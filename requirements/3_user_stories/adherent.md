# User Stories - Adhérent

## Inscription et Profil
En tant qu'utilisateur, je veux...
- M'inscrire avec mon email et mot de passe
- Modifier mes informations de base (email, mot de passe, nom, prénom)
- M'inscrire/me désinscrire de la newsletter
- Voir les types d'adhésion disponibles

En tant que membre avec adhésion active, je veux...
- Voir mon type d'adhésion actuel
- Voir ma date d'adhésion et d'expiration
- Consulter mon historique de présences
- Voir mes paiements effectués
- M'inscrire aux événements membres
- Marquer mon intérêt pour les événements

## Accès aux Entraînements
En tant que membre avec adhésion cirque, je veux...
- Voir les créneaux d'entraînement disponibles
- Consulter mon solde de séances (si pack)
- Voir mon historique de présences
- Recevoir une notification avant expiration

## Adhésion Basic (1€)
En tant qu'adhérent Basic, je veux...
- Voir mon statut d'adhérent sur ma carte
- Voir ma date d'adhésion à l'association
- Voir la date d'expiration de mon adhésion
- Accéder aux événements de l'association
- Participer aux assemblées
- Marquer mon intérêt pour un événement
- Voir tous les événements (publics et membres)

## Adhésion Cirque (10€/7€)
En tant qu'adhérent Cirque, je veux...
- Avoir tous les avantages de l'adhésion Basic
- Voir mon statut "Adhérent Cirque" sur ma carte
- Accéder aux entraînements (via pointage bénévole)
- Voir mon historique de présence
- Voir mon pack de séances restantes (si applicable)

## Renouvellement et Upgrade
En tant qu'adhérent, je veux...
- Être notifié avant l'expiration (1 mois)
- Connaître les tarifs applicables (normal/réduit)
- Comprendre les conditions d'upgrade (Basic vers Cirque)
- Savoir que je dois me rendre sur place pour :
  * Renouveler mon adhésion
  * Upgrader mon adhésion
  * Présenter un justificatif pour tarif réduit

## Scénarios Détaillés

### En tant que nouvel utilisateur
```gherkin
Scénario: Création de compte
Étant donné que je suis un nouveau visiteur
Quand je crée mon compte sur le site
Alors je peux renseigner :
  - Mon email
  - Mon mot de passe
  - Mes informations personnelles
Et je deviens un utilisateur sans adhésion
```

### En tant qu'utilisateur sans adhésion
```gherkin
Scénario: Adhésion sur place
Étant donné que j'ai un compte utilisateur
Quand je me présente à l'accueil
Alors je peux :
  - Choisir mon type d'adhésion (Basic ou Cirque)
  - Présenter un justificatif pour tarif réduit si nécessaire
  - Effectuer le paiement
  - Accéder à mon profil avec mon statut d'adhérent
```

### En tant qu'adhérent Basic
```gherkin
Scénario: Upgrade vers Cirque
Étant donné que j'ai une adhésion Basic active
Quand je me présente à l'accueil
Alors je peux :
  - Upgrader vers l'adhésion Cirque
  - Payer le tarif d'upgrade (9€ ou 6€ réduit)
  - Accéder aux entraînements
```

### En tant qu'adhérent Cirque
```gherkin
Scénario: Accès aux entraînements
Étant donné que j'ai une adhésion Cirque active
Quand je me présente à un entraînement
Alors je peux :
  - Me faire pointer par un bénévole
  - Accéder à la salle
```

### En tant qu'adhérent (Basic ou Cirque)
```gherkin
Scénario: Consultation de mon profil
Quand j'accède à mon compte
Alors je peux voir :
  - Mon type d'adhésion
  - Ma date d'adhésion
  - Ma date d'expiration
  - Mon historique d'achats
Et je peux marquer mon intérêt pour les événements
``` 