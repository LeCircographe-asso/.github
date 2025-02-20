# User Stories - Le Circographe

## 🔐 Authentification

### Must Have
- En tant que visiteur, je veux pouvoir créer un compte avec mon email et mot de passe afin d'accéder à l'application
- En tant que visiteur, je veux pouvoir me connecter avec mon email et mot de passe afin d'accéder à mon compte
- En tant qu'utilisateur connecté, je veux pouvoir me déconnecter afin de sécuriser mon compte

### Should Have
- En tant qu'utilisateur, je veux pouvoir cocher "Se souvenir de moi" lors de la connexion afin d'éviter de me reconnecter à chaque visite
- En tant qu'utilisateur, je veux voir des messages d'erreur clairs si mes identifiants sont incorrects afin de comprendre pourquoi la connexion échoue
- En tant qu'utilisateur, je veux être redirigé vers la page que je voulais visiter après m'être connecté

### Could Have
- En tant qu'utilisateur, je veux pouvoir réinitialiser mon mot de passe si je l'ai oublié
- En tant qu'utilisateur, je veux recevoir un email de confirmation lors de la création de mon compte

## 🎪 Adhésions et Cotisations
### Must Have
- En tant que membre, je veux pouvoir :
  * M'inscrire avec une adhésion Basic ou Cirque
  * Renouveler mon adhésion avant expiration
  * Voir mes séances restantes
  * Consulter l'historique de mes présences
  * Recevoir des alertes d'expiration

### Should Have
- En tant que membre, je veux pouvoir :
  * Télécharger mes reçus de paiement
  * Suspendre temporairement mon abonnement
  * Voir les créneaux disponibles
  * Mettre à jour mes informations

## 📋 Gestion des Présences
### Must Have
- En tant que bénévole, je veux pouvoir :
  * Vérifier les adhésions
  * Enregistrer les présences
  * Voir les quotas de présence
  * Gérer les événements spéciaux

### Should Have
- En tant que bénévole, je veux pouvoir :
  * Noter les incidents
  * Voir l'historique des présences

## 💰 Paiements et Comptabilité
### Must Have
- En tant qu'admin, je veux pouvoir :
  * Enregistrer les paiements (CB, chèque, espèces)
  * Émettre des reçus
  * Suivre les paiements
  * Gérer les tarifs réduits

### Should Have
- En tant qu'admin, je veux pouvoir :
  * Générer des rapports financiers
  * Gérer les remboursements
  * Suivre les impayés
  * Exporter les données comptables

## 🔐 Rôles et Permissions
### Bénévole
- Vérifier les adhésions des membres
- Enregistrer les présences quotidiennes
- Consulter les statistiques du jour
- Gérer les événements
- Voir les alertes de capacité

### Administrateur
- Gérer les adhésions et abonnements
- Traiter les paiements
- Accéder aux rapports complets
- Gérer les bénévoles
- Configurer les paramètres

### Super Admin
- Accès complet au système
- Gestion des rôles
- Configuration avancée
- Audit système
- Correction des données

## 📊 Traçabilité
### Audit
- Voir l'historique des modifications
- Suivre les corrections automatiques
- Consulter les logs de sécurité
- Analyser les tendances
- Exporter les données

### Sécurité
- Validation des accès
- Protection des données
- Détection des anomalies
- Alertes de sécurité
- Journal des incidents

## 🎪 Gestion des Entraînements

### Must Have
- En tant qu'utilisateur, je veux pouvoir voir les créneaux d'entraînement disponibles
- En tant qu'utilisateur, je veux pouvoir m'inscrire à un créneau d'entraînement
- En tant que bénévole, je veux pouvoir enregistrer les présences aux entraînements
- En tant qu'admin, je veux pouvoir créer et gérer les créneaux d'entraînement

### Should Have
- En tant qu'utilisateur, je veux recevoir un rappel avant mon entraînement
- En tant qu'utilisateur, je veux pouvoir voir mon historique d'entraînements
- En tant que bénévole, je veux pouvoir limiter le nombre de participants par créneau
- En tant qu'admin, je veux pouvoir voir des statistiques de fréquentation

### Could Have
- En tant qu'utilisateur, je veux pouvoir noter mes progrès par discipline
- En tant qu'utilisateur, je veux pouvoir échanger mon créneau avec un autre membre
- En tant que bénévole, je veux pouvoir ajouter des notes sur les séances

## 📱 Progressive Web App

### Must Have
- En tant qu'utilisateur, je veux pouvoir installer l'application sur mon téléphone/ordinateur
- En tant qu'utilisateur, je veux pouvoir accéder à mes données même hors connexion
- En tant qu'utilisateur, je veux recevoir des notifications push pour les rappels importants
- En tant qu'utilisateur, je veux que l'application se mette à jour automatiquement

### Should Have
- En tant qu'utilisateur, je veux pouvoir personnaliser mes préférences de notification
- En tant qu'utilisateur, je veux pouvoir synchroniser mes données quand je retrouve la connexion
- En tant qu'utilisateur, je veux voir un indicateur de statut de connexion
- En tant qu'administrateur, je veux pouvoir envoyer des notifications push à tous les utilisateurs

### Could Have
- En tant qu'utilisateur, je veux pouvoir partager des contenus via l'API de partage native
- En tant qu'utilisateur, je veux pouvoir scanner des QR codes pour les présences
- En tant qu'utilisateur, je veux avoir accès à mon appareil photo pour les justificatifs

## 📨 Notifications

### Must Have
- En tant qu'utilisateur, je veux recevoir des notifications pour :
  * L'expiration prochaine de mon adhésion
  * La confirmation de mes paiements
  * Les rappels d'entraînement
  * Les annulations de dernière minute
- En tant qu'utilisateur, je veux pouvoir choisir les canaux de notification (email, push, in-app)
- En tant qu'administrateur, je veux pouvoir configurer les modèles de notification

### Should Have
- En tant qu'utilisateur, je veux pouvoir définir des plages horaires pour les notifications
- En tant qu'utilisateur, je veux voir un centre de notifications dans l'application
- En tant qu'utilisateur, je veux pouvoir marquer les notifications comme lues
- En tant qu'administrateur, je veux voir les statistiques de lecture des notifications

### Could Have
- En tant qu'utilisateur, je veux pouvoir filtrer mes notifications par type
- En tant qu'utilisateur, je veux pouvoir archiver mes anciennes notifications
- En tant qu'administrateur, je veux pouvoir tester les notifications avant envoi

## 📊 Traçabilité

### Audit
- Voir l'historique des modifications
- Suivre les corrections automatiques
- Consulter les logs de sécurité
- Analyser les tendances
- Exporter les données

### Sécurité
- Validation des accès
- Protection des données
- Détection des anomalies
- Alertes de sécurité
- Journal des incidents 