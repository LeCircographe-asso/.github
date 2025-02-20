# Documentation Technique

## Technologies Utilisées

### Backend
- Ruby 3.2.0+
- Rails 8.0.1
- SQLite3 (dev) / PostgreSQL (prod)
- Redis pour le cache

### Frontend
- Hotwire (Turbo + Stimulus)
- Tailwind CSS
- Flowbite Components
- ImportMaps

### Outils
- SumUp pour paiements
- SendGrid pour emails
- Sidekiq pour jobs
- Nginx en production

## Standards de Code

### Ruby/Rails
- [Ruby Style Guide](https://rubystyle.guide)
- [Rails Best Practices](https://rails.rubystyle.guide)
- Tests RSpec obligatoires
- Documentation yard

### JavaScript
- ESLint configuration standard
- Stimulus controllers documentés
- Turbo frames nommés explicitement

### CSS
- Tailwind classes organisées
- Composants Flowbite adaptés
- Variables CSS documentées

## Environnements

### Développement
```bash
# Installation
bundle install
rails db:setup
bin/dev # Lance Procfile.dev

# Tests
bundle exec rspec
bundle exec rubocop
```

### Production
```bash
# Configuration requise
Ruby 3.2.0+
PostgreSQL 14+
Redis 6+
Nginx

# Déploiement
bundle exec rails assets:precompile
bundle exec rails db:migrate
``` 