# Domaines Métier du Circographe

## Vue d'ensemble

Le Circographe est une application de gestion complète pour association de cirque, organisée autour de six domaines métier fondamentaux. Cette section contient l'ensemble de ces domaines, documentés selon notre structure de Single Source of Truth. Chaque domaine constitue une source de vérité pour les règles et concepts spécifiques à un aspect fonctionnel du système.

## Organisation de la Documentation

Chaque domaine métier est organisé en trois fichiers principaux:

| Fichier | Description | Audience |
|---------|-------------|----------|
| **regles.md** | Source de vérité définissant les règles fondamentales du domaine | Équipe technique, métier |
| **specs.md** | Spécifications techniques d'implémentation | Équipe de développement |
| **validation.md** | Critères d'acceptation et scénarios de test | QA, Équipe technique |

## Navigation des Domaines

### [Adhésion](./adhesion/index.md)
Gestion des adhésions à l'association, permettant l'accès aux services du Circographe.
- [📜 Règles](./adhesion/regles.md) - Définition des types d'adhésion (Basic à 1€/an, Cirque à 10€/an), tarifs, validité, etc.
- [⚙️ Specs](./adhesion/specs.md) - Structure de données et implémentation technique
- [✅ Validation](./adhesion/validation.md) - Critères d'acceptation et scénarios de test

### [Cotisation](./cotisation/index.md)
Gestion des formules d'accès aux entraînements, disponibles uniquement pour les adhérents Cirque.
- [📜 Règles](./cotisation/regles.md) - Types de cotisation (séances uniques, cartes 10 séances, abonnements), tarification, droits d'accès
- [⚙️ Specs](./cotisation/specs.md) - Structure de données et implémentation technique
- [✅ Validation](./cotisation/validation.md) - Critères d'acceptation et scénarios de test

### [Paiement](./paiement/index.md)
Gestion des transactions financières pour les adhésions, cotisations et dons à l'association.
- [📜 Règles](./paiement/regles.md) - Méthodes de paiement, reçus, remboursements, reçus fiscaux pour les dons
- [⚙️ Specs](./paiement/specs.md) - Structure de données et implémentation technique
- [✅ Validation](./paiement/validation.md) - Critères d'acceptation et scénarios de test

### [Présence](./presence/index.md)
Système de pointage et contrôle d'accès aux entraînements, avec statistiques de fréquentation.
- [📜 Règles](./presence/regles.md) - Pointage, listes de présence, règles d'accès, gestion de la capacité
- [⚙️ Specs](./presence/specs.md) - Structure de données et implémentation technique
- [✅ Validation](./presence/validation.md) - Critères d'acceptation et scénarios de test

### [Rôles](./roles/index.md)
Gestion des permissions système et des fonctions associatives au sein de l'organisation.
- [📜 Règles](./roles/regles.md) - Hiérarchie et définition des rôles (membre, bénévole, administrateur, etc.), permissions
- [⚙️ Specs](./roles/specs.md) - Structure de données et implémentation technique
- [✅ Validation](./roles/validation.md) - Critères d'acceptation et scénarios de test

### [Notification](./notification/index.md)
Système de communication automatisée avec les membres pour les informer des événements importants.
- [📜 Règles](./notification/regles.md) - Types de notification (rappels d'échéance, confirmations, alertes), déclencheurs, contenu
- [⚙️ Specs](./notification/specs.md) - Structure de données et implémentation technique
- [✅ Validation](./notification/validation.md) - Critères d'acceptation et scénarios de test

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

### Exemples d'interdépendances clés:

- Une **Adhésion Cirque** valide est nécessaire pour souscrire à une **Cotisation**
- Le **Paiement** valide une **Adhésion** ou une **Cotisation**
- La **Présence** vérifie les droits d'accès via l'**Adhésion** et la **Cotisation**
- Les **Rôles** déterminent qui peut gérer les **Présences** et les **Paiements**
- Les **Notifications** sont déclenchées par des événements dans tous les autres domaines

## Navigation Globale

- [⬅️ Retour aux requirements](../)
- [📁 Documentation Utilisateur](../../docs/utilisateur/) - Guides pour les utilisateurs finaux
- [📁 Documentation Métier](../../docs/business/) - Documentation pour les parties prenantes
- [📁 Documentation Technique](../../docs/architecture/) - Schémas et diagrammes

---

<div align="center">
  <p>
    <a href="../../profile/README.md">⬅️ Retour à l'accueil</a> | 
    <a href="#domaines-métier-du-circographe">⬆️ Haut de page</a>
  </p>
</div>

*Dernière mise à jour : Mars 2023*

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