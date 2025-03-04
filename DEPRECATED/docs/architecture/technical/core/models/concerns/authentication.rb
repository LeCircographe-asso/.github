module Authentication
  extend ActiveSupport::Concern

  included do
    has_secure_password
    
    validates :email, presence: true, 
                     uniqueness: true,
                     format: { with: URI::MailTo::EMAIL_REGEXP }
  end

  module ClassMethods
    def authenticate_by_token(token)
      return nil if token.blank?
      
      user = find_by(remember_token: token)
      return nil unless user&.remember_token_expires_at&.future?
      
      user
    end
  end
end

# app/controllers/concerns/authentication_concern.rb
module AuthenticationConcern
  extend ActiveSupport::Concern
  
  included do
    helper_method :current_user, :user_signed_in?
    before_action :authenticate_user!
  end

  def authenticate_user!
    unless current_user
      store_location
      redirect_to login_path, alert: "Veuillez vous connecter"
    end
  end

  def current_user
    @current_user ||= begin
      if session[:user_id]
        User.find_by(id: session[:user_id])
      elsif cookies.signed[:remember_token]
        User.authenticate_by_token(cookies.signed[:remember_token])
      end
    end
  end

  def user_signed_in?
    current_user.present?
  end

  def sign_in(user, remember: false)
    session[:user_id] = user.id
    if remember
      user.remember_me
      cookies.signed[:remember_token] = {
        value: user.remember_token,
        expires: user.remember_token_expires_at
      }
    end
  end

  def sign_out
    current_user&.forget_me
    session.delete(:user_id)
    cookies.delete(:remember_token)
    @current_user = nil
  end

  private

  def store_location
    session[:return_to] = request.fullpath if request.get?
  end
end 