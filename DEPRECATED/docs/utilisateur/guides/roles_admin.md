# Guide Administrateur - Gestion des Rôles

## Introduction

Ce guide est destiné aux administrateurs du Circographe qui gèrent les rôles et permissions des utilisateurs. Il détaille les procédures pour attribuer, modifier et gérer les différents niveaux d'accès au système, ainsi que la gestion des bénévoles.

## Sommaire
1. [Comprendre les rôles système](#comprendre-les-rôles-système)
2. [Attribution et modification des rôles](#attribution-et-modification-des-rôles)
3. [Gestion des bénévoles](#gestion-des-bénévoles)
4. [Surveillance des permissions](#surveillance-des-permissions)
5. [Gestion des situations particulières](#gestion-des-situations-particulières)
6. [Rapports et audit](#rapports-et-audit)
7. [Résolution des problèmes courants](#résolution-des-problèmes-courants)

## Comprendre les rôles système

Le Circographe utilise une hiérarchie de rôles pour gérer les permissions :

1. **Membre** :
   - Rôle de base attribué automatiquement à tout adhérent
   - Permissions limitées à la gestion de son profil et l'utilisation des services
   - Aucun accès administratif
   
2. **Bénévole** :
   - Permissions administratives limitées
   - Accès aux fonctions d'accueil et de gestion quotidienne
   - Attribué par un Admin après formation
   
3. **Admin** :
   - Accès étendu à la plupart des fonctionnalités administratives
   - Capable de gérer les adhésions, cotisations, présences et événements
   - Peut attribuer le rôle Bénévole
   
4. **Super-Admin** :
   - Accès total au système
   - Capable de configurer l'application et gérer les autres administrateurs
   - Réservé aux responsables techniques de l'association

### Matrice des permissions

| Domaine fonctionnel | Membre | Bénévole | Admin | Super-Admin |
|---------------------|--------|----------|-------|------------|
| **Profil personnel** | Consultation, Modification | Complet | Complet | Complet |
| **Adhésions** | Consulter la sienne | Créer, Consulter, Valider | Gestion complète | Gestion complète |
| **Cotisations** | Consulter les siennes | Vendre, Consulter | Gestion complète | Gestion complète |
| **Présences** | Pointer sa présence | Gérer les listes, Valider entrées | Gestion complète | Gestion complète |
| **Paiements** | Consulter les siens | Encaisser, Générer reçus | Gestion complète, remboursements | Gestion complète |
| **Membres** | Aucun | Consultation | Gestion complète | Gestion complète |
| **Système** | Aucun | Aucun | Configuration partielle | Configuration complète |
| **Rôles** | Aucun | Aucun | Attribution (sauf Super-Admin) | Attribution complète |

## Attribution et modification des rôles

### Attribuer un rôle Bénévole

Pour promouvoir un membre au rôle de Bénévole :

1. **Vérification des prérequis** :
   - Vérifiez que le membre possède une adhésion valide
   - Confirmez qu'il a suivi la formation obligatoire
   - Assurez-vous qu'il a signé la charte des bénévoles

2. **Procédure d'attribution** :
   - Accédez à "Administration > Gestion des utilisateurs"
   - Recherchez le membre concerné
   - Ouvrez son profil et accédez à l'onglet "Rôles"
   - Sélectionnez "Modifier le rôle"
   - Choisissez "Bénévole" dans le menu déroulant
   - Indiquez la date de formation dans le champ dédié
   - Ajoutez un commentaire justifiant l'attribution
   - Cliquez sur "Enregistrer les modifications"

3. **Finalisation** :
   - Le système envoie automatiquement un email au membre
   - Programmez un premier créneau de permanence avec le nouveau bénévole
   - Assurez le suivi pendant la période d'essai (1 mois)

### Attribuer un rôle Admin

L'attribution du rôle Admin nécessite une validation par le bureau de l'association :

1. **Procédure préalable** :
   - Obtenez l'approbation du bureau (PV de réunion)
   - Vérifiez que la personne a exercé comme bénévole pendant au moins 3 mois

2. **Procédure technique** :
   - Seul un Super-Admin peut effectuer cette opération
   - Accédez à "Administration > Gestion des utilisateurs"
   - Suivez la même procédure que pour le rôle Bénévole
   - Joignez le numéro du PV de bureau autorisant l'attribution
   - Activez l'option "Formation Admin requise"

3. **Formation complémentaire** :
   - Programmez la session de formation Admin (3h)
   - Une fois la formation complétée, décochez "Formation requise"
   - Le système active alors toutes les permissions Admin

### Modifier ou révoquer un rôle

1. **Suspension temporaire** :
   - Accédez au profil de l'utilisateur
   - Onglet "Rôles" > "Suspendre temporairement"
   - Indiquez la durée et le motif de la suspension
   - Les permissions sont temporairement révoquées mais le rôle reste visible

2. **Rétrogradation** :
   - Pour passer d'Admin à Bénévole ou de Bénévole à Membre
   - Accédez au profil > "Rôles" > "Modifier le rôle"
   - Sélectionnez le nouveau rôle inférieur
   - Documentez soigneusement la raison du changement
   - Notifiez la personne concernée avant de procéder

3. **Révocation d'urgence** :
   - En cas de problème grave de sécurité
   - Utilisez "Révoquer immédiatement" dans l'onglet "Rôles"
   - Cette action nécessite une validation par un deuxième Admin
   - Un journal d'audit complet est généré automatiquement

## Gestion des bénévoles

### Suivi des permanences

1. **Planification** :
   - Accédez à "Bénévoles > Planning des permanences"
   - Consultez le calendrier des disponibilités
   - Assignez les créneaux en respectant l'engagement minimum (2 par mois)
   - Activez l'option "Notifier les bénévoles" pour envoyer le planning

2. **Suivi des présences** :
   - Vérifiez régulièrement "Bénévoles > Suivi des permanences"
   - Identifiez les permanences manquées ou en retard
   - Contactez les bénévoles en cas d'absences répétées
   - Utilisez le code couleur (vert/orange/rouge) pour visualiser l'assiduité

3. **Validation des heures** :
   - À la fin de chaque mois, validez les heures effectuées
   - Cliquez sur "Générer le rapport mensuel"
   - Vérifiez les anomalies signalées par le système
   - Validez le rapport pour archivage

### Formation des bénévoles

1. **Organisation des sessions** :
   - Programmez une session de formation mensuelle
   - Utilisez "Bénévoles > Programmer formation"
   - Définissez la date, l'heure, le lieu et le formateur
   - Envoyez les invitations aux membres intéressés

2. **Contenu de la formation** :
   - Utilisez le support standardisé disponible dans "Ressources"
   - Couvrez tous les modules obligatoires (accueil, paiements, présences)
   - Évaluez la compréhension via le questionnaire intégré
   - Remplissez la fiche d'évaluation pour chaque participant

3. **Validation** :
   - Après formation réussie, mettez à jour le statut dans le profil
   - Accédez à "Utilisateur > Formation" et cochez "Formation complétée"
   - Définissez la période de tutorat (généralement 2 semaines)
   - Assignez un tuteur expérimenté pour les premières permanences

### Réunions et communication

1. **Réunions trimestrielles** :
   - Utilisez "Bénévoles > Programmer réunion" pour l'organisation
   - Envoyez l'invitation et l'ordre du jour au moins 2 semaines avant
   - Activez le système de confirmation de présence
   - Enregistrez les minutes de réunion dans l'application

2. **Communication quotidienne** :
   - Vérifiez régulièrement les messages dans "Communication > Forum bénévoles"
   - Répondez aux questions dans un délai maximum de 24h
   - Utilisez "Annonces" pour les informations importantes
   - Catégorisez correctement les messages pour faciliter la recherche

## Surveillance des permissions

### Audit des accès

1. **Vérification régulière** :
   - Consultez mensuellement "Administration > Audit des accès"
   - Vérifiez les utilisateurs avec des permissions élevées
   - Contrôlez que les accès correspondent aux rôles officiels
   - Identifiez les comptes inactifs avec des permissions élevées

2. **Revue des activités sensibles** :
   - Accédez à "Administration > Journal d'activité"
   - Filtrez par "Actions sensibles"
   - Vérifiez les modifications de configuration
   - Contrôlez les transactions financières importantes

3. **Tests d'intrusion** :
   - Trimestriellement, effectuez des tests de permission
   - Utilisez "Administration > Test de sécurité"
   - Vérifiez qu'aucun rôle n'a accès à des fonctions non autorisées
   - Documentez les résultats et corrigez les anomalies

### Gestion des accès temporaires

1. **Attribution** :
   - Pour les besoins exceptionnels (événements, etc.)
   - Utilisez "Administration > Accès temporaire"
   - Définissez précisément la durée et les permissions
   - Activez l'option "Expiration automatique"

2. **Suivi** :
   - Consultez "Administration > Accès temporaires actifs"
   - Vérifiez régulièrement la pertinence des accès
   - Révoquez manuellement les accès qui ne sont plus nécessaires
   - Un rapport hebdomadaire des accès temporaires est généré automatiquement

## Gestion des situations particulières

### Utilisateurs avec rôle système mais sans adhésion valide

1. **Détection** :
   - Consultez le rapport "Rôles > Incohérences"
   - Identifiez les utilisateurs dont l'adhésion a expiré
   - Le système applique automatiquement une suspension temporaire

2. **Résolution** :
   - Contactez l'utilisateur pour l'inviter à renouveler son adhésion
   - Si renouvellement dans les 30 jours : les permissions sont restaurées
   - Si pas de renouvellement après 60 jours : proposez la rétrogradation

### Conflits d'intérêts

1. **Identification** :
   - Soyez attentif aux situations où un utilisateur ne devrait pas avoir accès
   - Exemple : accès aux données financières d'un proche
   - Utilisez "Administration > Déclarer conflit" pour signaler

2. **Gestion** :
   - Configurez des restrictions d'accès spécifiques
   - Accédez à "Utilisateur > Restrictions spéciales"
   - Définissez les dossiers ou fonctions concernées
   - Activez la journalisation renforcée pour ces situations

### Gestion des départs

Lorsqu'un bénévole ou administrateur quitte ses fonctions :

1. **Procédure administrative** :
   - Documentez le départ dans "Bénévoles > Gestion des départs"
   - Organisez un entretien de passation si possible
   - Récupérez tout matériel confié (badge, clés, etc.)

2. **Procédure technique** :
   - Révoquez les permissions en suivant la procédure standard
   - Vérifiez qu'aucune tâche n'est restée assignée à cette personne
   - Réattribuez les responsabilités permanentes à d'autres utilisateurs

## Rapports et audit

### Rapports disponibles

Les rapports suivants sont accessibles dans "Administration > Rapports" :

- **Matrice des rôles** : Vue d'ensemble de tous les utilisateurs et leurs rôles
- **Journal des modifications** : Historique des changements de rôles
- **Activité par rôle** : Analyse de l'utilisation des permissions
- **Bénévoles actifs** : Liste et statistiques des bénévoles
- **Audit de sécurité** : Vérification des permissions sensibles

### Procédure d'audit interne

1. **Préparation** :
   - Programmez un audit trimestriel
   - Utilisez "Administration > Préparer audit"
   - Générez les rapports préliminaires

2. **Réalisation** :
   - Vérifiez la correspondance entre rôles officiels et techniques
   - Contrôlez l'application des procédures d'attribution
   - Échantillonnez et vérifiez les logs d'actions sensibles
   - Documentez les écarts constatés

3. **Suivi** :
   - Créez un plan d'action pour les anomalies
   - Assignez des responsables pour chaque correction
   - Programmez une vérification de suivi

## Résolution des problèmes courants

### Permissions manquantes

1. **Diagnostic** :
   - Demandez à l'utilisateur de décrire précisément le problème
   - Vérifiez son rôle actuel dans "Utilisateurs > Profil"
   - Consultez la matrice des permissions pour confirmer les droits

2. **Résolution** :
   - Si le rôle devrait inclure cette permission : contactez un Super-Admin
   - Si l'utilisateur a besoin d'un rôle supérieur : suivez la procédure d'attribution
   - Si c'est un problème technique : créez un ticket "Support technique"

### Problèmes d'accès après attribution d'un rôle

1. **Vérification immédiate** :
   - Demandez à l'utilisateur de se déconnecter et se reconnecter
   - Vérifiez que le changement est bien enregistré dans le système
   - Contrôlez l'absence de restrictions spéciales

2. **Actions correctives** :
   - Si le problème persiste, utilisez "Rôles > Synchroniser permissions"
   - Si nécessaire, révoquez puis réattribuez le rôle
   - En dernier recours, contactez le support technique

### Conflits entre rôles multiples

Si un utilisateur semble avoir des comportements de plusieurs rôles :

1. **Analyse** :
   - Vérifiez qu'un seul rôle est attribué dans "Utilisateur > Rôles"
   - Contrôlez l'historique des attributions récentes
   - Vérifiez l'absence de rôle temporaire

2. **Correction** :
   - Utilisez "Rôles > Réinitialiser permissions"
   - Réattribuez clairement le rôle principal
   - Documentez l'incident pour le support technique

---

Pour toute question non couverte par ce guide, contactez l'équipe d'administration système à admin-system@lecircographe.fr 