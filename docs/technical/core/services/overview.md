# Services et Jobs

## Services Métier

### Membership Service
```ruby
# app/services/membership_service.rb
class MembershipService
  def self.create_or_upgrade(user:, type:, reduced_price: false)
    ActiveRecord::Base.transaction do
      case type
      when 'basic'
        create_basic_membership(user)
      when 'circus'
        upgrade_to_circus(user, reduced_price)
      end
    end
  end

  private

  def self.create_basic_membership(user)
    return false if user.active_basic_membership?

    user.memberships.create!(
      type: 'BasicMembership',
      start_date: Time.current,
      end_date: 1.year.from_now
    )
  end

  def self.upgrade_to_circus(user, reduced_price)
    return false unless user.active_basic_membership?
    return false if user.active_circus_membership?

    user.memberships.create!(
      type: 'CircusMembership',
      start_date: Time.current,
      end_date: 1.year.from_now,
      reduced_price: reduced_price
    )
  end
end
```

### Payment Service
```ruby
# app/services/payment_service.rb
class PaymentService
  def self.process(payable:, amount:, method:, user:, recorded_by:)
    ActiveRecord::Base.transaction do
      payment = Payment.create!(
        payable: payable,
        amount: amount,
        payment_method: method,
        user: user,
        recorded_by: recorded_by
      )

      # Génération reçu
      receipt = ReceiptService.generate(payment)
      
      # Notification
      NotificationService.payment_received(payment)

      payment
    end
  rescue => e
    Rails.logger.error("Erreur paiement: #{e.message}")
    false
  end
end
```

## Background Jobs

### Renewal Reminder Job
```ruby
# app/jobs/renewal_reminder_job.rb
class RenewalReminderJob < ApplicationJob
  queue_as :default

  def perform
    Membership.expiring_soon.find_each do |membership|
      NotificationMailer.renewal_reminder(membership).deliver_later
    end
  end
end
```

### Daily Stats Job
```ruby
# app/jobs/daily_stats_job.rb
class DailyStatsJob < ApplicationJob
  queue_as :stats

  def perform(date = Date.yesterday)
    stats = {
      total_visits: Attendance.for_date(date).count,
      unique_visitors: Attendance.for_date(date).distinct.count(:user_id),
      new_memberships: Membership.created_on(date).count,
      revenue: Payment.for_date(date).sum(:amount)
    }

    DailyStats.create!(date: date, data: stats)
    
    # Alerte si anomalies
    AlertService.check_daily_stats(stats) if Rails.env.production?
  end
end
```

### Cleanup Job
```ruby
# app/jobs/cleanup_job.rb
class CleanupJob < ApplicationJob
  queue_as :maintenance

  def perform
    # Nettoyage des sessions expirées
    ActiveRecord::SessionStore::Session
      .where('updated_at < ?', 2.weeks.ago)
      .delete_all

    # Archivage des vieux logs
    AuditLog
      .where('created_at < ?', 6.months.ago)
      .find_each do |log|
        ArchiveService.archive_log(log)
      end
  end
end
```

## Configuration Sidekiq

### Initializer
```ruby
# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1') }

  config.on(:startup) do
    schedule_file = "config/schedule.yml"
    if File.exist?(schedule_file)
      Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end
  end
end
```

### Schedule
```yaml
# config/schedule.yml
renewal_reminder:
  cron: "0 8 * * *"  # Tous les jours à 8h
  class: "RenewalReminderJob"
  queue: default

daily_stats:
  cron: "0 1 * * *"  # Tous les jours à 1h
  class: "DailyStatsJob"
  queue: stats

cleanup:
  cron: "0 2 * * 0"  # Tous les dimanches à 2h
  class: "CleanupJob"
  queue: maintenance
``` 