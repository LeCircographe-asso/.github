# Architecture des Modèles

## User
```ruby
class User
  # Attributs principaux
  - email: string, unique
  - first_name: string
  - last_name: string
  - phone: string
  - member_number: string # Format: YYT0001
  - birthdate: date
  - address: text
  - emergency_contact: string
  - emergency_phone: string
  - active: boolean

  # Relations
  has_many :roles
  has_many :memberships
  has_many :subscriptions
  has_many :payments
  has_many :donations
  has_many :attendances
end
```

## Role
```ruby
class Role
  # Attributs
  - user_id: references
  - role_type: enum [:member, :volunteer, :admin, :super_admin]
  - active: boolean
  - assigned_at: datetime
  - assigned_by_id: references

  # Relations
  belongs_to :user
  belongs_to :assigned_by, class_name: 'User'
end
```

## Membership
```ruby
class Membership
  # Attributs
  - user_id: references
  - type: enum [:basic, :circus]
  - start_date: date
  - end_date: date
  - price_paid: decimal
  - reduced_price: boolean
  - reduction_reason: string
  - active: boolean

  # Relations
  belongs_to :user
  has_many :payments, as: :payable
end
```

## Subscription
```ruby
class Subscription
  # Attributs
  - user_id: references
  - type: enum [:daily, :pack_10, :trimester, :annual]
  - start_date: date
  - end_date: date
  - entries_count: integer
  - entries_left: integer
  - price_paid: decimal
  - active: boolean

  # Relations
  belongs_to :user
  has_many :payments, as: :payable
  has_many :attendances
end
```

## Payment
```ruby
class Payment
  # Attributs
  - user_id: references
  - amount: decimal
  - payment_method: enum [:card, :cash, :check]
  - payable_type: string
  - payable_id: integer
  - recorded_by_id: references
  - donation_amount: decimal
  - receipt_number: string

  # Relations
  belongs_to :user
  belongs_to :recorded_by, class_name: 'User'
  belongs_to :payable, polymorphic: true
end
```

## Attendance
```ruby
class Attendance
  # Attributs
  - user_id: references
  - subscription_id: references
  - check_in_time: datetime
  - recorded_by_id: references

  # Relations
  belongs_to :user
  belongs_to :subscription, optional: true
  belongs_to :recorded_by, class_name: 'User'
end
``` 