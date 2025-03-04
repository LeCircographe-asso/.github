# Validation - Présence

## Identification du document

| Domaine           | Présence                            |
|-------------------|-------------------------------------|
| Version           | 1.0                                 |
| Référence         | VALID-PRE-2023-01                   |
| Dernière révision | [DATE]                              |

## Critères d'Acceptation

### CA-PRE-001: Création d'une liste de présence quotidienne
- **Étant donné** un administrateur authentifié
- **Quand** il crée une liste de présence quotidienne pour une date donnée
- **Alors** la liste est créée avec le statut "created"
- **Et** elle est configurée pour nécessiter une adhésion Cirque et une cotisation valide par défaut
- **Et** un job est planifié pour l'ouverture automatique le jour correspondant

### CA-PRE-002: Création d'une liste d'événement spécial
- **Étant donné** un administrateur authentifié
- **Quand** il crée une liste de présence pour un événement spécial
- **Alors** la liste est créée avec le statut "created"
- **Et** la liste est associée à l'événement spécifié
- **Et** les conditions d'accès peuvent être configurées spécifiquement

### CA-PRE-003: Ouverture d'une liste de présence
- **Étant donné** une liste de présence en statut "created"
- **Quand** elle est ouverte manuellement ou automatiquement
- **Alors** son statut passe à "open"
- **Et** la date et l'heure d'ouverture sont enregistrées
- **Et** l'enregistrement des présences devient possible

### CA-PRE-004: Clôture d'une liste de présence
- **Étant donné** une liste de présence en statut "open"
- **Quand** elle est clôturée manuellement ou automatiquement
- **Alors** son statut passe à "closed"
- **Et** la date et l'heure de clôture sont enregistrées
- **Et** l'enregistrement des présences n'est plus possible
- **Et** un job est planifié pour le calcul des statistiques

### CA-PRE-005: Validation de l'unicité des listes quotidiennes
- **Étant donné** une liste quotidienne existante pour une date donnée
- **Quand** un administrateur tente de créer une seconde liste quotidienne pour la même date
- **Alors** une erreur est générée
- **Et** la seconde liste n'est pas créée

### CA-PRE-006: Enregistrement d'une présence standard
- **Étant donné** une liste de présence ouverte
- **Et** un membre avec une adhésion Cirque valide et une cotisation active
- **Quand** un administrateur ou bénévole enregistre sa présence
- **Alors** une entrée est créée sur la liste
- **Et** la cotisation appropriée est sélectionnée selon l'ordre de priorité
- **Et** une entrée est décomptée pour les carnets ou pass journée

### CA-PRE-007: Vérification des conditions d'accès
- **Étant donné** une liste de présence ouverte nécessitant adhésion Cirque et cotisation
- **Et** un membre avec une adhésion expirée ou sans cotisation valide
- **Quand** un administrateur tente d'enregistrer sa présence
- **Alors** une erreur est générée
- **Et** l'entrée n'est pas enregistrée

### CA-PRE-008: Enregistrement des heures de sortie
- **Étant donné** un membre déjà enregistré sur une liste ouverte
- **Quand** son heure de sortie est enregistrée
- **Alors** l'entrée est mise à jour avec cette information
- **Et** la durée de présence peut être calculée

### CA-PRE-009: Calcul des statistiques
- **Étant donné** une liste de présence clôturée
- **Quand** les statistiques sont calculées
- **Alors** les compteurs sont mis à jour avec précision
- **Et** l'analyse des heures de pointe est effectuée
- **Et** les statistiques par type de cotisation sont disponibles

### CA-PRE-010: Gestion des limites de capacité
- **Étant donné** une liste de présence avec une capacité définie
- **Quand** le nombre maximum de présences est atteint
- **Alors** toute nouvelle tentative d'enregistrement est refusée
- **Et** une notification est générée pour les administrateurs

## Scénarios de Test

### Scénario 1: Cycle de vie d'une liste quotidienne
```gherkin
Feature: Gestion du cycle de vie d'une liste de présence
  Scenario: Liste quotidienne - création jusqu'à archivage
    Given un administrateur authentifié
    When il crée une liste quotidienne pour demain
    Then la liste est créée avec le statut "created"
    
    When l'heure d'ouverture automatique est atteinte
    Then la liste passe au statut "open"
    And l'heure d'ouverture est enregistrée
    
    When des présences sont enregistrées sur la liste
    Then les entrées sont correctement créées
    
    When l'heure de fermeture automatique est atteinte
    Then la liste passe au statut "closed"
    And l'heure de clôture est enregistrée
    
    When 30 jours se sont écoulés
    Then la liste passe au statut "archived"
    And l'heure d'archivage est enregistrée
```

