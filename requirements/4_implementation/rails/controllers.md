# Guide d'Implémentation - Controllers

## Configuration de Base

### Application Controller
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Authentication::Authenticatable
  include Authorization::Authorizable
  include Pagy::Backend
  
  before_action :authenticate_user!
  
  private
  
  def current_user
    @current_user ||= authenticate_user_from_session
  end
  helper_method :current_user
  
  def authenticate_user!
    redirect_to login_path, alert: "Connexion requise." unless current_user
  end
end
```

### Authentification Controller
```ruby
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
  end

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

  def destroy
    logout
    redirect_to root_path, notice: "Déconnexion réussie."
  end
end
```

## Controllers Métier

### Memberships Controller
```ruby
# app/controllers/memberships_controller.rb
class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update]

  def index
    @pagy, @memberships = pagy(authorized_scope(Membership.all))
    
    respond_to do |format|
      format.html
      format.turbo_stream if params[:page]
    end
  end

  def new
    @membership = authorize Membership.new
  end

  def create
    @membership = authorize current_user.memberships.build(membership_params)

    respond_to do |format|
      if @membership.save
        format.turbo_stream { 
          render turbo_stream: [
            turbo_stream.prepend("memberships", @membership),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        }
        format.html { redirect_to @membership, notice: "Adhésion créée." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_membership
    @membership = authorize Membership.find(params[:id])
  end

  def membership_params
    params.require(:membership)
          .permit(:type, :start_date, :end_date, :reduced_price)
  end
end
```

### Subscriptions Controller
```ruby
# app/controllers/subscriptions_controller.rb
class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:show, :check_in, :check_out]
  before_action :verify_membership, only: [:new, :create]

  def check_in
    attendance = @subscription.attendances.build(user: current_user)
    
    respond_to do |format|
      if attendance.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@subscription),
            turbo_stream.update("flash", "Présence enregistrée")
          ]
        }
        format.html { redirect_to @subscription }
      else
        format.html { redirect_to @subscription, alert: "Erreur d'enregistrement" }
      end
    end
  end

  private

  def verify_membership
    unless current_user.active_circus_membership?
      redirect_to memberships_path, 
                  alert: "Adhésion cirque requise pour acheter une cotisation"
    end
  end
end
```

## Admin Controllers

### Admin::BaseController
```ruby
# app/controllers/admin/base_controller.rb
class Admin::BaseController < ApplicationController
  before_action :require_admin
  layout 'admin'

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: "Accès non autorisé"
    end
  end
end
```

### Admin::UsersController
```ruby
# app/controllers/admin/users_controller.rb
class Admin::UsersController < Admin::BaseController
  def index
    @q = User.ransack(params[:q])
    @pagy, @users = pagy(@q.result)

    respond_to do |format|
      format.html
      format.turbo_stream if params[:page] || params[:q]
    end
  end

  def update_role
    @user = User.find(params[:id])
    authorize @user, :manage_roles?

    if @user.update(role_params)
      respond_to do |format|
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace(@user)
        }
        format.html { redirect_to admin_users_path }
      end
    end
  end
end
``` 