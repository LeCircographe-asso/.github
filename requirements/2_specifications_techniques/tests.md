# 🧪 Tests et Validation Technique - Le Circographe

<div align="right">
  <a href="./README.md">⬅️ Retour aux spécifications techniques</a> •
  <a href="../profile/README.md">📚 Documentation principale</a>
</div>

<p align="center"><i>🧭 Chemin: <a href="../profile/README.md">Documentation</a> > <a href="../README.md">Requirements</a> > <a href="./README.md">Spécifications Techniques</a> > <b>Tests et Validation</b></i></p>

## 📋 Vue d'ensemble

Ce document définit les stratégies et méthodologies de test pour l'application Le Circographe, organisées par types de tests et domaines métier. Ces spécifications assurent la qualité et la robustesse du logiciel selon les standards de Rails 8.0.1.

## 🧩 Stratégie de test globale

L'application suit une approche de test pyramidale combinant différents niveaux de tests :

```
           /\
          /  \
         /    \
        / End- \      Moins nombreux mais couvrent des scénarios complets
       / to-End \
      /----------\
     /  System    \
    /   Tests      \    Tests d'interface utilisateur et de workflows
   /----------------\
  /   Integration    \
 /      Tests         \  Interactions entre composants
/----------------------\
/      Unit Tests       \  Nombreux, rapides, isolés
--------------------------
```

### Couverture de test minimale requise

- Modèles : 90% de couverture
- Services : 85% de couverture
- Contrôleurs : 75% de couverture
- Helpers/Presenters : 70% de couverture
- Javascript (Stimulus) : 60% de couverture

## 🧪 Types de tests

### 1. Tests unitaires

Les tests unitaires ciblent les plus petites unités de code et sont implémentés avec RSpec :

```ruby
# spec/models/adhesion/adhesion_spec.rb
RSpec.describe Adhesion::Adhesion, type: :model do
  describe "validations" do
    it { should validate_presence_of(:numero) }
    it { should validate_presence_of(:date_debut) }
    it { should validate_presence_of(:date_fin) }
    it { should validate_uniqueness_of(:numero) }
  end
  
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:type_adhesion) }
    it { should have_many(:paiements) }
    it { should have_many(:souscriptions) }
  end
  
  describe "#active?" do
    let(:adhesion) { create(:adhesion, date_debut: Date.current - 10.days, date_fin: Date.current + 10.days) }
    
    it "returns true when date is between date_debut and date_fin" do
      expect(adhesion.active?).to be true
    end
    
    it "returns false when date is before date_debut" do
      expect(adhesion.active?(Date.current - 15.days)).to be false
    end
    
    it "returns false when date is after date_fin" do
      expect(adhesion.active?(Date.current + 15.days)).to be false
    end
  end
  
  describe "#renouveler" do
    let(:adhesion) { create(:adhesion, date_fin: Date.current + 30.days) }
    
    it "creates a new adhesion with proper dates" do
      nouvelle_adhesion = adhesion.renouveler
      
      expect(nouvelle_adhesion.user).to eq(adhesion.user)
      expect(nouvelle_adhesion.type_adhesion).to eq(adhesion.type_adhesion)
      expect(nouvelle_adhesion.date_debut).to eq(adhesion.date_fin + 1.day)
      expect(nouvelle_adhesion.date_fin).to eq(adhesion.date_fin + 1.year)
    end
  end
end
```

### 2. Tests d'intégration

Les tests d'intégration vérifient l'interaction entre différents composants :

