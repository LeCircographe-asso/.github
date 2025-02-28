# Spécifications Techniques - Notification

## Identification du document

| Domaine           | Notification                         |
|-------------------|-------------------------------------|
| Version           | 1.0                                 |
| Référence         | SPEC-NOT-2023-01                    |
| Dernière révision | [DATE]                              |

## Vue d'ensemble

Ce document définit les spécifications techniques pour l'implémentation du système de notification du Circographe. Conformément aux besoins opérationnels, le système se concentre sur deux canaux de communication principaux : les emails et les notifications push/in-app.

## Modèles de données

### Modèle `Notification`

#### Attributs principaux
| Attribut        | Type           | Description                                                      | Contraintes                 |
|-----------------|----------------|------------------------------------------------------------------|----------------------------|
| id              | Integer        | Identifiant unique                                               | PK, Auto-increment         |
| user_id         | Integer        | Destinataire de la notification                                  | FK, Not Null              |
| title           | String         | Titre court de la notification                                   | Not Null, Max 100 chars   |
| content         | Text           | Contenu détaillé                                                 | Not Null                  |
| notification_type | Enum         | Type de notification (adhésion, cotisation, paiement, etc.)      | Not Null                  |
| importance_level | Enum          | Niveau d'importance (critique, important, informatif, optionnel) | Not Null                  |
| source_type     | Enum           | Source (système, administratif, événementiel, communautaire)     | Not Null                  |
| reference_id    | Integer        | ID de l'objet lié (adhésion, cotisation, etc.)                   | Nullable                  |
| reference_type  | String         | Type de l'objet lié                                              | Nullable                  |
| action_url      | String         | URL d'action suggérée                                            | Nullable                  |
| action_text     | String         | Texte du bouton d'action                                         | Nullable                  |
| expiration_date | DateTime       | Date d'expiration de la notification                             | Nullable                  |
| created_at      | DateTime       | Date de création                                                 | Not Null, Default: now    |
| updated_at      | DateTime       | Date de dernière modification                                    | Not Null, Default: now    |

#### Validations
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

### Modèle `NotificationDelivery`

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

#### Validations
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

### Modèle `NotificationPreference`

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

#### Validations
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

## Services principaux

### `NotificationService`

Ce service centralise la création et l'envoi des notifications.

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
    
    # Créer les demandes d'envoi selon les préférences et l'importance
    create_deliveries(notification, user)
    
    # Déclencher l'envoi immédiat pour les notifications critiques
    if notification.critical?
      NotificationDeliveryJob.perform_now(notification.id)
    else
      NotificationDeliveryJob.perform_later(notification.id)
    end
    
    notification
  end
  
  def self.create_deliveries(notification, user)
    prefs = user.notification_preferences.find_by(notification_type: notification.notification_type)
    
    # Par défaut, toujours créer les notifications pour les cas critiques
    if notification.critical?
      notification.notification_deliveries.create!(channel: :email)
      notification.notification_deliveries.create!(channel: :push) if user.push_enabled?
      return
    end
    
    # Sinon, respecter les préférences utilisateur
    if prefs&.email_enabled
      notification.notification_deliveries.create!(channel: :email)
    end
    
    if prefs&.push_enabled && user.push_enabled?
      notification.notification_deliveries.create!(channel: :push)
    end
  end
  
  def self.should_notify?(user, notification_type, importance_level)
    # Les notifications critiques sont toujours envoyées
    return true if importance_level.to_sym == :critical
    
    # Vérifier les préférences pour les autres niveaux
    prefs = user.notification_preferences.find_by(notification_type: notification_type)
    
    # Si aucune préférence définie, utiliser les valeurs par défaut
    return true unless prefs
    
    # Vérifier si au moins un canal est actif
    prefs.email_enabled || (prefs.push_enabled && user.push_enabled?)
  end
  
  # Méthodes spécifiques pour les événements courants
  
  def self.notify_membership_expiration(membership)
    user = membership.user
    days_until_expiration = (membership.end_date - Date.current).to_i
    
    # Ne pas notifier si l'adhésion est déjà expirée
    return if days_until_expiration < 0
    
    # Déterminer le niveau d'importance selon l'imminence
    importance = case days_until_expiration
                 when 0..5 then :important
                 when 6..15 then :important
                 else :informative
                 end
    
    create_notification(
      user: user,
      title: "Votre adhésion expire bientôt",
      content: "Votre adhésion #{membership.membership_type} expire dans #{days_until_expiration} jours. Pensez à la renouveler pour continuer à bénéficier de tous les avantages.",
      notification_type: :membership,
      importance_level: importance,
      source_type: :system,
      reference: membership,
      action: { 
        url: "/memberships/renew/#{membership.id}",
        text: "Renouveler mon adhésion"
      }
    )
  end
  
  def self.notify_contribution_purchase(contribution)
    user = contribution.user
    
    create_notification(
      user: user,
      title: "Nouvelle cotisation activée",
      content: "Votre #{contribution.contribution_type_label} a été activé(e) et est désormais utilisable.",
      notification_type: :contribution,
      importance_level: :important,
      source_type: :system,
      reference: contribution,
      action: { 
        url: "/contributions/#{contribution.id}",
        text: "Voir ma cotisation"
      }
    )
  end
  
  def self.notify_admin_daily_report(admin, stats)
    create_notification(
      user: admin,
      title: "Rapport quotidien",
      content: "Le rapport quotidien du #{Date.current.strftime('%d/%m/%Y')} est disponible.",
      notification_type: :administrative,
      importance_level: :informative,
      source_type: :system,
      action: { 
        url: "/admin/reports/daily/#{Date.current.iso8601}",
        text: "Consulter le rapport"
      }
    )
  end
