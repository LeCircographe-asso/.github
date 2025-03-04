# Validation - Rôles

## Identification du Document
- **Domaine**: Rôles
- **Version**: 1.1.0
- **Référence**: VALID-ROL-2023-01
- **Dernière révision**: [DATE]

## Critères d'Acceptation

### AC1: Attribution automatique du rôle Membre
1. **Étant donné** un utilisateur sans rôle
2. **Quand** il souscrit à une adhésion (Basic ou Cirque) et que le paiement est validé
3. **Alors** le rôle "Membre" doit être automatiquement attribué
4. **Et** l'utilisateur doit avoir accès aux fonctionnalités de base réservées aux membres

### AC2: Attribution du rôle Bénévole
1. **Étant donné** un utilisateur avec le rôle "Membre"
2. **Quand** un Admin lui attribue le rôle "Bénévole"
3. **Alors** le rôle "Bénévole" doit être ajouté en complément du rôle "Membre"
4. **Et** l'utilisateur doit avoir accès aux fonctionnalités administratives de base
5. **Et** un enregistrement doit être créé dans le journal d'audit

### AC3: Attribution du rôle Admin
1. **Étant donné** un utilisateur avec le rôle "Membre"
2. **Quand** un Super-Admin lui attribue le rôle "Admin"
3. **Alors** le rôle "Admin" doit être ajouté en complément du rôle "Membre"
4. **Et** l'utilisateur doit avoir accès aux fonctionnalités administratives étendues
5. **Et** un enregistrement doit être créé dans le journal d'audit

### AC4: Suspension automatique lors de l'expiration d'adhésion
1. **Étant donné** un utilisateur avec des rôles actifs (Membre, Bénévole, etc.)
2. **Quand** son adhésion expire
3. **Alors** tous ses rôles doivent être automatiquement suspendus (mais pas supprimés)
4. **Et** l'utilisateur ne doit plus avoir accès aux fonctionnalités réservées à ces rôles
5. **Et** l'utilisateur doit conserver l'accès à ses données personnelles et historique

### AC5: Réactivation automatique après renouvellement d'adhésion
1. **Étant donné** un utilisateur avec des rôles suspendus suite à l'expiration de son adhésion
2. **Quand** il renouvelle son adhésion
3. **Alors** tous ses rôles doivent être automatiquement réactivés
4. **Et** l'utilisateur doit retrouver l'accès aux fonctionnalités associées à ses rôles
5. **Et** un enregistrement doit être créé dans le journal d'audit

### AC6: Accès différencié selon le type d'adhésion
1. **Étant donné** un utilisateur avec le rôle "Membre" et différents types d'adhésion
2. **Quand** il tente d'accéder aux entraînements
3. **Alors** l'accès doit être accordé uniquement s'il possède une adhésion Cirque valide ET une cotisation valide
4. **Et** un message approprié doit être affiché en cas de refus

### AC7: Compatibilité des rôles multiples
1. **Étant donné** un utilisateur avec le rôle "Membre"
2. **Quand** il reçoit des rôles additionnels (Bénévole, Admin)
3. **Alors** tous les rôles doivent coexister sans conflit
4. **Et** l'utilisateur doit avoir accès à toutes les fonctionnalités associées à ses rôles

### AC8: Gestion des permissions
1. **Étant donné** un utilisateur avec un rôle spécifique
2. **Quand** il tente d'accéder à une fonctionnalité
3. **Alors** l'accès doit être accordé ou refusé selon la matrice de permissions
4. **Et** un message approprié doit être affiché en cas de refus

### AC9: Audit des modifications de rôle
1. **Étant donné** une opération de modification de rôle (attribution, suspension, réactivation)
2. **Quand** l'opération est effectuée
3. **Alors** un enregistrement complet doit être créé dans le journal d'audit
4. **Et** cet enregistrement doit être accessible aux administrateurs

### AC10: Attribution exclusive des rôles administratifs
1. **Étant donné** un utilisateur avec le rôle "Membre"
2. **Quand** un admin tente d'attribuer le rôle "Admin"
3. **Alors** une erreur doit être générée
4. **Et** un message doit indiquer que seul un Super-Admin peut attribuer ce rôle
5. **Et** le rôle "Admin" ne doit pas être attribué

