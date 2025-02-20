# User Stories - Bénévole

## Accès Dashboard
En tant que bénévole, je veux...
- Accéder à une version basique du dashboard admin
- Voir les entraînements du jour
- Voir la liste des présences du jour (Entraînement Libre)
- Accéder aux fonctionnalités de gestion basique

## Gestion des Entraînements
En tant que bénévole, je veux...
- Ouvrir/fermer la salle d'entraînement
- Faire le pointage des présences
- Valider la présence des adhérents Cirque

## Gestion des Paiements
En tant que bénévole, je veux...
- Enregistrer les paiements sur place
- Enregistrer les adhésions (Basic ou Cirque)
- Enregistrer les abonnements
- Enregistrer les donations
- Appliquer les tarifs réduits avec justificatif

## Gestion des Présences
En tant que bénévole, je veux...
- Voir la liste de présence du jour
- Ajouter un adhérent à la liste
- Voir rapidement si un adhérent :
  * A une adhésion valide
  * A un abonnement actif
  * A déjà été pointé aujourd'hui
- Être alerté si :
  * L'adhésion est expirée
  * L'abonnement est épuisé
  * L'adhérent est déjà pointé

## Gestion des Listes de Présence
En tant que bénévole, je veux...
- Voir toutes les listes du jour
- Faire le check-in sur les listes d'entraînement et d'événements
- Voir rapidement si un adhérent :
  * A une adhésion valide
  * A un abonnement actif
  * Est déjà sur d'autres listes du jour

## Scénarios Détaillés

### En tant que bénévole à l'accueil
```gherkin
Scénario: Enregistrement d'une nouvelle adhésion
Étant donné que je suis connecté comme bénévole
Quand un utilisateur se présente pour adhérer
Alors je peux :
  - Vérifier son compte utilisateur
  - Sélectionner le type d'adhésion
  - Appliquer le tarif réduit si justificatif
  - Enregistrer le paiement
```

### En tant que bénévole aux entraînements
```gherkin
Scénario: Gestion d'une séance
Étant donné que je suis bénévole de permanence
Quand j'ouvre la salle
Alors je peux :
  - Marquer la salle comme ouverte
  - Pointer les présences des adhérents
  - Fermer la salle en fin de séance
```

### En tant que bénévole gestionnaire
```gherkin
Scénario: Gestion des paiements
Étant donné que je suis à l'accueil
Quand je reçois un paiement
Alors je peux :
  - Enregistrer le montant
  - Spécifier le type (adhésion/abonnement/donation)
  - Noter si tarif réduit
```

### En tant que bénévole adhérent
```gherkin
Scénario: Accès à mes fonctions
Quand j'accède à mon compte
Alors je peux voir :
  - Mon profil adhérent normal
  - Mes outils de bénévole
  - Le dashboard basique
```

### En tant que bénévole à la caisse
```gherkin
Scénario: Réception d'une donation
Étant donné que je suis à l'accueil
Quand quelqu'un souhaite faire un don
Alors je peux :
  - Enregistrer le montant de la donation
  - Noter si c'est anonyme ou non
  - Générer un reçu si demandé
```

## Scénarios

### Pointage Standard
```gherkin
Scénario: Pointage sur la liste d'entraînement
Étant donné que je suis bénévole
Quand je scanne la carte d'un adhérent
Alors je peux voir son statut
Et l'ajouter à la liste si tout est en ordre
```

### Gestion Multiple
```gherkin
Scénario: Gestion de plusieurs listes
Étant donné que je suis bénévole
Et qu'il existe une liste d'entraînement aujourd'hui
Quand je crée une nouvelle liste de type "réunion"
Alors je peux gérer les deux listes en parallèle
Et pointer les adhérents sur l'une ou l'autre
```

### Vérification des Droits
```gherkin
Scénario: Vérification avant pointage
Étant donné qu'un adhérent se présente
Quand je scanne sa carte
Alors je vois :
  * Son type d'adhésion
  * Son abonnement actif (si applicable)
  * Les listes où il est déjà présent aujourd'hui
```

### Scénarios
```gherkin
Scénario: Check-in événement
Étant donné que je suis bénévole
Et qu'il y a un événement aujourd'hui
Quand je scanne la carte d'un adhérent
Alors je peux l'ajouter à la liste de l'événement
Et voir son statut d'adhésion

Scénario: Tentative d'accès réunion
Étant donné que je suis bénévole
Et qu'il y a une réunion aujourd'hui
Alors je ne vois pas l'option de check-in pour cette liste
Et je suis informé que seuls les admins peuvent gérer les réunions
``` 