# DailyAttendanceList Model

## Validations
```ruby
validates :date, presence: true
validates :list_type, presence: true
validates :title, presence: true
validates :date, uniqueness: { 
  scope: [:list_type, :title],
  message: "Une liste avec ce titre existe déjà pour cette date et ce type" 
}
```

## États Possibles
1. Created (initial)
2. Active (ouvert aux pointages)
3. Closed (fermé, historique)

## Permissions
- Training : Bénévoles et Admins
- Event : Bénévoles et Admins
- Meeting : Admins uniquement 