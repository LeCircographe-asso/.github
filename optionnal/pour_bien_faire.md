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
9. [Migrations Complexes et Relations Avancées](#9-migrations-complexes-et-relations-avancées)
10. [Guide Pratique des Relations MVC](#10-guide-pratique-des-relations-mvc)
11. [Guide Approfondi des Attributs et Variables](#11-guide-approfondi-des-attributs-et-variables)
12. [Cas Pratique : Le Circographe](#12-cas-pratique-le-circographe)

## 1. Architecture MVC

### Principes Fondamentaux
L'architecture MVC dans Rails 8 sépare votre application en trois composants principaux :

- **Model (M)**: Gère les données, la logique métier et les règles de l'application
- **View (V)**: S'occupe de la présentation et de l'interface utilisateur
- **Controller (C)**: Coordonne les interactions entre le Model et la View

> **Clarification**: MVC est un pattern architectural qui permet de séparer les préoccupations et de maintenir un code propre et organisé.

#### ✅ Bonnes pratiques MVC
- Garder la logique métier dans les modèles
- Les contrôleurs doivent être minces, servant uniquement de coordination
- Les vues ne doivent contenir que la logique de présentation

```ruby
# ✅ Bon exemple: Logique métier dans le modèle
class Order < ApplicationRecord
  def total_with_tax
    line_items.sum(&:price) * (1 + tax_rate)
  end
end

# Contrôleur qui reste mince
class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
    @total = @order.total_with_tax
  end
end
```

#### ❌ Mauvaises pratiques MVC
- Placer la logique métier dans les contrôleurs
- Effectuer des requêtes de base de données dans les vues
- Mélanger la logique de présentation dans les modèles

```ruby
# ❌ Mauvais exemple: Logique métier dans le contrôleur
class OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
    # La logique métier ne devrait pas être ici
    @total = @order.line_items.sum(&:price) * (1 + @order.tax_rate)
  end
end
```

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
# ✅ Bon exemple: Modèle bien structuré avec scopes et validations
class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :content, presence: true
  
  scope :published, -> { where(published: true) }
  scope :recent, -> { order(created_at: :desc).limit(5) }
  
  before_save :normalize_title
  
  private
  
  def normalize_title
    self.title = title.titleize
  end
end
```

# ✅ Bon exemple: Modèle avec relations complexes bien définies
class User < ApplicationRecord
  # Relations claires et bidirectionnelles
  belongs_to :role
  has_many :memberships, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :plans, through: :subscriptions
  
  # Relation avec alias pour clarté
  has_many :instructed_sessions, class_name: 'Session', foreign_key: 'instructor_id'
  has_many :attendances
  has_many :attended_sessions, through: :attendances, source: :session
  
  # Scopes qui utilisent les relations
  scope :with_active_membership, -> { 
    joins(:memberships).where('memberships.expires_on >= ?', Date.current)
  }
end

## 3. Les Contrôleurs (Controllers)

### Structure de Base
```ruby
# ✅ Bon exemple: Contrôleur bien structuré
class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    @articles = Article.published.includes(:user, :categories).page(params[:page])
    
    respond_to do |format|
      format.html
      format.json { render json: @articles }
      format.turbo_stream
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
    params.require(:article).permit(:title, :content, :published)
  end
end
```

## 4. Les Vues et Hotwire

### Structure des Vues avec Hotwire
```erb
<!-- app/views/articles/index.html.erb -->
<div id="articles">
  <%= render @articles %>
</div>

<%= turbo_frame_tag "new_article" do %>
  <%= link_to "Nouvel article", new_article_path %>
<% end %>

<%= turbo_stream_from "articles" %>
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
      format.turbo_stream
      format.html { redirect_to @article }
    end
  else
    render :new, status: :unprocessable_entity
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
# ✅ Bon exemple: Authentication sécurisée
# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, allow_nil: true
  
  before_save :downcase_email
  
  private
  
  def downcase_email
    self.email = email.downcase if email.present?
  end
end

# app/controllers/sessions_controller.rb
def create
  user = User.find_by(email: params[:email].downcase)
  
  if user&.authenticate(params[:password])
    session = user.sessions.create!(
      token: SecureRandom.urlsafe_base64(32),
      expires_at: 2.weeks.from_now,
      user_agent: request.user_agent,
      ip_address: request.ip
    )
    
    cookies.encrypted[:session_token] = {
      value: session.token,
      expires: session.expires_at,
      httponly: true,
      secure: Rails.env.production?
    }
    
    redirect_to root_path, notice: "Connexion réussie"
  else
    flash.now[:alert] = "Email ou mot de passe incorrect"
    render :new, status: :unprocessable_entity
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
# ✅ Bon exemple: Utilisation de symboles et attributs
class Product < ApplicationRecord
  # Symboles comme identifiants
  enum status: { draft: 0, published: 1, archived: 2 }
  
  # Attributs virtuels typés
  attribute :full_price, :decimal
  attribute :sale_active, :boolean, default: false
  
  # Méthodes qui définissent les attributs virtuels
  def full_price
    price * (1 + tax_rate)
  end
  
  # Utilisation cohérente des symboles comme clés
  def search_options
    {
      status: status,
      category_ids: categories.pluck(:id),
      in_stock: inventory_count > 0
    }
  end
end
```

### Variables Locales dans les Partials
```erb
<!-- app/views/articles/_article.html.erb -->
<div class="article" id="<%= dom_id(article) %>">
  <h2><%= article.title %></h2>
  <% if article.published? %>
    <span class="badge badge-success">Publié</span>
  <% else %>
    <span class="badge badge-warning">Brouillon</span>
  <% end %>
  
  <!-- Logique métier dans la vue -->
  <p>Publié il y a <%= (Time.current - article.published_at) / 86400 %> jours</p>
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
  # Format une date selon le format spécifié
  # @param date [Date, DateTime] la date à formater
  # @param format [Symbol] le format (:short, :long, :relative)
  # @return [String] la date formatée
  def format_date(date, format = :short)
    return unless date
    
    case format
    when :short
      l(date, format: "%d/%m/%Y")
    when :long
      l(date, format: "%d %B %Y à %H:%M")
    when :relative
      time_ago_in_words(date)
    end
  end
  
  # Génère un titre de page avec le nom de l'app
  def page_title(title = nil)
    base = "Le Circographe"
    title.present? ? "#{title} | #{base}" : base
  end
end
```

### Service Objects
```ruby
# ✅ Bon exemple: Service bien structuré
class OrderProcessor
  def initialize(order, payment_params)
    @order = order
    @payment_params = payment_params
  end
  
  def call
    return failure("Commande déjà payée") if @order.paid?
    
    ActiveRecord::Base.transaction do
      process_payment
      update_inventory
      send_confirmation
      
      success(@order, "Paiement traité avec succès")
    end
  rescue Payment::ProcessingError => e
    failure(e.message)
  end
  
  private
  
  def process_payment
    @payment = Payment.create!(@payment_params.merge(order: @order))
    @order.update!(status: 'paid', paid_at: Time.current)
  end
  
  def update_inventory
    @order.line_items.each do |item|
      item.product.decrement!(:inventory_count, item.quantity)
    end
  end
  
  def send_confirmation
    OrderMailer.confirmation(@order).deliver_later
  end
  
  def success(order, message)
    { success: true, order: order, message: message }
  end
  
  def failure(message)
    { success: false, message: message }
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
# ✅ Bon exemple: Organisation avec concerns et namespaces
# app/models/concerns/searchable.rb
module Searchable
  extend ActiveSupport::Concern
  
  included do
    scope :search, ->(term) { where("title LIKE ?", "%#{term}%") }
  end
end

# app/models/article.rb
class Article < ApplicationRecord
  include Searchable
  # Le modèle hérite du comportement de recherche
end

# app/controllers/admin/articles_controller.rb
module Admin
  class ArticlesController < AdminController
    # Interface d'administration séparée
  end
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
class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :members do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.references :membership_type, null: false, foreign_key: true
      t.date :joined_on, null: false
      t.date :expires_on
      t.jsonb :preferences, default: {}, null: false
      
      t.timestamps
    end
    
    add_index :members, [:last_name, :first_name]
    add_index :members, :expires_on, where: "expires_on IS NOT NULL"
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
