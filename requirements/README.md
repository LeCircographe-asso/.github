# Le Circographe - Guide de Référence

## Règles pour l'Assistant
1. **Avant Chaque Réponse**
   - Toujours consulter les requirements avant de suggérer une solution
   - Vérifier la cohérence avec la documentation existante
   - Ne jamais proposer de gems non listées
   - Ne jamais suggérer Devise ou autres alternatives

2. **Ordre de Consultation**
   - 1️⃣ requirements/1_logique_metier/
   - 2️⃣ requirements/2_specifications_techniques/
   - 3️⃣ requirements/3_user_stories/
   - 4️⃣ requirements/4_implementation/

3. **Validation Systématique**
   - Vérifier la conformité avec l'architecture imposée
   - Respecter l'ordre d'implémentation
   - Assurer la cohérence des nommages
   - Garantir la couverture de tests

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

## Standards à Suivre
1. **Code**
   - Ruby Style Guide
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