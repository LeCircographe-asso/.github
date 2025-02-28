# Domaine Métier : Adhésion

## Vue d'ensemble

Le domaine d'adhésion définit les règles, les spécifications techniques et les critères de validation concernant les adhésions au Circographe.

## Contenu du dossier

### [📜 Règles Métier](requirements/1_métier/adhesion/regles.md)
Source de vérité définissant les règles fondamentales des adhésions:
- Types d'adhésion (Basic, Cirque)
- Tarifs et conditions
- États et transitions
- Processus d'adhésion

### [⚙️ Spécifications Techniques](requirements/1_métier/adhesion/specs.md)
Documentation technique pour l'implémentation:
- Modèles de données
- Validations
- Services
- API et endpoints

### [✅ Validation](requirements/1_métier/adhesion/validation.md)
Critères de validation pour garantir la conformité:
- Scénarios de test
- Cas limites
- Critères d'acceptation
- Plan de tests

## Concepts Clés

- **Adhésion Basic**: Adhésion de base à 1€/an donnant accès aux événements
- **Adhésion Cirque**: Adhésion complète à 10€/an (ou 7€ tarif réduit) permettant l'accès aux entraînements
- **Cycle d'adhésion**: Processus complet depuis la création jusqu'à l'expiration
- **Upgrade**: Passage d'une adhésion Basic à une adhésion Cirque

## Interdépendances

- **Paiement**: Validation du paiement pour activer une adhésion
- **Cotisation**: Nécessite une adhésion Cirque valide
- **Présence**: Vérification de l'adhésion pour l'accès
- **Rôles**: Droits spécifiques liés au type d'adhésion

## Navigation

- [⬅️ Retour aux domaines métier](/requirements/1_métier/)
- [📜 Règles d'Adhésion](requirements/1_métier/adhesion/regles.md)
- [⚙️ Spécifications Techniques](requirements/1_métier/adhesion/specs.md)
- [✅ Validation](requirements/1_métier/adhesion/validation.md)

## Documents liés

### Documentation technique
- [📝 Diagramme d'états](docs/architecture/diagrams/membership_states.md)
- [📝 Spécifications API](requirements/2_specifications_techniques/api/membership_api.md)

### Documentation utilisateur
- [📘 Guide des Adhésions](docs/business/regles/adhesion.md) - Explication accessible des adhésions
- [📗 Guide d'Adhésion - Membres](docs/utilisateur/guides/adhesion_membre.md) - Guide utilisateur 

## Relations avec les autres domaines

Le domaine d'adhésion interagit directement avec les domaines suivants:

### [Domaine Paiement](requirements/1_métier/adhesion/index.md)
- Validation des paiements pour activer les adhésions
- Différents tarifs selon le type d'adhésion (Basic, Cirque, tarif réduit)

### [Domaine Cotisation](requirements/1_métier/adhesion/index.md)
- Une adhésion Cirque valide est requise pour souscrire à une cotisation
- L'expiration d'une adhésion peut suspendre les cotisations associées

### [Domaine Présence](requirements/1_métier/adhesion/index.md)
- Vérification de l'adhésion pour autoriser l'accès aux activités
- Type d'adhésion déterminant l'accès à différents types d'événements

### [Domaine Rôles](requirements/1_métier/adhesion/index.md)
- Certains rôles nécessitent un type d'adhésion spécifique
- Gestion des droits d'accès basée sur le statut d'adhésion

### [Domaine Notification](requirements/1_métier/adhesion/index.md)
- Envoi de bienvenue aux nouveaux adhérents
- Rappels avant expiration d'adhésion
- Notifications de validation après paiement 