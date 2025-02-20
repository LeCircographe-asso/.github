# User Stories - Adhérent

## Inscription et Adhésion

### En tant que nouvel utilisateur
```gherkin
Scénario: Première visite
Étant donné que je suis un nouveau visiteur
Quand je me présente à l'accueil
Alors je peux créer un compte
Et choisir mon type d'adhésion
Et effectuer le paiement
Et recevoir ma carte de membre
```

### En tant qu'adhérent simple
```gherkin
Scénario: Upgrade vers adhésion cirque
Étant donné que j'ai une adhésion simple active
Quand je souhaite pratiquer
Alors je peux upgrader vers l'adhésion cirque
Et acheter une cotisation
Et accéder à l'espace de pratique
```

## Gestion du Compte

### En tant qu'adhérent
```gherkin
Scénario: Consultation de mon profil
Quand j'accède à mon compte
Alors je peux voir :
  - Mes informations personnelles
  - Mes adhésions actives
  - Mes cotisations en cours
  - Mon historique de présence
```

### En tant qu'adhérent cirque
```gherkin
Scénario: Achat de cotisation
Étant donné que j'ai une adhésion cirque valide
Quand je souhaite m'entraîner
Alors je peux acheter une nouvelle cotisation
Et l'utiliser immédiatement
```

## Présence et Accès

### En tant que membre actif
```gherkin
Scénario: Accès à l'entraînement
Quand je me présente à l'accueil
Alors je peux m'enregistrer
Et accéder à l'espace si mes droits sont valides
``` 