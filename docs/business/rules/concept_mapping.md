# Mapping des Concepts

## Adhésions et Abonnements

### Types d'Adhésion
| Concept | Implementation | Interface |
|---------|---------------|-----------|
| Adhésion Basic | BasicMembership | "Adhésion Basic" |
| Adhésion Cirque | CircusMembership | "Adhésion Cirque" |
| Abonnement | Subscription | "Carnet de séances" |

### États
| État | Description | Méthodes |
|------|-------------|----------|
| Actif | Adhésion en cours de validité | `membership.active?` |
| Expiré | Adhésion terminée | `membership.expired?` |
| En attente | Adhésion future | `membership.pending?` |

## Présence

### Types de Liste
| Type | Classe | Permissions |
|------|---------|------------|
| Entraînement | DailyAttendanceList.training | Bénévoles, Admins |
| Événement | DailyAttendanceList.event | Bénévoles, Admins |
| Réunion | DailyAttendanceList.meeting | Admins |

### Actions
| Action UI | Méthode | Service |
|-----------|---------|---------|
| "Pointer" | check_in | AttendanceService |
| "Dépointer" | check_out | AttendanceService |
| "Valider" | validate | AttendanceService |

## Paiements

### Méthodes
| UI | Base de données | Reçu |
|-------|----------------|-------|
| "Espèces" | CASH | ESP |
| "Carte" | CARD | CB |
| "Chèque" | CHECK | CHQ |

### Types
| Type | Classe | Validation |
|------|---------|------------|
| Adhésion | MembershipPayment | MembershipPaymentValidator |
| Abonnement | SubscriptionPayment | SubscriptionPaymentValidator |
| Don | Donation | DonationValidator 