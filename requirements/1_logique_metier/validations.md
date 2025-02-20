# Critères de Validation Technique

## Validation des Données
### Utilisateurs et Authentification
- Email : format valide, unique
- Mot de passe : min 8 caractères, 1 majuscule, 1 chiffre
- Rôles autorisés : guest, member, volunteer, admin uniquement
- Permissions : vérification stricte selon le rôle

### Documents et Fichiers
- Fichiers : taille max 5MB, formats autorisés (PDF, JPG, PNG)
- Justificatifs : vérification de validité
- Photos : format carré recommandé, max 1MB

### Données Financières
- Montants : decimal(10,2)
- Dates : format ISO 8601
- Paiements : CB (SumUp), espèces, chèque uniquement

## Validation des Actions
### Adhésions
- Une seule adhésion active par type (Basic, Cirque)
- Adhésion Basic requise pour Cirque
- Justificatif requis pour tarif réduit (étudiant, RSA, mineurs)
- Pas de chevauchement d'adhésions
- Vérification automatique des renouvellements
- Alerte avant expiration (30j, 15j, 7j)

### Cotisations et Abonnements
- Types autorisés :
  * Séance unique (4€, valable jour même)
  * Carnet de 10 séances (validité illimitée)
  * Trimestriel (3 mois de date à date)
  * Annuel (12 mois de date à date)
- Adhésion Cirque valide requise
- Un seul abonnement actif à la fois
- Validation des dates selon le type

### Listes de Présence
- Types de listes :
  * Entraînement Libre (volunteer + admin)
  * Evènement (volunteer + admin)
  * Reunion (admin uniquement)
- Une seule présence par personne par liste
- Vérification des droits d'accès selon le type
- Contrôle des doublons par liste
- Adhésion/cotisation valide requise

### Paiements
- Méthodes acceptées :
  * CB via SumUp
  * Espèces
  * Chèque
- Montant exact requis
- Reçu obligatoire (format PDF)
- Traçabilité complète
- Protection anti-doublon

## Validation Système
### Sécurité
- Permissions par rôle :
  * guest : lecture seule, données publiques
  * member : accès personnel limité
  * volunteer : gestion présences (hors Reunion)
  * admin : accès complet
- Tokens d'authentification
- Journalisation des accès

### Automatisation
- Vérification quotidienne des adhésions
- Notification des anomalies
- Sauvegarde des données
- Audit des modifications 