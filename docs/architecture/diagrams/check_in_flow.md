# Diagramme de Flux - Processus de Pointage

## Vue d'ensemble

Ce document décrit le flux de processus pour l'enregistrement des présences (check-in) dans le système du Circographe, incluant les différentes étapes et les règles de validation appliquées.

## Diagramme de Flux

```mermaid
flowchart TD
    Start([Début du Pointage]) --> A[Utilisateur accède à l'écran de pointage]
    A --> B{Utilisateur identifié?}
    B -->|Non| C[Identification par QR code, nom ou numéro]
    B -->|Oui| D[Vérification de l'adhésion]
    C --> D
    
    D --> E{Adhésion valide?}
    E -->|Non| F[Notification: Adhésion expirée/invalide]
    E -->|Oui| G[Vérification de la cotisation]
    
    G --> H{Cotisation active?}
    H -->|Non| I[Notification: Pas de cotisation active]
    H -->|Oui| J[Vérification des restrictions horaires]
    
    J --> K{Dans les horaires autorisés?}
    K -->|Non| L[Notification: Hors plage horaire]
    K -->|Oui| M[Enregistrement de la présence]
    
    M --> N[Mise à jour des statistiques]
    N --> O[Notification de confirmation]
    O --> End([Fin du Processus])
    
    F --> P[Redirection vers renouvellement]
    I --> Q[Redirection vers achat cotisation]
    L --> R[Information sur horaires autorisés]
    
    P --> End
    Q --> End
    R --> End
```

## Description des Étapes

1. **Début du Pointage**: Initiation du processus de pointage (par le bénévole à l'accueil)
2. **Identification**: Reconnaissance de l'utilisateur par divers moyens (QR code, recherche par nom, etc.)
3. **Vérification de l'Adhésion**: Contrôle de la validité de l'adhésion (expiration, statut)
4. **Vérification de la Cotisation**: Contrôle de l'existence d'une cotisation active
5. **Vérification des Restrictions Horaires**: Contrôle de la compatibilité avec la formule de cotisation
6. **Enregistrement**: Création de l'enregistrement de présence dans le système
7. **Mise à jour des Statistiques**: Actualisation des compteurs et statistiques liés aux présences
8. **Confirmation**: Notification visuelle et/ou sonore de confirmation du pointage

## Règles et Conditions

- Un utilisateur doit avoir une adhésion valide (non expirée, statut "actif")
- Un utilisateur doit avoir une cotisation active pour accéder aux entraînements
- Certaines formules de cotisation ont des restrictions horaires (jours, heures)
- Le système doit enregistrer l'horodatage précis de chaque pointage
- Les statistiques de présence doivent être mises à jour en temps réel

## Références

- [Règles du Domaine Présence](../../../requirements/1_métier/presence/regles.md)
- [Spécifications Techniques - Présence](../../../requirements/1_métier/presence/specs.md)
- [Matrice des Formules de Cotisation](../matrices/subscription_matrix.md)

---

*Dernière mise à jour: Mars 2023*
