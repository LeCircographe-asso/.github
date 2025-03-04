# Guide Administrateur - Gestion des Cotisations

## Introduction

Ce guide est destiné aux bénévoles et administrateurs du Circographe qui gèrent les cotisations des membres. Il détaille les procédures pour vendre, vérifier, et administrer les différentes formules de cotisation.

## Sommaire
1. [Vérification des prérequis](#vérification-des-prérequis)
2. [Vente des cotisations](#vente-des-cotisations)
3. [Gestion des entrées](#gestion-des-entrées)
4. [Administration des cotisations](#administration-des-cotisations)
5. [Rapports et statistiques](#rapports-et-statistiques)
6. [Résolution des problèmes courants](#résolution-des-problèmes-courants)

## Vérification des prérequis

Avant de vendre une cotisation, vous devez systématiquement :

1. **Vérifier l'adhésion du membre** :
   - Recherchez le membre dans le système par son nom ou scannez sa carte
   - Confirmez que l'adhésion est de type "Cirque" (pas "Basic")
   - Vérifiez que l'adhésion est en cours de validité

![Interface de vérification d'adhésion](../images/admin_verification_adhesion.png)

> **Important** : Une adhésion Basic (1€) ne permet pas d'acheter une cotisation. Le membre doit d'abord faire évoluer son adhésion vers Cirque (10€ ou 7€ tarif réduit).

### Procédure d'évolution d'adhésion Basic vers Cirque

Si un membre avec une adhésion Basic souhaite acheter une cotisation :

1. Allez dans "Adhésions > Modifier"
2. Sélectionnez le membre concerné
3. Cliquez sur "Faire évoluer vers Cirque"
4. Appliquez le tarif standard (10€) ou réduit (7€) selon la situation
5. Procédez au paiement de la différence
6. Validez l'évolution qui sera immédiatement effective

## Vente des cotisations

### Processus de vente standard

1. **Accédez au module de vente** :
   - Menu "Cotisations > Nouvelle vente"
   - Ou utilisez le raccourci "Ctrl+N" depuis l'écran d'accueil

2. **Sélection du membre** :
   - Recherchez par nom, prénom ou numéro d'adhérent
   - Vérifiez que l'adhésion Cirque est valide (indicateur vert)

3. **Choix de la formule** :
   - Sélectionnez parmi les options disponibles :
     - Pass Journée (4€)
     - Carnet 10 Séances (30€)
     - Abonnement Trimestriel (65€)
     - Abonnement Annuel (150€)

4. **Application des tarifs** :
   - Les tarifs sont fixes et non négociables
   - Aucune réduction n'est prévue sur les cotisations

5. **Paiement** :
   - Sélectionnez le mode de paiement (espèces, CB, chèque)
   - Pour les montants supérieurs à 50€, proposez le paiement en 3 fois
   - Si paiement en plusieurs fois, suivez la procédure "Paiement échelonné"

6. **Validation et émission du reçu** :
   - Validez la transaction
   - Imprimez le reçu ou envoyez-le par email selon préférence du membre
   - La cotisation est immédiatement active dans le système

![Interface de vente de cotisations](../images/admin_vente_cotisation.png)

### Cas particulier : Paiement échelonné

Pour les abonnements trimestriels et annuels, le paiement en plusieurs fois est possible :

1. Dans l'écran de paiement, cliquez sur "Paiement échelonné"
2. Sélectionnez le nombre de mensualités (2 ou 3)
3. Le système calculera automatiquement les montants et dates
4. Recueillez tous les chèques à l'avance avec dates d'encaissement
5. Notez les dates d'encaissement au dos des chèques
6. Enregistrez chaque chèque dans le système avec sa date d'encaissement
7. Imprimez le contrat de paiement échelonné en 2 exemplaires
8. Faites signer les deux exemplaires par le membre
9. Remettez un exemplaire au membre et conservez l'autre

> **Note** : La cotisation est active immédiatement, même si le paiement est échelonné.

## Gestion des entrées

### Enregistrement d'une entrée

Lorsqu'un membre se présente à l'entraînement :

1. **Accueil du membre** :
   - Demandez le nom ou scannez la carte membre
   - Vérifiez l'identité si nécessaire

2. **Vérification des cotisations** :
   - Accédez à la fiche "Cotisations actives" du membre
   - Le système affiche automatiquement les cotisations valides

3. **Enregistrement** :
   - Cliquez sur "Enregistrer une entrée"
   - Le système sélectionne automatiquement la cotisation prioritaire
   - Vous pouvez changer manuellement si le membre a une préférence

4. **Confirmation** :
   - Informez le membre du type de cotisation utilisé et du solde restant
   - Pour les abonnements, rappelez la date d'expiration
   - Pour les carnets, indiquez le nombre d'entrées restantes

![Interface d'enregistrement d'entrée](../images/admin_entree_cotisation.png)

### Ordre de priorité des cotisations

Le système utilise automatiquement cet ordre de priorité :

1. Abonnements (Trimestriel ou Annuel) en cours de validité
2. Carnet de séances avec entrées disponibles
3. Pass Journée

> **Note** : Vous pouvez modifier cette priorité manuellement lors de l'enregistrement si le membre le souhaite.

### Annulation d'une entrée

En cas d'erreur d'enregistrement :

1. Accédez à l'historique des entrées du jour
2. Localisez l'entrée à annuler
3. Cliquez sur "Annuler l'entrée"
4. Saisissez le motif d'annulation
5. Confirmez l'opération
6. L'entrée est restaurée sur le compte du membre

> **Important** : Seuls les administrateurs peuvent annuler une entrée enregistrée depuis plus de 24h.

## Administration des cotisations

### Consultation du compte d'un membre

Pour voir toutes les cotisations d'un membre :

1. Recherchez le membre dans le système
2. Accédez à l'onglet "Cotisations"
3. Vous verrez ses cotisations actives, en attente et expirées
4. Vous pourrez consulter l'historique complet des entrées

### Modifications administratives

#### Ajout manuel d'entrées sur un carnet

Dans certains cas exceptionnels (compensation, erreur système) :

1. Accédez à la fiche du membre
2. Sélectionnez le carnet concerné
3. Cliquez sur "Modifier le solde"
4. Ajoutez le nombre d'entrées à créditer
5. Indiquez impérativement le motif de l'ajout
6. Validez l'opération
7. L'action sera enregistrée dans l'historique administratif

#### Prolongation d'abonnement

Pour des cas particuliers (fermeture exceptionnelle, absence justifiée) :

1. Accédez à la fiche du membre
2. Sélectionnez l'abonnement concerné
3. Cliquez sur "Prolonger l'abonnement"
4. Indiquez le nombre de jours d'extension
5. Saisissez le motif détaillé de la prolongation
6. Validez l'opération
7. Un email de confirmation sera envoyé au membre

> **Attention** : Ces opérations sont réservées aux administrateurs et sont systématiquement tracées.

### Annulation d'une cotisation

Dans de rares cas (erreur de vente, insatisfaction) :

1. Accédez à la cotisation concernée
2. Cliquez sur "Annuler la cotisation"
3. Sélectionnez le motif d'annulation
4. Précisez si un remboursement doit être effectué
5. Si remboursement, indiquez le mode de remboursement
6. Validez l'annulation
7. Éditez le document de remboursement si nécessaire

> **Important** : 
> - L'annulation d'une cotisation active avec des entrées déjà utilisées nécessite une validation par un administrateur.
> - Le remboursement se fait au prorata des entrées non utilisées ou de la période restante.

## Rapports et statistiques

### Rapports quotidiens

À la fin de chaque journée, imprimez ou consultez :

1. **Récapitulatif des ventes** :
   - Menu "Rapports > Ventes du jour"
   - Vérifiez la concordance avec la caisse

2. **Journal des entrées** :
   - Menu "Rapports > Entrées du jour"
   - Utile pour vérifier la fréquentation

### Rapports mensuels

À la fin de chaque mois, les administrateurs doivent :

1. Générer le rapport mensuel ("Rapports > Synthèse mensuelle")
2. Vérifier les indicateurs clés :
   - Nombre de cotisations vendues par type
   - Montant total des ventes
   - Fréquentation journalière moyenne
   - Taux d'utilisation des différentes formules

### Alertes de gestion

Le système génère automatiquement des alertes pour :

- Abonnements arrivant à expiration (pour relance)
- Carnets avec peu d'entrées restantes (pour proposition de renouvellement)
- Membres sans activité depuis plus de 2 mois

## Résolution des problèmes courants

### Membre ne trouve pas sa carte

1. Recherchez par nom et vérifiez avec une pièce d'identité
2. Utilisez la photo du membre si disponible dans le système
3. En cas de doute, contactez un administrateur

### Cotisation visible par le membre mais pas par le système

1. Demandez un justificatif d'achat (reçu, email de confirmation)
2. Vérifiez dans l'historique des transactions
3. Si la cotisation est confirmée mais invisible :
   - Allez dans "Maintenance > Synchronisation des cotisations"
   - Lancez une synchronisation pour le membre concerné

### Désaccord sur le nombre d'entrées restantes

1. Consultez l'historique détaillé des entrées avec le membre
2. Vérifiez les dates et heures de passage
3. En cas d'erreur avérée, ajustez le solde (administrateur uniquement)
4. Documentez précisément l'incident et la résolution

### Problèmes de paiement échelonné

1. Consultez le contrat de paiement échelonné
2. Vérifiez les dates d'encaissement prévues
3. Contactez le membre en cas de rejet de paiement
4. Proposez une solution alternative de règlement

## Formation des nouveaux bénévoles

Pour former un nouveau bénévole à la gestion des cotisations :

1. Présentez ce guide et passez en revue les principales fonctionnalités
2. Faites une démonstration des opérations courantes
3. Supervisez les 5 premières ventes et enregistrements d'entrées
4. Restez disponible pour répondre aux questions

---

Document à usage interne - Version 1.0 