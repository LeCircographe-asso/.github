class Payment < ApplicationRecord
  # ... existing code ...

  # Validations
  validate :validate_amounts
  validate :validate_donation_amount

  # Callbacks
  after_create :handle_donation, if: :has_donation?
  after_create :track_creation
  after_update :track_changes
  before_destroy :track_deletion

  private

  def track_creation
    PaymentHistory.create!(
      payment: self,
      action: 'create',
      changes: attributes,
      recorded_by: recorded_by
    )
  end

  def track_changes
    return unless saved_changes.any?
    
    PaymentHistory.create!(
      payment: self,
      action: 'update',
      changes: saved_changes,
      recorded_by: recorded_by
    )
  end

  def track_deletion
    PaymentHistory.create!(
      payment_id: id, # Sauvegarde l'ID car le payment va être supprimé
      action: 'delete',
      changes: attributes,
      recorded_by: recorded_by
    )
  end

  def validate_amounts
    case payable_type
    when 'Membership'
      validate_membership_amount
    when 'Subscription'
      validate_subscription_amount
    end
  end

  def validate_membership_amount
    expected = payable.calculate_price
    unless amount == expected
      errors.add(:amount, "doit être de #{expected}€ pour cette adhésion")
    end
  end

  def validate_subscription_amount
    expected = payable.price_with_discounts
    unless amount == expected
      errors.add(:amount, "doit être de #{expected}€ pour cet abonnement")
    end
  end

  def validate_donation_amount
    if donation_amount.present? && donation_amount.negative?
      errors.add(:donation_amount, "ne peut pas être négatif")
    end
  end

  def handle_donation
    Donation.create!(
      user: user,
      amount: donation_amount,
      payment: self,
      recorded_by: recorded_by,
      anonymous: anonymous_donation
    )
  end

  def has_donation?
    donation_amount.present? && donation_amount.positive?
  end
end 