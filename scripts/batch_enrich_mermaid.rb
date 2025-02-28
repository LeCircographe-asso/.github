#!/usr/bin/env ruby
# frozen_string_literal: true

# Script pour enrichir automatiquement plusieurs fichiers avec des diagrammes Mermaid
# Usage: ruby batch_enrich_mermaid.rb [--limit=10] [--type=flowchart|stateDiagram|classDiagram|sequenceDiagram]

require_relative 'enrich_with_mermaid'

class BatchMermaidEnricher
  DOCS_ROOT = File.expand_path('../../', __FILE__)
  MARKDOWN_PATTERN = '**/*.md'
  
  attr_reader :enriched_files, :limit, :diagram_type
  
  def initialize(limit = nil, diagram_type = nil)
    @limit = limit ? limit.to_i : nil
    @diagram_type = diagram_type
    @enriched_files = []
  end
  
  def enrich_batch
    files = find_candidate_files
    
    if files.empty?
      puts "❌ Aucun fichier candidat trouvé pour l'enrichissement"
      return
    end
    
    puts "🔍 Trouvé #{files.size} fichiers candidats pour l'enrichissement"
    
    # Limiter le nombre de fichiers à traiter si nécessaire
    files = files.first(@limit) if @limit
    
    files.each do |file|
      puts "\n📄 Traitement du fichier: #{file}"
      
      begin
        enricher = MermaidEnricher.new(file, @diagram_type)
        if enricher.enrich
          @enriched_files << file
        end
      rescue => e
        puts "❌ Erreur lors de l'enrichissement du fichier #{file}: #{e.message}"
      end
    end
    
    print_summary
  end
  
  private
  
  def find_candidate_files
    candidate_files = []
    
    Dir.chdir(DOCS_ROOT) do
      Dir.glob(MARKDOWN_PATTERN).each do |file|
        next if file.include?('node_modules') || file.include?('vendor')
        
        # Vérifier si le fichier contient déjà un diagramme Mermaid
        content = File.read(file)
        has_mermaid = content.include?('```mermaid')
        
        # Si le fichier a déjà un diagramme Mermaid, on le saute sauf si on force un type spécifique
        next if has_mermaid && @diagram_type.nil?
        
        # Vérifier si le fichier contient des mots-clés qui suggèrent qu'un diagramme pourrait être utile
        if file_needs_diagram?(content)
          candidate_files << file
        end
      end
    end
    
    candidate_files
  end
  
  def file_needs_diagram?(content)
    # Mots-clés qui suggèrent qu'un diagramme pourrait être utile
    keywords = {
      'flowchart' => ['flux', 'processus', 'workflow', 'étapes', 'cycle', 'flow'],
      'stateDiagram' => ['état', 'statut', 'transition', 'state', 'status'],
      'classDiagram' => ['relation', 'dépendance', 'lien', 'association', 'dependency', 'classe', 'class'],
      'sequenceDiagram' => ['séquence', 'interaction', 'communication', 'sequence']
    }
    
    # Si un type de diagramme spécifique est demandé, vérifier seulement les mots-clés correspondants
    if @diagram_type
      keywords[@diagram_type].any? { |keyword| content.downcase.include?(keyword) }
    else
      # Sinon, vérifier tous les mots-clés
      keywords.values.flatten.any? { |keyword| content.downcase.include?(keyword) }
    end
  end
  
  def print_summary
    if @enriched_files.empty?
      puts "\n❌ Aucun fichier n'a été enrichi"
    else
      puts "\n✅ #{@enriched_files.size} fichiers ont été enrichis avec des diagrammes Mermaid:"
      
      @enriched_files.each do |file|
        puts "  - #{file}"
      end
    end
  end
end

# Main execution
limit = nil
diagram_type = nil

ARGV.each do |arg|
  if arg.start_with?('--limit=')
    limit = arg.split('=')[1]
  elsif arg.start_with?('--type=')
    diagram_type = arg.split('=')[1]
    unless MermaidEnricher::DIAGRAM_TYPES.include?(diagram_type)
      puts "Type de diagramme non reconnu: #{diagram_type}"
      puts "Types disponibles: #{MermaidEnricher::DIAGRAM_TYPES.join(', ')}"
      exit 1
    end
  end
end

enricher = BatchMermaidEnricher.new(limit, diagram_type)
enricher.enrich_batch 