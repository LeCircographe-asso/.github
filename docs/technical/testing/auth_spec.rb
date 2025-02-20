# spec/system/authentication_spec.rb
RSpec.describe "Authentication", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "Registration" do
    it "allows new users to sign up" do
      visit register_path
      
      fill_in "Nom", with: "Jean Test"
      fill_in "Email", with: "jean@test.com"
      fill_in "Mot de passe", with: "password123"
      fill_in "Confirmation du mot de passe", with: "password123"
      
      expect {
        click_button "Créer mon compte"
      }.to change(User, :count).by(1)
      
      expect(page).to have_text("Compte créé avec succès")
      expect(page).to have_current_path(root_path)
    end

    it "shows validation errors" do
      visit register_path
      click_button "Créer mon compte"
      
      expect(page).to have_text("Email doit être rempli")
      expect(page).to have_text("Mot de passe doit être rempli")
      expect(page).to have_text("Nom doit être rempli")
    end
  end

  describe "Login" do
    let(:user) { create(:user, email: "test@example.com", password: "password123") }

    it "allows users to sign in with correct credentials" do
      visit login_path
      
      fill_in "Email", with: user.email
      fill_in "Mot de passe", with: "password123"
      click_button "Se connecter"
      
      expect(page).to have_text("Connexion réussie")
      expect(page).to have_current_path(root_path)
    end

    it "remembers user when remember me is checked" do
      visit login_path
      
      fill_in "Email", with: user.email
      fill_in "Mot de passe", with: "password123"
      check "Se souvenir de moi"
      click_button "Se connecter"
      
      expect(page.driver.browser.rack_mock_session.cookie_jar['remember_token']).to be_present
    end

    it "shows error with invalid credentials" do
      visit login_path
      
      fill_in "Email", with: "jean@test.com"
      fill_in "Mot de passe", with: "wrong_password"
      click_button "Se connecter"
      
      expect(page).to have_text("Email ou mot de passe invalide")
      expect(page).to have_current_path(login_path)
    end
  end

  describe "Logout" do
    let(:user) { create(:user) }
    
    before do
      sign_in user
    end

    it "allows user to sign out" do
      visit root_path
      
      click_link "Déconnexion"
      
      expect(page).to have_text("Déconnexion réussie")
      expect(page).not_to have_text(user.name)
    end

    it "clears remember token on logout" do
      visit root_path
      click_link "Déconnexion"
      
      expect(page.driver.browser.rack_mock_session.cookie_jar['remember_token']).to be_nil
    end
  end

  describe "Password Reset" do
    let(:user) { create(:user) }

    it "allows users to request password reset" do
      visit password_new_path
      
      fill_in "Email", with: user.email
      click_button "Réinitialiser le mot de passe"
      
      expect(page).to have_text("Instructions envoyées")
      expect(ActionMailer::Base.deliveries.last.to).to include(user.email)
    end
  end

  describe "User Model" do
    describe "validations" do
      it { should validate_presence_of(:email) }
      it { should validate_uniqueness_of(:email).case_insensitive }
      it { should validate_length_of(:password).is_at_least(8) }
    end

    describe ".authenticate_by" do
      let(:user) { create(:user, password: "password123") }

      it "authenticates with correct credentials" do
        authenticated = User.authenticate_by(email: user.email, password: "password123")
        expect(authenticated).to eq(user)
      end

      it "returns nil with incorrect credentials" do
        authenticated = User.authenticate_by(email: user.email, password: "wrong")
        expect(authenticated).to be_nil
      end
    end
  end
end

# spec/requests/auth/sessions_controller_spec.rb
RSpec.describe Auth::SessionsController, type: :request do
  describe "POST /login" do
    let!(:user) { create(:user, email: "test@example.com", password: "password123") }
    
    context "with valid credentials" do
      it "signs in the user" do
        post login_path, params: { 
          email: "test@example.com",
          password: "password123"
        }
        
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
      end
    end
    
    context "with remember me" do
      it "sets remember token cookie" do
        post login_path, params: {
          email: "test@example.com",
          password: "password123",
          remember_me: "1"
        }
        
        expect(response.cookies["remember_token"]).to be_present
      end
    end
  end
end

# spec/models/user_spec.rb
RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:password).is_at_least(8) }
  end

  describe ".authenticate_by" do
    let(:user) { create(:user, password: "password123") }
    
    it "authenticates with valid credentials" do
      authenticated = User.authenticate_by(
        email: user.email,
        password: "password123"
      )
      expect(authenticated).to eq(user)
    end

    it "returns nil with invalid credentials" do
      authenticated = User.authenticate_by(
        email: user.email,
        password: "wrong"
      )
      expect(authenticated).to be_nil
    end
  end
end 