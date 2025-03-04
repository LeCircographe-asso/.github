# Guide de Contribution - Le Circographe 🎪

> **Note importante** : Ce guide détaille les procédures et conventions à suivre pour contribuer efficacement au projet Circographe. Veuillez le lire attentivement avant de commencer à travailler sur le code.

## 🔄 Structure des Branches

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
```

### Branches Principales
- `main` : Code en production, stable et déployé
- `staging` : Code en pré-production pour les tests d'intégration
- `develop` : Branche principale de développement, intégration continue

### Branches de Travail
- `feature/xxx` : Nouvelles fonctionnalités (ex: `feature/user-authentication`)
- `bugfix/xxx` : Corrections de bugs (ex: `bugfix/login-error`)
- `refactor/xxx` : Refactoring du code (ex: `refactor/clean-user-model`)
- `release/x.x.x` : Préparation des releases (ex: `release/1.2.0`)
- `hotfix/xxx` : Corrections urgentes en production (ex: `hotfix/critical-security-fix`)
- `docs/xxx` : Modifications de documentation uniquement (ex: `docs/update-api-docs`)

## 📝 Conventions de Commit

Nous suivons les conventions [Conventional Commits](https://www.conventionalcommits.org/) pour standardiser les messages de commit.

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
- `perf` : Amélioration de performance
- `ci` : Modifications de la CI
- `build` : Modifications du système de build

### Scopes
- `auth` : Authentification
- `core` : Fonctionnalités principales
- `ui` : Interface utilisateur
- `api` : API
- `db` : Base de données
- `config` : Configuration
- `deps` : Dépendances
- `adhesion` : Module d'adhésion
- `cotisation` : Module de cotisation
- `paiement` : Module de paiement
- `presence` : Module de présence
- `roles` : Module de gestion des rôles
- `notification` : Module de notification

### Exemples
```
feat(auth): ajouter l'authentification OAuth
fix(ui): corriger l'affichage du calendrier sur mobile
docs(api): mettre à jour la documentation de l'API de paiement
refactor(adhesion): simplifier le processus de renouvellement
test(presence): ajouter des tests pour la validation des listes
```

> **Astuce** : Utilisez des verbes à l'infinitif en français pour les descriptions.

## 🚀 Environnement de développement

### Prérequis
- Ruby 3.2.2
- Rails 8.0.1
- PostgreSQL 14+
- Node.js 18+
- Yarn 1.22+
- Redis 6+
- ImageMagick

### Installation

```bash
# Cloner le dépôt
git clone https://github.com/votre-organisation/project-manager-circographe.git
cd project-manager-circographe

# Installer les dépendances
bundle install
yarn install

# Configurer la base de données
cp config/database.yml.example config/database.yml
# Éditer database.yml avec vos informations

# Créer et migrer la base de données
bin/rails db:create db:migrate db:seed

# Lancer le serveur
bin/dev
```

### Outils recommandés
- VSCode avec les extensions Ruby, Rails, ESLint
- Rubocop pour le linting Ruby
- ESLint pour le linting JavaScript
- Foreman pour gérer les processus de développement

## 🔄 Workflow de Développement

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

> **Important** : Créez des commits atomiques et cohérents. Un commit = une modification logique.

## 👁️ Revue de Code

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

### Processus de revue
1. Assignez au moins un reviewer à votre PR
2. Répondez aux commentaires de manière constructive
3. Effectuez les modifications demandées dans de nouveaux commits
4. Une fois approuvée, squashez vos commits si nécessaire
5. Le reviewer effectuera le merge

## 📊 Standards de Code

### Ruby
- Suivre le [Ruby Style Guide](https://github.com/rubocop/ruby-style-guide)
- Indentation de 2 espaces
- Limiter les lignes à 100 caractères
- Utiliser les nouvelles syntaxes Ruby 3.x quand approprié

```ruby
# Bon
def calculate_total(items)
  items.sum { |item| item.price * item.quantity }
end

# Mauvais
def calculate_total(items)
  total = 0
  items.each do |i|
    total = total + i.price * i.quantity
  end
  return total
end
```

### Rails
- Suivre le [Rails Style Guide](https://github.com/rubocop/rails-style-guide)
- Utiliser les conventions de nommage Rails
- Préférer les scopes aux méthodes de classe
- Utiliser les validations au niveau du modèle

```ruby
# Bon
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :membership_type
  
  validates :start_date, presence: true
  validates :end_date, presence: true
  
  scope :active, -> { where("start_date <= ? AND end_date >= ?", Date.current, Date.current) }
end

# Mauvais
class Membership < ApplicationRecord
  def self.find_active
    where("start_date <= ? AND end_date >= ?", Date.current, Date.current)
  end
