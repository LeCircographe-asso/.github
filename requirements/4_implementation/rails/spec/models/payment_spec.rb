RSpec.describe Payment, type: :model do
  describe '#validate_amounts' do
    context 'with membership payment' do
      let(:membership) { create(:circus_membership) }
      let(:payment) { build(:payment, payable: membership) }

      it 'validates correct amount' do
        payment.amount = membership.calculate_price
        expect(payment).to be_valid
      end

      it 'rejects incorrect amount' do
        payment.amount = 999
        expect(payment).not_to be_valid
      end
    end
  end

  describe '#handle_donation' do
    let(:payment) { create(:payment, donation_amount: 5) }

    it 'creates a donation record' do
      expect { payment.save }.to change(Donation, :count).by(1)
    end
  end
end 