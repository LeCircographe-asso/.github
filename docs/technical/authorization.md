# Système d'Autorisation

## Configuration

### Module d'Autorisation
```ruby
# app/models/concerns/authorizable.rb
module Authorizable
  extend ActiveSupport::Concern

  included do
    has_many :roles, dependent: :destroy
    
    def has_role?(role_name)
      roles.exists?(name: role_name)
    end

    def add_role(role_name)
      roles.create(name: role_name) unless has_role?(role_name)
    end
  end
end
```

### Intégration Controller
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Authorization::Authorizable
  
  before_action :authenticate_user!
  
  private
  
  def authorize_action(record, action_name)
    unless current_user.can?(action_name, record)
      redirect_to root_path, alert: "Action non autorisée"
    end
  end
end
```

## Permissions

### Définition des Rôles
```ruby
# app/models/role.rb
class Role < ApplicationRecord
  AVAILABLE_ROLES = %w[member volunteer admin super_admin].freeze
  
  belongs_to :user
  
  validates :name, presence: true, inclusion: { in: AVAILABLE_ROLES }
  validates :user_id, uniqueness: { scope: :name }
end
```

### Vérification des Droits
```ruby
# app/controllers/concerns/authorization_helper.rb
module AuthorizationHelper
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "Accès administrateur requis"
    end
  end

  def require_volunteer
    unless current_user&.volunteer?
      redirect_to root_path, alert: "Accès bénévole requis"
    end
  end
end 