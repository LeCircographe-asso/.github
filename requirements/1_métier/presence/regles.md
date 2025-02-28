# Règles Métier - Présence

## Identification du document

| Domaine           | Présence                            |
|-------------------|-------------------------------------|
| Version           | 1.0                                 |
| Référence         | REGLE-PRE-2023-01                   |
| Dernière révision | [DATE]                              |

## 1. Définition et objectif

Le domaine de présence définit les règles et processus liés à l'enregistrement et au suivi des présences des membres aux entraînements et activités du Circographe. Ce système permet de gérer les entrées, de valider les conditions d'accès, de générer des statistiques de fréquentation et d'assurer la traçabilité des présences pour des raisons de sécurité et de gestion.

## 2. Types de listes de présence

### 2.1 Liste de présence quotidienne

| Caractéristique      | Valeur                               |
|----------------------|--------------------------------------|
| Fréquence            | Quotidienne                          |
| Accès                | Membres avec adhésion Cirque et cotisation valide (ou adhésion Basic) |
| Validation requise   | Vérification adhésion + cotisation   |
| Responsable          | Bénévole d'accueil                   |

**Règles spécifiques**:
- Création automatique chaque jour d'ouverture
- Enregistrement obligatoire de tous les membres présents
- Vérification systématique des droits d'accès
- Clôture automatique à la fermeture du lieu

### 2.2 Liste d'événement spécial

| Caractéristique      | Valeur                               |
|----------------------|--------------------------------------|
| Fréquence            | Ponctuelle                           |
| Accès                | Variable selon l'événement           |
| Validation requise   | Selon règles de l'événement          |
| Responsable          | Organisateur de l'événement          |

**Règles spécifiques**:
- Création manuelle par un administrateur
- Paramètres d'accès configurables (adhésion Basic, Cirque, ou public)
- Possibilité d'enregistrer des non-membres (avec coordonnées)
- Clôture manuelle par l'organisateur

## 3. Conditions d'accès aux entraînements

### 3.1 Prérequis d'accès

Pour accéder aux entraînements réguliers, un membre doit disposer de :
1. Une adhésion Cirque valide (non expirée)
2. Une cotisation valide parmi :
   - Pass Journée
   - Carnet avec entrées restantes
   - Abonnement Trimestriel en cours de validité
   - Abonnement Annuel en cours de validité

### 3.2 Exceptions et cas particuliers

| Cas                  | Règle appliquée                      |
|----------------------|--------------------------------------|
| Membre avec adhésion expirée | Accès refusé, renouvellement proposé |
| Membre sans cotisation | Achat de Pass Journée proposé      |

## 4. Processus d'enregistrement des présences

### 4.1 Enregistrement standard

1. Accueil du membre
2. Identification (nom/prénom ou carte membre)
3. Vérification de l'adhésion Cirque ou Basic
4. Vérification de la cotisation disponible
5. Sélection automatique de la cotisation selon priorité
6. Enregistrement de l'entrée
7. Décompte d'une entrée si applicable (carnet, pass)
8. Confirmation au membre

### 4.2 Cas particuliers d'enregistrement

#### Achat sur place
1. Vérification de l'adhésion
2. Proposition d'achat de Pass Journée
3. Processus de paiement
4. Activation immédiate
5. Enregistrement de l'entrée

### 4.3 Départ et clôture

- Enregistrement des départs : optionnel
- Clôture de la liste :
  * Automatique à minuit
  * Manuelle possible par un administrateur
- Archivage automatique des listes clôturées

## 5. Cycle de vie d'une liste de présence

### 5.1 États possibles

| État                  | Description                          |
|-----------------------|--------------------------------------|
| Créée                 | Liste initialisée mais non ouverte   |
| Ouverte               | Liste active, enregistrement possible|
| Clôturée              | Liste fermée, consultation seule     |
| Archivée              | Liste historisée après 30 jours      |

### 5.2 Transitions d'état

- **Création** → **Créée**: À l'initialisation de la liste
- **Créée** → **Ouverte**: À l'ouverture du lieu ou manuellement
- **Ouverte** → **Clôturée**: À la fermeture du lieu ou manuellement
- **Clôturée** → **Archivée**: Automatiquement après 30 jours

## 6. Gestion des statistiques et rapports

### 6.1 Statistiques quotidiennes

- Nombre total de présences
- Répartition par type de cotisation utilisée
- Heures de pointe
- Durée moyenne de présence (si départs enregistrés)
- Nouvelles adhésions/cotisations vendues

### 6.2 Statistiques mensuelles

- Fréquentation moyenne par jour
- Évolution par rapport au mois précédent
- Taux d'occupation
- Répartition des membres par fréquence de visite
- Analyse des pics de fréquentation

### 6.3 Rapports spécifiques

- Rapport de fréquentation pour le conseil d'administration
- Suivi des essais et taux de conversion
- Rapport d'activité des bénévoles
- Statistiques pour les demandes de subvention

## 7. Règles de sécurité et confidentialité

### 7.1 Accès aux données

| Rôle                  | Droits d'accès                       |
|-----------------------|--------------------------------------|
| Membre                | Consultation de ses propres présences |
| Bénévole d'accueil    | Enregistrement et consultation du jour |
| Administrateur        | Accès complet, modification possible |
| Coordinateur          | Accès aux statistiques et rapports   |

### 7.2 Conservation des données

- Listes de présence actives : accès complet
- Listes clôturées : consultation seule pendant 30 jours
- Listes archivées : conservation 3 ans, accès restreint
- Anonymisation des données après 3 ans

### 7.3 Utilisation en cas d'urgence

- Extraction rapide de la liste du jour en cas d'évacuation
- Procédure d'appel en cas d'incident
- Contact d'urgence accessible pour chaque membre présent

## 8. Intégration avec les autres domaines

### 8.1 Adhésion

- Vérification automatique de la validité de l'adhésion
- Alerte si adhésion proche de l'expiration
- Proposition de renouvellement si expirée

### 8.2 Cotisation

- Sélection automatique de la cotisation à utiliser
- Décompte des entrées pour les carnets
- Vérification de la validité des abonnements
- Alerte si carnet presque épuisé

### 8.3 Paiement

- Possibilité d'achat de Pass Journée à l'entrée
- Enregistrement du paiement et activation immédiate
- Génération de reçu

## 9. Tableaux récapitulatifs

### 9.1 Priorité d'utilisation des cotisations

| Priorité | Type de cotisation    | Condition d'utilisation              |
|----------|----------------------|--------------------------------------|
| 1        | Abonnement Annuel    | En cours de validité                 |
| 2        | Abonnement Trimestriel | En cours de validité               |
| 3        | Carnet 10 Séances    | Entrées disponibles                  |
| 4        | Pass Journée         | Acheté le jour même                  |

### 9.2 Droits d'accès par type de membre

| Type de membre        | Entraînement régulier | Événement spécial | Permanence |
|-----------------------|----------------------|-------------------|------------|
| Non-membre            | Non     | Non  | Non        |
| Adhésion Basic        | Visite quotidienne                  | Selon événement   | Non        |
| Adhésion Cirque sans cotisation | Non        | Selon événement   | Si bénévole |
| Adhésion Cirque avec cotisation | Oui        | Selon événement   | Si bénévole |
| Bénévole              | Selon cotisation     | Selon événement   | Oui        |
| Administrateur        | Oui                  | Oui               | Oui        |

---

*Document créé le [DATE] - Version 1.0* 