### Scénario 2: Enregistrement de présence avec différentes cotisations
```gherkin
Feature: Enregistrement des présences avec priorité des cotisations
  Scenario: Sélection automatique de la cotisation appropriée
    Given un membre avec une adhésion Cirque valide
    And un abonnement annuel actif
    And un carnet avec des entrées restantes
    
    When un bénévole enregistre sa présence sur une liste ouverte
    Then l'abonnement annuel est sélectionné automatiquement
    And aucune entrée n'est décomptée du carnet
    
    When l'abonnement annuel expire
    And le bénévole enregistre une nouvelle présence
    Then une entrée du carnet est utilisée
    And le nombre d'entrées restantes est décrémenté
```

### Scénario 3: Vérification des restrictions d'accès
```gherkin
Feature: Restrictions d'accès aux entraînements
  Scenario: Tentative d'enregistrement sans conditions requises
    Given une liste de présence ouverte
    And configurée pour nécessiter adhésion Cirque et cotisation
    
    When un bénévole tente d'enregistrer un membre sans adhésion Cirque
    Then une erreur "Adhésion Cirque requise" est affichée
    And aucune entrée n'est créée
    
    When un bénévole tente d'enregistrer un membre avec adhésion Cirque mais sans cotisation
    Then une erreur "Cotisation valide requise" est affichée
    And aucune entrée n'est créée
```

### Scénario 4: Gestion de la capacité maximale
```gherkin
Feature: Respect de la capacité maximale
  Scenario: Atteinte de la capacité maximale
    Given une liste de présence avec capacité de 3 personnes
    And 2 personnes déjà enregistrées
    
    When un bénévole enregistre une 3ème personne
    Then l'entrée est créée avec succès
    And la liste affiche 0 places disponibles
    
    When un bénévole tente d'enregistrer une 4ème personne
    Then une erreur "Capacité maximale atteinte" est affichée
    And l'entrée n'est pas créée
```

### Scénario 5: Calcul et consultation des statistiques
```gherkin
Feature: Génération et consultation des statistiques
  Scenario: Statistiques après clôture
    Given une liste de présence avec plusieurs entrées
    And différents types de cotisations utilisées
    
    When la liste est clôturée
    Then les statistiques sont calculées automatiquement
    
    When un administrateur consulte les statistiques
    Then il peut voir le nombre total de présences
    And la répartition par type de cotisation
    And l'heure de pointe identifiée
    And la durée moyenne de présence calculée
```

## Tests Unitaires

### Tests du modèle `AttendanceList`

