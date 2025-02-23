# Processus d'Adhésion 👥

## Diagramme du Processus

```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant F as Frontend
    participant C as Controller
    participant S as MembershipService
    participant M as Membership
    participant P as PaymentService
    participant N as NotificationService

    Note over U,N: Création Compte
    U->>F: Accède à l'inscription
    F->>C: POST /registrations
    C->>M: Crée User (role: none, membership: none)
    M-->>C: User créé
    C-->>F: Redirection accueil
    
    Note over U,N: Adhésion Basic (1€)
    U->>F: Demande adhésion Basic
    F->>C: POST /memberships
    C->>S: create_or_upgrade(type: basic)
    S->>M: Vérifie adhésions existantes
    M-->>S: Aucune adhésion active
    S->>M: Crée adhésion Basic
    M-->>S: Adhésion créée
    S->>P: Génère paiement (1€)
    P-->>S: Paiement créé
    S->>N: Envoie confirmation
    N-->>U: Email confirmation
    S-->>C: Succès
    C-->>F: Redirection profil
    
    Note over U,N: Option Adhésion Cirque (10€/7€)
    U->>F: Demande adhésion Cirque
    F->>C: POST /memberships/upgrade
    C->>S: create_or_upgrade(type: circus)
    S->>M: Vérifie adhésion Basic active
    M-->>S: Basic active confirmée
    alt Tarif Réduit Demandé
        S->>M: Vérifie justificatif
        M-->>S: Justificatif valide
        S->>P: Génère paiement (7€)
    else Tarif Normal
        S->>P: Génère paiement (10€)
    end
    P-->>S: Paiement créé
    S->>N: Envoie confirmation
    N-->>U: Email confirmation
    S-->>C: Succès
    C-->>F: Redirection profil

    Note over U,N: Validation Finale
    U->>F: Consulte profil
    F->>C: GET /profile
    C->>M: Récupère statut adhésions
    M-->>C: Statuts actifs
    C-->>F: Affiche statuts
    F-->>U: Affiche confirmation
```

## États et Transitions

### Types d'Adhésion
- **None** (0) : Compte créé sans adhésion
- **Basic** (1) : Adhésion basique (1€/an)
- **Circus** (2) : Adhésion cirque (10€/7€ avec tarif réduit)

### Conditions
1. **Adhésion Basic**
   - Requiert un compte vérifié
   - Paiement de 1€
   - Validité 1 an

2. **Adhésion Cirque**
   - Requiert une adhésion Basic active
   - Paiement de 10€ (ou 7€ avec justificatif)
   - Validité 1 an
   - Justificatif pour tarif réduit

### Tarifs Réduits
- **Conditions** : Étudiant, Chômeur, RSA, Mineur
- **Réduction** : 30% sur adhésion Cirque
- **Justificatif** obligatoire
- **Validation** par admin requise

## Validations

### Règles Métier
1. Une seule adhésion active par type
2. Adhésion Basic requise pour Cirque
3. Pas de chevauchement de dates
4. Renouvellement possible 30 jours avant expiration

### Vérifications Système
1. Unicité email/membre
2. Validité des dates
3. Justificatifs tarif réduit
4. Cohérence des paiements 