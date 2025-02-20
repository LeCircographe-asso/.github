stateDiagram-v2
    [*] --> Created: Création automatique/manuelle
    Created --> Active: Ouverture
    Active --> Closed: Fermeture
    
    state Active {
        [*] --> Empty
        Empty --> HasAttendees: Premier check-in
        HasAttendees --> Full: Capacité atteinte
        Full --> HasAttendees: Départ
        HasAttendees --> Empty: Dernier départ
    }
    
    Closed --> [*] 