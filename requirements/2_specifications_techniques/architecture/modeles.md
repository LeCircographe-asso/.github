# Architecture des Modèles

## User
```ruby
class User < ApplicationRecord
  # Rôles
  ROLES = %w[user member volunteer admin super_admin].freeze
  
  # Relations
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :memberships
  has_many :subscriptions
  has_many :payments
  has_many :attendances
  has_many :recorded_payments, class_name: 'Payment', foreign_key: :recorded_by_id
  has_many :recorded_attendances, class_name: 'Attendance', foreign_key: :recorded_by_id
  
  # Validations
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  
  # Scopes
  scope :members, -> { joins(:roles).where(roles: { name: 'member' }) }
  scope :volunteers, -> { joins(:roles).where(roles: { name: 'volunteer' }) }
  scope :admins, -> { joins(:roles).where(roles: { name: 'admin' }) }
  
  # Méthodes de rôle
  def member?
    roles.exists?(name: 'member')
  end
  
  def volunteer?
    roles.exists?(name: 'volunteer')
  end
  
  def admin?
    roles.exists?(name: 'admin')
  end
  
  def super_admin?
    roles.exists?(name: 'super_admin')
  end
end
```

## Role
```ruby
class Role < ApplicationRecord
  # Relations
  has_many :user_roles
  has_many :users, through: :user_roles
  
  # Validations
  validates :name, presence: true, 
                  inclusion: { in: User::ROLES }
end
```

## UserRole
```ruby
class UserRole < ApplicationRecord
  # Relations
  belongs_to :user
  belongs_to :role
  
  # Validations
  validates :user_id, uniqueness: { scope: :role_id }
  
  # Callbacks
  after_create :grant_member_permissions
  after_destroy :revoke_member_permissions
  
  private
  
  def grant_member_permissions
    return unless role.name == 'member'
    # Logique d'attribution des permissions
  end
  
  def revoke_member_permissions
    return unless role.name == 'member'
    # Logique de révocation des permissions
  end
end
```

## Membership
```ruby
class Membership < ApplicationRecord
  # Enum
  enum type: { basic: 'BasicMembership', circus: 'CircusMembership' }

  # Relations
  belongs_to :user
  has_many :payments, as: :payable, dependent: :restrict_with_error

  # Validations
  validates :user, :start_date, :end_date, presence: true
  validates :type, presence: true, inclusion: { in: types.keys }
  validate :end_date_after_start_date

  # Scopes
  scope :active, -> { where('start_date <= ? AND end_date >= ?', Date.current, Date.current) }

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    errors.add(:end_date, "doit être après la date de début") if end_date <= start_date
  end
end
```

## Subscription
```ruby
class Subscription < ApplicationRecord
  # Enum
  enum type: { 
    daily: 'DailySubscription',
    pack_10: 'PackSubscription',
    trimester: 'QuarterlySubscription',
    annual: 'YearlySubscription'
  }

  # Relations
  belongs_to :user
  has_many :payments, as: :payable, dependent: :restrict_with_error
  has_many :attendances, dependent: :restrict_with_error

  # Validations
  validates :user, :start_date, presence: true
  validates :type, presence: true, inclusion: { in: types.keys }
  validates :entries_left, numericality: { less_than_or_equal_to: :entries_count }, if: :pack?

  # Scopes
  scope :active, -> { where('start_date <= ? AND (end_date >= ? OR end_date IS NULL)', Date.current, Date.current) }
  scope :with_entries, -> { where('entries_left > 0') }
end
```

## Payment
```ruby
class Payment < ApplicationRecord
  # Enum
  enum payment_method: { card: 0, cash: 1, check: 2 }

  # Relations
  belongs_to :user
  belongs_to :payable, polymorphic: true
  belongs_to :recorded_by, class_name: 'User'

  # Validations
  validates :user, :recorded_by, :payment_method, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :donation_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :receipt_number, presence: true, uniqueness: true, 
            format: { with: /\A\d{8}-[A-Z]+-\d{3}\z/ }

  # Callbacks
  before_validation :generate_receipt_number, on: :create
end
```

## DailyAttendanceList
```ruby
class DailyAttendanceList < ApplicationRecord
  # Enum pour le type de liste
  enum list_type: {
    training: 'training',      # Entraînement quotidien
    meeting: 'meeting',        # Réunion (admin uniquement)
    event: 'event',           # Événement (check-in bénévole ok)
  }

  # Relations
  has_many :attendances
  belongs_to :created_by, class_name: 'User'
  
  # Validations
  validates :date, presence: true
  validates :list_type, presence: true
  validates :title, presence: true
  validates :date, uniqueness: { scope: [:list_type, :title], 
    message: "Une liste avec ce titre existe déjà pour cette date et ce type" }
  
  # Scopes
  scope :for_date, ->(date) { where(date: date) }
  scope :training, -> { where(list_type: :training) }
  scope :special, -> { where.not(list_type: :training) }
  scope :recent, -> { where(date: 2.weeks.ago..Date.current).order(date: :desc) }
  
  # Callbacks
  before_validation :set_default_title, if: :training?
  
  # Méthodes
  def self.generate_daily_training
    return if exists?(date: Date.current, list_type: :training)
    
    create!(
      date: Date.current,
      list_type: :training,
      created_by: User.system_user,
      automatic: true
    )
  end

  # Méthodes de permission
  def can_be_managed_by?(user)
    case list_type
    when 'training', 'event'
      user.volunteer? || user.admin?
    when 'meeting'
      user.admin?
    end
  end

  def can_checkin?(user)
    case list_type
    when 'training', 'event'
      user.volunteer? || user.admin?
    when 'meeting'
      user.admin?
    end
  end

  private

  def set_default_title
    self.title = "Entraînement du #{I18n.l(date, format: :long)}" if title.blank?
  end
end
```