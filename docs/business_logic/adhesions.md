# Système d'Adhésion et Rôles

## Rôles Système
### Backend (code)
- Utilisateur : compte sans adhésion
- Membre : statut de base pour tout adhérent
- Bénévole : membre avec accès admin basique
- Admin : accès complet
- Super Admin : accès total (godmode)

### Frontend (affichage)
- Utilisateur : compte sans adhésion
- Adhérent : membre avec adhésion Basic
- Adhérent Cirque : membre avec adhésion Circus
- Bénévole : accès admin basique
- Admin : accès complet
- Super Admin : accès total

## Types d'Adhésion
### Adhésion de base (1€)
- Accès aux événements
- Participation aux assemblées
- Newsletter
- Affichage : "Adhérent" sur la carte

### Adhésion cirque
- Nouvelle adhésion :
  * Prix normal : 10€
  * Prix réduit : 7€ (avec justificatif)
- Upgrade depuis adhésion de base :
  * Prix normal : 9€
  * Prix réduit : 6€ (avec justificatif)
- Inclut tous les avantages de l'adhésion de base
- Accès aux entraînements (via pointage)
- Affichage : "Adhérent Cirque" sur la carte

## Informations Visibles
### Carte Adhérent
- Type d'adhésion ("Adhérent" ou "Adhérent Cirque")
- Date d'adhésion à l'association
- Date d'expiration de l'adhésion actuelle
- Pack séances restantes (si applicable)
- Statut (actif/expiré)

## Permissions par Rôle

### Utilisateur (par défaut)
- Gestion du profil basique :
  * Modification email/mot de passe uniquement
  * Modification nom/prénom
- Newsletter :
  * Inscription/désinscription
- Consultation uniquement :
  * Voir les types d'adhésion disponibles
  * Voir les événements publics
  * Voir les informations de l'association
- Pas d'accès aux fonctionnalités de souscription en ligne
  * L'adhésion se fait uniquement sur place
  * Pas de paiement en ligne

### Adhérent (Basic ou Cirque)
- Toutes les permissions Utilisateur +
- Gestion du profil complet :
  * Voir son abonnement actif
  * Voir sa date d'adhésion
  * Voir son rôle actuel
- Événements :
  * Marquer son intérêt (bouton "intéressé")
  * Voir tous les événements (publics et membres)

### Bénévole
- Toutes les permissions Adhérent +
- Accès dashboard admin (vue basique) :
  * Gestion des présences aux entraînements
  * Ouverture/fermeture de la salle
  * Enregistrement des paiements sur place
  * Validation des présences

### Admin
- Accès complet au système
- Dashboard admin complet :
  * Gestion des utilisateurs
  * Gestion des rôles
  * Configuration du système
  * Vue détaillée des fiches adhérents
  * Rapports et statistiques

### Super Admin
- Toutes les permissions Admin +
- Accès aux logs système
- Gestion des administrateurs
- Configuration système avancée
- Opérations de maintenance
- Accès base de données
- Gestion des sauvegardes

## Règles Générales
- Une seule adhésion active par type
- Tarif réduit possible avec justificatif
- Durée d'un an
- Renouvellement possible 1 mois avant expiration
- Souscription uniquement sur place

## Donations
- Possibles lors de tout paiement à l'accueil
- Peuvent être anonymes
- Montant libre
- Indépendantes des adhésions 