module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?, :current_user, :turbo_frame_request?
    delegate :turbo_frame_request_id, to: :request
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
      Current.session&.extend_expiry
      Current.session.present?
    end

    def find_session_by_cookie
      Session.active.find_by(id: cookies.signed[:session_id])
    end

    def request_authentication
      respond_to do |format|
        format.html do
          session[:return_to_after_authenticating] = request.url
          redirect_to new_session_path
        end
        format.turbo_stream { 
          render turbo_stream: [
            turbo_stream.replace("content", partial: "sessions/login_required"),
            turbo_stream.update("flash", partial: "shared/flash", locals: { message: "Authentification requise", type: "warning" })
          ]
        }
        format.json { render json: { error: "Authentication required" }, status: :unauthorized }
      end
    end

    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    def start_new_session_for(user)
      user.sessions.create!(
        user_agent: request.user_agent, 
        ip_address: request.remote_ip,
        last_active_at: Time.current
      ).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { 
          value: session.id, 
          httponly: true, 
          same_site: :lax,
          secure: Rails.env.production? 
        }
        broadcast_login_to_user(user)
        track_authentication_event("login", user)
      end
    end

    def terminate_session
      track_authentication_event("logout", Current.user)
      broadcast_logout_to_user(Current.user)
      Current.session.destroy
      cookies.delete(:session_id)
      reset_session
    end

    def broadcast_login_to_user(user)
      broadcast_replace_to(
        user, 
        target: "session_status",
        partial: "shared/session_status",
        locals: { user: user }
      )
    end

    def broadcast_logout_to_user(user)
      broadcast_replace_to(
        user,
        target: "session_status",
        partial: "shared/session_status",
        locals: { user: nil }
      )
    end

    def track_authentication_event(action, user)
      SecurityEvent.create!(
        action: action,
        user: user,
        ip_address: request.remote_ip,
        user_agent: request.user_agent,
        metadata: {
          timestamp: Time.current,
          success: true
        }
      )
    end

    def turbo_frame_request?
      turbo_frame_request_id.present?
    end
end
