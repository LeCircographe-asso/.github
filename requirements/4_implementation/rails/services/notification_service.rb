class NotificationService
  def self.notify_if_needed(user, membership, subscription = nil)
    # 1. Notifications Adhésion
    if membership.expires_soon?
      UserMailer.membership_expiration_notice(user).deliver_later
      notify_volunteers(user, :membership_expiring)
    end

    # 2. Notifications Abonnement
    if subscription&.low_entries?
      UserMailer.subscription_running_low(user).deliver_later
      notify_volunteers(user, :subscription_low)
    end

    # 3. Notifications Statistiques
    if user.high_attendance?
      notify_admins(user, :high_attendance)
    end
  end

  private

  def self.notify_volunteers(user, type)
    Notification.create_for_volunteers(
      user: user,
      type: type,
      message: notification_message(user, type)
    )
  end

  def self.notify_admins(user, type)
    Notification.create_for_admins(
      user: user,
      type: type,
      message: notification_message(user, type)
    )
  end
end 