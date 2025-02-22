# Guide Complet Ruby on Rails 8 - Architecture MVC et Bonnes Pratiques

## Table des Matières
1. [Architecture MVC](#1-architecture-mvc)
2. [Les Modèles (Models)](#2-les-modèles-models)
3. [Les Contrôleurs (Controllers)](#3-les-contrôleurs-controllers)
4. [Les Vues et Hotwire](#4-les-vues-et-hotwire)
5. [Authentification avec Rails 8](#5-authentification-avec-rails-8)
6. [Gestion des Variables et Attributs](#6-gestion-des-variables-et-attributs)
7. [Helpers et Services](#7-helpers-et-services)
8. [Bonnes Pratiques et Conventions](#8-bonnes-pratiques-et-conventions)
9. [10. Guide Pratique des Relations MVC](#10-guide-pratique-des-relations-mvc)
10. [Migrations Complexes et Relations Avancées](#9-migrations-complexes-et-relations-avancées)
11. [Guide Approfondi des Attributs et Variables](#11-guide-approfondi-des-attributs-et-variables)
12. [Cas Pratique : Le Circographe](#12-cas-pratique-le-circographe)

## 1. Architecture MVC

### Principes Fondamentaux
L'architecture MVC dans Rails 8 sépare votre application en trois composants principaux :

- **Model (M)**: Gère les données, la logique métier et les règles de l'application
- **View (V)**: S'occupe de la présentation et de l'interface utilisateur
- **Controller (C)**: Coordonne les interactions entre le Model et la View

### Flow de Données Typique
1. L'utilisateur interagit avec l'application (clic, formulaire...)
2. La requête arrive au Router qui la dirige vers le Controller approprié
3. Le Controller interagit avec le Model pour les opérations de données
4. Le Model effectue les validations et opérations nécessaires
5. Le Controller reçoit les données du Model
6. Le Controller prépare les données pour la View
7. La View génère le HTML/JSON avec Hotwire
8. La réponse est envoyée au navigateur

## 2. Les Modèles (Models)

### Relations et Attributs
Les modèles Rails 8 utilisent Active Record pour gérer les relations entre tables :

```ruby
class User < ApplicationRecord
  # Relations
  belongs_to :department
  has_many :posts, dependent: :destroy
  has_one :profile
  has_and_belongs_to_many :projects
  
  # Validations
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { minimum: 2 }
  
  # Callbacks
  before_save :normalize_email
  after_create :send_welcome_email
  
  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :recent, -> { where('created_at > ?', 30.days.ago) }
  
  private
  
  def normalize_email
    self.email = email.downcase.strip
  end
  
  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
```

## 10. Guide Pratique des Relations MVC

### Comprendre les Relations dans la Pratique

#### Exemple d'une Structure Complexe
Prenons l'exemple d'une école de cirque avec :
- Des élèves qui peuvent s'inscrire à plusieurs cours
- Des professeurs qui donnent plusieurs cours
- Des salles qui accueillent différents cours
- Un système de paiement et de présence

#### Relations One-to-Many (1-N)
```ruby
# Le plus simple mais crucial à bien comprendre
class Course < ApplicationRecord
  belongs_to :teacher  # Côté "one"
  has_many :students   # Côté "many"
end
```

**Quand l'utiliser ?**
- Un article a plusieurs commentaires
- Un professeur donne plusieurs cours
- Une facture contient plusieurs lignes

#### Relations Many-to-Many (N-N)
```ruby
# Deux façons de le faire :

# 1. Simple avec has_and_belongs_to_many
class Student < ApplicationRecord
  has_and_belongs_to_many :courses
end

# 2. Complexe avec has_many :through
class Student < ApplicationRecord
  has_many :enrollments
  has_many :courses, through: :enrollments
end
```

**Quand utiliser has_many :through ?**
- Quand vous avez besoin d'attributs sur la relation
- Pour ajouter des validations sur l'association
- Pour avoir des callbacks sur l'association

#### Relations Polymorphiques
```ruby
# Exemple : Système de commentaires pour plusieurs types d'objets
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
end

class Course < ApplicationRecord
  has_many :comments, as: :commentable
end

class Blog < ApplicationRecord
  has_many :comments, as: :commentable
end
```

**Quand l'utiliser ?**
- Pour les systèmes de tags
- Pour les commentaires sur différents types d'objets
- Pour les pièces jointes

### Bonnes Pratiques de Validation

#### Validations Contextuelles
```ruby
class Registration < ApplicationRecord
  validates :payment_method, presence: true, on: :payment
  validates :health_certificate, presence: true, on: :enrollment

  # Utilisation
  registration.save(context: :payment)
end
```

#### Validations Conditionnelles
```ruby
class Course < ApplicationRecord
  validates :minimum_age, presence: true, if: :advanced_level?
  validates :parent_consent, presence: true, unless: :adult?

  def advanced_level?
    level == 'advanced'
  end
end
```

#### Gestion des Erreurs

##### Dans les Controllers
```ruby
def create
  @registration = Registration.new(registration_params)
  
  respond_to do |format|
    if @registration.save
      format.turbo_stream { render_success }
    else
      format.turbo_stream { render_errors }
    end
  end
rescue ActiveRecord::RecordInvalid => e
  # Gestion spécifique des erreurs de validation
  log_error(e)
  render_error_response(e)
end
```

##### Dans les Vues
```erb
<%= turbo_frame_tag "registration_form" do %>
  <%= form_with(model: @registration) do |f| %>
    <% if @registration.errors.any? %>
      <div class="error-messages">
        <% @registration.errors.full_messages.each do |msg| %>
          <div class="error-message"><%= msg %></div>
        <% end %>
      </div>
    <% end %>
    
    <!-- Reste du formulaire -->
  <% end %>
<% end %>
```

### Optimisation des Requêtes

#### Eager Loading Intelligent
```ruby
# Mauvais exemple
def index
  @courses = Course.all  # N+1 problème potentiel
end

# Bon exemple
def index
  @courses = Course.includes(:teacher, :room)
                  .with_attached_documents
                  .with_rich_text_description
end
```

#### Utilisation des Scopes
```ruby
class Course < ApplicationRecord
  scope :upcoming, -> { where('start_date > ?', Date.current) }
  scope :with_available_spots, -> { 
    left_joins(:registrations)
      .group(:id)
      .having('COUNT(registrations.id) < courses.capacity')
  }
end
```

### Types de Relations
- `belongs_to`: Relation "appartient à" (côté N de 1-N)
- `has_many`: Relation "possède plusieurs" (côté 1 de 1-N)
- `has_one`: Relation "possède un" (côté 1 de 1-1)
- `has_and_belongs_to_many`: Relation N-N
- `has_many :through`: Relation N-N avec un modèle intermédiaire

### Validations Avancées
```ruby
class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :code, format: { with: /\A[A-Z]{2}\d{3}\z/ }
  validate :price_must_be_lower_than_ceiling
  
  private
  
  def price_must_be_lower_than_ceiling
    if price.present? && price > 1000
      errors.add(:price, "ne peut pas dépasser 1000€")
    end
  end
end
```

## 3. Les Contrôleurs (Controllers)

### Structure de Base
```ruby
class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  
  def index
    @articles = Article.includes(:author, :categories)
                      .published
                      .order(created_at: :desc)
                      .page(params[:page])
    
    respond_to do |format|
      format.html
      format.turbo_stream
      format.json { render json: @articles }
    end
  end
  
  def show
    @comments = @article.comments.includes(:user)
    
    # Rails 8 Turbo Streams
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update("article", partial: "articles/article") }
    end
  end
  
  private
  
  def set_article
    @article = Article.find(params[:id])
  end
  
  def article_params
    params.require(:article)
          .permit(:title, :content, :published, category_ids: [])
  end
end
```

## 4. Les Vues et Hotwire

### Structure des Vues avec Hotwire
```erb
<!-- app/views/articles/index.html.erb -->
<%= turbo_frame_tag "articles_list" do %>
  <div class="articles-grid">
    <% @articles.each do |article| %>
      <%= turbo_frame_tag dom_id(article) do %>
        <%= render "article", article: article %>
      <% end %>
    <% end %>
  </div>
  
  <%= turbo_stream_from "articles" %>
<% end %>
```

### Composants Stimulus
```javascript
// app/javascript/controllers/article_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "output", "submitButton"]
  static values = { 
    successUrl: String,
    errorMessage: String
  }

  async submit(event) {
    event.preventDefault()
    this.submitButtonTarget.disabled = true

    try {
      const response = await fetch(this.formTarget.action, {
        method: "POST",
        body: new FormData(this.formTarget)
      })

      if (response.ok) {
        Turbo.visit(this.successUrlValue)
      } else {
        this.outputTarget.textContent = this.errorMessageValue
      }
    } catch (error) {
      console.error("Erreur:", error)
    } finally {
      this.submitButtonTarget.disabled = false
    }
  }
}
```

### Turbo Streams
```ruby
# app/controllers/articles_controller.rb
def create
  @article = current_user.articles.build(article_params)

  if @article.save
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.append("articles_list", partial: "article", locals: { article: @article }),
          turbo_stream.update("article_count", Article.count),
          turbo_stream.remove("empty_state")
        ]
      end
    end
  end
end
```

## 5. Authentification avec Rails 8

### Configuration de Base
```ruby
# config/initializers/authentication.rb
Rails.application.config.authentication do |config|
  config.authentication_method = :database
  config.allow_guest_access = false
  config.session_timeout = 30.minutes
end
```

### Modèle User avec Authentification
```ruby
class User < ApplicationRecord
  has_secure_password
  
  # Nouvelles fonctionnalités d'authentification Rails 8
  authenticates_with_password do |password|
    BCrypt::Password.new(password_digest).is_password?(password)
  end
  
  # Gestion des sessions
  has_many :sessions, dependent: :destroy
  
  # Validations
  validates :email, presence: true, 
                   uniqueness: true,
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 },
                     if: -> { password.present? }
                     
  # Callbacks
  before_save :ensure_authentication_token
  
  private
  
  def ensure_authentication_token
    self.authentication_token ||= SecureRandom.hex(32)
  end
end
```

## 6. Gestion des Variables et Attributs

### Variables d'Instance (@variable)
Les variables d'instance sont utilisées pour passer des données du contrôleur aux vues :

```ruby
# Dans le contrôleur
class ProfilesController < ApplicationController
  def show
    @user = current_user                    # Accessible dans la vue
    @recent_posts = @user.posts.recent      # Accessible dans la vue
    total_posts = @user.posts.count         # NON accessible dans la vue (variable locale)
  end
end
```

```erb
<!-- Dans la vue -->
<h1>Profil de <%= @user.name %></h1>
<div class="recent-posts">
  <%= render @recent_posts %>
</div>
```

### Symboles et Attributs
```ruby
class Article < ApplicationRecord
  # Symboles pour les relations
  belongs_to :author, class_name: 'User'
  has_many :comments
  
  # Attributs virtuels
  attribute :full_title, :string
  attribute :view_count, :integer, default: 0
  
  # Énumérations
  enum status: {
    draft: 0,
    published: 1,
    archived: 2
  }
  
  # Méthodes utilisant les attributs
  def full_title
    [title, subtitle].compact.join(' - ')
  end
end
```

### Variables Locales dans les Partials
```erb
<!-- app/views/articles/_article.html.erb -->
<div class="article" id="<%= dom_id(article) %>">
  <h2><%= article.title %></h2>
  <p>Par <%= article.author.name %></p>
</div>

<!-- Utilisation du partial -->
<%= render "article", article: @article %>
<%= render partial: "article", collection: @articles %>
```

## 7. Helpers et Services

### Application Helper
```ruby
# app/helpers/application_helper.rb
module ApplicationHelper
  def format_date(date, format = :long)
    return if date.nil?
    
    case format
    when :short
      l(date, format: "%d/%m/%Y")
    when :long
      l(date, format: "%d %B %Y à %H:%M")
    end
  end
  
  def page_title(title = nil)
    base_title = "Mon Application"
    title.present? ? "#{title} | #{base_title}" : base_title
  end
end
```

### Service Objects
```ruby
# app/services/article_creator_service.rb
class ArticleCreatorService
  def initialize(user, params)
    @user = user
    @params = params
  end
  
  def call
    article = @user.articles.build(@params)
    
    if article.save
      notify_subscribers(article)
      generate_social_media_preview(article)
      { success: true, article: article }
    else
      { success: false, errors: article.errors }
    end
  end
  
  private
  
  def notify_subscribers(article)
    article.author.followers.each do |follower|
      NotificationMailer.new_article(follower, article).deliver_later
    end
  end
  
  def generate_social_media_preview(article)
    SocialMediaPreviewJob.perform_later(article)
  end
end
```

## 8. Bonnes Pratiques et Conventions

### Conventions de Nommage
- Models: Singulier, PascalCase (`User`, `Article`)
- Controllers: Pluriel, PascalCase (`UsersController`)
- Tables: Pluriel, snake_case (`users`, `articles`)
- Fichiers: snake_case (`user.rb`, `application_controller.rb`)

### Organisation du Code
```ruby
# app/models/concerns/searchable.rb
module Searchable
  extend ActiveSupport::Concern
  
  included do
    scope :search, ->(query) { where("title LIKE ?", "%#{query}%") }
  end
end

# Utilisation dans les modèles
class Article < ApplicationRecord
  include Searchable
  # ...
end
```

### Sécurité
```ruby
# Protection CSRF
protect_from_forgery with: :exception

# Strong Parameters
def article_params
  params.require(:article)
        .permit(:title, :content, allowed_categories: [])
end

# Authentification et Autorisation
before_action :authenticate_user!
before_action :authorize_user, only: [:edit, :update, :destroy]
```

### Performance
```ruby
# Eager Loading
@articles = Article.includes(:author, :categories)
                  .with_attached_images
                  .recent
                  .page(params[:page])

# Caching
<% cache ["v1", @article] do %>
  <%= render @article %>
<% end %>

# Background Jobs
ArticleProcessingJob.perform_later(@article)
```

## 9. Migrations Complexes et Relations Avancées

### Structure de Base de Données pour un Établissement
```ruby
# Exemple de structure pour le Circographe

# app/db/migrations/YYYYMMDDHHMMSS_create_base_structure.rb
class CreateBaseStructure < ActiveRecord::Migration[8.0]
  def change
    # Table principale des utilisateurs
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.references :role, foreign_key: true
      t.timestamps
    end

    # Gestion des rôles
    create_table :roles do |t|
      t.string :name
      t.jsonb :permissions
      t.timestamps
    end

    # Adhésions
    create_table :memberships do |t|
      t.references :user, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :status
      t.decimal :amount_paid
      t.jsonb :custom_fields
      t.timestamps
    end

    # Abonnements
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :plan, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :payment_status
      t.integer :sessions_count
      t.timestamps
    end

    # Plans d'abonnement
    create_table :plans do |t|
      t.string :name
      t.integer :duration_months
      t.integer :sessions_allowed
      t.decimal :price
      t.timestamps
    end

    # Présences
    create_table :attendances do |t|
      t.references :user, foreign_key: true
      t.references :session, foreign_key: true
      t.datetime :check_in_time
      t.datetime :check_out_time
      t.string :status
      t.timestamps
    end

    # Sessions/Cours
    create_table :sessions do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.integer :capacity
      t.references :instructor, foreign_key: { to_table: :users }
      t.timestamps
    end

    # Transactions comptables
    create_table :accounting_entries do |t|
      t.references :user, foreign_key: true
      t.string :entry_type
      t.decimal :amount
      t.string :payment_method
      t.references :membership, foreign_key: true, null: true
      t.references :subscription, foreign_key: true, null: true
      t.jsonb :metadata
      t.timestamps
    end
  end
end
```

### Modèles avec Relations Complexes
```ruby
# app/models/user.rb
class User < ApplicationRecord
  belongs_to :role
  
  has_many :memberships
  has_many :subscriptions
  has_many :plans, through: :subscriptions
  has_many :attendances
  has_many :attended_sessions, through: :attendances, source: :session
  has_many :instructed_sessions, class_name: 'Session', foreign_key: 'instructor_id'
  has_many :accounting_entries

  # Validations
  validates :email, presence: true, uniqueness: true
  
  # Scopes
  scope :active_members, -> { joins(:memberships).where('memberships.end_date >= ?', Date.current) }
  scope :with_active_subscription, -> { joins(:subscriptions).where('subscriptions.end_date >= ?', Date.current) }
  
  # Méthodes métier
  def active_membership
    memberships.where('end_date >= ?', Date.current).first
  end

  def remaining_sessions
    current_subscription = subscriptions.where('end_date >= ?', Date.current).first
    return 0 unless current_subscription
    current_subscription.sessions_count - attendances.where(subscription: current_subscription).count
  end
end

# app/models/membership.rb
class Membership < ApplicationRecord
  belongs_to :user
  has_many :accounting_entries

  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date
  
  # Callbacks
  after_create :create_accounting_entry
  
  private
  
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    errors.add(:end_date, "doit être après la date de début") if end_date < start_date
  end

  def create_accounting_entry
    accounting_entries.create!(
      user: user,
      entry_type: 'membership_payment',
      amount: amount_paid,
      payment_method: 'direct_debit'
    )
  end
end

# app/models/session.rb
class Session < ApplicationRecord
  belongs_to :instructor, class_name: 'User'
  has_many :attendances
  has_many :attendees, through: :attendances, source: :user

  validates :start_time, :end_time, :capacity, presence: true
  validate :end_time_after_start_time
  validate :instructor_availability
  
  # Scopes
  scope :upcoming, -> { where('start_time > ?', Time.current) }
  scope :with_available_spots, -> { 
    left_joins(:attendances)
      .group(:id)
      .having('COUNT(attendances.id) < sessions.capacity')
  }

  def available_spots
    capacity - attendances.count
  end

  private
  
  def instructor_availability
    conflicting_sessions = instructor.instructed_sessions
      .where('start_time < ? AND end_time > ?', end_time, start_time)
    errors.add(:instructor, "n'est pas disponible sur ce créneau") if conflicting_sessions.exists?
  end
end
```

### Requêtes Complexes avec Active Record
```ruby
# Exemple de requêtes complexes

# Trouver tous les utilisateurs avec leurs adhésions actives et leurs présences
users_with_details = User.includes(:memberships, :attendances)
                        .where('memberships.end_date >= ?', Date.current)
                        .references(:memberships)

# Statistiques de présence par mois
monthly_stats = Attendance.select(
  "DATE_TRUNC('month', check_in_time) as month",
  'COUNT(DISTINCT user_id) as unique_users',
  'COUNT(*) as total_visits'
).group("DATE_TRUNC('month', check_in_time)")

# Revenus par type d'entrée comptable
revenue_by_type = AccountingEntry.select(
  'entry_type',
  'SUM(amount) as total_amount',
  "DATE_TRUNC('month', created_at) as month"
).group(:entry_type, "DATE_TRUNC('month', created_at)")
```

### Conseils pour les Relations Complexes

1. **Utilisation des Index**
```ruby
# Dans les migrations
add_index :attendances, [:user_id, :session_id]
add_index :accounting_entries, [:entry_type, :created_at]
add_index :memberships, [:user_id, :end_date]
```

2. **Optimisation des Requêtes**
```ruby
# Utiliser includes pour éviter les problèmes N+1
@active_users = User.includes(:memberships, :subscriptions)
                   .where(memberships: { status: 'active' })

# Utiliser distinct pour éviter les doublons
@instructors = User.joins(:instructed_sessions)
                  .distinct
                  .select('users.*, COUNT(sessions.id) as sessions_count')
                  .group('users.id')
```

3. **Validation des Données**
```ruby
class AccountingEntry < ApplicationRecord
  validate :valid_reference_entry
  
  private
  
  def valid_reference_entry
    unless membership.present? ^ subscription.present? # XOR operator
      errors.add(:base, "Doit être lié soit à une adhésion soit à un abonnement, pas les deux")
    end
  end
end
```

## 11. Guide Approfondi des Attributs et Variables

### Comprendre les Différents Types de Variables

#### 1. Variables d'Instance (@variable)
- **Usage dans les Controllers** : Pour passer des données aux vues
- **Portée** : Disponible dans le controller et toutes ses vues
- **Bonnes Pratiques** :
  ```ruby
  # ✅ Bon usage
  def show
    @user = User.find(params[:id])      # Pour la vue
    @posts = @user.posts                # Pour la vue
    calculate_statistics                 # Méthode privée
  end
  
  # ❌ Mauvais usage
  def show
    @temp = User.count                  # Variable temporaire inutile
    @user.posts.each do |@post|         # N'utilisez pas @ dans les blocs
  end
  ```

#### 2. Variables Locales (sans @)
- **Usage** : Pour la logique interne ou les partials
- **Portée** : Limitée au bloc ou à la méthode
- **Exemple** :
  ```ruby
  # Dans un partial _user_card.html.erb
  <div class="card">
    <h2><%= user.name %></h2>           # Variable locale
    <p><%= local_assigns[:role] %></p>  # Variable locale optionnelle
  </div>
  
  # Utilisation
  <%= render 'user_card', 
      user: @user,                      # Obligatoire
      role: @user.role.name             # Optionnel
  %>
  ```

### Attributs et Symboles

#### 1. Différence entre :attribut et attribut:
```ruby
class User < ApplicationRecord
  # :name est un symbole - utilisé comme identifiant
  validates :name, presence: true
  
  # name: est un hash key - utilisé pour les options
  scope :by_name, ->(value) { where(name: value) }
end
```

#### 2. Attributs Virtuels
```ruby
class User < ApplicationRecord
  # Attribut virtuel simple
  attr_accessor :terms_accepted
  
  # Attribut virtuel avec type Rails 8
  attribute :full_name, :string
  attribute :login_count, :integer, default: 0
  
  # Attribut calculé
  def full_name
    [first_name, last_name].compact.join(' ')
  end
end
```

### Bonnes Pratiques pour les Attributs

#### 1. Validation des Attributs
```ruby
class User < ApplicationRecord
  # Validations simples
  validates :email, presence: true, uniqueness: true
  
  # Validation conditionnelle
  validates :phone, presence: true, if: :requires_phone?
  
  # Validation personnalisée
  validate :age_must_be_valid
  
  private
  
  def age_must_be_valid
    if age.present? && (age < 0 || age > 150)
      errors.add(:age, "doit être entre 0 et 150")
    end
  end
end
```

#### 2. Callbacks sur Attributs
```ruby
class User < ApplicationRecord
  # Avant sauvegarde
  before_save :normalize_email
  
  # Après modification d'attribut spécifique
  after_update_commit :notify_email_change, if: :saved_change_to_email?
  
  private
  
  def normalize_email
    self.email = email.downcase.strip if email.present?
  end
end
```

### Astuces et Pièges à Éviter

#### 1. Gestion des Attributs Nil
```ruby
# ❌ Risqué
def full_name
  first_name + ' ' + last_name  # Peut lever une erreur si nil
end

# ✅ Sécurisé
def full_name
  [first_name, last_name].compact.join(' ')
end
```

#### 2. Utilisation des Getters/Setters
```ruby
class User < ApplicationRecord
  # ❌ Accès direct aux attributs
  def update_status
    self.status = 'active'
    save
  end
  
  # ✅ Utilisation de méthodes d'accès
  def activate
    update(status: 'active')
  end
end
```

## 12. Cas Pratique : Le Circographe

### Modélisation Métier Spécifique

#### Gestion des Adhésions et Abonnements
- Différence entre adhérent et abonné
- Gestion des périodes d'essai
- Système de cartes multi-entrées
- Forfaits spéciaux (été, trimestre, année)

#### Particularités des Cours
- Cours réguliers vs stages
- Gestion des niveaux
- Limitations d'âge et prérequis
- Matériel nécessaire

#### Exemple de Structure pour un Cours
```ruby
class Course < ApplicationRecord
  # Types de cours
  enum course_type: {
    regular: 0,      # Cours régulier
    workshop: 1,     # Stage
    intensive: 2,    # Stage intensif
    private: 3       # Cours particulier
  }

  # Niveaux de difficulté
  enum level: {
    beginner: 0,
    intermediate: 1,
    advanced: 2,
    all_levels: 3
  }

  # Relations essentielles
  belongs_to :discipline  # Aérien, Acrobatie, etc.
  belongs_to :instructor, class_name: 'User'
  has_many :course_registrations
  has_many :students, through: :course_registrations, source: :user

  # Validations spécifiques
  validates :minimum_age, presence: true, if: :requires_age_check?
  validates :maximum_participants, presence: true
  validate :instructor_qualification
end
```

#### Gestion des Présences
```ruby
class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :course_session
  belongs_to :subscription, optional: true
  belongs_to :pass, optional: true  # Pour les cartes multi-entrées

  before_create :verify_access_rights
  after_create :update_subscription_count

  private

  def verify_access_rights
    return if user.can_attend?(course_session)
    throw(:abort)
  end

  def update_subscription_count
    subscription&.decrement_remaining_sessions!
  end
end
```

#### Système de Facturation
```ruby
class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :payable, polymorphic: true  # Subscription, Pass, ou Membership

  # Types de paiement
  enum payment_type: {
    subscription: 0,
    membership: 1,
    pass: 2,
    workshop: 3
  }

  # Méthodes de paiement
  enum payment_method: {
    card: 0,
    cash: 1,
    transfer: 2,
    check: 3
  }

  # Statuts de paiement
  enum status: {
    pending: 0,
    completed: 1,
    failed: 2,
    refunded: 3
  }
end
```