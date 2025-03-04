# Le Circographe - Documentation Technique et Métier

## Vue d'ensemble

Le Circographe est une application de gestion pour les associations de cirque, développée avec Ruby on Rails 8.0.1. Cette documentation est principalement destinée aux développeurs et aux administrateurs qui définissent les règles métier de l'application.

## Documentation pour les développeurs

| Je veux... | Consulter... |
|------------|--------------|
| **Comprendre l'architecture** | [Architecture du système](technical/README.md#architecture-de-lapplication) |
| **Explorer les modèles de données** | [Modèles et relations](technical/README.md#modèles-de-données) |
| **Configurer mon environnement** | [Guide d'installation](technical/README.md#installation) |
| **Comprendre les flux de travail** | [Workflows de développement](technical/README.md#workflows-de-développement) |
| **Implémenter une fonctionnalité** | [Guide d'implémentation](technical/README.md#bonnes-pratiques) |
| **Explorer l'API** | [Documentation API](technical/README.md#api-restful) |

## Spécifications métier

| Domaine | Description | Documentation |
|---------|-------------|---------------|
| **Adhésion** | Gestion des adhérents et de leur statut | [Spécifications Adhésion](domains/adhesion/README.md) |
| **Cotisation** | Gestion des cotisations et des tarifs | [Spécifications Cotisation](domains/cotisation/README.md) |
| **Paiement** | Gestion des paiements et des factures | [Spécifications Paiement](domains/paiement/README.md) |
| **Présence** | Gestion des présences aux activités | [Spécifications Présence](domains/presence/README.md) |
| **Rôles** | Gestion des rôles et des permissions | [Spécifications Rôles](domains/roles/README.md) |
| **Notification** | Gestion des notifications et des communications | [Spécifications Notification](domains/notification/README.md) |

## Règles d'administration

| Aspect | Description | Documentation |
|--------|-------------|---------------|
| **Règles métier** | Règles fondamentales régissant l'application | [Règles métier globales](admin/business_rules.md) |
| **Validation des données** | Critères de validation pour chaque entité | [Critères de validation](admin/validation_criteria.md) ⚠️ |
| **Workflows administratifs** | Processus de gestion de l'application | [Workflows administratifs](admin/workflows.md) ⚠️ |
| **Configuration système** | Paramètres de configuration de l'application | [Guide de configuration](admin/configuration.md) ⚠️ |
| **Rapports et analyses** | Génération et interprétation des rapports | [Guide des rapports](admin/reporting.md) ⚠️ |

## Ressources techniques

- [Stack technique](technical/README.md#stack-technique) - Description détaillée des technologies utilisées
- [Diagrammes techniques](technical/README.md#diagramme-de-classes) - Diagrammes d'architecture, de classes et de séquence
- [Modèles de données](technical/README.md#modèles-de-données) - Description détaillée des modèles et relations
- [Guide de style](technical/README.md#style-de-code) - Conventions de codage et bonnes pratiques

## Documentation utilisateur

La documentation destinée aux utilisateurs finaux est disponible dans la section [Guide utilisateur](guide/). Elle est secondaire par rapport à la documentation technique et métier.

## Ressources supplémentaires

- [Glossaire](glossary.md) - Définitions des termes techniques et métier
- [FAQ Développeurs](technical/README.md#ressources-supplémentaires) - Questions fréquemment posées par les développeurs
- [FAQ Administrateurs](admin/faq.md) ⚠️ - Questions fréquemment posées par les administrateurs

## ⚠️ Fichiers manquants à créer

Les fichiers suivants sont référencés mais n'existent pas encore :

1. **Dossier admin** :
   - `admin/validation_criteria.md`
   - `admin/workflows.md`
   - `admin/configuration.md`
   - `admin/reporting.md`
   - `admin/faq.md`

2. **Dossier assets** :
   - Le dossier `assets/diagrams/` est manquant

3. **Guides utilisateur** :
   - Les guides spécifiques dans `guide/admin/` et `guide/member/` doivent être créés

---

*Dernière mise à jour: Mars 2023* 