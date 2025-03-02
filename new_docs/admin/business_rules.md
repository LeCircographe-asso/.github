# Règles Métier Globales - Le Circographe

Ce document définit les règles métier fondamentales qui régissent l'application Le Circographe. Ces règles doivent être respectées par toutes les implémentations techniques et servent de référence pour les développeurs.

## Principes fondamentaux

1. **Intégrité des données** : Toutes les données doivent être validées avant d'être enregistrées dans la base de données.
2. **Traçabilité** : Toutes les actions importantes doivent être journalisées avec l'identité de l'utilisateur, la date et l'heure.
3. **Cohérence** : Les règles métier doivent être appliquées de manière cohérente dans toute l'application.
4. **Sécurité** : L'accès aux fonctionnalités doit être strictement contrôlé selon les rôles des utilisateurs.

## Règles métier par domaine

### Adhésion

1. **Création d'adhésion**
   - Une adhésion nécessite un utilisateur valide avec des informations complètes
   - Une adhésion doit avoir une date de début et une date de fin
   - La date de fin doit être postérieure à la date de début
   - Une adhésion est initialement en statut "en attente"

2. **Activation d'adhésion**
   - Une adhésion ne peut être activée qu'après réception d'un paiement valide
   - L'activation change le statut de l'adhésion à "active"
   - Une notification doit être envoyée à l'adhérent lors de l'activation

3. **Renouvellement d'adhésion**
   - Le renouvellement prolonge la période d'adhésion
   - La nouvelle date de fin est calculée à partir de l'ancienne date de fin
   - Un paiement est requis pour finaliser le renouvellement

4. **Expiration d'adhésion**
   - Une adhésion expire automatiquement à sa date de fin
   - Une notification doit être envoyée avant l'expiration (30 jours, 15 jours, 7 jours)
   - Une adhésion expirée passe au statut "expirée"

### Cotisation

1. **Création de cotisation**
   - Une cotisation nécessite une adhésion active
   - Une cotisation doit avoir un type et un montant
   - Une cotisation doit avoir une période de validité

2. **Tarification**
   - Les tarifs sont définis par type d'adhésion et type d'activité
   - Des réductions peuvent s'appliquer selon des critères spécifiques
   - Les tarifs doivent être validés par un administrateur

### Paiement

1. **Enregistrement de paiement**
   - Tout paiement doit être lié à une adhésion, une donation ou une cotisation
   - Un paiement doit avoir un montant, une date et un mode de paiement
   - Un paiement peut être en statut "en attente", "validé" ou "refusé"

2. **Validation de paiement**
   - La validation d'un paiement déclenche l'activation de l'adhésion ou de la cotisation associée
   - Une facture peut être générée automatiquement
   - Une notification doit être envoyée à l'adhérent

### Présence

1. **Enregistrement de présence**
   - Une présence ne peut être enregistrée que pour un adhérent
   - Une présence doit être liée à une activité spécifique (visiteur, entraînement, réunion)
   - Une présence doit avoir une date et une durée

2. **Limitation de présence**
   - Le nombre de présences peut être limité selon le type de cotisation
   - Des règles spécifiques peuvent s'appliquer pour certaines activités

### Rôles

1. **Attribution de rôles**
   - Chaque utilisateur doit avoir au moins un rôle
   - Les rôles déterminent les permissions dans l'application
   - Seuls les administrateurs peuvent attribuer des rôles

2. **Hiérarchie des rôles**
   - Les rôles suivent une hiérarchie définie
   - Les permissions sont héritées des rôles supérieurs

### Notification

1. **Envoi de notifications**
   - Les notifications sont envoyées selon des événements spécifiques
   - Les utilisateurs peuvent configurer leurs préférences de notification
   - Certaines notifications sont obligatoires et ne peuvent être désactivées

## Règles de validation globales

1. **Validation des données utilisateur**
   - Les emails doivent être uniques et valides
   - Les mots de passe doivent respecter les critères de sécurité
   - Les informations personnelles doivent être complètes

2. **Validation des dates**
   - Les dates doivent être cohérentes (début avant fin)
   - Les périodes ne doivent pas se chevaucher de manière incohérente

3. **Validation des montants**
   - Les montants doivent être positifs
   - Les montants doivent correspondre aux tarifs définis

## Processus métier transversaux

1. **Processus d'adhésion complet**
   ```
   Création utilisateur → Demande d'adhésion sur place → Paiement → Activation adhésion → Souscription cotisation
   ```

2. **Processus de renouvellement**
   ```
   Notification d'expiration → Demande de renouvellement → Paiement → Prolongation adhésion
   ```

3. **Processus de gestion des présences**
   ```
   Création activité → Inscription membres → Enregistrement présences → Génération rapports
   ```

---

*Dernière mise à jour: Mars 2023*