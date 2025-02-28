# User Stories - Le Circographe

## Vue d'ensemble

Ce dossier contient toutes les user stories de l'application, réorganisées par domaine métier pour aligner parfaitement les besoins utilisateurs avec l'architecture fonctionnelle de l'application.

## Structure

```
3_user_stories/
├── README.md           # Vue d'ensemble et organisation
├── adhesion.md         # Stories liées aux adhésions (Basic et Cirque)
├── cotisation.md       # Stories liées aux formules de cotisation
├── paiement.md         # Stories liées aux paiements et reçus
├── presence.md         # Stories liées au pointage et statistiques
├── roles.md            # Stories liées à la gestion des rôles et permissions
├── notification.md     # Stories liées aux communications automatisées
└── public.md           # Stories pour utilisateurs non connectés
```

## Format Standard

Chaque user story suit le format :
```
En tant que [ROLE]
Je veux [ACTION]
Afin de [OBJECTIF]

Critères d'acceptation :
1. [CRITERE_1]
2. [CRITERE_2]
...
```

## Organisation par Domaine Métier

### 1. [Adhésion](./adhesion.md)
- Création et gestion des adhésions
- Renouvellement d'adhésion
- Upgrade d'adhésion (Basic vers Cirque)
- Vérification du statut d'adhésion

### 2. [Cotisation](./cotisation.md)
- Achat et gestion des formules de cotisation
- Consultation des séances restantes
- Renouvellement des formules
- Options tarifaires (normal/réduit)

### 3. [Paiement](./paiement.md)
- Transactions financières
- Génération et consultation des reçus
- Gestion des remboursements
- Historique des paiements

### 4. [Présence](./presence.md)
- Pointage aux entraînements
- Consultation des listes de présence
- Statistiques de fréquentation
- Contrôle d'accès

### 5. [Rôles](./roles.md)
- Attribution des rôles système
- Gestion des permissions
- Rôles associatifs (bénévole, CA, etc.)
- Audit des actions par rôle

### 6. [Notification](./notification.md)
- Rappels d'échéance
- Confirmations de transaction
- Alertes système
- Préférences de communication

### 7. [Public](./public.md)
- Création de compte
- Consultation des informations publiques
- Contact et demandes

## Priorités

### P0 - Critique
- Inscription et authentification
- Gestion des adhésions
- Pointage présence
- Paiements de base

### P1 - Important
- Gestion des cotisations
- Attribution des rôles
- Statistiques basiques
- Notifications essentielles

### P2 - Utile
- Rapports avancés
- Export de données
- Personnalisation
- Fonctionnalités secondaires

## Validation

Chaque domaine possède ses propres critères d'acceptation détaillés dans le fichier correspondant, alignés avec les critères définis dans les fichiers `validation.md` de chaque domaine métier.

## Mapping avec les anciens fichiers

| Nouveau Document | Anciens Documents |
|------------------|-------------------|
| [adhesion.md](./adhesion.md) | adherent.md (partiellement), user_stories.md (sections adhésion) |
| [cotisation.md](./cotisation.md) | adherent.md (sections cotisation), user_stories.md (sections cotisation) |
| [paiement.md](./paiement.md) | adherent.md (sections paiement), benevole.md (validation paiements) |
| [presence.md](./presence.md) | adherent.md (sections présence), benevole.md (gestion présence) |
| [roles.md](./roles.md) | admin.md, super_admin.md, benevole.md (sections rôles) |
| [notification.md](./notification.md) | Extraits de tous les anciens fichiers (sections notifications) |
| [public.md](./public.md) | public.md (inchangé) |

## Maintenance

### 1. Mise à Jour
- Revue régulière des stories par domaine
- Ajout de nouveaux besoins dans le domaine approprié
- Archivage des stories obsolètes

### 2. Documentation
- Maintenir la cohérence avec les fichiers de règles métier
- Documenter les changements
- Tracer les décisions

### 3. Tests
- Aligner les scénarios de test avec les critères dans validation.md
- Vérifier la couverture fonctionnelle
- Documenter les résultats 