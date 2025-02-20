# User Stories - Bénévole

## Gestion Quotidienne

### En tant que bénévole de service
```gherkin
Scénario: Ouverture session
Quand je prends mon service
Alors je peux accéder au tableau de bord
Et voir la liste des présents
Et gérer les entrées/sorties
```

### En tant que bénévole à l'accueil
```gherkin
Scénario: Nouvelle adhésion
Quand un visiteur souhaite adhérer
Alors je peux :
  - Créer son compte
  - Enregistrer son adhésion
  - Traiter le paiement
  - Générer sa carte membre
```

## Gestion des Présences

### En tant que bénévole
```gherkin
Scénario: Pointage membre
Quand un membre se présente
Alors je peux :
  - Vérifier ses droits
  - Enregistrer sa présence
  - Voir son historique
  - Gérer son départ
```

## Vente et Renouvellement

### En tant que bénévole caisse
```gherkin
Scénario: Vente cotisation
Quand un membre souhaite une cotisation
Alors je peux :
  - Vérifier son adhésion
  - Proposer les options
  - Traiter le paiement
  - Activer la cotisation
```

### En tant que bénévole administratif
```gherkin
Scénario: Renouvellement
Quand une adhésion arrive à échéance
Alors je peux :
  - Notifier le membre
  - Traiter le renouvellement
  - Mettre à jour la carte
``` 