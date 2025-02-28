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

### [Adhésion](./adhesion/index.md)
Règles et processus liés aux adhésions Basic et Cirque.
- [📜 Règles](./adhesion/regles.md) - Définition des types d'adhésion, tarifs, validité, etc.
- [⚙️ Specs](./adhesion/specs.md) - Structure de données et implémentation technique
- [✅ Validation](./adhesion/validation.md) - Critères d'acceptation et scénarios de test

### [Cotisation](./cotisation/index.md)
Règles et processus liés aux différentes formules de cotisations permettant l'accès aux entraînements.
- [📜 Règles](./cotisation/regles.md) - Types de cotisation, tarification, droits d'accès
- [⚙️ Specs](./cotisation/specs.md) - Structure de données et implémentation technique
- [✅ Validation](./cotisation/validation.md) - Critères d'acceptation et scénarios de test

### [Paiement](./paiement/index.md)
Règles et processus liés aux transactions financières, à la gestion des reçus et aux dons.
- [📜 Règles](./paiement/regles.md) - Méthodes de paiement, reçus, remboursements
- [⚙️ Specs](./paiement/specs.md) - Structure de données et implémentation technique
- [✅ Validation](./paiement/validation.md) - Critères d'acceptation et scénarios de test

### [Présence](./presence/index.md)
Règles et processus liés à l'enregistrement des présences, aux listes quotidiennes et aux statistiques de fréquentation.
- [📜 Règles](./presence/regles.md) - Pointage, listes de présence, règles d'accès
- [⚙️ Specs](./presence/specs.md) - Structure de données et implémentation technique
- [✅ Validation](./presence/validation.md) - Critères d'acceptation et scénarios de test

### [Rôles](./roles/index.md)
Règles et processus liés à la gestion des rôles système (permissions techniques) et des rôles utilisateurs (fonctions associatives).
- [📜 Règles](./roles/regles.md) - Hiérarchie et définition des rôles, permissions
- [⚙️ Specs](./roles/specs.md) - Structure de données et implémentation technique
- [✅ Validation](./roles/validation.md) - Critères d'acceptation et scénarios de test

### [Notification](./notification/index.md)
Règles et processus liés à la communication avec les membres, incluant les rappels d'échéance, les confirmations et autres communications automatisées.
- [📜 Règles](./notification/regles.md) - Types de notification, déclencheurs, contenu
- [⚙️ Specs](./notification/specs.md) - Structure de données et implémentation technique
- [✅ Validation](./notification/validation.md) - Critères d'acceptation et scénarios de test

## Navigation Globale

- [⬅️ Retour aux requirements](../)
- [➡️ Spécifications Techniques](../2_specifications_techniques/)
- [➡️ User Stories](../3_user_stories/)
- [➡️ Implémentation](../4_implementation/)

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
| [Adhésion/regles.md](./adhesion/regles.md) | requirements/1_métier/adhesions/regles.md, requirements/1_métier/adhesions/tarifs.md, docs/business/rules/membership_rules.md |
| [Cotisation/regles.md](./cotisation/regles.md) | requirements/1_métier/cotisations/types.md, docs/business/rules/subscription_rules.md |
| [Paiement/regles.md](./paiement/regles.md) | requirements/1_métier/paiements/methodes.md, requirements/1_métier/paiements/recus.md, requirements/1_métier/paiements/dons.md, docs/business/rules/payment_rules.md |
| [Presence/regles.md](./presence/regles.md) | requirements/1_métier/presences/listes.md, docs/business/processes/check_in.md |
| [Roles/regles.md](./roles/regles.md) | requirements/1_métier/utilisateurs/roles.md, docs/business/rules/user_roles.md |
| [Notification/regles.md](./notification/regles.md) | requirements/1_métier/notifications/types.md, docs/business/states/notification.md | 