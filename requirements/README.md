# Le Circographe - Guide de Référence

## Règles pour l'Assistant
1. **Avant Chaque Réponse**
   - Toujours consulter les requirements avant de suggérer une solution
   - Vérifier la cohérence avec la documentation existante
   - Ne jamais proposer de gems non listées
   - Ne jamais suggérer Devise ou autres alternatives

2. **Ordre de Consultation**
   - 1️⃣ requirements/1_métier/
   - 2️⃣ requirements/2_specifications_techniques/
   - 3️⃣ requirements/3_user_stories/
   - 4️⃣ requirements/4_implementation/

> **Note Importante**: Le dossier `1_logique_metier` est deprecated. Toute la logique métier a été migrée vers `1_métier`.

3. **Validation Systématique**
   - Vérifier la conformité avec l'architecture imposée
   - Respecter l'ordre d'implémentation
   - Assurer la cohérence des nommages
   - Garantir la couverture de tests

## Organisation de la Documentation

La documentation du projet a été réorganisée pour plus de clarté et de cohérence :

1. **Documentation Active**
   - Les domaines métier sont organisés dans `requirements/1_métier/`
   - La documentation utilisateur se trouve dans `docs/utilisateur/guides/`
   - La documentation technique détaillée est dans `docs/architecture/technical/`

2. **Documentation Obsolète**
   - Des dossiers `deprecated/` ont été créés dans chaque section
   - Ces dossiers contiennent des documents historiques qui ne sont plus à jour
   - Ils sont conservés pour référence mais ne doivent pas être utilisés pour le développement actuel

## Domaines Métier

Tous les domaines métier sont désormais organisés dans `requirements/1_métier/` avec la structure suivante:

| Domaine | Description |
|---------|-------------|
| [Adhésion](./1_métier/adhesion/index.md) | Règles et processus liés aux adhésions Basic et Cirque |
| [Cotisation](./1_métier/cotisation/index.md) | Règles pour les formules de cotisations d'accès aux entraînements |
| [Paiement](./1_métier/paiement/index.md) | Règles pour les transactions financières et reçus |
| [Présence](./1_métier/presence/index.md) | Gestion des présences et statistiques |
| [Rôles](./1_métier/roles/index.md) | Gestion des rôles système et utilisateurs |
| [Notification](./1_métier/notification/index.md) | Communication avec les membres |

## Stack Technique Imposée
1. **Core**
   - Ruby 3.2.0+
   - Rails 8.0.1
   - SQLite3 (dev et prod)
   - Authentification native Rails 8 (pas de Devise!)
   - Active Storage pour fichiers
   - Action Text pour contenus riches

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
gem "image_processing" # Pour Active Storage et Pour prod storage

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

## Navigation de la Documentation

- [📁 Requirements](.) - Ce dossier
  - [📁 Domaines Métier](./1_métier/) - Règles métier par domaine
  - [📁 Spécifications Techniques](./2_specifications_techniques/) - Détails d'implémentation
  - [📁 User Stories](./3_user_stories/) - Scénarios utilisateurs
  - [📁 Implémentation](./4_implementation/) - Guide d'implémentation
  - [📁 Processus](./processes/) - Documentation des processus métier (déplacée)
- [📁 Documentation](../docs/)
  - [📁 Architecture](../docs/architecture/) - Schémas et diagrammes
  - [📁 Guides Métier](../docs/business/) - Documentation pour les parties prenantes
  - [📁 Guides Utilisateur](../docs/utilisateur/) - Documentation pour utilisateurs finaux
  - [📄 Glossaire](../docs/glossaire.md) - Termes et définitions

---

*Dernière mise à jour : Février 2023* 