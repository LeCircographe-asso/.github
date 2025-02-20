# Mapping Global du Projet

## 1. Structure des Documents
```
/requirements/
├── 1_logique_metier/      # Règles métier et validations
├── 2_specifications/       # Spécifications techniques
├── 3_user_stories/        # Stories utilisateurs
└── 4_implementation/      # Code et tests

/docs/
├── business_logic/        # Documentation métier
├── technical/            # Documentation technique
└── verification/         # Documents de vérification
```

## 2. Flux Principaux

### Adhésion
1. User Story → requirements/3_user_stories/user_stories.md#adhésions
   - Création adhésion
   - Renouvellement
   - Tarifs réduits

2. Règles → requirements/1_logique_metier/validations.md#adhésions
   - Validations des données
   - Règles métier
   - Gestion des erreurs

3. Implémentation
   - Modèle → rails/models/membership.rb
   - Service → rails/services/membership_service.rb
   - Tests → rails/spec/models/membership_spec.rb

### Présence
1. User Story → requirements/3_user_stories/user_stories.md#présence
   - Pointage quotidien
   - Gestion des listes
   - Vérifications

2. Règles → requirements/1_logique_metier/validations.md#présence
   - Validations adhésion
   - Règles de pointage
   - Gestion des erreurs

3. Implémentation
   - Service → rails/services/attendance_service.rb
   - Modèle → rails/models/daily_attendance_list.rb
   - Tests → rails/spec/services/attendance_service_spec.rb

### Paiement
1. User Story → requirements/3_user_stories/user_stories.md#paiements
   - Paiement adhésion
   - Gestion des reçus
   - Dons

2. Règles → requirements/1_logique_metier/validations.md#paiements
   - Validation des montants
   - Règles de paiement
   - Gestion des erreurs

3. Implémentation
   - Service → rails/services/payment_service.rb
   - Modèle → rails/models/payment.rb
   - Tests → rails/spec/services/payment_service_spec.rb

## 3. Points de Synchronisation

### Adhésion → Présence
- Vérification adhésion avant pointage
- Mise à jour statut adhérent
- Notification si expiration proche

### Paiement → Adhésion
- Création/Renouvellement automatique
- Application des tarifs réduits
- Génération des reçus

### Présence → Cotisation
- Décompte des séances
- Alerte fin de forfait
- Historique de participation

## 4. Validation Croisée

### Documents à Vérifier
- [ ] User Stories complètes et cohérentes
- [ ] Règles métier documentées et implémentées
- [ ] Tests couvrant tous les cas d'usage
- [ ] Documentation technique à jour

### Points de Contrôle
- [ ] Terminologie cohérente
- [ ] Flux de données validés
- [ ] Gestion des erreurs uniforme
- [ ] Interfaces utilisateur cohérentes 