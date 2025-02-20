# Système d'Adhésion et Rôles

## Rôles Système
### Backend
- Utilisateur (défaut) : compte sans adhésion
- Membre : utilisateur avec adhésion active
- Bénévole : membre avec accès gestion basique
- Administrateur : accès complet à la gestion
- Super Admin : accès total (configuration système)

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

1. **Utilisateur**
   - Gestion de son profil :
     * Modification email/mot de passe
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

2. **Membre** (nécessite une adhésion active)
   - Tout ce qu'un Utilisateur peut faire
   - Gestion du profil complet :
     * Voir son abonnement actif
     * Voir sa date d'adhésion
     * Voir son historique
   - Événements :
     * Marquer son intérêt (bouton "intéressé")
     * Voir tous les événements (publics et membres)
     * Inscription aux événements membres
   - Accès aux entraînements selon son type d'adhésion

3. **Bénévole**
   - Tout ce qu'un Membre peut faire
   - Accès dashboard admin (vue basique) :
     * Gestion des présences aux entraînements
     * Ouverture/fermeture de la salle
     * Enregistrement des paiements sur place
     * Création d'adhésions
     * Consultation des statistiques basiques
     * Validation des présences

4. **Administrateur**
   - Tout ce qu'un Bénévole peut faire
   - Dashboard admin complet :
     * Gestion complète des membres
     * Gestion des rôles Bénévole
     * Configuration des adhésions et tarifs
     * Vue détaillée des fiches adhérents
     * Accès aux statistiques avancées
     * Rapports financiers

5. **Super Admin**
   - Tout ce qu'un Administrateur peut faire
   - Gestion des rôles Administrateur
   - Configuration système avancée
   - Gestion des sauvegardes
   - Accès aux logs système
   - Opérations de maintenance
   - Accès base de données

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