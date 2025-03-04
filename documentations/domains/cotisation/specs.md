# Spécifications Techniques - Cotisations

## Identification du document

| Domaine           | Cotisation                           |
|-------------------|--------------------------------------|
| Version           | 1.1                                  |
| Référence         | SPEC-COT-2024-01                     |
| Dernière révision | Mars 2024                           |

## Vue d'ensemble

Ce document définit les spécifications techniques pour le domaine "Cotisation" du système Circographe. Il décrit le modèle de données, les validations, les API, et les détails d'implémentation nécessaires au développement des fonctionnalités de gestion des cotisations.

## 1. Modèle de données

### 1.1 Entité principale : `Contribution`

#### Attributs

| Attribut             | Type               | Description                                       | Nullable |
|----------------------|--------------------|---------------------------------------------------|----------|
| `id`                 | Integer            | Identifiant unique (géré automatiquement par Rails) | Non      |
| `user_id`            | Integer            | Référence à l'utilisateur (clé étrangère)         | Non      |
| `formula`            | Enum               | Formule (single, card_10, monthly, annual)        | Non      |
| `rate_type`          | Enum               | Type de tarif (normal, reduced)                   | Non      |
| `start_date`         | Date               | Date de début de validité                         | Non      |
| `end_date`           | Date               | Date de fin de validité                           | Non      |
| `status`             | Enum               | Statut (pending, active, expired, cancelled)      | Non      |
| `remaining_entries`  | Integer            | Entrées restantes (pour card_10)                  | Oui      |
| `payment_id`         | Integer            | Référence au paiement (clé étrangère)             | Oui      |
| `created_at`         | DateTime           | Date de création                                  | Non      |
| `updated_at`         | DateTime           | Date de dernière mise à jour                      | Non      |

#### Associations

| Association          | Type               | Description                                       |
|----------------------|--------------------|---------------------------------------------------|
| `user`               | belongs_to         | Utilisateur auquel la cotisation est rattachée    |
| `entries`            | has_many           | Entrées liées à cette cotisation                  |
| `payments`           | has_many           | Paiements liés à cette cotisation                 |
| `cancelled_by`       | belongs_to         | Utilisateur ayant annulé la cotisation            |

### 1.2 Entité secondaire : `ContributionType`

#### Attributs

| Attribut             | Type               | Description                                       | Nullable |
|----------------------|--------------------|---------------------------------------------------|----------|
| `id`                 | Integer            | Identifiant unique (géré automatiquement par Rails) | Non      |
| `name`               | String             | Nom du type de cotisation                         | Non      |
| `code`               | String             | Code unique du type de cotisation                 | Non      |
| `description`        | Text               | Description détaillée                             | Oui      |
| `duration_days`      | Integer            | Durée en jours (null = illimité)                  | Oui      |
| `entries_count`      | Integer            | Nombre d'entrées (null = illimité)                | Oui      |
| `active`             | Boolean            | Si le type est actif                              | Non      |
| `created_at`         | DateTime           | Date de création                                  | Non      |
| `updated_at`         | DateTime           | Date de dernière mise à jour                      | Non      |

### 1.3 Entité secondaire : `ContributionRate`

#### Attributs

| Attribut             | Type               | Description                                       | Nullable |
|----------------------|--------------------|---------------------------------------------------|----------|
| `id`                 | Integer            | Identifiant unique (géré automatiquement par Rails) | Non      |
| `contribution_type_id` | Integer          | Référence au type de cotisation (clé étrangère)   | Non      |
| `rate_type`          | Enum               | Type de tarif (normal, reduced)                   | Non      |
| `amount`             | Decimal            | Montant du tarif                                  | Non      |
| `active`             | Boolean            | Si le tarif est actif                             | Non      |
| `created_at`         | DateTime           | Date de création                                  | Non      |
| `updated_at`         | DateTime           | Date de dernière mise à jour                      | Non      |

### 1.4 Entité tertiaire : `Entry`

#### Attributs

