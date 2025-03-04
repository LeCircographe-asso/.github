# Validation - Notification

## Identification du document

| Domaine           | Notification                         |
|-------------------|-------------------------------------|
| Version           | 1.1                                 |
| Référence         | VALID-NOT-2024-01                   |
| Dernière révision | Mars 2024                           |

## Critères d'Acceptation

### AC1: Création et envoi d'une notification
1. Le système doit permettre la création d'une notification pour un utilisateur spécifique
2. La notification doit être envoyée via les canaux appropriés (email et/ou push) selon les préférences utilisateur
3. Le statut d'envoi doit être correctement suivi et enregistré
4. Les notifications critiques doivent être envoyées immédiatement

### AC2: Gestion des préférences de notification
1. Les utilisateurs doivent pouvoir activer/désactiver les notifications par type
2. Les utilisateurs doivent pouvoir choisir les canaux de notification préférés (email et/ou push)
3. Les préférences doivent être appliquées lors de l'envoi des notifications
4. Les notifications critiques doivent être envoyées indépendamment des préférences

### AC3: Notifications liées aux adhésions
1. Une notification doit être envoyée lors de la création d'une nouvelle adhésion
2. Des rappels doivent être envoyés avant l'expiration d'une adhésion (30, 15 et 5 jours)
3. Une notification doit être envoyée le jour de l'expiration d'une adhésion
4. Une notification doit être envoyée lors du renouvellement d'une adhésion

### AC4: Notifications liées aux cotisations
1. Une notification doit être envoyée lors de l'achat d'une nouvelle cotisation
2. Des rappels doivent être envoyés avant l'expiration d'un abonnement
3. Une alerte doit être envoyée lorsqu'un carnet a peu d'entrées restantes
4. Une confirmation doit être envoyée après utilisation d'une entrée

### AC5: Interface utilisateur des notifications
1. Les utilisateurs doivent pouvoir consulter l'historique de leurs notifications
2. Les notifications non lues doivent être clairement identifiables
3. Les notifications doivent être triées par date (les plus récentes en haut)
4. Les utilisateurs doivent pouvoir marquer les notifications comme lues

### AC6: Heures de silence et fréquence d'envoi
1. Les utilisateurs doivent pouvoir définir des heures de silence pendant lesquelles les notifications non critiques ne sont pas envoyées
2. Le système doit respecter une limite de fréquence d'envoi pour éviter le spam
3. Les notifications similaires doivent être regroupées quand c'est possible
4. Les notifications reportées doivent être envoyées à la fin de la période de silence

### AC7: Gestion des erreurs et retentatives
1. En cas d'échec d'envoi, le système doit effectuer des retentatives
2. Le nombre de retentatives doit être limité (maximum 3)
3. Les erreurs d'envoi doivent être correctement enregistrées
4. Le système doit gérer proprement les cas de tokens push invalides

### AC8: Archivage et nettoyage des notifications
1. Les notifications anciennes doivent être archivées selon des règles de durée définies
2. Les notifications archivées doivent être supprimées après leur période de rétention
3. La période de conservation doit varier selon l'importance des notifications
4. Le processus d'archivage et de suppression doit s'exécuter régulièrement et automatiquement

## Scénarios de Test

### Scénario 1: Cycle de vie complet d'une notification
```gherkin
Feature: Cycle de vie des notifications
  Scenario: Création, envoi et lecture d'une notification
    Given un utilisateur avec des préférences de notification activées
    When le système crée une notification importante pour cet utilisateur
    Then des entrées de livraison sont créées pour les canaux email et push
    And les notifications sont envoyées via les canaux appropriés
    And le statut des notifications passe à "sent"
    
    When l'utilisateur consulte ses notifications
    Then la notification apparaît dans sa liste de notifications non lues
    
    When l'utilisateur clique sur la notification
    Then la notification est marquée comme lue
    And son statut est mis à jour dans le système
```

