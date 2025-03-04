# Matrice des Permissions par Rôle

Ce document définit la matrice complète des permissions par rôle dans l'application Le Circographe.

## Vue d'ensemble

Le système d'autorisation du Circographe est basé sur un modèle de rôles et permissions. Chaque utilisateur se voit attribuer un rôle qui détermine ses permissions dans l'application.

## Rôles Principaux

| Rôle | Description |
|------|-------------|
| **Guest** | Utilisateur non authentifié avec accès limité aux informations publiques |
| **Member** | Membre de l'association avec accès à son profil et ses données personnelles |
| **Volunteer** | Bénévole avec permissions étendues pour la gestion quotidienne |
| **Admin** | Administrateur avec accès complet à toutes les fonctionnalités |

## Format des Permissions

Les permissions suivent le format `action:resource` où :
- `action` est l'opération (read, write, create, update, delete)
- `resource` est la ressource concernée (users, memberships, etc.)

## Matrice Complète des Permissions

| Permission | Guest | Member | Volunteer | Admin |
|------------|:-----:|:------:|:---------:|:-----:|
| **Utilisateurs** |
| `read:users:self` | ❌ | ✅ | ✅ | ✅ |
| `read:users:all` | ❌ | ❌ | ✅ | ✅ |
| `create:users` | ✅ | ❌ | ❌ | ✅ |
| `update:users:self` | ❌ | ✅ | ✅ | ✅ |
| `update:users:all` | ❌ | ❌ | ❌ | ✅ |
| `delete:users:self` | ❌ | ✅ | ✅ | ✅ |
| `delete:users:all` | ❌ | ❌ | ❌ | ✅ |
| **Adhésions** |
| `read:memberships:self` | ❌ | ✅ | ✅ | ✅ |
| `read:memberships:all` | ❌ | ❌ | ✅ | ✅ |
| `create:memberships:self` | ✅ | ✅ | ✅ | ✅ |
| `create:memberships:all` | ❌ | ❌ | ✅ | ✅ |
| `update:memberships:self` | ❌ | ❌ | ❌ | ✅ |
| `update:memberships:all` | ❌ | ❌ | ❌ | ✅ |
| `delete:memberships:self` | ❌ | ❌ | ❌ | ✅ |
| `delete:memberships:all` | ❌ | ❌ | ❌ | ✅ |
| **Cotisations** |
| `read:subscriptions:self` | ❌ | ✅ | ✅ | ✅ |
| `read:subscriptions:all` | ❌ | ❌ | ✅ | ✅ |
| `create:subscriptions:self` | ❌ | ✅ | ✅ | ✅ |
| `create:subscriptions:all` | ❌ | ❌ | ✅ | ✅ |
| `update:subscriptions:self` | ❌ | ❌ | ❌ | ✅ |
| `update:subscriptions:all` | ❌ | ❌ | ❌ | ✅ |
| `delete:subscriptions:self` | ❌ | ❌ | ❌ | ✅ |
| `delete:subscriptions:all` | ❌ | ❌ | ❌ | ✅ |
| **Paiements** |
| `read:payments:self` | ❌ | ✅ | ✅ | ✅ |
| `read:payments:all` | ❌ | ❌ | ✅ | ✅ |
| `create:payments:self` | ❌ | ✅ | ✅ | ✅ |
| `create:payments:all` | ❌ | ❌ | ✅ | ✅ |
| `update:payments:self` | ❌ | ❌ | ❌ | ✅ |
| `update:payments:all` | ❌ | ❌ | ❌ | ✅ |
| `delete:payments:self` | ❌ | ❌ | ❌ | ✅ |
| `delete:payments:all` | ❌ | ❌ | ❌ | ✅ |
| **Présences** |
| `read:attendances:self` | ❌ | ✅ | ✅ | ✅ |
| `read:attendances:all` | ❌ | ❌ | ✅ | ✅ |
| `create:attendances:self` | ❌ | ✅ | ✅ | ✅ |
| `create:attendances:all` | ❌ | ❌ | ✅ | ✅ |
| `update:attendances:self` | ❌ | ❌ | ❌ | ✅ |
| `update:attendances:all` | ❌ | ❌ | ✅ | ✅ |
| `delete:attendances:self` | ❌ | ❌ | ❌ | ✅ |
| `delete:attendances:all` | ❌ | ❌ | ❌ | ✅ |
| **Notifications** |
| `read:notifications:self` | ❌ | ✅ | ✅ | ✅ |
| `read:notifications:all` | ❌ | ❌ | ❌ | ✅ |
| `create:notifications:self` | ❌ | ❌ | ❌ | ❌ |
| `create:notifications:all` | ❌ | ❌ | ✅ | ✅ |
| `update:notifications:self` | ❌ | ✅ | ✅ | ✅ |
| `update:notifications:all` | ❌ | ❌ | ❌ | ✅ |
| `delete:notifications:self` | ❌ | ✅ | ✅ | ✅ |
| `delete:notifications:all` | ❌ | ❌ | ❌ | ✅ |
| **Statistiques** |
| `read:stats:basic` | ❌ | ✅ | ✅ | ✅ |
| `read:stats:detailed` | ❌ | ❌ | ✅ | ✅ |
| `read:stats:financial` | ❌ | ❌ | ❌ | ✅ |
| `export:stats` | ❌ | ❌ | ✅ | ✅ |
| **Configuration** |
| `read:settings` | ❌ | ❌ | ✅ | ✅ |
| `update:settings` | ❌ | ❌ | ❌ | ✅ |

