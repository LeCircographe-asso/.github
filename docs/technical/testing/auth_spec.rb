# spec/system/authentication_spec.rb
RSpec.describe "Authentication", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "Registration" do
    it "allows new users to sign up" do
      visit auth_register_path
      
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
      visit auth_register_path
      click_button "Créer mon compte"
      
      expect(page).to have_text("Email doit être rempli")
      expect(page).to have_text("Mot de passe doit être rempli")
      expect(page).to have_text("Nom doit être rempli")
    end
  end

  describe "Login" do
    let!(:user) { create(:user, email: "jean@test.com", password: "password123") }

    it "allows users to sign in with correct credentials" do
      visit auth_login_path
      
      fill_in "Email", with: "jean@test.com"
      fill_in "Mot de passe", with: "password123"
      click_button "Se connecter"
      
      expect(page).to have_text("Connexion réussie")
      expect(page).to have_current_path(root_path)
    end

    it "remembers user when remember me is checked" do
      visit auth_login_path
      
      fill_in "Email", with: "jean@test.com"
      fill_in "Mot de passe", with: "password123"
      check "Se souvenir de moi"
      click_button "Se connecter"
      
      expect(page).to have_text("Connexion réussie")
      expect(user.reload.remember_token).to be_present
      expect(user.remember_token_expires_at).to be > 13.days.from_now
    end

    it "shows error with invalid credentials" do
      visit auth_login_path
      
      fill_in "Email", with: "jean@test.com"
      fill_in "Mot de passe", with: "wrong_password"
      click_button "Se connecter"
      
      expect(page).to have_text("Email ou mot de passe invalide")
      expect(page).to have_current_path(auth_login_path)
    end
  end

  describe "Logout" do
    let(:user) { create(:user) }
    
    before do
      sign_in_as user
    end

    it "allows user to sign out" do
      visit root_path
      
      click_link "Déconnexion"
      
      expect(page).to have_text("Déconnexion réussie")
      expect(page).not_to have_text(user.name)
    end

    it "clears remember token on logout" do
      user.remember_me
      
      visit root_path
      click_link "Déconnexion"
      
      expect(user.reload.remember_token).to be_nil
      expect(user.remember_token_expires_at).to be_nil
    end
  end
end

# spec/requests/auth/sessions_controller_spec.rb
RSpec.describe Auth::SessionsController, type: :request do
  describe "POST /auth/login" do
    let!(:user) { create(:user, email: "test@example.com", password: "password123") }
    
    context "with valid credentials" do
      it "signs in the user" do
        post auth_login_path, params: { 
          email: "test@example.com",
          password: "password123"
        }
        
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
      end
    end
    
    context "with remember me" do
      it "sets remember token" do
        post auth_login_path, params: { 
          email: "test@example.com",
          password: "password123",
          remember_me: "1"
        }
        
        expect(user.reload.remember_token).to be_present
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

  describe "#remember_me" do
    let(:user) { create(:user) }
    
    it "sets remember token and expiration" do
      user.remember_me
      
      expect(user.remember_token).to be_present
      expect(user.remember_token_expires_at).to be_present
      expect(user.remember_token_expires_at).to be > 13.days.from_now
    end
  end
end 