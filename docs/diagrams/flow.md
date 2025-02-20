graph TD
    subgraph Utilisateurs
        U[Utilisateur] --> M[Membre]
        M --> V[Bénévole]
        V --> A[Admin]
    end

    subgraph Adhésions
        MB[Adhésion Basic]
        MC[Adhésion Cirque]
        S[Abonnement]
    end

    subgraph Présence
        DL[Liste Quotidienne]
        EL[Liste Événement]
        ML[Liste Réunion]
        AT[Présence]
    end

    M --> MB
    MB --> MC
    MC --> S
    V --> DL
    V --> EL
    A --> ML
    DL --> AT
    EL --> AT
    ML --> AT

    style U fill:#f9f,stroke:#333
    style DL fill:#bbf,stroke:#333
    style AT fill:#bfb,stroke:#333 