RSpec.describe PaymentService do
  describe '.process_payment' do
    let(:admin) { create(:user, :admin) }
    let(:user) { create(:user) }
    let(:membership) { create(:membership, user: user) }
    
    let(:valid_params) do
      {
        amount: 10.0,
        payable: membership,
        payment_method: 'cash',
        user: user,
        donation_amount: 5.0
      }
    end

    context 'with valid parameters' do
      it 'creates a payment with tracking' do
        expect {
          PaymentService.process_payment(valid_params, recorded_by: admin)
        }.to change(Payment, :count).by(1)
          .and change(PaymentAttempt, :count).by(1)
      end

      it 'handles donations correctly' do
        payment = PaymentService.process_payment(valid_params, recorded_by: admin)
        
        expect(payment.donation_amount).to eq(5.0)
        expect(Donation.last.amount).to eq(5.0)
      end

      it 'generates a receipt' do
        expect(ReceiptService).to receive(:generate)
        PaymentService.process_payment(valid_params, recorded_by: admin)
      end
    end

    context 'with concurrent modifications' do
      it 'handles race conditions' do
        allow_any_instance_of(Payment).to receive(:save!)
          .and_raise(ActiveRecord::StaleObjectError)

        expect {
          PaymentService.process_payment(valid_params, recorded_by: admin)
        }.to raise_error(PaymentService::ConcurrencyError)
          .and change(PaymentAttempt, :count).by(1)
      end
    end

    context 'with amount changes' do
      before do
        allow_any_instance_of(Membership)
          .to receive(:calculate_real_time_price)
          .and_return(15.0)
      end

      it 'detects price changes' do
        expect {
          PaymentService.process_payment(valid_params, recorded_by: admin)
        }.to raise_error(PaymentService::ValidationError, /Le montant a changé/)
          .and change(PaymentAttempt, :count).by(1)
      end
    end

    context 'with system errors' do
      before do
        allow(ReceiptService).to receive(:generate)
          .and_raise(StandardError, "Erreur d'impression")
      end

      it 'logs system errors' do
        expect {
          PaymentService.process_payment(valid_params, recorded_by: admin)
        }.to raise_error(PaymentService::PaymentError, /Erreur système/)
          .and change(PaymentAttempt, :count).by(1)

        attempt = PaymentAttempt.last
        expect(attempt.status).to eq('system_error')
        expect(attempt.error_message).to include("Erreur d'impression")
      end
    end

    context 'with transaction isolation' do
      it 'uses serializable isolation level' do
        expect(Payment).to receive(:transaction)
          .with(hash_including(isolation: :serializable))
          .and_call_original

        PaymentService.process_payment(valid_params, recorded_by: admin)
      end
    end

    context 'with security checks' do
      context 'duplicate payments' do
        before do
          create(:payment, 
            user: user,
            payable: membership,
            created_at: 30.minutes.ago
          )
        end

        it 'prevents duplicate payments' do
          expect {
            PaymentService.process_payment(valid_params, recorded_by: admin)
          }.to raise_error(PaymentService::ValidationError, /similaire existe déjà/)
            .and change(SecurityEvent, :count).by(1)
        end
      end

      context 'daily limits' do
        before do
          create(:payment, 
            user: user,
            amount: PaymentService::MAX_DAILY_AMOUNT
          )
        end

        it 'enforces daily payment limits' do
          expect {
            PaymentService.process_payment(valid_params, recorded_by: admin)
          }.to raise_error(PaymentService::ValidationError, /Limite journalière/)
            .and change(SecurityEvent, :count).by(1)
        end
      end

      context 'suspicious activity' do
        before do
          create_list(:payment_attempt, 3, 
            user: user,
            created_at: 2.minutes.ago
          )
        end

        it 'detects rapid attempts' do
          expect {
            PaymentService.process_payment(valid_params, recorded_by: admin)
          }.to raise_error(PaymentService::SecurityError, /Activité suspecte/)
            .and change(SecurityEvent, :count).by(1)
        end
      end
    end
  end
end 