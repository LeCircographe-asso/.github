# Controllers et Routes

## Configuration Routes

### Routes Principales
```ruby
# config/routes.rb
Rails.application.routes.draw do
  # Authentication
  resources :sessions, only: [:new, :create, :destroy]
  resources :registrations, only: [:new, :create]
  
  # Public Routes
  root 'pages#home'
  
  resources :memberships, only: [:new, :create] do
    post :upgrade, on: :collection
  end

  # Member Routes
  authenticate :user do
    resources :subscriptions do
      get :history, on: :collection
    end
    
    resources :attendances, only: [:index, :show]
    resources :payments, only: [:index, :show]
    
    namespace :account do
      resource :profile, only: [:show, :edit, :update]
      resources :notifications, only: [:index, :show]
    end
  end

  # Volunteer Routes
  namespace :volunteer do
    resources :attendances, only: [:new, :create, :index]
    resources :memberships
    resources :payments, only: [:new, :create]
  end

  # Admin Routes
  namespace :admin do
    root to: 'dashboard#show'
    
    resources :users do
      member do
        patch :activate
        patch :deactivate
      end
    end
    
    resources :stats, only: [:index] do
      collection do
        get :daily
        get :monthly
        get :yearly
      end
    end
    
    resources :settings, only: [:index, :update]
  end
end
```

## Controllers

### Application Controller
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include Authentication
  include Authorization::Authorizable
  include ErrorHandling
  
  before_action :set_current_attributes
  before_action :authenticate_user!
  
  protected

  def set_current_attributes
    Current.user = current_user
    Current.ip_address = request.remote_ip
    Current.user_agent = request.user_agent
  end

  def authorize!(action, record)
    policy = "#{record.class}Policy".constantize.new(current_user, record)
    unless policy.public_send("#{action}?")
      raise NotAuthorizedError, "Non autorisé à #{action} ce #{record.class}"
    end
  end
end
```

### Memberships Controller
```ruby
# app/controllers/memberships_controller.rb
class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]
  before_action -> { authorize!(:update, @membership) }, only: [:edit, :update]

  def new
    @membership = current_user.memberships.build
  end

  def create
    @membership = current_user.memberships.build(membership_params)
    
    if MembershipService.create_or_upgrade(
      user: current_user,
      type: params[:type],
      reduced_price: params[:reduced_price]
    )
      redirect_to root_path, notice: "Adhésion créée avec succès"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def upgrade
    if MembershipService.create_or_upgrade(
      user: current_user,
      type: 'circus',
      reduced_price: params[:reduced_price]
    )
      redirect_to root_path, notice: "Adhésion mise à niveau avec succès"
    else
      redirect_to root_path, alert: "Impossible de mettre à niveau l'adhésion"
    end
  end

  def update
    if @membership.update(membership_params)
      redirect_to @membership, notice: 'Adhésion mise à jour.'
    else
      render :edit
    end
  end

  private

  def set_membership
    @membership = current_user.memberships.find(params[:id])
  end

  def membership_params
    params.require(:membership).permit(:type, :reduced_price)
  end
end
```

### Admin::Stats Controller
```ruby
# app/controllers/admin/stats_controller.rb
class Admin::StatsController < Admin::BaseController
  def index
    @stats = {
      total_users: User.count,
      active_memberships: Membership.active.count,
      monthly_revenue: Payment.this_month.sum(:amount),
      daily_attendance: Attendance.today.count
    }
  end

  def daily
    @date = params[:date]&.to_date || Date.current
    @stats = DailyStatsService.generate(@date)
    
    respond_to do |format|
      format.html
      format.json { render json: @stats }
      format.csv { send_data @stats.to_csv }
    end
  end

  def monthly
    @month = params[:month]&.to_date || Date.current.beginning_of_month
    @stats = MonthlyStatsService.generate(@month)
    
    render turbo_stream: turbo_stream.replace(
      "monthly_stats",
      partial: "monthly_stats",
      locals: { stats: @stats }
    )
  end
end 