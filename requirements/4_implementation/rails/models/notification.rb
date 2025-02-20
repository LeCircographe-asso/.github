class Notification < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  
  # Enums
  enum status: {
    pending: 0,
    delivered: 1,
    read: 2,
    failed: 3
  }

  enum notification_type: {
    membership_expiration: 0,
    subscription_low: 1,
    capacity_warning: 2,
    system_alert: 3
  }

  # Scopes
  scope :unread, -> { where(status: [:pending, :delivered]) }
  scope :recent, -> { where('created_at > ?', 30.days.ago) }
  scope :for_user, ->(user) { where(user: user) }

  # Callbacks
  after_create_commit :broadcast_notification

  def self.cleanup_old
    where('created_at < ?', 90.days.ago)
      .where(status: [:delivered, :read])
      .delete_all
  end

  def mark_as_read!
    update!(status: :read, read_at: Time.current)
  end

  def mark_as_delivered!
    update!(status: :delivered, delivered_at: Time.current)
  end

  def mark_as_failed!(error_message)
    update!(
      status: :failed,
      error_message: error_message,
      failed_at: Time.current
    )
  end

  def title
    case notification_type
    when 'membership_expiration'
      "Votre adhésion expire bientôt"
    when 'subscription_low'
      "Votre abonnement arrive à sa fin"
    when 'capacity_warning'
      "Alerte de capacité"
    else
      "Notification système"
    end
  end

  def body
    case notification_type
    when 'membership_expiration'
      "Votre adhésion expire dans #{data['days_remaining']} jours"
    when 'subscription_low'
      "Il vous reste #{data['sessions_remaining']} séances"
    when 'capacity_warning'
      "La salle est à #{data['capacity_percentage']}% de sa capacité"
    else
      data['message']
    end
  end

  private

  def broadcast_notification
    return unless user

    broadcast_append_to(
      "user_#{user.id}_notifications",
      target: "notifications",
      partial: "notifications/notification",
      locals: { notification: self }
    )
  end
end 