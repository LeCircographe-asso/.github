# Système d'Authentification

## Configuration Native Rails 8

### Installation
```ruby
# Installation du système d'authentification
rails generate authentication:install
rails generate authentication:user User
```

### Personnalisation
```ruby
# app/models/user.rb
class User < ApplicationRecord
  include Authentication::Authenticatable
  
  # Validations supplémentaires
  validates :email, presence: true, 
                   uniqueness: true,
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :member_number, uniqueness: true, allow_nil: true
  
  # Callbacks
  before_create :generate_member_number
end
```

### Sessions Controller
```ruby
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def create
    user = User.authenticate_by(email: params[:email], password: params[:password])
    
    if user
      login user
      redirect_to root_path, notice: "Connexion réussie !"
    else
      flash.now[:alert] = "Email ou mot de passe invalide."
      render :new, status: :unprocessable_entity
    end
  end
end
```

## Sécurité

### Protection CSRF
```ruby
# config/application.rb
config.action_controller.default_protect_from_forgery = true
```

### Sessions
```ruby
# config/initializers/session_store.rb
Rails.application.config.session_store :cookie_store, 
  key: '_circographe_session',
  expire_after: 12.hours,
  secure: Rails.env.production?
```

### Mots de Passe
- Hashage bcrypt
- Complexité minimale requise
- Réinitialisation sécurisée 