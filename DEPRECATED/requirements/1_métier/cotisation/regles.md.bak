# Règles Métier - Cotisations

## Identification du document

| Domaine           | Cotisation                           |
|-------------------|--------------------------------------|
| Version           | 1.0                                  |
| Référence         | REGLE-COT-2023-01                    |
| Dernière révision | [DATE]                               |

## 1. Définition et objectif

Les cotisations sont les contributions financières permettant aux membres disposant d'une adhésion Cirque valide d'accéder aux entraînements et activités du Circographe. Elles constituent la principale source de revenus de l'association pour financer les activités quotidiennes.

## 2. Types de cotisations

Le Circographe propose quatre types de cotisations, chacun adapté à différentes fréquences de pratique:

### 2.1 Pass Journée

| Caractéristique      | Valeur                               |
|----------------------|--------------------------------------|
| Référence            | PASS-J                               |
| Prix                 | 4€                                   |
| Validité             | Jour d'achat uniquement              |
| Nombre d'entrées     | 1 entrée                             |
| Public cible         | Pratiquants occasionnels             |

**Règles spécifiques**:
- Ne peut être utilisé que le jour de l'achat
- Un membre peut acheter plusieurs Pass Journée pour une utilisation future
- Non cumulable avec un abonnement actif (trimestriel ou annuel)

### 2.2 Carnet 10 Séances

| Caractéristique      | Valeur                               |
|----------------------|--------------------------------------|
| Référence            | CARNET-10                            |
| Prix                 | 30€                                  |
| Validité             | Illimitée                            |
| Nombre d'entrées     | 10 entrées                           |
| Public cible         | Pratiquants réguliers                |

**Règles spécifiques**:
- Pas de date d'expiration
- Utilisable tant que l'adhésion Cirque est valide
- Une entrée est décomptée à chaque utilisation
- Cumulable avec d'autres carnets

### 2.3 Abonnement Trimestriel

| Caractéristique      | Valeur                               |
|----------------------|--------------------------------------|
| Référence            | ABO-TRIM                             |
| Prix                 | 65€                                  |
| Validité             | 3 mois à partir de la date d'achat   |
| Nombre d'entrées     | Illimité                             |
| Public cible         | Pratiquants assidus                  |

**Règles spécifiques**:
- Entrées illimitées pendant les 3 mois de validité
- Non cumulable avec un autre abonnement (trimestriel ou annuel)
- Possibilité de paiement en 2 ou 3 fois

### 2.4 Abonnement Annuel

| Caractéristique      | Valeur                               |
|----------------------|--------------------------------------|
| Référence            | ABO-ANN                              |
| Prix                 | 150€                                 |
| Validité             | 12 mois à partir de la date d'achat  |
| Nombre d'entrées     | Illimité                             |
| Public cible         | Pratiquants intensifs                |

**Règles spécifiques**:
- Entrées illimitées pendant les 12 mois de validité
- Non cumulable avec un autre abonnement (trimestriel ou annuel)
- Possibilité de paiement en 2 ou 3 fois

## 3. Prérequis et conditions d'achat

### 3.1 Adhésion Cirque obligatoire

L'achat de toute cotisation nécessite une adhésion Cirque valide (10€/an ou 7€ tarif réduit). L'adhésion Basic (1€) ne permet pas d'acheter une cotisation.

### 3.2 Compatibilité des cotisations

| Type de cotisation    | Compatible avec                      |
|-----------------------|--------------------------------------|
| Pass Journée          | Carnet 10 Séances                    |
| Carnet 10 Séances     | Pass Journée, Autres carnets         |
| Abonnement Trimestriel| Carnet 10 Séances (suspendu)         |
| Abonnement Annuel     | Carnet 10 Séances (suspendu)         |

Un membre ne peut pas avoir deux abonnements actifs (trimestriel ou annuel) qui se chevauchent. En cas d'achat d'un abonnement alors que le membre possède un carnet, le carnet est "suspendu" (conservé mais non utilisable) pendant la durée de l'abonnement.

## 4. Cycle de vie d'une cotisation

### 4.1 États possibles

| État                  | Description                          |
|-----------------------|--------------------------------------|
| En attente (pending)  | Créée mais en attente de paiement    |
| Active                | Valide et utilisable                 |
| Expirée               | Plus valide (date ou entrées épuisées)|
| Annulée               | Annulée administrativement           |

### 4.2 Transitions d'état

- **Création** → **En attente**: À la création de la cotisation
- **En attente** → **Active**: Après validation du paiement
- **Active** → **Expirée**: 
  - Automatiquement à la date de fin pour les abonnements
  - Quand le nombre d'entrées atteint 0 pour les carnets et pass
- **[Tout état]** → **Annulée**: Action administrative uniquement

## 5. Règles d'utilisation

### 5.1 Vérification et enregistrement d'entrée

À chaque entrée d'un membre, le système doit:
1. Vérifier que l'adhésion Cirque est valide
2. Identifier la cotisation à utiliser selon l'ordre de priorité
3. Enregistrer l'entrée
4. Décrémenter le nombre d'entrées restantes pour les carnets/pass

