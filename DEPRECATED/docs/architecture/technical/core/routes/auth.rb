# config/routes.rb
Rails.application.routes.draw do
  # Routes d'authentification générées par Rails 8
  get  '/login', to: 'auth/sessions#new'
  post '/login', to: 'auth/sessions#create'
  get  '/logout', to: 'auth/sessions#destroy'
  
  # Routes de réinitialisation de mot de passe
  get  '/password/new', to: 'auth/passwords#new'
  post '/password/reset', to: 'auth/passwords#create'
  get  '/password/edit', to: 'auth/passwords#edit'
  patch '/password/update', to: 'auth/passwords#update'

  # Autres routes...
end 