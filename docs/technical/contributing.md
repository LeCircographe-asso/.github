# Guide de Contribution

## Processus de Développement

### 1. Branches
```bash
# Convention de nommage des branches
feature/nom-de-la-feature
bugfix/description-du-bug
hotfix/correction-urgente
release/x.y.z

# Exemple de workflow
git checkout -b feature/systeme-entrainement
git add .
git commit -m "feat: ajout du système d'entraînement"
git push origin feature/systeme-entrainement
```

### 2. Commits
```bash
# Format des messages de commit
<type>(<scope>): <description>

# Types
feat: nouvelle fonctionnalité
fix: correction de bug
docs: documentation
style: formatage, semicolons manquants, etc.
refactor: refactorisation du code
test: ajout ou modification de tests
chore: maintenance

# Exemples
feat(auth): ajoute l'authentification OAuth
fix(payments): corrige le calcul des réductions
docs(api): met à jour la documentation de l'API
```

## Bonnes Pratiques

### 1. Pull Requests
```markdown
## Description
Brève description des changements

## Changements
- Ajout de la fonctionnalité X
- Correction du bug Y
- Amélioration des performances de Z

## Tests
- [ ] Tests unitaires ajoutés
- [ ] Tests d'intégration mis à jour
- [ ] Tests manuels effectués

## Checklist
- [ ] Le code suit les conventions
- [ ] La documentation est à jour
- [ ] Les tests passent
- [ ] Le code a été revu
```

### 2. Code Review
```markdown
# Critères de Review

## Qualité du Code
- Le code est-il lisible et bien documenté ?
- Suit-il les conventions du projet ?
- Les noms sont-ils explicites ?

## Tests
- Les tests couvrent-ils les cas d'usage ?
- Les tests sont-ils maintenables ?

## Performance
- Les requêtes sont-elles optimisées ?
- Le code est-il efficace ?

## Sécurité
- Les entrées sont-elles validées ?
- Les autorisations sont-elles vérifiées ?
```

## Environnement de Développement

### 1. Installation
```bash
# Cloner le projet
git clone git@github.com:organization/circographe.git
cd circographe

# Installer les dépendances
bundle install
yarn install

# Configurer la base de données
cp config/database.yml.example config/database.yml
rails db:setup

# Lancer les tests
bundle exec rspec

# Démarrer le serveur
bin/dev
```

### 2. Outils Recommandés
```markdown
## Éditeur
- VSCode avec les extensions :
  - Ruby
  - Rails
  - ESLint
  - Prettier
  - GitLens

## Debugging
- ruby-debug-ide
- debase
- pry-rails

## Qualité de Code
- RuboCop
- ESLint
- Prettier
```

## Documentation

### 1. Mise à Jour
```ruby
# Documenter les méthodes publiques
# @param [Type] nom description
# @return [Type] description
def methode(param)
  # ...
end

# Documenter les modèles
# == Schema Information
# Table name: users
#  id          :integer          not null, primary key
#  email       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
class User < ApplicationRecord
  # ...
end
```

### 2. Génération
```bash
# Générer la documentation API
bundle exec rake docs:generate

# Mettre à jour les annotations de modèles
bundle exec annotate --models
```

## Déploiement

### 1. Environnements
```markdown
## Staging
- URL: https://staging.circographe.fr
- Branche: develop
- Déploiement: automatique

## Production
- URL: https://circographe.fr
- Branche: main
- Déploiement: manuel après validation
```

### 2. Checklist de Release
```markdown
## Avant le déploiement
- [ ] Tous les tests passent
- [ ] La documentation est à jour
- [ ] Les migrations sont réversibles
- [ ] Les changements sont testés en staging

## Après le déploiement
- [ ] Vérifier les logs
- [ ] Tester les fonctionnalités clés
- [ ] Monitorer les performances
- [ ] Vérifier les métriques
``` 