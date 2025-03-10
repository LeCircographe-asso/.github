# Roadmap du Circographe - MVP

## Vue d'ensemble

Ce document présente la roadmap détaillée pour le développement du MVP (Minimum Viable Product) du Circographe. Le développement est prévu sur une période de trois semaines, avec deux équipes travaillant en parallèle :

- **Équipe Frontend** : 3 développeurs, du 10 au 28 mars (3 semaines)
- **Équipe Backend** : 3 développeurs, du 17 au 28 mars (2 semaines)

## Organisation du projet

Le projet sera géré via GitHub Projects avec la structure suivante :

- **Milestones** : Représentent les semaines de développement
- **Issues** : Tâches spécifiques à accomplir
- **Labels** : Catégorisation des tâches (frontend, backend, priorité, etc.)
- **Assignees** : Attribution des tâches aux membres de l'équipe

## Planification des sprints

### Sprint 1 (10-15 mars) - Frontend uniquement

#### Équipe Frontend

| Tâche | Description | Priorité | Assigné à |
|-------|-------------|----------|-----------|
| **Mise en place du projet** | Initialisation du projet Rails avec Hotwire et Tailwind CSS | Haute | Développeur 1 |
| **Authentification UI** | Interface de connexion, inscription et gestion de profil (utilisant l'authentification native de Rails 8) | Haute | Développeur 2 |
| **Layout principal** | Structure de base de l'application (header, footer, navigation) | Haute | Développeur 3 |
| **Composants UI de base** | Boutons, formulaires, cartes, modales, notifications | Haute | Développeur 1 |
| **Dashboard membre** | Vue d'ensemble pour les membres | Moyenne | Développeur 2 |
| **Dashboard admin** | Vue d'ensemble pour les administrateurs | Moyenne | Développeur 3 |

### Sprint 2 (17-22 mars) - Frontend + Backend

#### Équipe Frontend

| Tâche | Description | Priorité | Assigné à |
|-------|-------------|----------|-----------|
| **Gestion des adhésions UI** | Interface pour voir et gérer les adhésions | Haute | Développeur 1 |
| **Gestion des cotisations UI** | Interface pour voir et gérer les cotisations | Haute | Développeur 2 |
| **Gestion des paiements UI** | Interface pour effectuer et suivre les paiements | Haute | Développeur 3 |
| **Gestion des présences UI** | Interface pour enregistrer et consulter les présences | Moyenne | Développeur 1 |
| **Notifications UI** | Interface pour les notifications système | Moyenne | Développeur 2 |
| **Gestion des rôles UI** | Interface pour gérer les rôles utilisateurs | Moyenne | Développeur 3 |

#### Équipe Backend

| Tâche | Description | Priorité | Assigné à |
|-------|-------------|----------|-----------|
| **Mise en place de l'API** | Structure de base de l'API RESTful | Haute | Développeur 4 |
| **Authentification** | Système d'authentification native Rails 8 et autorisation personnalisée | Haute | Développeur 5 |
| **Modèles de base** | Implémentation des modèles principaux et relations | Haute | Développeur 6 |
| **Gestion des adhésions** | Logique métier pour les adhésions | Haute | Développeur 4 |
| **Gestion des cotisations** | Logique métier pour les cotisations | Haute | Développeur 5 |
| **Gestion des paiements** | Logique métier pour les paiements | Haute | Développeur 6 |

### Sprint 3 (23-28 mars) - Frontend + Backend

#### Équipe Frontend

| Tâche | Description | Priorité | Assigné à |
|-------|-------------|----------|-----------|
| **Rapports et statistiques UI** | Interface pour visualiser les rapports | Moyenne | Développeur 1 |
| **Calendrier des activités** | Vue calendrier pour les sessions | Moyenne | Développeur 2 |
| **Optimisation UI/UX** | Améliorations de l'expérience utilisateur | Moyenne | Développeur 3 |
| **Tests E2E** | Tests end-to-end des fonctionnalités principales | Moyenne | Développeur 1 |
| **Documentation utilisateur** | Guide d'utilisation de l'interface | Basse | Développeur 2 |
| **Correction de bugs** | Résolution des problèmes identifiés | Haute | Tous |

#### Équipe Backend

| Tâche | Description | Priorité | Assigné à |
|-------|-------------|----------|-----------|
| **Gestion des présences** | Logique métier pour les présences | Moyenne | Développeur 4 |
| **Système de notifications** | Implémentation des notifications | Moyenne | Développeur 5 |
| **Gestion des rôles** | Logique métier pour les rôles et permissions | Moyenne | Développeur 6 |
| **Rapports et statistiques** | Génération de rapports et statistiques | Basse | Développeur 4 |
| **Tests unitaires et d'intégration** | Tests automatisés | Haute | Développeur 5 |
| **Optimisation des performances** | Amélioration des requêtes et du cache | Moyenne | Développeur 6 |

## Détail des fonctionnalités par domaine

### 1. Domaine Adhésion

#### Frontend
- Formulaire d'inscription/adhésion
- Visualisation des adhésions actives
- Interface de renouvellement
- Affichage des statuts d'adhésion
- Gestion des tarifs réduits

#### Backend
- Modèle `Membership` avec validations
- Service `MembershipService`
- Gestion des dates de validité
- Logique de tarification
- Vérification des adhésions

### 2. Domaine Cotisation

#### Frontend
- Achat de cotisations (abonnements/carnets)
- Visualisation des cotisations actives
- Historique des cotisations
- Interface de gestion des types de cotisation

#### Backend
- Modèle `Contribution` avec validations
- Service `ContributionService`
- Gestion des différents types (abonnement/carnet)
- Logique de consommation des entrées
- Vérification des cotisations

### 3. Domaine Paiement

#### Frontend
- Interface de paiement
- Historique des transactions
- Génération de reçus
- Gestion des remboursements

#### Backend
- Modèle `Payment` avec validations
- Service `PaymentService`
- Gestion des différents moyens de paiement
- Génération de références uniques
- Logique de remboursement

### 4. Domaine Présence

#### Frontend
- Pointage des présences
- Calendrier des sessions
- Statistiques de fréquentation
- Gestion des horaires

#### Backend
- Modèle `Attendance` avec validations
- Service `AttendanceService`
- Vérification des droits d'accès
- Calcul des statistiques
- Gestion des sessions

### 5. Domaine Rôles

#### Frontend
- Interface d'attribution des rôles
- Visualisation des permissions
- Gestion des utilisateurs

#### Backend
- Modèle `Role` avec validations
- Service `RoleManager`
- Logique de permissions personnalisée
- Audit des modifications
- Intégration avec l'authentification native de Rails 8

### 6. Domaine Notification

#### Frontend
- Centre de notifications
- Préférences de notification
- Affichage des alertes

#### Backend
- Modèle `Notification` avec validations
- Service `NotificationService`
- Gestion des canaux (email, in-app)
- Logique de délivrance
- Templates de notification

## Dépendances et ordre d'implémentation

1. **Fondation** : Authentification native Rails 8, Modèles de base, Layout
2. **Core** : Adhésion, Rôles
3. **Fonctionnalités principales** : Cotisation, Paiement
4. **Fonctionnalités secondaires** : Présence, Notification
5. **Améliorations** : Rapports, Optimisations

## Critères de succès du MVP

- Système d'authentification native Rails 8 fonctionnel
- Gestion complète du cycle d'adhésion
- Gestion des cotisations et paiements
- Système de pointage des présences
- Gestion des rôles et permissions
- Interface utilisateur responsive et intuitive
- Tests couvrant les fonctionnalités critiques

## Risques et mitigations

| Risque | Impact | Probabilité | Mitigation |
|--------|--------|-------------|------------|
| Retard dans le développement backend | Élevé | Moyenne | Commencer par des mocks côté frontend |
| Complexité des règles métier | Moyen | Élevée | Se concentrer sur les cas d'usage principaux |
| Problèmes d'intégration front/back | Moyen | Moyenne | Définir clairement les contrats d'API |
| Bugs dans les fonctionnalités critiques | Élevé | Moyenne | Prioriser les tests sur ces fonctionnalités |
| Complexité de l'autorisation personnalisée | Moyen | Moyenne | Commencer par un système simple et l'étendre progressivement |

## Après le MVP

Les fonctionnalités suivantes seront développées après la livraison du MVP :

- Système avancé de rapports et statistiques
- Gestion des exceptions d'horaires
- API pour applications mobiles
- Intégration avec des services tiers
- Optimisations de performance avancées

---

*Dernière mise à jour: Mars 2024* 