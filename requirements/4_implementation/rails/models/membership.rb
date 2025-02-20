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

  def calculate_price
    base_price = type == 'CircusMembership' ? 10 : 1
    discounted? ? apply_discount(base_price) : base_price
  end

  private

  def apply_discount(amount)
    return amount unless discounted?
    (amount * (100 - DISCOUNT_PERCENTAGE) / 100.0).round(2)
  end

  def discounted?
    discount_reason.present?
  end
end 