## Scénarios de Test

### Scénario 1: Cycle de vie complet du rôle Membre
```gherkin
Feature: Gestion du rôle Membre
  Scenario: Cycle complet d'un rôle Membre
    Given un utilisateur sans rôle
    When l'utilisateur souscrit à une adhésion Basic
    And le paiement est validé
    Then son rôle devrait être "Membre"
    And il devrait pouvoir accéder à son profil
    When son adhésion expire
    Then son rôle Membre devrait être suspendu
    And il ne devrait plus pouvoir accéder à son profil
    When il renouvelle son adhésion
    Then son rôle Membre devrait être réactivé
    And il devrait à nouveau pouvoir accéder à son profil
```

### Scénario 2: Gestion du rôle Bénévole
```gherkin
Feature: Gestion du rôle Bénévole
  Scenario: Attribution et suspension du rôle Bénévole
    Given un utilisateur avec le rôle "Membre"
    When un Admin lui attribue le rôle "Bénévole"
    Then l'utilisateur devrait avoir les rôles "Membre" et "Bénévole"
    And il devrait pouvoir accéder aux fonctionnalités de gestion des présences
    When son adhésion expire
    Then tous ses rôles devraient être suspendus
    And il ne devrait plus pouvoir accéder aux fonctionnalités de gestion des présences
    When il renouvelle son adhésion
    Then tous ses rôles devraient être réactivés
    And il devrait à nouveau pouvoir accéder aux fonctionnalités de gestion des présences
```

### Scénario 3: Attribution des rôles administratifs
```gherkin
Feature: Attribution des rôles administratifs
  Scenario: Attribution du rôle Admin
    Given un utilisateur avec le rôle "Membre"
    When un Super-Admin lui attribue le rôle "Admin"
    Then l'utilisateur devrait avoir les rôles "Membre" et "Admin"
    And il devrait pouvoir accéder aux statistiques complètes
    And il devrait pouvoir attribuer le rôle "Bénévole" à d'autres utilisateurs
    But il ne devrait pas pouvoir attribuer le rôle "Admin" à d'autres utilisateurs
```

### Scénario 4: Accès aux entraînements selon l'adhésion
```gherkin
Feature: Accès différencié selon l'adhésion
  Scenario: Tentatives d'accès aux entraînements
    Given un utilisateur avec le rôle "Membre" et une adhésion Basic
    When il tente d'accéder aux entraînements
    Then l'accès devrait être refusé
    And un message devrait indiquer que l'adhésion Cirque est requise
    When il souscrit à une adhésion Cirque
    But il n'a pas de cotisation valide
    Then l'accès devrait être refusé
    And un message devrait indiquer qu'une cotisation valide est requise
    When il achète une cotisation valide
    Then l'accès aux entraînements devrait être accordé
```

### Scénario 5: Audit des changements de rôle
```gherkin
Feature: Audit des modifications de rôle
  Scenario: Journalisation des modifications de rôle
    Given un utilisateur avec le rôle "Membre"
    When un Admin lui attribue le rôle "Bénévole"
    Then un enregistrement devrait être créé dans le journal d'audit
    And cet enregistrement devrait inclure la date, l'administrateur et le motif
    When l'utilisateur perd tous ses rôles suite à l'expiration de son adhésion
    Then un nouvel enregistrement devrait être créé dans le journal d'audit
    And cet enregistrement devrait indiquer le motif "Adhésion expirée"
```

## Tests Unitaires

