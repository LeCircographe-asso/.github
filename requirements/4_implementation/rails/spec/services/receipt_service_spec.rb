require 'rails_helper'

RSpec.describe ReceiptService do
  describe '.generate' do
    let(:payment) { create(:payment) }
    let(:admin) { create(:user, :admin) }

    it 'creates a receipt for the payment' do
      receipt = described_class.generate(payment)
      
      expect(receipt).to be_persisted
      expect(receipt.payment).to eq(payment)
      expect(receipt.amount).to eq(payment.total_amount)
      expect(receipt.number).to match(/\A\d{8}-[A-Z]+-\d{3}\z/)
    end

    it 'includes donation in total amount' do
      payment = create(:payment, amount: 10, donation_amount: 5)
      receipt = described_class.generate(payment)
      
      expect(receipt.amount).to eq(15)
    end
  end
end 