# États des Utilisateurs

```mermaid
stateDiagram-v2
    [*] --> Registered: Inscription
    Registered --> Basic: Adhésion Basic
    Basic --> Circus: Adhésion Cirque
    
    state Circus {
        [*] --> WithoutSubscription
        WithoutSubscription --> WithSubscription: Achat abonnement
        WithSubscription --> WithoutSubscription: Fin abonnement
    }
    
    Circus --> Basic: Expiration Cirque
    Basic --> Registered: Expiration Basic

    note right of Circus
        Rôles possibles :
        * Member
        * Volunteer
        * Admin
    end note
``` 