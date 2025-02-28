#!/usr/bin/env ruby
# frozen_string_literal: true

# Script pour analyser les fichiers de documentation et suggérer où ajouter des diagrammes Mermaid
# Usage: ruby add_mermaid_diagrams.rb [--generate]

class MermaidEnricher
  DOCS_ROOT = File.expand_path('../../', __FILE__)
  MARKDOWN_PATTERN = '**/*.md'
  
  # Mots-clés qui suggèrent qu'un diagramme pourrait être utile
  FLOW_KEYWORDS = ['flux', 'processus', 'workflow', 'étapes', 'cycle', 'flow']
  STATE_KEYWORDS = ['état', 'statut', 'transition', 'state', 'status']
  RELATION_KEYWORDS = ['relation', 'dépendance', 'lien', 'association', 'dependency']
  SEQUENCE_KEYWORDS = ['séquence', 'interaction', 'communication', 'sequence']
  
  attr_reader :suggestions, :generate_mode
  
  def initialize(generate_mode = false)
    @generate_mode = generate_mode
    @suggestions = {}
  end
  
  def analyze_files
    Dir.chdir(DOCS_ROOT) do
      Dir.glob(MARKDOWN_PATTERN).each do |file|
        next if file.include?('node_modules') || file.include?('vendor')
        
        analyze_file(file)
      end
    end
    
    print_results
  end
  
  private
  
  def analyze_file(file)
    content = File.read(file)
    
    # Vérifier si le fichier contient déjà des diagrammes Mermaid
    has_mermaid = content.include?('```mermaid')
    
    # Analyser le contenu pour détecter les sections qui pourraient bénéficier d'un diagramme
    sections = extract_sections(content)
    
    file_suggestions = []
    
    sections.each do |section|
      diagram_type = suggest_diagram_type(section[:title], section[:content])
      
      if diagram_type
        file_suggestions << {
          section: section[:title],
          diagram_type: diagram_type,
          line: section[:line],
          content: section[:content]
        }
      end
    end
    
    if !file_suggestions.empty?
      @suggestions[file] = {
        has_mermaid: has_mermaid,
        suggestions: file_suggestions
      }
    end
  end
  
  def extract_sections(content)
    sections = []
    current_section = { title: "Document", content: "", line: 1 }
    line_number = 0
    
    content.each_line do |line|
      line_number += 1
      
      # Détecter les titres de section (# Titre, ## Sous-titre, etc.)
      if line.match(/^#+\s+(.+)$/)
        # Sauvegarder la section précédente si elle n'est pas vide
        if !current_section[:content].strip.empty?
          sections << current_section
        end
        
        # Commencer une nouvelle section
        current_section = {
          title: $1.strip,
          content: "",
          line: line_number
        }
      else
        # Ajouter la ligne au contenu de la section courante
        current_section[:content] += line
      end
    end
    
    # Ajouter la dernière section
    if !current_section[:content].strip.empty?
      sections << current_section
    end
    
    sections
  end
  
  def suggest_diagram_type(title, content)
    text = "#{title} #{content}".downcase
    
    # Vérifier les mots-clés pour suggérer un type de diagramme
    if FLOW_KEYWORDS.any? { |keyword| text.include?(keyword) }
      return 'flowchart'
    elsif STATE_KEYWORDS.any? { |keyword| text.include?(keyword) }
      return 'stateDiagram'
    elsif RELATION_KEYWORDS.any? { |keyword| text.include?(keyword) }
      return 'classDiagram'
    elsif SEQUENCE_KEYWORDS.any? { |keyword| text.include?(keyword) }
      return 'sequenceDiagram'
    end
    
    nil
  end
  
  def generate_diagram(diagram_type, content)
    case diagram_type
    when 'flowchart'
      generate_flowchart(content)
    when 'stateDiagram'
      generate_state_diagram(content)
    when 'classDiagram'
      generate_class_diagram(content)
    when 'sequenceDiagram'
      generate_sequence_diagram(content)
    else
      "```mermaid\n#{diagram_type}\n  # Générer un diagramme ici\n```"
    end
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
  
  def print_results
    if @suggestions.empty?
      puts "✅ Aucune suggestion de diagramme trouvée."
      return
    end
    
    puts "🔍 Suggestions de diagrammes Mermaid pour #{@suggestions.size} fichiers:"
    
    @suggestions.each do |file, data|
      puts "\n📄 #{file}:"
      
      if data[:has_mermaid]
        puts "   ℹ️ Ce fichier contient déjà des diagrammes Mermaid."
      end
      
      data[:suggestions].each do |suggestion|
        puts "   - Section '#{suggestion[:section]}' (ligne #{suggestion[:line]}): Suggéré #{suggestion[:diagram_type]}"
        
        if @generate_mode
          puts "\n   Proposition de diagramme:"
          puts generate_diagram(suggestion[:diagram_type], suggestion[:content])
          puts
        end
      end
    end
    
    if !@generate_mode
      puts "\n💡 Exécutez avec --generate pour générer des propositions de diagrammes:"
      puts "   ruby add_mermaid_diagrams.rb --generate"
    end
  end
end

# Main execution
generate_mode = ARGV.include?('--generate')
enricher = MermaidEnricher.new(generate_mode)
enricher.analyze_files 