### Scénario 2: Respect des préférences utilisateur
```gherkin
Feature: Respect des préférences de notification
  Scenario: Envoi selon les préférences utilisateur
    Given un utilisateur qui a désactivé les notifications email pour les cotisations
    But a laissé activées les notifications push pour les cotisations
    When une notification de type "cotisation" est créée pour cet utilisateur
    Then aucune notification email n'est envoyée
    But une notification push est envoyée
    
    When l'utilisateur désactive toutes les notifications pour les cotisations
    And une nouvelle notification de type "cotisation" est créée
    Then aucune notification n'est envoyée
    
    When une notification critique est créée pour cet utilisateur
    Then des notifications sont envoyées quel que soit le paramétrage
```

### Scénario 3: Notifications d'adhésion
```gherkin
Feature: Notifications d'adhésion
  Scenario: Notifications liées au cycle de vie d'une adhésion
    Given un utilisateur avec une adhésion active
    When l'adhésion approche de sa date d'expiration (30 jours)
    Then une notification de rappel est envoyée
    
    When l'adhésion approche davantage de sa date d'expiration (15 jours)
    Then une seconde notification de rappel est envoyée
    
    When l'adhésion est sur le point d'expirer (5 jours)
    Then une notification urgente de rappel est envoyée
    
    When l'adhésion est renouvelée
    Then une notification de confirmation de renouvellement est envoyée
```

### Scénario 4: Respect des heures de silence
```gherkin
Feature: Respect des heures de silence
  Scenario: Report des notifications pendant les heures de silence
    Given un utilisateur ayant défini des heures de silence de 22h à 8h
    When une notification informative est générée à 23h
    Then la notification n'est pas envoyée immédiatement
    And est programmée pour être envoyée à 8h le lendemain
    
    When une notification critique est générée à 23h
    Then la notification est envoyée immédiatement malgré les heures de silence
```

### Scénario 5: Gestion des erreurs d'envoi
```gherkin
Feature: Gestion des erreurs d'envoi
  Scenario: Retentatives après échec d'envoi
    Given un utilisateur avec une adresse email invalide
    When une notification par email est envoyée à cet utilisateur
    Then l'envoi échoue et une erreur est enregistrée
    
    When le système effectue une première retentative
    Then l'envoi échoue à nouveau
    And le compteur de retentatives est incrémenté
    
    When le système effectue une seconde retentative
    Then l'envoi échoue à nouveau
    
    When le système effectue une troisième retentative
    Then l'envoi échoue à nouveau
    And le statut de la notification passe à "failed"
    And aucune nouvelle retentative n'est programmée
```

## Tests Unitaires

### Tests pour `Notification`

```ruby
RSpec.describe Notification, type: :model do
  describe "validations" do
    it "requires title, content, notification_type, importance_level, and source_type" do
      notification = build(:notification, title: nil, content: nil, notification_type: nil, importance_level: nil, source_type: nil)
      expect(notification).not_to be_valid
      expect(notification.errors).to include(:title, :content, :notification_type, :importance_level, :source_type)
    end
    
    it "limits title length to 100 characters" do
      notification = build(:notification, title: "a" * 101)
      expect(notification).not_to be_valid
      expect(notification.errors).to include(:title)
      
      notification.title = "a" * 100
      expect(notification).to be_valid
    end
    
    it "requires action_text when action_url is present" do
      notification = build(:notification, action_url: "https://example.com", action_text: nil)
      expect(notification).not_to be_valid
      expect(notification.errors).to include(:action_text)
      
      notification.action_text = "Click me"
      expect(notification).to be_valid
    end
  end
  
  describe "scopes" do
    before do
      @user = create(:user)
      @read = create(:notification, user: @user)
      create(:notification_delivery, notification: @read, read_at: Time.current)
      
      @unread = create(:notification, user: @user)
      create(:notification_delivery, notification: @unread, read_at: nil)
      
      @expired = create(:notification, user: @user, expiration_date: 1.day.ago)
      @active = create(:notification, user: @user, expiration_date: 1.day.from_now)
      @no_expiration = create(:notification, user: @user, expiration_date: nil)
    end
    
    it "filters unread notifications" do
      expect(Notification.unread).to include(@unread)
      expect(Notification.unread).not_to include(@read)
    end
    
    it "filters active notifications" do
      expect(Notification.active).to include(@active, @no_expiration)
      expect(Notification.active).not_to include(@expired)
    end
    
    it "filters by importance" do
      important = create(:notification, importance_level: :important)
      informative = create(:notification, importance_level: :informative)
      
      expect(Notification.by_importance(:important)).to include(important)
      expect(Notification.by_importance(:important)).not_to include(informative)
    end
  end
  
  describe "#mark_as_read!" do
    it "marks all deliveries as read" do
      notification = create(:notification)
      delivery1 = create(:notification_delivery, notification: notification)
      delivery2 = create(:notification_delivery, notification: notification)
      
      expect {
        notification.mark_as_read!
      }.to change { notification.read? }.from(false).to(true)
      
      expect(delivery1.reload.read?).to be true
      expect(delivery2.reload.read?).to be true
    end
  end
end
```

