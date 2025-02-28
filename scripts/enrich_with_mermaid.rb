#!/usr/bin/env ruby
# frozen_string_literal: true

# Script pour enrichir automatiquement un fichier de documentation avec un diagramme Mermaid
# Usage: ruby enrich_with_mermaid.rb <file_path> [--type=flowchart|stateDiagram|classDiagram|sequenceDiagram]

require 'fileutils'

class MermaidEnricher
  DIAGRAM_TYPES = ['flowchart', 'stateDiagram', 'classDiagram', 'sequenceDiagram']
  
  attr_reader :file_path, :diagram_type, :content, :sections
  
  def initialize(file_path, diagram_type = nil)
    @file_path = file_path
    @diagram_type = diagram_type || detect_diagram_type
    @content = File.read(file_path)
    @sections = extract_sections
  end
  
  def enrich
    if @sections.empty?
      puts "❌ Aucune section trouvée dans le fichier #{@file_path}"
      return false
    end
    
    # Trouver la section la plus appropriée pour ajouter un diagramme
    section = find_best_section
    
    if section.nil?
      puts "❌ Aucune section appropriée trouvée pour ajouter un diagramme #{@diagram_type}"
      return false
    end
    
    # Générer le diagramme
    diagram = generate_diagram(section)
    
    # Insérer le diagramme dans le fichier
    insert_diagram(section, diagram)
    
    puts "✅ Diagramme #{@diagram_type} ajouté à la section '#{section[:title]}' dans le fichier #{@file_path}"
    true
  end
  
  private
  
  def detect_diagram_type
    # Détecter le type de diagramme le plus approprié en fonction du contenu du fichier
    keywords = {
      'flowchart' => ['flux', 'processus', 'workflow', 'étapes', 'cycle', 'flow'],
      'stateDiagram' => ['état', 'statut', 'transition', 'state', 'status'],
      'classDiagram' => ['relation', 'dépendance', 'lien', 'association', 'dependency'],
      'sequenceDiagram' => ['séquence', 'interaction', 'communication', 'sequence']
    }
    
    counts = Hash.new(0)
    
    keywords.each do |type, words|
      words.each do |word|
        counts[type] += @content.downcase.scan(/#{word}/).count
      end
    end
    
    # Retourner le type avec le plus d'occurrences
    counts.max_by { |_, count| count }&.first || 'flowchart'
  end
  
  def extract_sections
    sections = []
    current_section = { title: "Document", content: "", start_line: 0, end_line: 0 }
    line_number = 0
    
    @content.each_line do |line|
      line_number += 1
      
      # Détecter les titres de section (# Titre, ## Sous-titre, etc.)
      if line.match(/^#+\s+(.+)$/)
        # Sauvegarder la section précédente si elle n'est pas vide
        if !current_section[:content].strip.empty?
          current_section[:end_line] = line_number - 1
          sections << current_section
        end
        
        # Commencer une nouvelle section
        current_section = {
          title: $1.strip,
          content: "",
          start_line: line_number,
          end_line: line_number
        }
      else
        # Ajouter la ligne au contenu de la section courante
        current_section[:content] += line
      end
    end
    
    # Ajouter la dernière section
    if !current_section[:content].strip.empty?
      current_section[:end_line] = line_number
      sections << current_section
    end
    
    sections
  end
  
  def find_best_section
    # Trouver la section la plus appropriée pour ajouter un diagramme
    # en fonction du type de diagramme et du contenu de la section
    
    # Vérifier si le fichier contient déjà un diagramme Mermaid du même type
    has_diagram = @content.include?("```mermaid\n#{@diagram_type}")
    
    if has_diagram
      puts "⚠️ Le fichier contient déjà un diagramme #{@diagram_type}"
    end
    
    # Mots-clés spécifiques à chaque type de diagramme
    keywords = {
      'flowchart' => ['flux', 'processus', 'workflow', 'étapes', 'cycle', 'flow'],
      'stateDiagram' => ['état', 'statut', 'transition', 'state', 'status'],
      'classDiagram' => ['relation', 'dépendance', 'lien', 'association', 'dependency', 'classe', 'class'],
      'sequenceDiagram' => ['séquence', 'interaction', 'communication', 'sequence']
    }
    
    # Calculer un score pour chaque section
    section_scores = @sections.map do |section|
      text = "#{section[:title]} #{section[:content]}".downcase
      
      # Calculer le score en fonction des mots-clés
      score = 0
      keywords[@diagram_type].each do |keyword|
        score += text.scan(/#{keyword}/).count * 2
      end
      
      # Bonus pour les sections qui semblent être des descriptions de processus ou d'états
      if @diagram_type == 'flowchart' && text.include?('étape')
        score += 5
      elsif @diagram_type == 'stateDiagram' && text.include?('état')
        score += 5
      elsif @diagram_type == 'classDiagram' && (text.include?('classe') || text.include?('model'))
        score += 5
      elsif @diagram_type == 'sequenceDiagram' && text.include?('acteur')
        score += 5
      end
      
      # Pénalité si la section contient déjà un diagramme
      if section[:content].include?('```mermaid')
        score -= 10
      end
      
      [section, score]
    end
    
    # Trier les sections par score décroissant
    section_scores.sort_by { |_, score| -score }.first&.first
  end
  
  def generate_diagram(section)
    case @diagram_type
    when 'flowchart'
      generate_flowchart(section)
    when 'stateDiagram'
      generate_state_diagram(section)
    when 'classDiagram'
      generate_class_diagram(section)
    when 'sequenceDiagram'
      generate_sequence_diagram(section)
    else
      generate_generic_diagram
    end
  end
  
  def generate_flowchart(section)
    # Extraire les étapes potentielles du contenu
    steps = extract_steps(section[:content])
    
    diagram = "```mermaid\nflowchart TD\n"
    
    if steps.empty?
      diagram += "    A[Début] --> B[Étape 1]\n"
      diagram += "    B --> C[Étape 2]\n"
      diagram += "    C --> D[Fin]\n"
    else
      steps.each_with_index do |step, index|
        node_id = (index + 65).chr # A, B, C, ...
        next_node_id = (index + 66).chr
        
        if index == 0
          diagram += "    #{node_id}[Début] --> #{next_node_id}[#{step}]\n"
        elsif index == steps.size - 1
          prev_node_id = (index + 64).chr
          end_node_id = (index + 66).chr
          diagram += "    #{prev_node_id} --> #{node_id}[#{step}]\n"
          diagram += "    #{node_id} --> #{end_node_id}[Fin]\n"
        else
          prev_node_id = (index + 64).chr
          diagram += "    #{prev_node_id} --> #{node_id}[#{step}]\n"
        end
      end
    end
    
    diagram += "```"
    diagram
  end
  
  def generate_state_diagram(section)
    # Extraire les états potentiels du contenu
    states = extract_states(section[:content])
    
    diagram = "```mermaid\nstateDiagram-v2\n"
    
    if states.empty?
      diagram += "    [*] --> État1\n"
      diagram += "    État1 --> État2\n"
      diagram += "    État2 --> État3\n"
      diagram += "    État3 --> [*]\n"
    else
      diagram += "    [*] --> #{states.first}\n"
      
      states.each_with_index do |state, index|
        next if index == states.size - 1
        next_state = states[index + 1]
        diagram += "    #{state} --> #{next_state}\n"
      end
      
      diagram += "    #{states.last} --> [*]\n"
    end
    
    diagram += "```"
    diagram
  end
  
  def generate_class_diagram(section)
    # Extraire les classes potentielles du contenu
    classes = extract_classes(section[:content])
    
    diagram = "```mermaid\nclassDiagram\n"
    
    if classes.empty?
      diagram += "    class Classe1 {\n        +attribut1\n        +méthode1()\n    }\n"
      diagram += "    class Classe2 {\n        +attribut2\n        +méthode2()\n    }\n"
      diagram += "    Classe1 --> Classe2\n"
    else
      classes.each do |class_name|
        diagram += "    class #{class_name} {\n        +attribut\n        +méthode()\n    }\n"
      end
      
      # Ajouter quelques relations entre les classes
      if classes.size > 1
        classes.each_with_index do |class_name, index|
          next if index == classes.size - 1
          next_class = classes[index + 1]
          diagram += "    #{class_name} --> #{next_class}\n"
        end
      end
    end
    
    diagram += "```"
    diagram
  end
  
  def generate_sequence_diagram(section)
    # Extraire les acteurs potentiels du contenu
    actors = extract_actors(section[:content])
    
    diagram = "```mermaid\nsequenceDiagram\n"
    
    if actors.empty?
      diagram += "    participant A as Acteur1\n"
      diagram += "    participant B as Acteur2\n"
      diagram += "    A->>B: Message1\n"
      diagram += "    B->>A: Réponse1\n"
    else
      actors.each_with_index do |actor, index|
        actor_id = (index + 65).chr # A, B, C, ...
        diagram += "    participant #{actor_id} as #{actor}\n"
      end
      
      # Ajouter quelques interactions entre les acteurs
      if actors.size > 1
        (0...actors.size).each do |i|
          next if i == actors.size - 1
          actor1_id = (i + 65).chr
          actor2_id = (i + 66).chr
          diagram += "    #{actor1_id}->>#{actor2_id}: Message\n"
          diagram += "    #{actor2_id}-->>#{actor1_id}: Réponse\n"
        end
      end
    end
    
    diagram += "```"
    diagram
  end
  
  def generate_generic_diagram
    "```mermaid\n#{@diagram_type}\n    # Générer un diagramme ici\n```"
  end
  
  def extract_steps(content)
    steps = []
    
    # Rechercher des listes numérotées ou à puces qui pourraient indiquer des étapes
    content.each_line do |line|
      if line.match(/^\s*(\d+\.|[\*\-])\s+(.+)$/)
        steps << $2.strip
      end
    end
    
    # Limiter à 5 étapes pour la lisibilité
    steps[0...5]
  end
  
  def extract_states(content)
    states = []
    
    # Rechercher des mots qui pourraient être des états
    content.scan(/[Éé]tat\s+(\w+)|statut\s+(\w+)|status\s+(\w+)/) do |matches|
      state = matches.compact.first
      states << state if state
    end
    
    # Rechercher des mots en gras ou italique qui pourraient être des états
    content.scan(/\*\*([^*]+)\*\*|\*([^*]+)\*/) do |matches|
      state = matches.compact.first
      states << state if state
    end
    
    # Si aucun état n'est trouvé, extraire des noms propres potentiels
    if states.empty?
      content.scan(/[A-Z][a-z]+/) do |word|
        states << word
      end
    end
    
    # Limiter à 5 états pour la lisibilité
    states.uniq[0...5]
  end
  
  def extract_classes(content)
    classes = []
    
    # Rechercher des mots qui pourraient être des noms de classes
    content.scan(/class\s+(\w+)|classe\s+(\w+)|model\s+(\w+)|modèle\s+(\w+)/) do |matches|
      class_name = matches.compact.first
      classes << class_name if class_name
    end
    
    # Rechercher des mots commençant par une majuscule qui pourraient être des classes
    content.scan(/\b([A-Z][a-zA-Z]+)\b/) do |word|
      classes << word[0]
    end
    
    # Limiter à 5 classes pour la lisibilité
    classes.uniq[0...5]
  end
  
  def extract_actors(content)
    actors = []
    
    # Rechercher des mots qui pourraient être des acteurs
    content.scan(/utilisateur|user|client|admin|système|system|service|API|serveur|server|membre|member/) do |actor|
      actors << actor.capitalize
    end
    
    # Si aucun acteur n'est trouvé, extraire des noms propres potentiels
    if actors.empty?
      content.scan(/[A-Z][a-z]+/) do |word|
        actors << word
      end
    end
    
    # Limiter à 5 acteurs pour la lisibilité
    actors.uniq[0...5]
  end
  
  def insert_diagram(section, diagram)
    # Créer une sauvegarde du fichier
    FileUtils.cp(@file_path, "#{@file_path}.bak")
    
    # Insérer le diagramme à la fin de la section
    lines = @content.lines
    
    # Trouver la ligne où insérer le diagramme
    insert_line = section[:end_line]
    
    # Créer le titre du diagramme
    diagram_title = case @diagram_type
                    when 'flowchart'
                      "### Diagramme de flux"
                    when 'stateDiagram'
                      "### Diagramme d'états"
                    when 'classDiagram'
                      "### Diagramme de classes"
                    when 'sequenceDiagram'
                      "### Diagramme de séquence"
                    else
                      "### Diagramme"
                    end
    
    # Insérer le diagramme
    lines.insert(insert_line, "\n#{diagram_title}\n\n#{diagram}\n\n")
    
    # Écrire le contenu modifié dans le fichier
    File.write(@file_path, lines.join)
  end
end

# Main execution
if ARGV.size < 1
  puts "Usage: ruby enrich_with_mermaid.rb <file_path> [--type=flowchart|stateDiagram|classDiagram|sequenceDiagram]"
  exit 1
end

file_path = ARGV[0]
diagram_type = nil

ARGV.each do |arg|
  if arg.start_with?('--type=')
    diagram_type = arg.split('=')[1]
    unless MermaidEnricher::DIAGRAM_TYPES.include?(diagram_type)
      puts "Type de diagramme non reconnu: #{diagram_type}"
      puts "Types disponibles: #{MermaidEnricher::DIAGRAM_TYPES.join(', ')}"
      exit 1
    end
  end
end

unless File.exist?(file_path)
  puts "Le fichier #{file_path} n'existe pas"
  exit 1
end

enricher = MermaidEnricher.new(file_path, diagram_type)
enricher.enrich 