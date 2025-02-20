RSpec.describe NotificationService do
  describe '.check_and_notify' do
    let(:user) { create(:user) }
    let(:admin) { create(:user, :admin) }

    context 'membership notifications' do
      let!(:membership) { create(:membership, user: user, expires_at: 7.days.from_now) }

      it 'notifies about expiring memberships' do
        expect {
          NotificationService.check_and_notify
        }.to change(Notification, :count).by(1)
        
        notification = Notification.last
        expect(notification.notification_type).to eq('membership_expiration')
        expect(notification.data['days_remaining']).to eq(7)
      end

      it 'avoids duplicate notifications' do
        NotificationService.check_and_notify
        
        expect {
          NotificationService.check_and_notify
        }.not_to change(Notification, :count)
      end
    end

    context 'subscription notifications' do
      let!(:subscription) { create(:subscription, user: user, sessions_remaining: 2) }

      it 'notifies about low sessions' do
        expect {
          NotificationService.check_and_notify
        }.to change(Notification, :count).by(1)

        notification = Notification.last
        expect(notification.notification_type).to eq('subscription_low')
        expect(notification.data['sessions_remaining']).to eq(2)
      end
    end

    context 'capacity warnings' do
      let!(:list) { create(:daily_attendance_list, :near_capacity) }

      it 'notifies admins about capacity issues' do
        expect {
          NotificationService.check_and_notify
        }.to change(Notification, :count).by(1)

        notification = Notification.last
        expect(notification.notification_type).to eq('capacity_warning')
      end
    end

    context 'multi-channel delivery' do
      let!(:membership) { create(:membership, user: user, expires_at: 7.days.from_now) }

      it 'delivers through all channels' do
        expect(NotificationMailer).to receive(:send_notification).and_return(double(deliver_later: true))
        expect(PushNotificationJob).to receive(:perform_later)
        expect(Turbo::StreamsChannel).to receive(:broadcast_append_to)

        NotificationService.check_and_notify
      end
    end
  end
end 