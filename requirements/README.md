# Le Circographe - Guide de Démarrage

## Technologies Requises
- Ruby 3.2.0+
- Rails 8.0.1
- SQLite3 (dev) / Sqlite3 (prod)
- Node.js 16+ (pour Tailwind)

## Stack Technique Imposée
1. **Backend**
   - Rails 8 authentification native (pas de Devise !)
   - Hotwire (Turbo + Stimulus)
   - ActiveJob avec Sidekiq
   - Action Mailer pour emails

2. **Frontend**
   - Tailwind CSS
   - Flowbite Components
   - Importmaps (pas de Webpacker)
   - Stimulus Controllers

3. **Base de Données**
   - SQLite3 (développement et production)
   - Redis pour cache et jobs

## Architecture Imposée
```
app/
├── models/
│   ├── concerns/
│   │   └── authorizable.rb       # Gestion des rôles
│   ├── user.rb                   # Auth native Rails 8
│   ├── membership.rb             # STI pour basic/circus
│   └── subscription.rb           # STI pour abonnements
├── controllers/
│   ├── concerns/
│   │   └── authenticatable.rb    # Méthodes auth
│   └── application_controller.rb
└── views/
    ├── layouts/
    │   └── application.html.erb  # Layout Flowbite
    └── shared/
        └── _navigation.html.erb  # Nav Flowbite
```

## Ordre d'Implémentation
1. **Phase 1 : Core System**
   - Authentication native Rails 8
   - Système de rôles
   - Modèles de base
   - Composants Flowbite pour l'UI
   - Hotwire pour les interactions dynamiques

2. **Phase 2 : Features**
   - Adhésions et cotisations
   - Présences
   - Paiements

3. **Phase 3 : UI/UX**
   - Interface admin
   - Interface bénévole
   - Interface membre

## Standards à Respecter
1. **Code**
   - [Ruby Style Guide](https://rubystyle.guide)
   - Tests RSpec obligatoires
   - Commits conventionnels

2. **Architecture**
   - MVC strict
   - Service Objects pour logique complexe
   - Concerns pour code partagé
   - Pas de gems non listées

3. **Sécurité**
   - Auth native uniquement
   - CSRF protection
   - Strong Parameters
   - Sanitization des inputs

## Points de Validation
- ✓ Consulter `requirements/1_logique_metier/` avant chaque feature
- ✓ Suivre les user stories de `requirements/3_user_stories/`
- ✓ Respecter l'architecture de `requirements/2_specifications_techniques/`
- ✓ Implémenter selon `requirements/4_implementation/`

## Documentation
- 📁 `./docs/` pour documentation technique
- 📁 `./requirements/` pour règles métier
- 📁 `./specs/` pour les tests

## Gems Autorisées
```ruby
# Gemfile
source "https://rubygems.org"

ruby "3.2.0"
gem "rails", "~> 8.0.1"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 6.0"
gem "redis", "~> 4.0"
gem "sidekiq"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "flowbite-rails"

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end
```

## Démarrage Projet
1. Cloner les dossiers requirements/ et docs/
2. Suivre l'architecture imposée
3. Implémenter dans l'ordre défini
4. Valider chaque étape avec les requirements 