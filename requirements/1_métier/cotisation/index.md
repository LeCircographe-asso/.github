# Domaine Métier : Cotisation

## Vue d'ensemble

Le domaine de cotisation définit les règles, les spécifications techniques et les critères de validation concernant les cotisations et formules d'accès aux entraînements du Circographe.

## Contenu du dossier

### [📜 Règles Métier](./regles.md)
Source de vérité définissant les règles fondamentales des cotisations:
- Types de cotisations (mensuelle, trimestrielle, etc.)
- Tarifs et conditions
- États et transitions
- Calcul des périodes de validité

### [⚙️ Spécifications Techniques](./specs.md)
Documentation technique pour l'implémentation:
- Modèles de données
- Validations
- Services
- API et endpoints

### [✅ Validation](./validation.md)
Critères de validation pour garantir la conformité:
- Scénarios de test
- Cas limites
- Critères d'acceptation
- Plan de tests

## Concepts Clés

- **Cotisation Mensuelle**: Accès illimité pendant un mois calendaire
- **Cotisation Trimestrielle**: Accès illimité pendant trois mois consécutifs
- **Cotisation à la Carte**: Accès pour un nombre défini de séances
- **Période de validité**: Durée pendant laquelle l'accès est autorisé

## Interdépendances

- **Adhésion**: Nécessite une adhésion Cirque valide
- **Paiement**: Validation du paiement pour activer une cotisation
- **Présence**: Vérification de la cotisation pour chaque accès
- **Notification**: Rappels pour expiration et renouvellement

## Navigation

- [⬅️ Retour aux domaines métier](../index.md)
- [📜 Règles de Cotisation](./regles.md)
- [⚙️ Spécifications Techniques](./specs.md)
- [✅ Validation](./validation.md)

## Documents liés

### Documentation technique
- [📝 Diagramme d'états](../../../docs/architecture/diagrams/subscription_states.md)
- [📝 Spécifications API](../../2_specifications_techniques/api/subscription_api.md)

### Documentation utilisateur
- [📘 Guide des Cotisations](../../../docs/business/regles/cotisation.md) - Explication accessible des cotisations
- [📗 Guide Cotisation - Membres](../../../docs/utilisateur/guides/cotisation_membre.md) - Guide utilisateur 

## Relations avec les autres domaines

Le domaine de cotisation interagit directement avec les domaines suivants:

### [Domaine Adhésion](../adhesion/index.md)
- Vérification de l'adhésion Cirque valide avant création d'une cotisation
- Une cotisation ne peut être activée que si l'adhésion est valide

### [Domaine Paiement](../paiement/index.md)
- Validation des paiements pour activer les cotisations
- Gestion des remboursements en cas d'annulation

### [Domaine Présence](../presence/index.md)
- Vérification de la validité des cotisations pour autoriser l'accès
- Décompte des entrées pour les cotisations à la carte

### [Domaine Notification](../notification/index.md)
- Envoi de rappels avant expiration de cotisation
- Notification de validation après paiement
- Alerte lorsqu'un carnet approche de sa fin 