| Attribut             | Type               | Description                                       | Nullable |
|----------------------|--------------------|---------------------------------------------------|----------|
| `id`                 | Integer            | Identifiant unique (géré automatiquement par Rails) | Non      |
| `contribution_id`    | Integer            | Référence à la cotisation (clé étrangère)         | Non      |
| `user_id`            | Integer            | Référence à l'utilisateur (clé étrangère)         | Non      |
| `recorded_by_id`     | Integer            | Admin/bénévole ayant enregistré l'entrée          | Non      |
| `entry_date`         | DateTime           | Date et heure de l'entrée                         | Non      |
| `cancelled`          | Boolean            | Indicateur d'annulation                           | Non      |
| `cancelled_at`       | DateTime           | Date et heure d'annulation                        | Oui      |
| `cancelled_reason`   | String             | Motif d'annulation                                | Oui      |
| `cancelled_by_id`    | Integer            | Admin ayant annulé l'entrée                       | Oui      |
| `created_at`         | DateTime           | Date et heure de création                         | Non      |
| `updated_at`         | DateTime           | Date et heure de dernière modification            | Non      |

#### Associations

| Association          | Type               | Description                                       |
|----------------------|--------------------|---------------------------------------------------|
| `contribution`       | belongs_to         | Cotisation utilisée pour cette entrée             |
| `user`               | belongs_to         | Utilisateur associé à cette entrée                |
| `recorded_by`        | belongs_to         | Utilisateur ayant enregistré l'entrée             |
| `cancelled_by`       | belongs_to         | Utilisateur ayant annulé l'entrée                 |

### 1.5 Entité tertiaire : `Payment`

#### Attributs

| Attribut             | Type               | Description                                       | Nullable |
|----------------------|--------------------|---------------------------------------------------|----------|
| `id`                 | Integer            | Identifiant unique (géré automatiquement par Rails) | Non      |
| `contribution_id`    | Integer            | Référence à la cotisation (clé étrangère)         | Non      |
| `amount`             | Decimal            | Montant du paiement                               | Non      |
| `payment_method`     | Enum               | Méthode de paiement                               | Non      |
| `payment_date`       | Date               | Date du paiement                                  | Non      |
| `status`             | Enum               | Statut du paiement                                | Non      |
| `reference`          | String             | Référence du paiement                             | Oui      |
| `recorded_by_id`     | Integer            | Admin ayant enregistré le paiement                | Non      |
| `created_at`         | DateTime           | Date de création                                  | Non      |
| `updated_at`         | DateTime           | Date de dernière mise à jour                      | Non      |

#### Associations

| Association          | Type               | Description                                       |
|----------------------|--------------------|---------------------------------------------------|
| `contribution`       | belongs_to         | Cotisation associée à ce paiement                 |
| `recorded_by`        | belongs_to         | Utilisateur ayant enregistré le paiement          |

## 2. Implémentation

### 2.1 Modèle `Contribution`

