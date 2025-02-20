# config/routes.rb
Rails.application.routes.draw do
  # Routes d'authentification
  namespace :auth do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    
    get 'register', to: 'registrations#new'
    post 'register', to: 'registrations#create'
  end

  # Autres routes...
end 