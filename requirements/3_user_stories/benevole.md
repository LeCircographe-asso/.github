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
Scénario: Pointage d'un adhérent
Étant donné que je suis bénévole
Et que nous ne sommes pas lundi
Quand je scanne la carte d'un adhérent
Alors je peux voir son statut
Et l'ajouter à la liste si tout est en ordre
```

### Jour de Fermeture
```gherkin
Scénario: Tentative de pointage un lundi
Étant donné que je suis bénévole
Et que nous sommes lundi
Alors je vois un message indiquant que le Circographe est fermé
Et je ne peux pas ajouter d'adhérents
``` 