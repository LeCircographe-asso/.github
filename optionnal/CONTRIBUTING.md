# Guide de Contribution - Le Circographe 🎪

## Structure des Branches

```
main (production)
├── staging (pré-production)
│   ├── develop (développement)
│   │   ├── feature/xxx
│   │   ├── bugfix/xxx
│   │   ├── refactor/xxx
│   │   └── deps/xxx
│   └── release/x.x.x
└── hotfix/xxx

### Branches Principales
- `main` : Code en production, stable
- `staging` : Code en pré-production pour les tests
- `develop` : Branche principale de développement

### Branches de Travail
- `feature/xxx` : Nouvelles fonctionnalités (ex: feature/user-authentication)
- `bugfix/xxx` : Corrections de bugs (ex: bugfix/login-error)
- `refactor/xxx` : Refactoring du code (ex: refactor/clean-user-model)
- `release/x.x.x` : Préparation des releases (ex: release/1.2.0)
- `hotfix/xxx` : Corrections urgentes en production (ex: hotfix/critical-security-fix)

## Conventions de Commit

### Format
```
<type>(<scope>): <description>

[corps]

[footer]
```

### Types de Commit
- `feat` : Nouvelle fonctionnalité
- `fix` : Correction de bug
- `docs` : Documentation
- `style` : Formatage, semi-colons manquants, etc.
- `refactor` : Refactoring du code
- `test` : Ajout ou modification de tests
- `chore` : Maintenance

### Scopes
- `auth` : Authentification
- `core` : Fonctionnalités principales
- `ui` : Interface utilisateur
- `api` : API
- `db` : Base de données
- `config` : Configuration
- `deps` : Dépendances

### Exemples
```
feat(auth): ajouter l'authentification OAuth
fix(ui): corriger l'affichage du calendrier
docs(api): mettre à jour la documentation de l'API
```

## Workflow de Développement

1. **Création de Branche**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/ma-fonctionnalite
   ```

2. **Commits Réguliers**
   ```bash
   git add .
   git commit -m "feat(scope): description"
   ```

3. **Mise à Jour avec Develop**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout feature/ma-fonctionnalite
   git rebase develop
   ```

4. **Push et Pull Request**
   ```bash
   git push origin feature/ma-fonctionnalite
   # Créer PR via GitHub
   ```

## Revue de Code

### Critères de Validation
- Tests passent ✅
- Pas de conflits avec develop ⚠️
- Respecte les standards de code 📝
- Documentation à jour 📚
- Approuvé par au moins 1 reviewer 👥

### Checklist de Review
- [ ] Le code suit les conventions
- [ ] Les tests sont présents et passent
- [ ] La documentation est à jour
- [ ] Pas de problèmes de sécurité
- [ ] Performance acceptable
- [ ] Code lisible et maintenable

## Déploiement

### Staging
1. Merger `develop` dans `staging`
2. Tests automatisés
3. Tests manuels
4. Validation QA

### Production
1. Créer une branche `release/x.x.x`
2. Tests finaux
3. Merger dans `main`
4. Tag de version
5. Déploiement

## Versioning

### Format
`MAJOR.MINOR.PATCH`
- MAJOR : Changements incompatibles
- MINOR : Nouvelles fonctionnalités compatibles
- PATCH : Corrections de bugs compatibles

### Exemple
```bash
git tag -a v1.2.3 -m "Version 1.2.3"
git push origin v1.2.3
```

## Gestion des Conflits

1. **Prévention**
   - Pull régulier de develop
   - Communication avec l'équipe
   - Tickets bien définis

2. **Résolution**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout ma-branche
   git rebase develop
   # Résoudre les conflits
   git add .
   git rebase --continue
   ```

## Bonnes Pratiques

1. **Commits**
   - Commits atomiques et cohérents
   - Messages clairs et descriptifs
   - Référencer les tickets (#123)

2. **Branches**
   - Branches courtes et focalisées
   - Nommage explicite
   - Supprimer après merge

3. **Code**
   - Suivre les standards Ruby/Rails
   - Documenter le code complexe
   - Tests pour nouvelles features

4. **Communication**
   - PR descriptives
   - Commenter les choix techniques
   - Répondre aux reviews

## Support

- Questions : #tech-support (Slack)
- Bugs : Issues GitHub
- Documentation : Wiki 