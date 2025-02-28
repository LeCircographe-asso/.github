# 🔧 Spécifications Techniques - Le Circographe

<div align="right">
  <a href="../README.md">⬅️ Retour aux requirements</a> •
  <a href="../../profile/README.md">📚 Documentation principale</a>
</div>

<p align="center"><i>🧭 Chemin: <a href="../../profile/README.md">Documentation</a> > <a href="../README.md">Requirements</a> > <b>Spécifications Techniques</b></i></p>

## 📋 Vue d'ensemble

Ce dossier contient les spécifications techniques essentielles de l'application, organisées par domaine technique et alignées avec les standards Rails 8.0.1. **Pour éviter les duplications, ce document fait référence aux autres sections de documentation quand c'est pertinent.**

## 🔄 Relations avec les domaines métier

Les spécifications techniques sont organisées pour supporter les [domaines métier](../1_métier/index.md) de l'application:

| Domaine Métier | Aspects Techniques Principaux |
|----------------|-------------------------------|
| [Adhésion](../1_métier/adhesion/index.md) | Modèles utilisateur et adhésion, workflows d'authentification |
| [Cotisation](../1_métier/cotisation/index.md) | Gestion des paiements récurrents, validité des formules |
| [Paiement](../1_métier/paiement/index.md) | Transactions, reçus, sécurité des données financières |
| [Présence](../1_métier/presence/index.md) | Check-in temps réel, génération de QR codes, statistiques |
| [Rôles](../1_métier/roles/index.md) | Système d'autorisation, audit d'actions, permissions |
| [Notification](../1_métier/notification/index.md) | Système de notifications, emails, préférences utilisateur |

## 📂 Organisation technique

```
2_specifications_techniques/
├── README.md         # Ce document
├── interfaces/       # Spécifications UI/UX
│   ├── README.md     # Structure des interfaces
│   ├── admin.md      # Interface administrateur
│   ├── benevole.md   # Interface bénévole
│   └── composants.md # Composants partagés
├── modeles.md        # Architecture des modèles de données
├── performance.md    # Optimisation et performance
├── securite.md       # Sécurité et authentification
├── storage.md        # Gestion du stockage
└── tests.md          # Tests et validation technique
```

## 🛠️ Stack technique Rails 8.0.1

La stack utilise exclusivement les technologies et paradigmes recommandés par Rails 8.0.1, sans gems tierces non approuvées.

### Backend
- **Ruby 3.2.0+** - Tirant parti des nouvelles fonctionnalités comme pattern matching et RBS
- **Rails 8.0.1** - Utilisation de l'architecture standard MVC
- **SQLite3** - Pour tous les environnements conformément aux requirements
- **Authentification native** - Sans utiliser Devise, selon [guides.rubyonrails.org](https://guides.rubyonrails.org)

### Frontend
- **Tailwind CSS** - Via la gem officielle `tailwindcss-rails`
- **Flowbite Components** - Via `flowbite-rails`, compatible avec Tailwind
- **Hotwire (Turbo + Stimulus)** - Sans SPA ou framework JS séparé
- **Importmaps** - Gestion des dépendances JS sans bundling

## 🗄️ Modèles et architecture des données

> 📝 **Note**: Les spécifications détaillées se trouvent dans le document [modeles.md](./modeles.md).

L'application utilise une architecture modulaire par domaine métier, avec des modèles optimisés pour les relations entre domaines. Les principales caractéristiques incluent:

- Organisation des modèles par namespaces de domaine métier
- Validation rigoureuse des données à tous les niveaux
- Relations polymorphiques pour les paiements et notifications
- Utilisation optimale des scopes et callbacks
- Documentation YARD complète pour tous les modèles

## 🔐 Sécurité et authentification

> 📝 **Note**: Les spécifications détaillées se trouvent dans le document [securite.md](./securite.md).

L'application implémente un système d'authentification et d'autorisation robuste:

- Authentification native Rails 8.0.1 avec `has_secure_password`
- Système de sessions sécurisé avec jetons uniques et expirations
- Gestion fine des rôles et des permissions par domaine
- Journal d'audit complet pour les actions sensibles
- Protection GDPR pour les données personnelles
- Mécanismes de limitation des tentatives d'authentification

## 🖥️ Interfaces utilisateur

> 📝 **Note**: Les spécifications détaillées se trouvent dans le dossier [interfaces/](./interfaces/).

Les interfaces respectent les standards modernes tout en étant adaptées aux spécificités du domaine associatif:

- **Mobile-first** avec des breakpoints Tailwind standards
- **Accessibilité** WCAG 2.1 niveau AA
- **Thème** cohérent avec l'identité visuelle de l'association
- **Composants** réutilisables basés sur Flowbite
- **Interfaces spécifiques** pour administrateurs et bénévoles

## ⚡ Performance et optimisation

> 📝 **Note**: Les spécifications détaillées se trouvent dans le document [performance.md](./performance.md).

L'application intègre des stratégies d'optimisation à tous les niveaux:

- Optimisation des requêtes SQL avec eager loading et indexes stratégiques
- Systèmes de cache à plusieurs niveaux (fragment, HTTP, modèle)
- Optimisation frontend avec Turbo et lazy loading
- Tâches d'arrière-plan pour les opérations lourdes
- Monitoring et instrumentation pour l'analyse continue

## 🧪 Tests et validation technique

> 📝 **Note**: Les spécifications détaillées se trouvent dans le document [tests.md](./tests.md).

La stratégie de test complète assure la fiabilité et la qualité du code:

- Tests unitaires couvrant les modèles et services (RSpec)
- Tests d'intégration pour les interactions entre composants
- Tests système pour simuler les interactions utilisateur réelles
- Organisation des tests par domaine métier
- Intégration continue avec rapports de couverture
- Suite de tests automatisée pour prévenir les régressions

## 🖇️ Liens vers la documentation technique approfondie

- [Architecture détaillée](/docs/architecture/README.md)
- [Guide d'implémentation](/requirements/4_implementation/README.md)
- [Rails 8.0.1 Guides](https://guides.rubyonrails.org/)
- [Flowbite Components](https://flowbite.com/docs/components/)

---

<div align="center">
  <p>
    <a href="../README.md">⬅️ Retour aux requirements</a> | 
    <a href="#-spécifications-techniques---le-circographe">⬆️ Haut de page</a>
  </p>
</div> 