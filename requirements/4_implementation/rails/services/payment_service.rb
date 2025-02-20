class PaymentService
  def self.process_payment(params, recorded_by:)
    ActiveRecord::Base.transaction do
      # 1. Création et validation du paiement
      payment = Payment.new(payment_params(params))
      payment.recorded_by = recorded_by
      
      # Validation des montants
      validate_amounts!(payment, params)
      
      # 2. Application des réductions
      if params[:discount_reason].present?
        payment.apply_discount(params[:discount_reason], params[:discount_proof])
      end

      # 3. Création/Renouvellement adhésion
      membership = MembershipService.create_or_renew(
        user: payment.user,
        type: params[:membership_type],
        payment: payment
      )

      # 4. Gestion des dons
      if params[:donation_amount].present? && params[:donation_amount].positive?
        DonationService.create_donation(
          user: payment.user,
          amount: params[:donation_amount],
          payment: payment
        )
      end

      # 5. Génération du reçu
      ReceiptService.generate(payment)

      payment
    end
  end

  private

  def self.validate_amounts!(payment, params)
    total = calculate_total(params)
    raise PaymentError, "Montant incorrect" unless payment.amount == total
  end

  def self.calculate_total(params)
    base = params[:amount].to_d
    donation = params[:donation_amount].to_d
    base + donation
  end
end 