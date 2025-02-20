# Architecture Système

## Environnements

### Développement
- Ruby 3.2.0+
- Rails 8.0.1
- SQLite3
- Serveur local Puma

### Production
- Ruby 3.2.0+
- Rails 8.0.1
- PostgreSQL
- Nginx + Puma
- Redis pour le cache

## Services Externes

### Paiement
- Terminal SumUp
- Pas d'intégration API
- Reçus générés localement

### Emails
- SMTP local en développement
- SendGrid en production
- Templates d'emails versionnés

## Sécurité

### Authentification
- Système natif Rails 8
- Sessions sécurisées
- Protection CSRF

### Données
- Chiffrement des données sensibles
- Backups automatiques
- Logs sécurisés

## Monitoring

### Performance
- Rails logs
- Exception tracking
- Métriques système

### Utilisateurs
- Audit trail des actions
- Logs de connexion
- Statistiques d'utilisation 