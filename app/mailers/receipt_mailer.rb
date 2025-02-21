class ReceiptMailer < ApplicationMailer
  def send_receipt(receipt)
    @receipt = receipt
    @user = receipt.user

    attachments["recu_#{receipt.number}.pdf"] = {
      mime_type: 'application/pdf',
      content: receipt.pdf_data
    }

    mail(
      to: @user.email,
      subject: "Votre reçu Le Circographe ##{receipt.number}"
    )
  end
end 