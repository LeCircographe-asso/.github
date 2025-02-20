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
  * Session-based authentication
  * Remember me functionality
  * Password reset
  * Email verification
- Système de rôles basé sur les tables roles et user_roles
- Gestion des permissions par rôle

### 2. Interface Utilisateur
- Components Flowbite pour l'UI
- Interactions temps réel avec Hotwire (Turbo + Stimulus)
- Design responsive avec Tailwind CSS
- Formulaires dynamiques

### 3. Base de Données
- SQLite3 en développement
- Migrations versionnées
- Indexation optimisée pour les recherches fréquentes
- STI pour memberships et subscriptions

### 4. Performance
- Cache Redis pour les sessions
- Background jobs avec Sidekiq pour :
  * Envoi d'emails
  * Génération de rapports
  * Calcul de statistiques
- Assets précompilés
- Optimisation des requêtes N+1 