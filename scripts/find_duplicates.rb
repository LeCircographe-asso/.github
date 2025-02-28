#!/usr/bin/env ruby
# frozen_string_literal: true

# Script pour identifier les doublons dans la documentation
# Usage: ruby find_duplicates.rb [--threshold=0.8]

require 'digest'
require 'set'

class DuplicateFinder
  DOCS_ROOT = File.expand_path('../../', __FILE__)
  MARKDOWN_PATTERN = '**/*.md'
  MIN_PARAGRAPH_LENGTH = 100 # Ignorer les paragraphes trop courts
  DEFAULT_SIMILARITY_THRESHOLD = 0.8 # Seuil de similarité par défaut (0.0 à 1.0)
  
  attr_reader :duplicates, :similarity_threshold
  
  def initialize(similarity_threshold = DEFAULT_SIMILARITY_THRESHOLD)
    @similarity_threshold = similarity_threshold.to_f
    @duplicates = []
    @paragraphs = {}
  end
  
  def find_duplicates
    extract_paragraphs
    detect_duplicates
    print_results
  end
  
  private
  
  def extract_paragraphs
    Dir.chdir(DOCS_ROOT) do
      Dir.glob(MARKDOWN_PATTERN).each do |file|
        next if file.include?('node_modules') || file.include?('vendor')
        
        content = File.read(file)
        paragraphs = extract_paragraphs_from_content(content)
        
        paragraphs.each_with_index do |paragraph, index|
          next if paragraph.length < MIN_PARAGRAPH_LENGTH
          
          # Stocker le paragraphe avec son fichier et sa position
          @paragraphs[paragraph] ||= []
          @paragraphs[paragraph] << { file: file, index: index }
        end
      end
    end
  end
  
  def extract_paragraphs_from_content(content)
    # Diviser le contenu en paragraphes (séparés par des lignes vides)
    paragraphs = content.split(/\n\s*\n/)
    
    # Nettoyer les paragraphes
    paragraphs.map do |p|
      p.strip.gsub(/\s+/, ' ')
    end
  end
  
  def detect_duplicates
    # Trouver les paragraphes exacts dupliqués
    @paragraphs.each do |paragraph, occurrences|
      next if occurrences.length < 2
      
      @duplicates << {
        type: 'exact',
        similarity: 1.0,
        paragraph: paragraph,
        occurrences: occurrences
      }
    end
    
    # Trouver les paragraphes similaires
    if @similarity_threshold < 1.0
      find_similar_paragraphs
    end
  end
  
  def find_similar_paragraphs
    # Créer un ensemble de paragraphes déjà traités comme doublons exacts
    exact_duplicates = Set.new
    @duplicates.each do |duplicate|
      if duplicate[:type] == 'exact'
        exact_duplicates.add(duplicate[:paragraph])
      end
    end
    
    # Comparer tous les paragraphes entre eux
    paragraphs = @paragraphs.keys
    paragraphs.each_with_index do |p1, i|
      next if exact_duplicates.include?(p1)
      
      (i+1...paragraphs.length).each do |j|
        p2 = paragraphs[j]
        next if exact_duplicates.include?(p2)
        
        similarity = calculate_similarity(p1, p2)
        
        if similarity >= @similarity_threshold && similarity < 1.0
          @duplicates << {
            type: 'similar',
            similarity: similarity,
            paragraph1: p1,
            paragraph2: p2,
            occurrences1: @paragraphs[p1],
            occurrences2: @paragraphs[p2]
          }
        end
      end
    end
  end
  
  def calculate_similarity(str1, str2)
    # Utiliser la distance de Levenshtein normalisée
    distance = levenshtein_distance(str1, str2)
    max_length = [str1.length, str2.length].max
    
    1.0 - (distance.to_f / max_length)
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
    if @duplicates.empty?
      puts "✅ No duplicates found!"
      return
    end
    
    # Trier les doublons par type et similarité
    sorted_duplicates = @duplicates.sort_by do |duplicate|
      [duplicate[:type] == 'exact' ? 0 : 1, -duplicate[:similarity]]
    end
    
    puts "🔍 Found #{sorted_duplicates.size} potential duplicates:"
    
    # Afficher les doublons exacts
    exact_count = sorted_duplicates.count { |d| d[:type] == 'exact' }
    puts "\n📋 #{exact_count} exact duplicates:"
    
    sorted_duplicates.each_with_index do |duplicate, index|
      next unless duplicate[:type] == 'exact'
      
      puts "\n#{index + 1}. Duplicate content (#{duplicate[:paragraph].length} chars):"
      puts "   First #{[50, duplicate[:paragraph].length].min} chars: #{duplicate[:paragraph][0..49]}..."
      puts "   Found in:"
      
      duplicate[:occurrences].each do |occurrence|
        puts "   - #{occurrence[:file]} (paragraph #{occurrence[:index] + 1})"
      end
    end
    
    # Afficher les paragraphes similaires
    similar_count = sorted_duplicates.count { |d| d[:type] == 'similar' }
    puts "\n📋 #{similar_count} similar paragraphs (threshold: #{@similarity_threshold}):"
    
    sorted_duplicates.each_with_index do |duplicate, index|
      next unless duplicate[:type] == 'similar'
      
      puts "\n#{index + 1 - exact_count}. Similar content (similarity: #{duplicate[:similarity].round(2)}):"
      puts "   Paragraph 1 (first 50 chars): #{duplicate[:paragraph1][0..49]}..."
      puts "   Found in:"
      duplicate[:occurrences1].each do |occurrence|
        puts "   - #{occurrence[:file]} (paragraph #{occurrence[:index] + 1})"
      end
      
      puts "   Paragraph 2 (first 50 chars): #{duplicate[:paragraph2][0..49]}..."
      puts "   Found in:"
      duplicate[:occurrences2].each do |occurrence|
        puts "   - #{occurrence[:file]} (paragraph #{occurrence[:index] + 1})"
      end
    end
    
    puts "\n💡 Recommendations:"
    puts "1. Review exact duplicates and consider consolidating them into a single source"
    puts "2. For similar paragraphs, check if they can be merged or if they should remain separate"
    puts "3. Consider using includes or references instead of duplicating content"
    puts "4. Run with different threshold to adjust sensitivity: ruby find_duplicates.rb --threshold=0.9"
  end
end

# Main execution
threshold = DEFAULT_SIMILARITY_THRESHOLD
ARGV.each do |arg|
  if arg.start_with?('--threshold=')
    threshold = arg.split('=')[1].to_f
  end
end

finder = DuplicateFinder.new(threshold)
finder.find_duplicates 