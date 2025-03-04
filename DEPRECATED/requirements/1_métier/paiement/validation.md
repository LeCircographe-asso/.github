# Validation - Paiements

## Identification du document

| Domaine           | Paiement                            |
|-------------------|-------------------------------------|
| Version           | 1.0                                 |
| Référence         | VALID-PAI-2023-01                   |
| Dernière révision | [DATE]                              |

## Critères d'Acceptation

### CA-PAI-001: Création d'un paiement standard
- **Étant donné** un administrateur authentifié et un membre avec un élément à payer
- **Quand** l'administrateur crée un paiement en espèces, carte ou chèque
- **Alors** le paiement est enregistré avec le statut "completed" si paiement immédiat (espèces/carte) ou "pending" si par chèque
- **Et** l'élément payé est activé si le paiement est immédiat
- **Et** un reçu standard est généré automatiquement

### CA-PAI-002: Paiement avec don
- **Étant donné** un administrateur authentifié et un membre effectuant un paiement
- **Quand** l'administrateur ajoute un montant de don au paiement
- **Alors** le paiement total inclut le don et est enregistré
- **Et** le don est tracé séparément
- **Et** un reçu incluant la mention du don est généré
- **Et** un reçu fiscal est généré si le don est supérieur à 10€

### CA-PAI-003: Paiement en plusieurs fois
- **Étant donné** un administrateur authentifié et un membre payant un montant > 50€
- **Quand** l'administrateur choisit l'option de paiement en plusieurs fois (2 ou 3 échéances)
- **Alors** les échéances sont calculées et enregistrées
- **Et** la première échéance est marquée comme payée
- **Et** l'élément payé est activé immédiatement
- **Et** un échéancier est généré

### CA-PAI-004: Traitement d'une échéance
- **Étant donné** un administrateur authentifié et une échéance planifiée
- **Quand** l'administrateur marque l'échéance comme payée
- **Alors** le statut de l'échéance est modifié à "completed"
- **Et** si toutes les échéances sont complétées, le paiement principal est marqué comme "completed"

### CA-PAI-005: Remboursement d'un paiement
- **Étant donné** un administrateur authentifié et un paiement complété
- **Quand** l'administrateur initie un remboursement avec un motif valide
- **Alors** le paiement est marqué comme "refunded"
- **Et** l'élément payé est marqué comme annulé
- **Et** un reçu d'annulation est généré
- **Et** le remboursement est tracé avec les informations de l'administrateur

### CA-PAI-006: Génération et envoi de reçus
- **Étant donné** un paiement complété
- **Quand** le système génère et envoie automatiquement un reçu
- **Alors** le reçu inclut toutes les informations nécessaires
- **Et** le reçu est envoyé à l'email du membre
- **Et** le paiement est marqué comme "receipt_sent"

### CA-PAI-007: Génération des reçus fiscaux annuels
- **Étant donné** des dons enregistrés pour l'année précédente
- **Quand** la tâche de génération des reçus fiscaux annuels est exécutée
- **Alors** un reçu fiscal est généré pour chaque donateur
- **Et** les reçus incluent le total des dons pour l'année
- **Et** les reçus sont envoyés aux donateurs

### CA-PAI-008: Validation des données de paiement
- **Étant donné** un administrateur saisissant des informations de paiement
- **Quand** des données invalides sont saisies (montant négatif, méthode invalide)
- **Alors** le système affiche une erreur de validation
- **Et** le paiement n'est pas enregistré

## Scénarios de Test

### Scénario 1: Paiement standard d'une adhésion
```gherkin
Feature: Paiement d'adhésion
  Scenario: Paiement en espèces d'une adhésion Cirque
    Given un administrateur authentifié
    And un membre avec une adhésion Basic valide
    When l'administrateur crée une adhésion Cirque pour le membre
    And choisit le paiement en espèces de 9€
    Then le paiement est enregistré avec le statut "completed"
    And l'adhésion Cirque est activée immédiatement
    And un reçu standard est généré
    And le reçu est envoyé à l'email du membre
```

