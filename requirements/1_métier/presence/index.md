# Domaine Métier : Présence

## Vue d'ensemble

Le domaine de présence définit les règles, les spécifications techniques et les critères de validation concernant l'enregistrement des présences aux entraînements et la gestion des accès au Circographe.

## Contenu du dossier

### [📜 Règles Métier](../adhesion/regles.md)
Source de vérité définissant les règles fondamentales des présences:
- Processus de pointage (check-in/check-out)
- Gestion des listes quotidiennes
- Contrôle des accès
- Calcul des statistiques

### [⚙️ Spécifications Techniques](../adhesion/specs.md)
Documentation technique pour l'implémentation:
- Modèles de données
- Algorithmes de validation d'accès
- Génération des rapports
- Système de pointage

### [✅ Validation](../adhesion/validation.md)
Critères de validation pour garantir la conformité:
- Scénarios de test des présences
- Cas d'utilisation spécifiques
- Tests de performance
- Plan de validation

## Concepts Clés

- **Pointage**: Enregistrement de l'entrée/sortie d'un adhérent
- **Liste de présence**: Ensemble des adhérents présents sur un créneau
- **Accès autorisé**: Validation de l'autorisation d'entrée selon l'adhésion et la cotisation
- **Rapport de fréquentation**: Statistiques d'utilisation des créneaux

## Interdépendances

- **Adhésion**: Vérification de l'adhésion valide
- **Cotisation**: Contrôle des droits d'accès selon la formule
- **Rôles**: Permissions pour la gestion des listes et validation des accès
- **Notification**: Alertes en cas d'accès refusé ou expiration prochaine

## Navigation

- [⬅️ Retour aux domaines métier](..)
- [📜 Règles de Présence](../adhesion/regles.md)
- [⚙️ Spécifications Techniques](../adhesion/specs.md)
- [✅ Validation](../adhesion/validation.md)

## Documents liés

### Documentation technique
- [📝 Diagramme de flux](../../../docs/architecture/diagrams/check_in_flow.md)
- [📝 Formats des rapports](../..../../docs/architecture/reports/attendance_reports.md)

### Documentation utilisateur
- [📘 Guide de Pointage](docs/business/regles/pointage.md) - Procédures pour les administrateurs
- [📗 Guide d'Accès](docs/utilisateur/guides/acces_entrainement.md) - Guide pour les membres

## Relations avec les autres domaines

Le domaine de présence interagit directement avec les domaines suivants:

### [Domaine Adhésion](../adhesion/index.md)
- Vérification de la validité des adhésions lors de l'enregistrement des présences
- Lien entre les membres et leurs enregistrements de présence

### [Domaine Cotisation](../adhesion/index.md)
- Utilisation des cotisations lors de l'enregistrement des présences
- Décompte des entrées pour les carnets de séances
- Vérification de la validité des abonnements

### [Domaine Paiement](../adhesion/index.md)
- Vérification des paiements pour accéder aux entraînements
- Possibilité de paiement à l'entrée (Pass Journée)

### [Domaine Rôles](../adhesion/index.md)
- Différents niveaux d'accès aux fonctionnalités de gestion des présences selon les rôles
- Certains rôles peuvent valider ou modifier les listes de présence

### [Domaine Notification](../adhesion/index.md)
- Notifications de confirmation de présence aux adhérents
- Alertes aux administrateurs en cas de problème d'accès
- Rappels automatiques basés sur les habitudes de fréquentation 