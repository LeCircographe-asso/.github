class AuditService
  def self.track_action(action, target, details = {})
    AuditLog.create!(
      action: action,
      target: target,
      user: Current.user,
      details: details.merge(
        ip: Current.ip_address,
        user_agent: Current.user_agent,
        timestamp: Time.current
      )
    )
  rescue => e
    Rails.logger.error "Erreur d'audit: #{e.message}"
    Sentry.capture_exception(e) if defined?(Sentry)
    false
  end

  def self.activity_for(user, start_date: 30.days.ago)
    AuditLog.where(user: user)
           .where('created_at > ?', start_date)
           .order(created_at: :desc)
  end
end 