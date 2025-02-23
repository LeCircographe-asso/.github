# États des Abonnements

```mermaid
stateDiagram-v2
    [*] --> Created: Création
    Created --> Active: Paiement validé
    Active --> Suspended: Adhésion expirée
    Active --> Depleted: Plus de séances
    Active --> Cancelled: Annulation admin
    
    Suspended --> Active: Adhésion renouvelée
    Depleted --> [*]
    Cancelled --> [*]

    note right of Active
        Décompte des séances :
        * Carnet (10 séances)
        * Trimestriel (illimité)
        * Annuel (illimité)
    end note
``` 