```ruby
# spec/requests/adhesion/adhesions_spec.rb
RSpec.describe "Adhesion::Adhesions", type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:adhesion) { create(:adhesion, user: user) }
  
  describe "GET /adhesions/:id" do
    context "when user is not logged in" do
      it "redirects to login page" do
        get adhesion_path(adhesion)
        expect(response).to redirect_to(new_session_path)
      end
    end
    
    context "when user is logged in" do
      before { sign_in(user) }
      
      it "returns the user's own adhesion" do
        get adhesion_path(adhesion)
        expect(response).to be_successful
        expect(response.body).to include(adhesion.numero)
      end
      
      it "does not allow access to another user's adhesion" do
        other_adhesion = create(:adhesion)
        get adhesion_path(other_adhesion)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to include("autorisé")
      end
    end
    
    context "when admin is logged in" do
      before { sign_in(admin) }
      
      it "allows access to any adhesion" do
        get adhesion_path(adhesion)
        expect(response).to be_successful
        expect(response.body).to include(adhesion.numero)
        
        other_adhesion = create(:adhesion)
        get adhesion_path(other_adhesion)
        expect(response).to be_successful
      end
    end
  end
  
  describe "POST /adhesions" do
    let(:valid_attributes) { attributes_for(:adhesion) }
    
    context "with valid parameters" do
      before { sign_in(user) }
      
      it "creates a new adhesion" do
        expect {
          post adhesions_path, params: { adhesion: valid_attributes }
        }.to change(Adhesion::Adhesion, :count).by(1)
        
        expect(response).to redirect_to(adhesion_path(Adhesion::Adhesion.last))
        expect(flash[:notice]).to include("créée avec succès")
      end
    end
  end
end
```

### 3. Tests système

Les tests système simulent l'interaction utilisateur réelle avec l'application :

```ruby
# spec/system/adhesion/adhesion_flows_spec.rb
RSpec.describe "Adhesion Flows", type: :system do
  let(:user) { create(:user) }
  let(:benevole) { create(:user, :benevole) }
  
  before do
    driven_by(:selenium_headless)
  end
  
  describe "Creation d'adhésion" do
    before { sign_in(benevole) }
    
    it "allows benevole to create an adhesion", js: true do
      visit new_adhesion_path
      
      fill_in "Nom", with: "Dupont"
      fill_in "Prénom", with: "Jean"
      fill_in "Email", with: "jean.dupont@example.com"
      select "Adhésion Basic", from: "Type d'adhésion"
      fill_in "Date de début", with: Date.current.strftime("%Y-%m-%d")
      fill_in "Date de fin", with: (Date.current + 1.year).strftime("%Y-%m-%d")
      
      click_button "Créer l'adhésion"
      
      expect(page).to have_content("Adhésion créée avec succès")
      expect(page).to have_content("Dupont")
      expect(page).to have_content("Jean")
    end
  end
  
  describe "Renouvellement d'adhésion" do
    let!(:adhesion) { create(:adhesion, user: user, date_fin: Date.current + 30.days) }
    
    before { sign_in(user) }
    
    it "allows user to renew their adhesion", js: true do
      visit adhesion_path(adhesion)
      
      expect(page).to have_content("Expire dans 30 jours")
      
      click_button "Renouveler mon adhésion"
      
      expect(page).to have_content("Votre adhésion a été renouvelée")
      # Vérifier que la nouvelle adhésion est affichée
      expect(page).to have_content("Valide du")
      expect(page).to have_content((adhesion.date_fin + 1.day).strftime("%d/%m/%Y"))
      expect(page).to have_content((adhesion.date_fin + 1.year).strftime("%d/%m/%Y"))
    end
  end
end
```

### 4. Mocks et Stubs

Les mocks et stubs permettent d'isoler le code testé des dépendances externes :

