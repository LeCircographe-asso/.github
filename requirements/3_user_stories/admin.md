# User Stories - Administrateur

## Gestion des Utilisateurs
En tant qu'admin, je veux...
- Voir tous les utilisateurs du système
- Gérer les rôles des utilisateurs
- Voir les détails des fiches adhérents
- Gérer les statuts des adhésions

## Gestion des Accès
En tant qu'admin, je veux...
- Attribuer/retirer le rôle de bénévole
- Gérer les accès au dashboard admin
- Configurer les permissions
- Voir les logs de connexion

## Gestion Administrative
En tant qu'admin, je veux...
- Accéder aux rapports et statistiques
- Gérer la configuration du système
- Voir l'historique des paiements
- Voir l'historique des présences :
  * Par jour/semaine/mois
  * Par utilisateur
  * Statistiques globales

## Scénarios Détaillés

### En tant qu'administrateur système
```gherkin
Scénario: Gestion des rôles
Étant donné que je suis connecté comme admin
Quand j'accède à la gestion des utilisateurs
Alors je peux :
  - Voir la liste complète des utilisateurs
  - Modifier leurs rôles
  - Gérer leurs permissions
  - Voir leur historique complet
  - Modifier leurs informations complètes :
    * Données personnelles
    * Coordonnées
    * Documents administratifs
    * Notes internes
```

### En tant qu'administrateur des accès
```gherkin
Scénario: Attribution des rôles bénévoles
Étant donné que je suis dans le dashboard admin
Quand je sélectionne un adhérent
Alors je peux :
  - Lui attribuer le rôle bénévole
  - Définir ses accès spécifiques
  - Voir ses actions en tant que bénévole
```

### En tant qu'administrateur financier
```gherkin
Scénario: Consultation des rapports
Étant donné que je suis dans la section rapports
Alors je peux voir :
  - Les statistiques d'adhésion
  - L'historique des paiements
  - Les donations reçues
  - Les abonnements actifs
```

### En tant qu'administrateur des entraînements
```gherkin
Scénario: Gestion des présences
Étant donné que je consulte les entraînements
Alors je peux :
  - Voir l'historique des présences
  - Gérer les incidents
  - Ajuster les pointages si nécessaire
```

### En tant qu'administrateur système
```gherkin
Scénario: Configuration système
Quand j'accède aux paramètres
Alors je peux :
  - Configurer les règles d'adhésion
  - Gérer les tarifs
  - Gérer les horaires d'ouverture :
    * Définir les créneaux réguliers
    * Ajouter des fermetures exceptionnelles
    * Mettre à jour l'affichage public
  - Paramétrer les notifications
``` 