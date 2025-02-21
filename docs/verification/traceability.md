# Matrice de Traçabilité

## Modèles et Services
| Composant | Fichier Source | Tests | Documentation |
|-----------|----------------|-------|---------------|
| User | models/user.rb | ✅ | ✅ |
| Membership | models/membership.rb | ✅ | ✅ |
| DailyAttendanceList | models/daily_attendance_list.rb | ✅ | ✅ |
| Payment | models/payment.rb | ✅ | ✅ |
| AttendanceService | services/attendance_service.rb | ✅ | ✅ |
| PaymentService | services/payment_service.rb | ✅ | ✅ |
| NotificationService | services/notification_service.rb | ❌ | ✅ |
| ReceiptService | services/receipt_service.rb | ❌ | ❌ |

## Points d'Attention
1. **Haute Priorité**
   - Implémentation ReceiptService
   - Tests NotificationService
   - Gestion des exceptions

2. **Moyenne Priorité**
   - Documentation API
   - Tests d'intégration
   - Monitoring

3. **Basse Priorité**
   - Optimisations performance
   - Documentation utilisateur
   - Internationalisation

## Adhésions
| Règle Métier | Spécification Technique | Implémentation | Status |
|--------------|------------------------|----------------|---------|
| Adhésion Basic requise | Membership#validate_basic_requirement | models/membership.rb | ✅ |
| Tarif réduit avec justificatif | Membership#apply_discount | models/membership.rb | ✅ |
| Une seule adhésion active | Membership#validate_uniqueness | models/membership.rb | ✅ |

## Présence
| Règle Métier | Spécification Technique | Implémentation | Status |
|--------------|------------------------|----------------|---------|
| Liste quotidienne | DailyAttendanceList.generate_daily | services/attendance_service.rb | ✅ |
| Permissions par type | DailyAttendanceList#can_checkin? | models/daily_attendance_list.rb | ✅ |
| Décompte séances | Attendance#decrement_subscription | services/attendance_service.rb | ✅ |

## Paiements
| Règle Métier | Spécification Technique | Implémentation | Status |
|--------------|------------------------|----------------|---------|
| Validation montants | Payment#validate_amounts | models/payment.rb | ✅ |
| Gestion dons | Payment#handle_donation | services/payment_service.rb | ✅ |
| Génération reçus | ReceiptService.generate | services/receipt_service.rb | ❌ | 