### 5.2 Ordre de priorité des cotisations

Si un membre possède plusieurs cotisations actives, l'ordre de priorité d'utilisation est:

1. Abonnements (Trimestriel ou Annuel)
2. Carnet de séances
3. Pass Journée

Cette priorité peut être modifiée manuellement par un administrateur lors de l'enregistrement de l'entrée, à la demande du membre.

### 5.3 Gestion des entrées

Chaque entrée doit être:
- Associée à un membre identifié
- Associée à une cotisation spécifique
- Horodatée
- Enregistrée par un administrateur ou bénévole identifié

### 5.4 Utilisation d'une cotisation par un tiers

Les cotisations sont strictement personnelles et ne peuvent pas être utilisées par un autre membre.

## 6. Règles de paiement

### 6.1 Modes de paiement acceptés

- Espèces
- Carte bancaire
- Chèque

### 6.2 Paiement échelonné

Pour les montants supérieurs à 50€ (Abonnements Trimestriel et Annuel), un paiement échelonné est possible:
- 2 ou 3 échéances maximum
- Paiement par chèque uniquement
- Tous les chèques doivent être fournis à l'achat
- Les dates d'encaissement sont fixées au moment de l'achat

### 6.3 Validation du paiement

Une cotisation n'est active qu'après validation complète du paiement:
- Immédiatement pour les paiements en espèces et carte bancaire
- Après avoir mis le chèque dans la caisse

### 6.4 Remboursement

Le remboursement d'une cotisation n'est possible que dans des cas exceptionnels:
- Erreur de vente
- Cas de force majeure (maladie longue durée avec certificat médical)

Le montant du remboursement est calculé au prorata:
- Pour les carnets: nombre d'entrées non utilisées
- Pour les abonnements: pourcentage de la période non utilisée

## 7. Gestion des situations particulières

### 7.1 Expiration de l'adhésion Cirque

Si l'adhésion Cirque d'un membre expire:
- Les abonnements en cours deviennent inutilisables jusqu'au renouvellement de l'adhésion
- Les carnets restent valides mais inutilisables jusqu'au renouvellement
- Aucune entrée n'est perdue

### 7.2 Renouvellement anticipé

Un membre peut renouveler sa cotisation avant son expiration:
- Pour les carnets: les entrées restantes et nouvelles s'additionnent
- Pour les abonnements: la nouvelle période commence à la fin de l'abonnement en cours

### 7.3 Prolongation exceptionnelle

Dans des cas particuliers (fermeture exceptionnelle, absence justifiée), un administrateur peut prolonger la validité d'un abonnement:
- La prolongation doit être documentée (raison, durée)
- Elle n'est possible que pour les abonnements, pas pour les carnets

### 7.4 Conversion entre types de cotisations

Il n'est pas possible de convertir directement une cotisation d'un type à un autre. Un membre doit acheter une nouvelle cotisation du type souhaité.

## 8. Notifications et alertes

### 8.1 Notifications aux membres

Le système doit notifier les membres dans les cas suivants:
- Expiration proche d'un abonnement (1 mois avant)
- Carnet avec peu d'entrées restantes (3, 2, puis 1)
- Confirmation d'achat de cotisation
- Confirmation d'utilisation d'entrée

### 8.2 Alertes administratives

Les administrateurs doivent recevoir des alertes pour:
- Paiements échelonnés à encaisser
- Abonnements à forte fréquentation
- Statistiques d'utilisation hebdomadaires

## 9. Rapports statistiques

Les données suivantes doivent être suivies et analysées:
- Nombre de cotisations vendues par type
- Taux d'utilisation des différentes formules
- Fréquentation journalière
- Chiffre d'affaires par période

## 10. Tableaux récapitulatifs

### 10.1 Tarifs des cotisations

| Type de cotisation    | Prix standard | Paiement échelonné     |
|-----------------------|---------------|------------------------|
| Pass Journée          | 4€            | Non applicable         |
| Carnet 10 Séances     | 30€           | Non applicable         |
| Abonnement Trimestriel| 65€           | 2 ou 3 fois possible   |
| Abonnement Annuel     | 150€          | 2 ou 3 fois possible   |

### 10.2 Résumé des règles par type de cotisation

| Règle                      | Pass Journée | Carnet 10 | Abo. Trim. | Abo. Annuel |
|----------------------------|--------------|-----------|------------|-------------|
| Adhésion Cirque requise    | Oui          | Oui       | Oui        | Oui         |
| Validité                   | 1 jour       | Illimitée | 3 mois     | 12 mois     |
| Nombre d'entrées           | 1            | 10        | Illimité   | Illimité    |
| Paiement échelonné         | Non          | Non       | Oui        | Oui         |
| Compatible avec abonnement | Non          | Non       | Non        | Non         |
| Cumulable même type        | Oui          | Oui       | Non        | Non         |
| Remboursable               | Exception    | Prorata   | Prorata    | Prorata     |
| Prolongeable               | Non          | Non       | Oui        | Oui         |

---

*Document créé le [DATE] - Version 1.0* 