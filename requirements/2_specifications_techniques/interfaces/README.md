# 🖥️ Interfaces - Le Circographe

<div align="right">
  <a href="../README.md">⬅️ Retour aux spécifications techniques</a> •
  <a href="../../../profile/README.md">📚 Documentation principale</a>
</div>

<p align="center"><i>🧭 Chemin: <a href="../../../profile/README.md">Documentation</a> > <a href="../../README.md">Requirements</a> > <a href="../README.md">Spécifications Techniques</a> > <b>Interfaces</b></i></p>

## 📋 Vue d'ensemble

Cette section définit les spécifications des interfaces utilisateur pour l'application Le Circographe, organisées par type d'interface et alignées sur les domaines métier.

## 🏛️ Organisation des interfaces

Les interfaces de l'application sont structurées en trois catégories principales:

1. **[Interface administrateur](./admin.md)** - Pour la gestion complète de l'application
2. **[Interface bénévole](./benevole.md)** - Pour les opérations quotidiennes de l'association
3. **[Composants partagés](./composants.md)** - Éléments d'interface réutilisables

## 📊 Principes de conception

### 1. Alignement avec les domaines métier

Chaque interface est conçue pour refléter l'organisation en domaines métier de l'application:

| Domaine | Admin | Bénévole | Public |
|---------|-------|----------|--------|
| Adhésion | ✅ Complète | ✅ Lecture + validation | ✅ Consultation |
| Cotisation | ✅ Configuration | ✅ Lecture + vente | ✅ Catalogue |
| Paiement | ✅ Complète | ✅ Enregistrement | ❌ Aucun |
| Présence | ✅ Configuration | ✅ Gestion quotidienne | ✅ Consultation |
| Rôles | ✅ Complète | ❌ Aucun | ❌ Aucun |
| Notification | ✅ Configuration | ✅ Lecture | ✅ Réception |

### 2. Technologies utilisées

Les interfaces sont développées avec les technologies Rails 8.0.1:

- **Backend**: Ruby on Rails 8.0.1 avec architecture MVC
- **Frontend**: Hotwire (Turbo + Stimulus) + Tailwind CSS
- **Responsive**: Design adaptatif pour mobile, tablette et bureau
- **Accessibilité**: Conforme WCAG 2.1 AA

### 3. Principes UX

- **Cohérence**: Expérience utilisateur uniforme à travers les interfaces
- **Simplicité**: Interfaces intuitives avec des actions claires
- **Feedback**: Réactions immédiates aux actions utilisateur
- **Efficacité**: Optimisation des parcours utilisateur fréquents

## 🧩 Structure des interfaces par domaine

### Adhésion

```
app/views/
├── adhesion/                # Interface publique
│   ├── new.html.erb         # Création d'adhésion
│   ├── renew.html.erb       # Renouvellement
│   └── show.html.erb        # Détail d'adhésion
├── admin/
│   └── adhesion/            # Interface administration
│       ├── index.html.erb   # Liste des adhésions
│       ├── show.html.erb    # Détail complet
│       └── edit.html.erb    # Modification
└── benevole/
    └── adhesion/            # Interface bénévole
        ├── validate.html.erb # Validation de justificatifs
        └── search.html.erb  # Recherche d'adhérents
```

### Cotisation

Structure similaire pour les formules d'accès, avec des interfaces spécifiques pour la configuration (admin) et la vente (bénévole).

### Présence

Inclut des interfaces pour la gestion des créneaux, l'enregistrement des présences, et les statistiques.

## 🔄 Éléments partagés entre interfaces

Les composants réutilisables sont documentés dans [composants.md](./composants.md) et incluent:

- Systèmes de navigation (menus, breadcrumbs)
- Éléments de formulaire standardisés
- Tableaux de données interactifs
- Composants de notification
- Widgets de statistiques

## 🔐 Sécurité et authentification

- Authentification basée sur les rôles définis dans le domaine Rôles
- Contrôle d'accès au niveau des contrôleurs et des vues
- Protection CSRF et XSS intégrée
- Journalisation des actions par utilisateur

## 📱 Responsive et mobile-first

Toutes les interfaces sont conçues selon l'approche mobile-first:
- Mise en page fluide avec Tailwind CSS
- Composants adaptatifs selon la taille d'écran
- Fonctionnalités critiques accessibles sur mobile
- Performance optimisée pour les connexions limitées

## 📚 Documentation complémentaire

- [Interface administrateur](./admin.md) - Détails de l'interface d'administration
- [Interface bénévole](./benevole.md) - Spécifications pour les bénévoles
- [Composants partagés](./composants.md) - Bibliothèque de composants réutilisables

## 📆 Historique des mises à jour

- **28 février 2024** : Révision des liens et de la structure de la documentation
- **26 février 2024** : Création des documents détaillés pour chaque interface
- **25 février 2024** : Structure initiale du dossier interfaces

---

<div align="center">
  <p>
    <a href="../README.md">⬅️ Retour aux spécifications techniques</a> | 
    <a href="#-interfaces---le-circographe">⬆️ Haut de page</a>
  </p>
</div> 