# Guide d'Implémentation - Modèles Rails

## Configuration Initiale

### Installation Rails
```bash
# Création du projet avec les configurations modernes
rails new circographe --css tailwind --database=sqlite3 --javascript=importmap
```

### Authentification Native
```ruby
# Installation de l'authentification native Rails 8
rails generate authentication:install
rails generate authentication:user User
```

### Gems Essentielles
```ruby
# Gemfile
gem "importmap-rails"        # JS moderne
gem "turbo-rails"           # Hotwire
gem "stimulus-rails"        # Hotwire
gem "tailwindcss-rails"     # CSS
gem "flowbite-rails"        # Composants UI
gem "ransack"               # Recherche
gem "pagy"                  # Pagination
```

## Modèles de Base

### User
```ruby
# app/models/user.rb
class User < ApplicationRecord
  include Authentication::Authenticatable
  include Authorization::Authorizable
  
  has_many :memberships, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :payments, dependent: :destroy

  validates :email, presence: true, 
                   uniqueness: true,
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :member_number, uniqueness: true, allow_nil: true

  before_create :generate_member_number

  private

  def generate_member_number
    return if member_number.present?
    
    year = Time.current.strftime("%y")
    last_number = User.where("member_number LIKE ?", "#{year}%")
                     .maximum(:member_number)
                     &.last(4)
                     &.to_i || 0
    
    self.member_number = "#{year}#{format('%04d', last_number + 1)}"
  end
end
```

### Membership (STI)
```ruby
# app/models/membership.rb
class Membership < ApplicationRecord
  belongs_to :user
  has_many :payments, as: :payable

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :type, inclusion: { in: %w[BasicMembership CircusMembership] }

  scope :active, -> { where("start_date <= ? AND end_date >= ?", Date.current, Date.current) }
  scope :expiring_soon, -> { active.where("end_date <= ?", 30.days.from_now) }

  def active?
    start_date <= Date.current && end_date >= Date.current
  end
end

# app/models/basic_membership.rb
class BasicMembership < Membership
  def fee
    1.00 # 1€
  end
end

# app/models/circus_membership.rb
class CircusMembership < Membership
  belongs_to :basic_membership
  validates :basic_membership, presence: true

  def fee
    reduced_price? ? 7.00 : 10.00
  end
end
```

### Subscription (STI)
```ruby
# app/models/subscription.rb
class Subscription < ApplicationRecord
  belongs_to :user
  has_many :payments, as: :payable
  has_many :attendances

  validates :type, inclusion: { in: subscription_types }
  validates :start_date, presence: true
  
  scope :active, -> { where("start_date <= ? AND end_date >= ?", Date.current, Date.current) }

  def self.subscription_types
    %w[DailySubscription Pack10Subscription TrimesterSubscription AnnualSubscription]
  end
end

class DailySubscription < Subscription
  def fee; 4.00; end
end

class Pack10Subscription < Subscription
  def fee; 30.00; end
  
  def entries_left
    10 - attendances.count
  end
end

class TrimesterSubscription < Subscription
  def fee; 65.00; end
  
  before_create do
    self.end_date = start_date + 3.months
  end
end

class AnnualSubscription < Subscription
  def fee; 150.00; end
  
  before_create do
    self.end_date = start_date + 1.year
  end
end
```

### Payment
```ruby
# app/models/payment.rb
class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :recorded_by, class_name: 'User'
  belongs_to :payable, polymorphic: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_method, inclusion: { in: %w[card cash check] }
  
  before_create :generate_receipt_number

  private

  def generate_receipt_number
    date = Time.current.strftime("%y%m%d")
    last_number = Payment.where("receipt_number LIKE ?", "#{date}%")
                        .maximum(:receipt_number)
                        &.last(3)
                        &.to_i || 0
    
    self.receipt_number = "#{date}#{format('%03d', last_number + 1)}"
  end
end
``` 