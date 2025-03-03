# Spécifications Techniques - Rôles

## Identification du document

| Domaine           | Rôles                               |
|-------------------|-------------------------------------|
| Version           | 1.1                                 |
| Référence         | SPEC-ROL-2024-01                    |
| Dernière révision | Mars 2024                           |

## Vue d'ensemble

Ce document détaille les spécifications techniques pour l'implémentation du système de rôles dans l'application Circographe. Le système gère quatre rôles principaux (Membre, Bénévole, Admin, Super-Admin) qui définissent les permissions et niveaux d'accès des utilisateurs, indépendamment de leur type d'adhésion.

## 1. Modèles de données

### 1.1 Modèle `Role`

#### Attributs
| Attribut         | Type      | Description                                    | Contraintes                 |
|------------------|-----------|------------------------------------------------|----------------------------|
| id               | Integer   | Identifiant unique                             | PK, Auto-increment         |
| user_id          | Integer   | Référence à l'utilisateur                      | FK, Not Null              |
| role_type        | Enum      | Type de rôle                                   | Not Null                  |
| active           | Boolean   | Statut actif du rôle                           | Default: true             |
| assigned_by_id   | Integer   | Référence à l'utilisateur ayant attribué le rôle | FK, Nullable              |
| assigned_at      | DateTime  | Date d'attribution                             | Nullable                  |
| expires_at       | DateTime  | Date d'expiration                              | Nullable                  |
| suspended        | Boolean   | Statut de suspension                           | Default: false            |
| suspended_reason | String    | Raison de la suspension                        | Nullable                  |
| suspended_at     | DateTime  | Date de suspension                             | Nullable                  |
| suspended_by_id  | Integer   | Référence à l'utilisateur ayant suspendu le rôle | FK, Nullable              |
| created_at       | DateTime  | Date de création                               | Not Null                  |
| updated_at       | DateTime  | Date de dernière modification                  | Not Null                  |

#### Implémentation

```ruby
class Role < ApplicationRecord
  # Enums
  enum role_type: {
    member: 0,
    volunteer: 1,
    admin: 2,
    super_admin: 3
  }

  # Associations
  belongs_to :user
  belongs_to :assigned_by, class_name: 'User', optional: true
  belongs_to :suspended_by, class_name: 'User', optional: true
  has_many :role_audit_logs, dependent: :destroy

  # Validations
  validates :user_id, :role_type, presence: true
  validates :role_type, uniqueness: { scope: :user_id }
  validate :user_has_valid_membership, if: :active?
  validate :role_compatibility

  # Methods
  def active?
    active && !suspended && (expires_at.nil? || expires_at > Time.current)
  end

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  def suspend!(reason, by_user)
    update!(
      suspended: true,
      suspended_reason: reason,
      suspended_at: Time.current,
      suspended_by: by_user
    )
  end

  def reactivate!
    update!(
      suspended: false,
      suspended_reason: nil,
      suspended_at: nil,
      suspended_by: nil
    )
  end

  def extend_expiration!(date, by_user)
    update!(
      expires_at: date,
      assigned_by: by_user,
      assigned_at: Time.current
    )
  end

  private

  def user_has_valid_membership
    errors.add(:user, "must have valid membership") unless user&.has_valid_membership?
  end

  def role_compatibility
    # Implementation of role compatibility rules
  end
end
```

### 1.2 Modèle `RoleAuditLog`

#### Attributs
| Attribut         | Type      | Description                                    | Contraintes                 |
|------------------|-----------|------------------------------------------------|----------------------------|
| id               | Integer   | Identifiant unique                             | PK, Auto-increment         |
| user_id          | Integer   | Référence à l'utilisateur concerné             | FK, Not Null              |
| role_id          | Integer   | Référence au rôle concerné                     | FK, Nullable              |
| role_type        | String    | Type de rôle (copie pour historique)           | Nullable                  |
| action           | Enum      | Type d'action effectuée                        | Not Null                  |
| details          | Text      | Détails de l'action                            | Nullable                  |
| performed_by_id  | Integer   | Référence à l'utilisateur ayant effectué l'action | FK, Not Null              |
| created_at       | DateTime  | Date de l'action                               | Not Null                  |

#### Implémentation

```ruby
class RoleAuditLog < ApplicationRecord
  # Enums
  enum action: {
    create: 0,
    update: 1, 
    suspend: 2,
    reactivate: 3,
    delete: 4
  }

  # Associations
  belongs_to :user
  belongs_to :role, optional: true
  belongs_to :performed_by, class_name: 'User'

  # Validations
  validates :user_id, :action, :performed_by_id, presence: true
end
```

## 2. Services

### 2.1 `RoleManager`

Service centralisant la gestion des rôles dans l'application.

