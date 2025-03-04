#!/usr/bin/env ruby
# Script to identify orphaned files (not referenced by any other file)

require 'find'
require 'pathname'
require 'set'

class OrphanFinder
  attr_reader :workspace_root, :all_files, :referenced_files, :orphaned_files

  def initialize(workspace_root)
    @workspace_root = workspace_root
    @all_files = Set.new
    @referenced_files = Set.new
    @orphaned_files = nil
  end

  def run
    puts "🔍 Scanning for orphaned files in documentation..."
    
    # First, collect all markdown files
    Find.find(workspace_root) do |path|
      next unless path.end_with?('.md')
      next if path.include?('/.git/')
      
      relative_path = path.sub(workspace_root + '/', '')
      @all_files.add(relative_path)
    end
    
    puts "  📄 Found #{all_files.size} markdown files"
    
    # Then, find all references to other files
    Find.find(workspace_root) do |path|
      next unless path.end_with?('.md')
      next if path.include?('/.git/')
      
      find_references_in_file(path)
    end
    
    puts "  🔗 Found #{referenced_files.size} referenced files"
    
    # Calculate orphaned files
    @orphaned_files = all_files - referenced_files
    
    print_results
  end

  def find_references_in_file(file_path)
    content = File.read(file_path)
    
    # Find markdown links
    content.scan(/\[([^\]]+)\]\(([^)]+)\)/).each do |_, link_path|
      next if link_path.start_with?('http', '#', 'mailto:')
      
      # Normalize the path
      target_path = resolve_path(link_path, file_path)
      @referenced_files.add(target_path) if target_path
    end
    
    # Find HTML links
    content.scan(/<a\s+href=["']([^"']+)["']/).each do |link_path|
      link_path = link_path[0]
      next if link_path.start_with?('http', '#', 'mailto:')
      
      # Normalize the path
      target_path = resolve_path(link_path, file_path)
      @referenced_files.add(target_path) if target_path
    end
  end

  def resolve_path(link_path, source_file)
    # Remove leading slash for absolute paths
    if link_path.start_with?('/')
      link_path = link_path[1..-1]
      
      # Check if this file exists in our workspace
      return link_path if all_files.include?(link_path)
    else
      # Handle relative paths
      source_dir = Pathname.new(File.dirname(source_file))
      relative_to_root = source_dir.relative_path_from(Pathname.new(workspace_root))
      
      # Calculate absolute path from workspace root
      absolute_path = File.expand_path(File.join(relative_to_root.to_s, link_path))
      relative_path = absolute_path.sub(workspace_root + '/', '')
      
      # Check if this file exists in our workspace
      return relative_path if all_files.include?(relative_path)
    end
    
    nil
  end

  def print_results
    puts "\n📊 Orphaned Files Summary:"
    puts "  📄 Total markdown files: #{all_files.size}"
    puts "  🔗 Referenced files: #{referenced_files.size}"
    puts "  🚫 Orphaned files: #{orphaned_files.size}"
    
    if orphaned_files.size > 0
      puts "\n📋 List of Orphaned Files:"
      orphaned_files.sort.each do |file|
        puts "  - #{file}"
      end
    end
    
    puts "\nDone! ✅"
  end
end

# Run the script
if __FILE__ == $0
  workspace_root = ARGV[0] || Dir.pwd
  OrphanFinder.new(workspace_root).run
end 