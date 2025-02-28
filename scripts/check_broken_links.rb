#!/usr/bin/env ruby
# frozen_string_literal: true

# Script pour vérifier et corriger intelligemment les liens cassés dans la documentation
# Usage: ruby check_broken_links.rb [--fix] [--verbose] [--dir=path/to/check] [--normalize-folders]

require 'fileutils'
require 'pathname'
require 'json'
require 'set'
require 'tmpdir'

class BrokenLinkChecker
  DOCS_ROOT = File.expand_path('../../', __FILE__)
  MARKDOWN_PATTERN = '**/*.md'
  LINK_REGEX = /\[.*?\]\((.*?)\)/
  
  # Fichier de cache pour stocker la structure du projet
  CACHE_FILE = File.join(Dir.tmpdir, 'circographe-link-checker-cache.json')
  
  attr_reader :broken_links, :fixed_count, :project_structure, :section_map, :folder_issues

  def initialize(options = {})
    @fix_mode = options[:fix] || false
    @verbose = options[:verbose] || false
    @target_dir = options[:dir]
    @normalize_folders = options[:normalize_folders] || false
    @broken_links = {}
    @fixed_count = 0
    @file_exists_cache = {}
    @attempted_fixes = {}
    @project_structure = {}
    @all_markdown_files = []
    @section_map = {}
    @folder_issues = {}
    @renamed_folders = {}
    
    # Construction d'une carte des sections du projet pour mieux comprendre la hiérarchie
    @common_sections = {
      'requirements' => {
        '1_métier' => ['adhesion', 'cotisation', 'paiement', 'presence', 'roles', 'notification'],
        '2_specifications_techniques' => ['interfaces', 'api'],
        '3_user_stories' => [],
        '4_implementation' => ['rails']
      },
      'docs' => {
        'architecture' => ['diagrams', 'technical', 'templates'],
        'business' => ['regles', 'processes'],
        'utilisateur' => ['guides', 'images']
      }
    }
    
    # Règles de normalisation des noms de dossiers
    @folder_naming_rules = {
      # Pluriel -> singulier
      'adhesions' => 'adhesion',
      'paiements' => 'paiement',
      'cotisations' => 'cotisation',
      'utilisateurs' => 'roles',
      'notifications' => 'notification',
      'presences' => 'presence',
      
      # Variations d'orthographe
      'adhésions' => 'adhesion',
      'présences' => 'presence',
      'rôles' => 'roles',
      
      # Structure d'anciennes versions
      '1_logique_metier' => '1_métier'
    }
    
    # Charger le cache si existant
    load_cache if File.exist?(CACHE_FILE) && (Time.now - File.mtime(CACHE_FILE)) < 3600 # Cache valide pour 1 heure
  end

  def check_all_files
    # Cartographier la structure du projet si pas de cache valide
    build_project_structure unless @project_structure.any?
    
    # Vérifier et normaliser la structure des dossiers si demandé
    if @normalize_folders
      check_folder_structure
      normalize_folder_structure if @fix_mode
    end
    
    # Déterminer le répertoire cible
    target_path = @target_dir ? File.join(DOCS_ROOT, @target_dir) : DOCS_ROOT
    pattern = @target_dir ? File.join(@target_dir, MARKDOWN_PATTERN) : MARKDOWN_PATTERN
    
    # Vérifier les fichiers
    Dir.chdir(DOCS_ROOT) do
      Dir.glob(pattern).each do |file|
        next if file.include?('node_modules') || file.include?('vendor')
        check_file(file)
      end
    end
    
    # Sauvegarder le cache mis à jour
    save_cache
    
    print_results
  end

  private
  
  def load_cache
    puts "📂 Chargement du cache de la structure du projet..." if @verbose
    begin
      cache_data = JSON.parse(File.read(CACHE_FILE))
      @project_structure = cache_data['structure'] || {}
      @all_markdown_files = cache_data['files'] || []
      @section_map = cache_data['sections'] || {}
    rescue => e
      puts "⚠️ Erreur lors du chargement du cache: #{e.message}" if @verbose
      @project_structure = {}
      @all_markdown_files = []
      @section_map = {}
    end
  end
  
  def save_cache
    cache_data = {
      'structure' => @project_structure,
      'files' => @all_markdown_files,
      'sections' => @section_map,
      'renamed_folders' => @renamed_folders,
      'updated_at' => Time.now.to_s
    }
    
    File.write(CACHE_FILE, JSON.pretty_generate(cache_data))
    puts "💾 Cache de structure sauvegardé dans #{CACHE_FILE}" if @verbose
  end
  
  def build_project_structure
    puts "🔍 Analyse de la structure du projet..." if @verbose
    
    # Récupérer tous les fichiers Markdown
    Dir.chdir(DOCS_ROOT) do
      @all_markdown_files = Dir.glob(MARKDOWN_PATTERN).reject do |file|
        file.include?('node_modules') || file.include?('vendor')
      end
      
      # Construire une structure par domaine
      @all_markdown_files.each do |file|
        path_parts = file.split('/')
        current_level = @project_structure
        
        # Construire la hiérarchie
        path_parts.each_with_index do |part, index|
          is_file = (index == path_parts.size - 1)
          
          if is_file
            # Stocker les informations sur le fichier
            current_level[part] = {
              'type' => 'file',
              'path' => file,
              'title' => extract_title(file)
            }
          else
            current_level[part] ||= {}
            current_level = current_level[part]
          end
        end
        
        # Cartographier les sections dans le fichier
        map_file_sections(file)
      end
    end
    
    # Construire des mappings intelligents des sections et domaines
    build_section_mapping
    
    puts "✓ Structure du projet analysée: #{@all_markdown_files.size} fichiers Markdown identifiés" if @verbose
  end
  
  def check_folder_structure
    puts "🔍 Analyse de la structure des dossiers pour normalisation..." if @verbose
    
    # Récupérer tous les dossiers
    all_folders = Set.new
    @all_markdown_files.each do |file|
      path_parts = file.split('/')
      path_parts.pop # Enlever le nom du fichier
      
      # Ajouter tous les sous-dossiers
      current_path = ""
      path_parts.each do |part|
        current_path = current_path.empty? ? part : "#{current_path}/#{part}"
        all_folders.add(current_path)
      end
    end
    
    # Vérifier les noms de dossiers selon les règles de normalisation
    all_folders.each do |folder|
      folder_parts = folder.split('/')
      folder_name = folder_parts.last
      
      # Vérifier si le nom du dossier doit être normalisé
      if @folder_naming_rules.key?(folder_name)
        normalized_name = @folder_naming_rules[folder_name]
        parent_path = folder_parts[0..-2].join('/')
        normalized_path = parent_path.empty? ? normalized_name : "#{parent_path}/#{normalized_name}"
        
        @folder_issues[folder] = {
          current_name: folder_name,
          normalized_name: normalized_name,
          normalized_path: normalized_path
        }
        
        puts "📁 Dossier à normaliser: #{folder} → #{normalized_path}" if @verbose
      end
    end
    
    if @folder_issues.empty?
      puts "✅ Tous les dossiers suivent déjà les conventions de nommage!" if @verbose
    else
      puts "⚠️ Trouvé #{@folder_issues.size} dossier(s) à normaliser" if @verbose
    end
  end
  
  def normalize_folder_structure
    return if @folder_issues.empty?
    
    puts "🔄 Normalisation des dossiers..." if @verbose
    
    # Trier les dossiers par profondeur descendante (renommer d'abord les dossiers les plus profonds)
    sorted_folders = @folder_issues.keys.sort_by { |path| -path.count('/') }
    
    Dir.chdir(DOCS_ROOT) do
      sorted_folders.each do |folder|
        issue = @folder_issues[folder]
        
        # Vérifier si le dossier existe toujours (peut avoir été renommé par une opération précédente)
        next unless Dir.exist?(folder)
        
        # Vérifier si le dossier cible existe déjà
        if Dir.exist?(issue[:normalized_path])
          puts "⚠️ Le dossier cible existe déjà: #{issue[:normalized_path]}, fusion des contenus..." if @verbose
          
          # Déplacer tous les fichiers et sous-dossiers
          Dir.glob("#{folder}/**/*").each do |item|
            relative_path = item.sub("#{folder}/", '')
            target_path = File.join(issue[:normalized_path], relative_path)
            
            if File.directory?(item)
              FileUtils.mkdir_p(target_path) unless Dir.exist?(target_path)
            else
              FileUtils.mkdir_p(File.dirname(target_path)) unless Dir.exist?(File.dirname(target_path))
              FileUtils.mv(item, target_path) unless File.exist?(target_path)
            end
          end
          
          # Supprimer le dossier source s'il est vide
          if Dir.glob("#{folder}/*").empty?
            FileUtils.rmdir(folder)
            puts "🗑️  Suppression du dossier source vide: #{folder}" if @verbose
          end
        else
          # Renommer simplement le dossier
          FileUtils.mv(folder, issue[:normalized_path])
          puts "✅ Dossier renommé: #{folder} → #{issue[:normalized_path]}" if @verbose
        end
        
        # Enregistrer le renommage pour mettre à jour les liens
        @renamed_folders[folder] = issue[:normalized_path]
      end
    end
    
    # Mettre à jour la liste des fichiers Markdown après le renommage
    update_file_list_after_renaming
    
    puts "✅ Normalisation des dossiers terminée: #{@renamed_folders.size} dossier(s) renommé(s)" if @verbose
  end
  
  def update_file_list_after_renaming
    # Mettre à jour les chemins des fichiers après le renommage des dossiers
    updated_files = []
    
    @all_markdown_files.each do |file|
      updated_path = file
      
      @renamed_folders.each do |old_path, new_path|
        if file.start_with?("#{old_path}/")
          updated_path = file.sub("#{old_path}/", "#{new_path}/")
          break
        end
      end
      
      updated_files << updated_path
    end
    
    @all_markdown_files = updated_files
  end
  
  def map_file_sections(file)
    content = File.read(File.join(DOCS_ROOT, file))
    sections = extract_sections(content)
    
    @section_map[file] = {
      'sections' => sections,
      'keywords' => extract_keywords(content)
    }
  end
  
  def extract_title(file)
    begin
      content = File.read(File.join(DOCS_ROOT, file))
      first_line = content.lines.first&.strip
      if first_line && first_line.start_with?('#')
        return first_line.gsub(/^#+\s*/, '').strip
      end
    rescue => e
      # En cas d'erreur, utiliser le nom du fichier comme titre
    end
    
    File.basename(file, '.md').capitalize
  end
  
  def extract_sections(content)
    sections = []
    content.scan(/^(#+)\s+(.*?)$/m).each do |level, title|
      sections << {
        'level' => level.size,
        'title' => title.strip
      }
    end
    sections
  end
  
  def extract_keywords(content)
    # Extraire des mots-clés significatifs pour aider à la correspondance sémantique
    important_terms = Set.new(['adhésion', 'cotisation', 'paiement', 'présence', 
                              'rôle', 'notification', 'règle', 'spécification',
                              'technique', 'métier', 'architecture', 'API'])
    
    found_keywords = Set.new
    content.downcase.scan(/\b(\w{3,})\b/).flatten.each do |word|
      found_keywords.add(word) if important_terms.include?(word)
    end
    
    found_keywords.to_a
  end
  
  def build_section_mapping
    # Construire une cartographie avancée des sections pour faciliter la correspondance
    domains = {}
    
    # Analyser les fichiers par domaine métier
    @common_sections.each do |main_section, subsections|
      subsections.each do |subsection, domains_list|
        path_prefix = [main_section, subsection].join('/')
        
        # Identifier tous les fichiers dans ce domaine
        domain_files = @all_markdown_files.select { |f| f.start_with?(path_prefix) }
        
        domains_list.each do |domain|
          domain_path = [path_prefix, domain].join('/')
          relevant_files = domain_files.select { |f| f.start_with?(domain_path) }
          
          if relevant_files.any?
            domains[domain] = {
              'path_prefix' => domain_path,
              'files' => relevant_files,
              'index' => relevant_files.find { |f| f.end_with?('index.md') || f.end_with?('README.md') }
            }
          end
        end
      end
    end
    
    @domains_mapping = domains
  end

  def check_file(file)
    content = File.read(file)
    line_number = 0
    file_changed = false
    
    new_content = content.lines.map do |line|
      line_number += 1
      processed_line = line
      
      # Extraire tous les liens de la ligne
      line.scan(LINK_REGEX).flatten.each do |link|
        next if link.start_with?('http://', 'https://', 'mailto:', '#')
        
        # Vérifier si le lien doit être mis à jour à cause d'un renommage de dossier
        updated_link = update_link_for_renamed_folders(link)
        if updated_link != link
          processed_line = processed_line.gsub(link, updated_link)
          file_changed = true
          link = updated_link # Utiliser le lien mis à jour pour les vérifications suivantes
        end
        
        if broken_link?(link)
          @broken_links[file] ||= []
          @broken_links[file] << { line: line_number, link: link, original_line: line.strip }
          
          if @fix_mode
            fixed_line = fix_link(processed_line, link, file)
            if fixed_line != processed_line
              processed_line = fixed_line
              file_changed = true
              @fixed_count += 1
              @attempted_fixes["#{file}:#{line_number}"] = { 
                original: link, 
                fixed: extract_link_from_line(fixed_line) 
              }
            end
          end
        end
      end
      
      processed_line
    end
    
    if @fix_mode && file_changed
      File.write(file, new_content.join)
    end
  end
  
  def update_link_for_renamed_folders(link)
    updated_link = link
    
    @renamed_folders.each do |old_path, new_path|
      # Cas 1: Lien commence par l'ancien chemin
      if updated_link.start_with?("#{old_path}/")
        updated_link = updated_link.sub("#{old_path}/", "#{new_path}/")
      # Cas 2: Lien sans préfixe mais contient l'ancien chemin
      elsif updated_link.include?("/#{old_path}/")
        updated_link = updated_link.gsub("/#{old_path}/", "/#{new_path}/")
      end
    end
    
    updated_link
  end

  def extract_link_from_line(line)
    line.scan(LINK_REGEX).flatten.first || ""
  end

  def broken_link?(link)
    # Ignorer les ancres dans l'URL
    link = link.split('#').first
    
    # Vérifier si le lien contient des caractères interdits ou est vide
    return true if link.nil? || link.empty? || link.match?(/[\s<>|:"\\]/)
    
    # Cache pour les vérifications d'existence de fichier (performance)
    @file_exists_cache[link] ||= begin
      # Gestion des liens absolus vs relatifs
      if link.start_with?('/')
        target_path = File.join(DOCS_ROOT, link)
      else
        target_path = File.expand_path(link, DOCS_ROOT)
      end
      
      # Vérifier si le fichier existe
      !File.exist?(target_path) && !Dir.exist?(target_path)
    end
  end

  def fix_link(line, broken_link, current_file)
    # Extraire des informations sur le contexte du fichier actuel
    file_info = extract_file_context(current_file)
    
    # Stratégie 1: Corriger les chemins connus incorrects
    fixed_link = apply_known_path_corrections(broken_link)
    
    # Stratégie 2: Appliquer des corrections basées sur le contexte
    if broken_link?(fixed_link)
      fixed_link = apply_context_based_corrections(fixed_link, file_info)
    end
    
    # Stratégie 3: Recherche intelligente de fichiers similaires
    if broken_link?(fixed_link)
      similar_file = find_similar_file(fixed_link, file_info)
      fixed_link = similar_file if similar_file
    end
    
    # Stratégie 4: Déduction basée sur le nom de domaine métier
    if broken_link?(fixed_link) && broken_link.include?('/')
      domain_based_fix = apply_domain_based_corrections(broken_link, file_info)
      fixed_link = domain_based_fix if domain_based_fix && !broken_link?(domain_based_fix)
    end
    
    # Appliquer la correction uniquement si le lien a été amélioré
    if fixed_link != broken_link && (!broken_link?(fixed_link) || is_better_path(broken_link, fixed_link))
      return line.gsub(broken_link, fixed_link)
    end
    
    line
  end
  
  def extract_file_context(file_path)
    parts = file_path.split('/')
    
    # Déterminer le domaine métier si possible
    domain = nil
    @common_sections.each do |main_section, subsections|
      if parts.include?(main_section)
        main_index = parts.index(main_section)
        if main_index && parts.size > main_index + 1
          subsection = parts[main_index + 1]
          if subsections.key?(subsection) && parts.size > main_index + 2
            domain = parts[main_index + 2]
          end
        end
      end
    end
    
    {
      path: file_path,
      parts: parts,
      filename: File.basename(file_path),
      directory: File.dirname(file_path),
      domain: domain,
      is_index: file_path.end_with?('index.md') || file_path.end_with?('README.md'),
      sections: @section_map[file_path]&.dig('sections') || [],
      keywords: @section_map[file_path]&.dig('keywords') || []
    }
  end
  
  def apply_known_path_corrections(link)
    # Corrections courantes de chemins connus
    replacements = {
      # Migration des anciens chemins
      '/requirements/1_logique_metier/' => '/requirements/1_métier/',
      'adhesions/' => 'adhesion/',
      'paiements/' => 'paiement/',
      'cotisations/' => 'cotisation/',
      'utilisateurs/' => 'roles/',
      'notifications/' => 'notification/',
      'presences/' => 'presence/',
      
      # Migration des anciens noms de fichiers
      'systeme.md' => 'regles.md',
      'tarifs.md' => 'regles.md',
      'reglements.md' => 'regles.md',
      'types.md' => 'regles.md',
      
      # Correction des chemins absolus vs relatifs
      '/docs/' => '../docs/',
      '/requirements/' => '../requirements/',
      '../../../../../docs/' => '../docs/',
      '../../../../../requirements/' => '../requirements/',
      '../../../../docs/' => '../docs/',
      '../../../../requirements/' => '../requirements/',
      '../../../docs/' => '../docs/',
      '../../../requirements/' => '../requirements/',
      
      # Correction des doubles slash
      '//' => '/'
    }
    
    fixed_link = link.dup
    replacements.each do |old_pattern, new_pattern|
      fixed_link = fixed_link.gsub(old_pattern, new_pattern)
    end
    
    # Nettoyer les séquences de ../ excessives
    fixed_link = clean_relative_path(fixed_link)
    
    fixed_link
  end
  
  def clean_relative_path(path)
    # Convertir le chemin relatif en absolu puis de nouveau en relatif pour nettoyer
    return path unless path.include?('../')
    
    parts = path.split('/')
    clean_parts = []
    
    parts.each do |part|
      if part == '..'
        clean_parts.pop
      elsif part != '.'
        clean_parts << part
      end
    end
    
    clean_parts.join('/')
  end
  
  def apply_context_based_corrections(link, file_info)
    fixed_link = link.dup
    
    # Cas 1: liens relatifs dans les fichiers d'index des domaines métier
    if file_info[:is_index] && file_info[:parts].include?('1_métier')
      domain_part = file_info[:domain]
      
      if domain_part && link.include?(domain_part)
        # Corriger les références à des fichiers dans le même domaine
        if link.start_with?('/requirements/1_métier/')
          fixed_link = link.sub('/requirements/1_métier/', './')
        elsif link.start_with?('requirements/1_métier/')
          fixed_link = link.sub('requirements/1_métier/', './')
        end
      end
    end
    
    # Cas 2: liens entre domaines métier
    if file_info[:parts].include?('1_métier') && 
       (link.include?('/1_métier/') || link.include?('requirements/1_métier/'))
      
      # Si nous sommes dans un domaine et référençons un autre domaine
      if file_info[:domain] && !link.include?(file_info[:domain])
        @common_sections['requirements']['1_métier'].each do |domain|
          if link.include?(domain)
            if link.start_with?('requirements/1_métier/')
              fixed_link = link.sub('requirements/1_métier/', '../')
            elsif link.start_with?('/requirements/1_métier/')
              fixed_link = link.sub('/requirements/1_métier/', '../')
            end
          end
        end
      end
    end
    
    # Cas 3: liens vers des spécifications techniques
    if file_info[:parts].include?('1_métier') && 
       (link.include?('/2_specifications_techniques/') || link.include?('requirements/2_specifications_techniques/'))
      
      fixed_link = link.sub('requirements/2_specifications_techniques/', '../2_specifications_techniques/')
      fixed_link = fixed_link.sub('/requirements/2_specifications_techniques/', '../2_specifications_techniques/')
    end
    
    # Cas 4: liens vers des user stories
    if file_info[:parts].include?('1_métier') && 
       (link.include?('/3_user_stories/') || link.include?('requirements/3_user_stories/'))
      
      fixed_link = link.sub('requirements/3_user_stories/', '../3_user_stories/')
      fixed_link = fixed_link.sub('/requirements/3_user_stories/', '../3_user_stories/')
    end
    
    # Cas 5: Liens entre l'architecture et les domaines métier
    if file_info[:parts].include?('architecture') && 
       (link.include?('/1_métier/') || link.include?('requirements/1_métier/'))
      
      fixed_link = link.sub('requirements/1_métier/', '../../requirements/1_métier/')
      fixed_link = fixed_link.sub('/requirements/1_métier/', '../../requirements/1_métier/')
    end
    
    clean_relative_path(fixed_link)
  end
  
  def apply_domain_based_corrections(link, file_info)
    # Essayer de déduire le domaine à partir du lien
    link_parts = link.split('/')
    domain = nil
    
    # Rechercher un domaine métier connu dans les parties du lien
    @common_sections['requirements']['1_métier'].each do |d|
      if link_parts.include?(d)
        domain = d
        break
      end
    end
    
    return link unless domain
    
    # Construire un chemin relatif correct basé sur le domaine
    if file_info[:domain] == domain
      # Même domaine - chemin relatif local
      local_path = link_parts.last
      return "./#{local_path}"
    else
      # Domaine différent - chemin relatif entre domaines
      if file_info[:parts].include?('1_métier')
        target_file = link_parts.last
        return "../#{domain}/#{target_file}"
      end
    end
    
    link
  end
  
  def is_better_path(old_path, new_path)
    # Un chemin est considéré meilleur s'il a moins de composants '..' ou est plus susceptible d'être valide
    old_path_components = old_path.scan(/\.\./).count
    new_path_components = new_path.scan(/\.\./).count
    
    return true if new_path_components < old_path_components
    
    # Préférer les chemins avec une structure correcte
    better_structure = [
      # Structures préférées pour l'architecture
      ['/docs/architecture/', new_path.include?('/docs/architecture/')],
      ['/docs/business/', new_path.include?('/docs/business/')],
      ['/docs/utilisateur/', new_path.include?('/docs/utilisateur/')],
      
      # Structures préférées pour les requirements
      ['/requirements/1_métier/', new_path.include?('/requirements/1_métier/')],
      ['/requirements/2_specifications_techniques/', new_path.include?('/requirements/2_specifications_techniques/')],
      ['../1_métier/', new_path.include?('../1_métier/')]
    ]
    
    better_structure.any? { |pattern, is_included| old_path.include?(pattern) && is_included }
  end
  
  def find_similar_file(broken_link, file_info)
    # Extraire le nom de fichier du lien cassé
    filename = File.basename(broken_link)
    
    # Si le fichier contient un chemin de domaine, essayer de trouver le domaine correct
    domain = nil
    @common_sections['requirements']['1_métier'].each do |d|
      if broken_link.include?(d)
        domain = d
        break
      end
    end
    
    # Rechercher les fichiers avec des noms similaires
    similar_files = []
    
    # Recherche 1: Correspondance exacte du nom de fichier
    @all_markdown_files.each do |file|
      if File.basename(file) == filename
        # Si un domaine est spécifié, donner la priorité aux fichiers de ce domaine
        if domain && file.include?("/#{domain}/")
          return file
        end
        similar_files << file
      end
    end
    
    # Recherche 2: Correspondance partielle du nom de fichier
    if similar_files.empty?
      @all_markdown_files.each do |file|
        if File.basename(file).include?(filename.split('.').first)
          similar_files << file
        end
      end
    end
    
    # Recherche 3: Correspondance sémantique basée sur les mots-clés
    if similar_files.empty? && file_info[:keywords].any?
      best_match = nil
      best_score = 0
      
      @all_markdown_files.each do |file|
        next unless @section_map[file] && @section_map[file]['keywords']
        
        # Calculer un score de correspondance basé sur les mots-clés partagés
        shared_keywords = file_info[:keywords] & @section_map[file]['keywords']
        score = shared_keywords.size
        
        if score > best_score
          best_score = score
          best_match = file
        end
      end
      
      return best_match if best_score > 0
    end
    
    return nil if similar_files.empty?
    
    # Retourner le fichier le plus similaire en fonction de la distance d'édition
    similar_files.min_by { |file| levenshtein_distance(filename, File.basename(file)) }
  end
  
  def levenshtein_distance(s, t)
    m = s.length
    n = t.length
    
    return m if n == 0
    return n if m == 0
    
    d = Array.new(m+1) { Array.new(n+1) }
    
    (0..m).each { |i| d[i][0] = i }
    (0..n).each { |j| d[0][j] = j }
    
    (1..n).each do |j|
      (1..m).each do |i|
        d[i][j] = if s[i-1] == t[j-1]
                    d[i-1][j-1]
                  else
                    [d[i-1][j] + 1, d[i][j-1] + 1, d[i-1][j-1] + 1].min
                  end
      end
    end
    
    d[m][n]
  end

  def print_results
    # Afficher les résultats de la normalisation des dossiers
    if @normalize_folders && !@folder_issues.empty?
      puts "\n📁 Rapport de normalisation des dossiers:"
      
      if @fix_mode
        puts "✅ #{@renamed_folders.size} dossier(s) ont été normalisés:"
        @renamed_folders.each do |old_path, new_path|
          puts "  - #{old_path} → #{new_path}"
        end
      else
        puts "⚠️ #{@folder_issues.size} dossier(s) devraient être normalisés:"
        @folder_issues.each do |folder, issue|
          puts "  - #{folder} → #{issue[:normalized_path]}"
        end
        
        puts "\n💡 Exécutez avec --fix pour normaliser automatiquement les dossiers"
      end
      
      puts "\n"
    end
    
    # Afficher les résultats des liens cassés
    if @broken_links.empty?
      puts "✅ Aucun lien cassé trouvé!"
    else
      total_links = @broken_links.values.flatten.size
      
      puts "❌ Trouvé #{total_links} liens cassés dans #{@broken_links.size} fichiers:"
      
      @broken_links.each do |file, links|
        puts "\n📄 #{file}:"
        links.each do |link_info|
          puts "  - Ligne #{link_info[:line]}: [#{link_info[:link]}] dans '#{link_info[:original_line]}'"
          
          if @fix_mode
            fix_info = @attempted_fixes["#{file}:#{link_info[:line]}"]
            if fix_info
              puts "    ↳ Correction tentée: [#{fix_info[:original]}] → [#{fix_info[:fixed]}]"
            else
              puts "    ↳ Impossible de corriger automatiquement"
              suggest_fix(link_info[:link], file)
            end
          else
            suggest_fix(link_info[:link], file)
          end
        end
      end
      
      if @fix_mode
        success_rate = (@fixed_count.to_f / total_links * 100).round(2)
        puts "\n🔧 #{@fixed_count} liens corrigés automatiquement (#{success_rate}% de réussite)."
        puts "   Veuillez vérifier les modifications et corriger manuellement les #{total_links - @fixed_count} liens restants."
      else
        puts "\n💡 Exécutez avec --fix pour tenter des corrections automatiques: ruby check_broken_links.rb --fix"
        puts "   Pour un mode détaillé: ruby check_broken_links.rb --fix --verbose"
        puts "   Pour vérifier un répertoire spécifique: ruby check_broken_links.rb --fix --dir=requirements/1_métier"
        puts "   Pour normaliser les noms de dossiers: ruby check_broken_links.rb --fix --normalize-folders"
      end
    end
  end

  def suggest_fix(broken_link, current_file)
    # Extraire le contexte du fichier actuel
    file_info = extract_file_context(current_file)
    
    # Appliquer toutes les stratégies de correction
    fixed_link = apply_known_path_corrections(broken_link)
    
    if broken_link?(fixed_link)
      fixed_link = apply_context_based_corrections(fixed_link, file_info)
    end
    
    if broken_link?(fixed_link)
      similar_file = find_similar_file(fixed_link, file_info)
      fixed_link = similar_file if similar_file
    end
    
    if broken_link?(fixed_link) && broken_link.include?('/')
      domain_based_fix = apply_domain_based_corrections(broken_link, file_info)
      fixed_link = domain_based_fix if domain_based_fix && !broken_link?(domain_based_fix)
    end
    
    if fixed_link != broken_link && !broken_link?(fixed_link)
      puts "    ↳ Suggestion: #{fixed_link}"
    end
  end
end

# Exécution principale
options = {
  fix: ARGV.include?('--fix'),
  verbose: ARGV.include?('--verbose'),
  normalize_folders: ARGV.include?('--normalize-folders')
}

# Traiter les arguments avec des valeurs
ARGV.each do |arg|
  if arg.start_with?('--dir=')
    options[:dir] = arg.split('=')[1]
  end
end

checker = BrokenLinkChecker.new(options)
checker.check_all_files 