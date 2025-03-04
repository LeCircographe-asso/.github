# États des Reçus

```mermaid
stateDiagram-v2
    [*] --> Generated: Création
    Generated --> Sent: Envoi email
    Generated --> Printed: Impression
    
    state Sent {
        [*] --> Delivered
        [*] --> Bounced
        Bounced --> Retried
        Retried --> Delivered
    }
    
    Printed --> Archived
    Sent --> Archived
    Archived --> [*]

    note right of Generated
        Types de reçu :
        * Adhésion
        * Abonnement
        * Don
        * Multiple
    end note
``` 