# Validation - Cotisation

## Identification du Document
- **Domaine**: Cotisation
- **Version**: 1.0.0
- **Référence**: [Règles de Cotisation](./regles.md)
- **Dernière révision**: [DATE]

## Critères d'Acceptation

### AC1: Création d'une cotisation Pass Journée
1. L'utilisateur doit avoir une adhésion Cirque valide
2. Le paiement doit être de 4€ exactement
3. La cotisation doit être activée immédiatement après paiement
4. L'utilisateur doit pouvoir utiliser cette cotisation le jour même uniquement
5. Une seule entrée doit être disponible

### AC2: Création d'un Carnet 10 Séances
1. L'utilisateur doit avoir une adhésion Cirque valide
2. Le paiement doit être de 30€ exactement
3. La cotisation doit être activée immédiatement après paiement
4. 10 entrées doivent être disponibles sans date d'expiration
5. Les entrées doivent pouvoir s'accumuler avec d'autres carnets

### AC3: Création d'un Abonnement Trimestriel
1. L'utilisateur doit avoir une adhésion Cirque valide
2. Le paiement doit être de 65€ exactement
3. La cotisation doit être activée immédiatement après paiement
4. La validité doit être de 3 mois exactement à partir de la date d'achat
5. L'abonnement ne doit pas pouvoir coexister avec un autre abonnement actif

### AC4: Création d'un Abonnement Annuel
1. L'utilisateur doit avoir une adhésion Cirque valide
2. Le paiement doit être de 150€ exactement
3. La cotisation doit être activée immédiatement après paiement
4. La validité doit être de 12 mois exactement à partir de la date d'achat
5. L'abonnement ne doit pas pouvoir coexister avec un autre abonnement actif

### AC5: Utilisation d'une cotisation
1. Lors de l'utilisation, le système doit sélectionner automatiquement la cotisation selon l'ordre de priorité défini
2. Pour un Pass Journée ou un Carnet, le compteur d'entrées doit être décrémenté
3. Un abonnement (trimestriel ou annuel) ne doit pas avoir de compteur
4. L'état doit passer à "Expired" quand toutes les entrées sont utilisées ou la date dépassée

### AC6: Expiration et renouvellement
1. Le système doit marquer les cotisations comme expirées au bon moment
2. Une notification doit être envoyée 1 mois avant l'expiration d'un abonnement
3. Le renouvellement ne doit pas être possible si l'adhésion Cirque est expirée

## Scénarios de Test

### Scénario 1: Achat et utilisation d'un Pass Journée
```gherkin
Feature: Gestion des Pass Journée
  Scenario: Achat et utilisation d'un Pass Journée
    Given un utilisateur avec une adhésion Cirque valide
    When l'utilisateur achète un Pass Journée pour 4€
    Then le statut de la cotisation devrait être "active"
    And le nombre d'entrées disponibles devrait être 1
    When l'utilisateur utilise le Pass Journée pour une séance
    Then le nombre d'entrées disponibles devrait être 0
    And le statut de la cotisation devrait être "expired"
    When l'utilisateur tente d'utiliser à nouveau le Pass Journée
    Then une erreur "Aucune cotisation valide disponible" devrait être affichée
```

### Scénario 2: Achat et utilisation partielle d'un Carnet
```gherkin
Feature: Gestion des Carnets 10 Séances
  Scenario: Utilisation partielle d'un Carnet
    Given un utilisateur avec une adhésion Cirque valide
    When l'utilisateur achète un Carnet 10 Séances pour 30€
    Then le statut de la cotisation devrait être "active"
    And le nombre d'entrées disponibles devrait être 10
    When l'utilisateur utilise 3 entrées du carnet
    Then le nombre d'entrées disponibles devrait être 7
    And le statut de la cotisation devrait toujours être "active"
```

