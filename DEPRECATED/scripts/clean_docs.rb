#!/usr/bin/env ruby
# frozen_string_literal: true

# Script d'audit et de nettoyage de la documentation
# Usage: ruby clean_docs.rb [--analyze] [--remove-empty] [--archive] [--interactive]

require 'fileutils'
require 'pathname'
require 'json'
require 'set'
require 'date'
require 'digest'

class DocumentationCleaner
  DOCS_ROOT = File.expand_path('../../', __FILE__)
  MARKDOWN_PATTERN = '**/*.md'
  LINK_REGEX = /\[.*?\]\((.*?)\)/
  IMAGE_REGEX = /!\[.*?\]\((.*?)\)/
  
  # Dossier pour archiver les fichiers obsolètes
  ARCHIVE_DIR = File.join(DOCS_ROOT, 'archive', Date.today.strftime('%Y%m%d'))
  
  # Age en jours à partir duquel un fichier est considéré obsolète s'il n'est pas référencé
  OBSOLETE_THRESHOLD_DAYS = 90
  
  # Mots-clés indiquant un contenu obsolète
  OBSOLETE_KEYWORDS = [
    'deprecated',
    'obsolète',
    'à supprimer',
    'ne pas utiliser',
    'ancien',
    'remplacé par',
    'TODO',
    'FIXME',
    'draft',
    'brouillon'
  ]
  
  attr_reader :empty_dirs, :unreferenced_files, :obsolete_files, :duplicate_files, :archive_files

  def initialize(options = {})
    @analyze_only = options[:analyze] || false
    @remove_empty = options[:remove_empty] || false
    @archive_mode = options[:archive] || false
    @interactive = options[:interactive] || false
    
    @empty_dirs = []
    @unreferenced_files = []
    @obsolete_files = []
    @duplicate_files = {}
    @archive_files = []
    
    # Structures de données pour l'analyse
    @all_files = []
    @all_dirs = Set.new
    @file_references = {}
    @file_content_hashes = {}
    
    # Marquer tous les fichiers comme non référencés initialement
    @referenced_files = Set.new
  end

  def run
    puts "🔍 Analyse de la documentation..."
    
    # Étape 1: Collecter tous les fichiers
    collect_files
    
    # Étape 2: Analyser les références entre fichiers
    analyze_references
    
    # Étape 3: Identifier les fichiers non référencés
    identify_unreferenced_files
    
    # Étape 4: Détecter les fichiers obsolètes
    detect_obsolete_files
    
    # Étape 5: Trouver les contenus dupliqués
    find_duplicate_content
    
    # Étape 6: Identifier les dossiers vides
    identify_empty_directories
    
    # Afficher le rapport
    print_report
    
    # Effectuer le nettoyage si demandé
    clean_up unless @analyze_only
  end

  private

  def collect_files
    Dir.chdir(DOCS_ROOT) do
      @all_files = Dir.glob(MARKDOWN_PATTERN).reject do |file|
        file.include?('node_modules') || file.include?('vendor') || file.start_with?('archive/')
      end
      
      # Initialiser chaque fichier comme non référencé
      @all_files.each do |file|
        @file_references[file] = []
      end
      
      # Collecter tous les dossiers
      @all_files.each do |file|
        parts = file.split('/')
        parts.pop # Enlever le nom du fichier
        
        path = ""
        parts.each do |part|
          path = path.empty? ? part : "#{path}/#{part}"
          @all_dirs.add(path)
        end
      end
    end
    
    puts "✓ Collecté #{@all_files.size} fichiers et #{@all_dirs.size} dossiers"
  end

  def analyze_references
    Dir.chdir(DOCS_ROOT) do
      @all_files.each do |file|
        begin
          content = File.read(file)
          
          # Calculer un hash du contenu pour la détection de doublons
          @file_content_hashes[file] = Digest::MD5.hexdigest(content)
          
          # Extraire les liens markdown
          links = content.scan(LINK_REGEX).flatten + content.scan(IMAGE_REGEX).flatten
          
          links.each do |link|
            # Ignorer liens externes, ancres et vides
            next if link.nil? || link.empty? || link.match?(/^(https?:|mailto:|#)/)
            
            # Résoudre le chemin relatif
            target_file = resolve_relative_path(link, file)
            
            if target_file && @file_references.key?(target_file)
              # Marquer le fichier cible comme référencé
              @referenced_files.add(target_file)
              # Enregistrer la référence
              @file_references[target_file] << file
            end
          end
        rescue => e
          puts "⚠️ Erreur lors de l'analyse du fichier #{file}: #{e.message}"
        end
      end
    end
    
    puts "✓ Analyse des références terminée"
  end

  def resolve_relative_path(link, source_file)
    # Supprimer les ancres éventuelles
    link = link.split('#').first
    
    # Gérer les chemins absolus (commencent par /)
    if link.start_with?('/')
      clean_link = link.sub(/^\//, '')
      return clean_link if @all_files.include?(clean_link)
      return nil
    end
    
    # Gérer les chemins relatifs
    source_dir = File.dirname(source_file)
    target_path = File.expand_path(link, source_dir)
    
    # Rendre le chemin relatif par rapport à DOCS_ROOT
    target_path = Pathname.new(target_path).relative_path_from(Pathname.new(DOCS_ROOT)).to_s
    
    return target_path if @all_files.include?(target_path)
    
    # Essayer avec .md ajouté si nécessaire
    target_path_md = target_path.end_with?('.md') ? target_path : "#{target_path}.md"
    return target_path_md if @all_files.include?(target_path_md)
    
    nil
  end

  def identify_unreferenced_files
    @unreferenced_files = @all_files.reject do |file|
      # Considérer les README et index comme toujours "référencés"
      file.end_with?('README.md') || file.end_with?('index.md') || @referenced_files.include?(file)
    end
    
    puts "✓ Identifié #{@unreferenced_files.size} fichiers non référencés"
  end

  def detect_obsolete_files
    Dir.chdir(DOCS_ROOT) do
      @all_files.each do |file|
        begin
          # Vérifier l'âge du fichier
          file_age_days = (Date.today - Date.parse(File.mtime(file).to_s)).to_i
          
          # Vérifier le contenu pour les mots-clés de contenu obsolète
          content = File.read(file)
          has_obsolete_keywords = OBSOLETE_KEYWORDS.any? { |keyword| content.downcase.include?(keyword.downcase) }
          
          # Un fichier est considéré obsolète s'il:
          # 1. Contient des mots-clés indiquant l'obsolescence OU
          # 2. Est non référencé ET est très ancien
          if has_obsolete_keywords || (@unreferenced_files.include?(file) && file_age_days > OBSOLETE_THRESHOLD_DAYS)
            @obsolete_files << {
              file: file,
              age_days: file_age_days,
              has_keywords: has_obsolete_keywords,
              size: File.size(file)
            }
          end
        rescue => e
          puts "⚠️ Erreur lors de l'analyse d'obsolescence de #{file}: #{e.message}"
        end
      end
    end
    
    puts "✓ Identifié #{@obsolete_files.size} fichiers obsolètes"
  end

  def find_duplicate_content
    # Regrouper les fichiers par hash de contenu
    hashes = {}
    @file_content_hashes.each do |file, hash|
      hashes[hash] ||= []
      hashes[hash] << file
    end
    
    # Conserver uniquement les groupes avec plus d'un fichier (doublons)
    @duplicate_files = hashes.select { |_, files| files.size > 1 }
    
    puts "✓ Identifié #{@duplicate_files.size} groupes de fichiers dupliqués"
  end

  def identify_empty_directories
    Dir.chdir(DOCS_ROOT) do
      @all_dirs.each do |dir|
        # Vérifier si le dossier existe (pourrait avoir été supprimé par une opération précédente)
        next unless Dir.exist?(dir)
        
        # Un dossier est vide s'il ne contient aucun fichier ou dossier
        # ou s'il ne contient que des sous-dossiers vides
        is_empty = Dir.glob("#{dir}/*").empty?
        
        # Vérifier aussi les dossiers qui ne contiennent que des fichiers obsolètes
        if !is_empty
          files_in_dir = Dir.glob("#{dir}/**/*").reject { |f| File.directory?(f) }
          obsolete_files_in_dir = @obsolete_files.map { |f| f[:file] }
          
          # Si tous les fichiers du dossier sont obsolètes, considérer le dossier comme "vide"
          is_effectively_empty = files_in_dir.all? { |f| obsolete_files_in_dir.include?(f.sub("./", "")) }
          is_empty = is_empty || (is_effectively_empty && !files_in_dir.empty?)
        end
        
        @empty_dirs << dir if is_empty
      end
    end
    
    puts "✓ Identifié #{@empty_dirs.size} dossiers vides"
  end

  def print_report
    puts "\n📊 RAPPORT D'AUDIT DE LA DOCUMENTATION 📊"
    puts "==========================================\n"
    
    puts "📂 DOSSIERS VIDES (#{@empty_dirs.size})"
    if @empty_dirs.empty?
      puts "  Aucun dossier vide trouvé."
    else
      @empty_dirs.sort.each do |dir|
        puts "  - #{dir}"
      end
    end
    
    puts "\n📄 FICHIERS NON RÉFÉRENCÉS (#{@unreferenced_files.size})"
    if @unreferenced_files.empty?
      puts "  Tous les fichiers sont référencés par d'autres documents."
    else
      @unreferenced_files.sort.each do |file|
        puts "  - #{file}"
      end
    end
    
    puts "\n🕰️ FICHIERS OBSOLÈTES (#{@obsolete_files.size})"
    if @obsolete_files.empty?
      puts "  Aucun fichier obsolète détecté."
    else
      @obsolete_files.sort_by { |f| f[:age_days] }.reverse.each do |file_info|
        reason = file_info[:has_keywords] ? "contient des mots-clés obsolètes" : "non référencé depuis #{file_info[:age_days]} jours"
        puts "  - #{file_info[:file]} (#{reason}, #{format_size(file_info[:size])})"
      end
    end
    
    puts "\n🔄 CONTENUS DUPLIQUÉS (#{@duplicate_files.size} groupes)"
    if @duplicate_files.empty?
      puts "  Aucun contenu dupliqué détecté."
    else
      @duplicate_files.each_with_index do |(hash, files), index|
        puts "  Groupe #{index + 1}: #{files.size} fichiers identiques (#{format_size(File.size(File.join(DOCS_ROOT, files.first)))})"
        files.sort.each do |file|
          puts "   - #{file}"
        end
        puts ""
      end
    end
    
    puts "\n💡 RECOMMANDATIONS"
    if @empty_dirs.empty? && @obsolete_files.empty? && @unreferenced_files.empty? && @duplicate_files.empty?
      puts "  La documentation est bien maintenue ! Aucune action n'est nécessaire."
    else
      puts "  1. Supprimer les #{@empty_dirs.size} dossiers vides" if @empty_dirs.any?
      puts "  2. Archiver les #{@obsolete_files.size} fichiers obsolètes" if @obsolete_files.any?
      puts "  3. Vérifier les #{@unreferenced_files.size} fichiers non référencés" if @unreferenced_files.any?
      puts "  4. Dédupliquer les #{@duplicate_files.size} groupes de fichiers identiques" if @duplicate_files.any?
      
      puts "\n  Pour exécuter le nettoyage automatique:"
      puts "  - ruby clean_docs.rb --remove-empty    # Supprimer les dossiers vides"
      puts "  - ruby clean_docs.rb --archive         # Archiver les fichiers obsolètes"
      puts "  - ruby clean_docs.rb --interactive     # Nettoyage interactif"
    end
    
    puts "\n==========================================\n"
  end

  def clean_up
    actions_performed = false
    
    # Créer le dossier d'archive si nécessaire
    if @archive_mode && (@obsolete_files.any? || @unreferenced_files.any? || @duplicate_files.any?)
      FileUtils.mkdir_p(ARCHIVE_DIR) unless Dir.exist?(ARCHIVE_DIR)
    end
    
    # 1. Archiver ou supprimer les fichiers obsolètes
    if @obsolete_files.any?
      @obsolete_files.each do |file_info|
        file = file_info[:file]
        if should_process_file?(file, "archiver", file_info[:has_keywords] ? "obsolète" : "non référencé depuis #{file_info[:age_days]} jours")
          if @archive_mode
            archive_file(file)
          else
            delete_file(file)
          end
          actions_performed = true
        end
      end
    end
    
    # 2. Dédupliquer les contenus identiques
    if @duplicate_files.any?
      @duplicate_files.each_with_index do |(hash, files), index|
        puts "\nGroupe de doublons #{index + 1}:"
        files.sort.each_with_index do |file, file_index|
          puts "  #{file_index + 1}. #{file}"
        end
        
        if @interactive
          puts "\nQuel fichier conserver? (numéro, 'a' pour archiver tout sauf le premier, 's' pour ignorer): "
          choice = gets.chomp
          
          if choice.downcase == 'a'
            # Conserver le premier, archiver les autres
            to_keep = files.first
            puts "Conservation de #{to_keep}, archivage des autres..."
            
            files.drop(1).each do |file|
              if @archive_mode
                archive_file(file)
              else
                delete_file(file)
              end
            end
            actions_performed = true
          elsif choice.downcase == 's'
            puts "Groupe ignoré."
          elsif choice.to_i.between?(1, files.size)
            # Conserver le fichier choisi, archiver les autres
            to_keep = files[choice.to_i - 1]
            puts "Conservation de #{to_keep}, archivage des autres..."
            
            files.reject { |f| f == to_keep }.each do |file|
              if @archive_mode
                archive_file(file)
              else
                delete_file(file)
              end
            end
            actions_performed = true
          else
            puts "Choix invalide, groupe ignoré."
          end
        else
          # En mode non interactif, conserver le premier fichier
          to_keep = files.first
          puts "Conservation automatique de #{to_keep}, traitement des autres..."
          
          files.drop(1).each do |file|
            if @archive_mode
              archive_file(file)
            else
              delete_file(file)
            end
          end
          actions_performed = true
        end
      end
    end
    
    # 3. Supprimer les dossiers vides
    if @remove_empty && @empty_dirs.any?
      # Trier les dossiers par profondeur (supprimer d'abord les plus profonds)
      @empty_dirs.sort_by { |dir| -dir.count('/') }.each do |dir|
        if should_process_file?(dir, "supprimer", "dossier vide")
          begin
            Dir.rmdir(File.join(DOCS_ROOT, dir))
            puts "✅ Dossier supprimé: #{dir}"
            actions_performed = true
          rescue => e
            puts "❌ Échec de la suppression du dossier #{dir}: #{e.message}"
          end
        end
      end
    end
    
    # Confirmation finale
    if actions_performed
      puts "\n✅ Nettoyage terminé!"
      if @archive_mode && @archive_files.any?
        puts "📦 #{@archive_files.size} fichiers archivés dans #{ARCHIVE_DIR}"
      end
    else
      puts "\nℹ️ Aucune action de nettoyage effectuée."
    end
  end

  def should_process_file?(file, action, reason)
    return true unless @interactive
    
    puts "\nFichier: #{file}"
    puts "Raison: #{reason}"
    puts "Voulez-vous #{action} ce fichier? (o/n): "
    choice = gets.chomp.downcase
    choice == 'o' || choice == 'oui' || choice == 'y' || choice == 'yes'
  end

  def archive_file(file)
    source_path = File.join(DOCS_ROOT, file)
    archive_path = File.join(ARCHIVE_DIR, file)
    
    # Créer le répertoire de destination
    FileUtils.mkdir_p(File.dirname(archive_path))
    
    begin
      FileUtils.mv(source_path, archive_path)
      @archive_files << file
      puts "📦 Fichier archivé: #{file} → #{archive_path.sub(DOCS_ROOT, '')}"
    rescue => e
      puts "❌ Échec de l'archivage du fichier #{file}: #{e.message}"
    end
  end

  def delete_file(file)
    begin
      FileUtils.rm(File.join(DOCS_ROOT, file))
      puts "🗑️ Fichier supprimé: #{file}"
    rescue => e
      puts "❌ Échec de la suppression du fichier #{file}: #{e.message}"
    end
  end

  def format_size(size_in_bytes)
    units = ['B', 'KB', 'MB', 'GB']
    size = size_in_bytes.to_f
    unit_index = 0
    
    while size > 1024 && unit_index < units.size - 1
      size /= 1024
      unit_index += 1
    end
    
    "#{size.round(1)} #{units[unit_index]}"
  end
end

# Exécution principale
options = {
  analyze: !ARGV.include?('--remove-empty') && !ARGV.include?('--archive'),
  remove_empty: ARGV.include?('--remove-empty'),
  archive: ARGV.include?('--archive'),
  interactive: ARGV.include?('--interactive')
}

cleaner = DocumentationCleaner.new(options)
cleaner.run 