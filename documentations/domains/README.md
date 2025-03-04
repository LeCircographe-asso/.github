# Domaines Métier - Le Circographe

## Vue d'ensemble

Cette section documente les six domaines métier fondamentaux du Circographe. Chaque domaine est une unité fonctionnelle cohérente avec ses propres règles, spécifications et critères de validation.

## Structure de la documentation

Chaque domaine métier est documenté selon la structure suivante :

- **README.md** - Vue d'ensemble et spécifications techniques
- **rules.md** - Règles métier détaillées
- **specs.md** - Spécifications techniques détaillées
- **validation.md** - Critères de validation

## Domaines métier

| Domaine | Description | Documentation |
|---------|-------------|---------------|
| **Adhésion** | Gestion des adhérents et de leur statut | [Spécifications Adhésion](adhesion/README.md) |
| **Cotisation** | Gestion des cotisations et des tarifs | [Spécifications Cotisation](cotisation/README.md) |
| **Paiement** | Gestion des paiements et des factures | [Spécifications Paiement](paiement/README.md) |
| **Présence** | Gestion des présences aux activités | [Spécifications Présence](presence/README.md) |
| **Rôles** | Gestion des rôles et des permissions | [Spécifications Rôles](roles/README.md) |
| **Notification** | Gestion des notifications et des communications | [Spécifications Notification](notification/README.md) |

## Interactions entre domaines

Les domaines métier interagissent entre eux de manière cohérente :

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   Adhésion  │◄────►│  Cotisation │◄────►│   Paiement  │
└─────┬───────┘      └──────┬──────┘      └──────┬──────┘
      │                     │                    │
      │                     ▼                    │
      │              ┌─────────────┐             │
      └─────────────►│   Présence  │◄────────────┘
                     └──────┬──────┘
                            │
┌─────────────┐             │             ┌─────────────┐
│    Rôles    │◄────────────┼────────────►│ Notification│
└─────────────┘             │             └─────────────┘
                            ▼
                    ┌───────────────┐
                    │ Fonctionnalités│
                    │ transversales  │
                    └───────────────┘
```

## Cas d'usage transversaux

Certains cas d'usage traversent plusieurs domaines métier :

1. **Inscription d'un nouveau membre** : Adhésion → Paiement → Notification
2. **Renouvellement d'adhésion** : Adhésion → Paiement → Notification
3. **Achat d'une cotisation** : Cotisation → Paiement → Notification
4. **Participation à un entraînement** : Présence → Cotisation → Notification
5. **Gestion des accès** : Rôles → Adhésion → Notification

## Ressources supplémentaires

- [Règles métier globales](../admin/business_rules.md) - Règles fondamentales régissant l'application
- [Glossaire](../glossary.md) - Définitions des termes techniques et métier
- [Documentation technique](../technical/README.md) - Architecture et implémentation

---

*Dernière mise à jour: Mars 2023*
