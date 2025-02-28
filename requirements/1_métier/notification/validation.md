# Validation - Notification

## Identification du document

| Domaine           | Notification                         |
|-------------------|-------------------------------------|
| Version           | 1.0                                 |
| Référence         | VALID-NOT-2023-01                   |
| Dernière révision | [DATE]                              |

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

### Tests pour `Notification` et `NotificationDelivery`

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
  
  describe "status transition methods" do
    let(:delivery) { create(:notification_delivery, status: :pending) }
    
    it "updates status to read with mark_as_read!" do
      expect {
        delivery.mark_as_read!
      }.to change { delivery.status }.from("pending").to("read")
      .and change { delivery.read_at }.from(nil).to(be_present)
    end
    
    it "updates status to sent with mark_as_sent!" do
      expect {
        delivery.mark_as_sent!
      }.to change { delivery.status }.from("pending").to("sent")
      .and change { delivery.sent_at }.from(nil).to(be_present)
    end
    
    it "updates status to delivered with mark_as_delivered!" do
      expect {
        delivery.mark_as_delivered!
      }.to change { delivery.status }.from("pending").to("delivered")
      .and change { delivery.delivered_at }.from(nil).to(be_present)
    end
    
    it "updates status to failed with mark_as_failed!" do
      expect {
        delivery.mark_as_failed!("Test error")
      }.to change { delivery.status }.from("pending").to("failed")
      .and change { delivery.error_message }.from(nil).to("Test error")
    end
    
    it "increments retry count with increment_retry_count!" do
      expect {
        delivery.increment_retry_count!
      }.to change { delivery.retry_count }.from(0).to(1)
    end
  end
  
  describe "scopes" do
    before do
      @pending = create(:notification_delivery, status: :pending)
      @sent = create(:notification_delivery, status: :sent)
      @failed = create(:notification_delivery, status: :failed)
      @read = create(:notification_delivery, status: :read, read_at: Time.current)
      @delivered = create(:notification_delivery, status: :delivered, read_at: nil)
    end
    
    it "filters by status correctly" do
      expect(NotificationDelivery.pending).to include(@pending)
      expect(NotificationDelivery.pending).not_to include(@sent, @failed, @read)
      
      expect(NotificationDelivery.failed).to include(@failed)
      expect(NotificationDelivery.failed).not_to include(@pending, @sent, @read)
    end
    
    it "filters read and unread correctly" do
      expect(NotificationDelivery.read).to include(@read)
      expect(NotificationDelivery.read).not_to include(@pending, @sent, @failed, @delivered)
      
      expect(NotificationDelivery.unread).to include(@pending, @sent, @failed, @delivered)
      expect(NotificationDelivery.unread).not_to include(@read)
    end
  end
