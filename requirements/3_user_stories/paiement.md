# User Stories - Domaine Paiement

Ce document contient les user stories relatives à la gestion des paiements, des reçus et des dons au sein de l'application Le Circographe.

## Gestion des paiements

### En tant qu'adhérent
Je veux voir l'historique de mes paiements
Afin de suivre mes transactions avec l'association

**Critères d'acceptation :**
1. Je peux voir la liste de tous mes paiements dans mon profil
2. Chaque paiement affiche le montant, la date et l'objet (adhésion, cotisation, etc.)
3. Je peux filtrer par type de paiement
4. Je peux filtrer par période
5. Je peux télécharger mes reçus pour chaque paiement

### En tant que bénévole à l'accueil
Je veux pouvoir enregistrer un paiement
Afin de valider l'achat d'un service par un adhérent

**Critères d'acceptation :**
1. Je peux sélectionner l'adhérent concerné
2. Je peux sélectionner l'objet du paiement (adhésion, cotisation, etc.)
3. Je peux sélectionner le mode de paiement (espèces, CB, chèque)
4. Le montant est automatiquement renseigné selon le service sélectionné
5. Je peux appliquer un tarif réduit si justifié
6. Le système génère automatiquement un reçu

### En tant que bénévole à l'accueil
Je veux pouvoir consulter l'historique des paiements récents
Afin de vérifier les transactions et faire le suivi de caisse

**Critères d'acceptation :**
1. Je peux voir la liste des paiements du jour
2. Je peux filtrer par date ou période
3. Je peux filtrer par type de paiement
4. Je peux voir les montants cumulés par mode de paiement
5. Je peux marquer des paiements comme vérifiés

## Reçus de paiement

### En tant qu'adhérent
Je veux recevoir un reçu pour chaque paiement effectué
Afin d'avoir une preuve de transaction

**Critères d'acceptation :**
1. Un reçu est automatiquement généré après chaque paiement validé
2. Le reçu contient les informations de l'association (nom, adresse, contact)
3. Le reçu détaille le service acheté, le montant et la date
4. Le reçu mentionne le mode de paiement utilisé
5. Je reçois le reçu par email et peux le télécharger depuis mon profil

### En tant qu'adhérent
Je veux pouvoir télécharger à nouveau mes anciens reçus
Afin de conserver mes justificatifs

**Critères d'acceptation :**
1. Je peux accéder à tous mes reçus depuis mon profil
2. Les reçus sont classés par date, du plus récent au plus ancien
3. Je peux filtrer par type de service
4. Je peux télécharger chaque reçu au format PDF
5. Je peux demander l'envoi d'un reçu par email

### En tant qu'administrateur
Je veux pouvoir générer un reçu manuellement
Afin de gérer les cas particuliers ou les problèmes techniques

**Critères d'acceptation :**
1. Je peux créer un reçu pour n'importe quel adhérent
2. Je peux spécifier l'objet, le montant et la date
3. Je peux indiquer le mode de paiement
4. Je peux ajouter des notes spécifiques
5. Je peux envoyer le reçu par email et/ou le télécharger

## Gestion des dons

### En tant qu'utilisateur
Je veux pouvoir faire un don à l'association
Afin de soutenir ses activités

**Critères d'acceptation :**
1. Je peux accéder à la page de don depuis la page d'accueil
2. Je peux choisir le montant de mon don librement
3. Je peux être informé sur l'utilisation des dons
4. Je comprends que le don est distinct de l'adhésion
5. Je peux faire un don même sans être adhérent

### En tant que donateur
Je veux recevoir un reçu fiscal pour mon don
Afin de bénéficier de la déduction fiscale

**Critères d'acceptation :**
1. Un reçu fiscal est automatiquement généré pour chaque don
2. Le reçu fiscal est conforme aux exigences légales
3. Le reçu indique clairement le statut de l'association et les modalités de déduction
4. Je reçois le reçu par email et peux le télécharger depuis mon profil
5. Je peux demander une copie de mon reçu fiscal à tout moment

### En tant qu'administrateur
Je veux pouvoir gérer les dons reçus
Afin de suivre les soutiens financiers à l'association

**Critères d'acceptation :**
1. Je peux voir la liste de tous les dons reçus
2. Je peux filtrer par période et par montant
3. Je peux voir les statistiques (montant total, moyenne, etc.)
4. Je peux générer des rapports pour la comptabilité
5. Je peux identifier les donateurs réguliers

## Modes de paiement

### En tant que bénévole à l'accueil
Je veux pouvoir accepter différents modes de paiement
Afin de faciliter les transactions pour les adhérents

**Critères d'acceptation :**
1. Je peux enregistrer un paiement en espèces
2. Je peux enregistrer un paiement par carte bancaire
3. Je peux enregistrer un paiement par chèque
4. Le système calcule automatiquement la monnaie à rendre pour les paiements en espèces
5. Je peux annuler ou modifier un paiement récent en cas d'erreur

### En tant qu'administrateur
Je veux accéder aux statistiques de paiement
Afin d'analyser les préférences de paiement et optimiser la gestion

**Critères d'acceptation :**
1. Je peux voir la répartition des paiements par mode
2. Je peux voir l'évolution des modes de paiement dans le temps
3. Je peux filtrer par période (jour, semaine, mois, année)
4. Je peux voir les montants totaux encaissés par mode de paiement
5. Je peux exporter ces données au format CSV

## Rapports financiers

### En tant qu'administrateur
Je veux pouvoir générer des rapports financiers
Afin de suivre les recettes et faciliter la comptabilité

**Critères d'acceptation :**
1. Je peux générer un rapport journalier des transactions
2. Je peux générer un rapport mensuel des recettes par catégorie
3. Je peux filtrer les rapports par type de service
4. Je peux exporter les rapports aux formats PDF et CSV
5. Les rapports incluent des graphiques de synthèse 