### Scénario 2: Paiement d'une cotisation avec don
```gherkin
Feature: Paiement avec don
  Scenario: Paiement d'un carnet 10 séances avec don
    Given un administrateur authentifié
    And un membre avec une adhésion Cirque valide
    When l'administrateur crée un carnet 10 séances pour le membre
    And ajoute un don de 15€
    And procède au paiement par carte bancaire
    Then le paiement total de 45€ est enregistré
    And le carnet est activé immédiatement
    And le don de 15€ est tracé séparément
    And un reçu standard avec mention du don est généré
    And un reçu fiscal pour le don est généré
```

### Scénario 3: Paiement échelonné d'un abonnement
```gherkin
Feature: Paiement échelonné
  Scenario: Paiement en 3 fois d'un abonnement annuel
    Given un administrateur authentifié
    And un membre avec une adhésion Cirque valide
    When l'administrateur crée un abonnement annuel pour le membre
    And choisit le paiement en 3 fois par chèque
    Then 3 échéances de 50€ sont créées
    And la première échéance est marquée comme "completed"
    And les deux autres échéances sont à statut "pending"
    And l'abonnement est activé immédiatement
    And un échéancier est généré et envoyé au membre
```

### Scénario 4: Traitement des échéances
```gherkin
Feature: Suivi des échéances
  Scenario: Encaissement de la seconde échéance
    Given un administrateur authentifié
    And un paiement échelonné avec la première échéance payée
    When l'administrateur marque la seconde échéance comme payée
    Then le statut de l'échéance passe à "completed"
    And le paiement principal reste à "pending" car il reste une échéance
    And un email de confirmation est envoyé au membre
```

### Scénario 5: Remboursement partiel
```gherkin
Feature: Remboursement
  Scenario: Remboursement partiel d'un abonnement
    Given un administrateur authentifié
    And un abonnement trimestriel actif payé 65€ il y a 1 mois
    When l'administrateur initie un remboursement de 45€
    And indique comme motif "Fermeture exceptionnelle"
    Then le paiement est marqué comme "refunded"
    And le montant remboursé de 45€ est enregistré
    And l'abonnement est marqué comme "cancelled"
    And un reçu d'annulation est généré
```

### Scénario 6: Génération de reçus fiscaux annuels
```gherkin
Feature: Reçus fiscaux
  Scenario: Génération automatique des reçus fiscaux annuels
    Given des dons enregistrés pour plusieurs membres sur l'année 2022
    When la tâche de génération des reçus fiscaux est exécutée en janvier 2023
    Then un reçu fiscal est généré pour chaque donateur
    And chaque reçu inclut le total des dons du membre pour 2022
    And les reçus sont envoyés par email aux donateurs
```

## Tests Unitaires

