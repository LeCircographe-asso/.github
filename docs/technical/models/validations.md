# Validations et Scopes

## Validations Personnalisées

### Date Validation
```ruby
# app/models/concerns/date_validatable.rb
module DateValidatable
  extend ActiveSupport::Concern

  included do
    validate :end_date_after_start_date, if: -> { start_date.present? && end_date.present? }
  end

  private

  def end_date_after_start_date
    if end_date < start_date
      errors.add(:end_date, "doit être postérieure à la date de début")
    end
  end
end
```

### Payment Validation
```ruby
# app/models/concerns/payment_validatable.rb
module PaymentValidatable
  extend ActiveSupport::Concern

  included do
    validates :amount, presence: true,
                      numericality: { greater_than: 0 }
    validates :payment_method, presence: true,
                             inclusion: { in: Payment::METHODS }
    validate :valid_payment_amount
  end

  private

  def valid_payment_amount
    return unless payable && amount

    expected_amount = payable.calculate_price(reduced_price: reduced_price?)
    if amount != expected_amount
      errors.add(:amount, "ne correspond pas au montant attendu (#{expected_amount}€)")
    end
  end
end
```

## Scopes Réutilisables

### Time Scopes
```ruby
# app/models/concerns/time_scopable.rb
module TimeScopable
  extend ActiveSupport::Concern

  included do
    scope :created_today, -> { where(created_at: Time.current.beginning_of_day..Time.current.end_of_day) }
    scope :created_this_week, -> { where(created_at: Time.current.beginning_of_week..Time.current.end_of_week) }
    scope :created_this_month, -> { where(created_at: Time.current.beginning_of_month..Time.current.end_of_month) }
    
    scope :updated_since, ->(time) { where('updated_at > ?', time) }
    scope :created_between, ->(start_date, end_date) { where(created_at: start_date..end_date) }
  end
end
```

### Status Scopes
```ruby
# app/models/concerns/status_scopable.rb
module StatusScopable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :pending, -> { where(status: 'pending') }
    scope :approved, -> { where(status: 'approved') }
    scope :rejected, -> { where(status: 'rejected') }
  end
end
```

## Exemples d'Utilisation

### Subscription Model
```ruby
# app/models/subscription.rb
class Subscription < ApplicationRecord
  include DateValidatable
  include PaymentValidatable
  include TimeScopable
  include StatusScopable

  belongs_to :user
  has_many :attendances
  has_many :payments, as: :payable

  validates :type, inclusion: { in: TYPES }
  validates :status, inclusion: { in: STATUSES }
  validate :user_has_valid_memberships

  scope :active_on, ->(date) { 
    where('start_date <= ? AND end_date >= ?', date, date)
  }

  scope :by_priority, -> {
    order(Arel.sql(
      "CASE type 
         WHEN 'daily' THEN 1 
         WHEN 'pack' THEN 2 
         WHEN 'quarterly' THEN 3 
         WHEN 'yearly' THEN 4 
       END"
    ))
  }

  private

  def user_has_valid_memberships
    unless user.active_circus_membership?
      errors.add(:base, "nécessite une adhésion cirque valide")
    end
  end
end
```

### Attendance Model
```ruby
# app/models/attendance.rb
class Attendance < ApplicationRecord
  include TimeScopable

  belongs_to :user
  belongs_to :subscription, optional: true
  belongs_to :recorded_by, class_name: 'User'

  validates :attended_on, presence: true
  validates :attendance_type, inclusion: { in: TYPES }
  validate :no_duplicate_attendance
  validate :valid_subscription_if_required

  scope :for_date, ->(date) { where(attended_on: date) }
  scope :by_type, ->(type) { where(attendance_type: type) }
  scope :recorded_by_user, ->(user_id) { where(recorded_by_id: user_id) }

  private

  def no_duplicate_attendance
    if user.attendances.exists?(attended_on: attended_on)
      errors.add(:base, "déjà présent ce jour")
    end
  end

  def valid_subscription_if_required
    if requires_subscription? && !user.has_valid_subscription_on?(attended_on)
      errors.add(:base, "nécessite un abonnement valide")
    end
  end
end
``` 