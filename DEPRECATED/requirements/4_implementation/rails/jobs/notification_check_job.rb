class NotificationCheckJob < ApplicationJob
  queue_as :notifications

  def perform
    NotificationService.check_and_notify
  rescue => e
    Rails.logger.error "Erreur lors de la vérification des notifications: #{e.message}"
    Sentry.capture_exception(e) if defined?(Sentry)
    raise e
  end
end 