```ruby
# spec/services/payment_service_spec.rb
RSpec.describe PaymentService do
  describe "#process_payment" do
    let(:user) { create(:user) }
    let(:adhesion) { create(:adhesion, user: user) }
    let(:payment_params) { { montant: 50, mode_paiement: 'carte' } }
    
    it "calls the payment gateway and records the transaction" do
      # Stub du service de paiement externe
      payment_gateway = instance_double(PaymentGateway)
      allow(PaymentGateway).to receive(:new).and_return(payment_gateway)
      allow(payment_gateway).to receive(:process).and_return(
        { success: true, transaction_id: 'txn_123456' }
      )
      
      service = PaymentService.new(adhesion, payment_params)
      
      expect {
        result = service.process_payment
        expect(result[:success]).to be true
        expect(result[:payment]).to be_persisted
        expect(result[:payment].reference_externe).to eq('txn_123456')
      }.to change(Paiement::Paiement, :count).by(1)
      
      expect(payment_gateway).to have_received(:process).with(
        amount: 50,
        payment_method: 'carte',
        description: "Adhésion #{adhesion.numero}"
      )
    end
    
    it "handles failed payments properly" do
      # Stub du service de paiement externe qui échoue
      payment_gateway = instance_double(PaymentGateway)
      allow(PaymentGateway).to receive(:new).and_return(payment_gateway)
      allow(payment_gateway).to receive(:process).and_return(
        { success: false, error: 'Insufficient funds' }
      )
      
      service = PaymentService.new(adhesion, payment_params)
      
      expect {
        result = service.process_payment
        expect(result[:success]).to be false
        expect(result[:error]).to eq('Insufficient funds')
      }.not_to change(Paiement::Paiement, :count)
    end
  end
end
```

## 🔄 Tests par domaine métier

### Domaine Adhésion

```ruby
# spec/factories/adhesion_factories.rb
FactoryBot.define do
  factory :adhesion, class: 'Adhesion::Adhesion' do
    user
    association :type_adhesion, factory: :adhesion_type
    numero { "CI#{Date.current.year.to_s[2..]}-#{SecureRandom.hex(2).upcase}" }
    date_debut { Date.current }
    date_fin { Date.current + 1.year }
    status { 'active' }
  end
  
  factory :adhesion_type, class: 'Adhesion::AdhesionType' do
    sequence(:nom) { |n| "Type Adhésion #{n}" }
    sequence(:code) { |n| "T#{n}" }
    description { "Description du type d'adhésion" }
    tarif { 25.0 }
  end
end

# spec/policies/adhesion_policy_spec.rb
RSpec.describe AdhesionPolicy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:benevole) { create(:user, :benevole) }
  
  describe "Scope" do
    let!(:user_adhesion) { create(:adhesion, user: user) }
    let!(:other_adhesion) { create(:adhesion) }
    
    it "shows only user's adhesions for regular users" do
      scope = AdhesionPolicy::Scope.new(user, Adhesion::Adhesion).resolve
      expect(scope).to include(user_adhesion)
      expect(scope).not_to include(other_adhesion)
    end
    
    it "shows all adhesions for admins" do
      scope = AdhesionPolicy::Scope.new(admin, Adhesion::Adhesion).resolve
      expect(scope).to include(user_adhesion)
      expect(scope).to include(other_adhesion)
    end
  end
  
  # Tests pour les permissions CRUD
end
```

### Domaine Cotisation

```ruby
# spec/models/cotisation/formule_spec.rb
RSpec.describe Cotisation::Formule, type: :model do
  describe "#duree_humaine" do
    it "returns correct human-readable duration for 30 days" do
      formule = build(:formule, duree_jours: 30)
      expect(formule.duree_humaine).to eq("1 mois")
    end
    
    it "returns correct human-readable duration for 90 days" do
      formule = build(:formule, duree_jours: 90)
      expect(formule.duree_humaine).to eq("3 mois")
    end
    
    it "returns correct human-readable duration for 365 days" do
      formule = build(:formule, duree_jours: 365)
      expect(formule.duree_humaine).to eq("1 an")
    end
    
    it "returns days for non-standard durations" do
      formule = build(:formule, duree_jours: 45)
      expect(formule.duree_humaine).to eq("45 jours")
    end
  end
end

# spec/models/cotisation/souscription_spec.rb
RSpec.describe Cotisation::Souscription, type: :model do
  describe "#decrementer_sessions" do
    context "with a session-based formule" do
      let(:formule) { create(:formule, sessions_total: 10) }
      let(:souscription) { create(:souscription, formule: formule, sessions_restantes: 5) }
      
      it "decrements sessions_restantes" do
        expect {
          souscription.decrementer_sessions
        }.to change(souscription, :sessions_restantes).by(-1)
      end
      
      it "raises an error when no sessions are left" do
        souscription.update(sessions_restantes: 0)
        
        expect {
          souscription.decrementer_sessions
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
    
    context "with a duration-based formule" do
      let(:formule) { create(:formule, sessions_total: nil) }
      let(:souscription) { create(:souscription, formule: formule) }
      
      it "does nothing" do
        expect {
          souscription.decrementer_sessions
        }.not_to change(souscription, :sessions_restantes)
      end
    end
  end
end
```

