# Domaines Métier du Circographe

## Vue d'ensemble

Cette section contient l'ensemble des domaines métier du Circographe, documentés selon notre structure de Single Source of Truth. Chaque domaine constitue une source de vérité pour les règles et concepts spécifiques à un aspect fonctionnel du système.

## Organisation de la Documentation

Chaque domaine métier est organisé en trois fichiers principaux:

| Fichier | Description | Audience |
|---------|-------------|----------|
| **regles.md** | Source de vérité définissant les règles fondamentales du domaine | Équipe technique, métier |
| **specs.md** | Spécifications techniques d'implémentation | Équipe de développement |
| **validation.md** | Critères d'acceptation et scénarios de test | QA, Équipe technique |

## Navigation des Domaines

### [Adhésion](requirements/1_métier/adhesion/index.md)
Règles et processus liés aux adhésions Basic et Cirque.
- [📜 Règles](requirements/1_métier/adhesion/regles.md) - Définition des types d'adhésion, tarifs, validité, etc.
- [⚙️ Specs](requirements/1_métier/adhesion/specs.md) - Structure de données et implémentation technique
- [✅ Validation](requirements/1_métier/adhesion/validation.md) - Critères d'acceptation et scénarios de test

### [Cotisation](requirements/1_métier/adhesion/index.md)
Règles et processus liés aux différentes formules de cotisations permettant l'accès aux entraînements.
- [📜 Règles](requirements/1_métier/adhesion/regles.md) - Types de cotisation, tarification, droits d'accès
- [⚙️ Specs](requirements/1_métier/adhesion/specs.md) - Structure de données et implémentation technique
- [✅ Validation](requirements/1_métier/adhesion/validation.md) - Critères d'acceptation et scénarios de test

### [Paiement](requirements/1_métier/adhesion/index.md)
Règles et processus liés aux transactions financières, à la gestion des reçus et aux dons.
- [📜 Règles](requirements/1_métier/adhesion/regles.md) - Méthodes de paiement, reçus, remboursements
- [⚙️ Specs](requirements/1_métier/adhesion/specs.md) - Structure de données et implémentation technique
- [✅ Validation](requirements/1_métier/adhesion/validation.md) - Critères d'acceptation et scénarios de test

### [Présence](requirements/1_métier/adhesion/index.md)
Règles et processus liés à l'enregistrement des présences, aux listes quotidiennes et aux statistiques de fréquentation.
- [📜 Règles](requirements/1_métier/adhesion/regles.md) - Pointage, listes de présence, règles d'accès
- [⚙️ Specs](requirements/1_métier/adhesion/specs.md) - Structure de données et implémentation technique
- [✅ Validation](requirements/1_métier/adhesion/validation.md) - Critères d'acceptation et scénarios de test

### [Rôles](requirements/1_métier/adhesion/index.md)
Règles et processus liés à la gestion des rôles système (permissions techniques) et des rôles utilisateurs (fonctions associatives).
- [📜 Règles](requirements/1_métier/adhesion/regles.md) - Hiérarchie et définition des rôles, permissions
- [⚙️ Specs](requirements/1_métier/adhesion/specs.md) - Structure de données et implémentation technique
- [✅ Validation](requirements/1_métier/adhesion/validation.md) - Critères d'acceptation et scénarios de test

### [Notification](requirements/1_métier/adhesion/index.md)
Règles et processus liés à la communication avec les membres, incluant les rappels d'échéance, les confirmations et autres communications automatisées.
- [📜 Règles](requirements/1_métier/adhesion/regles.md) - Types de notification, déclencheurs, contenu
- [⚙️ Specs](requirements/1_métier/adhesion/specs.md) - Structure de données et implémentation technique
- [✅ Validation](requirements/1_métier/adhesion/validation.md) - Critères d'acceptation et scénarios de test

## Navigation Globale

- [⬅️ Retour aux requirements](../)
- [➡️ Spécifications Techniques](/requirements/2_specifications_techniques/)
- [➡️ User Stories](/requirements/3_user_stories/)
- [➡️ Implémentation](/requirements/4_implementation/)

## Interdépendances entre Domaines

Pour faciliter la compréhension des relations entre les domaines, ce diagramme montre les principales interdépendances:

```
Adhésion <──────> Paiement
   │               │
   ▼               ▼
Cotisation <────> Présence
   │               ▲
   │               │
   └───> Rôles <───┘
          │
          ▼
      Notification
```

## Mapping avec les anciens documents

Pour faciliter la transition vers cette nouvelle structure, voici les correspondances avec les anciens fichiers :

| Nouveau Document | Anciens Documents |
|------------------|-------------------|
| [Adhésion/regles.md](requirements/1_métier/adhesion/regles.md) | requirements/1_métier/adhesions/regles.md, requirements/1_métier/adhesions/tarifs.md, docs/business/rules/membership_rules.md |
| [Cotisation/regles.md](requirements/1_métier/adhesion/regles.md) | requirements/1_métier/cotisations/types.md, docs/business/rules/subscription_rules.md |
| [Paiement/regles.md](requirements/1_métier/adhesion/regles.md) | requirements/1_métier/paiements/methodes.md, requirements/1_métier/paiements/recus.md, requirements/1_métier/paiements/dons.md, docs/business/rules/payment_rules.md |
| [Presence/regles.md](requirements/1_métier/adhesion/regles.md) | requirements/1_métier/presences/listes.md, docs/business/processes/check_in.md |
| [Roles/regles.md](requirements/1_métier/adhesion/regles.md) | requirements/1_métier/utilisateurs/roles.md, docs/business/rules/user_roles.md |
| [Notification/regles.md](requirements/1_métier/adhesion/regles.md) | requirements/1_métier/notifications/types.md, docs/business/states/notification.md | 