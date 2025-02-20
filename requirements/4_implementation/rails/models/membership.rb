class Membership < ApplicationRecord
  # ... existing code ...

  DISCOUNT_REASONS = %w[student unemployed rsa minor].freeze
  DISCOUNT_PERCENTAGE = 30

  # Attributes
  attr_accessor :discount_reason
  attr_accessor :discount_proof

  # Validations
  validates :discount_reason, inclusion: { 
    in: DISCOUNT_REASONS,
    message: "n'est pas une raison valide"
  }, if: :discounted?

  validates :discount_proof, presence: true, if: :discounted?
  validate :validate_renewal_dates, if: :renewal?
  validate :validate_basic_requirement, if: :circus?
  validate :validate_discount_proof, if: :discounted?

  # Scopes
  scope :active, -> { where("start_date <= ? AND end_date >= ?", Date.current, Date.current) }
  scope :future, -> { where("start_date > ?", Date.current) }
  scope :by_type, ->(type) { where(type: type) }

  def calculate_price
    base_price = type == 'CircusMembership' ? 10 : 1
    discounted? ? apply_discount(base_price) : base_price
  end

  def renewal?
    user.memberships.exists?(["end_date >= ?", Date.current])
  end

  def validate_renewal_dates
    current_membership = user.memberships.active.first
    
    if current_membership
      if start_date <= current_membership.end_date
        errors.add(:start_date, "doit être postérieure à la fin de l'adhésion actuelle")
      end

      if start_date > current_membership.end_date + 30.days
        errors.add(:start_date, "doit être dans les 30 jours suivant la fin de l'adhésion actuelle")
      end
    end
  end

  def validate_basic_requirement
    return if type != 'CircusMembership'
    
    unless user.memberships.basic.active.exists?
      errors.add(:base, "Une adhésion basique active est requise pour l'adhésion cirque")
    end
  end

  def validate_discount_proof
    return unless discounted?
    
    if discount_proof.blank?
      errors.add(:discount_proof, "est requis pour le tarif réduit")
    end

    unless DISCOUNT_REASONS.include?(discount_reason)
      errors.add(:discount_reason, "n'est pas une raison valide")
    end
  end

  private

  def apply_discount(amount)
    return amount unless discounted?
    (amount * (100 - DISCOUNT_PERCENTAGE) / 100.0).round(2)
  end

  def discounted?
    discount_reason.present?
  end

  def set_end_date
    self.end_date = start_date + 1.year
  end
end 