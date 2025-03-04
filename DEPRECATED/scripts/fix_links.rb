#!/usr/bin/env ruby
# Script to identify and fix broken links in markdown documentation

require 'find'
require 'pathname'

class LinkFixer
  LINK_PATTERN = /\[([^\]]+)\]\(([^)]+)\)/
  ABSOLUTE_PATH_PATTERN = /^\/[a-zA-Z0-9_\-\/\.]+/
  INCORRECT_RELATIVE_PATTERN = /^(\.\.\/){3,}|^requirements\/|^docs\//

  attr_reader :workspace_root, :fixed_count, :broken_count, :files_checked

  def initialize(workspace_root)
    @workspace_root = workspace_root
    @fixed_count = 0
    @broken_count = 0
    @files_checked = 0
  end

  def run
    puts "🔍 Scanning for broken links in markdown files..."
    
    Find.find(workspace_root) do |path|
      next unless path.end_with?('.md')
      next if path.include?('/deprecated/') || path.include?('/.git/')
      
      fix_links_in_file(path)
    end

    print_summary
  end

  def fix_links_in_file(file_path)
    @files_checked += 1
    content = File.read(file_path)
    original_content = content.dup
    file_dir = Pathname.new(File.dirname(file_path))
    
    content.gsub!(LINK_PATTERN) do |match|
      link_text = $1
      link_path = $2
      
      # Skip URLs, anchors, and email links
      next match if link_path.start_with?('http', '#', 'mailto:')
      
      if link_path.match?(ABSOLUTE_PATH_PATTERN) || link_path.match?(INCORRECT_RELATIVE_PATTERN)
        @broken_count += 1
        fixed_path = fix_path(link_path, file_dir)
        puts "  🔧 In #{file_path.sub(workspace_root + '/', '')}"
        puts "     Fixed: [#{link_text}](#{link_path}) → [#{link_text}](#{fixed_path})"
        "[#{link_text}](#{fixed_path})"
      else
        match
      end
    end
    
    if content != original_content
      @fixed_count += 1
      File.write(file_path, content)
    end
  end

  def fix_path(link_path, file_dir)
    # Remove leading slash for absolute paths
    if link_path.start_with?('/')
      link_path = link_path[1..-1]
    end
    
    # Handle paths that start with domain names
    if link_path.start_with?('requirements/') || link_path.start_with?('docs/')
      target_path = File.join(workspace_root, link_path)
      
      # Calculate relative path from file_dir to target
      if File.exist?(target_path)
        relative_path = Pathname.new(target_path).relative_path_from(file_dir).to_s
        return relative_path
      end
    end
    
    # Fix excessive parent directory references
    if link_path.match?(/^(\.\.\/){3,}/)
      parts = link_path.split('/')
      parent_count = 0
      while parts[0] == '..'
        parent_count += 1
        parts.shift
      end
      
      # Calculate correct number of parent directories needed
      file_parts = file_dir.to_s.sub(workspace_root, '').split('/')
      needed_parents = [file_parts.size - 1, 1].max
      
      # Rebuild path with correct number of parent references
      new_path = (['..'] * needed_parents + parts).join('/')
      return new_path
    end
    
    # Return original if we couldn't fix it
    link_path
  end

  def print_summary
    puts "\n📊 Link Fixing Summary:"
    puts "  📄 Files checked: #{files_checked}"
    puts "  🔗 Broken links found: #{broken_count}"
    puts "  🔧 Files with fixed links: #{fixed_count}"
    puts "\nDone! ✅"
  end
end

# Run the script
if __FILE__ == $0
  workspace_root = ARGV[0] || Dir.pwd
  LinkFixer.new(workspace_root).run
end 