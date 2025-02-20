# Guide d'Implémentation - Routes

## Configuration des Routes

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # Pages publiques
  root "pages#home"
  resources :schedules, only: [:index]  # Horaires publics
  resources :events, only: [:index, :show]  # Événements publics
  
  # Authentification
  devise_for :users
  
  # Espaces par rôle
  namespace :member do
    resources :attendances, only: [:index, :show]
    resources :events, only: [:index, :show] do
      member do
        post :mark_interested
      end
    end
  end
  
  namespace :volunteer do
    resources :dashboard, only: [:index]
    resources :attendances
    resources :payments
    resources :memberships, only: [:new, :create]
  end
  
  namespace :admin do
    resources :dashboard, only: [:index]
    resources :users
    resources :roles
    resources :memberships
    resources :reports
  end
  
  namespace :super_admin do
    resources :system_settings
    resources :logs
    resources :backups
  end

  # Interface Membre
  resources :memberships, except: [:destroy] do
    member do
      post :renew
    end
  end

  resources :subscriptions do
    member do
      post :check_in
      post :check_out
    end
  end

  resources :attendances, only: [:index, :create, :destroy]

  # Interface Admin
  namespace :admin do
    root to: "dashboard#index"
    
    resources :users do
      member do
        patch :update_role
        patch :toggle_active
      end
      collection do
        get :search
      end
    end

    resources :memberships do
      collection do
        get :expiring
        get :statistics
      end
    end

    resources :payments do
      collection do
        get :daily_report
        get :export
      end
    end

    resources :statistics, only: [:index] do
      collection do
        get :attendance
        get :financial
      end
    end
  end

  # API Routes (future)
  namespace :api do
    namespace :v1 do
      resources :users, only: [:show]
      resources :attendances, only: [:create]
    end
  end
end
```

## Points Importants

### Contraintes de Routes
```ruby
# Contraintes pour l'admin
constraints ->(req) { req.env["warden"].user&.admin? } do
  # Routes admin
end

# Contraintes pour les bénévoles
constraints ->(req) { req.env["warden"].user&.volunteer? } do
  # Routes bénévoles
end
```

### Routes Turbo
```ruby
# Support des frames Turbo
resources :users do
  member do
    get :card, defaults: { format: :turbo_stream }
  end
end
``` 