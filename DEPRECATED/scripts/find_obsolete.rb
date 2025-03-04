#!/usr/bin/env ruby
# Script to identify obsolete files based on keywords and modification date

require 'find'
require 'date'

class ObsoleteFinder
  OBSOLETE_KEYWORDS = [
    'deprecated',
    'obsolete',
    'outdated',
    'old',
    'legacy',
    'TODO',
    'FIXME',
    '[DATE]'
  ]
  
  OBSOLETE_THRESHOLD_DAYS = 90

  attr_reader :workspace_root, :obsolete_files

  def initialize(workspace_root)
    @workspace_root = workspace_root
    @obsolete_files = []
  end

  def run
    puts "🔍 Scanning for obsolete files in documentation..."
    
    Find.find(workspace_root) do |path|
      next unless path.end_with?('.md')
      next if path.include?('/.git/')
      next if path.include?('/deprecated/')
      
      check_file_obsolescence(path)
    end
    
    print_results
  end

  def check_file_obsolescence(file_path)
    content = File.read(file_path)
    file_age_days = (Date.today - File.mtime(file_path).to_date).to_i
    
    # Check for obsolete keywords
    has_obsolete_keywords = OBSOLETE_KEYWORDS.any? { |keyword| content.downcase.include?(keyword.downcase) }
    
    # Check if file is old and hasn't been updated
    is_old = file_age_days > OBSOLETE_THRESHOLD_DAYS
    
    if has_obsolete_keywords || is_old
      @obsolete_files << {
        file: file_path.sub(workspace_root + '/', ''),
        age_days: file_age_days,
        has_keywords: has_obsolete_keywords,
        keywords_found: OBSOLETE_KEYWORDS.select { |k| content.downcase.include?(k.downcase) }
      }
    end
  end

  def print_results
    puts "\n📊 Obsolete Files Summary:"
    puts "  🕰️ Files older than #{OBSOLETE_THRESHOLD_DAYS} days: #{obsolete_files.count { |f| f[:age_days] > OBSOLETE_THRESHOLD_DAYS }}"
    puts "  🚫 Files with obsolete keywords: #{obsolete_files.count { |f| f[:has_keywords] }}"
    puts "  📄 Total obsolete files: #{obsolete_files.size}"
    
    if obsolete_files.size > 0
      puts "\n📋 List of Obsolete Files:"
      obsolete_files.sort_by { |f| -f[:age_days] }.each do |file|
        reason = []
        reason << "#{file[:age_days]} days old" if file[:age_days] > OBSOLETE_THRESHOLD_DAYS
        reason << "contains #{file[:keywords_found].join(', ')}" if file[:has_keywords]
        
        puts "  - #{file[:file]} (#{reason.join(', ')})"
      end
    end
    
    puts "\nDone! ✅"
  end
end

# Run the script
if __FILE__ == $0
  workspace_root = ARGV[0] || Dir.pwd
  ObsoleteFinder.new(workspace_root).run
end 