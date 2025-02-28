# User Stories - Domaine Présence

Ce document contient les user stories relatives à la gestion des présences aux entraînements et aux statistiques de fréquentation.

## Pointage aux entraînements

### En tant qu'adhérent Cirque
Je veux pouvoir consulter les créneaux d'entraînement disponibles
Afin de planifier ma venue

**Critères d'acceptation :**
1. Je peux voir la liste des créneaux hebdomadaires (jours et horaires)
2. Je peux voir les informations spécifiques à chaque créneau (thématique, niveau)
3. Je peux être informé des créneaux exceptionnellement fermés
4. Je peux voir le taux d'affluence habituel par créneau
5. Je comprends que je dois avoir une cotisation valide pour participer

### En tant qu'adhérent Cirque
Je veux pouvoir consulter mon historique de présence
Afin de suivre ma pratique

**Critères d'acceptation :**
1. Je peux voir la liste de toutes mes présences aux entraînements
2. Chaque entrée affiche la date, l'heure et le type de créneau
3. Je peux filtrer par période (semaine, mois, année)
4. Je peux voir des statistiques sur ma fréquentation (jours préférés, régularité)
5. Je peux exporter mon historique au format CSV

### En tant que bénévole responsable de l'accueil
Je veux pouvoir pointer la présence des adhérents
Afin de contrôler l'accès aux entraînements

**Critères d'acceptation :**
1. Je peux rechercher rapidement un adhérent par son nom ou email
2. Je peux voir immédiatement si l'adhérent a une cotisation valide
3. Je peux voir le type de cotisation (séance, carte, mensuel, annuel)
4. Je peux décrémenter une séance si l'adhérent utilise une carte
5. Je peux enregistrer la présence avec un simple clic
6. Le système refuse l'accès aux adhérents sans cotisation valide

### En tant que bénévole responsable de l'accueil
Je veux pouvoir consulter la liste des présents du jour
Afin de suivre les entrées et gérer la sécurité

**Critères d'acceptation :**
1. Je peux voir la liste en temps réel des adhérents présents
2. Je peux voir l'heure d'arrivée de chaque adhérent
3. Je peux effectuer un comptage rapide du nombre de présents
4. Je peux marquer le départ d'un adhérent si nécessaire
5. Je peux filtrer la liste par heure d'arrivée

## Gestion des listes de présence

### En tant que bénévole responsable de l'accueil
Je veux pouvoir gérer les cas particuliers de présence
Afin d'assurer le bon fonctionnement des entraînements

**Critères d'acceptation :**
1. Je peux ajouter un invité exceptionnel (avec nom et statut)
2. Je peux noter les présences d'adhérents ayant oublié leur carte
3. Je peux gérer les séances d'essai (première visite gratuite)
4. Je peux enregistrer un paiement direct pour une séance
5. Je peux ajouter des notes sur des situations particulières

### En tant que bénévole responsable de l'accueil
Je veux pouvoir générer la liste d'émargement quotidienne
Afin de conserver une trace physique des présences

**Critères d'acceptation :**
1. Je peux générer une liste à tout moment de la journée
2. La liste inclut tous les présents avec leur nom et heure d'arrivée
3. La liste inclut un espace pour la signature de chaque adhérent
4. Je peux imprimer cette liste au format PDF
5. La liste est automatiquement archivée en fin de journée

### En tant qu'administrateur
Je veux pouvoir consulter les archives des listes de présence
Afin de répondre aux exigences légales et de sécurité

**Critères d'acceptation :**
1. Je peux consulter les listes de présence de n'importe quelle date passée
2. Je peux rechercher par date ou par période
3. Je peux filtrer par créneau horaire
4. Je peux identifier rapidement les périodes de forte affluence
5. Je peux exporter les archives au format CSV

## Statistiques de fréquentation

### En tant qu'adhérent Cirque
Je veux voir des statistiques personnelles sur ma pratique
Afin de suivre mon assiduité

**Critères d'acceptation :**
1. Je peux voir le nombre total de mes présences
2. Je peux voir ma fréquence moyenne (par semaine/mois)
3. Je peux voir une visualisation de mes jours de pratique préférés
4. Je peux comparer ma fréquentation actuelle à mes périodes précédentes
5. Je peux voir des suggestions basées sur mon profil de fréquentation

### En tant qu'administrateur
Je veux accéder aux statistiques de fréquentation
Afin d'optimiser l'offre d'entraînements

**Critères d'acceptation :**
1. Je peux voir la fréquentation moyenne par créneau
2. Je peux voir l'évolution de la fréquentation dans le temps
3. Je peux identifier les pics et creux de fréquentation
4. Je peux filtrer par période (jour, semaine, mois, année)
5. Je peux exporter les statistiques aux formats CSV et PDF
6. Je peux voir la répartition des adhérents par type de cotisation

### En tant qu'administrateur
Je veux pouvoir générer des rapports de fréquentation
Afin de suivre l'activité de l'association

**Critères d'acceptation :**
1. Je peux générer un rapport mensuel de fréquentation
2. Je peux générer un rapport annuel avec comparaison à l'année précédente
3. Le rapport inclut des graphiques de tendance
4. Le rapport affiche des indicateurs clés (moyenne, maximum, croissance)
5. Je peux paramétrer le contenu du rapport selon mes besoins

## Gestion de la capacité

### En tant que bénévole responsable de l'accueil
Je veux pouvoir suivre le nombre de présents en temps réel
Afin de respecter la capacité maximale de la salle

**Critères d'acceptation :**
1. Je vois en permanence le nombre actuel de personnes présentes
2. Je vois la capacité maximale autorisée
3. Je reçois une alerte visuelle quand le nombre approche de la limite
4. Je peux consulter rapidement l'historique récent pour estimer les arrivées
5. Le système refuse automatiquement les entrées au-delà de la capacité maximale

### En tant qu'administrateur
Je veux gérer les capacités maximales des différents créneaux
Afin d'assurer la sécurité et le confort des pratiquants

**Critères d'acceptation :**
1. Je peux définir une capacité maximale différente pour chaque créneau
2. Je peux modifier temporairement une capacité (travaux, événement)
3. Je peux programmer des changements de capacité à l'avance
4. Le système applique automatiquement les limites de capacité
5. Je reçois des notifications quand un créneau atteint régulièrement sa capacité 