#!/usr/bin/env ruby
# frozen_string_literal: true

# Script pour vérifier les spécifications techniques liées à Rails 8.0.1
# Usage: ruby check_rails_specs.rb [--fix]

class RailsSpecChecker
  DOCS_ROOT = File.expand_path('../../', __FILE__)
  MARKDOWN_PATTERN = '**/*.md'
  
  # Fonctionnalités spécifiques à Rails 8.0.1 à vérifier
  RAILS_8_FEATURES = {
    'typed_params' => {
      'description' => 'Paramètres typés dans les contrôleurs',
      'pattern' => /typed_params|params\.require.*\.permit/,
      'example' => "```ruby\nparams.require(:user).permit(:name, :email)\n```"
    },
    'result_object' => {
      'description' => 'Objets Result pour les services',
      'pattern' => /Result|Success|Failure|service.*result/i,
      'example' => "```ruby\nclass Result\n  attr_reader :success, :data, :errors\n  \n  def initialize(success, data = nil, errors = nil)\n    @success = success\n    @data = data\n    @errors = errors\n  end\n  \n  def self.success(data = nil)\n    new(true, data, nil)\n  end\n  \n  def self.failure(errors = nil)\n    new(false, nil, errors)\n  end\nend\n```"
    },
    'turbo_streams' => {
      'description' => 'Turbo Streams pour les mises à jour en temps réel',
      'pattern' => /turbo_stream|turbo-stream|turbo_frame|turbo-frame/i,
      'example' => "```ruby\nturbo_stream.replace \"user_#{@user.id}\", partial: \"users/user\", locals: { user: @user }\n```"
    },
    'stimulus_controllers' => {
      'description' => 'Contrôleurs Stimulus',
      'pattern' => /stimulus|controller.*connect|data-controller/i,
      'example' => "```javascript\nimport { Controller } from \"@hotwired/stimulus\"\n\nexport default class extends Controller {\n  static targets = [ \"name\" ]\n  \n  greet() {\n    console.log(`Hello, ${this.nameTarget.value}!`)\n  }\n}\n```"
    },
    'active_storage' => {
      'description' => 'Active Storage pour la gestion des fichiers',
      'pattern' => /active_storage|has_one_attached|has_many_attached/i,
      'example' => "```ruby\nclass User < ApplicationRecord\n  has_one_attached :avatar\n  has_many_attached :documents\nend\n```"
    },
    'action_text' => {
      'description' => 'Action Text pour le contenu riche',
      'pattern' => /action_text|has_rich_text/i,
      'example' => "```ruby\nclass Article < ApplicationRecord\n  has_rich_text :content\nend\n```"
    },
    'strong_migrations' => {
      'description' => 'Migrations sécurisées',
      'pattern' => /add_index.*algorithm|disable_ddl_transaction|add_reference.*index/i,
      'example' => "```ruby\nclass AddIndexToUsers < ActiveRecord::Migration[8.0]\n  disable_ddl_transaction!\n  \n  def change\n    add_index :users, :email, algorithm: :concurrently\n  end\nend\n```"
    },
    'enum_with_prefix' => {
      'description' => 'Enums avec préfixe',
      'pattern' => /enum.*prefix/i,
      'example' => "```ruby\nclass Conversation < ApplicationRecord\n  enum status: { active: 0, archived: 1 }, _prefix: true\nend\n```"
    },
    'delegated_types' => {
      'description' => 'Types délégués',
      'pattern' => /delegated_type|delegated_types/i,
      'example' => "```ruby\nclass Entry < ApplicationRecord\n  delegated_type :entryable, types: %w[ Message Comment ]\nend\n```"
    },
    'encrypted_attributes' => {
      'description' => 'Attributs chiffrés',
      'pattern' => /encrypts|encrypted_attribute/i,
      'example' => "```ruby\nclass User < ApplicationRecord\n  encrypts :email, deterministic: true\n  encrypts :credit_card_number\nend\n```"
    }
  }
  
  attr_reader :fix_mode, :issues
  
  def initialize(fix_mode = false)
    @fix_mode = fix_mode
    @issues = []
  end
  
  def check_all_files
    Dir.chdir(DOCS_ROOT) do
      Dir.glob(MARKDOWN_PATTERN).each do |file|
        next if file.include?('node_modules') || file.include?('vendor')
        
        check_file(file)
      end
    end
    
    print_results
  end
  
  private
  
  def check_file(file)
    content = File.read(file)
    
    # Vérifier si le fichier mentionne Rails 8.0
    return unless content.match(/Rails\s+8\.0|Rails\s+8|Ruby\s+on\s+Rails\s+8/i)
    
    # Vérifier les fonctionnalités Rails 8.0.1
    missing_features = []
    
    RAILS_8_FEATURES.each do |feature_key, feature_info|
      unless content.match(feature_info['pattern'])
        missing_features << feature_key
      end
    end
    
    if missing_features.any?
      @issues << {
        file: file,
        missing_features: missing_features
      }
      
      if @fix_mode
        fix_file(file, missing_features)
      end
    end
  end
  
  def fix_file(file, missing_features)
    content = File.read(file)
    
    # Créer une sauvegarde du fichier
    File.write("#{file}.bak", content)
    
    # Ajouter une section sur les fonctionnalités manquantes
    new_content = content
    
    # Trouver un bon endroit pour ajouter la section
    if content.include?('## Fonctionnalités Rails 8.0')
      # Si une section existe déjà, ajouter les fonctionnalités manquantes à cette section
      section_start = content.index('## Fonctionnalités Rails 8.0')
      section_end = content.index(/^##[^#]/, section_start + 1) || content.length
      
      section_content = content[section_start...section_end]
      new_section_content = section_content.dup
      
      missing_features.each do |feature_key|
        feature_info = RAILS_8_FEATURES[feature_key]
        
        unless section_content.include?(feature_info['description'])
          new_section_content += "\n\n### #{feature_info['description']}\n\n"
          new_section_content += "Rails 8.0.1 introduit #{feature_info['description'].downcase}. Voici un exemple d'utilisation :\n\n"
          new_section_content += "#{feature_info['example']}\n"
        end
      end
      
      new_content = content.sub(section_content, new_section_content)
    else
      # Sinon, ajouter une nouvelle section à la fin du fichier
      new_content += "\n\n## Fonctionnalités Rails 8.0.1\n\n"
      new_content += "Ce document utilise les fonctionnalités suivantes de Rails 8.0.1 :\n\n"
      
      missing_features.each do |feature_key|
        feature_info = RAILS_8_FEATURES[feature_key]
        
        new_content += "### #{feature_info['description']}\n\n"
        new_content += "Rails 8.0.1 introduit #{feature_info['description'].downcase}. Voici un exemple d'utilisation :\n\n"
        new_content += "#{feature_info['example']}\n\n"
      end
    end
    
    # Écrire le contenu modifié dans le fichier
    File.write(file, new_content)
  end
  
  def print_results
    if @issues.empty?
      puts "✅ Tous les fichiers mentionnant Rails 8.0 incluent les fonctionnalités spécifiques à Rails 8.0.1"
      return
    end
    
    puts "🔍 Trouvé #{@issues.size} fichiers mentionnant Rails 8.0 mais manquant certaines fonctionnalités spécifiques à Rails 8.0.1:"
    
    @issues.each do |issue|
      puts "\n📄 #{issue[:file]}:"
      puts "   Fonctionnalités manquantes:"
      
      issue[:missing_features].each do |feature_key|
        feature_info = RAILS_8_FEATURES[feature_key]
        puts "   - #{feature_info['description']}"
      end
      
      if @fix_mode
        puts "   ✅ Fichier mis à jour avec les fonctionnalités manquantes"
      end
    end
    
    if !@fix_mode
      puts "\n💡 Exécutez avec --fix pour ajouter automatiquement les fonctionnalités manquantes:"
      puts "   ruby check_rails_specs.rb --fix"
    end
  end
end

# Main execution
fix_mode = ARGV.include?('--fix')
checker = RailsSpecChecker.new(fix_mode)
checker.check_all_files 