```ruby
RSpec.describe AttendanceList, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      attendance_list = build(:attendance_list, list_type: :daily, date: Date.tomorrow)
      expect(attendance_list).to be_valid
    end
    
    it "prevents duplicate daily lists for same date" do
      create(:attendance_list, list_type: :daily, date: Date.tomorrow)
      duplicate = build(:attendance_list, list_type: :daily, date: Date.tomorrow)
      expect(duplicate).not_to be_valid
    end
    
    it "allows duplicate event lists for same date" do
      create(:attendance_list, list_type: :event, date: Date.tomorrow)
      duplicate = build(:attendance_list, list_type: :event, date: Date.tomorrow)
      expect(duplicate).to be_valid
    end
    
    it "validates status transitions" do
      list = create(:attendance_list, status: :created)
      
      # Allowed: created -> open
      expect(list.update(status: :open)).to be true
      
      # Allowed: open -> closed
      expect(list.update(status: :closed)).to be true
      
      # Allowed: closed -> archived
      expect(list.update(status: :archived)).to be true
      
      # Create a new list
      list = create(:attendance_list, status: :created)
      
      # Not allowed: created -> closed (skipping open)
      expect(list.update(status: :closed)).to be false
      
      # Not allowed: created -> archived (skipping stages)
      expect(list.update(status: :archived)).to be false
    end
  end
  
  describe "methods" do
    it "calculates available spots correctly" do
      list = create(:attendance_list, capacity: 10)
      3.times { create(:attendance, attendance_list: list) }
      
      expect(list.available_spots).to eq(7)
    end
    
    it "checks if a list is full" do
      list = create(:attendance_list, capacity: 2)
      2.times { create(:attendance, attendance_list: list) }
      
      expect(list.full?).to be true
    end
    
    it "unlimited capacity when capacity is 0" do
      list = create(:attendance_list, capacity: 0)
      10.times { create(:attendance, attendance_list: list) }
      
      expect(list.full?).to be false
      expect(list.available_spots).to be_nil
    end
    
    it "determines if a user can register" do
      list = create(:attendance_list, requires_cirque: true, requires_contribution: true)
      
      user_without_membership = create(:user)
      expect(list.can_register?(user_without_membership)).to be false
      
      user_with_basic = create(:user)
      create(:membership, user: user_with_basic, membership_type: :basic, status: :active)
      expect(list.can_register?(user_with_basic)).to be false
      
      user_with_cirque = create(:user)
      create(:membership, user: user_with_cirque, membership_type: :cirque, status: :active)
      expect(list.can_register?(user_with_cirque)).to be false
      
      user_with_cirque_and_contribution = create(:user)
      create(:membership, user: user_with_cirque_and_contribution, membership_type: :cirque, status: :active)
      create(:contribution, user: user_with_cirque_and_contribution, status: :active)
      expect(list.can_register?(user_with_cirque_and_contribution)).to be true
    end
  end
end
```

### Tests du modèle `Attendance`

```ruby
RSpec.describe Attendance, type: :model do
  describe "validations" do
    it "requires an entry time" do
      attendance = build(:attendance, entry_time: nil)
      expect(attendance).not_to be_valid
    end
    
    it "ensures exit time is after entry time" do
      attendance = build(:attendance, 
                         entry_time: Time.current, 
                         exit_time: 1.hour.ago)
      expect(attendance).not_to be_valid
      
      attendance.exit_time = 1.hour.from_now
      expect(attendance).to be_valid
    end
    
    it "prevents duplicate attendance for the same user on the same list" do
      list = create(:attendance_list)
      user = create(:user)
      create(:attendance, attendance_list: list, user: user)
      
      duplicate = build(:attendance, attendance_list: list, user: user)
      expect(duplicate).not_to be_valid
    end
  end
  
  describe "callbacks" do
    context "when using a limited contribution" do
      it "decrements entries left for entry packs" do
        user = create(:user)
        contribution = create(:contribution, 
                              user: user, 
                              contribution_type: :entry_pack, 
                              entries_left: 5)
        
        expect {
          create(:attendance, user: user, contribution: contribution)
        }.to change { contribution.reload.entries_left }.from(5).to(4)
      end
      
      it "sets entries left to 0 for pass day" do
        user = create(:user)
        contribution = create(:contribution, 
                              user: user, 
                              contribution_type: :pass_day, 
                              entries_left: 1)
        
        expect {
          create(:attendance, user: user, contribution: contribution)
        }.to change { contribution.reload.entries_left }.from(1).to(0)
      end
      
      it "doesn't affect unlimited contributions" do
        user = create(:user)
        contribution = create(:contribution, 
                              user: user, 
                              contribution_type: :subscription_annual)
        
        expect {
          create(:attendance, user: user, contribution: contribution)
        }.not_to change { contribution.reload.entries_left }
      end
    end
  end
  
  describe "methods" do
    it "calculates duration in minutes" do
      attendance = create(:attendance, 
                          entry_time: 2.hours.ago,
                          exit_time: 1.hour.ago)
      
      expect(attendance.duration_minutes).to be_within(1).of(60)
    end
    
    it "returns nil duration when exit time not recorded" do
      attendance = create(:attendance, exit_time: nil)
      expect(attendance.duration_minutes).to be_nil
    end
    
    it "records exit time" do
      attendance = create(:attendance, exit_time: nil)
      expect {
        attendance.record_exit!
      }.to change { attendance.exit_time }.from(nil)
    end
  end
end
```

## Tests du Service d'Enregistrement

