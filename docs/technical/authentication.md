# Système d'Authentification

## Configuration Native Rails 8

### Installation
```ruby
# Installation du système d'authentification
rails generate authentication:install
rails generate authentication:user User
```

### Structure Générée
```
app/
├── controllers/
│   ├── auth/
│   │   ├── sessions_controller.rb     # Gestion des sessions
│   │   └── passwords_controller.rb    # Réinitialisation mot de passe
│   └── concerns/
│       └── authentication_concern.rb  # Méthodes d'authentification
├── models/
│   └── user.rb                       # Modèle utilisateur avec auth
└── views/
    └── auth/
        ├── sessions/                 # Formulaires connexion
        └── passwords/                # Formulaires mot de passe
```

### Fonctionnalités Incluses
- Session-based authentication
- Remember me functionality
- Password reset
- Email verification
- Protection CSRF
- Session security
- HTTP Basic Auth (optionnel)

### Configuration Sessions
```ruby
# config/initializers/session_store.rb
Rails.application.config.session_store :cookie_store, 
  key: '_circographe_session',
  expire_after: 12.hours,
  secure: Rails.env.production?
```

### Modèle User
```ruby
# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  
  # Relations
  has_many :memberships, dependent: :destroy
  has_many :roles, through: :user_roles
  
  # Validations
  validates :email, presence: true, 
                   uniqueness: true,
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :member_number, uniqueness: true, allow_nil: true
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
  
  # Callbacks
  before_create :generate_member_number
  
  private
  
  def generate_member_number
    return if member_number.present?
    
    year = Time.current.strftime("%y")
    last_number = User.where("member_number LIKE ?", "#{year}%")
                     .maximum(:member_number)
                     &.last(4)
                     &.to_i || 0
    
    self.member_number = "#{year}#{format('%04d', last_number + 1)}"
  end
end
```

### Protection CSRF
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  
  private
  
  def authenticate_user!
    unless current_user
      store_location
      redirect_to auth_login_path, alert: "Connexion requise"
    end
  end
  
  def store_location
    session[:return_to] = request.fullpath if request.get?
  end
end
```

### Helpers Disponibles
- `current_user` : Utilisateur connecté
- `user_signed_in?` : Vérifie si un utilisateur est connecté
- `authenticate_user!` : Force l'authentification
- `sign_in(user)` : Connecte un utilisateur
- `sign_out` : Déconnecte l'utilisateur

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