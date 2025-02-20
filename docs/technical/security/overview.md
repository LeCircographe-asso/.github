# Sécurité

## Configuration de Base

### Protection CSRF
```ruby
# config/application.rb
config.action_controller.default_protect_from_forgery = true

# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :verify_authenticity_token
end
```

### Headers de Sécurité
```ruby
# config/initializers/security_headers.rb
Rails.application.config.action_dispatch.default_headers = {
  'X-Frame-Options' => 'SAMEORIGIN',
  'X-XSS-Protection' => '1; mode=block',
  'X-Content-Type-Options' => 'nosniff',
  'X-Download-Options' => 'noopen',
  'X-Permitted-Cross-Domain-Policies' => 'none',
  'Referrer-Policy' => 'strict-origin-when-cross-origin'
}
```

## Authentification

### Configuration Sessions
```ruby
# config/initializers/session_store.rb
Rails.application.config.session_store :cookie_store,
  key: '_circographe_session',
  expire_after: 12.hours,
  secure: Rails.env.production?,
  httponly: true,
  same_site: :lax
```

### Protection Brute Force
```ruby
# config/initializers/rack_attack.rb
class Rack::Attack
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip
  end

  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/login' && req.post?
      req.ip
    end
  end
end
```

## Autorisation

### Vérification des Rôles
```ruby
# app/controllers/concerns/role_verification.rb
module RoleVerification
  extend ActiveSupport::Concern

  private

  def require_admin
    unless current_user&.admin?
      audit_unauthorized_access
      redirect_to root_path, alert: "Accès non autorisé"
    end
  end

  def audit_unauthorized_access
    Rails.logger.warn(
      "Tentative d'accès non autorisé: #{current_user&.id} - #{request.path}"
    )
  end
end
```

### Audit Trail
```ruby
# app/models/concerns/auditable.rb
module Auditable
  extend ActiveSupport::Concern

  included do
    has_many :audit_logs, as: :auditable
    
    after_create :log_creation
    after_update :log_changes
    after_destroy :log_deletion
  end

  private

  def log_creation
    record_audit_log('create')
  end

  def log_changes
    record_audit_log('update', changes: saved_changes)
  end

  def log_deletion
    record_audit_log('delete')
  end

  def record_audit_log(action, extras = {})
    AuditLog.create!(
      action: action,
      auditable: self,
      user: Current.user,
      ip_address: Current.ip_address,
      data: extras
    )
  end
end
```

## Protection des Données

### Chiffrement Sensible
```ruby
# app/models/user.rb
class User < ApplicationRecord
  encrypts :phone
  encrypts :emergency_contact
  encrypts :medical_info
end
```

### Nettoyage des Paramètres
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :sanitize_params
  
  private
  
  def sanitize_params
    params.each do |key, value|
      if value.is_a?(String)
        params[key] = Loofah.fragment(value).scrub!(:strip)
      end
    end
  end
end
```

## Monitoring

### Logging Sécurité
```ruby
# config/initializers/lograge.rb
Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.custom_options = lambda do |event|
    {
      user_id: event.payload[:user_id],
      ip: event.payload[:ip],
      params: event.payload[:params].except(*Rails.application.config.filter_parameters)
    }
  end
end
```

### Alertes
```ruby
# app/services/security_alert_service.rb
class SecurityAlertService
  def self.notify_suspicious_activity(user:, action:, ip:)
    return unless suspicious?(action, ip)

    AdminMailer.suspicious_activity(
      user: user,
      action: action,
      ip: ip,
      timestamp: Time.current
    ).deliver_later

    Rails.logger.warn("Activité suspecte: #{action} par #{user.id} depuis #{ip}")
  end
end
``` 