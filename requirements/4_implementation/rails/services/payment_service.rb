class PaymentService
  def self.process_payment(params, recorded_by:)
    ActiveRecord::Base.transaction do
      # 1. Création du Paiement
      payment = Payment.new(payment_params(params))
      payment.recorded_by = recorded_by
      
      # 2. Application des Réductions
      if params[:discount_reason].present?
        payment.apply_discount(params[:discount_reason], params[:discount_proof])
      end

      # 3. Création/Renouvellement Adhésion
      membership = MembershipService.create_or_renew(
        user: payment.user,
        type: params[:membership_type],
        payment: payment
      )

      # 4. Gestion des Dons
      if params[:donation_amount].present?
        DonationService.create_donation(
          user: payment.user,
          amount: params[:donation_amount],
          payment: payment
        )
      end

      # 5. Génération Reçu
      ReceiptService.generate(payment)

      payment
    end
  end
end 