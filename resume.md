# Résumé du Projet Circographe

## 1. Logique Métier
- Gestion des adhésions et cotisations
  - Adhésion Basic (obligatoire pour accéder à l'adhésion Cirque)
  - Adhésion Cirque (permet l'accès aux entraînements)
  - Types de cotisations :
    * Séance unique (4€, valable jour même)
    * Carnet de 10 séances (validité illimitée)
    * Trimestriel (3 mois de date à date)
    * Annuel (12 mois de date à date)

## 2. Spécifications Techniques
### Architecture MVC Rails 8
- Models principaux :
  - User (adhérents et rôles)
  - Attendance (présences)
  - Payment (système de facturation)
  - TrainingSession (séances d'entraînement)

### Base de Données
- Tables principales :
  - users (adhérents et rôles)
  - memberships (adhésions)
  - subscriptions (cotisations)
  - attendances (présences)
  - training_sessions (séances)
  - payments (paiements)
  - daily_stats (statistiques journalières)
  - monthly_stats (statistiques mensuelles)

## 3. Flux de Données Principaux
### Adhésion → Présence
- Vérification adhésion valide avant pointage
- Vérification cotisation valide avant pointage
- Paiement de l'adhésion sans pointage
- Paiement de l'adhésion ou cotisation avant pointage et sans pointage
- Contrôle des doublons par liste

### Paiement → Adhésion
- Gestion manuelle au bureau
- Génération des reçus
- Tarifs réduits sur justificatif (verification visuel par les admin)

### Présence → Cotisation
- Décompte des séances (carnets)
- Vérification validité (abonnements)
- Historique de participation
- Alertes fin de forfait

## 4. Règles de Validation
### Adhésions
- Une seule adhésion active par type
- Adhésion Basic requise pour Cirque
- Justificatif pour tarif réduit
- Pas de chevauchement

### Présences
- Types de listes :
  * Entraînement Libre (volunteer + admin)
  * Événement (volunteer + admin)
  * Réunion (admin uniquement)
- Une seule présence par personne/liste
- Adhésion/cotisation valide requise

### Paiements
- Méthodes acceptées :
  * CB via SumUp
  * Espèces
  * Chèque
- Reçu optionnel (PDF)
- Protection anti-doublon

## 5. Points Critiques
- Validation des droits d'accès selon rôle
- Gestion des présences quotidiennes
- Suivi des paiements physiques
- Statistiques de fréquentation

## 6. Spécificités du Circographe
### Rôles Utilisateurs
- guest : lecture seule, données publiques
- member : accès personnel limité
- volunteer : gestion présences (hors Réunion)
- admin : accès complet

### Système de Paiement
- Types : adhésion, cotisation
- Méthodes : CB (SumUp), espèces, chèque
- Gestion manuelle au bureau ou sur l'app mobile (PWA)
- Génération automatique des reçus

### Statistiques et Rapports
- Suivi quotidien et mensuel
- Taux de fréquentation
- Analyse des revenus
- Suivi des adhésions 