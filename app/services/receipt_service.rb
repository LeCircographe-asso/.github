class ReceiptService
  class ReceiptError < StandardError; end

  def self.generate(payment)
    ActiveRecord::Base.transaction do
      validate_payment!(payment)
      
      receipt = Receipt.create!(
        payment: payment,
        user: payment.user,
        generated_by: payment.recorded_by,
        amount: calculate_total(payment),
        date: Time.current,
        receipt_type: determine_receipt_type(payment),
        donation_included: payment.donation_amount.present?
      )

      generate_pdf(receipt)
      send_email(receipt) unless payment.user.email.blank?
      
      receipt
    end
  rescue ActiveRecord::RecordInvalid => e
    raise ReceiptError, "Erreur de création du reçu : #{e.message}"
  rescue StandardError => e
    Rails.logger.error("Erreur ReceiptService : #{e.message}")
    raise ReceiptError, "Erreur lors de la génération du reçu"
  end

  private

  def self.validate_payment!(payment)
    raise ReceiptError, "Paiement invalide" unless payment.valid?
    raise ReceiptError, "Paiement déjà traité" if payment.receipt.present?
  end

  def self.calculate_total(payment)
    payment.amount + (payment.donation_amount || 0)
  end

  def self.determine_receipt_type(payment)
    if payment.donation_amount.present?
      'donation_included'
    else
      payment.payable_type.underscore
    end
  end

  def self.generate_pdf(receipt)
    pdf = Prawn::Document.new

    pdf.font_families.update("OpenSans" => {
      normal: Rails.root.join("app/assets/fonts/OpenSans-Regular.ttf"),
      bold: Rails.root.join("app/assets/fonts/OpenSans-Bold.ttf")
    })

    pdf.font "OpenSans"

    # En-tête
    pdf.text "Le Circographe", size: 20, style: :bold
    pdf.text "Reçu ##{receipt.number}", size: 16
    pdf.move_down 20

    # Informations du paiement
    pdf.text "Date : #{I18n.l(receipt.date, format: :long)}"
    pdf.text "Membre : #{receipt.user.full_name}"
    pdf.text "Numéro membre : #{receipt.user.member_number}"
    pdf.move_down 10

    # Détails du paiement
    pdf.text "Détails :", style: :bold
    pdf.text "Type : #{I18n.t("receipts.types.#{receipt.receipt_type}")}"
    pdf.text "Montant : #{number_to_currency(receipt.amount)}"
    
    if receipt.donation_included?
      pdf.text "Don : #{number_to_currency(receipt.payment.donation_amount)}"
    end

    # Pied de page
    pdf.move_down 20
    pdf.text "Généré par : #{receipt.generated_by.name}"
    pdf.text "Le Circographe - Association loi 1901"

    receipt.update!(pdf_data: pdf.render)
  end

  def self.send_email(receipt)
    ReceiptMailer.send_receipt(receipt).deliver_later
  end
end 