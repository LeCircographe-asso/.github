#!/usr/bin/env ruby
# frozen_string_literal: true

# Script pour ajouter des diagrammes Mermaid à une liste de fichiers spécifiée
# Usage: ruby add_mermaid_to_files.rb <diagram_type> <file1> [<file2> ...]
# Exemple: ruby add_mermaid_to_files.rb stateDiagram ../requirements/1_métier/adhesion/regles.md

require 'fileutils'

class MermaidAdder
  DIAGRAM_TYPES = ['flowchart', 'stateDiagram', 'classDiagram', 'sequenceDiagram']
  
  def initialize(diagram_type)
    unless DIAGRAM_TYPES.include?(diagram_type)
      puts "Type de diagramme non reconnu: #{diagram_type}"
      puts "Types disponibles: #{DIAGRAM_TYPES.join(', ')}"
      exit 1
    end
    
    @diagram_type = diagram_type
  end
  
  def add_to_file(file_path)
    unless File.exist?(file_path)
      puts "Le fichier #{file_path} n'existe pas"
      return false
    end
    
    content = File.read(file_path)
    
    # Vérifier si le fichier contient déjà un diagramme Mermaid
    if content.include?('```mermaid')
      puts "⚠️ Le fichier #{file_path} contient déjà un diagramme Mermaid"
      return false
    end
    
    # Créer une sauvegarde du fichier
    FileUtils.cp(file_path, "#{file_path}.bak")
    
    # Générer le diagramme
    diagram = generate_diagram(content)
    
    # Trouver un bon endroit pour insérer le diagramme
    lines = content.lines
    
    # Chercher un titre de section approprié
    section_line = find_section_line(lines)
    
    # Insérer le diagramme après la section trouvée
    if section_line
      lines.insert(section_line + 1, "\n#{diagram}\n\n")
    else
      # Si aucune section appropriée n'est trouvée, ajouter à la fin du fichier
      lines << "\n#{diagram}\n"
    end
    
    # Écrire le contenu modifié dans le fichier
    File.write(file_path, lines.join)
    
    puts "✅ Diagramme #{@diagram_type} ajouté au fichier #{file_path}"
    true
  end
  
  private
  
  def generate_diagram(content)
    diagram_title = case @diagram_type
                    when 'flowchart'
                      "### Diagramme de flux\n"
                    when 'stateDiagram'
                      "### Diagramme d'états\n"
                    when 'classDiagram'
                      "### Diagramme de classes\n"
                    when 'sequenceDiagram'
                      "### Diagramme de séquence\n"
                    else
                      "### Diagramme\n"
                    end
    
    case @diagram_type
    when 'flowchart'
      diagram_title + generate_flowchart(content)
    when 'stateDiagram'
      diagram_title + generate_state_diagram(content)
    when 'classDiagram'
      diagram_title + generate_class_diagram(content)
    when 'sequenceDiagram'
      diagram_title + generate_sequence_diagram(content)
    else
      diagram_title + "```mermaid\n#{@diagram_type}\n  # Générer un diagramme ici\n```"
    end
  end
  
  def find_section_line(lines)
    # Mots-clés spécifiques à chaque type de diagramme
    keywords = {
      'flowchart' => ['flux', 'processus', 'workflow', 'étapes', 'cycle', 'flow'],
      'stateDiagram' => ['état', 'statut', 'transition', 'state', 'status'],
      'classDiagram' => ['relation', 'dépendance', 'lien', 'association', 'dependency', 'classe', 'class'],
      'sequenceDiagram' => ['séquence', 'interaction', 'communication', 'sequence']
    }
    
    # Chercher une section qui contient des mots-clés pertinents
    section_lines = []
    
    lines.each_with_index do |line, index|
      if line.match(/^#+\s+(.+)$/)
        section_title = $1.downcase
        if keywords[@diagram_type].any? { |keyword| section_title.include?(keyword) }
          section_lines << index
        end
      end
    end
    
    # Retourner la première section trouvée, ou nil si aucune n'est trouvée
    section_lines.first
  end
  
  def generate_flowchart(content)
    # Extraire les étapes potentielles du contenu
    steps = extract_steps(content)
    
    diagram = "```mermaid\nflowchart TD\n"
    
    if steps.empty?
      diagram += "  A[Début] --> B[Étape 1]\n"
      diagram += "  B --> C[Étape 2]\n"
      diagram += "  C --> D[Fin]\n"
    else
      steps.each_with_index do |step, index|
        node_id = (index + 65).chr # A, B, C, ...
        next_node_id = (index + 66).chr
        
        if index == 0
          diagram += "  #{node_id}[Début] --> #{next_node_id}[#{step}]\n"
        elsif index == steps.size - 1
          prev_node_id = (index + 64).chr
          end_node_id = (index + 66).chr
          diagram += "  #{prev_node_id} --> #{node_id}[#{step}]\n"
          diagram += "  #{node_id} --> #{end_node_id}[Fin]\n"
        else
          prev_node_id = (index + 64).chr
          diagram += "  #{prev_node_id} --> #{node_id}[#{step}]\n"
        end
      end
    end
    
    diagram += "```"
    diagram
  end
  
  def generate_state_diagram(content)
    # Extraire les états potentiels du contenu
    states = extract_states(content)
    
    diagram = "```mermaid\nstateDiagram-v2\n"
    
    if states.empty?
      diagram += "  [*] --> État1\n"
      diagram += "  État1 --> État2\n"
      diagram += "  État2 --> État3\n"
      diagram += "  État3 --> [*]\n"
    else
      diagram += "  [*] --> #{states.first}\n"
      
      states.each_with_index do |state, index|
        next if index == states.size - 1
        next_state = states[index + 1]
        diagram += "  #{state} --> #{next_state}\n"
      end
      
      diagram += "  #{states.last} --> [*]\n"
    end
    
    diagram += "```"
    diagram
  end
  
  def generate_class_diagram(content)
    # Extraire les classes potentielles du contenu
    classes = extract_classes(content)
    
    diagram = "```mermaid\nclassDiagram\n"
    
    if classes.empty?
      diagram += "  class Classe1 {\n    +attribut1\n    +méthode1()\n  }\n"
      diagram += "  class Classe2 {\n    +attribut2\n    +méthode2()\n  }\n"
      diagram += "  Classe1 --> Classe2\n"
    else
      classes.each do |class_name|
        diagram += "  class #{class_name} {\n    +attribut\n    +méthode()\n  }\n"
      end
      
      # Ajouter quelques relations entre les classes
      if classes.size > 1
        classes.each_with_index do |class_name, index|
          next if index == classes.size - 1
          next_class = classes[index + 1]
          diagram += "  #{class_name} --> #{next_class}\n"
        end
      end
    end
    
    diagram += "```"
    diagram
  end
  
  def generate_sequence_diagram(content)
    # Extraire les acteurs potentiels du contenu
    actors = extract_actors(content)
    
    diagram = "```mermaid\nsequenceDiagram\n"
    
    if actors.empty?
      diagram += "  participant A as Acteur1\n"
      diagram += "  participant B as Acteur2\n"
      diagram += "  A->>B: Message1\n"
      diagram += "  B->>A: Réponse1\n"
    else
      actors.each_with_index do |actor, index|
        actor_id = (index + 65).chr # A, B, C, ...
        diagram += "  participant #{actor_id} as #{actor}\n"
      end
      
      # Ajouter quelques interactions entre les acteurs
      if actors.size > 1
        (0...actors.size).each do |i|
          next if i == actors.size - 1
          actor1_id = (i + 65).chr
          actor2_id = (i + 66).chr
          diagram += "  #{actor1_id}->>#{actor2_id}: Message\n"
          diagram += "  #{actor2_id}-->>#{actor1_id}: Réponse\n"
        end
      end
    end
    
    diagram += "```"
    diagram
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
end

# Main execution
if ARGV.size < 2
  puts "Usage: ruby add_mermaid_to_files.rb <diagram_type> <file1> [<file2> ...]"
  puts "Exemple: ruby add_mermaid_to_files.rb stateDiagram ../requirements/1_métier/adhesion/regles.md"
  exit 1
end

diagram_type = ARGV[0]
files = ARGV[1..-1]

adder = MermaidAdder.new(diagram_type)

files.each do |file|
  adder.add_to_file(file)
end 