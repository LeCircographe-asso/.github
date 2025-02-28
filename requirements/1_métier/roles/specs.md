# Spécifications Techniques - Rôles

## Identification du document

| Domaine           | Rôles                               |
|-------------------|-------------------------------------|
| Version           | 1.1                                 |
| Référence         | SPEC-ROL-2023-01                    |
| Dernière révision | [DATE]                              |

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

#### Énumérations
```ruby
enum role_type: {
  membre: 0,
  benevole: 1,
  admin: 2,
  super_admin: 3
}
```

#### Validations principales
- Présence de `user_id` et `role_type`
- Unicité de `role_type` par utilisateur
- Compatibilité des rôles (voir règles dans la section 3)
- Vérification qu'un utilisateur a une adhésion valide pour avoir des rôles actifs

#### Méthodes principales
- `active?` : Vérifie si le rôle est actif (ni suspendu, ni expiré)
- `expired?` : Vérifie si le rôle est expiré
- `suspend!(reason, by_user)` : Suspend le rôle
- `reactivate!` : Réactive un rôle suspendu
- `extend_expiration!(date, by_user)` : Prolonge la durée de validité

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

#### Énumérations
```ruby
enum action: {
  create: 0,
  update: 1, 
  suspend: 2,
  reactivate: 3,
  delete: 4
}
```

## 2. Services

### 2.1 `RoleManager`

Service centralisant la gestion des rôles dans l'application avec les méthodes principales :

- `assign_role(user, role_type, assigned_by: nil, expires_at: nil)` : Attribue un rôle à un utilisateur
- `suspend_roles_on_membership_expiration(user)` : Suspend les rôles suite à l'expiration d'une adhésion
- `reactivate_roles_after_renewal(user)` : Réactive les rôles après renouvellement d'adhésion
- `check_and_update_roles_based_on_memberships` : Vérifie quotidiennement le statut des adhésions et met à jour les rôles

### 2.2 `PermissionService`

Service gérant les vérifications d'autorisation avec les méthodes principales :

- `can_access?(user, action, resource = nil)` : Vérifie si un utilisateur a accès à une action
- `can_modify?(user, resource)` : Vérifie si un utilisateur peut modifier une ressource
- `requires_additional_check?(action)` : Détermine si une action nécessite des vérifications supplémentaires (ex: adhésion Cirque pour accès aux entraînements)

## 3. Règles d'implémentation

La mise en œuvre technique du système de rôles doit respecter la séparation claire entre adhésion et rôles système définie dans les [Règles Métier - Rôles](requirements/1_métier/adhesion/regles.md).

### 3.1 Implémentation de l'attribution des rôles

Le service `RoleManager` implémente l'attribution des rôles selon les règles suivantes:

1. Le rôle Membre est attribué automatiquement à tout utilisateur avec une adhésion valide
2. Les rôles Bénévole, Admin et Super-Admin sont attribués manuellement par des utilisateurs ayant les droits appropriés
3. Tout rôle attribué est enregistré dans le journal d'audit avec les détails de l'attribution

### 3.2 Implémentation de la suspension des rôles

Lorsqu'une adhésion expire:
1. Le système détecte l'expiration via un job programmé quotidiennement
2. Tous les rôles de l'utilisateur sont suspendus (mais pas supprimés)
3. Le motif de suspension "Adhésion expirée" est enregistré
4. Le système envoie une notification à l'utilisateur

### 3.3 Implémentation de la réactivation des rôles

Lorsqu'une adhésion est renouvelée:
1. Le système détecte le renouvellement
2. Tous les rôles suspendus sont automatiquement réactivés
3. Le motif de réactivation "Adhésion renouvelée" est enregistré
4. Le système envoie une confirmation à l'utilisateur

### 3.4 Implémentation des vérifications d'autorisation

Le service `PermissionService` implémente les vérifications d'autorisation en suivant ces étapes:
1. Vérification des rôles actifs (non suspendus) de l'utilisateur
2. Application de la matrice de permissions définie dans les règles métier
3. Vérification additionnelle du type d'adhésion pour certaines fonctionnalités spécifiques (ex: adhésion Cirque pour accès aux entraînements)

## 4. Intégration dans le modèle User

```ruby
class User < ApplicationRecord
  has_many :roles, dependent: :destroy
  has_many :memberships
  
  # Méthodes d'instance pour les rôles
  def active_roles
    roles.active.where(suspended: false)
  end
  
  def has_role?(role_type)
    active_roles.of_type(role_type).exists?
  end
  
  # Méthodes d'accès rapide
  def membre?
    has_role?(:membre)
  end
  
  def benevole?
    has_role?(:benevole)
  end
  
  def admin?
    has_role?(:admin)
  end
  
  def super_admin?
    has_role?(:super_admin)
  end
  
  # Méthodes liées aux adhésions
  def has_valid_membership?
    memberships.active.exists?
  end
  
  def has_valid_basic_membership?
    memberships.active.basic.exists?
  end
  
  def has_valid_cirque_membership?
    memberships.active.cirque.exists?
  end
  
  # Méthode pour vérifier l'accès aux entraînements
  def can_access_trainings?
    has_valid_cirque_membership? && has_valid_contribution?
  end
end
```

## 5. Jobs automatisés

### 5.1 `MembershipStatusCheckJob`
Job quotidien vérifiant les adhésions et mettant à jour les rôles en conséquence.

```ruby
class MembershipStatusCheckJob < ApplicationJob
  queue_as :default
  
  def perform
    RoleManager.check_and_update_roles_based_on_memberships
  end
end
```

## 6. Hooks d'événements

Intégration avec le modèle `Membership` pour la gestion automatique des rôles :

```ruby
class Membership < ApplicationRecord
  after_create :update_user_roles, if: -> { active? }
  after_save :handle_status_change, if: -> { saved_change_to_status? }
  
  private
  
  def update_user_roles
    RoleManager.assign_role(user, :membre) unless user.has_role?(:membre)
  end
  
  def handle_status_change
    if previous_changes["status"].first == "active" && status != "active"
      # L'adhésion n'est plus active
      RoleManager.suspend_roles_on_membership_expiration(user)
    elsif previous_changes["status"].first != "active" && status == "active"
      # L'adhésion devient active
      RoleManager.reactivate_roles_after_renewal(user)
    end
  end
end
```

## 7. Points d'attention pour les développeurs

1. **Séparation des concepts**: Maintenir une distinction claire entre adhésion (accès aux installations) et rôles système (permissions dans l'application)
2. **Suspension vs Suppression**: Les rôles sont suspendus lors de l'expiration d'une adhésion, pas supprimés
3. **Audit**: Toutes les modifications de rôles doivent être journalisées
4. **Vérifications contextuelles**: Certaines actions nécessitent à la fois un rôle et un type d'adhésion spécifique (ex: accès aux entraînements)
5. **Performance**: Optimiser les vérifications fréquentes pour ne pas impacter les performances
6. **Priorité des règles**: En cas de conflit, les règles d'adhésion prévalent sur les permissions des rôles (ex: un admin sans adhésion cirque ne peut pas accéder aux entraînements)

---

*Document créé le [DATE] - Version 1.1* 