### Tests pour le modèle `Role`
```ruby
RSpec.describe Role, type: :model do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  
  describe "validations" do
    it "is valid with valid attributes" do
      role = build(:role, user: user, role_type: :membre)
      expect(role).to be_valid
    end
    
    it "requires a role_type" do
      role = build(:role, user: user, role_type: nil)
      expect(role).not_to be_valid
    end
    
    it "requires a user" do
      role = build(:role, user: nil, role_type: :membre)
      expect(role).not_to be_valid
    end
    
    it "validates uniqueness of role_type per user" do
      create(:role, user: user, role_type: :membre)
      duplicate = build(:role, user: user, role_type: :membre)
      expect(duplicate).not_to be_valid
    end
  end
  
  describe "scopes" do
    it "returns active roles" do
      active = create(:role, user: user, role_type: :membre, active: true, suspended: false)
      inactive = create(:role, user: user, role_type: :benevole, active: false)
      suspended = create(:role, user: user, role_type: :admin, active: true, suspended: true)
      
      expect(Role.active).to include(active)
      expect(Role.active).not_to include(inactive)
      expect(Role.active.where(suspended: false)).not_to include(suspended)
    end
    
    it "returns roles by type" do
      membre = create(:role, user: user, role_type: :membre)
      admin_role = create(:role, user: admin, role_type: :admin)
      
      expect(Role.of_type(:membre)).to include(membre)
      expect(Role.of_type(:membre)).not_to include(admin_role)
    end
  end
  
  describe "status transitions" do
    it "can be suspended" do
      role = create(:role, user: user, role_type: :benevole)
      expect(role.suspended).to be false
      
      role.suspend!("Adhésion expirée")
      expect(role.suspended).to be true
      expect(role.suspended_reason).to eq("Adhésion expirée")
    end
    
    it "can be reactivated" do
      role = create(:role, user: user, role_type: :benevole, suspended: true)
      
      role.reactivate!
      expect(role.suspended).to be false
    end
  end
end
```

### Tests pour le service `RoleManager`
```ruby
RSpec.describe RoleManager, type: :service do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:super_admin) { create(:user, :super_admin) }
  
  describe "#assign_role" do
    it "assigns membre role automatically on valid membership" do
      create(:membership, user: user, status: :active)
      result = RoleManager.assign_role(user, :membre)
      
      expect(result).to be_success
      expect(user.roles.active.of_type(:membre)).to exist
    end
    
    it "allows admin to assign benevole role" do
      create(:membership, user: user, status: :active)
      create(:role, user: user, role_type: :membre)
      result = RoleManager.assign_role(user, :benevole, assigned_by: admin)
      
      expect(result).to be_success
      expect(user.roles.active.of_type(:benevole)).to exist
    end
    
    it "prevents admin from assigning admin role" do
      create(:membership, user: user, status: :active)
      create(:role, user: user, role_type: :membre)
      result = RoleManager.assign_role(user, :admin, assigned_by: admin)
      
      expect(result).not_to be_success
      expect(result.errors).to include("Droits insuffisants pour attribuer le rôle Admin")
    end
    
    it "allows super_admin to assign admin role" do
      create(:membership, user: user, status: :active)
      create(:role, user: user, role_type: :membre)
      result = RoleManager.assign_role(user, :admin, assigned_by: super_admin)
      
      expect(result).to be_success
      expect(user.roles.active.of_type(:admin)).to exist
    end
  end
  
  describe "#suspend_roles_on_membership_expiration" do
    it "suspends all roles when membership expires" do
      create(:role, user: user, role_type: :membre)
      create(:role, user: user, role_type: :benevole)
      
      RoleManager.suspend_roles_on_membership_expiration(user)
      
      user.roles.each do |role|
        expect(role.suspended).to be true
      end
    end
  end
  
  describe "#reactivate_roles_after_renewal" do
    it "reactivates all suspended roles after membership renewal" do
      create(:role, user: user, role_type: :membre, suspended: true)
      create(:role, user: user, role_type: :benevole, suspended: true)
      
      RoleManager.reactivate_roles_after_renewal(user)
      
      user.roles.each do |role|
        expect(role.suspended).to be false
      end
    end
  end
end
```

## Tests d'Intégration

