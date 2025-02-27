# Architecture Le Circographe 🏗️

## Vue d'ensemble

Le Circographe est construit sur une architecture moderne et modulaire, utilisant Ruby on Rails 8.0.1 comme framework principal. Cette section détaille l'architecture technique et les choix de conception.

## 🔧 Stack Technique

### Backend
- Ruby 3.2.0
- Rails 8.0.1
- SQLite3
- Redis (Cache & Jobs)
- Sidekiq (Background Jobs)

### Frontend
- Hotwire (Turbo & Stimulus)
- Tailwind CSS
- Flowbite Components
- ImportMaps

### Testing
- RSpec
- Factory Bot
- Faker

## 📂 Structure du Projet

### Composants Principaux
- [Core](/docs/architecture/technical/core/README.md) - Logique métier et modèles
- [Frontend](/docs/architecture/technical/frontend/README.md) - Interface utilisateur
- [Sécurité](/docs/architecture/technical/security/README.md) - Authentification et autorisation
- [Performance](/docs/architecture/technical/performance/README.md) - Optimisations et monitoring

### Organisation du Code
```
app/
├── controllers/    # Contrôleurs REST
├── models/        # Modèles Active Record
├── services/      # Services métier
├── jobs/          # Background jobs
├── mailers/       # Emails
├── views/         # Templates ERB/HAML
└── components/    # View components
```

## 🔄 Flux de Données

### Diagrammes
- [Flux Utilisateur](/docs/architecture/flow.md#user-flow)
- [Flux Paiement](/docs/architecture/flow.md#payment-flow)
- [Flux Présence](/docs/architecture/flow.md#attendance-flow)

### Intégrations
- Système de paiement
- Envoi d'emails
- Stockage de fichiers
- API externes

## 🛠️ Composants Techniques

### Services Principaux
- [AuthenticationService](/docs/architecture/components.md#authentication)
- [PaymentService](/docs/architecture/components.md#payment)
- [NotificationService](/docs/architecture/components.md#notification)
- [StatisticsService](/docs/architecture/components.md#statistics)

### Jobs Background
- Calcul des statistiques
- Envoi des notifications
- Synchronisation des données
- Tâches de maintenance

## 📈 Performance et Scalabilité

### Optimisations
- Cache Redis
- Background jobs
- Eager loading
- Indexation DB

### Monitoring
- Métriques système
- Logs applicatifs
- Alertes
- Dashboard

## 🔒 Sécurité

### Mesures Principales
- Authentification native Rails
- Autorisation basée sur les rôles
- Protection CSRF
- Encryption des données sensibles

### Audit
- Logs de sécurité
- Traçabilité des actions
- Monitoring des accès

## 📝 Guides de Développement

### Setup
1. [Installation](/docs/architecture/technical/installation.md)
2. [Configuration](/docs/architecture/technical/configuration.md)
3. [Déploiement](/docs/architecture/technical/deployment.md)

### Bonnes Pratiques
- [Conventions de Code](/docs/architecture/technical/conventions.md)
- [Guidelines API](/docs/architecture/technical/api_guidelines.md)
- [Tests](/docs/architecture/technical/testing.md)

## 🔄 Cycle de Développement

### Workflow
1. Développement local
2. Tests automatisés
3. Review de code
4. Déploiement staging
5. Tests QA
6. Déploiement production

### Environnements
- Development
- Testing
- Staging
- Production

## 📚 Documentation Technique

### API
- [Documentation API](/docs/architecture/technical/api/README.md)
- [Endpoints](/docs/architecture/technical/api/endpoints.md)
- [Authentication](/docs/architecture/technical/api/auth.md)

### Base de Données
- [Schéma](/docs/architecture/technical/database/schema.md)
- [Migrations](/docs/architecture/technical/database/migrations.md)
- [Indexation](/docs/architecture/technical/database/indexes.md)

## 🤝 Contribution

### Process
1. Fork du projet
2. Création de branche
3. Développement
4. Tests
5. Pull Request

### Standards
- [Guidelines de Code](/docs/architecture/technical/guidelines.md)
- [Convention de Commits](/docs/architecture/technical/commits.md)
- [Process de Review](/docs/architecture/technical/review.md)

## 📞 Contact

### Support Technique
- **Email**: tech@lecirco.org
- **Slack**: #tech-support
- **Documentation**: [Wiki Technique](/docs/architecture/technical/wiki.md)

### Urgences
- **Astreinte**: +33 6 XX XX XX XX
- **Slack**: #tech-emergency
- **Incident Process**: [Guide Incidents](/docs/architecture/technical/incidents.md) 