```ruby
class Contribution < ApplicationRecord
  # Énumérations
  enum contribution_type: {
    pass_day: 0,
    entry_pack: 1,
    subscription_quarterly: 2, 
    subscription_annual: 3
  }
  
  enum status: {
    pending: 0,
    active: 1,
    expired: 2,
    cancelled: 3
  }
  
  enum payment_status: {
    pending: 0,
    completed: 1,
    failed: 2
  }
  
  enum payment_method: {
    cash: 0,
    card: 1,
    check: 2,
    installment: 3
  }
  
  # Associations
  belongs_to :user
  belongs_to :cancelled_by, class_name: 'User', optional: true
  has_many :entries, dependent: :nullify
  has_many :payments, dependent: :nullify
  
  # Validations
  validates :contribution_type, presence: true
  validates :status, presence: true
  validates :payment_status, presence: true
  validates :payment_method, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :start_date, presence: true
  validates :entries_count, presence: true, if: :entry_pack?
  validates :entries_left, presence: true, if: :entry_pack?
  validates :end_date, presence: true, if: :subscription?
  
  # Callbacks
  before_validation :set_initial_values, on: :create
  after_create :create_payment_record
  after_save :check_expiration_status
  
  # Scopes
  scope :active, -> { where(status: :active) }
  scope :pending_payment, -> { where(payment_status: :pending) }
  scope :subscriptions, -> { where(contribution_type: [:subscription_quarterly, :subscription_annual]) }
  scope :entry_packs, -> { where(contribution_type: :entry_pack) }
  
  # Méthodes d'instance
  def subscription?
    subscription_quarterly? || subscription_annual?
  end
  
  def active_subscription?
    subscription? && active?
  end
  
  def can_be_used?
    active? && user.has_valid_cirque_membership? && 
    (subscription? || (entry_pack? && entries_left.to_i > 0))
  end
  
  def record_entry!(recorded_by:)
    return false unless can_be_used?
    
    Entry.transaction do
      entries.create!(
        user: user,
        recorded_by: recorded_by,
        entry_date: Time.current
      )
      
      if entry_pack?
        decrement!(:entries_left)
        update_status_if_needed
      end
    end
  end
  
  def cancel!(reason:, cancelled_by:)
    return false if cancelled?
    
    transaction do
      update!(
        status: :cancelled,
        cancelled_at: Time.current,
        cancelled_reason: reason,
        cancelled_by: cancelled_by
      )
      
      # Notify user
      ContributionMailer.cancellation_notification(self).deliver_later
    end
  end
  
  private
  
  def set_initial_values
    self.status ||= :pending
    self.payment_status ||= :pending
    
    if entry_pack?
      self.entries_left = entries_count
      self.end_date = nil
    elsif subscription?
      self.entries_count = nil
      self.entries_left = nil
      self.end_date = calculate_end_date
    end
  end
  
  def calculate_end_date
    return unless start_date
    case contribution_type
    when 'subscription_quarterly'
      start_date + 3.months
    when 'subscription_annual'
      start_date + 1.year
    end
  end
  
  def update_status_if_needed
    if entry_pack? && entries_left.to_i <= 0
      update!(status: :expired)
    elsif subscription? && end_date <= Date.current
      update!(status: :expired)
    end
  end
  
  def create_payment_record
    payments.create!(
      amount: amount,
      payment_method: payment_method,
      payment_date: payment_method == 'installment' ? nil : Date.current,
      status: :pending
    )
  end
end
```

### 2.2 Modèle `Entry`

```ruby
class Entry < ApplicationRecord
  # Associations
  belongs_to :contribution
  belongs_to :user
  belongs_to :recorded_by, class_name: 'User'
  belongs_to :cancelled_by, class_name: 'User', optional: true
  
  # Validations
  validates :entry_date, presence: true
  validates :cancelled, inclusion: { in: [true, false] }
  validates :cancelled_reason, presence: true, if: :cancelled
  validates :cancelled_by_id, presence: true, if: :cancelled
  validates :cancelled_at, presence: true, if: :cancelled
  
  # Scopes
  scope :active, -> { where(cancelled: false) }
  scope :today, -> { where(entry_date: Date.current.all_day) }
  scope :this_week, -> { where(entry_date: Date.current.beginning_of_week..Date.current.end_of_week) }
  
  # Callbacks
  after_create :notify_low_entries_if_needed
  after_create :update_contribution_status
  
  def cancel!(reason:, cancelled_by:)
    return false if cancelled?
    
    transaction do
      update!(
        cancelled: true,
        cancelled_at: Time.current,
        cancelled_reason: reason,
        cancelled_by: cancelled_by
      )
      
      # Si c'est un carnet, on réincrémente le nombre d'entrées
      if contribution.entry_pack?
        contribution.increment!(:entries_left)
      end
    end
  end
  
  private
  
  def notify_low_entries_if_needed
    return unless contribution.entry_pack?
    
    case contribution.entries_left
    when 3, 2, 1
      ContributionMailer.low_entries_notification(contribution).deliver_later
    end
  end
  
  def update_contribution_status
    contribution.send(:update_status_if_needed)
  end
end
```

### 2.3 Modèle `Payment`