### Modèle Payment
```ruby
RSpec.describe Payment, type: :model do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:membership) { create(:membership, user: user) }
  
  describe "validations" do
    it "is valid with valid attributes" do
      payment = build(:payment, user: user, payable: membership, processed_by: admin)
      expect(payment).to be_valid
    end
    
    it "requires an amount greater than or equal to 0" do
      payment = build(:payment, user: user, payable: membership, amount: -1)
      expect(payment).not_to be_valid
    end
    
    it "requires a payment method" do
      payment = build(:payment, user: user, payable: membership, payment_method: nil)
      expect(payment).not_to be_valid
    end
    
    it "generates a unique reference number on creation" do
      payment = create(:payment, user: user, payable: membership)
      expect(payment.reference_number).to be_present
      expect(payment.reference_number).to match(/PAY-\d{8}-[A-Z0-9]{4}/)
    end
    
    it "validates donation amount if present" do
      payment = build(:payment, user: user, payable: membership, donation_amount: -5)
      expect(payment).not_to be_valid
      
      payment.donation_amount = 10
      expect(payment).to be_valid
    end
    
    it "requires processed_by and processed_at for completed payments" do
      payment = build(:payment, user: user, payable: membership, status: :completed, processed_by: nil, processed_at: nil)
      expect(payment).not_to be_valid
      
      payment.processed_by = admin
      payment.processed_at = Time.current
      expect(payment).to be_valid
    end
    
    it "requires refund fields for refunded payments" do
      payment = build(:payment, user: user, payable: membership, status: :refunded)
      expect(payment).not_to be_valid
      
      payment.refunded_by = admin
      payment.refunded_at = Time.current
      payment.refund_reason = "Test refund"
      payment.refunded_amount = 10
      expect(payment).to be_valid
    end
  end
  
  describe "methods" do
    it "detects if the payment has a donation" do
      payment = build(:payment, user: user, payable: membership, donation_amount: nil)
      expect(payment.has_donation?).to be false
      
      payment.donation_amount = 10
      expect(payment.has_donation?).to be true
    end
    
    it "marks a payment as completed" do
      payment = create(:payment, user: user, payable: membership, status: :pending)
      payment.mark_as_completed(admin)
      
      expect(payment.reload.status).to eq("completed")
      expect(payment.processed_by).to eq(admin)
      expect(payment.processed_at).to be_present
    end
    
    it "determines if a payment is eligible for refund" do
      recent_payment = create(:payment, user: user, payable: membership, status: :completed, created_at: 1.day.ago)
      old_payment = create(:payment, user: user, payable: membership, status: :completed, created_at: 60.days.ago)
      refunded_payment = create(:payment, user: user, payable: membership, status: :refunded)
      
      expect(recent_payment.can_refund?).to be true
      expect(old_payment.can_refund?).to be true # Because it's a membership
      expect(refunded_payment.can_refund?).to be false
      
      # A contribution older than 30 days shouldn't be refundable
      contribution = create(:contribution, user: user)
      old_contribution_payment = create(:payment, user: user, payable: contribution, status: :completed, created_at: 60.days.ago)
      expect(old_contribution_payment.can_refund?).to be false
    end
    
    it "processes a refund" do
      payment = create(:payment, user: user, payable: membership, status: :completed, amount: 100)
      result = payment.process_refund(admin, 50, "Test refund")
      
      expect(result).to be true
      expect(payment.reload.status).to eq("refunded")
      expect(payment.refunded_amount).to eq(50)
      expect(payment.refund_reason).to eq("Test refund")
      expect(payment.refunded_by).to eq(admin)
      expect(payment.refunded_at).to be_present
      expect(membership.reload.status).to eq("cancelled")
    end
  end
  
  describe "callbacks" do
    it "generates a receipt for completed payments" do
      expect(ReceiptService).to receive(:generate_receipt)
      create(:payment, user: user, payable: membership, status: :completed, processed_by: admin, processed_at: Time.current)
    end
  end
end
```

