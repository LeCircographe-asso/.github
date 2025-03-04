# User Stories - Domaine Notification

Ce document contient les user stories relatives au système de notification de l'application Le Circographe, couvrant les rappels, les confirmations et autres communications automatisées.

## Configuration des notifications

### En tant qu'utilisateur
Je veux pouvoir configurer mes préférences de notification
Afin de contrôler les communications que je reçois

**Critères d'acceptation :**
1. Je peux activer/désactiver chaque type de notification individuellement
2. Je peux choisir les canaux de réception (email, push, dans l'application)
3. Je peux définir des plages horaires pour recevoir les notifications
4. Mes préférences sont enregistrées et respectées par le système
5. Je peux facilement tout activer ou tout désactiver en un clic

### En tant qu'adhérent
Je veux recevoir uniquement les notifications pertinentes pour moi
Afin d'éviter la surcharge d'informations

**Critères d'acceptation :**
1. Les notifications sont filtrées selon mon statut (Basic/Cirque)
2. Je ne reçois que les informations concernant mes formules souscrites
3. Les notifications sont adaptées à mon profil d'utilisation
4. Je ne reçois plus de notifications pour des services expirés
5. Le système regroupe intelligemment les notifications similaires

### En tant qu'administrateur
Je veux pouvoir configurer les modèles de notification
Afin de personnaliser la communication avec les adhérents

**Critères d'acceptation :**
1. Je peux modifier le contenu de chaque type de notification
2. Je peux insérer des variables dynamiques (nom, date, montant, etc.)
3. Je peux prévisualiser les notifications avant de sauvegarder
4. Je peux programmer des notifications récurrentes
5. Je peux définir des règles de déclenchement personnalisées

## Notifications d'adhésion

### En tant qu'adhérent
Je veux être notifié de l'approche de la date d'expiration de mon adhésion
Afin de pouvoir la renouveler à temps

**Critères d'acceptation :**
1. Je reçois une première notification 1 mois avant expiration
2. Je reçois un rappel 1 semaine avant expiration
3. Je reçois un dernier rappel le jour de l'expiration
4. La notification inclut les informations sur le processus de renouvellement
5. Je peux cliquer sur un lien direct pour initier le renouvellement

### En tant qu'adhérent
Je veux recevoir une confirmation après toute modification de mon adhésion
Afin d'être assuré que les changements ont été pris en compte

**Critères d'acceptation :**
1. Je reçois une confirmation immédiate après une nouvelle adhésion
2. Je reçois une confirmation après un renouvellement
3. Je reçois une confirmation après un upgrade d'adhésion
4. La notification inclut les détails de la transaction (montant, date)
5. La notification inclut la nouvelle date d'expiration

## Notifications de cotisation

### En tant qu'adhérent Cirque
Je veux être notifié de l'approche de la fin de validité de ma formule
Afin de prévoir son renouvellement

**Critères d'acceptation :**
1. Pour les formules mensuelles, je reçois un rappel 7 jours avant expiration
2. Pour les formules annuelles, je reçois un rappel 1 mois avant expiration
3. Pour les cartes de séances, je reçois une alerte quand il me reste 2 séances
4. La notification inclut les options de renouvellement disponibles
5. Je peux cliquer sur un lien direct pour voir les différentes formules

### En tant qu'adhérent Cirque
Je veux recevoir une confirmation après tout achat de formule de cotisation
Afin de confirmer ma transaction

**Critères d'acceptation :**
1. Je reçois une confirmation immédiate après l'achat d'une nouvelle formule
2. La notification détaille le type de formule, son prix et sa durée de validité
3. Pour les cartes, la notification indique le nombre de séances disponibles
4. Pour les abonnements, la notification indique les dates de début et fin
5. La notification inclut un reçu de paiement au format PDF

## Notifications de présence

### En tant qu'adhérent Cirque
Je veux recevoir un récapitulatif de mes présences
Afin de suivre ma pratique

**Critères d'acceptation :**
1. Je peux recevoir un récapitulatif hebdomadaire de mes présences
2. Je peux recevoir un récapitulatif mensuel avec des statistiques
3. La notification inclut des comparaisons avec mes périodes précédentes
4. La notification inclut des suggestions basées sur mes habitudes
5. Je peux désactiver ces récapitulatifs si je ne les souhaite pas

### En tant que bénévole accueil
Je veux recevoir des rappels pour mes créneaux de permanence
Afin de ne pas oublier mes engagements

**Critères d'acceptation :**
1. Je reçois un rappel la veille de ma permanence
2. Je reçois un rappel 2 heures avant le début de ma permanence
3. La notification inclut les informations pratiques (horaires, lieu)
4. La notification inclut un contact en cas d'empêchement
5. Je peux confirmer ma présence directement depuis la notification

## Notifications administratives

### En tant qu'administrateur
Je veux pouvoir envoyer des notifications ciblées aux adhérents
Afin de communiquer des informations importantes

**Critères d'acceptation :**
1. Je peux sélectionner des destinataires selon différents critères (type d'adhésion, ancienneté, etc.)
2. Je peux créer un message personnalisé avec mise en forme
3. Je peux programmer l'envoi à une date future
4. Je peux suivre les taux d'ouverture et de clic
5. Je peux enregistrer des modèles pour réutilisation future

### En tant qu'administrateur
Je veux recevoir des alertes sur les événements importants du système
Afin de réagir rapidement aux situations critiques

**Critères d'acceptation :**
1. Je reçois une alerte en cas de pic inhabituel d'inscriptions
2. Je reçois une alerte en cas de problème technique détecté
3. Je reçois une notification quotidienne sur les statistiques clés
4. Je peux définir des seuils pour certaines alertes
5. Je peux déléguer certaines alertes à d'autres rôles spécifiques

## Rappels et événements

### En tant qu'adhérent
Je veux être informé des événements à venir de l'association
Afin de pouvoir y participer

**Critères d'acceptation :**
1. Je reçois une notification pour les nouveaux événements correspondant à mon profil
2. Je reçois un rappel 3 jours avant les événements auxquels je me suis inscrit
3. Je reçois un rappel le jour de l'événement
4. La notification inclut les informations pratiques (horaires, lieu, matériel)
5. Je peux ajouter l'événement à mon calendrier depuis la notification

### En tant qu'adhérent avec un rôle associatif
Je veux recevoir des rappels pour les réunions et tâches importantes
Afin de remplir mes responsabilités

**Critères d'acceptation :**
1. Je reçois des rappels pour les réunions du CA, commissions, etc.
2. Je reçois des alertes pour les tâches qui me sont assignées
3. Je reçois des rappels pour les échéances importantes liées à mon rôle
4. Je peux définir mes propres rappels pour des tâches spécifiques
5. Je peux marquer une tâche comme complétée directement depuis la notification

## Centre de notifications

### En tant qu'utilisateur
Je veux accéder à un centre de notifications centralisé
Afin de gérer toutes mes communications

**Critères d'acceptation :**
1. Je peux accéder à toutes mes notifications passées dans l'application
2. Je peux marquer des notifications comme lues/non lues
3. Je peux supprimer des notifications
4. Je peux filtrer les notifications par type et date
5. Je peux voir si une notification a déjà été consultée 