### Tests pour `NotificationDelivery`

```ruby
RSpec.describe NotificationDelivery, type: :model do
  describe "validations" do
    it "requires channel and status" do
      delivery = build(:notification_delivery, channel: nil, status: nil)
      expect(delivery).not_to be_valid
      expect(delivery.errors).to include(:channel, :status)
    end
    
    it "validates retry_count is non-negative" do
      delivery = build(:notification_delivery, retry_count: -1)
      expect(delivery).not_to be_valid
      expect(delivery.errors).to include(:retry_count)
      
      delivery.retry_count = 0
      expect(delivery).to be_valid
    end
  end
  
  describe "status transitions" do
    let(:delivery) { create(:notification_delivery) }
    
    it "marks as sent" do
      expect {
        delivery.mark_as_sent!
      }.to change { delivery.status }.to("sent")
        .and change { delivery.sent_at }.from(nil)
    end
    
    it "marks as delivered" do
      expect {
        delivery.mark_as_delivered!
      }.to change { delivery.status }.to("delivered")
        .and change { delivery.delivered_at }.from(nil)
    end
    
    it "marks as failed with error message" do
      error_message = "Invalid email"
      expect {
        delivery.mark_as_failed!(error_message)
      }.to change { delivery.status }.to("failed")
        .and change { delivery.error_message }.to(error_message)
    end
    
    it "increments retry count" do
      expect {
        delivery.increment_retry_count!
      }.to change { delivery.retry_count }.by(1)
    end
  end
end
```

### Tests pour `NotificationService`

```ruby
RSpec.describe NotificationService do
  describe ".create_notification" do
    let(:user) { create(:user) }
    
    context "with valid parameters" do
      let(:params) do
        {
          user: user,
          title: "Test notification",
          content: "Test content",
          notification_type: :membership,
          importance_level: :important,
          source_type: :system
        }
      end
      
      it "creates a notification" do
        expect {
          NotificationService.create_notification(**params)
        }.to change(Notification, :count).by(1)
      end
      
      it "creates delivery entries based on preferences" do
        create(:notification_preference, user: user, notification_type: :membership, email_enabled: true, push_enabled: true)
        
        expect {
          NotificationService.create_notification(**params)
        }.to change(NotificationDelivery, :count).by(2)
      end
      
      it "respects user preferences" do
        create(:notification_preference, user: user, notification_type: :membership, email_enabled: false, push_enabled: true)
        
        expect {
          NotificationService.create_notification(**params)
        }.to change(NotificationDelivery, :count).by(1)
        
        expect(NotificationDelivery.last.channel).to eq("push")
      end
    end
    
    context "with critical notifications" do
      let(:params) do
        {
          user: user,
          title: "Critical notification",
          content: "Critical content",
          notification_type: :system,
          importance_level: :critical,
          source_type: :system
        }
      end
      
      it "creates delivery entries regardless of preferences" do
        create(:notification_preference, user: user, notification_type: :system, email_enabled: false, push_enabled: false)
        
        expect {
          NotificationService.create_notification(**params)
        }.to change(NotificationDelivery, :count).by(2)
      end
      
      it "triggers immediate delivery" do
        expect(NotificationDeliveryJob).to receive(:perform_now)
        
        NotificationService.create_notification(**params)
      end
    end
  end
end
```