### Domaine Paiement

```ruby
# spec/services/paiement/recu_generator_spec.rb
RSpec.describe Paiement::RecuGenerator, type: :service do
  let(:paiement) { create(:paiement) }
  let(:service) { Paiement::RecuGenerator.new(paiement) }
  
  describe "#generate" do
    it "creates a PDF receipt with correct information" do
      pdf = service.generate
      
      # Test that the PDF contains the right content
      text = PDF::Inspector::Text.analyze(pdf).strings.join(" ")
      
      expect(text).to include(paiement.reference)
      expect(text).to include(paiement.user.full_name)
      expect(text).to include(paiement.montant.to_s)
      expect(text).to include(I18n.l(paiement.created_at, format: :long))
    end
    
    it "saves the receipt to Active Storage" do
      expect {
        service.generate_and_attach
      }.to change { paiement.recu.file.attached? }.from(false).to(true)
    end
  end
end
```

### Domaine Présence

```ruby
# spec/models/presence/presence_spec.rb
RSpec.describe Presence::Presence, type: :model do
  let(:adhesion) { create(:adhesion, status: :active) }
  let(:creneau) { create(:creneau, capacite: 10) }
  
  describe "validations" do
    it "validates that adhesion is active" do
      expired_adhesion = create(:adhesion, status: :expired)
      presence = build(:presence, adhesion: expired_adhesion, creneau: creneau)
      
      expect(presence).not_to be_valid
      expect(presence.errors[:adhesion]).to include("n'est pas active à la date du pointage")
    end
    
    it "validates creneau capacity" do
      # Create presences up to capacity
      create_list(:presence, 10, creneau: creneau, date_pointage: Date.current)
      
      # Try to create one more
      presence = build(:presence, creneau: creneau, date_pointage: Date.current)
      
      expect(presence).not_to be_valid
      expect(presence.errors[:creneau]).to include("a atteint sa capacité maximale")
    end
    
    it "considers exceptions when validating" do
      # Create an exception for the creneau
      create(:exception, creneau: creneau, date: Date.current, fermeture: true)
      
      presence = build(:presence, creneau: creneau, date_pointage: Date.current)
      
      expect(presence).not_to be_valid
      expect(presence.errors[:creneau]).to include("n'est pas disponible à cette date (fermeture exceptionnelle)")
    end
  end
end
```

### Domaine Notification

```ruby
# spec/jobs/notification/notification_delivery_job_spec.rb
RSpec.describe Notification::NotificationDeliveryJob, type: :job do
  include ActiveJob::TestHelper
  
  let(:notification) { create(:notification) }
  
  describe "#perform" do
    it "delivers email notification for email channel" do
      notification.update(canal: 'email')
      
      expect {
        perform_enqueued_jobs do
          Notification::NotificationDeliveryJob.perform_later(notification.id)
        end
      }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
      
      expect(notification.reload.envoyee_at).not_to be_nil
    end
    
    it "broadcasts to Turbo stream for app channel" do
      notification.update(canal: 'app')
      
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_to)
      
      perform_enqueued_jobs do
        Notification::NotificationDeliveryJob.perform_later(notification.id)
      end
      
      expect(Turbo::StreamsChannel).to have_received(:broadcast_append_to)
        .with("notifications:#{notification.user_id}", anything)
      
      expect(notification.reload.envoyee_at).not_to be_nil
    end
  end
end
```

## 🧪 Configuration de l'environnement de test

### RSpec Configuration

