# Spécifications Techniques - Notification

## Identification du document

| Domaine           | Notification                         |
|-------------------|-------------------------------------|
| Version           | 1.1                                 |
| Référence         | SPEC-NOT-2024-01                    |
| Dernière révision | Mars 2024                           |

## Vue d'ensemble

Ce document définit les spécifications techniques pour l'implémentation du système de notification du Circographe. Conformément aux besoins opérationnels, le système se concentre sur deux canaux de communication principaux : les emails et les notifications push/in-app.

## 1. Modèles de données

### 1.1 Modèle `Notification`

#### Attributs principaux
| Attribut        | Type           | Description                                                      | Contraintes                 |
|-----------------|----------------|------------------------------------------------------------------|----------------------------|
| id              | Integer        | Identifiant unique                                               | PK, Auto-increment         |
| user_id         | Integer        | Destinataire de la notification                                  | FK, Not Null              |
| title           | String         | Titre court de la notification                                   | Not Null, Max 100 chars   |
| content         | Text           | Contenu détaillé                                                 | Not Null                  |
| notification_type | Enum         | Type de notification (adhésion, cotisation, paiement, etc.)      | Not Null                  |
| importance_level | Enum         | Niveau d'importance (critique, important, informatif, optionnel) | Not Null                  |
| source_type     | Enum          | Source (système, administratif, événementiel, communautaire)     | Not Null                  |
| reference_id    | Integer       | ID de l'objet lié (adhésion, cotisation, etc.)                  | Nullable                  |
| reference_type  | String        | Type de l'objet lié                                             | Nullable                  |
| action_url      | String        | URL d'action suggérée                                           | Nullable                  |
| action_text     | String        | Texte du bouton d'action                                        | Nullable                  |
| expiration_date | DateTime      | Date d'expiration de la notification                            | Nullable                  |
| created_at      | DateTime      | Date de création                                                | Not Null, Default: now    |
| updated_at      | DateTime      | Date de dernière modification                                   | Not Null, Default: now    |

#### Implémentation
```ruby
class Notification < ApplicationRecord
  belongs_to :user
  has_many :notification_deliveries, dependent: :destroy
  
  enum notification_type: {
    membership: 0,
    contribution: 1,
    payment: 2,
    attendance: 3,
    role: 4,
    system: 5,
    administrative: 6,
    event: 7
  }
  
  enum importance_level: {
    critical: 0,
    important: 1,
    informative: 2,
    optional: 3
  }
  
  enum source_type: {
    system: 0,
    administrative: 1,
    event: 2,
    community: 3
  }
  
  validates :title, :content, :notification_type, :importance_level, :source_type, presence: true
  validates :title, length: { maximum: 100 }
  validates :action_text, presence: true, if: -> { action_url.present? }
  
  scope :unread, -> { joins(:notification_deliveries).where(notification_deliveries: { read_at: nil }) }
  scope :active, -> { where("expiration_date IS NULL OR expiration_date > ?", Time.current) }
  scope :by_importance, -> (level) { where(importance_level: level) }
  scope :for_user, -> (user_id) { where(user_id: user_id) }
  scope :recent, -> { order(created_at: :desc) }
  
  def mark_as_read!
    notification_deliveries.each(&:mark_as_read!)
  end
  
  def read?
    notification_deliveries.all?(&:read?)
  end
end
```

### 1.2 Modèle `NotificationDelivery`

#### Attributs principaux
| Attribut        | Type           | Description                                      | Contraintes                 |
|-----------------|----------------|--------------------------------------------------|----------------------------|
| id              | Integer        | Identifiant unique                               | PK, Auto-increment         |
| notification_id | Integer        | Référence à la notification                      | FK, Not Null              |
| channel         | Enum           | Canal utilisé (email, push)                      | Not Null                  |
| status          | Enum           | Statut de l'envoi                                | Not Null, Default: pending |
| sent_at         | DateTime       | Date d'envoi                                     | Nullable                  |
| delivered_at    | DateTime       | Date de réception                                | Nullable                  |
| read_at         | DateTime       | Date de lecture                                  | Nullable                  |
| error_message   | String         | Message d'erreur en cas d'échec                  | Nullable                  |
| retry_count     | Integer        | Nombre de tentatives effectuées                  | Not Null, Default: 0     |
| created_at      | DateTime       | Date de création                                 | Not Null, Default: now   |
| updated_at      | DateTime       | Date de dernière modification                    | Not Null, Default: now   |