```ruby
class Payment < ApplicationRecord
  # Énumérations
  enum payment_method: {
    cash: 0,
    card: 1,
    check: 2
  }
  
  enum status: {
    pending: 0,
    completed: 1,
    failed: 2
  }
  
  # Associations
  belongs_to :contribution
  belongs_to :recorded_by, class_name: 'User'
  
  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_method, presence: true
  validates :payment_date, presence: true, unless: :installment?
  validates :status, presence: true
  
  # Callbacks
  after_save :update_contribution_payment_status, if: :saved_change_to_status?
  
  # Scopes
  scope :pending, -> { where(status: :pending) }
  scope :completed, -> { where(status: :completed) }
  scope :for_date, ->(date) { where(payment_date: date) }
  
  def mark_as_completed!(recorded_by:)
    return false unless pending?
    
    transaction do
      update!(
        status: :completed,
        recorded_by: recorded_by,
        payment_date: Date.current
      )
      
      # Mettre à jour le statut de la cotisation si tous les paiements sont complétés
      contribution.update!(payment_status: :completed) if all_payments_completed?
    end
  end
  
  private
  
  def all_payments_completed?
    contribution.payments.all?(&:completed?)
  end
  
  def update_contribution_payment_status
    if completed?
      contribution.update!(payment_status: :completed) if all_payments_completed?
    elsif failed?
      contribution.update!(payment_status: :failed)
    end
  end
end
```

## 3. Services

### 3.1 `ContributionService`

```ruby
class ContributionService
  def self.create_contribution(user:, type:, payment_method:, amount:, start_date: Date.current)
    return Result.error("User must have valid Cirque membership") unless user.has_valid_cirque_membership?
    
    contribution = Contribution.new(
      user: user,
      contribution_type: type,
      payment_method: payment_method,
      amount: amount,
      start_date: start_date
    )
    
    if contribution.save
      Result.success(contribution)
    else
      Result.error(contribution.errors.full_messages.join(", "))
    end
  end
  
  def self.record_entry(contribution:, recorded_by:)
    return Result.error("Invalid contribution") unless contribution.can_be_used?
    
    if contribution.record_entry!(recorded_by: recorded_by)
      Result.success(contribution.entries.last)
    else
      Result.error("Failed to record entry")
    end
  end
  
  def self.cancel_contribution(contribution:, reason:, cancelled_by:)
    if contribution.cancel!(reason: reason, cancelled_by: cancelled_by)
      Result.success(contribution)
    else
      Result.error("Failed to cancel contribution")
    end
  end
end
```

### 3.2 `PaymentService`

```ruby
class PaymentService
  def self.process_payment(payment:, recorded_by:)
    return Result.error("Payment already processed") if payment.completed?
    
    if payment.mark_as_completed!(recorded_by: recorded_by)
      Result.success(payment)
    else
      Result.error("Failed to process payment")
    end
  end
  
  def self.setup_installment_plan(contribution:, installments:)
    return Result.error("Invalid number of installments") unless [2, 3].include?(installments.size)
    
    Payment.transaction do
      installments.each do |installment|
        contribution.payments.create!(
          amount: installment[:amount],
          payment_method: :check,
          payment_date: installment[:date],
          status: :pending
        )
      end
    end
    
    Result.success(contribution)
  rescue ActiveRecord::RecordInvalid => e
    Result.error(e.message)
  end
end
```

## 4. Jobs

### 4.1 `ContributionExpirationJob`

```ruby
class ContributionExpirationJob < ApplicationJob
  queue_as :default
  
  def perform
    # Expire les abonnements dépassés
    Contribution.active.subscriptions.where("end_date < ?", Date.current).find_each do |contribution|
      contribution.update!(status: :expired)
      ContributionMailer.expiration_notification(contribution).deliver_later
    end
    
    # Notifie les abonnements qui vont expirer dans un mois
    expiring_soon = Contribution.active.subscriptions
                              .where(end_date: Date.current..(Date.current + 1.month))
    
    expiring_soon.find_each do |contribution|
      ContributionMailer.expiration_warning(contribution).deliver_later
    end
  end
end
```

### 4.2 `InstallmentReminderJob`

