# API Documentation

## Configuration

### API Versioning
```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :memberships, only: [:index, :show, :create]
      resources :attendances, only: [:create, :index]
      resources :stats, only: [:index]
      
      get 'user/profile', to: 'users#profile'
    end
  end
end
```

### Base Controller
```ruby
# app/controllers/api/v1/base_controller.rb
module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_api_token!

      private

      def authenticate_api_token!
        token = request.headers['Authorization']&.split(' ')&.last
        @current_api_user = User.find_by_valid_api_token(token)

        unless @current_api_user
          render json: { error: 'Invalid API token' }, status: :unauthorized
        end
      end

      def current_api_user
        @current_api_user
      end
    end
  end
end
```

## Endpoints

### Memberships API
```ruby
# app/controllers/api/v1/memberships_controller.rb
module Api
  module V1
    class MembershipsController < BaseController
      def index
        @memberships = current_api_user.memberships.active
        
        render json: MembershipSerializer.new(@memberships).serializable_hash
      end

      def show
        @membership = current_api_user.memberships.find(params[:id])
        
        render json: MembershipSerializer.new(@membership).serializable_hash
      end

      def create
        result = MembershipService.create_or_upgrade(
          user: current_api_user,
          type: membership_params[:type],
          reduced_price: membership_params[:reduced_price]
        )

        if result.success?
          render json: MembershipSerializer.new(result.membership).serializable_hash,
                 status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      private

      def membership_params
        params.require(:membership).permit(:type, :reduced_price)
      end
    end
  end
end
```

### Attendances API
```ruby
# app/controllers/api/v1/attendances_controller.rb
module Api
  module V1
    class AttendancesController < BaseController
      def create
        @attendance = current_api_user.attendances.build(attendance_params)
        @attendance.recorded_by = current_api_user

        if @attendance.save
          render json: AttendanceSerializer.new(@attendance).serializable_hash,
                 status: :created
        else
          render json: { errors: @attendance.errors }, status: :unprocessable_entity
        end
      end

      def index
        @attendances = current_api_user.attendances
                                     .includes(:subscription)
                                     .order(attended_on: :desc)
                                     .page(params[:page])
                                     .per(20)

        render json: {
          attendances: AttendanceSerializer.new(@attendances).serializable_hash,
          meta: {
            total_pages: @attendances.total_pages,
            current_page: @attendances.current_page,
            total_count: @attendances.total_count
          }
        }
      end

      private

      def attendance_params
        params.require(:attendance).permit(:attended_on, :attendance_type)
      end
    end
  end
end
```

## Serializers

### Membership Serializer
```ruby
# app/serializers/membership_serializer.rb
class MembershipSerializer
  include JSONAPI::Serializer
  
  attributes :type, :start_date, :end_date, :reduced_price
  
  attribute :status do |membership|
    if membership.end_date < Date.current
      'expired'
    elsif membership.start_date > Date.current
      'pending'
    else
      'active'
    end
  end

  attribute :remaining_days do |membership|
    (membership.end_date - Date.current).to_i if membership.end_date >= Date.current
  end
end
```

### Attendance Serializer
```ruby
# app/serializers/attendance_serializer.rb
class AttendanceSerializer
  include JSONAPI::Serializer
  
  attributes :attended_on, :attendance_type
  
  belongs_to :subscription, if: Proc.new { |record| record.subscription.present? }
  
  attribute :subscription_info do |attendance|
    if attendance.subscription
      {
        type: attendance.subscription.type,
        remaining_entries: attendance.subscription.remaining_entries
      }
    end
  end
end
``` 