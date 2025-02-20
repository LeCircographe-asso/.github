# Tests RSpec

## Configuration

### Installation
```ruby
# Gemfile
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'shoulda-matchers'
  gem 'capybara'
end
```

### Configuration RSpec
```ruby
# spec/rails_helper.rb
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
end
```

## Tests Modèles

### User Model
```ruby
# spec/models/user_spec.rb
RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:member_number).allow_nil }
  end

  describe "associations" do
    it { should have_many(:memberships) }
    it { should have_many(:subscriptions) }
    it { should have_many(:attendances) }
  end

  describe "#generate_member_number" do
    it "generates a unique member number" do
      user = create(:user)
      expect(user.member_number).to match(/\d{2}\d{4}/)
    end
  end
end
```

### Membership Model
```ruby
# spec/models/membership_spec.rb
RSpec.describe Membership, type: :model do
  describe "scopes" do
    describe ".active" do
      it "returns only active memberships" do
        active = create(:membership, start_date: Date.current, end_date: 1.year.from_now)
        expired = create(:membership, start_date: 2.years.ago, end_date: 1.year.ago)
        
        expect(Membership.active).to include(active)
        expect(Membership.active).not_to include(expired)
      end
    end
  end
end
```

## Tests Controllers

### Integration Tests
```ruby
# spec/requests/memberships_spec.rb
RSpec.describe "Memberships", type: :request do
  let(:user) { create(:user) }
  
  before { sign_in user }

  describe "POST /memberships" do
    let(:valid_attributes) { attributes_for(:membership) }

    context "with valid parameters" do
      it "creates a new membership" do
        expect {
          post memberships_path, params: { membership: valid_attributes }
        }.to change(Membership, :count).by(1)
      end

      it "redirects to the created membership" do
        post memberships_path, params: { membership: valid_attributes }
        expect(response).to redirect_to(Membership.last)
      end
    end
  end
end
```

### System Tests
```ruby
# spec/system/membership_management_spec.rb
RSpec.describe "Membership Management", type: :system do
  let(:volunteer) { create(:user, :volunteer) }
  
  before do
    driven_by(:rack_test)
    sign_in volunteer
  end

  it "allows volunteers to create new memberships" do
    visit new_membership_path
    
    fill_in "Email", with: "test@example.com"
    select "Basic", from: "Type"
    click_on "Créer adhésion"
    
    expect(page).to have_text("Adhésion créée avec succès")
  end
end 