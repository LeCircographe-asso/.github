# Guide Technique pour Développeurs - Le Circographe

## Vue d'ensemble technique

Le Circographe est une application Ruby on Rails 8.0.1 conçue pour la gestion d'associations de cirque. Ce guide fournit les informations techniques essentielles pour les développeurs travaillant sur le projet.

## Environnement de développement

### Prérequis

- Ruby 3.2.0+
- Rails 8.0.1
- SQLite3
- Node.js 16+
- Yarn 1.22+
- Git

### Installation

```bash
# Cloner le dépôt
git clone https://github.com/organisation/circographe.git
cd circographe

# Installer les dépendances
bundle install
yarn install

# Configurer la base de données
rails db:create
rails db:migrate
rails db:seed

# Lancer le serveur
rails server
```

## Architecture de l'application

### Structure MVC+

Le Circographe suit une architecture MVC étendue avec des services, des présentateurs et des jobs:

```
app/
├── models/               # Modèles ActiveRecord
├── views/                # Vues (ERB, Slim)
├── controllers/          # Contrôleurs
├── services/             # Services métier
├── presenters/           # Présentateurs pour les vues
├── jobs/                 # Jobs ActiveJob
├── mailers/              # Mailers pour les emails
├── helpers/              # Helpers pour les vues
├── assets/               # Assets (JS, CSS, images)
│   ├── javascripts/
│   ├── stylesheets/
│   └── images/
├── javascript/           # JavaScript moderne (Stimulus)
└── components/           # Composants View Component
```

### Domaines métier

L'application est organisée autour de six domaines métier principaux:

1. **Adhésion** - Gestion des adhérents et de leur statut
2. **Cotisation** - Gestion des cotisations et des tarifs
3. **Paiement** - Gestion des paiements et des factures
4. **Présence** - Gestion des présences aux activités
5. **Rôles** - Gestion des rôles et des permissions
6. **Notification** - Gestion des notifications et des communications

Chaque domaine est implémenté avec ses propres modèles, contrôleurs, services et vues.

## Stack technique

### Backend

| Composant | Technologie | Documentation |
|-----------|------------|---------------|
| Framework | Ruby on Rails 8.0.1 | [Documentation Rails](https://guides.rubyonrails.org/) |
| Base de données | SQLite3 | [Documentation SQLite](https://www.sqlite.org/docs.html) |
| Authentification | Devise | [Documentation Devise](https://github.com/heartcombo/devise) |
| Autorisation | Pundit | [Documentation Pundit](https://github.com/varvet/pundit) |
| Jobs asynchrones | ActiveJob | [Documentation ActiveJob](https://guides.rubyonrails.org/active_job_basics.html) |
| Planification | Rufus-Scheduler | [Documentation Rufus](https://github.com/jmettraux/rufus-scheduler) |
| Tests | RSpec, FactoryBot | [Documentation RSpec](https://rspec.info/) |

### Frontend

| Composant | Technologie | Documentation |
|-----------|------------|---------------|
| CSS | Tailwind CSS | [Documentation Tailwind](https://tailwindcss.com/docs) |
| Composants | Flowbite | [Documentation Flowbite](https://flowbite.com/docs/components/) |
| JavaScript | Hotwire (Turbo, Stimulus) | [Documentation Hotwire](https://hotwired.dev/) |
| Formulaires | Simple Form | [Documentation Simple Form](https://github.com/heartcombo/simple_form) |
| Pagination | Pagy | [Documentation Pagy](https://github.com/ddnexus/pagy) |

## Modèles de données

### Diagramme de classes

![Diagramme de classes](../assets/diagrams/class_diagram.png)

### Relations principales

```ruby
# User (Utilisateur)
class User < ApplicationRecord
  has_many :memberships
  has_many :subscriptions, through: :memberships
  has_many :attendances
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :notifications
end

# Membership (Adhésion)
class Membership < ApplicationRecord
  belongs_to :user
  has_many :subscriptions
  has_many :payments, as: :payable
end

# Subscription (Cotisation)
class Subscription < ApplicationRecord
  belongs_to :membership
  belongs_to :activity_type, optional: true
  has_many :payments, as: :payable
end

# Payment (Paiement)
class Payment < ApplicationRecord
  belongs_to :payable, polymorphic: true
  belongs_to :user
end

# Attendance (Présence)
class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :activity
end

# Activity (Activité)
class Activity < ApplicationRecord
  belongs_to :activity_type
  has_many :attendances
end

# Role (Rôle)
class Role < ApplicationRecord
  has_many :user_roles
  has_many :users, through: :user_roles
  has_many :role_permissions
  has_many :permissions, through: :role_permissions
end

# Notification
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true
end
```

## API RESTful

L'application expose une API RESTful pour chaque domaine métier:

| Domaine | Endpoint de base | Documentation |
|---------|-----------------|---------------|
| Adhésion | `/api/v1/memberships` | [API Adhésion](api/memberships.md) |
| Cotisation | `/api/v1/subscriptions` | [API Cotisation](api/subscriptions.md) |
| Paiement | `/api/v1/payments` | [API Paiement](api/payments.md) |
| Présence | `/api/v1/attendances` | [API Présence](api/attendances.md) |
| Rôles | `/api/v1/roles` | [API Rôles](api/roles.md) |
| Notification | `/api/v1/notifications` | [API Notification](api/notifications.md) |

## Workflows de développement

### Création d'une nouvelle fonctionnalité

1. Créer une branche à partir de `develop`:
   ```bash
   git checkout develop
   git pull
   git checkout -b feature/nom-de-la-fonctionnalite
   ```

2. Implémenter la fonctionnalité avec TDD:
   ```bash
   # Écrire les tests d'abord
   rspec spec/models/nouveau_modele_spec.rb
   
   # Implémenter la fonctionnalité
   # ...
   
   # Vérifier que les tests passent
   rspec
   ```

3. Soumettre une pull request vers `develop`

### Déploiement

Le déploiement suit un workflow GitOps:

1. Les PR validées sont fusionnées dans `develop`
2. Les tests automatisés sont exécutés sur `develop`
3. Après validation, `develop` est fusionné dans `staging` pour les tests d'intégration
4. Après validation en staging, `staging` est fusionné dans `main` pour le déploiement en production

## Bonnes pratiques

### Style de code

Le projet suit les conventions de style de Ruby et Rails:

- [Ruby Style Guide](https://rubystyle.guide/)
- [Rails Style Guide](https://rails.rubystyle.guide/)

Un fichier `.rubocop.yml` est inclus dans le projet pour assurer la cohérence du style.

### Tests

- Tous les modèles, services et contrôleurs doivent être testés
- Utiliser FactoryBot pour créer des objets de test
- Viser une couverture de code d'au moins 80%

### Sécurité

- Utiliser `strong_parameters` dans tous les contrôleurs
- Valider toutes les entrées utilisateur
- Éviter les requêtes N+1 avec `includes` et `eager_load`

## Ressources supplémentaires

- [Guide de contribution](../CONTRIBUTING.md)
- [Guide de déploiement](deployment.md)
- [Guide de dépannage](troubleshooting.md)
- [FAQ Développeurs](faq.md)

---

*Dernière mise à jour: Mars 2023* 