```ruby
# spec/rails_helper.rb
RSpec.configure do |config|
  # Utilisation des modules Helper
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Devise::Test::ControllerHelpers, type: :controller
  
  # Nettoyage de la base de données
  config.use_transactional_fixtures = true
  
  # Configuration des outils d'analyse
  config.after(:suite) do
    FactoryBot.lint
  end
  
  # Configuration spécifique aux tests système
  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  end
end
```

### Factories Configuration

```ruby
# spec/support/factory_bot.rb
RSpec.configure do |config|
  config.before(:suite) do
    FactoryBot.find_definitions
  end
end

# Définitions de factory génériques
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    first_name { "Jean" }
    last_name { "Dupont" }
    password { "password123" }
    password_confirmation { "password123" }
    
    # Association avec un rôle par défaut
    association :role, factory: :adherent_role
    
    # Traits pour différents types d'utilisateurs
    trait :admin do
      association :role, factory: :admin_role
    end
    
    trait :benevole do
      association :role, factory: :benevole_role
    end
  end
  
  factory :admin_role, class: 'Role::Role' do
    nom { Role::Role::ADMIN }
  end
  
  factory :benevole_role, class: 'Role::Role' do
    nom { Role::Role::BENEVOLE }
  end
  
  factory :adherent_role, class: 'Role::Role' do
    nom { Role::Role::ADHERENT }
  end
end
```

## 📊 Couverture et rapports de test

### Configuration de SimpleCov

```ruby
# spec/spec_helper.rb
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/vendor/'
  
  # Regroupement par domaines métier
  add_group 'Adhésion', 'app/models/adhesion'
  add_group 'Cotisation', 'app/models/cotisation'
  add_group 'Paiement', 'app/models/paiement'
  add_group 'Présence', 'app/models/presence'
  add_group 'Rôles', 'app/models/role'
  add_group 'Notification', 'app/models/notification'
  
  # Regroupement par type
  add_group 'Controllers', 'app/controllers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Mailers', 'app/mailers'
  
  # Seuil minimal de couverture
  minimum_coverage 80
end
```

### Rapports CI/CD

Les tests sont exécutés sur le pipeline CI avec génération de rapports :

```yaml
# .github/workflows/tests.yml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Ruby
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.2.0
        bundler-cache: true
    
    - name: Install dependencies
      run: |
        gem install bundler
        bundle install
    
    - name: Setup database
      run: bundle exec rails db:create db:schema:load
    
    - name: Run tests
      run: bundle exec rspec
    
    - name: Upload coverage report
      uses: actions/upload-artifact@v3
      with:
        name: code-coverage
        path: coverage/
```

## 🛠️ Bonnes pratiques de test

1. **Tests isolés** : Chaque test doit être indépendant et pouvoir s'exécuter seul
2. **Utilisation de factories** : Créer des données de test via FactoryBot au lieu de fixtures
3. **Tester les cas limites** : S'assurer de tester les cas d'erreur et exceptions
4. **Tests de non-régression** : Créer des tests pour reproduire et éviter les bugs antérieurs
5. **Tests déterministes** : Éviter les tests qui dépendent de facteurs aléatoires

### Exemple de test pour bug corrigé

```ruby
# spec/bugs/issue_123_spec.rb
RSpec.describe "Issue #123: Renouvellement d'adhésion incorrect", type: :model do
  it "fixes the bug where renewal used wrong dates" do
    # Ancien comportement bugué
    adhesion = create(:adhesion, date_debut: Date.new(2022, 1, 1), date_fin: Date.new(2022, 12, 31))
    
    # Le renouvellement doit maintenant utiliser la bonne date
    renewed = adhesion.renouveler
    
    # Vérifier que le bug est corrigé
    expect(renewed.date_debut).to eq(Date.new(2023, 1, 1))
    expect(renewed.date_fin).to eq(Date.new(2023, 12, 31))
  end
end
```

---

<div align="center">
  <p>
    <a href="./README.md">⬅️ Retour aux spécifications techniques</a> | 
    <a href="#-tests-et-validation-technique---le-circographe">⬆️ Haut de page</a>
  </p>
</div> 