end
```

### `NotificationDeliveryService`

Ce service gère l'envoi effectif des notifications via les différents canaux.

```ruby
class NotificationDeliveryService
  MAX_RETRIES = 3
  
  def self.process_delivery(delivery)
    return if delivery.read?
    
    begin
      case delivery.channel
      when "email"
        deliver_email(delivery)
      when "push"
        deliver_push(delivery)
      end
      
      # Marquer comme envoyé si pas d'erreur
      delivery.mark_as_sent!
      true
    rescue => e
      handle_delivery_error(delivery, e)
      false
    end
  end
  
  def self.deliver_email(delivery)
    notification = delivery.notification
    user = notification.user
    
    # Ne pas envoyer pendant les heures de silence
    if in_quiet_hours?(user, notification)
      DeliveryRetryJob.set(wait: next_active_period(user)).perform_later(delivery.id)
      return
    end
    
    # Envoyer l'email
    NotificationMailer.notification_email(notification).deliver_now
  end
  
  def self.deliver_push(delivery)
    notification = delivery.notification
    user = notification.user
    
    # Ne pas envoyer pendant les heures de silence
    if in_quiet_hours?(user, notification)
      DeliveryRetryJob.set(wait: next_active_period(user)).perform_later(delivery.id)
      return
    end
    
    # Vérifier que le token push est présent
    unless user.push_token.present?
      delivery.mark_as_failed!("Aucun token push enregistré pour l'utilisateur")
      return
    end
    
    # Envoyer la notification push (exemple avec FCM)
    send_fcm_notification(user.push_token, notification)
  end
  
  def self.handle_delivery_error(delivery, error)
    delivery.increment_retry_count!
    
    if delivery.retry_count >= MAX_RETRIES
      delivery.mark_as_failed!(error.message)
    else
      # Programmation d'une nouvelle tentative
      backoff_time = (2 ** delivery.retry_count) * 10 # Backoff exponentiel
      DeliveryRetryJob.set(wait: backoff_time.minutes).perform_later(delivery.id)
    end
  end
  
  def self.in_quiet_hours?(user, notification)
    # Les notifications critiques ignorent les heures de silence
    return false if notification.critical?
    
    prefs = user.notification_preferences.find_by(notification_type: notification.notification_type)
    return false unless prefs&.quiet_hours_start && prefs&.quiet_hours_end
    
    current_time = Time.current.strftime("%H:%M")
    start_time = prefs.quiet_hours_start.strftime("%H:%M")
    end_time = prefs.quiet_hours_end.strftime("%H:%M")
    
    # Gestion du cas où la période chevauche minuit
    if start_time > end_time
      current_time >= start_time || current_time < end_time
    else
      current_time >= start_time && current_time < end_time
    end
  end
  
  def self.next_active_period(user)
    prefs = user.notification_preferences.first
    
    # Si pas d'heures de silence définies, retourner un délai court
    return 15.minutes unless prefs&.quiet_hours_end
    
    now = Time.current
    end_time = Time.zone.parse(prefs.quiet_hours_end.strftime("%H:%M"))
    
    # Ajuster à aujourd'hui
    end_time = DateTime.new(
      now.year, now.month, now.day,
      end_time.hour, end_time.min, 0, end_time.offset
    )
    
    # Si l'heure de fin est déjà passée aujourd'hui, utiliser celle de demain
    end_time += 1.day if end_time < now
    
    # Calculer le délai d'attente
    (end_time - now).seconds
  end
  
  private
  
  def self.send_fcm_notification(token, notification)
    # Implémentation de l'envoi via Firebase Cloud Messaging
    # Ceci est un exemple qui devrait être adapté à l'infrastructure réelle
    client = FirebaseCloudMessaging::Client.new(ENV['FCM_SERVER_KEY'])
    
    message = {
      to: token,
      notification: {
        title: notification.title,
        body: notification.content,
        icon: "icon.png",
        click_action: notification.action_url
      },
      data: {
        notification_id: notification.id,
        type: notification.notification_type,
        importance: notification.importance_level,
        reference_id: notification.reference_id,
        reference_type: notification.reference_type
      }
    }
    
    response = client.send(message)
    
    unless response[:success] == 1
      raise StandardError, "Échec de l'envoi FCM: #{response[:failure]}"
    end
  end