end
```

### Tests pour `NotificationService`

```ruby
RSpec.describe NotificationService do
  describe ".create_notification" do
    let(:user) { create(:user) }
    
    before do
      # Créer des préférences par défaut
      NotificationPreference.create_defaults_for(user)
    end
    
    it "creates a notification with specified attributes" do
      expect {
        notification = NotificationService.create_notification(
          user: user,
          title: "Test notification",
          content: "This is a test",
          notification_type: :membership,
          importance_level: :important,
          source_type: :system
        )
        
        expect(notification).to be_persisted
        expect(notification.title).to eq("Test notification")
        expect(notification.content).to eq("This is a test")
        expect(notification.notification_type).to eq("membership")
        expect(notification.importance_level).to eq("important")
        expect(notification.source_type).to eq("system")
      }.to change(Notification, :count).by(1)
      .and change(NotificationDelivery, :count).by(2) # email et push
    end
    
    it "respects user preferences for non-critical notifications" do
      # Désactiver les préférences email
      pref = user.notification_preferences.find_by(notification_type: "membership")
      pref.update(email_enabled: false)
      
      expect {
        NotificationService.create_notification(
          user: user,
          title: "Test notification",
          content: "This is a test",
          notification_type: :membership,
          importance_level: :important,
          source_type: :system
        )
      }.to change(NotificationDelivery, :count).by(1) # push seulement
      
      # Vérifier que seule la notification push a été créée
      expect(NotificationDelivery.last.channel).to eq("push")
    end
    
    it "ignores preferences for critical notifications" do
      # Désactiver toutes les préférences
      user.notification_preferences.update_all(email_enabled: false, push_enabled: false)
      
      expect {
        NotificationService.create_notification(
          user: user,
          title: "Critical alert",
          content: "This is critical",
          notification_type: :system,
          importance_level: :critical,
          source_type: :system
        )
      }.to change(NotificationDelivery, :count).by(2) # email et push malgré les préférences
    end
    
    it "sets optional fields correctly" do
      ref_obj = create(:membership, user: user)
      expiration = 1.day.from_now
      
      notification = NotificationService.create_notification(
        user: user,
        title: "Test with optionals",
        content: "This has all optional fields",
        notification_type: :membership,
        importance_level: :informative,
        source_type: :system,
        reference: ref_obj,
        action: { url: "/test", text: "Click me" },
        expiration_date: expiration
      )
      
      expect(notification.reference_id).to eq(ref_obj.id)
      expect(notification.reference_type).to eq(ref_obj.class.name)
      expect(notification.action_url).to eq("/test")
      expect(notification.action_text).to eq("Click me")
      expect(notification.expiration_date).to be_within(1.second).of(expiration)
    end
    
    it "returns false if user should not be notified" do
      # Désactiver toutes les préférences pour ce type
      user.notification_preferences.find_by(notification_type: "membership").update(
        email_enabled: false, push_enabled: false
      )
      
      result = NotificationService.create_notification(
        user: user,
        title: "Should not send",
        content: "This should not be sent",
        notification_type: :membership,
        importance_level: :informative,
        source_type: :system
      )
      
      expect(result).to be false
      expect(Notification.where(title: "Should not send")).not_to exist
    end
  end
  
  describe ".notify_membership_expiration" do
    it "sends notification with correct importance based on days until expiration" do
      user = create(:user)
      
      # Adhésion expirant dans 35 jours
      membership_far = create(:membership, user: user, end_date: 35.days.from_now)
      NotificationService.notify_membership_expiration(membership_far)
      notification_far = Notification.last
      expect(notification_far.importance_level).to eq("informative")
      
      # Adhésion expirant dans 15 jours
      membership_medium = create(:membership, user: user, end_date: 15.days.from_now)
      NotificationService.notify_membership_expiration(membership_medium)
      notification_medium = Notification.last
      expect(notification_medium.importance_level).to eq("important")
      
      # Adhésion expirant dans 5 jours
      membership_soon = create(:membership, user: user, end_date: 5.days.from_now)
      NotificationService.notify_membership_expiration(membership_soon)
      notification_soon = Notification.last
      expect(notification_soon.importance_level).to eq("important")
    end
    
    it "does not send notification for already expired memberships" do
      user = create(:user)
      membership = create(:membership, user: user, end_date: 1.day.ago)
      
      expect {
        NotificationService.notify_membership_expiration(membership)
      }.not_to change(Notification, :count)
    end
  end
