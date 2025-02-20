RSpec.describe NotificationCheckJob, type: :job do
  describe '#perform' do
    it 'calls NotificationService.check_and_notify' do
      expect(NotificationService).to receive(:check_and_notify)
      NotificationCheckJob.perform_now
    end

    context 'when an error occurs' do
      before do
        allow(NotificationService).to receive(:check_and_notify)
          .and_raise(StandardError, "Test error")
      end

      it 'logs the error' do
        expect(Rails.logger).to receive(:error)
          .with(/Erreur lors de la vérification des notifications/)
        
        expect {
          NotificationCheckJob.perform_now
        }.to raise_error(StandardError)
      end
    end
  end
end 