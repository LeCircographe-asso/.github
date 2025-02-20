module Auth
  class SessionsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:new, :create]
    layout 'auth'

    def new
    end

    def create
      user = User.authenticate_by(email: params[:email], password: params[:password])
      
      if user
        sign_in(user, remember: params[:remember_me] == '1')
        redirect_to after_sign_in_path_for(user), notice: 'Connexion réussie'
      else
        flash.now[:alert] = 'Email ou mot de passe invalide'
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      sign_out
      redirect_to root_path, notice: 'Déconnexion réussie'
    end

    private

    def after_sign_in_path_for(user)
      stored_location = session.delete(:return_to)
      stored_location || root_path
    end
  end
end 