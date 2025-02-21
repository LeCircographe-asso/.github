# Le Circographe - Guide de Référence

## Points de Validation Obligatoires
1. **Avant toute réponse**
   - ✓ Vérifier les requirements correspondants
   - ✓ Consulter la documentation technique
   - ✓ Valider la cohérence avec l'architecture

2. **Pour chaque feature**
   - ✓ Suivre l'ordre d'implémentation défini
   - ✓ Respecter les standards de code
   - ✓ Assurer la couverture de tests

## Stack Technique Imposée
1. **Core**
   - Ruby 3.2.0+
   - Rails 8.0.1
   - SQLite3 (dev et prod)
   - Authentification native Rails 8 (pas de Devise!)

2. **Frontend**
   - Tailwind CSS
   - Flowbite Components
   - Hotwire (Turbo + Stimulus)
   - Importmaps (pas de Webpacker)

## Structure Projet
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
1. **Core System**
   - Authentication native Rails 8
   - Système de rôles
   - Modèles de base
   - Composants Flowbite pour l'UI
   - Hotwire pour les interactions dynamiques

2. **Features**
   - Adhésions et cotisations
   - Présences
   - Paiements

3. **Interfaces**
   - Admin
   - Bénévole
   - Membre

## Dossiers de Référence
- 📁 `requirements/1_logique_metier/` → Règles métier
- 📁 `requirements/2_specifications_techniques/` → Architecture
- 📁 `requirements/3_user_stories/` → Parcours utilisateur
- 📁 `requirements/4_implementation/` → Code et tests
- 📁 `docs/` → Documentation technique

## Gems Autorisées
```ruby
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

## Standards Obligatoires
1. **Code**
   - Ruby Style Guide
   - Tests RSpec
   - Commits conventionnels

2. **Architecture**
   - MVC strict
   - Service Objects
   - Concerns
   - Pas de gems non listées

3. **Sécurité**
   - Auth native uniquement
   - CSRF protection
   - Strong Parameters
   - Sanitization des inputs 