end
```

## Jobs en arrière-plan

Le système utilise des jobs pour traiter les notifications de manière asynchrone.

### `NotificationDeliveryJob`

```ruby
class NotificationDeliveryJob < ApplicationJob
  queue_as :notifications
  
  def perform(notification_id)
    notification = Notification.find_by(id: notification_id)
    return unless notification
    
    notification.notification_deliveries.pending.each do |delivery|
      NotificationDeliveryService.process_delivery(delivery)
    end
  end
end
```

### `DeliveryRetryJob`

```ruby
class DeliveryRetryJob < ApplicationJob
  queue_as :notifications
  
  def perform(delivery_id)
    delivery = NotificationDelivery.find_by(id: delivery_id)
    return unless delivery && delivery.pending?
    
    NotificationDeliveryService.process_delivery(delivery)
  end
end
```

### `NotificationCleanupJob`

```ruby
class NotificationCleanupJob < ApplicationJob
  queue_as :maintenance
  
  def perform
    # Archivage des notifications
    archive_old_notifications
    
    # Suppression des notifications archivées trop anciennes
    delete_archived_notifications
  end
  
  private
  
  def archive_old_notifications
    cutoffs = {
      critical: 3.months.ago,
      important: 2.months.ago,
      informative: 1.month.ago,
      optional: 2.weeks.ago
    }
    
    cutoffs.each do |level, date|
      Notification.where(importance_level: level)
        .where("created_at < ?", date)
        .update_all(archived: true)
    end
  end
  
  def delete_archived_notifications
    retention_periods = {
      critical: 2.years.ago,
      important: 1.year.ago,
      informative: 6.months.ago,
      optional: 3.months.ago
    }
    
    retention_periods.each do |level, date|
      Notification.where(importance_level: level, archived: true)
        .where("created_at < ?", date)
        .destroy_all
    end
  end
end
```

## Implémentation des canaux de communication

### 1. Email

#### Mailer
```ruby
class NotificationMailer < ApplicationMailer
  def notification_email(notification)
    @notification = notification
    @user = notification.user
    
    # Définir la priorité de l'email selon l'importance
    headers["X-Priority"] = case notification.importance_level
                            when "critical" then "1"
                            when "important" then "2"
                            else "3"
                            end
    
    mail(
      to: @user.email,
      subject: @notification.title,
      content_type: "text/html"
    )
  end
