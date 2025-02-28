# Le Circographe - Documentation Officielle 📚

## 🎯 Vue d'ensemble
Le Circographe est une application de gestion complète pour une association de cirque, développée avec Ruby on Rails 8.0.1. Cette documentation couvre l'ensemble des aspects techniques, fonctionnels et organisationnels du projet.

## 🚀 Démarrage Rapide
- [Guide d'Installation](/docs/architecture/technical/installation.md)
- [Premier Pas](/docs/architecture/technical/quickstart.md)
- [FAQ](/docs/architecture/technical/faq.md)

## 📚 Structure de la Documentation

### 📖 Fondamentaux
- [Glossaire](/docs/glossaire.md) - Terminologie métier et technique
- [Architecture Globale](/docs/architecture/README.md) - Vue d'ensemble technique
- [Processus Métier](/docs/business/README.md) - Flux et règles métier
- [Validation](/docs/validation/README.md) - Tests et qualité

### 🏗️ Architecture Technique
- [Core](/docs/architecture/technical/core/README.md) - Logique métier
- [Frontend](/docs/architecture/technical/frontend/README.md) - Interface utilisateur
- [Sécurité](/docs/architecture/technical/security/README.md) - Gestion des accès
- [Performance](/docs/architecture/technical/performance/README.md) - Optimisations

### 🔄 Domaines Métier Restructurés
Notre application est organisée autour de six domaines métier clairement définis, chacun avec ses propres responsabilités :

1. **[Adhésion](/docs/business/domains/adhesion/README.md)** - Gestion des adhésions Basic et Cirque
   - Création et renouvellement d'adhésions
   - Upgrade d'adhésion Basic vers Cirque
   - Gestion du cycle de vie des adhésions

2. **[Cotisation](/docs/business/domains/cotisation/README.md)** - Formules d'accès aux entraînements
   - Séances uniques, cartes 10 séances
   - Abonnements mensuels et annuels
   - Tarifications normale et réduite

3. **[Paiement](/docs/business/domains/paiement/README.md)** - Transactions financières
   - Gestion des paiements et des reçus
   - Traitement des dons et reçus fiscaux
   - Rapports financiers et export comptable

4. **[Présence](/docs/business/domains/presence/README.md)** - Suivi des entraînements
   - Pointage et contrôle d'accès
   - Statistiques de fréquentation
   - Gestion de la capacité des créneaux

5. **[Rôles](/docs/business/domains/roles/README.md)** - Gestion des accès
   - Rôles système (permissions techniques)
   - Rôles associatifs (fonctions au sein de l'association)
   - Audit des actions par rôle

6. **[Notification](/docs/business/domains/notification/README.md)** - Communication automatisée
   - Rappels d'échéance et confirmations
   - Alertes système et communications
   - Préférences de notification personnalisées

### 💼 Documentation Métier
#### Processus Clés
- [Check-in](/docs/business/processes/check_in.md)
- [Paiement](/docs/business/processes/payment.md)
- [Adhésion](/docs/business/processes/membership.md)
- [Gestion des cotisations](/docs/business/processes/subscription.md)

#### Règles et Concepts
- [Règles Métier](/docs/business/rules/business_rules.md)
- [Concepts Métier](/docs/business/rules/concepts.md)
- [Mapping Concepts](/docs/business/rules/concept_mapping.md)

### ✅ Validation et Tests
- [User Stories](/docs/validation/user_stories/README.md)
- [Traçabilité](/docs/validation/traceability/README.md)
- [Plan de Tests](/docs/validation/test_plan.md)

## 🎯 Guides par Cas d'Usage

### 👥 Gestion des Membres
- [Guide Complet](/docs/business/guides/member_management.md)
- [Adhésion](/docs/business/domains/adhesion/README.md)
- [Rôles Utilisateurs](/docs/business/domains/roles/user_roles.md)
- [Notifications Membres](/docs/business/domains/notification/member_notifications.md)

### 💰 Gestion Financière
- [Guide Complet](/docs/business/guides/financial_management.md)
- [Paiements](/docs/business/domains/paiement/payments.md)
- [Reçus](/docs/business/domains/paiement/receipts.md)
- [Dons](/docs/business/domains/paiement/donations.md)

### 📊 Suivi & Statistiques
- [Guide Complet](/docs/business/guides/tracking_stats.md)
- [Présence](/docs/business/domains/presence/attendance.md)
- [Check-in](/docs/business/processes/check_in.md)
- [Rapports](/docs/business/reports/README.md)

## 🔄 Gestion des Documents

### Cycle de Vie
1. **Brouillon** - Document en cours d'écriture
2. **Revue** - Document en cours de relecture
3. **Validé** - Document approuvé et publié
4. **Archivé** - Document remplacé ou obsolète

### Versioning
- Utilisation du versioning sémantique (MAJOR.MINOR.PATCH)
- Versions documentées dans [CHANGELOG.md](/CHANGELOG.md)
- Tags Git pour chaque version majeure

## 📝 Contribution

### Guide de Contribution
1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

### Standards de Documentation
- Utiliser le Markdown pour tous les documents
- Suivre les templates fournis
- Maintenir les liens entre documents
- Mettre à jour le glossaire si nécessaire

## 🏷️ Versions
- v1.0.0 - Version initiale
- v1.1.0 - Ajout gestion des dons
- v1.2.0 - Intégration comptabilité
- v1.3.0 - Réorganisation de la documentation

## 📞 Support et Contact

### Support Technique
- **Email** : tech@lecirco.org
- **Slack** : #tech-support
- [Documentation Technique](/docs/architecture/technical/README.md#contact)

### Support Métier
- **Email** : business@lecirco.org
- **Slack** : #business-support
- [Documentation Métier](/docs/business/rules/README.md#contact)

## 📜 Licence
Ce projet est sous licence MIT - voir le fichier [LICENSE.md](/LICENSE.md) pour plus de détails. 