#### Implémentation
```ruby
class NotificationDelivery < ApplicationRecord
  belongs_to :notification
  
  enum channel: {
    email: 0,
    push: 1
  }
  
  enum status: {
    pending: 0,
    sent: 1,
    delivered: 2,
    failed: 3,
    read: 4
  }
  
  validates :channel, :status, presence: true
  validates :retry_count, numericality: { greater_than_or_equal_to: 0 }
  
  scope :pending, -> { where(status: :pending) }
  scope :failed, -> { where(status: :failed) }
  scope :read, -> { where.not(read_at: nil) }
  scope :unread, -> { where(read_at: nil) }
  
  def mark_as_read!
    update(status: :read, read_at: Time.current)
  end
  
  def read?
    read_at.present?
  end
  
  def mark_as_sent!
    update(status: :sent, sent_at: Time.current)
  end
  
  def mark_as_delivered!
    update(status: :delivered, delivered_at: Time.current)
  end
  
  def mark_as_failed!(error_message = nil)
    update(status: :failed, error_message: error_message)
  end
  
  def increment_retry_count!
    increment!(:retry_count)
  end
end
```

### 1.3 Modèle `NotificationPreference`

#### Attributs principaux
| Attribut            | Type           | Description                                      | Contraintes                 |
|---------------------|----------------|--------------------------------------------------|----------------------------|
| id                  | Integer        | Identifiant unique                               | PK, Auto-increment         |
| user_id             | Integer        | Référence à l'utilisateur                        | FK, Not Null              |
| notification_type   | Enum           | Type de notification                             | Not Null                  |
| email_enabled       | Boolean        | Activation des emails                            | Not Null, Default: true   |
| push_enabled        | Boolean        | Activation des notifications push                | Not Null, Default: true   |
| quiet_hours_start   | Time           | Début des heures de silence                      | Nullable                  |
| quiet_hours_end     | Time           | Fin des heures de silence                        | Nullable                  |
| created_at          | DateTime       | Date de création                                 | Not Null, Default: now   |
| updated_at          | DateTime       | Date de dernière modification                    | Not Null, Default: now   |

#### Implémentation
```ruby
class NotificationPreference < ApplicationRecord
  belongs_to :user
  
  enum notification_type: {
    membership: 0,
    contribution: 1,
    payment: 2,
    attendance: 3,
    role: 4,
    system: 5,
    administrative: 6,
    event: 7
  }
  
  validates :notification_type, presence: true
  validates :email_enabled, :push_enabled, inclusion: { in: [true, false] }
  validate :quiet_hours_consistency
  
  scope :for_user, -> (user_id) { where(user_id: user_id) }
  
  def self.create_defaults_for(user)
    notification_type.keys.each do |type|
      user.notification_preferences.find_or_create_by!(
        notification_type: type,
        email_enabled: true,
        push_enabled: true
      )
    end
  end
  
  private
  
  def quiet_hours_consistency
    if quiet_hours_start.present? ^ quiet_hours_end.present?
      errors.add(:base, "Les heures de début et de fin de silence doivent être définies ensemble")
    end
  end
end
```

## 2. Services

### 2.1 `NotificationService`

Service central pour la création et l'envoi des notifications.

