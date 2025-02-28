# Guide Administrateur - Gestion des Notifications

## Introduction

Ce guide est destiné aux administrateurs et bénévoles autorisés du Circographe qui gèrent les communications avec les membres. Il détaille les procédures pour configurer, envoyer et surveiller les différents types de notifications à travers les canaux disponibles.

## Sommaire
1. [Comprendre le système de notifications](#comprendre-le-système-de-notifications)
2. [Configuration des notifications automatiques](#configuration-des-notifications-automatiques)
3. [Envoi de notifications manuelles](#envoi-de-notifications-manuelles)
4. [Gestion des modèles de messages](#gestion-des-modèles-de-messages)
5. [Suivi et analyse des communications](#suivi-et-analyse-des-communications)
6. [Gestion des préférences utilisateurs](#gestion-des-préférences-utilisateurs)
7. [Résolution des problèmes courants](#résolution-des-problèmes-courants)

## Comprendre le système de notifications

Le Circographe utilise un système de notifications à plusieurs niveaux :

### Niveaux d'importance

1. **Notifications critiques** :
   - Exigent une attention immédiate
   - Envoyées par tous les canaux disponibles
   - Ne peuvent jamais être désactivées par les utilisateurs
   - Exemples : fermetures exceptionnelles, annulations de dernière minute
   
2. **Notifications importantes** :
   - Informations significatives à connaître rapidement
   - Envoyées par les canaux préférentiels des utilisateurs
   - Désactivation limitée ou impossible
   - Exemples : rappels d'expiration, changements d'horaires
   
3. **Notifications informatives** :
   - Informations utiles mais non urgentes
   - Envoyées selon les préférences utilisateurs
   - Peuvent être désactivées par les utilisateurs
   - Exemples : nouveaux événements, statistiques
   
4. **Notifications optionnelles** :
   - Contenu complémentaire
   - Entièrement personnalisables par les utilisateurs
   - Exemples : newsletter, conseils, actualités

### Canaux de communication

Le système utilise quatre canaux principaux :

- **Email** : Format détaillé, pièces jointes possibles
- **Application** : Notifications internes à l'application web/mobile
- **Push mobile** : Alertes sur les appareils mobiles des utilisateurs
- **Postal** : Courrier physique (utilisé exceptionnellement)

## Configuration des notifications automatiques

### Accès au système de configuration

1. Connectez-vous avec un compte administrateur
2. Accédez à "Administration > Système de notifications"
3. Sélectionnez "Notifications automatiques"

### Configuration par domaine fonctionnel

#### Adhésion

1. **Confirmation d'adhésion** :
   - Accédez à "Notifications > Adhésion > Confirmation"
   - Vérifiez les déclencheurs (création/renouvellement d'adhésion)
   - Confirmez les canaux activés (email, application)
   - Vous pouvez personnaliser le délai d'envoi (immédiat par défaut)

2. **Rappels d'expiration** :
   - Configurez les rappels à J-30 et J-7
   - Vérifiez que les canaux appropriés sont activés
   - Testez ces notifications depuis l'interface de prévisualisation

#### Cotisation

Suivez une procédure similaire pour configurer :
- Confirmation d'achat
- Rappels d'entrées restantes (carnets)
- Alertes d'expiration (abonnements)

### Paramètres généraux

Dans "Paramètres généraux des notifications" :

1. **Horaires d'envoi** :
   - Définissez les plages horaires autorisées pour les envois
   - Configurez des exceptions pour les notifications critiques

2. **Limites de volume** :
   - Fixez le nombre maximal de notifications par jour/semaine par utilisateur
   - Définissez les priorités en cas de conflit

3. **Consolidation** :
   - Activez l'option de regroupement des notifications similaires
   - Configurez le délai de consolidation (15min, 1h, 6h, 24h)

## Envoi de notifications manuelles

### Notifications ciblées

Pour envoyer une notification à un utilisateur spécifique :

1. Accédez au profil du membre concerné
2. Cliquez sur "Communication > Envoyer notification"
3. Sélectionnez le type de notification et le niveau d'importance
4. Choisissez les canaux à utiliser
5. Rédigez votre message ou utilisez un modèle
6. Prévisualisez et envoyez

### Notifications de groupe

Pour envoyer à plusieurs utilisateurs :

1. Accédez à "Notifications > Nouvelle campagne"
2. Définissez les critères de sélection des destinataires :
   - Par type d'adhésion
   - Par statut de cotisation
   - Par date d'inscription
   - Par activité récente
   - Par préférences utilisateurs
3. Utilisez l'estimation de la taille du groupe avant envoi
4. Suivez les étapes 3-6 ci-dessus

### Notifications d'urgence

Pour les situations critiques :

1. Accédez à "Notifications > Alerte urgente"
2. Cette interface simplifie l'envoi rapide
3. Le message sera envoyé par tous les canaux disponibles
4. Un rapport d'accusés de réception sera généré
5. **Attention** : Utilisez uniquement pour des situations véritablement urgentes

## Gestion des modèles de messages

### Bibliothèque de modèles

1. **Accès à la bibliothèque** :
   - Naviguer vers "Notifications > Modèles"
   - Consultez les modèles par catégorie

2. **Utilisation des modèles** :
   - Sélectionnez un modèle existant
   - Personnalisez les champs variables si nécessaire
   - Prévisualisez le rendu sur différents canaux

### Création et modification de modèles

1. **Création d'un nouveau modèle** :
   - Cliquez sur "Créer nouveau modèle"
   - Sélectionnez la catégorie et le type de notification
   - Définissez un nom interne pour le modèle

2. **Conception du contenu** :
   - Utilisez l'éditeur pour créer le contenu
   - Insérez des variables avec les boutons dédiés
   - Créez des versions spécifiques par canal si nécessaire

3. **Test et validation** :
   - Envoyez un test à votre propre compte
   - Vérifiez le rendu sur différents appareils
   - Soumettez pour approbation si nécessaire

### Variables dynamiques

Les variables couramment utilisées :
- `{{nom_membre}}`, `{{prenom_membre}}` : Personnalisation
- `{{date_expiration}}` : Pour les rappels
- `{{solde_entrees}}` : Pour les carnets
- `{{lien_action}}` : Pour les boutons d'action

## Suivi et analyse des communications

### Tableaux de bord

1. **Vue d'ensemble** :
   - Accédez à "Notifications > Tableaux de bord"
   - Consultez les indicateurs clés : taux d'ouverture, clics, etc.
   - Filtrez par période, type de notification, canal

2. **Analyse détaillée** :
   - Sélectionnez une campagne spécifique pour l'analyse
   - Identifiez les tendances et problèmes potentiels
   - Exportez les données pour une analyse approfondie

### Rapports

Les rapports suivants sont disponibles :

- **Rapport d'efficacité** : Analyse l'impact des notifications
- **Rapport de volume** : Surveille le nombre de messages envoyés
- **Rapport de préférences** : Analyse les choix des utilisateurs
- **Rapport d'erreurs** : Identifie les problèmes techniques

Pour générer un rapport :
1. Accédez à "Notifications > Rapports"
2. Sélectionnez le type de rapport
3. Définissez la période et les filtres
4. Cliquez sur "Générer" et choisissez le format

## Gestion des préférences utilisateurs

### Vue d'ensemble des préférences

1. **Consultation globale** :
   - Accédez à "Notifications > Préférences globales"
   - Visualisez les tendances générales de préférence
   - Identifiez les canaux et types les plus/moins populaires

2. **Gestion individuelle** :
   - Depuis le profil d'un membre, accédez à "Préférences de notification"
   - Consultez et modifiez ses paramètres si nécessaire
   - Tout changement doit être documenté avec motif

### Configuration des options disponibles

1. **Définition des options personnalisables** :
   - Accédez à "Administration > Options de préférences"
   - Déterminez quelles notifications peuvent être désactivées
   - Configurez les options minimum obligatoires

2. **Communication des options** :
   - Rédigez les descriptions claires pour chaque option
   - Préparez des conseils pour aider les utilisateurs
   - Mettez à jour la FAQ relative aux notifications

## Résolution des problèmes courants

### Echecs de livraison

1. **Identification des problèmes** :
   - Consultez "Notifications > Erreurs de livraison"
   - Filtrez par canal, type d'erreur ou période

2. **Résolution commune par canal** :

   **Email** :
   - Vérifiez les bounces (hard/soft)
   - Contrôlez les adresses incorrectes
   - Vérifiez les problèmes de réputation du domaine

   **Push mobile** :
   - Contrôlez les tokens expirés
   - Vérifiez les problèmes de service (Firebase/Apple)
   - Confirmez les autorisations sur les appareils

   **Application** :
   - Vérifiez l'état du service de notifications
   - Contrôlez les logs d'erreur spécifiques

3. **Correction et suivi** :
   - Appliquez les corrections nécessaires
   - Tentez un nouvel envoi pour les notifications importantes
   - Documentez les problèmes récurrents

### Problèmes de contenu

1. **Notifications mal formatées** :
   - Vérifiez les modèles pour les erreurs de balisage
   - Contrôlez la compatibilité multiplateforme
   - Testez sur différents clients email et appareils

2. **Variables non résolues** :
   - Identifiez les variables qui ne s'affichent pas correctement
   - Vérifiez les sources de données associées
   - Corrigez les mappings dans la configuration

### Gestion des plaintes

1. **Réception des plaintes** :
   - Consultez "Notifications > Feedback utilisateurs"
   - Traitez en priorité les désabonnements et plaintes directes

2. **Analyse et action** :
   - Évaluez la pertinence de la plainte
   - Ajustez la fréquence ou le contenu si nécessaire
   - Contactez l'utilisateur pour clarification si approprié

3. **Adaptation système** :
   - Si les plaintes sont récurrentes sur un type de notification
   - Envisagez une révision de la stratégie de communication
   - Présentez des recommandations au comité de communication

---

Pour toute question non couverte par ce guide, contactez l'équipe technique à admin-notification@lecircographe.fr 