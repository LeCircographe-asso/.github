# Le Circographe - Spécifications et Exigences

## Vue d'ensemble

Ce dossier contient l'ensemble des spécifications et exigences pour l'application Le Circographe, un système de gestion complet pour association de cirque. Ces documents définissent les règles métier, les spécifications techniques et les critères de validation qui guident le développement de l'application.

## Structure de la documentation

La documentation des exigences est organisée de manière hiérarchique pour faciliter la navigation et la compréhension:

### 1. [Domaines Métier](./1_métier/)

Cette section contient les règles métier organisées par domaine fonctionnel:

| Domaine | Description |
|---------|-------------|
| [Adhésion](./1_métier/adhesion/index.md) | Gestion des adhésions Basic (1€/an) et Cirque (10€/an ou 7€ tarif réduit) |
| [Cotisation](./1_métier/cotisation/index.md) | Formules d'accès aux entraînements (séances uniques, cartes, abonnements) |
| [Paiement](./1_métier/paiement/index.md) | Gestion des transactions financières, reçus et dons |
| [Présence](./1_métier/presence/index.md) | Pointage, contrôle d'accès et statistiques de fréquentation |
| [Rôles](./1_métier/roles/index.md) | Gestion des permissions système et des fonctions associatives |
| [Notification](./1_métier/notification/index.md) | Communications automatisées avec les membres |

Chaque domaine est documenté selon une structure standard:
- **regles.md** - Définition des règles fondamentales du domaine
- **specs.md** - Spécifications techniques d'implémentation
- **validation.md** - Critères d'acceptation et scénarios de test

### 2. [Spécifications Techniques](./2_specifications_techniques/)

Documentation détaillée sur l'implémentation technique:
- Architecture système
- Modèles de données
- API et interfaces
- Sécurité et performance

### 3. [User Stories](./3_user_stories/)

Scénarios utilisateur organisés par domaine et par profil:
- Parcours membres
- Parcours administrateurs
- Parcours bénévoles

### 4. [Implémentation](./4_implementation/)

Guides d'implémentation pour les développeurs:
- Bonnes pratiques
- Patterns recommandés
- Exemples de code

## Architecture Technique

Le Circographe est développé avec les technologies suivantes:

### Core
- Ruby 3.2.0+
- Rails 8.0.1
- SQLite3 (développement et production)
- Authentification native Rails 8
- Active Storage pour la gestion des fichiers
- Action Text pour les contenus riches

### Frontend
- Tailwind CSS pour les styles
- Flowbite Components pour l'interface utilisateur
- Hotwire (Turbo + Stimulus) pour les interactions dynamiques
- Importmaps pour la gestion des assets JavaScript

### Structure du projet

```
app/
├── models/               # Modèles de données
│   ├── concerns/         # Comportements partagés
│   ├── user.rb           # Authentification native
│   ├── membership.rb     # Adhésions (STI)
│   └── subscription.rb   # Cotisations (STI)
├── controllers/          # Contrôleurs
│   ├── concerns/         # Comportements partagés
│   └── application_controller.rb
└── views/                # Vues
    ├── layouts/          # Templates principaux
    └── shared/           # Composants partagés
```

## Standards de développement

Pour garantir la qualité et la maintenabilité du code:

1. **Code**
   - Respect du Ruby Style Guide
   - Tests RSpec obligatoires
   - Commits conventionnels

2. **Architecture**
   - MVC strict
   - Service Objects pour la logique métier complexe
   - Concerns pour le code partagé

3. **Sécurité**
   - Authentification native Rails
   - Protection CSRF
   - Strong Parameters
   - Sanitization des entrées utilisateur

## Navigation

- [📁 Domaines Métier](./1_métier/) - Règles métier par domaine
- [📁 Spécifications Techniques](./2_specifications_techniques/) - Détails d'implémentation
- [📁 User Stories](./3_user_stories/) - Scénarios utilisateurs
- [📁 Implémentation](./4_implementation/) - Guide d'implémentation
- [📁 Documentation Utilisateur](../docs/utilisateur/) - Guides pour les utilisateurs finaux
- [📁 Documentation Métier](../docs/business/) - Documentation pour les parties prenantes
- [📁 Documentation Technique](../docs/architecture/) - Schémas et diagrammes

---

<div align="center">
  <p>
    <a href="../profile/README.md">⬅️ Retour à l'accueil</a> | 
    <a href="#le-circographe---spécifications-et-exigences">⬆️ Haut de page</a>
  </p>
</div>

*Dernière mise à jour : Mars 2023* 