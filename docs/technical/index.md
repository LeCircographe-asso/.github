# Documentation Technique - Le Circographe

## Vue d'Ensemble

Le Circographe est une application de gestion d'association de cirque qui permet de :
- Gérer les adhésions et abonnements
- Suivre les présences aux entraînements
- Gérer les paiements
- Administrer les utilisateurs et leurs droits

## Structure de la Documentation

### 1. Architecture
- [Architecture Générale](../BIS_ARCHITECTURE.md)
- [Bonnes Pratiques](architecture/best_practices.md)
- [Conventions de Code](conventions/coding_style.md)

### 2. Base de Données
- [Modèles et Migrations](models/overview.md)
- [Validations et Scopes](models/validations.md)

### 3. Backend
- [Controllers et Routes](controllers/overview.md)
- [API Documentation](api/overview.md)
- [Mailers et Notifications](mailers/overview.md)

### 4. Frontend
- [Vues Admin](views/admin.md)
- [Composants Partagés](views/shared.md)

### 5. Qualité et Tests
- [Tests et Qualité](testing/quality.md)
- [Guide de Contribution](contributing.md)

### 6. Infrastructure
- [Monitoring et Maintenance](monitoring/overview.md)
- [Déploiement](deployment/procedures.md)

## Points Clés de l'Architecture

### Stack Technique
- Ruby 3.2.0
- Rails 8.0.1
- SQLite3
- Redis
- Sidekiq
- Hotwire (Turbo + Stimulus)
- Tailwind CSS + Flowbite

### Gems Principales
#### Interface Utilisateur
- `flowbite-rails` : Composants Tailwind pré-construits
- `tailwindcss-rails` : Framework CSS
- `pagy` : Pagination légère et performante

#### Authentification & Sécurité
- `bcrypt` : Hashage des mots de passe
- `strong_migrations` : Sécurité des migrations

#### Emails & Notifications
- `letter_opener` : Preview des emails (développement)
- `premailer-rails` : Inline CSS dans les emails
- `noticed` : Système de notifications
- `webpush` : Notifications push (PWA)

#### Background Jobs & Cache
- `sidekiq` : Traitement asynchrone
- `redis` : Cache et files d'attente

#### Upload & Validation
- `image_processing` : Traitement des images
- `active_storage_validations` : Validation des fichiers

#### Recherche & Filtres
- `ransack` : Recherche et filtres avancés

### Principes Architecturaux
1. **Modularité**
   - Services pour la logique métier complexe
   - Concerns pour le code partagé
   - Presenters pour la logique de présentation

2. **Performance**
   - Cache multi-niveaux
   - Optimisation des requêtes
   - Background jobs pour les tâches lourdes

3. **Sécurité**
   - Authentification native Rails (has_secure_password)
   - Autorisation avec des politiques personnalisées
   - Validation des entrées
   - Protection CSRF

4. **Maintenabilité**
   - Tests automatisés
   - Documentation à jour
   - Conventions de code strictes
   - Monitoring complet

## Workflow de Développement

### 1. Installation
```bash
git clone git@github.com:organization/circographe.git
cd circographe
bundle install
yarn install
rails db:setup
```

### 2. Développement
```bash
# Lancer le serveur
bin/dev

# Lancer les tests
bundle exec rspec

# Lancer les linters
bundle exec rubocop
yarn lint
```

### 3. Déploiement
```bash
# Staging
git push origin develop

# Production
git push origin main
cap production deploy
```

## Ressources

### Documentation Externe
- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [Hotwire](https://hotwired.dev/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Flowbite](https://flowbite.com/)

### Outils de Développement
- [VSCode](https://code.visualstudio.com/)
- [RuboCop](https://rubocop.org/)
- [ESLint](https://eslint.org/)
- [Prettier](https://prettier.io/)

### Monitoring
- [Sentry](https://sentry.io/)
- [New Relic](https://newrelic.com/)
- [Grafana](https://grafana.com/) 