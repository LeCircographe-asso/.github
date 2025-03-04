# Validation - Adhésion

## Identification du Document
- **Domaine**: Adhésion
- **Version**: 1.0.0
- **Référence**: [Règles d'Adhésion](regles.md)
- **Dernière révision**: [DATE]

## Critères d'Acceptation

### CA-ADH-001: Création d'une adhésion Basic
- **Étant donné** un nouvel utilisateur sans adhésion
- **Quand** il souscrit à une adhésion Basic
- **Alors** une nouvelle adhésion Basic est créée
- **Et** son statut est "pending" si aucun paiement n'est enregistré
- **Et** son statut est "active" si un paiement est validé
- **Et** la date de validité est fixée à un an à partir de la date de souscription

### CA-ADH-002: Création d'une adhésion Cirque
- **Étant donné** un utilisateur avec une adhésion Basic active
- **Quand** il souscrit à une adhésion Cirque
- **Alors** une nouvelle adhésion Cirque est créée
- **Et** son statut est "pending" si aucun paiement n'est enregistré
- **Et** son statut est "active" si un paiement est validé
- **Et** la date de validité est fixée à un an à partir de la date de souscription

### CA-ADH-003: Validation de l'exigence d'adhésion Basic
- **Étant donné** un utilisateur sans adhésion Basic active
- **Quand** il tente de souscrire à une adhésion Cirque
- **Alors** une erreur est générée
- **Et** l'adhésion Cirque n'est pas créée

### CA-ADH-004: Application du tarif réduit
- **Étant donné** un utilisateur éligible au tarif réduit
- **Quand** un administrateur valide son justificatif
- **Et** il souscrit à une adhésion Cirque
- **Alors** le tarif réduit est appliqué
- **Et** l'administrateur est enregistré comme vérificateur

### CA-ADH-005: Unicité des adhésions actives
- **Étant donné** un utilisateur avec une adhésion Basic active
- **Quand** il tente de souscrire à une nouvelle adhésion Basic
- **Alors** une erreur est générée
- **Et** la nouvelle adhésion n'est pas créée

### CA-ADH-006: Upgrade d'adhésion Basic vers Cirque
- **Étant donné** un utilisateur avec une adhésion Basic active
- **Quand** il effectue un upgrade vers une adhésion Cirque
- **Alors** une nouvelle adhésion Cirque est créée
- **Et** elle a la même date d'expiration que l'adhésion Basic
- **Et** le tarif appliqué est celui de l'upgrade (9€ ou 6€)

### CA-ADH-007: Renouvellement d'adhésion
- **Étant donné** un utilisateur avec une adhésion active
- **Et** dont la date d'expiration est à moins d'un mois
- **Quand** il renouvelle son adhésion
- **Alors** une nouvelle adhésion est créée
- **Et** sa date de début est fixée au lendemain de l'expiration de l'ancienne adhésion
- **Et** sa date de fin est fixée à un an après la date de début

### CA-ADH-008: Expiration automatique
- **Étant donné** une adhésion active
- **Quand** sa date d'expiration est dépassée
- **Et** le job d'expiration s'exécute
- **Alors** son statut passe à "expired"

## Scénarios de Test

### Scénario 1: Parcours complet nouvel adhérent
1. Création d'un nouvel utilisateur
2. Souscription adhésion Basic
3. Paiement 1€
4. Vérification activation adhésion Basic
5. Souscription adhésion Cirque
6. Paiement 9€
7. Vérification activation adhésion Cirque

### Scénario 2: Parcours avec tarif réduit
1. Création d'un nouvel utilisateur
2. Souscription adhésion Basic
3. Paiement 1€
4. Validation tarif réduit par admin
5. Souscription adhésion Cirque avec tarif réduit
6. Paiement 6€
7. Vérification activation adhésion Cirque

### Scénario 3: Tentative création multiple
1. Utilisateur avec adhésion Basic active
2. Tentative souscription seconde adhésion Basic
3. Vérification erreur générée

### Scénario 4: Renouvellement
1. Utilisateur avec adhésion expirant dans 15 jours
2. Renouvellement adhésion
3. Paiement
4. Vérification nouvelle période de validité

### Scénario 5: Expiration
1. Création adhésion avec date d'expiration passée
2. Exécution job d'expiration
3. Vérification changement statut

## Tests Unitaires

### Modèle Membership
```ruby
RSpec.describe Membership, type: :model do
  let(:user) { create(:user) }
  
  describe "validations" do
    it "is valid with valid attributes" do
      membership = build(:membership, user: user)
      expect(membership).to be_valid
    end
    
    it "requires a membership_type" do
      membership = build(:membership, user: user, membership_type: nil)
      expect(membership).not_to be_valid
    end
    
    it "requires a start_date" do
      membership = build(:membership, user: user, start_date: nil)
      expect(membership).not_to be_valid
    end
    
    it "requires an end_date after start_date" do
      membership = build(:membership, user: user, start_date: Date.today, end_date: Date.yesterday)
      expect(membership).not_to be_valid
    end
    
    it "validates basic requirement for cirque membership" do
      membership = build(:membership, user: user, membership_type: :cirque)
      expect(membership).not_to be_valid
      
      create(:membership, user: user, membership_type: :basic, status: :active)
      membership = build(:membership, user: user, membership_type: :cirque)
      expect(membership).to be_valid
    end
    
    it "validates single active membership per type" do
      create(:membership, user: user, membership_type: :basic, status: :active)
      membership = build(:membership, user: user, membership_type: :basic)
      expect(membership).not_to be_valid
    end
  end
  
  describe "scopes" do
    it "returns active memberships" do
      active = create(:membership, user: user, status: :active)
      expired = create(:membership, user: user, status: :expired)
      
      expect(Membership.active).to include(active)
      expect(Membership.active).not_to include(expired)
    end
    
    it "returns memberships by type" do
      basic = create(:membership, user: user, membership_type: :basic)
      cirque = create(:membership, user: user, membership_type: :cirque)
      
      expect(Membership.basic).to include(basic)
      expect(Membership.basic).not_to include(cirque)
      
      expect(Membership.cirque).to include(cirque)
      expect(Membership.cirque).not_to include(basic)
    end
  end
  
  describe "methods" do
    it "sets expiration date automatically" do
      membership = create(:membership, user: user, start_date: Date.today)
      expect(membership.end_date).to eq(Date.today + 1.year)
    end
    
    it "applies discount" do
      admin = create(:user, :admin)
      membership = create(:membership, user: user)
      
      membership.apply_discount(admin)
      expect(membership.discount_applied).to be true
      expect(membership.discount_verified_by).to eq(admin.id)
    end
    
    it "checks if can renew" do
      soon_expiring = create(:membership, 
        user: user, 
        status: :active,
        start_date: 11.months.ago.to_date, 
        end_date: 1.month.from_now.to_date
      )
      not_expiring = create(:membership, 
        user: user, 
        status: :active,
        start_date: 1.month.ago.to_date, 
        end_date: 11.months.from_now.to_date
      )
      
      expect(soon_expiring.can_renew?).to be true
      expect(not_expiring.can_renew?).to be false
    end
  end
end
```

### Service MembershipService
```ruby
RSpec.describe MembershipService do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:payment) { create(:payment) }
  
  describe ".create_basic_membership" do
    it "creates a basic membership" do
      expect {
        MembershipService.create_basic_membership(user, payment)
      }.to change(Membership, :count).by(1)
      
      membership = Membership.last
      expect(membership.membership_type).to eq("basic")
      expect(membership.status).to eq("active")
      expect(membership.payment).to eq(payment)
    end
    
    it "creates pending membership without payment" do
      membership = MembershipService.create_basic_membership(user)
      expect(membership.status).to eq("pending")
    end
  end
  
  describe ".create_cirque_membership" do
    it "raises error without basic membership" do
      expect {
        MembershipService.create_cirque_membership(user)
      }.to raise_error(StandardError)
    end
    
    it "creates cirque membership with active basic" do
      create(:membership, user: user, membership_type: :basic, status: :active)
      
      expect {
        MembershipService.create_cirque_membership(user, payment: payment)
      }.to change(Membership, :count).by(1)
      
      membership = Membership.last
      expect(membership.membership_type).to eq("cirque")
      expect(membership.status).to eq("active")
    end
    
    it "applies discount when specified" do
      create(:membership, user: user, membership_type: :basic, status: :active)
      
      membership = MembershipService.create_cirque_membership(
        user, 
        discount: true,
        verified_by: admin,
        payment: payment
      )
      
      expect(membership.discount_applied).to be true
      expect(membership.discount_verified_by).to eq(admin.id)
    end
  end
  
  describe ".upgrade_to_cirque" do
    it "raises error without basic membership" do
      expect {
        MembershipService.upgrade_to_cirque(user)
      }.to raise_error(StandardError)
    end
    
    it "creates cirque membership with same end date as basic" do
      basic = create(
        :membership, 
        user: user, 
        membership_type: :basic, 
        status: :active,
        end_date: 6.months.from_now.to_date
      )
      
      cirque = MembershipService.upgrade_to_cirque(user, payment: payment)
      
      expect(cirque.end_date).to eq(basic.end_date)
      expect(cirque.membership_type).to eq("cirque")
      expect(cirque.status).to eq("active")
    end
  end
  
  describe ".renew_membership" do
    it "raises error if cannot renew yet" do
      membership = create(
        :membership, 
        user: user, 
        status: :active,
        start_date: 1.month.ago.to_date, 
        end_date: 11.months.from_now.to_date
      )
      
      expect {
        MembershipService.renew_membership(membership)
      }.to raise_error(StandardError)
    end
    
    it "creates new membership with consecutive dates" do
      membership = create(
        :membership, 
        user: user, 
        status: :active,
        start_date: 11.months.ago.to_date, 
        end_date: 1.month.from_now.to_date
      )
      
      new_membership = MembershipService.renew_membership(membership, payment)
      
      expect(new_membership.start_date).to eq(membership.end_date + 1.day)
      expect(new_membership.end_date).to eq(new_membership.start_date + 1.year)
      expect(new_membership.status).to eq("active")
    end
    
    it "transfers discount status" do
      membership = create(
        :membership, 
        user: user, 
        status: :active,
        start_date: 11.months.ago.to_date, 
        end_date: 1.month.from_now.to_date,
        discount_applied: true,
        discount_verified_by: admin.id
      )
      
      new_membership = MembershipService.renew_membership(membership, payment)
      
      expect(new_membership.discount_applied).to be true
      expect(new_membership.discount_verified_by).to eq(admin.id)
    end
  end
  
  describe ".check_and_expire_memberships" do
    it "expires memberships past end date" do
      active_expired = create(
        :membership, 
        status: :active,
        end_date: 1.day.ago.to_date
      )
      
      active_valid = create(
        :membership, 
        status: :active,
        end_date: 1.day.from_now.to_date
      )
      
      MembershipService.check_and_expire_memberships
      
      expect(active_expired.reload.status).to eq("expired")
      expect(active_valid.reload.status).to eq("active")
    end
  end
end
```

## Tests d'Intégration

### Flux Création Adhésion
```ruby
RSpec.describe "Flux création adhésion", type: :feature do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  
  before do
    login_as(admin)
  end
  
  scenario "Création adhésion Basic pour nouvel utilisateur" do
    visit new_user_membership_path(user)
    
    select "Basic", from: "Type d'adhésion"
    click_button "Créer adhésion"
    
    # Redirection vers paiement
    expect(page).to have_content("Paiement adhésion")
    expect(page).to have_content("1,00 €")
    
    select "Espèces", from: "Méthode de paiement"
    click_button "Valider paiement"
    
    # Confirmation
    expect(page).to have_content("Adhésion créée avec succès")
    expect(user.memberships.basic.active).to exist
  end
  
  scenario "Tentative création Cirque sans Basic" do
    visit new_user_membership_path(user)
    
    select "Cirque", from: "Type d'adhésion"
    click_button "Créer adhésion"
    
    # Message d'erreur
    expect(page).to have_content("Une adhésion Basic valide est requise")
    expect(user.memberships.cirque).not_to exist
  end
  
  scenario "Création adhésion Cirque avec tarif réduit" do
    create(:membership, user: user, membership_type: :basic, status: :active)
    
    visit new_user_membership_path(user)
    
    select "Cirque", from: "Type d'adhésion"
    check "Tarif réduit"
    select "Étudiant", from: "Justificatif"
    click_button "Créer adhésion"
    
    # Redirection vers paiement
    expect(page).to have_content("Paiement adhésion")
    expect(page).to have_content("6,00 €")
    
    select "Espèces", from: "Méthode de paiement"
    click_button "Valider paiement"
    
    # Confirmation
    expect(page).to have_content("Adhésion créée avec succès")
    
    membership = user.memberships.cirque.active.first
    expect(membership).to be_present
    expect(membership.discount_applied).to be true
  end
  
  scenario "Renouvellement adhésion" do
    membership = create(
      :membership, 
      user: user, 
      status: :active,
      start_date: 11.months.ago.to_date, 
      end_date: 1.month.from_now.to_date
    )
    
    visit user_path(user)
    click_link "Renouveler adhésion"
    
    expect(page).to have_content("Renouvellement adhésion")
    
    click_button "Confirmer renouvellement"
    
    # Redirection vers paiement
    select "Espèces", from: "Méthode de paiement"
    click_button "Valider paiement"
    
    # Confirmation
    expect(page).to have_content("Adhésion renouvelée avec succès")
    
    new_membership = user.memberships.active.order(created_at: :desc).first
    expect(new_membership.start_date).to eq(membership.end_date + 1.day)
  end
end
```

## Plan de Test

### Tests de performance
- Création massive d'adhésions (benchmark)
- Recherche d'adhésions par critères (index)
- Expiration automatique de nombreuses adhésions

### Tests de sécurité
- Vérification que seuls les administrateurs peuvent valider les tarifs réduits
- Vérification que les utilisateurs ne peuvent pas créer d'adhésions pour d'autres utilisateurs
- Vérification des droits d'accès aux données d'adhésion

## Matrix de Traçabilité

| ID | Règle | Critère | Test Unitaire | Test Intégration |
|----|-------|---------|--------------|-----------------|
| R1 | Types d'adhésion | CA-ADH-001, CA-ADH-002 | Membership#type | Création Basic/Cirque |
| R2 | Basic avant Cirque | CA-ADH-003 | validate_basic_requirement | Tentative Cirque sans Basic |
| R3 | Une seule adhésion active | CA-ADH-005 | validate_single_active_membership | Tentative création multiple |
| R4 | Tarifs réduits | CA-ADH-004 | apply_discount | Création avec tarif réduit |
| R5 | Upgrade | CA-ADH-006 | upgrade_to_cirque | - |
| R6 | Renouvellement | CA-ADH-007 | renew_membership | Renouvellement adhésion |
| R7 | Expiration | CA-ADH-008 | check_and_expire_memberships | - |
``` 