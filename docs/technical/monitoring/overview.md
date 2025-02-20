# Monitoring et Maintenance

## Monitoring

### Configuration Lograge
```ruby
# config/initializers/lograge.rb
Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    {
      time: event.time,
      user_id: event.payload[:user_id],
      params: event.payload[:params].except(*Rails.application.config.filter_parameters),
      ip: event.payload[:ip],
      request_id: event.payload[:request_id]
    }
  end
end
```

### Sentry Configuration
```ruby
# config/initializers/sentry.rb
Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  
  config.traces_sample_rate = 0.5
  config.send_default_pii = false
  
  config.before_send = lambda do |event, hint|
    if hint[:exception].is_a?(ActiveRecord::RecordNotFound)
      nil
    else
      event
    end
  end
end
```

### Prometheus Metrics
```ruby
# config/initializers/prometheus.rb
require 'prometheus/client'

PROMETHEUS_REGISTRY = Prometheus::Client.registry

# Métriques personnalisées
HTTP_REQUESTS_TOTAL = PROMETHEUS_REGISTRY.counter(
  :http_requests_total,
  docstring: 'Total number of HTTP requests',
  labels: [:method, :path, :status]
)

ACTIVE_USERS_GAUGE = PROMETHEUS_REGISTRY.gauge(
  :active_users,
  docstring: 'Number of active users'
)

MEMBERSHIP_OPERATIONS = PROMETHEUS_REGISTRY.histogram(
  :membership_operations_duration_seconds,
  docstring: 'Membership operation duration',
  labels: [:operation]
)
```

## Maintenance

### Tâches de Nettoyage
```ruby
# lib/tasks/maintenance.rake
namespace :maintenance do
  desc 'Clean expired sessions'
  task clean_sessions: :environment do
    ActiveRecord::SessionStore::Session
      .where('updated_at < ?', 2.weeks.ago)
      .delete_all
  end

  desc 'Archive old audit logs'
  task archive_logs: :environment do
    AuditLog
      .where('created_at < ?', 6.months.ago)
      .find_each do |log|
        ArchiveService.archive_log(log)
      end
  end

  desc 'Clean temporary files'
  task clean_temp_files: :environment do
    TempFile
      .where('created_at < ?', 24.hours.ago)
      .find_each(&:purge)
  end
end
```

### Backup Configuration
```ruby
# config/schedule.rb
set :output, 'log/cron.log'

every 1.day, at: '4:30 am' do
  command "pg_dump -Fc circographe_production > #{Rails.root}/backups/db-#{Time.current.strftime('%Y%m%d')}.dump"
end

every 1.day, at: '5:00 am' do
  rake 'backup:upload_to_s3'
end

# lib/tasks/backup.rake
namespace :backup do
  desc 'Upload backup to S3'
  task upload_to_s3: :environment do
    backup_file = Dir["#{Rails.root}/backups/db-*.dump"].sort.last
    
    if backup_file
      s3 = Aws::S3::Client.new
      File.open(backup_file, 'rb') do |file|
        s3.put_object(
          bucket: ENV['AWS_BACKUP_BUCKET'],
          key: File.basename(backup_file),
          body: file
        )
      end
    end
  end
end
```

### Healthcheck
```ruby
# app/controllers/monitoring/health_controller.rb
module Monitoring
  class HealthController < ActionController::Base
    def show
      checks = {
        db: check_database,
        redis: check_redis,
        sidekiq: check_sidekiq
      }
      
      status = checks.values.all? ? :ok : :service_unavailable
      
      render json: {
        status: status,
        checks: checks,
        version: Rails.application.config.version,
        timestamp: Time.current
      }, status: status
    end
    
    private
    
    def check_database
      ActiveRecord::Base.connection.execute('SELECT 1')
      true
    rescue StandardError
      false
    end
    
    def check_redis
      Redis.current.ping == 'PONG'
    rescue StandardError
      false
    end
    
    def check_sidekiq
      Sidekiq::ProcessSet.new.size.positive?
    rescue StandardError
      false
    end
  end
end
``` 