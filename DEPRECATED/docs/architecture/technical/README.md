# Le Circographe

## Vue d'Ensemble

### Terminologie Clé
| Terme            | Description |
|------------------|-------------|
| Adhésion Basic   | Statut membre de base (1€/an) |
| Adhésion Cirque  | Statut membre pratiquant (10€/an) |
| Cotisation       | Abonnement aux entraînements |
| Carnet           | Lot de séances prépayées |
| Pointage         | Enregistrement des présences |

### Rôles Utilisateurs
- **Guest** : Lecture seule, données publiques
- **Member** : Accès personnel limité
- **Volunteer** : Gestion présences (hors réunions)
- **Admin** : Accès complet

## Architecture Rails 8

### Structure MVC
```ruby
# app/models/user.rb
class User < ApplicationRecord
  include Trackable
  include Analyzable
  
  has_many :memberships
  has_many :payments
  has_many :attendances
  has_many :subscriptions
  has_many :notifications, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  
  enum role: { guest: 0, member: 1, volunteer: 2, admin: 3 }
  
  broadcasts_to ->(user) { :users }
  after_update_commit -> { broadcast_replace_to self }
  after_create_commit -> { broadcast_prepend_to :users }
  
  def active_membership_of_type(type)
    memberships.active.find_by(type: type)
  end
  
  def can_attend?(daily_list)
    return false unless active_membership_of_type('basic')
    return true unless daily_list.training?
    active_membership_of_type('circus')&.subscription&.valid_for_attendance?
  end

  def notify(title:, body:, level: :info)
    notifications.create!(
      title: title,
      body: body,
      level: level
    ).broadcast_append_to(
      self,
      target: "notifications",
      partial: "notifications/notification"
    )
  end
end
```

### Concerns Partagés

```ruby
# app/models/concerns/trackable.rb
module Trackable
  extend ActiveSupport::Concern
  
  included do
    has_many :activity_logs, as: :trackable
    
    after_create  -> { track_activity("created") }
    after_update  -> { track_activity("updated", changes: saved_changes) }
    after_destroy -> { track_activity("deleted") }
  end
  
  private
  
  def track_activity(action, metadata = {})
    activity_logs.create!(
      user: Current.user,
      action: action,
      metadata: metadata,
      ip_address: Current.request&.ip
    )
  end
end

# app/models/concerns/analyzable.rb
module Analyzable
  extend ActiveSupport::Concern
  
  included do
    has_many :metrics, as: :measurable
    after_commit :update_metrics
  end
  
  def record_metric(key, value, metadata = {})
    metrics.create!(
      key: key,
      value: value,
      metadata: metadata,
      recorded_at: Time.current
    )
  end
end
```

### Bonnes Pratiques
- Models : Logique métier et validations
- Controllers : Coordination et autorisations
- Views : Présentation avec Hotwire/Turbo
- Services : Logique complexe isolée

## Logique Métier

### Adhésions

- **Basic** (1€/an)
  * Accès événements, assemblées, newsletter
  * Une seule adhésion active à la fois
  * Obligatoire pour toute activité

- **Cirque** (10€/an, 7€ tarif réduit)
  * Requiert une adhésion Basic active
  * Accès aux entraînements
  * Historique personnel
  * Justificatif pour tarif réduit

```ruby
class Membership < ApplicationRecord
  TYPES = {
    basic: { 
      price: 1, 
      features: [:events, :assemblies, :newsletter] 
    },
    circus: { 
      price: 10, 
      reduced_price: 7, 
      features: [:training_access],
      requires: :basic
    }
  }
  
  belongs_to :user
  has_many :payments
  has_many :attendances
  has_one :subscription, dependent: :restrict_with_error
  
  validates :type, inclusion: { in: TYPES.keys.map(&:to_s) }
  validate :one_active_per_type, :requires_basic_for_circus
  
  scope :active, -> { where("expires_at > ?", Time.current) }
  scope :expiring_soon, -> { active.where("expires_at <= ?", 30.days.from_now) }
end
```

### Cotisations

- **Types disponibles**
  * Séance unique (4€, valable jour même)
  * Carnet 10 séances (validité illimitée)
  * Trimestriel (3 mois de date à date)
  * Annuel (12 mois de date à date)

