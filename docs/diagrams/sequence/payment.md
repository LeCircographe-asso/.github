sequenceDiagram
    participant B as Bénévole
    participant S as Système
    participant U as Utilisateur
    participant P as Paiement
    participant M as Membership/Subscription

    B->>S: Scan carte membre
    S->>U: Vérifie utilisateur
    U-->>S: Info utilisateur
    
    B->>S: Sélectionne type (adhésion/abonnement)
    B->>S: Entre montant
    B->>S: Sélectionne méthode paiement
    
    alt Tarif réduit
        B->>S: Indique justificatif
        S->>S: Applique réduction
    end
    
    S->>P: Crée paiement
    P->>M: Crée/Renouvelle adhésion/abonnement
    S-->>B: Génère reçu
    
    alt Don supplémentaire
        B->>S: Ajoute montant don
        S->>P: Enregistre don
        S-->>B: Met à jour reçu
    end 