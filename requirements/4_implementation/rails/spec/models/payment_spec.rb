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

  describe "history tracking" do
    let(:payment) { build(:payment) }
    let(:admin) { create(:user, :admin) }

    context "when creating payment" do
      it "tracks creation" do
        expect { payment.save! }.to change(PaymentHistory, :count).by(1)
        
        history = PaymentHistory.last
        expect(history.action).to eq('create')
        expect(history.changes).to include(
          "amount" => payment.amount,
          "payment_method" => payment.payment_method
        )
      end
    end

    context "when updating payment" do
      before { payment.save! }

      it "tracks changes" do
        expect {
          payment.update!(amount: 999)
        }.to change(PaymentHistory, :count).by(1)

        history = PaymentHistory.last
        expect(history.action).to eq('update')
        expect(history.changes["amount"]).to eq([payment.amount_was, 999])
      end

      it "doesn't track when nothing changes" do
        expect {
          payment.save!
        }.not_to change(PaymentHistory, :count)
      end
    end

    context "when deleting payment" do
      before { payment.save! }

      it "tracks deletion" do
        expect {
          payment.destroy!
        }.to change(PaymentHistory, :count).by(1)

        history = PaymentHistory.last
        expect(history.action).to eq('delete')
        expect(history.payment_id).to eq(payment.id)
      end
    end
  end
end 