```ruby
class Subscription < ApplicationRecord
  TYPES = {
    single: { price: 4, duration: 1.day },
    pack_10: { price: 35, sessions: 10 },
    quarterly: { price: 90, duration: 3.months },
    yearly: { price: 300, duration: 1.year }
  }
  
  belongs_to :user
  belongs_to :membership
  has_many :attendances
  
  validates :type, inclusion: { in: TYPES.keys.map(&:to_s) }
  validate :requires_circus_membership
  
  def valid_for_attendance?
    case type
    when 'single' then valid_until > Time.current
    when 'pack_10' then remaining_sessions.positive?
    else valid_until > Time.current
    end
  end
end
```

### Paiements

- **Méthodes** : CB (SumUp), Espèces, Chèque
- **Options** : 
  * Paiement en plusieurs fois si montant > 50€
  * Maximum 3 mensualités
  * Donations possibles sur tout paiement
  * Reçus automatiques (PDF)

```ruby
class Payment < ApplicationRecord
  include Cacheable
  
  METHODS = %w[card cash check]
  INSTALLMENT_THRESHOLD = 50
  MAX_INSTALLMENTS = 3
  
  belongs_to :user
  belongs_to :payable, polymorphic: true, optional: true
  has_many :installments
  has_one_attached :receipt
  
  validates :amount, numericality: { greater_than: 0 }
  validate :installments_allowed
  
  broadcasts_to ->(payment) { [payment.user, "payments"] }
  after_create_commit -> { process_payment_async }
  after_update_commit -> { broadcast_replace_later_to [user, "payments"] }
  after_destroy_commit -> { broadcast_remove_to [user, "payments"] }
  
  def process_payment_async
    PaymentProcessJob.perform_later(self)
    broadcast_append_to(
      [user, "payments"],
      target: "payment_list",
      partial: "payments/payment",
      locals: { payment: self }
    )
    broadcast_update_to(
      user,
      target: "payment_status",
      partial: "payments/status",
      locals: { status: "processing" }
    )
  end
  
  def generate_receipt
    ReceiptGenerationJob.perform_later(self)
    notify_user_about_receipt
    broadcast_update_to(
      user,
      target: "receipt_status",
      partial: "payments/receipt_status",
      locals: { status: "generating" }
    )
  end
  
  private
  
  def notify_user_about_receipt
    user.notify(
      title: "Reçu en cours de génération",
      body: "Votre reçu sera bientôt disponible",
      level: :info
    ).broadcast_append_to(
      user,
      target: "notifications",
      partial: "notifications/notification"
    )
  end
  
  def installments_allowed
    return unless installments.any?
    
    if amount < INSTALLMENT_THRESHOLD
      errors.add(:base, "Le paiement en plusieurs fois n'est possible qu'à partir de #{INSTALLMENT_THRESHOLD}€")
    end
    
    if installments.count > MAX_INSTALLMENTS
      errors.add(:base, "Maximum #{MAX_INSTALLMENTS} paiements possibles")
    end
  end

  def calculate_stats
    Rails.cache.fetch([self, "payment_stats"], expires_in: 1.hour) do
      {
        total_amount: amount + (donation_amount || 0),
        installments_count: installments.count,
        status: status,
        payment_method: payment_method
      }
    end
  end
end
```

### Présences et Activités

- **Types de Listes**
  * Entraînement Libre (volunteer + admin)
  * Événement (volunteer + admin)
  * Réunion (admin uniquement)

```ruby
class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :daily_list
  belongs_to :subscription, optional: true
  
  validates :user_id, uniqueness: { scope: :daily_list_id }
  validate :user_has_valid_membership
  validate :user_has_valid_subscription, if: :training_session?
  
  after_create :update_statistics
  after_create :notify_admins_if_full
  after_create :decrement_pack_sessions, if: :pack_subscription?
end

class DailyList < ApplicationRecord
  TYPES = %w[training event meeting]
  
  has_many :attendances
  has_many :users, through: :attendances
  has_one :daily_stat, dependent: :destroy
  
  validates :date, presence: true, uniqueness: true
  validates :type, inclusion: { in: TYPES }
  
  scope :recent, -> { where(date: 2.weeks.ago..) }
  scope :with_stats, -> { includes(:daily_stat, :attendances) }
  
  def full?
    attendances.count >= max_capacity
  end
end
```

## Implémentation

### Traçabilité
Tout objet important hérite de ces comportements :
```ruby
include Trackable   # Audit des changements
include Analyzable  # Métriques et statistiques
```

### Interface
- Turbo pour les mises à jour en temps réel
- Tailwind/Flowbite pour l'UI
- Composants Ruby réutilisables
- PWA pour accès mobile

