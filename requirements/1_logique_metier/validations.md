# Critères de Validation Technique

## Validation des Données
- Email : format valide, unique
- Mot de passe : min 8 caractères, 1 majuscule, 1 chiffre
- Dates : format ISO 8601
- Montants : decimal(10,2)

## Validation des Actions
### Adhésions
- Une seule adhésion active par type
- Adhésion Basic requise pour Circus
- Justificatif requis pour tarif réduit
- Dates de validité cohérentes

### Cotisations
- Adhésion Circus valide requise
- Montant exact requis
- Un seul abonnement actif à la fois

### Présences
- Adhésion/cotisation valide requise
- Une seule présence par jour
- Enregistrement par bénévole uniquement

### Paiements
- Montant exact requis
- Méthode de paiement valide
- Reçu obligatoire
- Traçabilité complète 