## Permissions Spéciales par Domaine

### Adhésion

| Permission | Description | Guest | Member | Volunteer | Admin |
|------------|-------------|:-----:|:------:|:---------:|:-----:|
| `renew:memberships:self` | Renouveler sa propre adhésion | ❌ | ✅ | ✅ | ✅ |
| `renew:memberships:all` | Renouveler l'adhésion d'un autre membre | ❌ | ❌ | ✅ | ✅ |
| `print:membership_card:self` | Imprimer sa propre carte de membre | ❌ | ✅ | ✅ | ✅ |
| `print:membership_card:all` | Imprimer la carte d'un autre membre | ❌ | ❌ | ✅ | ✅ |

### Cotisation

| Permission | Description | Guest | Member | Volunteer | Admin |
|------------|-------------|:-----:|:------:|:---------:|:-----:|
| `apply_discount:subscriptions:self` | Appliquer une réduction à sa propre cotisation | ❌ | ❌ | ❌ | ❌ |
| `apply_discount:subscriptions:all` | Appliquer une réduction à la cotisation d'un membre | ❌ | ❌ | ✅ | ✅ |
| `change_plan:subscriptions:self` | Changer de formule pour sa propre cotisation | ❌ | ✅ | ✅ | ✅ |
| `change_plan:subscriptions:all` | Changer la formule de cotisation d'un membre | ❌ | ❌ | ❌ | ✅ |

### Présence

| Permission | Description | Guest | Member | Volunteer | Admin |
|------------|-------------|:-----:|:------:|:---------:|:-----:|
| `check_in:self` | S'enregistrer à une session | ❌ | ✅ | ✅ | ✅ |
| `check_in:others` | Enregistrer d'autres membres | ❌ | ❌ | ✅ | ✅ |
| `manage:daily_lists` | Gérer les listes quotidiennes | ❌ | ❌ | ✅ | ✅ |
| `close:daily_lists` | Clôturer les listes quotidiennes | ❌ | ❌ | ✅ | ✅ |

## Implémentation Technique

La vérification des permissions est implémentée à plusieurs niveaux :

1. **Middleware d'authentification** : Vérifie la validité du token JWT
2. **Middleware d'autorisation** : Vérifie les permissions requises
3. **Contrôleurs** : Vérifications spécifiques au contexte
4. **Vues** : Affichage conditionnel des éléments d'interface

Exemple de vérification dans un contrôleur :

```ruby
class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_action!
  
  def index
    if current_user.can?('read:memberships:all')
      @memberships = Membership.all
    else
      @memberships = current_user.memberships
    end
  end
  
  private
  
  def authorize_action!
    case action_name
    when 'index'
      authorize! 'read:memberships:self'
    when 'show'
      authorize_membership_access!(@membership)
    when 'create'
      authorize! 'create:memberships:self'
    when 'update'
      authorize_membership_access!(@membership, :update)
    when 'destroy'
      authorize! 'delete:memberships:all'
    end
  end
  
  def authorize_membership_access!(membership, action = :read)
    permission = "#{action}:memberships:"
    permission += (membership.user_id == current_user.id) ? 'self' : 'all'
    
    authorize! permission
  end
end
```

## Évolution des Permissions

Les permissions peuvent évoluer en fonction des besoins de l'application. Toute modification doit suivre le processus suivant :

1. Proposition de modification
2. Évaluation de l'impact sur la sécurité
3. Mise à jour de cette matrice
4. Implémentation technique
5. Tests de validation
6. Déploiement

---

*Version: 1.0 - Dernière mise à jour: Février 2024*
