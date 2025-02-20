stateDiagram-v2
    [*] --> Created: Création automatique/manuelle
    Created --> Active: Ouverture
    Active --> Closed: Fermeture
    
    state Active {
        [*] --> Empty
        Empty --> HasAttendees: Premier check-in
        HasAttendees --> Empty: Dernier départ
    }
    
    Closed --> [*]

    note right of Active
        Une liste peut avoir
        un nombre illimité
        de participants
    end note 