end
```

### Tests
- Utiliser RSpec pour les tests
- Organiser les tests par type (modèles, contrôleurs, etc.)
- Utiliser FactoryBot pour les fixtures
- Viser une couverture de code > 80%

```ruby
# Exemple de test RSpec
RSpec.describe Membership, type: :model do
  describe "validations" do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
  end
  
  describe "scopes" do
    describe ".active" do
      it "returns only active memberships" do
        active = create(:membership, start_date: 1.month.ago, end_date: 1.month.from_now)
        expired = create(:membership, start_date: 2.months.ago, end_date: 1.month.ago)
        
        expect(Membership.active).to include(active)
        expect(Membership.active).not_to include(expired)
      end
    end
  end
end
```

## 🚢 Déploiement

### Staging
1. Merger `develop` dans `staging`
2. Tests automatisés via CI/CD
3. Tests manuels sur l'environnement de staging
4. Validation QA

### Production
1. Créer une branche `release/x.x.x`
2. Tests finaux
3. Merger dans `main`
4. Tag de version
5. Déploiement automatique via CI/CD

### Commandes de déploiement
```bash
# Déploiement en staging
git checkout staging
git merge develop
git push origin staging

# Déploiement en production
git checkout main
git merge release/1.2.3
git tag -a v1.2.3 -m "Version 1.2.3"
git push origin main --tags
```

## 🏷️ Versioning

Nous suivons [Semantic Versioning](https://semver.org/) pour la gestion des versions.

### Format
`MAJOR.MINOR.PATCH`
- MAJOR : Changements incompatibles avec les versions précédentes
- MINOR : Nouvelles fonctionnalités compatibles avec les versions précédentes
- PATCH : Corrections de bugs compatibles avec les versions précédentes

### Exemple
```bash
git tag -a v1.2.3 -m "Version 1.2.3"
git push origin v1.2.3
```

## ⚠️ Gestion des Conflits

1. **Prévention**
   - Pull régulier de develop
   - Communication avec l'équipe sur Slack
   - Tickets bien définis dans le système de suivi
   - Branches de courte durée

2. **Résolution**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout ma-branche
   git rebase develop
   # Résoudre les conflits
   git add .
   git rebase --continue
   git push origin ma-branche --force-with-lease
   ```

> **Attention** : Utilisez `--force-with-lease` au lieu de `--force` pour éviter d'écraser le travail des autres.

## 🧪 Tests

### Types de tests
- **Tests unitaires** : Tester les modèles et services isolément
- **Tests d'intégration** : Tester les interactions entre composants
- **Tests système** : Tester l'application de bout en bout
- **Tests de performance** : Vérifier les temps de réponse et la charge

### Exécution des tests
```bash
# Exécuter tous les tests
bundle exec rspec

# Exécuter un fichier spécifique
bundle exec rspec spec/models/membership_spec.rb

# Exécuter avec la couverture de code
COVERAGE=true bundle exec rspec
```

### CI/CD
Nos tests sont automatiquement exécutés via GitHub Actions à chaque push et pull request.

## 💡 Bonnes Pratiques

1. **Commits**
   - Commits atomiques et cohérents
   - Messages clairs et descriptifs
   - Référencer les tickets (#123)
   - Squasher les commits avant merge

2. **Branches**
   - Branches courtes et focalisées
   - Nommage explicite
   - Supprimer après merge
   - Rebaser régulièrement avec develop

3. **Code**
   - Suivre les standards Ruby/Rails
   - Documenter le code complexe
   - Tests pour nouvelles features
   - Optimiser les requêtes N+1

4. **Communication**
   - PR descriptives avec contexte
   - Commenter les choix techniques
   - Répondre aux reviews rapidement
   - Partager les connaissances

## 🔍 Revue de Performance

Avant de soumettre une PR pour une fonctionnalité critique:

1. Vérifier les requêtes N+1 avec Bullet
2. Tester avec un jeu de données réaliste
3. Optimiser les requêtes SQL complexes
4. Vérifier l'utilisation de la mémoire

## 📚 Documentation

Toute nouvelle fonctionnalité doit être documentée:

1. Documentation technique dans `/documentations/technical/`
2. Documentation métier dans `/documentations/domains/[domaine]/`
3. Mise à jour des guides utilisateur si nécessaire
4. Commentaires explicatifs pour le code complexe

## 🆘 Support

- **Questions techniques** : #tech-support (Slack)
- **Bugs** : Issues GitHub
- **Documentation** : Wiki du projet
- **Urgences** : Contact direct avec le lead developer

---

Ce guide est évolutif. N'hésitez pas à proposer des améliorations via une PR avec le préfixe `docs:`. 