```ruby
class InstallmentReminderJob < ApplicationJob
  queue_as :default
  
  def perform
    upcoming_payments = Payment.pending
                             .where(payment_date: Date.tomorrow)
    
    upcoming_payments.find_each do |payment|
      PaymentMailer.installment_reminder(payment).deliver_later
    end
  end
end
```

## 5. Politiques d'accès

### 5.1 `ContributionPolicy`

```ruby
class ContributionPolicy < ApplicationPolicy
  def index?
    user.admin? || user.volunteer?
  end
  
  def show?
    user.admin? || user.volunteer? || record.user_id == user.id
  end
  
  def create?
    user.admin? || user.volunteer?
  end
  
  def cancel?
    user.admin?
  end
  
  def extend_validity?
    user.admin?
  end
  
  class Scope < Scope
    def resolve
      if user.admin? || user.volunteer?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
```

### 5.2 `EntryPolicy`

```ruby
class EntryPolicy < ApplicationPolicy
  def create?
    user.admin? || user.volunteer?
  end
  
  def cancel?
    user.admin?
  end
  
  def index?
    user.admin? || user.volunteer?
  end
  
  class Scope < Scope
    def resolve
      if user.admin? || user.volunteer?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end
end
```

## 6. Configuration

### 6.1 Paramètres système

```ruby
# config/initializers/contribution_settings.rb

Rails.application.config.contribution_settings = {
  prices: {
    pass_day: 4,
    entry_pack: 30,
    subscription_quarterly: 65,
    subscription_annual: 150
  },
  
  entry_pack_size: 10,
  
  subscription_durations: {
    quarterly: 3.months,
    annual: 1.year
  },
  
  installment_thresholds: {
    minimum_amount: 50,
    maximum_installments: 3
  },
  
  notifications: {
    expiration_warning: 1.month,
    low_entries_threshold: 3
  }
}
```

## 7. Intégration

### 7.1 Webhooks

```ruby
# app/controllers/api/webhooks/payment_controller.rb

module Api
  module Webhooks
    class PaymentController < ApplicationController
      def sumup
        payment = Payment.find_by!(reference: params[:payment_id])
        
        if params[:status] == "PAID"
          PaymentService.process_payment(
            payment: payment,
            recorded_by: SystemUser.instance
          )
        else
          payment.update!(status: :failed)
        end
        
        head :ok
      end
    end
  end
end
```

## 8. Performance

### 8.1 Indexation

```ruby
# db/migrate/YYYYMMDDHHMMSS_add_indices_to_contributions.rb

class AddIndicesToContributions < ActiveRecord::Migration[7.0]
  def change
    add_index :contributions, [:user_id, :status]
    add_index :contributions, [:contribution_type, :status]
    add_index :contributions, :payment_status
    add_index :entries, [:contribution_id, :cancelled]
    add_index :entries, [:user_id, :entry_date]
    add_index :payments, [:contribution_id, :status]
  end
end
```

### 8.2 Cache

```ruby
# app/models/contribution.rb

class Contribution < ApplicationRecord
  # ...
  
  def entries_count_cache_key
    "contribution/#{id}/entries_count"
  end
  
  def total_entries_count
    Rails.cache.fetch(entries_count_cache_key, expires_in: 1.hour) do
      entries.active.count
    end
  end
  
  # Invalidation du cache
  after_touch do
    Rails.cache.delete(entries_count_cache_key)
  end
end
```

## 9. Monitoring

### 9.1 Métriques

```ruby
# config/initializers/metrics.rb

CONTRIBUTION_METRICS = [
  {
    name: 'contributions.created',
    type: 'counter',
    description: 'Number of contributions created'
  },
  {
    name: 'entries.recorded',
    type: 'counter',
    description: 'Number of entries recorded'
  },
  {
    name: 'payments.processed',
    type: 'counter',
    description: 'Number of payments processed'
  }
]

# Utilisation dans les modèles
after_create_commit do
  METRICS.increment('contributions.created', tags: { type: contribution_type })
end
```

## 10. Tests

Les tests unitaires et d'intégration sont essentiels. Voir le fichier de validation pour les scénarios de test détaillés. 