### Flux changement de rôle automatique
```ruby
RSpec.describe "Changement de rôle automatique", type: :feature do
  let(:user) { create(:user) }
  
  scenario "Attribution et suspension du rôle Membre" do
    # Création d'une adhésion
    visit new_membership_path
    fill_in "Nom", with: "Utilisateur Test"
    select "Basic", from: "Type d'adhésion"
    click_button "Continuer"
    
    # Simulation de paiement validé
    # ...
    
    # Vérification du rôle
    visit profile_path
    expect(page).to have_content("Membre")
    expect(page).to have_content("Mon profil")
    
    # Simulation d'expiration d'adhésion
    Timecop.travel(1.year.from_now)
    RoleManager.check_and_update_roles_based_on_memberships
    
    # Vérification de la suspension
    visit profile_path
    expect(page).to have_content("Votre adhésion a expiré")
    expect(page).to have_content("Vos rôles sont temporairement suspendus")
    expect(page).to have_content("Mon profil") # Accès maintenu aux données personnelles
    expect(page).not_to have_content("Acheter une cotisation") # Fonctionnalité restreinte
  end
  
  scenario "Attribution et suspension du rôle Bénévole" do
    admin = create(:user, :admin)
    
    # Connexion en tant qu'admin
    login_as(admin)
    
    # Création d'un utilisateur avec adhésion
    create(:membership, user: user, status: :active)
    create(:role, user: user, role_type: :membre)
    
    # Attribution du rôle Bénévole
    visit user_path(user)
    click_link "Gestion des rôles"
    check "Bénévole"
    click_button "Enregistrer"
    
    # Vérification
    expect(page).to have_content("Rôle attribué avec succès")
    
    # Vérification des permissions
    login_as(user)
    visit attendances_path
    expect(page).to have_content("Liste des présences")
    
    # Simulation d'expiration d'adhésion
    Timecop.travel(1.year.from_now)
    RoleManager.check_and_update_roles_based_on_memberships
    
    # Vérification de la suspension
    visit attendances_path
    expect(page).to have_content("Accès restreint")
    expect(page).to have_content("Votre adhésion a expiré, certaines fonctionnalités sont temporairement indisponibles")
  end
end
```

## Plan de Test

### Tests de performance
- Attribution massive de rôles (benchmark)
- Vérification d'autorisation pour un grand nombre d'utilisateurs
- Gestion des rôles lors d'expiration d'adhésions en masse

### Tests de sécurité
- Vérification que les rôles protégés ne peuvent pas être attribués sans autorisation
- Vérification que les rôles ne peuvent pas être auto-attribués
- Vérification de l'isolation des vues et actions selon les rôles
- Vérification que l'expiration d'une adhésion ne peut pas être contournée

### Tests de robustesse
- Comportement du système lors de la suspension/réactivation répétée de rôles
- Cohérence des données de rôle après des transactions échouées
- Traitement des cas limites (exemple: renouvellement d'adhésion le jour même de l'expiration)

## Matrice de Traçabilité

| ID | Règle | Critère d'acceptation | Test Unitaire | Test Intégration |
|----|-------|------------------------|---------------|------------------|
| R1 | Attribution automatique du rôle Membre | AC1 | Role#validate | Attribution et suspension du rôle Membre |
| R2 | Attribution manuelle des rôles administratifs | AC2, AC3 | RoleManager#assign_role | Attribution et suspension du rôle Bénévole |
| R3 | Suspension des rôles à l'expiration d'adhésion | AC4 | RoleManager#suspend_roles_on_membership_expiration | Attribution et suspension du rôle Membre |
| R4 | Réactivation après renouvellement | AC5 | RoleManager#reactivate_roles_after_renewal | Attribution et suspension du rôle Membre |
| R5 | Accès différencié selon l'adhésion | AC6 | User#can_access_trainings? | Accès différencié selon l'adhésion |
| R6 | Compatibilité des rôles multiples | AC7 | Role#validate | Attribution des rôles administratifs |
| R7 | Gestion des permissions | AC8 | PermissionService#can_access? | Flux changement de rôle automatique |
| R8 | Audit des modifications | AC9 | RoleAuditLog model | Journalisation des modifications de rôle |
| R9 | Attribution exclusive des rôles | AC10 | RoleManager#assign_role | Attribution des rôles administratifs |

---

*Document créé le [DATE] - Version 1.1* 