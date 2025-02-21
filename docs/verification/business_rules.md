# Vérification des Règles Métier

## Adhésions et Rôles
| Règle | Implémentation | Status | Priorité |
|-------|----------------|--------|----------|
| Types d'adhésion (Basic/Circus) | User#membership_type enum | ✅ | P0 |
| Validation adhésion Basic avant Circus | Membership#validate_basic_requirement | ✅ | P0 |
| Tarifs réduits avec justificatif | Membership#apply_discount | ❌ | P1 |
| Gestion des rôles (Member/Volunteer/Admin) | User#roles association | ✅ | P0 |

## Présence et Listes
| Règle | Implémentation | Status | Priorité |
|-------|----------------|--------|----------|
| Liste quotidienne automatique | DailyAttendanceList.generate_daily | ✅ | P0 |
| Permissions par type de liste | DailyAttendanceList#can_checkin? | ✅ | P0 |
| Décompte des séances | Attendance#decrement_subscription | ✅ | P0 |
| Gestion des exceptions (fermetures) | ScheduleException model | ❌ | P1 |

## Paiements et Reçus
| Règle | Implémentation | Status | Priorité |
|-------|----------------|--------|----------|
| Validation des montants | Payment#validate_amounts | ✅ | P0 |
| Gestion des dons | Payment#handle_donation | ✅ | P0 |
| Génération des reçus | ReceiptService.generate | ❌ | P1 |
| Historique des transactions | PaymentHistory model | ✅ | P0 | 