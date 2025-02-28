# Le Circographe - Documentation Project

## Vue d'ensemble

Le Circographe est une application de gestion pour les écoles et associations de cirque, construite en Ruby on Rails 8.0.1. Ce projet vise à optimiser la gestion des adhésions, cotisations, et présences pour les petites et moyennes structures circassiennes.

## Structure du Projet

La documentation est organisée en trois sections principales:

### 📁 [Requirements](requirements/README.md)

Documentation technique et métier des exigences de l'application:

- **1_métier** - Règles et spécifications par domaine fonctionnel
- **2_specifications_techniques** - Détails d'implémentation technique
- **3_user_stories** - Scénarios utilisateur détaillés
- **4_implementation** - Guide d'implémentation pour les développeurs

### 📁 [Docs](docs/glossaire.md)

Documentation générale de l'application:

- **architecture** - Diagrammes, schémas et documentation d'architecture
- **business** - Documentation pour les parties prenantes métier
- **utilisateur** - Guides utilisateur pour l'application finale
- **validation** - Critères et plans de test

### ⚙️ Autres Ressources

- **profile** - Profil technique du projet
- **pour_bien_faire.md** - Guide des bonnes pratiques pour ce projet
- **RAILS_COMMANDS.md** - Référence des commandes Rails utiles

## Domaines Métier

L'application est organisée autour de six domaines fonctionnels principaux:

1. **Adhésion** - Gestion des adhésions (Basic et Cirque)
2. **Cotisation** - Gestion des formules d'accès aux entraînements
3. **Paiement** - Gestion des transactions financières
4. **Présence** - Gestion des présences aux entraînements
5. **Rôles** - Gestion des rôles et permissions
6. **Notification** - Système de communication avec les adhérents

## Stack Technique

- **Backend**: Ruby 3.2.0, Rails 8.0.1
- **Base de données**: SQLite3
- **Frontend**: Tailwind CSS, Flowbite, Hotwire (Turbo + Stimulus)
- **Authentification**: Native Rails (pas de Devise)

## Guide de Contribution

Consultez le [Guide de Contribution](CONTRIBUTING.md) pour comprendre comment participer au projet et le [Guide d'Audit](AUDIT.md) pour les standards de qualité.

## Ressources Principales

- [📝 Glossaire](docs/glossaire.md) - Terminologie du projet
- [🔍 Requirements](requirements/README.md) - Spécifications détaillées
- [📚 Guide de Bonnes Pratiques](pour_bien_faire.md) - Standards de code
- [❓ FAQ Administrateurs](QUESTIONS_ADMIN.md) - Réponses aux questions fréquentes 