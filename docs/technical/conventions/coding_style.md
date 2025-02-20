# Conventions de Code

## Style Ruby

### Nommage
```ruby
# ✅ Bon nommage
class UserAuthentication
  def authenticate_with_credentials(email, password)
    # ...
  end
end

# ❌ Mauvais nommage
class Auth
  def auth(e, p)
    # ...
  end
end

# Constantes
MAXIMUM_LOGIN_ATTEMPTS = 3
DEFAULT_MEMBERSHIP_DURATION = 1.year

# Modules et Namespaces
module Memberships
  module Payments
    class ProcessorService
      # ...
    end
  end
end
```

### Formatage
```ruby
# Indentation : 2 espaces
class Membership
  belongs_to :user
  
  def calculate_price
    base_price = 10.0
    apply_discounts(base_price)
  end
  
  private
  
  def apply_discounts(price)
    price *= 0.7 if reduced_price?
    price
  end
end

# Espacement
# ✅ Bon espacement
def process_payment(amount, method:)
  return if amount.zero?
  
  Payment.create!(
    amount: amount,
    method: method,
    processed_at: Time.current
  )
end

# ❌ Mauvais espacement
def process_payment(amount,method:)
  return if amount.zero?
  Payment.create!(amount:amount,method:method,processed_at:Time.current)
end
```

## Conventions Rails

### Structure MVC
```ruby
# app/models/user.rb
class User < ApplicationRecord
  # 1. Extensions/Includes
  devise :database_authenticatable, :registerable
  include Auditable
  
  # 2. Associations
  has_many :memberships
  belongs_to :referrer, optional: true
  
  # 3. Validations
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  
  # 4. Callbacks
  before_create :generate_reference
  
  # 5. Scopes
  scope :active, -> { where(active: true) }
  scope :with_active_membership, -> { joins(:memberships).merge(Membership.active) }
  
  # 6. Class methods
  def self.search(query)
    where("name ILIKE ? OR email ILIKE ?", "%#{query}%", "%#{query}%")
  end
  
  # 7. Instance methods
  def full_name
    [first_name, last_name].compact.join(' ')
  end
  
  private # 8. Private methods
  
  def generate_reference
    self.reference = SecureRandom.hex(6).upcase
  end
end
```

### Routes et Controllers
```ruby
# config/routes.rb
Rails.application.routes.draw do
  # RESTful resources
  resources :memberships do
    member do
      patch :renew
      patch :cancel
    end
    
    collection do
      get :expired
    end
  end
  
  # Namespaces cohérents
  namespace :admin do
    resources :users
    resources :payments
  end
end

# app/controllers/memberships_controller.rb
class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]
  
  def index
    @memberships = current_user.memberships.includes(:payments)
  end
  
  def show
    respond_to do |format|
      format.html
      format.pdf { render pdf: generate_pdf }
    end
  end
  
  private
  
  def set_membership
    @membership = Membership.find(params[:id])
  end
  
  def membership_params
    params.require(:membership)
          .permit(:type, :start_date, :end_date, :reduced_price)
  end
end
```

## Conventions de Vue

### Partials et Helpers
```ruby
# app/helpers/application_helper.rb
module ApplicationHelper
  def page_title(title = nil)
    base = "Le Circographe"
    title.present? ? "#{title} | #{base}" : base
  end
  
  def format_price(amount)
    number_to_currency(amount, unit: "€", format: "%n %u")
  end
end

# app/views/memberships/_membership.html.erb
<div class="membership-card" id="<%= dom_id(membership) %>">
  <%= render "memberships/header", membership: membership %>
  
  <div class="membership-details">
    <%= render "memberships/status", membership: membership %>
    <%= render "memberships/actions", membership: membership if membership.active? %>
  </div>
</div>
```

### Organisation JavaScript
```javascript
// app/javascript/controllers/membership_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["priceDisplay", "reducedPrice"]
  
  connect() {
    this.updatePrice()
  }
  
  updatePrice() {
    const basePrice = 10
    const price = this.reducedPriceTarget.checked ? basePrice * 0.7 : basePrice
    this.priceDisplayTarget.textContent = `${price}€`
  }
}
```

## Conventions de Test

### Structure RSpec
```ruby
# spec/models/membership_spec.rb
RSpec.describe Membership, type: :model do
  # 1. Factories et let
  let(:user) { create(:user) }
  let(:membership) { build(:membership, user: user) }
  
  # 2. Validations et associations
  describe "validations" do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should belong_to(:user) }
  end
  
  # 3. Méthodes et comportements
  describe "#active?" do
    context "when membership is current" do
      it "returns true" do
        membership.start_date = 1.day.ago
        membership.end_date = 1.day.from_now
        expect(membership).to be_active
      end
    end
  end
  
  # 4. Callbacks et effets de bord
  describe "after create" do
    it "sends welcome email" do
      expect { membership.save! }
        .to have_enqueued_mail(MembershipMailer, :welcome_email)
    end
  end
end
``` 