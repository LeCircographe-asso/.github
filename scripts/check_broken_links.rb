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
            fixed_line = fix_link(line, link)
            if fixed_line != line
              content = content.gsub(line, fixed_line)
              @fixed_count += 1
            end
          end
        end
      end
    end
    
    if @fix_mode && @broken_links[file]
      File.write(file, content)
    end
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

  def fix_link(line, broken_link)
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
      'types.md' => 'regles.md'
    }
    
    fixed_link = broken_link
    replacements.each do |old_pattern, new_pattern|
      fixed_link = fixed_link.gsub(old_pattern, new_pattern)
    end
    
    # Only replace if the fixed link actually exists
    if fixed_link != broken_link && !broken_link?(fixed_link)
      return line.gsub(broken_link, fixed_link)
    end
    
    line
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
            puts "    ↳ Attempted to fix"
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