end
```

### Tests pour `NotificationDeliveryService`

```ruby
RSpec.describe NotificationDeliveryService do
  describe ".process_delivery" do
    let(:notification) { create(:notification) }
    
    it "processes email delivery successfully" do
      delivery = create(:notification_delivery, notification: notification, channel: :email)
      
      expect(NotificationMailer).to receive_message_chain(:notification_email, :deliver_now)
      expect {
        result = NotificationDeliveryService.process_delivery(delivery)
        expect(result).to be true
      }.to change { delivery.reload.status }.from("pending").to("sent")
      .and change { delivery.reload.sent_at }.from(nil).to(be_present)
    end
    
    it "processes push delivery successfully" do
      user = notification.user
      allow(user).to receive(:push_token).and_return("valid_token")
      delivery = create(:notification_delivery, notification: notification, channel: :push)
      
      expect(NotificationDeliveryService).to receive(:send_fcm_notification).with("valid_token", notification)
      expect {
        result = NotificationDeliveryService.process_delivery(delivery)
        expect(result).to be true
      }.to change { delivery.reload.status }.from("pending").to("sent")
    end
    
    it "handles missing push token" do
      user = notification.user
      allow(user).to receive(:push_token).and_return(nil)
      delivery = create(:notification_delivery, notification: notification, channel: :push)
      
      expect {
        result = NotificationDeliveryService.process_delivery(delivery)
        expect(result).to be false
      }.to change { delivery.reload.status }.from("pending").to("failed")
      .and change { delivery.reload.error_message }.from(nil).to(include("Aucun token push"))
    end
    
    it "handles delivery errors" do
      delivery = create(:notification_delivery, notification: notification, channel: :email)
      
      allow(NotificationMailer).to receive_message_chain(:notification_email, :deliver_now)
        .and_raise(StandardError.new("Test error"))
      
      expect {
        result = NotificationDeliveryService.process_delivery(delivery)
        expect(result).to be false
      }.to change { delivery.reload.retry_count }.from(0).to(1)
      
      # Should not mark as failed on first retry
      expect(delivery.reload.status).to eq("pending")
    end
    
    it "marks as failed after max retries" do
      delivery = create(:notification_delivery, notification: notification, channel: :email, retry_count: NotificationDeliveryService::MAX_RETRIES - 1)
      
      allow(NotificationMailer).to receive_message_chain(:notification_email, :deliver_now)
        .and_raise(StandardError.new("Test error"))
      
      expect {
        result = NotificationDeliveryService.process_delivery(delivery)
        expect(result).to be false
      }.to change { delivery.reload.status }.from("pending").to("failed")
      .and change { delivery.reload.error_message }.from(nil).to("Test error")
    end
    
    it "skips already read deliveries" do
      delivery = create(:notification_delivery, notification: notification, status: :read, read_at: Time.current)
      
      expect(NotificationMailer).not_to receive(:notification_email)
      
      result = NotificationDeliveryService.process_delivery(delivery)
      expect(result).to be_nil
    end
  end
  
  describe ".in_quiet_hours?" do
    let(:user) { create(:user) }
    let(:notification) { create(:notification, user: user, importance_level: :informative) }
    let(:critical_notification) { create(:notification, user: user, importance_level: :critical) }
    
    before do
      pref = create(:notification_preference, 
        user: user, 
        notification_type: notification.notification_type,
        quiet_hours_start: "22:00",
        quiet_hours_end: "08:00"
      )
    end
    
    it "returns true during quiet hours for non-critical notifications" do
      allow(Time).to receive(:current).and_return(Time.parse("23:30"))
      
      expect(NotificationDeliveryService.in_quiet_hours?(user, notification)).to be true
    end
    
    it "returns false outside quiet hours" do
      allow(Time).to receive(:current).and_return(Time.parse("12:00"))
      
      expect(NotificationDeliveryService.in_quiet_hours?(user, notification)).to be false
    end
    
    it "returns false for critical notifications regardless of time" do
      allow(Time).to receive(:current).and_return(Time.parse("23:30"))
      
      expect(NotificationDeliveryService.in_quiet_hours?(user, critical_notification)).to be false
    end
    
    it "handles quiet hours spanning midnight" do
      pref = user.notification_preferences.first
      pref.update(quiet_hours_start: "23:00", quiet_hours_end: "06:00")
      
      # Before midnight
      allow(Time).to receive(:current).and_return(Time.parse("23:30"))
      expect(NotificationDeliveryService.in_quiet_hours?(user, notification)).to be true
      
      # After midnight
      allow(Time).to receive(:current).and_return(Time.parse("02:30"))
      expect(NotificationDeliveryService.in_quiet_hours?(user, notification)).to be true
      
      # Outside range
      allow(Time).to receive(:current).and_return(Time.parse("22:30"))
      expect(NotificationDeliveryService.in_quiet_hours?(user, notification)).to be false
    end
  end
end
```

## Tests d'Intégration

### Flux complet de notification

```ruby
RSpec.describe "Flux de notification", type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  
  before do
    # S'assurer que les préférences existent
    NotificationPreference.create_defaults_for(user)
    sign_in admin
  end
  
  it "gère correctement le flux complet de notification" do
    # Envoi d'une notification par un admin
    post "/admin/notifications", params: {
      notification: {
        user_id: user.id,
        title: "Test notification",
        content: "This is a test notification",
        notification_type: "administrative",
        importance_level: "important",
        source_type: "administrative",
        action_url: "/test",
        action_text: "Test action"
      }
    }
    
    expect(response).to have_http_status(:redirect)
    
    # Vérifier que la notification a été créée
    notification = Notification.last
    expect(notification.title).to eq("Test notification")
    expect(notification.user).to eq(user)
    
    # Vérifier que les livraisons ont été créées
    expect(notification.notification_deliveries.count).to eq(2) # email et push
    expect(notification.notification_deliveries.pluck(:channel)).to include("email", "push")
    
    # Se connecter en tant qu'utilisateur pour consulter les notifications
    sign_in user
    
    # Consultation des notifications
    get "/api/v1/notifications"
    expect(response).to have_http_status(:ok)
    
    json = JSON.parse(response.body)
    expect(json.size).to eq(1)
    expect(json[0]["title"]).to eq("Test notification")
    expect(json[0]["read"]).to be false
    
    # Marquer comme lue
    post "/api/v1/notifications/#{notification.id}/mark_read"
    expect(response).to have_http_status(:ok)
    
    # Vérifier que la notification est marquée comme lue
    get "/api/v1/notifications"
    json = JSON.parse(response.body)
    expect(json[0]["read"]).to be true
    
    # Vérifier le compteur de notifications non lues
    get "/api/v1/notifications/unread_count"
    json = JSON.parse(response.body)
    expect(json["count"]).to eq(0)
  end