## Tests d'Intégration

### Processus complet de notification

```ruby
RSpec.describe "Notification Process", type: :request do
  let(:user) { create(:user) }
  
  before do
    create(:notification_preference, user: user, notification_type: :membership, email_enabled: true)
  end
  
  it "handles the complete notification lifecycle" do
    # Création de la notification
    post "/api/notifications", params: {
      user_id: user.id,
      title: "Test notification",
      content: "Test content",
      notification_type: "membership",
      importance_level: "important"
    }
    
    expect(response).to have_http_status(:created)
    notification = Notification.last
    
    # Vérification de la création des deliveries
    expect(notification.notification_deliveries.count).to eq(1)
    delivery = notification.notification_deliveries.first
    expect(delivery.channel).to eq("email")
    
    # Simulation de l'envoi réussi
    delivery.mark_as_sent!
    expect(delivery.reload.status).to eq("sent")
    
    # Lecture de la notification
    get "/api/notifications/#{notification.id}"
    expect(response).to have_http_status(:ok)
    
    # Marquage comme lue
    patch "/api/notifications/#{notification.id}/mark_as_read"
    expect(response).to have_http_status(:ok)
    expect(notification.reload.read?).to be true
  end
end
```

### Gestion des préférences

```ruby
RSpec.describe "Notification Preferences", type: :request do
  let(:user) { create(:user) }
  
  it "allows users to manage their notification preferences" do
    # Création des préférences
    post "/api/notification_preferences", params: {
      user_id: user.id,
      notification_type: "membership",
      email_enabled: true,
      push_enabled: false,
      quiet_hours_start: "22:00",
      quiet_hours_end: "08:00"
    }
    
    expect(response).to have_http_status(:created)
    preference = NotificationPreference.last
    
    # Modification des préférences
    patch "/api/notification_preferences/#{preference.id}", params: {
      email_enabled: false,
      push_enabled: true
    }
    
    expect(response).to have_http_status(:ok)
    expect(preference.reload.email_enabled).to be false
    expect(preference.reload.push_enabled).to be true
    
    # Vérification que les préférences sont respectées
    post "/api/notifications", params: {
      user_id: user.id,
      title: "Test notification",
      content: "Test content",
      notification_type: "membership",
      importance_level: "important"
    }
    
    notification = Notification.last
    expect(notification.notification_deliveries.pluck(:channel)).to contain_exactly("push")
  end
end
```

## Matrice de Traçabilité

| Critère d'acceptation | Scénario de test | Test unitaire | Test d'intégration |
|-----------------------|------------------|---------------|-------------------|
| AC1: Création et envoi | Scénario 1 | NotificationService#create_notification | Notification Process |
| AC2: Préférences | Scénario 2 | NotificationPreference validations | Notification Preferences |
| AC3: Adhésions | Scénario 3 | Notification scopes | Membership Notifications |
| AC4: Cotisations | - | - | Contribution Notifications |
| AC5: Interface UI | Scénario 1 | Notification#mark_as_read! | Notification Process |
| AC6: Heures silence | Scénario 4 | NotificationService#should_notify? | Quiet Hours |
| AC7: Erreurs | Scénario 5 | NotificationDelivery status transitions | Error Handling |
| AC8: Archivage | - | NotificationCleanupJob | Archival Process |

---

*Document mis à jour le Mars 2024 - Version 1.1* 