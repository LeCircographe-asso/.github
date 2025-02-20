# Architecture Technique - Le Circographe

## Vue d'Ensemble
Application de gestion pour l'espace de pratique du Circographe, basée sur :
- Ruby on Rails 8.0.1
- Hotwire (Turbo + Stimulus)
- Tailwind CSS + Flowbite
- SQLite3

## Structure Générale
```
app/
├── models/                  # Modèles de données
│   ├── user.rb             # Gestion des utilisateurs
│   ├── membership.rb       # Gestion des adhésions
│   └── subscription.rb     # Gestion des cotisations
│
├── controllers/            # Logique métier
│   ├── application_controller.rb
│   ├── memberships_controller.rb
│   └── subscriptions_controller.rb
│
└── views/                  # Interface utilisateur
    ├── layouts/
    └── components/
```

## Points Clés Techniques

### 1. Authentification & Autorisation
- Authentification native Rails 8
- Système de rôles personnalisé
- Gestion fine des permissions

### 2. Interface Utilisateur
- Components Flowbite
- Interactions temps réel avec Hotwire
- Design responsive

### 3. Base de Données
- SQLite3 en développement
- Migrations versionnées
- Indexation optimisée

### 4. Performance
- Cache Redis
- Background jobs avec Sidekiq
- Assets précompilés 