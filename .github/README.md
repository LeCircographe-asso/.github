# Configuration GitHub - Projet Circographe

Ce dossier contient la configuration GitHub pour le projet Circographe. Il définit la structure du projet, les templates d'issues, et les workflows GitHub Actions.

## Structure du projet

Le projet est organisé selon la méthodologie Agile avec des sprints de développement d'une semaine. La roadmap complète est disponible dans le fichier [ROADMAP.md](../ROADMAP.md) à la racine du projet.

## Milestones

Les milestones correspondent aux sprints de développement :

- **Sprint 1 (10-15 mars)** : Mise en place du projet et fondations frontend
- **Sprint 2 (17-22 mars)** : Développement des fonctionnalités principales (frontend + backend)
- **Sprint 3 (23-28 mars)** : Finalisation du MVP (frontend + backend)

## Labels

Les labels sont organisés en plusieurs catégories :

### Types de tâches
- `frontend` : Tâches liées au frontend
- `backend` : Tâches liées au backend
- `full-stack` : Tâches impliquant frontend et backend
- `documentation` : Tâches de documentation
- `tests` : Tâches de tests

### Priorités
- `priorité: haute` : Tâches de haute priorité
- `priorité: moyenne` : Tâches de priorité moyenne
- `priorité: basse` : Tâches de priorité basse

### Domaines
- `domaine: adhésion` : Tâches liées au domaine Adhésion
- `domaine: cotisation` : Tâches liées au domaine Cotisation
- `domaine: paiement` : Tâches liées au domaine Paiement
- `domaine: présence` : Tâches liées au domaine Présence
- `domaine: rôles` : Tâches liées au domaine Rôles
- `domaine: notification` : Tâches liées au domaine Notification

### Statuts
- `statut: à faire` : Tâche à faire
- `statut: en cours` : Tâche en cours
- `statut: en revue` : Tâche en attente de revue
- `statut: bloquée` : Tâche bloquée
- `statut: terminée` : Tâche terminée

## Templates d'issues

Deux templates d'issues sont disponibles :

1. **Feature** : Pour les nouvelles fonctionnalités
2. **Bug** : Pour signaler des bugs ou des problèmes

## Utilisation du projet GitHub

### Création d'une issue

1. Allez dans l'onglet "Issues" du dépôt
2. Cliquez sur "New issue"
3. Sélectionnez le template approprié
4. Remplissez les informations demandées
5. Assignez l'issue à un développeur
6. Ajoutez les labels appropriés
7. Associez l'issue à une milestone

### Suivi du projet

1. Allez dans l'onglet "Projects" du dépôt
2. Sélectionnez le projet "Circographe MVP"
3. Visualisez l'état d'avancement des tâches dans les différentes colonnes
4. Utilisez les filtres pour afficher les tâches par domaine, priorité, etc.

### Workflow de développement

1. Créez une branche à partir de l'issue : `feature/[numéro-issue]-[nom-court]`
2. Développez la fonctionnalité
3. Créez une pull request vers la branche `develop`
4. Associez la pull request à l'issue
5. Demandez une revue de code
6. Une fois approuvée, mergez la pull request

## Automatisations

Le projet utilise plusieurs automatisations :

- Les issues sont automatiquement déplacées dans les colonnes appropriées en fonction de leurs labels
- Les pull requests sont automatiquement liées aux issues qu'elles résolvent
- Les tests sont automatiquement exécutés sur les pull requests

## Ressources supplémentaires

- [Documentation GitHub Projects](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [Documentation GitHub Actions](https://docs.github.com/en/actions)
- [Roadmap du projet](../ROADMAP.md) 