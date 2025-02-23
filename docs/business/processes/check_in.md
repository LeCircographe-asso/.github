sequenceDiagram
    participant B as Bénévole
    participant S as Système
    participant L as Liste
    participant U as Utilisateur
    participant A as Abonnement

    B->>S: Scan carte membre
    S->>U: Vérifie adhésion
    U-->>S: Statut adhésion
    S->>A: Vérifie abonnement
    A-->>S: Statut abonnement
    S->>L: Vérifie présence
    L-->>S: Statut présence
    
    alt Tout est valide
        S->>L: Ajoute présence
        L->>A: Décompte séance
        S-->>B: Confirmation
    else Erreur
        S-->>B: Message d'erreur
    end 