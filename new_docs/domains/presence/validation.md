# Validation - Présence

## Identification du document

| Domaine           | Présence                            |
|-------------------|-------------------------------------|
| Version           | 1.0                                 |
| Référence         | VALID-PRE-2024-01                   |
| Dernière révision | Mars 2024                           |

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
- **Quand** un administrateur ou bénévole tente d'enregistrer sa présence
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

## Tests Unitaires

### Test du modèle `AttendanceList`

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
  end
  
  describe "state transitions" do
    it "follows correct state flow" do
      list = create(:attendance_list, status: :created)
      
      expect(list.open!).to be true
      expect(list).to be_open
      
      expect(list.close!).to be true
      expect(list).to be_closed
      
      expect(list.archive!).to be true
      expect(list).to be_archived
    end
    
    it "prevents invalid state transitions" do
      list = create(:attendance_list, status: :created)
      
      expect(list.close!).to be false
      expect(list.archive!).to be false
      
      list.update!(status: :open)
      expect(list.archive!).to be false
    end
  end
  
  describe "capacity management" do
    it "handles capacity limits correctly" do
      list = create(:attendance_list, capacity: 2)
      
      expect(list.can_register?(build(:user))).to be true
      create(:attendance, attendance_list: list)
      expect(list.can_register?(build(:user))).to be true
      create(:attendance, attendance_list: list)
      expect(list.can_register?(build(:user))).to be false
    end
    
    it "allows unlimited capacity" do
      list = create(:attendance_list, capacity: 0)
      10.times { create(:attendance, attendance_list: list) }
      expect(list.can_register?(build(:user))).to be true
    end
  end
end
```

### Test du modèle `Attendance`

```ruby
RSpec.describe Attendance, type: :model do
  describe "validations" do
    it "requires an open list" do
      list = create(:attendance_list, status: :closed)
      attendance = build(:attendance, attendance_list: list)
      expect(attendance).not_to be_valid
    end
    
    it "prevents duplicate entries" do
      list = create(:attendance_list)
      user = create(:user)
      create(:attendance, attendance_list: list, user: user)
      duplicate = build(:attendance, attendance_list: list, user: user)
      expect(duplicate).not_to be_valid
    end
    
    it "validates exit time" do
      attendance = build(:attendance, 
        entry_time: Time.current,
        exit_time: 1.hour.ago
      )
      expect(attendance).not_to be_valid
    end
  end
  
  describe "duration calculation" do
    it "calculates duration correctly" do
      entry_time = Time.current
      exit_time = entry_time + 2.hours
      attendance = create(:attendance, 
        entry_time: entry_time,
        exit_time: exit_time
      )
      expect(attendance.duration_minutes).to eq(120)
    end
  end
end
```

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
```

### Scénario 2: Enregistrement de présence avec cotisations
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

### Scénario 3: Gestion de la capacité
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