```ruby
class RoleManager
  def self.assign_role(user, role_type, assigned_by: nil, expires_at: nil)
    Role.transaction do
      role = user.roles.create!(
        role_type: role_type,
        assigned_by: assigned_by,
        assigned_at: Time.current,
        expires_at: expires_at
      )

      RoleAuditLog.create!(
        user: user,
        role: role,
        role_type: role_type,
        action: :create,
        performed_by: assigned_by || SystemUser.instance,
        details: "Role #{role_type} assigned"
      )

      role
    end
  end

  def self.suspend_roles_on_membership_expiration(user)
    user.active_roles.each do |role|
      role.suspend!("Membership expired", SystemUser.instance)
      RoleAuditLog.create!(
        user: user,
        role: role,
        role_type: role.role_type,
        action: :suspend,
        performed_by: SystemUser.instance,
        details: "Role suspended due to membership expiration"
      )
    end
  end

  def self.reactivate_roles_after_renewal(user)
    user.roles.where(suspended: true).each do |role|
      role.reactivate!
      RoleAuditLog.create!(
        user: user,
        role: role,
        role_type: role.role_type,
        action: :reactivate,
        performed_by: SystemUser.instance,
        details: "Role reactivated after membership renewal"
      )
    end
  end

  def self.check_and_update_roles_based_on_memberships
    User.joins(:memberships).where(memberships: { status: :expired }).find_each do |user|
      suspend_roles_on_membership_expiration(user) unless user.has_valid_membership?
    end
  end
end
```

### 2.2 `PermissionService`

Service gérant les vérifications d'autorisation.

```ruby
class PermissionService
  def self.can_access?(user, action, resource = nil)
    return false unless user.active_roles.any?

    case action
    when :access_trainings
      user.can_access_trainings?
    when :manage_users
      user.admin? || user.super_admin?
    when :assign_volunteer_role
      user.admin? || user.super_admin?
    when :assign_admin_role
      user.super_admin?
    else
      check_standard_permissions(user, action, resource)
    end
  end

  def self.can_modify?(user, resource)
    return false unless user.active_roles.any?
    
    case resource
    when User
      user.admin? || user.super_admin? || user == resource
    when Role
      can_modify_role?(user, resource)
    else
      check_standard_permissions(user, :modify, resource)
    end
  end

  def self.requires_additional_check?(action)
    [:access_trainings, :manage_users, :assign_roles].include?(action)
  end

  private

  def self.can_modify_role?(user, role)
    return true if user.super_admin?
    return false if role.super_admin?
    user.admin? && role.volunteer?
  end

  def self.check_standard_permissions(user, action, resource)
    # Implementation of standard permission checks based on role hierarchy
  end
end
```

## 3. Intégration dans le modèle User

```ruby
class User < ApplicationRecord
  # Associations
  has_many :roles, dependent: :destroy
  has_many :memberships
  
  # Role methods
  def active_roles
    roles.active.where(suspended: false)
  end
  
  def has_role?(role_type)
    active_roles.where(role_type: role_type).exists?
  end
  
  # Quick access methods
  def member?
    has_role?(:member)
  end
  
  def volunteer?
    has_role?(:volunteer)
  end
  
  def admin?
    has_role?(:admin)
  end
  
  def super_admin?
    has_role?(:super_admin)
  end
  
  # Membership methods
  def has_valid_membership?
    memberships.active.exists?
  end
  
  def has_valid_basic_membership?
    memberships.active.basic.exists?
  end
  
  def has_valid_cirque_membership?
    memberships.active.cirque.exists?
  end
  
  # Training access check
  def can_access_trainings?
    has_valid_cirque_membership? && has_valid_contribution?
  end
end
```

## 4. Jobs automatisés

### 4.1 `MembershipStatusCheckJob`

```ruby
class MembershipStatusCheckJob < ApplicationJob
  queue_as :default
  
  def perform
    RoleManager.check_and_update_roles_based_on_memberships
  end
end
```

## 5. Hooks d'événements

### 5.1 Intégration avec le modèle `Membership`

```ruby
class Membership < ApplicationRecord
  # Callbacks
  after_create :update_user_roles, if: -> { active? }
  after_save :handle_status_change, if: -> { saved_change_to_status? }
  
  private
  
  def update_user_roles
    RoleManager.assign_role(user, :member) unless user.has_role?(:member)
  end
  
  def handle_status_change
    if previous_changes["status"].first == "active" && status != "active"
      RoleManager.suspend_roles_on_membership_expiration(user)
    elsif previous_changes["status"].first != "active" && status == "active"
      RoleManager.reactivate_roles_after_renewal(user)
    end
  end
end
```

## 6. Points d'attention pour les développeurs

1. **Séparation des concepts**: Maintenir une distinction claire entre adhésion (accès aux installations) et rôles système (permissions dans l'application)
2. **Suspension vs Suppression**: Les rôles sont suspendus lors de l'expiration d'une adhésion, pas supprimés
3. **Audit**: Toutes les modifications de rôles doivent être journalisées
4. **Vérifications contextuelles**: Certaines actions nécessitent à la fois un rôle et un type d'adhésion spécifique (ex: accès aux entraînements)
5. **Performance**: Optimiser les vérifications fréquentes pour ne pas impacter les performances
6. **Priorité des règles**: En cas de conflit, les règles d'adhésion prévalent sur les permissions des rôles (ex: un admin sans adhésion cirque ne peut pas accéder aux entraînements) 