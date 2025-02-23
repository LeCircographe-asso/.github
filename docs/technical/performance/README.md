# Performance - Documentation Technique

## Vue d'ensemble
Optimisations de performance pour Rails 8.0 avec focus sur le caching, les requêtes DB et le monitoring.

## Caching

### Russian Doll Caching
```ruby
# app/views/daily_lists/show.html.erb
<%= turbo_frame_tag "daily_list" do %>
  <div class="daily-list">
    <%= render "header", list: @list %>
    
    <% cache @list do %>
      <div class="attendances">
        <% @list.attendances.each do |attendance| %>
          <% cache attendance do %>
            <%= render AttendanceComponent.new(attendance: attendance) %>
          <% end %>
        <% end %>
      </div>
      
      <%= render "stats", list: @list %>
    <% end %>
  </div>
<% end %>
```

### Fragment Caching
```ruby
# app/views/shared/_stats.html.erb
<% cache ["stats", @list.cache_key_with_version] do %>
  <div class="stats-container">
    <div class="stat-card">
      <h3>Total Présents</h3>
      <p><%= @list.attendances.count %></p>
    </div>
    
    <div class="stat-card">
      <h3>Membres Cirque</h3>
      <p><%= @list.circus_members.count %></p>
    </div>
  </div>
<% end %>
```

### Low Level Caching
```ruby
# app/services/stats_service.rb
class StatsService
  def monthly_stats(year, month)
    Rails.cache.fetch(["monthly_stats", year, month], expires_in: 1.hour) do
      calculate_monthly_stats(year, month)
    end
  end
  
  private
  
  def calculate_monthly_stats(year, month)
    DailyAttendanceList
      .where(date: Date.new(year, month)..Date.new(year, month).end_of_month)
      .includes(:attendances)
      .group_by(&:date)
      .transform_values { |lists| lists.sum { |l| l.attendances.size } }
  end
end
```

## Database Optimization

### Indexes
```ruby
# db/migrate/20240220123456_add_performance_indexes.rb
class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :attendances, [:user_id, :daily_attendance_list_id]
    add_index :memberships, [:user_id, :status]
    add_index :payments, [:user_id, :created_at]
  end
end
```

### Eager Loading
```ruby
# app/controllers/daily_lists_controller.rb
class DailyListsController < ApplicationController
  def index
    @lists = DailyAttendanceList
      .includes(attendances: { user: :membership })
      .where(date: 2.weeks.ago..)
      .order(date: :desc)
  end
end
```

### Query Optimization
```ruby
# app/models/daily_attendance_list.rb
class DailyAttendanceList < ApplicationRecord
  scope :with_complete_data, -> {
    includes(attendances: { user: [:membership, :profile] })
      .where(date: 2.weeks.ago..)
      .order(date: :desc)
  }
  
  scope :active_circus_members, -> {
    joins(attendances: { user: :membership })
      .where(memberships: { type: "circus", status: "active" })
  }
  
  def self.attendance_stats
    select("DATE(created_at) as date, COUNT(*) as count")
      .group("DATE(created_at)")
      .order("date DESC")
  end
end
```

## Monitoring

### Application Performance
```ruby
# config/initializers/skylight.rb
Skylight.configure do |config|
  config.environment = Rails.env
  config.enable_segments!
  config.enable_sidekiq!
end
```

### Custom Metrics
```ruby
# app/controllers/concerns/metrics_tracking.rb
module MetricsTracking
  extend ActiveSupport::Concern
  
  included do
    around_action :track_controller_action
  end
  
  private
  
  def track_controller_action
    start_time = Time.current
    
    yield
    
    duration = Time.current - start_time
    StatsD.timing("controller.#{controller_name}.#{action_name}", duration)
  end
end
```

### Background Jobs
```ruby
# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") }
  
  config.server_middleware do |chain|
    chain.add SidekiqMetrics
  end
end

class SidekiqMetrics
  def call(worker, job, queue)
    start = Time.current
    yield
    duration = Time.current - start
    
    StatsD.timing("sidekiq.jobs.#{worker.class.name}", duration)
  end
end
```

## Optimisations Avancées

### Connection Pool
```ruby
# config/database.yml
production:
  adapter: sqlite3
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000
```

### Redis Cache Store
```ruby
# config/environments/production.rb
Rails.application.configure do
  config.cache_store = :redis_cache_store, {
    url: ENV.fetch("REDIS_URL"),
    connect_timeout: 30,
    read_timeout: 0.2,
    write_timeout: 0.2,
    reconnect_attempts: 1,
    error_handler: -> (method:, returning:, exception:) {
      Raven.capture_exception(exception, level: "warning")
    }
  }
end
```

### Active Record Query Cache
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  around_action :use_query_cache
  
  private
  
  def use_query_cache
    ActiveRecord::Base.cache do
      yield
    end
  end
end
``` 