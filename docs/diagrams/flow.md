```mermaid
graph TD
    %% Utilisateurs et Rôles
    subgraph Rôles
        U[Utilisateur] --> M[Membre]
        M --> V[Bénévole]
        V --> A[Admin]
        
        U:::guest
        M:::member
        V:::volunteer
        A:::admin
    end

    %% Adhésions et Cotisations
    subgraph Adhésions & Cotisations
        MB[Adhésion Basic 1€/an]
        MC[Adhésion Cirque 10€/an]
        
        subgraph Cotisations
            S1[Séance 4€]
            S2[Carnet 10 35€]
            S3[Trimestre 90€]
            S4[Annuel 300€]
        end
    end

    %% Paiements
    subgraph Paiements
        P1[CB/SumUp]
        P2[Espèces]
        P3[Chèque]
        DON[Donation]
        INST[Paiement échelonné]
    end

    %% Présences
    subgraph Listes de Présence
        DL[Liste Entraînement]
        EL[Liste Événement]
        ML[Liste Réunion]
        AT[Présence]
        STAT[Statistiques]
    end

    %% Relations
    M --> MB
    MB --> MC
    MC --> S1
    MC --> S2
    MC --> S3
    MC --> S4
    
    %% Paiements
    MB --> P1
    MB --> P2
    MB --> P3
    MC --> P1
    MC --> P2
    MC --> P3
    S2 --> INST
    S3 --> INST
    S4 --> INST
    P1 --> DON
    P2 --> DON
    P3 --> DON

    %% Gestion Présences
    V --> DL
    V --> EL
    A --> ML
    DL --> AT
    EL --> AT
    ML --> AT
    AT --> STAT

    %% Styles
    classDef guest fill:#f9f,stroke:#333
    classDef member fill:#bbf,stroke:#333
    classDef volunteer fill:#bfb,stroke:#333
    classDef admin fill:#fbb,stroke:#333
    
    style MB fill:#dfd,stroke:#333
    style MC fill:#dfd,stroke:#333
    style S1 fill:#ffd,stroke:#333
    style S2 fill:#ffd,stroke:#333
    style S3 fill:#ffd,stroke:#333
    style S4 fill:#ffd,stroke:#333
    style DON fill:#fdb,stroke:#333
    style STAT fill:#ddf,stroke:#333 