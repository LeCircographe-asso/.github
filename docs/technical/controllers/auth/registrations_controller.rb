module Auth
  class RegistrationsController < ApplicationController
    skip_before_action :authenticate_user!
    layout 'auth'

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.email = @user.email.downcase

      if @user.save
        sign_in(@user)
        redirect_to root_path, notice: 'Compte créé avec succès'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name)
    end
  end
end 