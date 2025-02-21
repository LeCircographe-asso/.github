RSpec.describe ReceiptService do
  describe '.generate' do
    let(:user) { create(:user) }
    let(:admin) { create(:user, :admin) }
    let(:payment) { create(:payment, user: user, recorded_by: admin) }

    context 'with valid payment' do
      it 'creates a receipt' do
        expect {
          ReceiptService.generate(payment)
        }.to change(Receipt, :count).by(1)
      end

      it 'generates PDF data' do
        receipt = ReceiptService.generate(payment)
        expect(receipt.pdf_data).to be_present
      end

      it 'sends email' do
        expect {
          ReceiptService.generate(payment)
        }.to have_enqueued_mail(ReceiptMailer, :send_receipt)
      end

      context 'with donation' do
        let(:payment) { create(:payment, :with_donation, user: user) }

        it 'includes donation in total' do
          receipt = ReceiptService.generate(payment)
          expect(receipt.amount).to eq(payment.amount + payment.donation_amount)
        end

        it 'marks receipt as donation_included' do
          receipt = ReceiptService.generate(payment)
          expect(receipt).to be_donation_included
        end
      end
    end

    context 'with invalid payment' do
      before { allow(payment).to receive(:valid?).and_return(false) }

      it 'raises ReceiptError' do
        expect {
          ReceiptService.generate(payment)
        }.to raise_error(ReceiptService::ReceiptError)
      end
    end

    context 'when receipt already exists' do
      before { create(:receipt, payment: payment) }

      it 'raises ReceiptError' do
        expect {
          ReceiptService.generate(payment)
        }.to raise_error(ReceiptService::ReceiptError, /déjà traité/)
      end
    end
  end
end 