```ruby
RSpec.describe AttendanceRegistrationService do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:attendance_list) { create(:attendance_list, status: :open) }
  
  before do
    create(:membership, user: user, membership_type: :cirque, status: :active)
  end
  
  describe "#register" do
    context "with valid parameters" do
      it "registers attendance with annual subscription" do
        # Create an annual subscription
        annual = create(:contribution, 
                      user: user, 
                      contribution_type: :subscription_annual, 
                      status: :active)
        
        # Also create a pack that should not be used
        pack = create(:contribution, 
                   user: user, 
                   contribution_type: :entry_pack, 
                   status: :active,
                   entries_left: 10)
        
        service = AttendanceRegistrationService.new(attendance_list, user, admin)
        result = service.register
        
        expect(result).to be_a(Attendance)
        expect(result.contribution).to eq(annual)
        expect(pack.reload.entries_left).to eq(10) # Pack should not be decremented
      end
      
      it "registers attendance with entry pack when no subscription" do
        pack = create(:contribution, 
                   user: user, 
                   contribution_type: :entry_pack, 
                   status: :active,
                   entries_left: 10)
        
        service = AttendanceRegistrationService.new(attendance_list, user, admin)
        result = service.register
        
        expect(result).to be_a(Attendance)
        expect(result.contribution).to eq(pack)
        expect(pack.reload.entries_left).to eq(9) # Pack should be decremented
      end
    end
    
    context "with invalid parameters" do
      it "fails when list is not open" do
        closed_list = create(:attendance_list, status: :closed)
        service = AttendanceRegistrationService.new(closed_list, user, admin)
        
        result = service.register
        expect(result).to be false
        expect(service.errors).to include(/must be open/)
      end
      
      it "fails when user is already registered" do
        create(:attendance, attendance_list: attendance_list, user: user)
        
        service = AttendanceRegistrationService.new(attendance_list, user, admin)
        result = service.register
        
        expect(result).to be false
        expect(service.errors).to include(/déjà enregistré/)
      end
      
      it "fails when user has no valid contributions" do
        attendance_list.update(requires_contribution: true)
        
        service = AttendanceRegistrationService.new(attendance_list, user, admin)
        result = service.register
        
        expect(result).to be false
        expect(service.errors).to include(/cotisation valide/)
      end
    end
  end
end
```

## Tests d'Intégration

### Gestion des listes de présence

```ruby
RSpec.describe "Gestion des listes de présence", type: :request do
  let(:admin) { create(:user, :admin) }
  
  before do
    sign_in admin
  end
  
  describe "GET /api/v1/attendance_lists" do
    it "returns all attendance lists" do
      create_list(:attendance_list, 3)
      
      get "/api/v1/attendance_lists"
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
    
    it "filters by date" do
      create(:attendance_list, date: Date.today)
      create(:attendance_list, date: Date.tomorrow)
      
      get "/api/v1/attendance_lists", params: { date: Date.today.to_s }
      
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end
  
  describe "POST /api/v1/attendance_lists" do
    it "creates a new attendance list" do
      list_params = {
        list_type: 'daily',
        date: Date.tomorrow.to_s,
        capacity: 50,
        requires_cirque: true,
        requires_contribution: true
      }
      
      expect {
        post "/api/v1/attendance_lists", params: { attendance_list: list_params }
      }.to change(AttendanceList, :count).by(1)
      
      expect(response).to have_http_status(:created)
    end
    
    it "prevents duplicate daily lists" do
      create(:attendance_list, list_type: :daily, date: Date.tomorrow)
      
      list_params = {
        list_type: 'daily',
        date: Date.tomorrow.to_s
      }
      
      expect {
        post "/api/v1/attendance_lists", params: { attendance_list: list_params }
      }.not_to change(AttendanceList, :count)
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe "POST /api/v1/attendance_lists/:id/open" do
    it "opens a created list" do
      list = create(:attendance_list, status: :created)
      
      post "/api/v1/attendance_lists/#{list.id}/open"
      
      expect(response).to have_http_status(:ok)
      expect(list.reload.status).to eq("open")
      expect(list.opened_at).to be_present
    end
    
    it "fails to open already open list" do
      list = create(:attendance_list, status: :open)
      
      post "/api/v1/attendance_lists/#{list.id}/open"
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe "POST /api/v1/attendance_lists/:id/close" do
    it "closes an open list" do
      list = create(:attendance_list, status: :open)
      
      post "/api/v1/attendance_lists/#{list.id}/close"
      
      expect(response).to have_http_status(:ok)
      expect(list.reload.status).to eq("closed")
      expect(list.closed_at).to be_present
    end
  end
end
```

