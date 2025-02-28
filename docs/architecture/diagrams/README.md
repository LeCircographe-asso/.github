# Diagrammes d'Architecture - Le Circographe

Ce dossier contient tous les diagrammes d'architecture du projet Le Circographe, organisés par domaine métier et type de diagramme.

## Organisation des Diagrammes

Les diagrammes sont organisés selon les catégories suivantes :

### Diagrammes d'États
- [États des Adhésions](docs/architecture/diagrams/membership_states.md) - Cycle de vie d'une adhésion
- [États des Cotisations](docs/architecture/diagrams/subscription_states.md) - Cycle de vie d'une cotisation

### Diagrammes de Flux
- [Flux de Paiement](docs/architecture/diagrams/payment_flow.md) - Processus de paiement complet
- [Flux de Pointage](docs/architecture/diagrams/check_in_flow.md) - Processus d'enregistrement des présences
- [Flux de Notification](docs/architecture/diagrams/notification_flow.md) - Système de notifications

### Diagrammes de Structure
- [Permissions des Rôles](docs/architecture/diagrams/roles_permissions.md) - Matrice des permissions par rôle
- [Structure de la Base de Données](database_schema.md) - Schéma relationnel

## Conventions de Nommage

Tous les diagrammes suivent les conventions de nommage suivantes :
- Fichiers en anglais, snake_case
- Contenu en français
- Format Markdown avec intégration de diagrammes Mermaid

## Mise à Jour des Diagrammes

Les diagrammes doivent être mis à jour à chaque modification significative de l'architecture ou des processus métier. Chaque diagramme inclut une date de dernière mise à jour et une version.

---

*Dernière mise à jour : Février 2024* 