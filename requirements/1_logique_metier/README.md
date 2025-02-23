# Logique Métier - Le Circographe

## Vue d'ensemble

Ce dossier contient toute la logique métier de l'application, organisée par domaine fonctionnel.

## Structure

```
1_logique_metier/
├── adhesions/     # Gestion des adhésions
├── cotisations/   # Gestion des cotisations
├── paiements/     # Gestion des paiements
├── presence/      # Gestion des présences
├── roles/         # Gestion des rôles
├── validations.md # Règles de validation globales
└── errors.md      # Gestion des erreurs
```

## Domaines Fonctionnels

### 1. Adhésions
- Types d'adhésion
- Cycle de vie
- Règles de renouvellement
- Validations spécifiques

### 2. Cotisations
- Types de cotisations
- Périodicité
- Calcul des montants
- Règles de prorata

### 3. Paiements
- Modes de paiement
- Processus de validation
- Gestion des remboursements
- Reçus et factures

### 4. Présence
- Pointage
- Créneaux horaires
- Règles de fréquentation
- Statistiques

### 5. Rôles
- Hiérarchie des rôles
- Permissions
- Règles d'attribution
- Cycle de vie des rôles

## Règles de Validation

Voir [validations.md](./validations.md) pour les règles détaillées.

## Gestion des Erreurs

Voir [errors.md](./errors.md) pour la gestion des cas d'erreur.

## Interdépendances

### Adhésions → Paiements
- Validation du paiement requise pour activation
- Historique des paiements lié à l'adhésion

### Cotisations → Présence
- Vérification des cotisations pour accès
- Impact sur les statistiques de présence

### Rôles → Toutes Fonctionnalités
- Contrôle d'accès sur toutes les actions
- Validation des permissions

## Points d'Attention

1. **Cohérence**
   - Toute modification doit respecter les règles existantes
   - Vérifier les impacts sur les autres domaines

2. **Validation**
   - Tests obligatoires pour chaque règle
   - Documentation des cas limites

3. **Performance**
   - Optimisation des règles complexes
   - Mise en cache des validations fréquentes

## Maintenance

1. **Mise à Jour**
   - Documenter les changements de règles
   - Versionner les modifications majeures

2. **Tests**
   - Couvrir tous les cas d'usage
   - Tester les interactions entre domaines

3. **Documentation**
   - Maintenir les diagrammes à jour
   - Documenter les décisions techniques 