end
```

### Gestion des préférences

```ruby
RSpec.describe "Gestion des préférences de notification", type: :request do
  let(:user) { create(:user) }
  
  before do
    # S'assurer que les préférences existent
    NotificationPreference.create_defaults_for(user)
    sign_in user
  end
  
  it "permet de consulter les préférences" do
    get "/api/v1/notification_preferences"
    expect(response).to have_http_status(:ok)
    
    json = JSON.parse(response.body)
    expect(json.size).to eq(8) # Tous les types de notification
    expect(json[0]["email_enabled"]).to be true
    expect(json[0]["push_enabled"]).to be true
  end
  
  it "permet de mettre à jour les préférences" do
    pref = user.notification_preferences.first
    
    patch "/api/v1/notification_preferences/#{pref.id}", params: {
      notification_preference: {
        email_enabled: false,
        push_enabled: true,
        quiet_hours_start: "22:00",
        quiet_hours_end: "08:00"
      }
    }
    
    expect(response).to have_http_status(:ok)
    
    # Vérifier que les préférences ont été mises à jour
    pref.reload
    expect(pref.email_enabled).to be false
    expect(pref.push_enabled).to be true
    expect(pref.quiet_hours_start.strftime("%H:%M")).to eq("22:00")
    expect(pref.quiet_hours_end.strftime("%H:%M")).to eq("08:00")
  end
  
  it "permet de mettre à jour plusieurs préférences à la fois" do
    post "/api/v1/notification_preferences/update_multiple", params: {
      preferences: {
        membership: { email_enabled: false, push_enabled: false },
        payment: { email_enabled: true, push_enabled: false }
      }
    }
    
    expect(response).to have_http_status(:ok)
    
    # Vérifier les mises à jour
    membership_pref = user.notification_preferences.find_by(notification_type: "membership")
    expect(membership_pref.email_enabled).to be false
    expect(membership_pref.push_enabled).to be false
    
    payment_pref = user.notification_preferences.find_by(notification_type: "payment")
    expect(payment_pref.email_enabled).to be true
    expect(payment_pref.push_enabled).to be false
  end
  
  it "permet de réinitialiser les préférences par défaut" do
    # D'abord, modifier quelques préférences
    user.notification_preferences.update_all(email_enabled: false, push_enabled: false)
    
    post "/api/v1/notification_preferences/reset_defaults"
    expect(response).to have_http_status(:ok)
    
    # Vérifier que les préférences ont été réinitialisées
    user.notification_preferences.reload.each do |pref|
      expect(pref.email_enabled).to be true
      expect(pref.push_enabled).to be true
    end
  end
end
```

## Plan de Test

### Tests de Performance
1. **Test de charge**
   - Génération simultanée de nombreuses notifications (100+)
   - Mesure du temps de traitement et d'envoi
   - Vérification du comportement du système sous charge

2. **Test des jobs asynchrones**
   - Vérification du bon fonctionnement des files d'attente
   - Test du comportement lors de pics d'activité
   - Mesure du délai entre création et envoi

3. **Test de la gestion des heures de silence**
   - Vérification du report correct des notifications
   - Test du comportement lorsque de nombreuses notifications sont reportées
   - Mesure du temps de traitement lors de la fin des heures de silence

### Tests de Sécurité
1. **Test d'accès aux notifications**
   - Vérification qu'un utilisateur ne peut pas accéder aux notifications d'un autre
   - Test des permissions administratives

2. **Test de protection des données**
   - Vérification du chiffrement des communications
   - Test de la protection des tokens push
   - Vérification de la non-inclusion de données sensibles dans les notifications

3. **Test d'injection**
   - Tentatives d'injection dans les paramètres de notification
   - Test avec des caractères spéciaux dans les titres et contenus
   - Vérification de l'échappement correct des données

### Tests de Résilience
1. **Test des retentatives**
   - Simulation d'échecs d'envoi
   - Vérification du comportement du backoff exponentiel
   - Test de la gestion des erreurs permanentes

2. **Test du nettoyage des données**
   - Vérification du processus d'archivage automatique
   - Test de la suppression des anciennes notifications
   - Mesure de l'impact sur les performances du système

## Matrice de Traçabilité

| Règle Métier | Critère d'Acceptation | Test Unitaire | Test d'Intégration |
|--------------|------------------------|---------------|-------------------|
| Types de notifications | AC1 | Notification#validations | Flux complet |
| Canaux de communication | AC1, AC2 | NotificationDelivery#validations | Flux complet |
| Préférences utilisateur | AC2 | NotificationService#should_notify? | Gestion des préférences |
| Notifications adhésion | AC3 | NotificationService#notify_membership_expiration | - |
| Notifications cotisation | AC4 | NotificationService#notify_contribution_purchase | - |
| Interface utilisateur | AC5 | - | Flux complet |
| Heures de silence | AC6 | NotificationDeliveryService#in_quiet_hours? | - |
| Gestion des erreurs | AC7 | NotificationDeliveryService#handle_delivery_error | - |
| Archivage notifications | AC8 | NotificationCleanupJob | - |

---

*Document créé le [DATE] - Version 1.0* 