class User < ApplicationRecord
  # Enums
  enum membership_type: {
    none: 0,      # Pas d'adhésion
    basic: 1,     # Adhérent Basic (1€)
    circus: 2     # Adhérent Cirque (10€/7€)
  }

  # Relations
  has_many :memberships
  has_many :subscriptions
  has_many :attendances
  has_many :payments
  has_many :roles, through: :user_roles

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :membership_type, inclusion: { in: membership_types.keys }

  # Méthodes pour vérifier le type d'adhésion
  def basic_member?
    membership_type == 'basic' || membership_type == 'circus'
  end

  def circus_member?
    membership_type == 'circus'
  end

  def active_membership
    memberships.active.last
  end

  def update_membership_type!
    if memberships.circus.active.exists?
      update!(membership_type: :circus)
    elsif memberships.basic.active.exists?
      update!(membership_type: :basic)
    else
      update!(membership_type: :none)
    end
  end

  # Callbacks
  after_create :set_default_membership_type
  
  private

  def set_default_membership_type
    self.membership_type ||= :none
  end
end 