# Modèles et Migrations

## Modèles Principaux

### User
```ruby
# app/models/user.rb
class User < ApplicationRecord
  include Authentication
  include Authorizable
  include Auditable

  has_many :memberships, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :attendances
  has_many :payments
  has_many :notifications

  validates :email, presence: true, 
                   uniqueness: true,
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :member_number, uniqueness: true, allow_nil: true
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }

  encrypts :phone
  encrypts :emergency_contact
  encrypts :medical_info

  before_create :generate_member_number

  def active_basic_membership?
    memberships.basic.active.exists?
  end

  def active_circus_membership?
    memberships.circus.active.exists?
  end

  def remember_me
    self.remember_token = SecureRandom.urlsafe_base64
    self.remember_token_expires_at = 2.weeks.from_now
    save(validate: false)
  end
  
  def forget_me
    self.remember_token = nil
    self.remember_token_expires_at = nil
    save(validate: false)
  end

  private

  def generate_member_number
    loop do
      self.member_number = "#{Time.current.year.to_s[2..3]}#{SecureRandom.random_number(10000).to_s.rjust(4, '0')}"
      break unless User.exists?(member_number: member_number)
    end
  end
end
```

### Membership
```ruby
# app/models/membership.rb
class Membership < ApplicationRecord
  TYPES = %w[basic circus].freeze
  
  belongs_to :user
  has_many :payments, as: :payable

  validates :type, inclusion: { in: TYPES }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :no_overlapping_memberships

  scope :active, -> { where('start_date <= ? AND end_date >= ?', Date.current, Date.current) }
  scope :basic, -> { where(type: 'basic') }
  scope :circus, -> { where(type: 'circus') }
  scope :expiring_soon, -> { where(end_date: 30.days.from_now..Date.current) }

  private

  def no_overlapping_memberships
    return unless user
    
    overlapping = user.memberships
                     .where(type: type)
                     .where.not(id: id)
                     .where('start_date <= ? AND end_date >= ?', end_date, start_date)
    
    if overlapping.exists?
      errors.add(:base, "Une adhésion de ce type est déjà active pour cette période")
    end
  end
end
```

## Migrations

### Users Table
```ruby
# db/migrate/YYYYMMDDHHMMSS_create_users.rb
class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :name
      t.string :remember_token
      t.datetime :remember_token_expires_at
      t.boolean :active, default: true
      t.timestamps

      t.index :email, unique: true
      t.index :remember_token, unique: true
    end
  end
end
```

### Memberships Table
```ruby
# db/migrate/YYYYMMDDHHMMSS_create_memberships.rb
class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.string :type, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.boolean :reduced_price, default: false
      t.jsonb :metadata, default: {}

      t.timestamps
      t.index [:user_id, :type, :start_date, :end_date]
    end
  end
end
```

### Payments Table
```ruby
# db/migrate/YYYYMMDDHHMMSS_create_payments.rb
class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recorded_by, null: false, foreign_key: { to_table: :users }
      t.references :payable, polymorphic: true, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :payment_method, null: false
      t.string :reference
      t.jsonb :metadata, default: {}

      t.timestamps
      t.index :reference, unique: true
    end
  end
end
```

### Roles and User Roles
```ruby
# app/models/role.rb
class Role < ApplicationRecord
  has_many :user_roles
  has_many :users, through: :user_roles
  
  validates :name, presence: true, uniqueness: true
end

# app/models/user_role.rb
class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
  
  validates :user_id, uniqueness: { scope: :role_id }
end

# Migration
class CreateRolesAndUserRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.timestamps
      t.index :name, unique: true
    end

    create_table :user_roles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.timestamps
      t.index [:user_id, :role_id], unique: true
    end
  end
end

# app/models/concerns/authentication.rb
module Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password
    
    validates :email, presence: true, 
                     uniqueness: true,
                     format: { with: URI::MailTo::EMAIL_REGEXP }
  end

  module ClassMethods
    def find_by_valid_api_token(token)
      return nil unless token.present?
      
      User.find_by(api_token: token)
    end
  end
end

# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  layout 'auth'

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      sign_in(user)
      redirect_to after_sign_in_path_for(user), notice: 'Connexion réussie'
    else
      flash.now[:alert] = 'Email ou mot de passe invalide'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out
    redirect_to root_path, notice: 'Déconnexion réussie'
  end

  private

  def after_sign_in_path_for(user)
    stored_location = session.delete(:return_to)
    stored_location || root_path
  end
end

# app/controllers/registrations_controller.rb
class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'auth'

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in(@user)
      redirect_to root_path, notice: 'Compte créé avec succès'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end 