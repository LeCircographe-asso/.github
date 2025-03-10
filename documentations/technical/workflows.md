# Workflows de développement

## Processus de développement

### Création d'une nouvelle fonctionnalité

1. Créer une branche à partir de `develop`:
   ```bash
   git checkout develop
   git pull
   git checkout -b feature/nom-de-la-fonctionnalite
   ```

2. Implémenter la fonctionnalité avec TDD:
   ```bash
   # Écrire les tests d'abord
   rspec spec/models/nouveau_modele_spec.rb
   
   # Implémenter la fonctionnalité
   # ...
   
   # Vérifier que les tests passent
   rspec
   ```

3. Soumettre une pull request vers `develop`
   - Utiliser le modèle de PR fourni
   - S'assurer que tous les tests passent
   - S'assurer que le code respecte les normes de style
   - Demander une revue de code à au moins un autre développeur

## Cycle de vie des branches

### Branches principales

- `main` : Branche de production, contient le code actuellement en production
- `staging` : Branche de préproduction, utilisée pour les tests finaux avant production
- `develop` : Branche principale de développement, intègre toutes les fonctionnalités terminées

### Branches temporaires

- `feature/*` : Nouvelles fonctionnalités
- `bugfix/*` : Corrections de bugs
- `hotfix/*` : Corrections urgentes à appliquer en production
- `release/*` : Préparation d'une nouvelle version de l'application

## Processus de déploiement

Le déploiement suit un workflow GitOps:

1. Les PR validées sont fusionnées dans `develop`
2. Les tests automatisés sont exécutés sur `develop`
3. Après validation, `develop` est fusionné dans `staging` pour les tests d'intégration
4. Après validation en staging, `staging` est fusionné dans `main` pour le déploiement en production

### Environnements de déploiement

| Environnement | Branche | URL | Utilisation |
|---------------|---------|-----|------------|
| Développement | `develop` | dev.circographe.org | Tests en cours de développement |
| Staging | `staging` | staging.circographe.org | Tests d'intégration et recette |
| Production | `main` | circographe.org | Environnement de production |

## Intégration continue (CI)

Le projet utilise GitHub Actions pour l'intégration continue:

- Exécution automatique des tests à chaque push et pull request
- Analyse de qualité de code avec RuboCop
- Vérification de la couverture des tests
- Construction et déploiement automatiques

## Revue de code

### Critères de validation

- Le code suit les conventions de style Ruby et Rails
- La couverture de tests est adéquate (>80%)
- La documentation est à jour
- Les migrations de base de données sont réversibles
- Les performances sont optimisées (pas de requêtes N+1, utilisation d'index, etc.)

### Processus de revue

1. Créer une Pull Request
2. Attribuer au moins un reviewer
3. Répondre aux commentaires et apporter les modifications nécessaires
4. Obtenir l'approbation du reviewer
5. Fusionner la PR

## Gestion des versions

Le projet suit le versionnement sémantique (SemVer):

- **Version majeure (X.0.0)** : Changements incompatibles avec les versions précédentes
- **Version mineure (0.X.0)** : Ajouts de fonctionnalités rétrocompatibles
- **Version corrective (0.0.X)** : Corrections de bugs rétrocompatibles

---

*Dernière mise à jour: Mars 2023*
