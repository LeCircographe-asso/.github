# Sécurité - Documentation Technique

## Vue d'ensemble
Utilisation du système d'authentification natif de Rails 8.0, généré via `rails g authenticate`.

## Authentication

### Configuration de Base
```ruby
# config/application.rb
module Circographe
  class Application < Rails::Application
    config.load_defaults 8.0
    
    # Configuration de la session
    config.session_store :cookie_store, 
      key: "_circographe_session",
      secure: Rails.env.production?,
      same_site: :lax
  end
end
```

### Authentication Concern (Rails 8.0 Native)
```ruby
# app/controllers/concerns/authentication.rb
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  def current_user
    Current.user if authenticated?
  end

  private
    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      Current.session ||= find_session_by_cookie
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id])
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    def start_new_session_for(user)
      user.sessions.create!(
        user_agent: request.user_agent, 
        ip_address: request.remote_ip
      ).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { 
          value: session.id, 
          httponly: true, 
          same_site: :lax 
        }
      end
    end

    def terminate_session
      Current.session.destroy
      cookies.delete(:session_id)
    end
end
```

### Current (Rails 8.0 Native)
```ruby
# app/models/current.rb
class Current < ActiveSupport::CurrentAttributes
  attribute :session
  attribute :user

  def user=(user)
    super
    self.session = nil
  end

  def session=(session)
    super
    self.user = session&.user
  end
end
```

### Modèle Session
```ruby
# app/models/session.rb
class Session < ApplicationRecord
  belongs_to :user
  
  validates :user_agent, presence: true
  validates :ip_address, presence: true
  
  before_create :set_expiry
  
  scope :active, -> { where("expires_at > ?", Time.current) }
  scope :expired, -> { where("expires_at <= ?", Time.current) }
  
  private
  
  def set_expiry
    self.expires_at = 2.weeks.from_now
  end
end
```

### Controller Sessions
```ruby
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    
    if user&.authenticate(params[:password])
      start_new_session_for(user)
      redirect_to after_authentication_url, notice: "Connexion réussie"
    else
      flash.now[:alert] = "Email ou mot de passe invalide"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "Déconnexion réussie"
  end
end
```

### Application Controller
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Authentication
end
```

## Protection des Données

### Strong Parameters
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Authentication
  
  private
  
  def authorize!(action, resource)
    unless current_user&.can?(action, resource)
      redirect_to root_path, alert: "Accès non autorisé"
    end
  end
end
```

## Audit et Logging

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
    record_audit("created")
  end

  def log_changes
    record_audit("updated", changes: saved_changes)
  end

  def log_deletion
    record_audit("deleted")
  end

  def record_audit(action, extras = {})
    AuditLog.create!(
      action: action,
      auditable: self,
      user: Current.user,
      ip_address: Current.ip_address,
      **extras
    )
  end
end
```

## Headers de Sécurité
```ruby
# config/initializers/security_headers.rb
Rails.application.config.action_dispatch.default_headers = {
  'X-Frame-Options' => 'SAMEORIGIN',
  'X-XSS-Protection' => '0',  # Désactivé car redondant avec CSP dans Rails 8.0
  'X-Content-Type-Options' => 'nosniff',
  'X-Download-Options' => 'noopen',
  'X-Permitted-Cross-Domain-Policies' => 'none',
  'Referrer-Policy' => 'strict-origin-when-cross-origin',
  'Content-Security-Policy' => Rails.application.config.content_security_policy&.build
}
``` 