### Service PaymentService
```ruby
RSpec.describe PaymentService do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:membership) { create(:membership, user: user, status: :pending) }
  let(:contribution) { create(:contribution, user: user, status: :pending) }
  
  describe "#create_payment" do
    context "with valid params for membership" do
      let(:params) do
        {
          payable_type: 'Membership',
          payable_id: membership.id,
          payment_method: 'cash'
        }
      end
      
      it "creates a payment and activates the membership" do
        service = PaymentService.new(user, admin, params)
        result = service.create_payment
        
        expect(result).to be_a(Payment)
        expect(result.status).to eq("completed")
        expect(result.amount).to eq(membership.membership_type == 'basic' ? 1 : 10)
        expect(membership.reload.status).to eq("active")
      end
    end
    
    context "with a pending check payment" do
      let(:params) do
        {
          payable_type: 'Contribution',
          payable_id: contribution.id,
          payment_method: 'check',
          installment_plan: false
        }
      end
      
      it "creates a pending payment" do
        service = PaymentService.new(user, admin, params)
        result = service.create_payment
        
        expect(result).to be_a(Payment)
        expect(result.status).to eq("completed") # Même un chèque est marqué completed s'il n'est pas échelonné
        expect(contribution.reload.status).to eq("active")
      end
    end
    
    context "with donation" do
      let(:params) do
        {
          payable_type: 'Membership',
          payable_id: membership.id,
          payment_method: 'cash',
          donation_amount: '15.50',
          donation_anonymous: false
        }
      end
      
      it "creates a payment with donation" do
        service = PaymentService.new(user, admin, params)
        result = service.create_payment
        
        expect(result).to be_a(Payment)
        expect(result.donation_amount).to eq(15.5)
        expect(result.donation_anonymous).to eq(false)
        
        donation = Donation.last
        expect(donation.amount).to eq(15.5)
        expect(donation.anonymous).to eq(false)
        expect(donation.user).to eq(user)
      end
    end
    
    context "with installment plan" do
      let(:params) do
        {
          payable_type: 'Contribution',
          payable_id: contribution.id,
          payment_method: 'check',
          installment_plan: true,
          installments_count: 3,
          check_number: '123456'
        }
      end
      
      it "creates a payment with installments" do
        allow(contribution).to receive(:contribution_type).and_return('subscription_annual')
        allow(contribution).to receive(:amount).and_return(150)
        
        service = PaymentService.new(user, admin, params)
        result = service.create_payment
        
        expect(result).to be_a(Payment)
        expect(result.installments.count).to eq(3)
        
        first_installment = result.installments.order(:due_date).first
        expect(first_installment.status).to eq("completed")
        expect(first_installment.amount).to eq(50)
        expect(first_installment.reference).to eq('123456')
        
        last_installment = result.installments.order(:due_date).last
        expect(last_installment.status).to eq("pending")
        expect(last_installment.due_date).to be > 1.month.from_now
      end
    end
    
    context "with invalid params" do
      let(:params) do
        {
          payable_type: 'InvalidType',
          payable_id: 1,
          payment_method: 'cash'
        }
      end
      
      it "returns false and collects errors" do
        service = PaymentService.new(user, admin, params)
        result = service.create_payment
        
        expect(result).to eq(false)
        expect(service.errors).to include("Type d'élément payé invalide")
      end
    end
  end
  
  describe "#process_refund" do
    let(:payment) { create(:payment, user: user, payable: membership, status: :completed, amount: 100) }
    
    it "processes a valid refund" do
      service = PaymentService.new(user, admin, {})
      result = service.process_refund(payment, 50, "Test refund")
      
      expect(result).to be true
      expect(payment.reload.status).to eq("refunded")
      expect(payment.refunded_amount).to eq(50)
    end
    
    it "fails for a payment that cannot be refunded" do
      already_refunded = create(:payment, user: user, payable: membership, status: :refunded)
      
      service = PaymentService.new(user, admin, {})
      result = service.process_refund(already_refunded, 50, "Test refund")
      
      expect(result).to eq(false)
      expect(service.errors).not_to be_empty
    end
  end
end
```

### Service ReceiptService
```ruby
RSpec.describe ReceiptService do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:membership) { create(:membership, user: user) }
  let(:payment) { create(:payment, user: user, payable: membership, status: :completed, processed_by: admin) }
  
  describe ".generate_receipt" do
    it "creates a receipt with the correct attributes" do
      receipt = ReceiptService.generate_receipt(payment, 'standard')
      
      expect(receipt).to be_a(Receipt)
      expect(receipt.payment).to eq(payment)
      expect(receipt.receipt_type).to eq("standard")
      expect(receipt.total_amount).to eq(payment.amount)
      expect(receipt.created_by).to eq(admin)
      expect(receipt.pdf_path).to be_present
    end
    
    it "creates a receipt with donation details if payment has donation" do
      payment.update(donation_amount: 15)
      
      receipt = ReceiptService.generate_receipt(payment, 'standard_with_donation')
      
      expect(receipt.receipt_type).to eq("standard_with_donation")
      expect(receipt.donation_amount).to eq(15)
    end
  end
  
  describe ".generate_refund_receipt" do
    it "creates a refund receipt" do
      payment.update(status: :refunded, refunded_amount: 50, refunded_by: admin, refunded_at: Time.current, refund_reason: "Test refund")
      
      receipt = ReceiptService.generate_refund_receipt(payment, admin)
      
      expect(receipt.receipt_type).to eq("refund")
      expect(receipt.total_amount).to eq(50)
    end
  end
  
  describe ".generate_annual_fiscal_receipts" do
    before do
      # Create some donations for testing
      3.times do |i|
        donor = create(:user)
        payment = create(:payment, user: donor, payable: create(:membership, user: donor))
        create(:donation, user: donor, payment: payment, amount: 20 + i, anonymous: false, created_at: Date.new(2022, 1, 1))
      end
      
      # Create an anonymous donation
      create(:donation, user: nil, payment: payment, amount: 50, anonymous: true, created_at: Date.new(2022, 2, 1))
    end
    
    it "generates fiscal receipts for non-anonymous donors" do
      receipts = ReceiptService.generate_annual_fiscal_receipts(2022)
      
      expect(receipts.count).to eq(3) # Only non-anonymous donations
      expect(receipts.first.receipt_type).to eq("fiscal")
    end
    
    it "does not generate receipts for anonymous donors" do
      receipts = ReceiptService.generate_annual_fiscal_receipts(2022)
      
      anonymous_donations = Donation.where(anonymous: true)
      expect(anonymous_donations).to exist
      
      receipt_payment_ids = receipts.map(&:payment_id)
      anonymous_payment_ids = anonymous_donations.map(&:payment_id)
      
      expect(receipt_payment_ids).not_to include(*anonymous_payment_ids)
    end
  end
end
```

