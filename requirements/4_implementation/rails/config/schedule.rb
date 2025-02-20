# Utilise whenever pour configurer les cron jobs
every 1.hour do
  runner "NotificationCheckJob.perform_later"
end

# Nettoyage des anciennes notifications
every 1.day, at: '00:30' do
  runner "Notification.cleanup_old"
end 