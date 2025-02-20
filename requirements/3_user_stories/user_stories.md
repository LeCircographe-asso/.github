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

## 👥 Gestion des Adhésions

### Must Have
- En tant qu'utilisateur, je veux pouvoir souscrire à une adhésion de base afin d'être membre de l'association
- En tant qu'utilisateur, je veux pouvoir voir la date de fin de mon adhésion afin de savoir quand la renouveler
- En tant que bénévole, je veux pouvoir vérifier si un utilisateur a une adhésion valide
- En tant qu'admin, je veux pouvoir gérer les adhésions des membres (création, modification, annulation)

### Should Have
- En tant qu'utilisateur, je veux pouvoir demander un tarif réduit avec justificatif
- En tant qu'utilisateur, je veux recevoir une notification avant l'expiration de mon adhésion
- En tant que bénévole, je veux pouvoir voir l'historique des adhésions d'un membre
- En tant qu'admin, je veux pouvoir définir différents types d'adhésions avec leurs tarifs

### Could Have
- En tant qu'utilisateur, je veux pouvoir télécharger ma carte de membre
- En tant qu'utilisateur, je veux pouvoir renouveler automatiquement mon adhésion
- En tant qu'admin, je veux pouvoir générer des rapports sur les adhésions

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

## 💰 Gestion des Paiements

### Must Have
- En tant qu'utilisateur, je veux pouvoir payer mon adhésion en ligne
- En tant qu'utilisateur, je veux recevoir une confirmation de paiement
- En tant que bénévole, je veux pouvoir enregistrer un paiement en espèces
- En tant qu'admin, je veux pouvoir suivre tous les paiements

### Should Have
- En tant qu'utilisateur, je veux pouvoir voir l'historique de mes paiements
- En tant qu'utilisateur, je veux pouvoir choisir mon mode de paiement
- En tant que bénévole, je veux pouvoir générer une facture
- En tant qu'admin, je veux pouvoir gérer les remboursements

### Could Have
- En tant qu'utilisateur, je veux pouvoir configurer un paiement récurrent
- En tant d'admin, je veux pouvoir générer des rapports financiers
- En tant que bénévole, je veux pouvoir appliquer des réductions exceptionnelles

## 👮 Gestion des Rôles

### Must Have
- En tant qu'admin, je veux pouvoir assigner des rôles aux utilisateurs
- En tant qu'admin, je veux pouvoir définir les permissions par rôle
- En tant que bénévole, je veux accéder aux fonctionnalités de gestion basique
- En tant qu'utilisateur, je veux voir uniquement les actions autorisées pour mon rôle

### Should Have
- En tant qu'admin, je veux pouvoir créer des rôles personnalisés
- En tant qu'admin, je veux pouvoir voir l'historique des modifications de rôles
- En tant que bénévole, je veux pouvoir demander des permissions supplémentaires

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

## 🔐 Rôles et Permissions

### Bénévole
- Vérifier les adhésions des membres
- Enregistrer les présences quotidiennes
- Consulter les statistiques du jour
- Gérer la liste d'attente
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