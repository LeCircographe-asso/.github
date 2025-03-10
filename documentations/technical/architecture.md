# Architecture de l'application

## Structure MVC+

Le Circographe suit une architecture MVC étendue avec des services, des présentateurs et des jobs:

```
app/
├── models/               # Modèles ActiveRecord
├── views/                # Vues (ERB, Slim)
├── controllers/          # Contrôleurs
├── services/             # Services métier
├── presenters/           # Présentateurs pour les vues
├── jobs/                 # Jobs ActiveJob
├── mailers/              # Mailers pour les emails
├── helpers/              # Helpers pour les vues
├── assets/               # Assets (JS, CSS, images)
│   ├── javascripts/
│   ├── stylesheets/
│   └── images/
├── javascript/           # JavaScript moderne (Stimulus)
└── components/           # Composants View Component
```

## Domaines métier

L'application est organisée autour de six domaines métier principaux:

1. **Adhésion** - Gestion des adhérents et de leur statut
2. **Cotisation** - Gestion des cotisations et des tarifs
3. **Paiement** - Gestion des paiements et des factures
4. **Présence** - Gestion des présences aux activités
5. **Rôles** - Gestion des rôles et des permissions
6. **Notification** - Gestion des notifications et des communications

Chaque domaine est implémenté avec ses propres modèles, contrôleurs, services et vues.

## Stack technique

### Backend

| Composant | Technologie | Documentation |
|-----------|------------|---------------|
| Framework | Ruby on Rails 8.0.1 | [Documentation Rails](https://guides.rubyonrails.org/) |
| Base de données | SQLite3 | [Documentation SQLite](https://www.sqlite.org/docs.html) |
| Authentification | Authentification native Rails 8 | [Documentation Rails Authentication](https://guides.rubyonrails.org/security.html#user-management) |
| Autorisation | Système d'autorisation personnalisé | [Spécifications Rôles](../domains/roles/README.md) |
| Jobs asynchrones | ActiveJob | [Documentation ActiveJob](https://guides.rubyonrails.org/active_job_basics.html) |
| Planification | Rufus-Scheduler | [Documentation Rufus](https://github.com/jmettraux/rufus-scheduler) |
| Tests | RSpec, FactoryBot | [Documentation RSpec](https://rspec.info/) |

### Frontend

| Composant | Technologie | Documentation |
|-----------|------------|---------------|
| CSS | Tailwind CSS | [Documentation Tailwind](https://tailwindcss.com/docs) |
| Composants | Flowbite | [Documentation Flowbite](https://flowbite.com/docs/components/) |
| JavaScript | Hotwire (Turbo, Stimulus) | [Documentation Hotwire](https://hotwired.dev/) |
| Formulaires | Simple Form | [Documentation Simple Form](https://github.com/heartcombo/simple_form) |
| Pagination | Pagy | [Documentation Pagy](https://github.com/ddnexus/pagy) |

## Diagrammes d'architecture

Les diagrammes d'architecture de l'application sont disponibles dans le dossier `../assets/diagrams/`.

---

*Dernière mise à jour: Mars 2023*