### Base de Données
- SQLite3 avec vues matérialisées pour les stats
- Redis pour le cache et les jobs
- Indexation optimisée des relations
- Statistiques quotidiennes et mensuelles

### Monitoring et Statistiques

```ruby
# app/models/daily_stat.rb
class DailyStat < ApplicationRecord
  belongs_to :daily_list
  
  def self.calculate_for(daily_list)
    stats = new(daily_list: daily_list)
    stats.total_attendees = daily_list.attendances.count
    stats.member_types = daily_list.users.group(:role).count
    stats.subscription_types = daily_list.attendances
      .joins(subscription: :type)
      .group('subscriptions.type')
      .count
    stats.save!
  end
end

# app/models/metric.rb
class Metric < ApplicationRecord
  belongs_to :measurable, polymorphic: true
  
  scope :last_30_days, -> { where(recorded_at: 30.days.ago..) }
  scope :by_key, ->(key) { where(key: key) }
  
  def self.average_for(key, timeframe = 30.days.ago..)
    where(key: key, recorded_at: timeframe).average(:value)
  end
end
```

### Sécurité
- Authentification native Rails 8
- Autorisations par rôles
- Audit complet des actions
- Protection anti-doublon
- Validation des sessions

## Performance
```ruby
# app/models/concerns/cacheable.rb
module Cacheable
  extend ActiveSupport::Concern
  
  included do
    after_commit :clear_cache
  end

  class_methods do
    def cached_find(id)
      Rails.cache.fetch([name, id], expires_in: 1.hour) do
        find(id)
      end
    end

    def cached_count
      Rails.cache.fetch([name, "count"], expires_in: 5.minutes) do
        count
      end
    end
  end

  private

  def clear_cache
    Rails.cache.delete([self.class.name, id])
  end
end

# Optimisations des modèles principaux
class User < ApplicationRecord
  include Cacheable
  
  # Cache des adhésions actives
  def active_memberships
    Rails.cache.fetch([self, "active_memberships"], expires_in: 1.hour) do
      memberships.active.includes(:payments, :subscription).to_a
    end
  end
end

class DailyList < ApplicationRecord
  include Cacheable
  
  # Eager loading optimisé
  scope :with_complete_data, -> {
    includes(
      attendances: {
        user: [:memberships, :subscriptions],
        subscription: :payments
      }
    )
  }
  
  # Cache des statistiques
  def cached_stats
    Rails.cache.fetch([self, "stats"], expires_in: 15.minutes) do
      calculate_stats
    end
  end
end

# Configuration Redis pour le cache
config.cache_store = :redis_cache_store, {
  url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1"),
  connect_timeout: 30,
  read_timeout: 0.2,
  write_timeout: 0.2,
  error_handler: -> (method:, returning:, exception:) {
    Raven.capture_exception(exception, level: "warning")
  }
}

# Indexes optimisés
add_index :attendances, [:user_id, :daily_list_id]
add_index :memberships, [:user_id, :type, :expires_at]
add_index :payments, [:payable_type, :payable_id, :created_at]
```

## Monitoring et Jobs
```ruby
class ApplicationJob < ActiveJob::Base
  retry_on StandardError, wait: :exponentially_longer, attempts: 5
  discard_on ActiveRecord::RecordNotFound

  around_perform do |job, block|
    start = Time.current
    block.call
    duration = Time.current - start
    
    StatsD.timing("jobs.#{job.class.name}.duration", duration)
    StatsD.increment("jobs.#{job.class.name}.success")
  end

  rescue_from(StandardError) do |exception|
    StatsD.increment("jobs.#{self.class.name}.failure")
    raise exception
  end
end

# Configuration Skylight pour le monitoring
Skylight.configure do |config|
  config.enable_segments!
  config.enable_sidekiq!
  config.ignored_endpoints = %w[RailsAdmin::Engine]
end
```

## Développement

```bash
# Installation
git clone git@github.com:organization/circographe.git
cd circographe
bundle install
rails db:setup

# Lancement
bin/dev

# Tests
rspec                 # Tous les tests
rspec spec/models    # Tests des modèles
rspec spec/system    # Tests d'intégration
```

## Ressources
- [Rails 8.0 Guides](https://guides.rubyonrails.org/)
- [Hotwire](https://hotwired.dev/)
- [Flowbite](https://flowbite.com/docs/components/) 