# Le Circographe - Architecture Technique

## 1. Modèles Principaux

### Utilisateur & Rôles
- Entité utilisateur de base
- Support de rôles multiples
- Suivi des adhésions
- Gestion des cotisations

### Système d'Adhésion
- Adhésion Simple (1€/an)
  - Accès à l'espace et aux événements
  - Pas de prérequis
  - Possibilité d'upgrade vers Cirque

- Adhésion Cirque (10€/7€ an)
  - Nécessite une adhésion simple valide
  - Permet l'achat de cotisations
  - Options de tarif réduit

### Cotisations
- Pass Journée (4€)
- Carnet 10 Séances (30€)
- Trimestriel (65€)
- Annuel (150€)

## 2. Logique Métier

### Gestion des Adhésions

1. **Règles d'Adhésion**
   - Une seule adhésion active par type
   - L'adhésion cirque est requise pour la pratique
   - Les adhésions sont valables un an
   - Possibilité de faire un don lors de l'adhésion

2. **Renouvellement**
   - Possible avant expiration
   - Conserve l'historique
   - Mise à jour automatique du statut

### Gestion des Abonnements

1. **Hiérarchie des Priorités**
   ```
   Journée (0) < Pack 10 (1) < Trimestre (2) < Année (3)
   ```

2. **Règles de Compatibilité**
   - Pas de pass journée avec abonnement actif
   - Un seul abonnement actif à la fois
   - Possibilité de renouveler avant expiration

### Gestion des Présences

1. **Types de Présence**
   - Regular (pratiquant)
   - Visitor (visiteur)
   - Staff (bénévole/admin)

2. **Règles de Présence**
   - Une seule présence par jour par personne
   - Vérification des adhésions/abonnements
   - Décompte automatique pour les carnets
   - Enregistrement uniquement pendant les sessions ouvertes

### Statistiques

1. **Périodes**
   - Journalières
   - Hebdomadaires
   - Mensuelles
   - Annuelles

2. **Métriques**
   - Total des visites
   - Visiteurs uniques
   - Nombre de visiteurs vs pratiquants
   - Heures de pointe
   - Taux d'occupation

## 3. User Stories

### Visiteurs
- En tant que visiteur, je peux créer un compte
- En tant que visiteur, je peux acheter une adhésion simple
- En tant que visiteur, je peux m'inscrire aux événements

### Membres
- En tant que membre simple, je peux upgrader vers une adhésion cirque
- En tant que membre cirque, je peux acheter des abonnements
- En tant que membre cirque, je peux consulter mon historique de présences
- En tant que membre, je peux faire un don lors de mes paiements

### Bénévoles
- En tant que bénévole, je peux enregistrer les présences
- En tant que bénévole, je peux gérer les adhésions
- En tant que bénévole, je peux vérifier les abonnements
- En tant que bénévole, je conserve mes droits de membre

### Administrateurs
- En tant qu'admin, je peux gérer les utilisateurs
- En tant qu'admin, je peux consulter les statistiques
- En tant qu'admin, je peux gérer les événements
- En tant qu'admin, je peux modifier les types d'abonnement

## 4. Points d'Attention

### Sécurité
- Validation des rôles pour chaque action
- Protection des données personnelles
- Gestion sécurisée des paiements

### Performance
- Indexation des champs de recherche fréquents
- Optimisation des requêtes statistiques
- Gestion efficace des sessions

### Maintenance
- Historisation des modifications
- Traçabilité des paiements
- Sauvegarde des données

## 5. Évolutions Possibles

1. **Fonctionnalités**
   - Système de réservation
   - Gestion des cours
   - Carte de membre numérique
   - Application mobile

2. **Améliorations**
   - Interface de reporting
   - Automatisation des renouvellements
   - Système de notification
   - Intégration de paiements en ligne

3. **Technique**
   - API REST
   - Tests automatisés
   - CI/CD
   - Monitoring 