end
```

#### Template Email
```erb
<%# app/views/notification_mailer/notification_email.html.erb %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <style>
    body { font-family: Arial, sans-serif; color: #333; line-height: 1.5; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background-color: #4a86e8; color: white; padding: 10px; text-align: center; }
    .content { padding: 20px; }
    .footer { font-size: 12px; color: #777; text-align: center; margin-top: 20px; }
    .button { 
      background-color: #4a86e8; 
      color: white; 
      padding: 10px 20px; 
      text-decoration: none; 
      border-radius: 4px;
      display: inline-block;
      margin: 15px 0;
    }
    .critical { border-left: 5px solid #ff0000; }
    .important { border-left: 5px solid #ff9900; }
    .informative { border-left: 5px solid #4a86e8; }
    .optional { border-left: 5px solid #777777; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>Le Circographe</h1>
    </div>
    
    <div class="content <%= @notification.importance_level %>">
      <h2><%= @notification.title %></h2>
      
      <p>Bonjour <%= @user.first_name %>,</p>
      
      <div><%= simple_format(@notification.content) %></div>
      
      <% if @notification.action_url.present? %>
        <a href="<%= @notification.action_url %>" class="button"><%= @notification.action_text %></a>
      <% end %>
    </div>
    
    <div class="footer">
      <p>Le Circographe - Association de pratique des arts du cirque</p>
      <p>Vous recevez cet email car vous êtes membre de l'association.</p>
      <p><a href="<%= preferences_url %>">Gérer mes préférences de notification</a></p>
    </div>
  </div>
</body>
</html>
```

### 2. Notifications Push

#### Configuration FCM (Firebase Cloud Messaging)
```ruby
# config/initializers/firebase.rb

# Initialisation du client FCM
require 'firebase_cloud_messaging'

FirebaseCloudMessaging.configure do |config|
  config.server_key = ENV['FCM_SERVER_KEY']
  config.timeout = 5 # secondes
end
```

#### Composant Frontend pour les notifications push
```javascript
// app/javascript/components/notifications/PushHandler.js
import { useEffect } from 'react';
import { getMessaging, getToken, onMessage } from "firebase/messaging";
import { initializeApp } from "firebase/app";

const PushHandler = () => {
  useEffect(() => {
    // Configuration Firebase
    const firebaseConfig = {
      apiKey: process.env.FIREBASE_API_KEY,
      authDomain: process.env.FIREBASE_AUTH_DOMAIN,
      projectId: process.env.FIREBASE_PROJECT_ID,
      messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
      appId: process.env.FIREBASE_APP_ID
    };

    // Initialisation de Firebase
    const app = initializeApp(firebaseConfig);
    const messaging = getMessaging(app);

    // Demande de permission et enregistrement du token
    const requestPermissionAndRegisterToken = async () => {
      try {
        const permission = await Notification.requestPermission();
        
        if (permission === 'granted') {
          const token = await getToken(messaging, {
            vapidKey: process.env.FIREBASE_VAPID_KEY
          });
          
          // Enregistrer le token sur le serveur
          await fetch('/api/v1/push_tokens', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
            },
            body: JSON.stringify({ token })
          });
          
          console.log('Token enregistré avec succès');
        } else {
          console.log('Permission de notification refusée');
        }
      } catch (error) {
        console.error('Erreur lors de l\'enregistrement du token:', error);
      }
    };
    
    // Gestionnaire de messages
    onMessage(messaging, (payload) => {
      console.log('Message reçu:', payload);
      
      // Afficher une notification native si le navigateur est en arrière-plan
      if (document.visibilityState === 'hidden') {
        const { title, body, icon } = payload.notification;
        
        const notificationOptions = {
          body,
          icon,
          data: payload.data
        };
        
        self.registration.showNotification(title, notificationOptions);
      } else {
        // Afficher dans l'interface si l'application est active
        window.dispatchEvent(new CustomEvent('pushNotification', { 
          detail: payload 
        }));
      }
      
      // Marquer comme livré sur le serveur
      if (payload.data && payload.data.notification_id) {
        fetch(`/api/v1/notifications/${payload.data.notification_id}/mark_delivered`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
          }
        });
      }
    });
    
    // Demander la permission au chargement
    requestPermissionAndRegisterToken();
    
    // Nettoyer à la désinscription
    return () => {
      // Pas besoin de cleanup spécifique
    };
  }, []);
  
  return null; // Composant sans rendu
};

export default PushHandler;
```

## API et routes

```ruby
# config/routes.rb

Rails.application.routes.draw do
  # Routes API pour les notifications
  namespace :api do
    namespace :v1 do
      resources :notifications, only: [:index, :show] do
        member do
          post :mark_read
          post :mark_delivered
        end
        collection do
          get :unread_count
        end
      end
      
      resources :notification_preferences, only: [:index, :update] do
        collection do
          post :update_multiple
          post :reset_defaults
        end
      end
      
      resources :push_tokens, only: [:create, :destroy]
    end
  end
  
  # Routes pour la gestion des préférences
  get 'preferences/notifications', to: 'preferences#notifications', as: :preferences
  
  # Routes administratives
  namespace :admin do
    resources :notifications, only: [:index, :new, :create, :show] do
      collection do
        get :stats
        post :send_bulk
      end
    end
  end
end
```

## Intégration avec les autres domaines

### 1. Adhésion

Les notifications relatives aux adhésions sont générées par des callbacks dans le modèle `Membership` :

```ruby
# app/models/membership.rb

class Membership < ApplicationRecord
  # Autres configurations du modèle...
  
  after_create :send_welcome_notification
  after_save :schedule_expiration_reminders, if: -> { saved_change_to_end_date? || saved_change_to_status? && active? }
  
  private
  
  def send_welcome_notification
    return unless active?
    
    NotificationService.create_notification(
      user: user,
      title: "Bienvenue au Circographe !",
      content: "Votre adhésion #{membership_type_label} est maintenant active jusqu'au #{I18n.l(end_date)}.",
      notification_type: :membership,
      importance_level: :important,
      source_type: :system,
      reference: self
    )
  end
  
  def schedule_expiration_reminders
    return unless active?
    
    # Calculer les délais pour les rappels
    [30, 15, 5].each do |days_before|
      reminder_date = end_date - days_before.days
      next if reminder_date <= Date.current
      
      MembershipExpirationReminderJob.set(wait_until: reminder_date.beginning_of_day + 9.hours).perform_later(id)
    end
  end
end
```

### 2. Cotisation

De même pour les cotisations :

```ruby
# app/models/contribution.rb

class Contribution < ApplicationRecord
  # Autres configurations du modèle...
  
  after_create :send_purchase_notification, if: -> { active? }
  after_save :send_low_entries_notification, if: -> { saved_change_to_entries_left? && low_entries? }
  
  def low_entries?
    entries_left.present? && entries_left <= 2 && entries_left > 0
  end
  
  private
  
  def send_purchase_notification
    NotificationService.create_notification(
      user: user,
      title: "Nouvelle cotisation activée",
      content: "Votre #{contribution_type_label} a été activé(e) et est désormais utilisable.",
      notification_type: :contribution,
      importance_level: :important,
      source_type: :system,
      reference: self
    )
  end
  
  def send_low_entries_notification
    return unless active?
    
    NotificationService.create_notification(
      user: user,
      title: "Votre carnet est presque épuisé",
      content: "Il ne vous reste plus que #{entries_left} entrée(s) dans votre carnet. Pensez à le renouveler.",
      notification_type: :contribution,
      importance_level: :important,
      source_type: :system,
      reference: self,
      action: {
        url: "/contributions/new",
        text: "Acheter un nouveau carnet"
      }
    )
  end
end
```

## Points d'attention pour les développeurs

1. **Performance**
   - Les notifications sont traitées de manière asynchrone via des jobs pour ne pas bloquer les requêtes principales
   - Le regroupement des notifications similaires est important pour éviter de surcharger les utilisateurs
   - Un système de rate limiting est implémenté pour limiter le nombre de notifications par jour

2. **Sécurité**
   - Toutes les communications sont chiffrées
   - Les tokens push sont stockés de manière sécurisée
   - Les accès aux notifications d'un utilisateur sont strictement contrôlés

3. **Maintenance**
   - Un job de maintenance automatique nettoie les anciennes notifications selon les règles de conservation
   - La surveillance des erreurs d'envoi permet d'identifier les problèmes récurrents

4. **Tests**
   - Des tests unitaires complets doivent couvrir tous les services de notification
   - Des tests d'intégration doivent valider le bon fonctionnement des différents canaux
   - Des mocks doivent être utilisés pour les services externes comme Firebase

---

*Document créé le [DATE] - Version 1.0* 