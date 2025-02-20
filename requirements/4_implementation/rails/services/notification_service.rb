class NotificationService
  EXPIRATION_THRESHOLDS = [30.days, 7.days, 1.day].freeze
  SUBSCRIPTION_THRESHOLDS = [5, 2, 1].freeze # séances restantes

  def self.check_and_notify
    check_memberships
    check_subscriptions
    check_attendance_limits
  end

  private

  def self.check_memberships
    User.joins(:memberships).where(memberships: { status: :active }).find_each do |user|
      membership = user.active_membership
      next unless membership

      EXPIRATION_THRESHOLDS.each do |threshold|
        if membership.expires_in?(threshold) && !recently_notified?(user, :membership_expiration, threshold)
          notify_expiration(user, membership, threshold)
        end
      end
    end
  end

  def self.check_subscriptions
    User.joins(:subscriptions).where(subscriptions: { status: :active }).find_each do |user|
      subscription = user.active_subscription
      next unless subscription

      SUBSCRIPTION_THRESHOLDS.each do |threshold|
        if subscription.sessions_remaining <= threshold && !recently_notified?(user, :subscription_low, threshold)
          notify_subscription_low(user, subscription, threshold)
        end
      end
    end
  end

  def self.check_attendance_limits
    DailyAttendanceList.active.find_each do |list|
      if list.near_capacity? && !recently_notified?(list, :capacity_warning)
        notify_capacity_warning(list)
      end
    end
  end

  def self.notify_expiration(user, membership, threshold)
    notification = create_notification(
      user: user,
      type: :membership_expiration,
      data: {
        membership_id: membership.id,
        expires_at: membership.expires_at,
        days_remaining: threshold.to_i / 1.day
      }
    )

    # Envoi multi-canal
    deliver_email(notification)
    deliver_push(notification)
    deliver_in_app(notification)
  end

  def self.notify_subscription_low(user, subscription, threshold)
    notification = create_notification(
      user: user,
      type: :subscription_low,
      data: {
        subscription_id: subscription.id,
        sessions_remaining: threshold
      }
    )

    deliver_email(notification)
    deliver_push(notification)
    deliver_in_app(notification)
  end

  def self.notify_capacity_warning(list)
    notification = create_notification(
      type: :capacity_warning,
      data: {
        list_id: list.id,
        date: list.date,
        capacity_percentage: list.capacity_percentage
      }
    )

    # Notification aux admins
    User.admin.find_each do |admin|
      deliver_email(notification, admin)
      deliver_push(notification, admin)
    end
  end

  def self.create_notification(user:, type:, data:)
    Notification.create!(
      user: user,
      notification_type: type,
      data: data,
      status: :pending
    )
  end

  def self.recently_notified?(target, type, threshold = nil)
    scope = Notification.where(
      notification_type: type,
      created_at: 24.hours.ago..Time.current
    )

    if target.is_a?(User)
      scope = scope.where(user: target)
    else
      scope = scope.where("data->>'list_id' = ?", target.id.to_s)
    end

    scope = scope.where("data->>'threshold' = ?", threshold.to_s) if threshold

    scope.exists?
  end

  def self.deliver_email(notification, user = notification.user)
    NotificationMailer.send_notification(notification, user).deliver_later
  end

  def self.deliver_push(notification, user = notification.user)
    return unless user.push_enabled?
    
    PushNotificationJob.perform_later(
      user_id: user.id,
      title: notification.title,
      body: notification.body,
      data: notification.data
    )
  end

  def self.deliver_in_app(notification, user = notification.user)
    Turbo::StreamsChannel.broadcast_append_to(
      "user_#{user.id}_notifications",
      target: "notifications",
      partial: "notifications/notification",
      locals: { notification: notification }
    )
  end
end 