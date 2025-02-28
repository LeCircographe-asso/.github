# User Stories - Domaine Cotisation

Ce document contient les user stories relatives aux formules de cotisation permettant l'accès aux entraînements de cirque.

## Consulter les formules disponibles

### En tant qu'adhérent Cirque
Je veux voir les différentes formules de cotisation disponibles
Afin de choisir celle qui correspond le mieux à ma pratique

**Critères d'acceptation :**
1. Toutes les formules (séance unique, carte 10 séances, illimité mensuel, illimité annuel) sont clairement présentées
2. Les prix (tarifs normal et réduit) sont affichés pour chaque formule
3. Les conditions d'utilisation sont expliquées (validité, restrictions éventuelles)
4. Les conditions d'accès au tarif réduit sont précisées
5. Je comprends que je dois avoir une adhésion Cirque valide pour souscrire

## Séance unique

### En tant qu'adhérent Cirque
Je veux pouvoir acheter une séance unique
Afin de participer occasionnellement aux entraînements

**Critères d'acceptation :**
1. Je comprends que je dois me présenter physiquement pour l'achat
2. Je vois les tarifs applicables (6€ normal / 4€ réduit)
3. La séance est immédiatement utilisable après achat
4. Je comprends que la séance n'a pas de date d'expiration
5. Je peux voir mon historique d'achat de séances dans mon profil

## Carte 10 séances

### En tant qu'adhérent Cirque
Je veux pouvoir acheter une carte de 10 séances
Afin de bénéficier d'un tarif avantageux pour une pratique régulière

**Critères d'acceptation :**
1. Je comprends que je dois me présenter physiquement pour l'achat
2. Je vois les tarifs applicables (50€ normal / 35€ réduit)
3. Je vois que cela représente une réduction par rapport à 10 séances unitaires
4. La carte est immédiatement utilisable après achat
5. Je peux voir le nombre de séances restantes dans mon profil
6. Je comprends que les séances n'ont pas de date d'expiration

### En tant qu'adhérent Cirque avec une carte de séances
Je veux pouvoir consulter mon solde de séances
Afin de savoir combien il me reste de séances disponibles

**Critères d'acceptation :**
1. Le nombre de séances restantes est clairement visible dans mon profil
2. Je peux voir l'historique d'utilisation de mes séances
3. Je peux voir la date d'achat de ma carte
4. Je reçois une notification quand il ne me reste que 2 séances
5. Je vois une option pour acheter une nouvelle carte quand mon solde est bas

## Formule mensuelle illimitée

### En tant qu'adhérent Cirque
Je veux pouvoir souscrire à une formule mensuelle illimitée
Afin de pratiquer intensivement pendant un mois

**Critères d'acceptation :**
1. Je comprends que je dois me présenter physiquement pour la souscription
2. Je vois les tarifs applicables (40€ normal / 30€ réduit)
3. Je comprends la période de validité (30 jours à partir de la date d'achat)
4. Je vois la date de début et de fin de validité dans mon profil
5. Je comprends que je peux venir à tous les entraînements pendant cette période

### En tant qu'adhérent Cirque avec un abonnement mensuel
Je veux être informé de l'approche de la fin de validité
Afin de pouvoir renouveler à temps si je le souhaite

**Critères d'acceptation :**
1. Je reçois une notification 7 jours avant l'expiration
2. Je reçois un rappel 2 jours avant l'expiration
3. Je vois clairement la date d'expiration dans mon profil
4. Je comprends comment procéder au renouvellement
5. Je comprends que le renouvellement n'est pas automatique

## Formule annuelle illimitée

### En tant qu'adhérent Cirque
Je veux pouvoir souscrire à une formule annuelle illimitée
Afin de pratiquer toute l'année à tarif avantageux

**Critères d'acceptation :**
1. Je comprends que je dois me présenter physiquement pour la souscription
2. Je vois les tarifs applicables (350€ normal / 250€ réduit)
3. Je vois que cela représente une réduction par rapport à 12 mois d'abonnement mensuel
4. Je comprends la période de validité (365 jours à partir de la date d'achat)
5. Je vois la date de début et de fin de validité dans mon profil
6. Je comprends que je peux venir à tous les entraînements pendant cette période

### En tant qu'adhérent Cirque avec un abonnement annuel
Je veux être informé de l'approche de la fin de validité
Afin de pouvoir renouveler à temps si je le souhaite

**Critères d'acceptation :**
1. Je reçois une notification 1 mois avant l'expiration
2. Je reçois un rappel 1 semaine avant l'expiration
3. Je vois clairement la date d'expiration dans mon profil
4. Je comprends comment procéder au renouvellement
5. Je comprends que le renouvellement n'est pas automatique

## Gestion administrative

### En tant que bénévole à l'accueil
Je veux pouvoir enregistrer l'achat d'une formule de cotisation
Afin de permettre à un adhérent d'accéder aux entraînements

**Critères d'acceptation :**
1. Je peux rechercher l'adhérent par son nom ou email
2. Je peux vérifier qu'il possède bien une adhésion Cirque valide
3. Je peux sélectionner la formule souhaitée (séance unique, carte, mensuel, annuel)
4. Je peux appliquer le tarif réduit après vérification des justificatifs
5. Je peux enregistrer le paiement de la cotisation
6. Un reçu est généré pour l'adhérent
7. Le profil de l'adhérent est immédiatement mis à jour avec sa nouvelle formule

### En tant que bénévole à l'entraînement
Je veux pouvoir vérifier la validité de la cotisation d'un adhérent
Afin de contrôler son accès à l'entraînement

**Critères d'acceptation :**
1. Je peux rechercher rapidement l'adhérent
2. Je peux voir clairement s'il possède une cotisation valide
3. Je peux voir le type de cotisation (séance, carte, mensuel, annuel)
4. Pour les cartes, je peux voir le nombre de séances restantes
5. Pour les abonnements, je peux voir la date d'expiration
6. Je peux décrémenter une séance si l'adhérent utilise une carte

### En tant qu'administrateur
Je veux pouvoir consulter les statistiques des formules vendues
Afin d'analyser les préférences des adhérents

**Critères d'acceptation :**
1. Je peux voir le nombre de formules vendues par type
2. Je peux filtrer par période (jour, semaine, mois, année)
3. Je peux voir la répartition tarif normal / tarif réduit
4. Je peux voir les recettes générées par type de formule
5. Je peux exporter ces données au format CSV 