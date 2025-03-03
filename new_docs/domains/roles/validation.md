# Validation - Rôles

## Identification du Document
- **Domaine**: Rôles
- **Version**: 1.1.0
- **Référence**: VALID-ROL-2024-01
- **Dernière révision**: Mars 2024

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
    Then son rôle devrait être "member"
    And il devrait pouvoir accéder à son profil
    When son adhésion expire
    Then son rôle member devrait être suspendu
    And il ne devrait plus pouvoir accéder à son profil
    When il renouvelle son adhésion
    Then son rôle member devrait être réactivé
    And il devrait à nouveau pouvoir accéder à son profil
```

### Scénario 2: Gestion du rôle Bénévole
```gherkin
Feature: Gestion du rôle Bénévole
  Scenario: Attribution et suspension du rôle Bénévole
    Given un utilisateur avec le rôle "member"
    When un Admin lui attribue le rôle "volunteer"
    Then l'utilisateur devrait avoir les rôles "member" et "volunteer"
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
    Given un utilisateur avec le rôle "member"
    When un Super-Admin lui attribue le rôle "admin"
    Then l'utilisateur devrait avoir les rôles "member" et "admin"
    And il devrait pouvoir accéder aux statistiques complètes
    And il devrait pouvoir attribuer le rôle "volunteer" à d'autres utilisateurs
    But il ne devrait pas pouvoir attribuer le rôle "admin" à d'autres utilisateurs
```

### Scénario 4: Accès aux entraînements selon l'adhésion
```gherkin
Feature: Accès différencié selon l'adhésion
  Scenario: Tentatives d'accès aux entraînements
    Given un utilisateur avec le rôle "member" et une adhésion Basic
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
    Given un utilisateur avec le rôle "member"
    When un Admin lui attribue le rôle "volunteer"
    Then un enregistrement devrait être créé dans le journal d'audit
    And cet enregistrement devrait inclure la date, l'administrateur et le motif
    When l'utilisateur perd tous ses rôles suite à l'expiration de son adhésion
    Then un nouvel enregistrement devrait être créé dans le journal d'audit
    And cet enregistrement devrait indiquer le motif "Membership expired"
```

## Tests Unitaires

### Tests pour le modèle `Role`
```ruby
RSpec.describe Role, type: :model do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  
  describe "validations" do
    it "is valid with valid attributes" do
      role = build(:role, user: user, role_type: :member)
      expect(role).to be_valid
    end
    
    it "requires a role_type" do
      role = build(:role, user: user, role_type: nil)
      expect(role).not_to be_valid
    end
    
    it "requires a user" do
      role = build(:role, user: nil, role_type: :member)
      expect(role).not_to be_valid
    end
    
    it "validates uniqueness of role_type per user" do
      create(:role, user: user, role_type: :member)
      duplicate = build(:role, user: user, role_type: :member)
      expect(duplicate).not_to be_valid
    end
  end
  
  describe "scopes" do
    it "returns active roles" do
      active = create(:role, user: user, role_type: :member, active: true, suspended: false)
      inactive = create(:role, user: user, role_type: :volunteer, active: false)
      suspended = create(:role, user: user, role_type: :admin, active: true, suspended: true)
      
      expect(Role.active).to include(active)
      expect(Role.active).not_to include(inactive)
      expect(Role.active.where(suspended: false)).not_to include(suspended)
    end
    
    it "returns roles by type" do
      member = create(:role, user: user, role_type: :member)
      admin_role = create(:role, user: admin, role_type: :admin)
      
      expect(Role.of_type(:member)).to include(member)
      expect(Role.of_type(:member)).not_to include(admin_role)
    end
  end
  
  describe "status transitions" do
    it "can be suspended" do
      role = create(:role, user: user, role_type: :volunteer)
      expect(role.suspended).to be false
      
      role.suspend!("Membership expired")
      expect(role.suspended).to be true
      expect(role.suspended_reason).to eq("Membership expired")
    end
    
    it "can be reactivated" do
      role = create(:role, user: user, role_type: :volunteer, suspended: true)
      
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
    it "assigns member role automatically on valid membership" do
      create(:membership, user: user, status: :active)
      result = RoleManager.assign_role(user, :member)
      
      expect(result).to be_success
      expect(user.roles.active.of_type(:member)).to exist
    end
    
    it "allows admin to assign volunteer role" do
      create(:membership, user: user, status: :active)
      create(:role, user: user, role_type: :member)
      result = RoleManager.assign_role(user, :volunteer, assigned_by: admin)
      
      expect(result).to be_success
      expect(user.roles.active.of_type(:volunteer)).to exist
    end
    
    it "prevents admin from assigning admin role" do
      create(:membership, user: user, status: :active)
      create(:role, user: user, role_type: :member)
      result = RoleManager.assign_role(user, :admin, assigned_by: admin)
      
      expect(result).not_to be_success
      expect(user.roles.active.of_type(:admin)).not_to exist
    end
    
    it "allows super_admin to assign admin role" do
      create(:membership, user: user, status: :active)
      create(:role, user: user, role_type: :member)
      result = RoleManager.assign_role(user, :admin, assigned_by: super_admin)
      
      expect(result).to be_success
      expect(user.roles.active.of_type(:admin)).to exist
    end
  end
  
  describe "#suspend_roles_on_membership_expiration" do
    it "suspends all roles when membership expires" do
      create(:role, user: user, role_type: :member)
      create(:role, user: user, role_type: :volunteer)
      
      RoleManager.suspend_roles_on_membership_expiration(user)
      
      expect(user.roles.active).to be_empty
      expect(user.roles.where(suspended: true).count).to eq(2)
    end
  end
  
  describe "#reactivate_roles_after_renewal" do
    it "reactivates all suspended roles after membership renewal" do
      member_role = create(:role, user: user, role_type: :member, suspended: true)
      volunteer_role = create(:role, user: user, role_type: :volunteer, suspended: true)
      
      RoleManager.reactivate_roles_after_renewal(user)
      
      expect(user.roles.active.count).to eq(2)
      expect(user.roles.where(suspended: true)).to be_empty
    end
  end
end
``` 