## Tests d'Intégration

### Flux complet de paiement d'adhésion
```ruby
RSpec.describe "Flux de paiement d'adhésion", type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  
  before do
    login_as(admin)
  end
  
  scenario "Paiement en espèces d'une adhésion Basic" do
    visit new_user_membership_path(user)
    
    select "Basic", from: "Type d'adhésion"
    click_button "Créer adhésion"
    
    # Page de paiement
    expect(page).to have_content("Paiement d'adhésion")
    expect(page).to have_content("1,00 €")
    
    select "Espèces", from: "Méthode de paiement"
    fill_in "Don additionnel", with: "0"
    click_button "Valider le paiement"
    
    # Vérification
    expect(page).to have_content("Paiement enregistré avec succès")
    expect(page).to have_content("Reçu envoyé à #{user.email}")
    
    # Vérification BDD
    payment = Payment.last
    expect(payment.amount).to eq(1)
    expect(payment.status).to eq("completed")
    expect(payment.payment_method).to eq("cash")
    
    membership = Membership.last
    expect(membership.status).to eq("active")
    
    receipt = Receipt.last
    expect(receipt.receipt_type).to eq("standard")
    expect(receipt.receipt_sent).to be true
  end
  
  scenario "Paiement par carte d'une adhésion Cirque avec don" do
    # Créer une adhésion Basic active pour le membre
    create(:membership, user: user, membership_type: :basic, status: :active)
    
    visit new_user_membership_path(user)
    
    select "Cirque", from: "Type d'adhésion"
    click_button "Créer adhésion"
    
    # Page de paiement
    expect(page).to have_content("Paiement d'adhésion")
    expect(page).to have_content("9,00 €") # Upgrade price
    
    select "Carte bancaire", from: "Méthode de paiement"
    fill_in "Don additionnel", with: "25"
    click_button "Valider le paiement"
    
    # Vérification
    expect(page).to have_content("Paiement enregistré avec succès")
    
    # Vérification BDD
    payment = Payment.last
    expect(payment.amount).to eq(9)
    expect(payment.donation_amount).to eq(25)
    expect(payment.status).to eq("completed")
    
    membership = Membership.last
    expect(membership.membership_type).to eq("cirque")
    expect(membership.status).to eq("active")
    
    donation = Donation.last
    expect(donation.amount).to eq(25)
    expect(donation.user).to eq(user)
    
    receipts = Receipt.last(2)
    expect(receipts.map(&:receipt_type)).to include("standard_with_donation", "fiscal")
  end
end
```

