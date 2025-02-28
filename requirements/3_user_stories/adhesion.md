# User Stories - Domaine Adhésion

Ce document contient les user stories relatives à la gestion des adhésions (Basic et Cirque) au sein de l'application Le Circographe.

## Consulter les types d'adhésion

### En tant qu'utilisateur
Je veux voir les types d'adhésion disponibles
Afin de comprendre les offres de l'association et choisir celle qui me convient

**Critères d'acceptation :**
1. Les deux types d'adhésion (Basic et Cirque) sont clairement présentés
2. Les prix (1€ pour Basic, 10€/7€ pour Cirque) sont affichés
3. Les avantages de chaque type d'adhésion sont listés
4. Les conditions d'accès au tarif réduit sont expliquées
5. La durée de validité (1 an) est indiquée

## Adhésion Basic

### En tant qu'utilisateur avec un compte
Je veux pouvoir souscrire une adhésion Basic
Afin de devenir membre de l'association

**Critères d'acceptation :**
1. Je dois être connecté pour accéder au processus d'adhésion
2. Je comprends que je dois me présenter physiquement pour finaliser l'adhésion
3. Je peux voir le tarif applicable (1€)
4. Je reçois les informations sur les documents à apporter
5. Mon profil reste "utilisateur sans adhésion" jusqu'à validation sur place

### En tant qu'adhérent Basic
Je veux voir mon statut d'adhésion dans mon profil
Afin de connaître mes droits et la validité de mon adhésion

**Critères d'acceptation :**
1. Mon profil affiche clairement "Adhérent Basic"
2. Je vois la date de début de mon adhésion
3. Je vois la date de fin de mon adhésion
4. Je comprends les droits associés à mon statut
5. Je peux voir l'historique de mes adhésions passées

## Adhésion Cirque

### En tant qu'utilisateur avec un compte
Je veux pouvoir souscrire une adhésion Cirque
Afin d'accéder aux entraînements

**Critères d'acceptation :**
1. Je dois être connecté pour accéder au processus d'adhésion
2. Je comprends que je dois me présenter physiquement pour finaliser l'adhésion
3. Je peux voir les tarifs applicables (normal 10€ / réduit 7€)
4. Je reçois les informations sur les justificatifs à apporter pour le tarif réduit
5. Mon profil reste "utilisateur sans adhésion" jusqu'à validation sur place

### En tant qu'adhérent Cirque
Je veux voir mon statut d'adhésion dans mon profil
Afin de connaître mes droits et la validité de mon adhésion

**Critères d'acceptation :**
1. Mon profil affiche clairement "Adhérent Cirque"
2. Je vois la date de début de mon adhésion
3. Je vois la date de fin de mon adhésion
4. Je comprends les droits associés à mon statut
5. Je peux voir l'historique de mes adhésions passées

## Upgrade d'adhésion

### En tant qu'adhérent Basic
Je veux pouvoir upgrader vers une adhésion Cirque
Afin d'accéder aux entraînements

**Critères d'acceptation :**
1. L'option d'upgrade est clairement visible dans mon profil
2. Je comprends que je dois me présenter physiquement pour l'upgrade
3. Je vois le tarif applicable pour l'upgrade (9€ normal / 6€ réduit)
4. Je comprends que la date de fin reste inchangée
5. Je reçois les informations sur les justificatifs à apporter pour le tarif réduit

## Renouvellement d'adhésion

### En tant qu'adhérent (Basic ou Cirque) avec adhésion expirant prochainement
Je veux être notifié de l'expiration prochaine de mon adhésion
Afin de pouvoir la renouveler à temps

**Critères d'acceptation :**
1. Je reçois une notification 1 mois avant l'expiration
2. Je reçois un rappel 1 semaine avant l'expiration
3. La notification m'indique comment procéder au renouvellement
4. Je comprends que je dois me présenter physiquement pour le renouvellement
5. Les tarifs de renouvellement sont clairement indiqués

### En tant qu'adhérent avec adhésion expirée
Je veux pouvoir renouveler mon adhésion
Afin de continuer à bénéficier des avantages de membre

**Critères d'acceptation :**
1. Mon profil indique clairement que mon adhésion est expirée
2. Je comprends que je dois me présenter physiquement pour le renouvellement
3. Je vois les tarifs applicables pour le renouvellement
4. Je reçois les informations sur les justificatifs à apporter pour le tarif réduit
5. Après renouvellement, la nouvelle date d'expiration est calculée à partir de la date de renouvellement

## Gestion administrative

### En tant que bénévole à l'accueil
Je veux pouvoir enregistrer une nouvelle adhésion
Afin d'accueillir un nouveau membre

**Critères d'acceptation :**
1. Je peux rechercher l'utilisateur par son nom ou email
2. Je peux sélectionner le type d'adhésion (Basic ou Cirque)
3. Je peux appliquer le tarif réduit après vérification des justificatifs
4. Je peux enregistrer le paiement de l'adhésion
5. Un reçu d'adhésion est généré pour le membre
6. Le statut du membre est immédiatement mis à jour

### En tant que bénévole à l'accueil
Je veux pouvoir enregistrer un upgrade d'adhésion
Afin de permettre à un membre Basic d'accéder aux entraînements

**Critères d'acceptation :**
1. Je peux rechercher l'adhérent Basic par son nom ou email
2. Je peux vérifier la validité de son adhésion actuelle
3. Je peux appliquer le tarif réduit après vérification des justificatifs
4. Je peux enregistrer le paiement de l'upgrade
5. Un reçu d'upgrade est généré pour le membre
6. Le statut du membre est immédiatement mis à jour en "Adhérent Cirque"
7. La date de fin d'adhésion reste inchangée

### En tant qu'administrateur
Je veux pouvoir consulter la liste des adhérents
Afin de suivre l'évolution des adhésions

**Critères d'acceptation :**
1. Je peux filtrer par type d'adhésion (Basic/Cirque)
2. Je peux filtrer par statut (actif/expiré)
3. Je peux voir les statistiques d'adhésion (nouvelles, renouvellements, upgrades)
4. Je peux exporter la liste au format CSV
5. Je peux consulter l'historique des adhésions d'un membre spécifique 