```ruby
class NotificationService
  def self.create_notification(user:, title:, content:, notification_type:, importance_level:, source_type:, reference: nil, action: nil, expiration_date: nil)
    # Vérifier les préférences de l'utilisateur
    return false unless should_notify?(user, notification_type, importance_level)
    
    # Créer la notification
    notification = Notification.create!(
      user: user,
      title: title,
      content: content,
      notification_type: notification_type,
      importance_level: importance_level,
      source_type: source_type,
      reference_id: reference&.id,
      reference_type: reference&.class&.name,
      action_url: action&.fetch(:url, nil),
      action_text: action&.fetch(:text, nil),
      expiration_date: expiration_date
    )
    
    # Créer les demandes d'envoi selon les préférences
    create_deliveries(notification, user)
    
    # Envoi immédiat pour les notifications critiques
    if notification.critical?
      NotificationDeliveryJob.perform_now(notification.id)
    else
      NotificationDeliveryJob.perform_later(notification.id)
    end
    
    notification
  end
  
  private
  
  def self.should_notify?(user, type, importance)
    return true if importance == :critical
    
    prefs = user.notification_preferences.find_by(notification_type: type)
    return true unless prefs # Pas de préférences = notifications activées
    
    # Vérifier les heures de silence
    if prefs.quiet_hours_start.present?
      current_time = Time.current.strftime("%H:%M")
      quiet_start = prefs.quiet_hours_start.strftime("%H:%M")
      quiet_end = prefs.quiet_hours_end.strftime("%H:%M")
      
      return false if current_time >= quiet_start && current_time <= quiet_end
    end
    
    prefs.email_enabled? || prefs.push_enabled?
  end
  
  def self.create_deliveries(notification, user)
    prefs = user.notification_preferences.find_by(notification_type: notification.notification_type)
    
    if prefs&.email_enabled? || notification.critical?
      notification.notification_deliveries.create!(channel: :email)
    end
    
    if prefs&.push_enabled? || notification.critical?
      notification.notification_deliveries.create!(channel: :push)
    end
  end
end
```

### 2.2 `NotificationDeliveryService`

Service responsable de l'envoi effectif des notifications.

```ruby
class NotificationDeliveryService
  MAX_RETRIES = 3
  RETRY_DELAY = 10.minutes
  
  def self.process_delivery(delivery)
    return if delivery.read?
    return if delivery.retry_count >= MAX_RETRIES
    
    begin
      case delivery.channel
      when 'email'
        send_email(delivery)
      when 'push'
        send_push(delivery)
      end
      
      delivery.mark_as_sent!
      
    rescue StandardError => e
      handle_delivery_error(delivery, e)
    end
  end
  
  private
  
  def self.send_email(delivery)
    NotificationMailer.send_notification(delivery).deliver_now
  end
  
  def self.send_push(delivery)
    # Implémentation de l'envoi push via Firebase ou autre service
    notification = delivery.notification
    
    message = {
      title: notification.title,
      body: notification.content,
      data: {
        notification_id: notification.id,
        type: notification.notification_type,
        action_url: notification.action_url
      }
    }
    
    response = push_service.send_to_user(notification.user.push_token, message)
    
    unless response.success?
      raise "Échec de l'envoi push: #{response.error_message}"
    end
  end
  
  def self.handle_delivery_error(delivery, error)
    delivery.increment_retry_count!
    delivery.mark_as_failed!(error.message)
    
    if delivery.retry_count < MAX_RETRIES
      NotificationDeliveryJob.set(wait: RETRY_DELAY).perform_later(delivery.notification_id)
    end
  end
end
```

## 3. Jobs

### 3.1 `NotificationDeliveryJob`

```ruby
class NotificationDeliveryJob < ApplicationJob
  queue_as :notifications
  
  def perform(notification_id)
    notification = Notification.find(notification_id)
    
    notification.notification_deliveries.pending.each do |delivery|
      NotificationDeliveryService.process_delivery(delivery)
    end
  end
end
```

### 3.2 `NotificationCleanupJob`

```ruby
class NotificationCleanupJob < ApplicationJob
  queue_as :maintenance
  
  def perform
    # Supprimer les notifications expirées
    Notification.where("expiration_date < ?", 7.days.ago).destroy_all
    
    # Archiver les anciennes notifications
    archive_old_notifications
  end
  
  private
  
  def archive_old_notifications
    cutoff_dates = {
      critical: 2.years.ago,
      important: 1.year.ago,
      informative: 6.months.ago,
      optional: 3.months.ago
    }
    
    cutoff_dates.each do |importance, date|
      Notification.by_importance(importance)
                 .where("created_at < ?", date)
                 .find_each do |notification|
        NotificationArchiveService.archive(notification)
      end
    end
  end
end
```

## 4. Mailers

### 4.1 `NotificationMailer`