### Flux de paiement échelonné
```ruby
RSpec.describe "Flux de paiement échelonné", type: :feature do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  
  before do
    login_as(admin)
    create(:membership, user: user, membership_type: :cirque, status: :active)
  end
  
  scenario "Paiement en 3 fois d'un abonnement annuel" do
    visit new_user_contribution_path(user)
    
    select "Abonnement Annuel", from: "Type de cotisation"
    click_button "Créer cotisation"
    
    # Page de paiement
    expect(page).to have_content("Paiement de cotisation")
    expect(page).to have_content("150,00 €")
    
    select "Chèque", from: "Méthode de paiement"
    check "Paiement échelonné"
    select "3", from: "Nombre d'échéances"
    fill_in "Numéro du premier chèque", with: "123456"
    click_button "Valider le paiement"
    
    # Vérification
    expect(page).to have_content("Paiement échelonné enregistré avec succès")
    expect(page).to have_content("La cotisation est active")
    
    # Vérification BDD
    payment = Payment.last
    expect(payment.amount).to eq(150)
    
    installments = payment.installments.order(:due_date)
    expect(installments.count).to eq(3)
    
    first_installment = installments.first
    expect(first_installment.amount).to eq(50)
    expect(first_installment.status).to eq("completed")
    
    last_installment = installments.last
    expect(last_installment.amount).to eq(50)
    expect(last_installment.status).to eq("pending")
    
    contribution = Contribution.last
    expect(contribution.status).to eq("active")
    
    receipt = Receipt.last
    expect(receipt.receipt_type).to eq("installment_plan")
  end
  
  scenario "Traitement d'une échéance planifiée" do
    # Créer un paiement échelonné existant
    contribution = create(:contribution, user: user, status: :active)
    payment = create(:payment, user: user, payable: contribution, amount: 150, status: :pending)
    
    # Première échéance déjà payée
    create(:installment, payment: payment, amount: 50, status: :completed, due_date: Date.today - 30.days)
    
    # Seconde échéance en attente
    installment = create(:installment, payment: payment, amount: 50, status: :pending, due_date: Date.today)
    
    # Troisième échéance future
    create(:installment, payment: payment, amount: 50, status: :pending, due_date: Date.today + 30.days)
    
    visit edit_installment_path(installment)
    
    expect(page).to have_content("Traitement de l'échéance")
    expect(page).to have_content("50,00 €")
    
    select "Complétée", from: "Statut"
    fill_in "Référence", with: "654321"
    click_button "Mettre à jour l'échéance"
    
    # Vérification
    expect(page).to have_content("Échéance mise à jour avec succès")
    
    # Vérification BDD
    installment.reload
    expect(installment.status).to eq("completed")
    expect(installment.reference).to eq("654321")
    
    payment.reload
    expect(payment.status).to eq("pending") # Toujours pending car il reste une échéance
  end
end
```

## Plan de Tests Complémentaires

### Tests de performance
- Tests de charge pour la génération de multiples reçus simultanément
- Tests de performance de la recherche de paiements avec différents filtres
- Tests de concurrence pour la création simultanée de paiements (verrouillage optimiste)

### Tests de sécurité
- Vérification que seuls les administrateurs peuvent créer/éditer/rembourser des paiements
- Tests d'injection SQL sur les paramètres de recherche
- Vérification des autorisations entre différents utilisateurs (un membre ne peut pas voir les paiements d'un autre)

### Tests de résilience
- Tests de comportement en cas d'erreur lors de la génération de PDF
- Tests de comportement en cas d'échec d'envoi d'email
- Tests de reprise sur erreur pour les tâches planifiées

## Matrice de Traçabilité

| Règle Métier | Critère d'Acceptation | Test Unitaire | Test d'Intégration |
|--------------|----------------------|---------------|-------------------|
| Types de paiement | CA-PAI-001, CA-PAI-002 | PaymentService#calculate_amount | "Paiement d'adhésion" |
| Méthodes de paiement | CA-PAI-001 | Payment#payment_method | "Paiement par carte" |
| Paiement avec don | CA-PAI-002 | PaymentService#create_donation | "Paiement avec don" |
| Paiement échelonné | CA-PAI-003, CA-PAI-004 | PaymentService#create_installments | "Paiement en 3 fois" |
| Génération de reçus | CA-PAI-006, CA-PAI-007 | ReceiptService | "Vérification des reçus" |
| Remboursement | CA-PAI-005 | Payment#process_refund | - |
| États et transitions | CA-PAI-001, CA-PAI-004, CA-PAI-005 | Payment#mark_as_completed | "Traitement d'une échéance" |

---

*Document créé le [DATE] - Version 1.0* 