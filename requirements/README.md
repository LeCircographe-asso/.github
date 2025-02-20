# Le Circographe - Documentation Technique

## Structure du Projet
```
app/
├── models/
│   ├── concerns/
│   │   └── authorizable.rb       # Gestion des rôles
│   ├── user.rb                   # Authentification native
│   ├── membership.rb             # STI pour basic/circus
│   └── subscription.rb           # STI pour les abonnements
│
├── controllers/
│   ├── concerns/
│   │   └── authenticatable.rb    # Méthodes d'auth
│   └── application_controller.rb # Configuration de base
│
└── views/
    ├── layouts/
    │   └── application.html.erb  # Layout Flowbite
    └── shared/
        └── _navigation.html.erb  # Nav Flowbite
```

## Points Clés
1. Utilisation de l'authentification native Rails 8
2. Système d'autorisation basé sur les rôles
3. Composants Flowbite pour l'UI
4. Hotwire pour les interactions dynamiques

## Vue d'Ensemble
Application de gestion pour l'espace de pratique du Circographe, permettant :
- Gestion des adhésions et cotisations
- Suivi des présences
- Administration des accès
- Reporting et statistiques

## Structure de la Documentation

### 1. Logique Métier
- Règles de gestion
- Processus métier
- Contraintes fonctionnelles

### 2. Spécifications Techniques
- Architecture système
- Modèles de données
- Interfaces utilisateur

### 3. User Stories
- Parcours utilisateur
- Cas d'utilisation
- Scénarios métier

### 4. Guide d'Implémentation
- Configuration Rails
- Structure du code
- Déploiement

## Glossaire
[Voir le glossaire complet](./glossaire.md)

## Points d'Attention
- Flexibilité des rôles (cumul possible)
- Pas de limite de capacité
- Traçabilité complète des paiements
- Support hors-ligne possible 