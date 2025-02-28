# Domaine Métier : Rôles

## Vue d'ensemble

Le domaine de rôles définit les règles, les spécifications techniques et les critères de validation concernant la gestion des rôles utilisateurs et des permissions d'accès au Circographe.

## Contenu du dossier

### [📜 Règles Métier](requirements/1_métier/adhesion/regles.md)
Source de vérité définissant les règles fondamentales des rôles:
- Hiérarchie des rôles système
- Fonctions associatives
- Attribution des permissions
- Règles d'escalade et délégation

### [⚙️ Spécifications Techniques](requirements/1_métier/adhesion/specs.md)
Documentation technique pour l'implémentation:
- Modèles de données
- Système d'autorisation
- Gestion des permissions
- Politiques d'accès

### [✅ Validation](requirements/1_métier/adhesion/validation.md)
Critères de validation pour garantir la conformité:
- Scénarios de test des permissions
- Matrice de rôles et fonctionnalités
- Tests de sécurité
- Plan de validation

## Concepts Clés

- **Rôle système**: Ensemble de permissions techniques (Admin, Secrétaire, Trésorier)
- **Fonction associative**: Rôle dans l'association indépendant des permissions système
- **Permission**: Droit d'effectuer une action spécifique dans l'application
- **Politique d'accès**: Règle définissant qui peut faire quoi et dans quelles circonstances

## Interdépendances

- **Adhésion**: Les types d'adhésion influencent les rôles disponibles
- **Présence**: Certains rôles permettent la gestion des listes de présence
- **Paiement**: Rôles spécifiques pour la gestion financière
- **Notification**: Alertes liées aux changements de rôles

## Navigation

- [⬅️ Retour aux domaines métier](/requirements/1_métier/)
- [📜 Règles des Rôles](requirements/1_métier/adhesion/regles.md)
- [⚙️ Spécifications Techniques](requirements/1_métier/adhesion/specs.md)
- [✅ Validation](requirements/1_métier/adhesion/validation.md)

## Documents liés

### Documentation technique
- [📝 Diagramme de permissions](../..../../docs/architecture/diagrams/roles_permissions.md)
- [📝 Matrice d'autorisation](../../docs/architecture/matrices/authorization_matrix.md)

### Documentation utilisateur
- [📘 Guide des Rôles](/docs/business/regles/roles_systeme.md) - Explication pour les administrateurs
- [📗 Guide des Fonctions](/docs/utilisateur/guides/fonctions_association.md) - Rôles associatifs

## Relations avec les autres domaines

Le domaine des rôles interagit directement avec les domaines suivants:

### [Domaine Adhésion](requirements/1_métier/adhesion/index.md)
- Vérification du statut d'adhésion pour l'attribution de certains rôles
- Conditions d'adhésion spécifiques pour certains rôles (ex: adhésion Cirque obligatoire pour les bénévoles)

### [Domaine Présence](requirements/1_métier/adhesion/index.md)
- Permissions différentes selon les rôles pour la gestion des listes de présence
- Accès aux statistiques et rapports selon le rôle

### [Domaine Paiement](requirements/1_métier/adhesion/index.md)
- Autorisations de gestion des paiements selon les rôles
- Accès aux fonctionnalités financières basé sur les rôles

### [Domaine Cotisation](requirements/1_métier/adhesion/index.md)
- Certains rôles peuvent créer ou modifier des cotisations
- Permissions spéciales pour appliquer des réductions ou des offres spéciales

### [Domaine Notification](requirements/1_métier/adhesion/index.md)
- Certains rôles reçoivent des notifications spécifiques
- Rôles administratifs peuvent configurer les paramètres de notification
- Alertes lors des changements de rôles dans le système 