### Scénario 3: Priorité d'utilisation avec plusieurs cotisations
```gherkin
Feature: Priorité d'utilisation des cotisations
  Scenario: Utilisation prioritaire selon les règles
    Given un utilisateur avec une adhésion Cirque valide
    And un Carnet avec 5 entrées restantes
    When l'utilisateur achète un Abonnement Annuel
    And l'utilisateur se présente à une séance
    Then l'Abonnement Annuel devrait être utilisé
    And le Carnet devrait toujours avoir 5 entrées
    When l'Abonnement Annuel expire
    And l'utilisateur se présente à une séance
    Then une entrée du Carnet devrait être utilisée
    And le Carnet devrait avoir 4 entrées restantes
```

### Scénario 4: Tentative d'achat avec adhésion invalide
```gherkin
Feature: Validation des prérequis pour cotisation
  Scenario: Tentative d'achat sans adhésion valide
    Given un utilisateur sans adhésion Cirque valide
    When l'utilisateur tente d'acheter un Abonnement Trimestriel
    Then une erreur "Adhésion Cirque valide requise" devrait être affichée
    And aucune cotisation ne devrait être créée
```

### Scénario 5: Tentative d'achat d'abonnement déjà actif
```gherkin
Feature: Validation de compatibilité des abonnements
  Scenario: Tentative d'achat avec abonnement déjà actif
    Given un utilisateur avec une adhésion Cirque valide
    And un Abonnement Trimestriel actif
    When l'utilisateur tente d'acheter un Abonnement Annuel
    Then une erreur "Un abonnement illimité est déjà actif" devrait être affichée
    And aucun nouvel abonnement ne devrait être créé
```

## Plan de Tests Unitaires

### Pour le modèle `Subscription`
1. Test des validations de base (présence des champs, formats)
2. Test de validation de l'adhésion Cirque
3. Test de validation des incompatibilités entre abonnements
4. Test des méthodes d'état (expired?, active?, etc.)
5. Test de décrémentation des entrées
6. Test de détermination de type (has_limited_sessions?, unlimited_access?)

### Pour les sous-classes (STI)
1. Test des valeurs par défaut pour chaque type
2. Test de l'initialisation correcte selon le type

### Pour le service `SubscriptionService`
1. Test de création de chaque type de cotisation
2. Test des vérifications d'éligibilité
3. Test de la gestion des erreurs
4. Test de l'utilisation des cotisations selon priorité
5. Test du décompte d'entrées lors de l'utilisation
6. Test des notifications lors de l'utilisation

## Tests d'Intégration

### Processus d'achat complet
1. Test du processus complet d'achat-paiement-activation
2. Test de l'intégration avec le système de paiement
3. Test de la génération des reçus
4. Test du paiement en plusieurs fois

### Utilisation de cotisation
1. Test de l'intégration avec le système de présence
2. Test du mécanisme de sélection prioritaire
3. Test des mises à jour d'état après utilisation
4. Test de l'historique de présence

### Notifications et rappels
1. Test des notifications avant expiration
2. Test des alertes de séances restantes
3. Test des propositions de renouvellement

## Matrice de Traçabilité

| Règle Métier | Test Unitaire | Test d'Intégration | Scénario |
|--------------|---------------|-------------------|----------|
| Types de cotisation | SubscriptionTest#test_valid_types | IntegrationTest#test_subscription_creation | Scénarios 1-4 |
| Adhésion Cirque requise | SubscriptionTest#test_validate_circus_membership | IntegrationTest#test_create_with_invalid_membership | Scénario 4 |
| Un seul abonnement actif | SubscriptionTest#test_validate_compatible_subscriptions | IntegrationTest#test_multiple_active_subscriptions | Scénario 5 |
| Priorité d'utilisation | SubscriptionServiceTest#test_determine_subscription | IntegrationTest#test_subscription_priority | Scénario 3 |
| Décompte séances | SubscriptionTest#test_decrement_usage | IntegrationTest#test_attendance_creation | Scénario 1, 2 | 