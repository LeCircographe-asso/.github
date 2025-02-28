#!/usr/bin/env ruby
# frozen_string_literal: true

# Script pour vérifier les liens cassés dans la documentation
# Usage: ruby check_broken_links.rb [--fix]

require 'fileutils'
require 'pathname'

class BrokenLinkChecker
  DOCS_ROOT = File.expand_path('../../', __FILE__)
  MARKDOWN_PATTERN = '**/*.md'
  LINK_REGEX = /\[.*?\]\((.*?)\)/
  
  attr_reader :broken_links, :fixed_count

  def initialize(fix_mode = false)
    @fix_mode = fix_mode
    @broken_links = {}
    @fixed_count = 0
    @file_exists_cache = {}
    @attempted_fixes = {}
  end

  def check_all_files
    Dir.chdir(DOCS_ROOT) do
      Dir.glob(MARKDOWN_PATTERN).each do |file|
        check_file(file)
      end
    end
    
    print_results
  end

  private

  def check_file(file)
    content = File.read(file)
    line_number = 0
    
    content.each_line do |line|
      line_number += 1
      line.scan(LINK_REGEX).flatten.each do |link|
        next if link.start_with?('http://', 'https://', 'mailto:', '#')
        
        if broken_link?(link)
          @broken_links[file] ||= []
          @broken_links[file] << { line: line_number, link: link, original_line: line.strip }
          
          if @fix_mode
            fixed_line = fix_link(line, link, file)
            if fixed_line != line
              content = content.gsub(line, fixed_line)
              @fixed_count += 1
              @attempted_fixes["#{file}:#{line_number}"] = { original: link, fixed: extract_link_from_line(fixed_line) }
            end
          end
        end
      end
    end
    
    if @fix_mode && @broken_links[file]
      File.write(file, content)
    end
  end

  def extract_link_from_line(line)
    line.scan(LINK_REGEX).flatten.first || ""
  end

  def broken_link?(link)
    # Ignore anchors in the URL
    link = link.split('#').first
    
    # Cache file existence check for performance
    @file_exists_cache[link] ||= begin
      target_path = File.expand_path(link, DOCS_ROOT)
      !File.exist?(target_path)
    end
  end

  def fix_link(line, broken_link, current_file)
    # Common replacements for known patterns
    replacements = {
      # Old paths to new paths
      '/requirements/1_logique_metier/' => '/requirements/1_métier/',
      'adhesions/' => 'adhesion/',
      'paiements/' => 'paiement/',
      'cotisations/' => 'cotisation/',
      'utilisateurs/' => 'roles/',
      'notifications/' => 'notification/',
      'presences/' => 'presence/',
      
      # Old filenames to new filenames
      'systeme.md' => 'regles.md',
      'tarifs.md' => 'regles.md',
      'reglements.md' => 'regles.md',
      'types.md' => 'regles.md',
      
      # Fix common path issues
      '/docs/' => '../../docs/',
      '/requirements/' => '../../requirements/',
      '../../../docs/' => '../../docs/',
      '../../../requirements/' => '../../requirements/'
    }
    
    # Try to fix relative paths based on current file location
    if current_file.start_with?('docs/') && broken_link.start_with?('/docs/')
      replacements['/docs/'] = '../'
    elsif current_file.start_with?('requirements/') && broken_link.start_with?('/requirements/')
      replacements['/requirements/'] = '../'
    end
    
    # Try to fix paths to images
    if broken_link.include?('images/') && !File.exist?(File.expand_path(broken_link, DOCS_ROOT))
      # Check if image exists in a different location
      possible_image_locations = [
        '../../docs/business/images/',
        '../../docs/utilisateur/images/',
        '../../docs/architecture/images/',
        '../images/'
      ]
      
      image_name = File.basename(broken_link)
      possible_image_locations.each do |location|
        possible_path = "#{location}#{image_name}"
        if !broken_link?(possible_path)
          replacements[File.dirname(broken_link) + '/'] = location
          break
        end
      end
    end
    
    # Try to fix paths to diagrams
    if broken_link.include?('diagrams/') && !File.exist?(File.expand_path(broken_link, DOCS_ROOT))
      replacements[broken_link] = '../../docs/architecture/diagrams/' + File.basename(broken_link)
    end
    
    # Try to fix paths to templates
    if broken_link.include?('templates/') && !File.exist?(File.expand_path(broken_link, DOCS_ROOT))
      replacements[broken_link] = '../../docs/architecture/templates/' + File.basename(broken_link)
    end
    
    # Try to fix paths to API docs
    if broken_link.include?('api/') && !File.exist?(File.expand_path(broken_link, DOCS_ROOT))
      replacements[broken_link] = '../../docs/architecture/technical/api/' + File.basename(broken_link)
    end
    
    fixed_link = broken_link
    replacements.each do |old_pattern, new_pattern|
      fixed_link = fixed_link.gsub(old_pattern, new_pattern)
    end
    
    # Only replace if the fixed link actually exists or is a better path
    if fixed_link != broken_link && (!broken_link?(fixed_link) || is_better_path(broken_link, fixed_link))
      return line.gsub(broken_link, fixed_link)
    end
    
    # Try to find a similar file by name
    if @fix_mode && broken_link?(fixed_link)
      similar_file = find_similar_file(fixed_link)
      if similar_file && similar_file != fixed_link
        return line.gsub(broken_link, similar_file)
      end
    end
    
    line
  end
  
  def is_better_path(old_path, new_path)
    # Consider a path better if it has fewer '..' components or is more likely to be valid
    old_path_components = old_path.scan(/\.\./).count
    new_path_components = new_path.scan(/\.\./).count
    
    return true if new_path_components < old_path_components
    
    # Consider paths with proper structure better
    return true if new_path.include?('/docs/architecture/') && old_path.include?('/architecture/')
    return true if new_path.include?('/requirements/1_métier/') && old_path.include?('/1_métier/')
    
    false
  end
  
  def find_similar_file(broken_link)
    # Extract the filename from the broken link
    filename = File.basename(broken_link)
    
    # Search for files with similar names
    similar_files = []
    
    Dir.chdir(DOCS_ROOT) do
      Dir.glob("**/*#{filename}*").each do |file|
        if File.file?(file) && file.end_with?('.md')
          similar_files << file
        end
      end
    end
    
    return nil if similar_files.empty?
    
    # Return the most similar file path
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
    if @broken_links.empty?
      puts "✅ No broken links found!"
    else
      puts "❌ Found #{@broken_links.values.flatten.size} broken links in #{@broken_links.size} files:"
      
      @broken_links.each do |file, links|
        puts "\n📄 #{file}:"
        links.each do |link_info|
          puts "  - Line #{link_info[:line]}: [#{link_info[:link]}] in '#{link_info[:original_line]}'"
          
          if @fix_mode
            fix_info = @attempted_fixes["#{file}:#{link_info[:line]}"]
            if fix_info
              puts "    ↳ Attempted to fix: [#{fix_info[:original]}] → [#{fix_info[:fixed]}]"
            else
              puts "    ↳ Could not fix automatically"
            end
          else
            suggest_fix(link_info[:link])
          end
        end
      end
      
      if @fix_mode
        puts "\n🔧 Fixed #{@fixed_count} links automatically."
        puts "   Please review the changes and fix the remaining #{@broken_links.values.flatten.size - @fixed_count} links manually."
      else
        puts "\n💡 Run with --fix to attempt automatic fixes: ruby check_broken_links.rb --fix"
      end
    end
  end

  def suggest_fix(broken_link)
    # Try to suggest a fix based on common patterns
    replacements = {
      '/requirements/1_logique_metier/' => '/requirements/1_métier/',
      'adhesions/' => 'adhesion/',
      'paiements/' => 'paiement/',
      'cotisations/' => 'cotisation/',
      'utilisateurs/' => 'roles/',
      'notifications/' => 'notification/',
      'presences/' => 'presence/',
      'systeme.md' => 'regles.md',
      'tarifs.md' => 'regles.md',
      'reglements.md' => 'regles.md',
      'types.md' => 'regles.md'
    }
    
    fixed_link = broken_link
    replacements.each do |old_pattern, new_pattern|
      fixed_link = fixed_link.gsub(old_pattern, new_pattern)
    end
    
    if fixed_link != broken_link && !broken_link?(fixed_link)
      puts "    ↳ Suggested fix: #{fixed_link}"
    end
  end
end

# Main execution
fix_mode = ARGV.include?('--fix')
checker = BrokenLinkChecker.new(fix_mode)
checker.check_all_files 