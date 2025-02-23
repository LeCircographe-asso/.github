# États des Listes de Présence

```mermaid
stateDiagram-v2
    [*] --> Created: Création (Auto/Manuel)
    Created --> Open: Ouverture créneau
    Open --> Closed: Fermeture créneau
    
    state Open {
        [*] --> Empty
        Empty --> HasAttendees: Premier pointage
        HasAttendees --> Full: Capacité atteinte
    }
    
    Closed --> [*]

    note right of Open
        Types de liste :
        * Entraînement (auto)
        * Événement (manuel)
        * Réunion (admin)
    end note 