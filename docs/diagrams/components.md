graph TB
    subgraph Frontend
        UI[Interface Utilisateur]
        Forms[Formulaires]
        Lists[Listes]
    end

    subgraph Backend
        API[API Controllers]
        Auth[Authentification]
        Perm[Permissions]
    end

    subgraph Services
        AttendanceService[Service Présence]
        MembershipService[Service Adhésion]
        NotificationService[Service Notification]
    end

    subgraph Database
        Users[(Users)]
        Memberships[(Memberships)]
        Attendances[(Attendances)]
        Lists[(AttendanceLists)]
    end

    UI --> Forms
    UI --> Lists
    Forms --> API
    Lists --> API
    API --> Auth
    API --> Perm
    Auth --> Services
    Perm --> Services
    Services --> Database 