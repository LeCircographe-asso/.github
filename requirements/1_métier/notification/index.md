# Domaine Métier : Notification

## Vue d'ensemble

Le domaine de notification définit les règles, les spécifications techniques et les critères de validation concernant toutes les communications automatisées envoyées aux membres du Circographe.

## Contenu du dossier

### [📜 Règles Métier](./regles.md)
Source de vérité définissant les règles fondamentales des notifications:
- Types de notifications
- Déclencheurs et conditions d'envoi
- Contenu et formatage
- Canaux de communication

### [⚙️ Spécifications Techniques](./specs.md)
Documentation technique pour l'implémentation:
- Modèles de données
- Services d'envoi
- Templates et personnalisation
- Gestion des files d'attente

### [✅ Validation](./validation.md)
Critères de validation pour garantir la conformité:
- Scénarios de test par type de notification
- Vérification de la livraison
- Tests des déclencheurs
- Validation des contenus

## Concepts Clés

- **Notification**: Message automatisé envoyé à un membre
- **Modèle de notification**: Template définissant le contenu et le format
- **Déclencheur**: Événement système qui initie l'envoi d'une notification
- **Canal de communication**: Moyen d'envoi (email, SMS, in-app)

## Interdépendances

- **Adhésion**: Notifications sur l'état et l'expiration des adhésions
- **Cotisation**: Rappels de renouvellement et confirmations
- **Paiement**: Reçus et confirmations de transactions
- **Présence**: Confirmations de participation et rappels

## Navigation

- [⬅️ Retour aux domaines métier](../index.md)
- [📜 Règles des Notifications](./regles.md)
- [⚙️ Spécifications Techniques](./specs.md)
- [✅ Validation](./validation.md)

## Documents liés

### Documentation technique
- [📝 Diagramme de flux](../../../docs/architecture/diagrams/notification_flow.md)
- [📝 Modèles de messages](../../../docs/architecture/templates/notification_templates.md)

### Documentation utilisateur
- [📘 Guide des Notifications](../../../docs/business/regles/notifications.md) - Configuration pour les administrateurs
- [📗 Guide de Communication](../../../docs/utilisateur/guides/preferences_communication.md) - Préférences pour les membres

## Relations avec les autres domaines

Le domaine des notifications interagit directement avec les domaines suivants:

### [Domaine Adhésion](../adhesion/index.md)
- Notifications de bienvenue aux nouveaux membres
- Rappels d'échéance pour les adhésions expirant prochainement
- Confirmations de renouvellement d'adhésion

### [Domaine Cotisation](../cotisation/index.md)
- Notifications d'achat de nouvelles cotisations
- Rappels d'échéance pour les abonnements
- Alertes sur le nombre de séances restantes dans un carnet

### [Domaine Paiement](../paiement/index.md)
- Confirmations de paiement
- Reçus électroniques
- Rappels de paiements en attente

### [Domaine Présence](../presence/index.md)
- Confirmation d'enregistrement de présence
- Alertes de capacité maximale atteinte
- Statistiques périodiques de fréquentation (pour les administrateurs)

### [Domaine Rôles](../roles/index.md)
- Notifications spécifiques selon les rôles des utilisateurs
- Alertes aux administrateurs pour les actions nécessitant attention
- Notifications de changement de rôle ou de privilèges 