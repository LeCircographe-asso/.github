# Tests et Qualité

## Configuration RSpec

### Configuration de Base
```ruby
# spec/rails_helper.rb
require 'spec_helper'
require 'capybara/rspec'
require 'webmock/rspec'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
```

### Factories
```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    name { "John Doe" }
    
    trait :with_basic_membership do
      after(:create) do |user|
        create(:membership, :basic, user: user)
      end
    end
    
    trait :with_circus_membership do
      after(:create) do |user|
        create(:membership, :circus, user: user)
      end
    end
    
    trait :volunteer do
      after(:create) do |user|
        user.add_role(:volunteer)
      end
    end
  end
end

# spec/factories/memberships.rb
FactoryBot.define do
  factory :membership do
    user
    start_date { Date.current }
    end_date { 1.year.from_now }
    
    trait :basic do
      type { 'BasicMembership' }
    end
    
    trait :circus do
      type { 'CircusMembership' }
    end
    
    trait :reduced_price do
      reduced_price { true }
    end
  end
end
```

## Tests Système

### Test d'Adhésion
```ruby
# spec/system/membership_subscription_spec.rb
RSpec.describe "Membership Subscription", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "allows a user to subscribe to a basic membership" do
    visit new_membership_path
    
    fill_in "Email", with: "new@example.com"
    fill_in "Nom", with: "Jean Test"
    select "Adhésion Simple", from: "Type"
    
    expect {
      click_button "Créer l'adhésion"
    }.to change(Membership, :count).by(1)
    
    expect(page).to have_text("Adhésion créée avec succès")
  end

  context "with reduced price" do
    it "requires justification document" do
      visit new_membership_path
      
      fill_in "Email", with: "student@example.com"
      fill_in "Nom", with: "Étudiant Test"
      select "Adhésion Cirque", from: "Type"
      check "Tarif réduit"
      
      click_button "Créer l'adhésion"
      
      expect(page).to have_text("Justificatif doit être fourni")
    end
  end
end
```

## Tests API

### Test des Endpoints
```ruby
# spec/requests/api/v1/memberships_spec.rb
RSpec.describe "API V1 Memberships", type: :request do
  let(:user) { create(:user) }
  let(:token) { user.generate_api_token }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe "GET /api/v1/memberships" do
    before do
      create_list(:membership, 3, user: user)
    end

    it "returns user's memberships" do
      get '/api/v1/memberships', headers: headers
      
      expect(response).to have_http_status(:ok)
      expect(json_response['data'].size).to eq(3)
    end
  end

  describe "POST /api/v1/memberships" do
    let(:valid_params) do
      {
        membership: {
          type: 'basic',
          reduced_price: false
        }
      }
    end

    it "creates a new membership" do
      expect {
        post '/api/v1/memberships', 
             params: valid_params,
             headers: headers
      }.to change(Membership, :count).by(1)
      
      expect(response).to have_http_status(:created)
    end
  end
end
```

## Qualité de Code

### RuboCop Configuration
```yaml
# .rubocop.yml
require:
  - rubocop-rails
  - rubocop-rspec
  - rubocop-performance

AllCops:
  NewCops: enable
  TargetRubyVersion: 3.2
  Exclude:
    - 'db/**/*'
    - 'bin/**/*'
    - 'vendor/**/*'

Style/Documentation:
  Enabled: false

Metrics/BlockLength:
  Exclude:
    - 'spec/**/*'
    - 'config/routes.rb'

Rails/FilePath:
  Exclude:
    - 'spec/rails_helper.rb'

RSpec/MultipleExpectations:
  Max: 3

RSpec/NestedGroups:
  Max: 4
```

### Brakeman Configuration
```ruby
# lib/tasks/security.rake
namespace :security do
  desc 'Run security checks'
  task check: :environment do
    puts 'Running Brakeman...'
    system('bundle exec brakeman -q -z')
    
    puts 'Running Bundle Audit...'
    system('bundle exec bundle-audit check --update')
  end
end
```

### SimpleCov Configuration
```ruby
# spec/spec_helper.rb
require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/config/'
  
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
  add_group 'Mailers', 'app/mailers'
  
  minimum_coverage 90
end
```

### Test des Controllers
```ruby
# spec/controllers/memberships_controller_spec.rb
RSpec.describe MembershipsController, type: :controller do
  describe "PUT #update" do
    let(:membership) { create(:membership) }
    
    context "with admin user" do
      let(:admin) { create(:user, :admin) }
      before { sign_in_as admin }
      
      it "updates the membership" do
        put :update, params: { id: membership.id, membership: valid_attributes }
        expect(response).to redirect_to(membership)
      end
    end
    
    context "with regular user" do
      let(:user) { create(:user) }
      before { sign_in user }
      
      it "raises NotAuthorizedError" do
        expect {
          put :update, params: { id: membership.id, membership: valid_attributes }
        }.to raise_error(NotAuthorizedError)
      end
    end
  end
end
```

# spec/support/auth_helper.rb
module AuthHelper
  def sign_in_as(user)
    session[:user_id] = user.id
  end
end

RSpec.configure do |config|
  config.include AuthHelper, type: :controller
  config.include AuthHelper, type: :request
end 