### Gestion des présences

```ruby
RSpec.describe "Gestion des présences", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:attendance_list) { create(:attendance_list, status: :open) }
  
  before do
    sign_in admin
    create(:membership, user: user, membership_type: :cirque, status: :active)
    create(:contribution, user: user, contribution_type: :entry_pack, status: :active, entries_left: 10)
  end
  
  describe "POST /api/v1/attendance_lists/:list_id/attendances" do
    it "registers a user's attendance" do
      expect {
        post "/api/v1/attendance_lists/#{attendance_list.id}/attendances", 
             params: { user_id: user.id }
      }.to change(Attendance, :count).by(1)
      
      expect(response).to have_http_status(:created)
      
      contribution = user.contributions.first
      expect(contribution.reload.entries_left).to eq(9)
    end
    
    it "prevents duplicate registration" do
      create(:attendance, attendance_list: attendance_list, user: user)
      
      expect {
        post "/api/v1/attendance_lists/#{attendance_list.id}/attendances", 
             params: { user_id: user.id }
      }.not_to change(Attendance, :count)
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe "POST /api/v1/attendance_lists/:list_id/attendances/:id/record_exit" do
    it "records exit time for an attendance" do
      attendance = create(:attendance, 
                          attendance_list: attendance_list, 
                          user: user, 
                          exit_time: nil)
      
      post "/api/v1/attendance_lists/#{attendance_list.id}/attendances/#{attendance.id}/record_exit"
      
      expect(response).to have_http_status(:ok)
      expect(attendance.reload.exit_time).to be_present
    end
  end
  
  describe "GET /api/v1/attendances/user/:user_id" do
    it "returns user's attendance history" do
      attendance1 = create(:attendance, 
                          attendance_list: attendance_list, 
                          user: user)
      
      other_list = create(:attendance_list, status: :open)
      attendance2 = create(:attendance, 
                          attendance_list: other_list, 
                          user: user)
      
      # Create attendance for another user which should not be returned
      other_user = create(:user)
      create(:attendance, attendance_list: attendance_list, user: other_user)
      
      get "/api/v1/attendances/user/#{user.id}"
      
      expect(response).to have_http_status(:ok)
      
      body = JSON.parse(response.body)
      expect(body.size).to eq(2)
      expect(body.map { |a| a["id"] }).to include(attendance1.id, attendance2.id)
    end
  end
end
```

## Plan de Tests Complémentaires

### Tests de performance
- Tests de charge pour la création simultanée de nombreuses présences
- Tests de performance des requêtes statistiques
- Tests de concurrence pour l'enregistrement des sorties

### Tests de sécurité
- Vérification des permissions selon les différents rôles
- Tests d'injection dans les paramètres de recherche
- Vérification de la protection des données personnelles

### Tests de résilience
- Comportement en cas d'erreur lors de l'enregistrement
- Reprise sur erreur des jobs automatisés
- Gestion des cas limites (listes à capacité élevée, historiques volumineux)

## Matrice de Traçabilité

| Règle Métier | Critère d'Acceptation | Test Unitaire | Test d'Intégration |
|--------------|------------------------|---------------|-------------------|
| Types de listes | CA-PRE-001, CA-PRE-002 | AttendanceList#validations | "Gestion des listes" |
| Cycle de vie | CA-PRE-003, CA-PRE-004 | AttendanceList#status_transitions | "Cycle de vie d'une liste" |
| Unicité quotidienne | CA-PRE-005 | AttendanceList#prevents_duplicate | "Prevents duplicate daily lists" |
| Enregistrement présence | CA-PRE-006 | AttendanceRegistrationService | "Registers a user's attendance" |
| Conditions d'accès | CA-PRE-007 | AttendanceList#can_register? | "Validation des restrictions" |
| Heures entrée/sortie | CA-PRE-008 | Attendance#duration_minutes | "Records exit time" |
| Statistiques | CA-PRE-009 | AttendanceStatistic#recalculate! | "Statistiques après clôture" |
| Capacité | CA-PRE-010 | AttendanceList#full? | "Atteinte de la capacité maximale" |

---

*Document créé le [DATE] - Version 1.0* 