```ruby
class NotificationMailer < ApplicationMailer
  def send_notification(delivery)
    @notification = delivery.notification
    @user = @notification.user
    
    subject = case @notification.importance_level
             when 'critical'
               "[URGENT] #{@notification.title}"
             else
               @notification.title
             end
    
    mail(
      to: @user.email,
      subject: subject,
      template_name: template_for_notification
    )
  end
  
  private
  
  def template_for_notification
    case @notification.notification_type
    when 'membership'
      'membership_notification'
    when 'contribution'
      'contribution_notification'
    else
      'default_notification'
    end
  end
end
```

## 5. Politiques d'accès

### 5.1 `NotificationPolicy`

```ruby
class NotificationPolicy < ApplicationPolicy
  def index?
    true # Tout utilisateur connecté peut voir ses notifications
  end
  
  def show?
    record.user_id == user.id
  end
  
  def update?
    record.user_id == user.id
  end
  
  def destroy?
    record.user_id == user.id
  end
  
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
```

### 5.2 `NotificationPreferencePolicy`

```ruby
class NotificationPreferencePolicy < ApplicationPolicy
  def index?
    true
  end
  
  def update?
    record.user_id == user.id
  end
  
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
```

## 6. Configuration

### 6.1 Paramètres système

```ruby
# config/initializers/notification_settings.rb

Rails.application.config.notification_settings = {
  delivery: {
    max_retries: 3,
    retry_delay: 10.minutes,
    batch_size: 100
  },
  
  channels: {
    email: {
      enabled: true,
      daily_limit: 10
    },
    push: {
      enabled: true,
      daily_limit: 20,
      provider: :firebase
    }
  },
  
  quiet_hours: {
    default_start: "21:00",
    default_end: "08:00"
  },
  
  archival: {
    critical: 2.years,
    important: 1.year,
    informative: 6.months,
    optional: 3.months
  }
}
```

## 7. Intégration

### 7.1 Webhooks pour les notifications push

```ruby
# app/controllers/api/webhooks/push_notifications_controller.rb

module Api
  module Webhooks
    class PushNotificationsController < ApplicationController
      def delivery_status
        delivery = NotificationDelivery.find_by!(
          channel: :push,
          notification_id: params[:notification_id]
        )
        
        case params[:status]
        when "delivered"
          delivery.mark_as_delivered!
        when "failed"
          delivery.mark_as_failed!(params[:error_message])
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
# db/migrate/YYYYMMDDHHMMSS_add_indices_to_notifications.rb

class AddIndicesToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_index :notifications, [:user_id, :created_at]
    add_index :notifications, [:notification_type, :importance_level]
    add_index :notifications, [:reference_type, :reference_id]
    add_index :notification_deliveries, [:notification_id, :status]
    add_index :notification_deliveries, [:channel, :status]
    add_index :notification_preferences, [:user_id, :notification_type]
  end
end
```

### 8.2 Cache

```ruby
# app/models/notification.rb

class Notification < ApplicationRecord
  # ...
  
  def unread_count_cache_key
    "user/#{user_id}/unread_notifications_count"
  end
  
  def self.unread_count_for(user_id)
    Rails.cache.fetch("user/#{user_id}/unread_notifications_count", expires_in: 5.minutes) do
      joins(:notification_deliveries)
        .where(user_id: user_id)
        .where(notification_deliveries: { read_at: nil })
        .count
    end
  end
  
  # Invalidation du cache
  after_touch do
    Rails.cache.delete(unread_count_cache_key)
  end
end
```

## 9. Monitoring

### 9.1 Métriques

```ruby
# config/initializers/metrics.rb

NOTIFICATION_METRICS = [
  {
    name: 'notifications.created',
    type: 'counter',
    description: 'Number of notifications created'
  },
  {
    name: 'notifications.delivered',
    type: 'counter',
    description: 'Number of notifications delivered'
  },
  {
    name: 'notifications.failed',
    type: 'counter',
    description: 'Number of failed notifications'
  }
]

# Utilisation dans les modèles
after_create_commit do
  METRICS.increment('notifications.created', 
    tags: { 
      type: notification_type,
      importance: importance_level
    }
  )
end
```

## 10. Tests

Les tests unitaires et d'intégration sont essentiels. Voir le fichier de validation pour les scénarios de test détaillés. 