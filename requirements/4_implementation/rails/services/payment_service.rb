class PaymentService
  class PaymentError < StandardError; end
  class ConcurrencyError < PaymentError; end
  class ValidationError < PaymentError; end
  class SecurityError < PaymentError; end

  MAX_DAILY_AMOUNT = 1000
  SUSPICIOUS_PATTERNS = {
    multiple_attempts: 3,
    time_window: 5.minutes,
    max_daily_attempts: 10
  }.freeze

  def self.process_payment(params, recorded_by:)
    Payment.transaction(isolation: :serializable) do
      # Vérifications de sécurité préalables
      check_duplicate_payment!(params)
      check_payment_limits!(params)
      check_suspicious_activity!(params)

      # Verrouillage optimiste
      payment = Payment.lock.new(payment_params(params))
      payment.recorded_by = recorded_by
      
      begin
        # Double vérification des montants
        validate_amounts!(payment, params)
        validate_real_time_amounts!(payment, params)
        
        # Création du paiement avec traçage
        payment.save!
        log_payment_attempt(payment, :success)

        # Traitement des différents types de paiement
        case payment.payable_type
        when 'Membership'
          process_membership_payment(payment)
        when 'Subscription'
          process_subscription_payment(payment)
        end

        # Gestion des dons si présents
        handle_donation(payment, params) if params[:donation_amount].present?

        # Génération du reçu
        ReceiptService.generate(payment)

        payment
      rescue ActiveRecord::StaleObjectError
        log_payment_attempt(payment, :concurrency_error)
        raise ConcurrencyError, "Le paiement a été modifié par un autre processus"
      rescue ActiveRecord::RecordInvalid => e
        log_payment_attempt(payment, :validation_error, e.message)
        raise ValidationError, e.message
      rescue => e
        log_payment_attempt(payment, :system_error, e.message)
        raise PaymentError, "Erreur système: #{e.message}"
      end
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

  def self.validate_real_time_amounts!(payment, params)
    current_price = case payment.payable_type
                   when 'Membership'
                     payment.payable.calculate_real_time_price
                   when 'Subscription'
                     payment.payable.calculate_current_price
                   end

    if payment.amount != current_price
      raise ValidationError, "Le montant a changé. Attendu: #{current_price}€"
    end
  end

  def self.log_payment_attempt(payment, status, error_message = nil)
    PaymentAttempt.create!(
      payment: payment,
      user: payment.user,
      recorded_by: payment.recorded_by,
      amount: payment.amount,
      status: status,
      error_message: error_message,
      ip_address: Current.ip_address,
      user_agent: Current.user_agent
    )
  end

  def self.process_membership_payment(payment)
    membership = payment.payable
    membership.lock! # Verrouillage explicite

    membership.update!(
      status: :active,
      payment_id: payment.id,
      activated_at: Time.current
    )
  end

  def self.process_subscription_payment(payment)
    subscription = payment.payable
    subscription.lock! # Verrouillage explicite

    subscription.update!(
      status: :active,
      payment_id: payment.id,
      activated_at: Time.current
    )
  end

  def self.handle_donation(payment, params)
    return unless params[:donation_amount].positive?

    Donation.create!(
      user: payment.user,
      amount: params[:donation_amount],
      payment: payment,
      recorded_by: payment.recorded_by,
      anonymous: params[:anonymous_donation]
    )
  end

  def self.check_duplicate_payment!(params)
    duplicate = Payment.where(
      user_id: params[:user_id],
      payable_type: params[:payable_type],
      payable_id: params[:payable_id]
    ).where('created_at > ?', 1.hour.ago).exists?

    if duplicate
      log_security_event(:duplicate_payment_attempt, params)
      raise ValidationError, "Un paiement similaire existe déjà"
    end
  end

  def self.check_payment_limits!(params)
    daily_total = Payment.where(user_id: params[:user_id])
                        .where('created_at > ?', 24.hours.ago)
                        .sum(:amount)

    if daily_total + params[:amount].to_d > MAX_DAILY_AMOUNT
      log_security_event(:daily_limit_exceeded, params)
      raise ValidationError, "Limite journalière de paiement dépassée"
    end
  end

  def self.check_suspicious_activity!(params)
    recent_attempts = PaymentAttempt
      .where(user_id: params[:user_id])
      .where('created_at > ?', SUSPICIOUS_PATTERNS[:time_window].ago)

    if recent_attempts.count >= SUSPICIOUS_PATTERNS[:multiple_attempts]
      log_security_event(:suspicious_activity, params)
      raise SecurityError, "Activité suspecte détectée"
    end

    daily_attempts = PaymentAttempt
      .where(user_id: params[:user_id])
      .where('created_at > ?', 24.hours.ago)

    if daily_attempts.count >= SUSPICIOUS_PATTERNS[:max_daily_attempts]
      log_security_event(:too_many_attempts, params)
      raise SecurityError, "Trop de tentatives aujourd'hui"
    end
  end

  def self.log_security_event(type, params)
    SecurityEvent.create!(
      event_type: type,
      user_id: params[:user_id],
      details: {
        params: params,
        ip_address: Current.ip_address,
        user_agent: Current.user_agent,
        timestamp: Time.current
      }
    )
  end
end 