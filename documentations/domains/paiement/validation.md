# Validation - Paiements

## Identification du document

| Domaine           | Paiement                            |
|-------------------|-------------------------------------|
| Version           | 1.0                                 |
| Référence         | VALID-PAI-2024-01                   |
| Dernière révision | Mars 2024                           |

## Critères d'Acceptation

### CA-PAI-001: Création d'un paiement standard
- **Étant donné** un administrateur ou bénévole authentifié et un membre avec un élément à payer
- **Quand** l'administrateur/bénévole crée un paiement en espèces, carte ou chèque
- **Alors** le paiement est enregistré avec le statut "completed" si paiement immédiat (espèces/carte) ou "pending" si par chèque
- **Et** l'élément payé est activé si le paiement est immédiat
- **Et** un reçu standard est généré automatiquement

### CA-PAI-002: Paiement avec don
- **Étant donné** un administrateur ou bénévole authentifié et un membre effectuant un paiement
- **Quand** l'administrateur/bénévole ajoute un montant de don au paiement
- **Alors** le paiement total inclut le don et est enregistré
- **Et** le don est tracé séparément
- **Et** un reçu incluant la mention du don est généré
- **Et** un reçu fiscal est généré si le don est supérieur à 10€

### CA-PAI-003: Paiement en plusieurs fois
- **Étant donné** un administrateur ou bénévole authentifié et un membre payant un montant > 50€
- **Quand** l'administrateur/bénévole choisit l'option de paiement en plusieurs fois (2 ou 3 échéances)
- **Alors** les échéances sont calculées et enregistrées
- **Et** la première échéance est marquée comme payée
- **Et** l'élément payé est activé immédiatement
- **Et** un échéancier est généré

### CA-PAI-004: Traitement d'une échéance
- **Étant donné** un administrateur ou bénévole authentifié et une échéance planifiée
- **Quand** l'administrateur/bénévole marque l'échéance comme payée
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
- **Étant donné** un administrateur ou bénévole saisissant des informations de paiement
- **Quand** des données invalides sont saisies (montant négatif, méthode invalide)
- **Alors** le système affiche une erreur de validation
- **Et** le paiement n'est pas enregistré

## Tests Unitaires

### Test du modèle Payment
```ruby
RSpec.describe Payment, type: :model do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:volunteer) { create(:user, :volunteer) }
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
  end
  
  describe "methods" do
    it "detects if the payment has a donation" do
      payment = build(:payment, user: user, payable: membership)
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
      expect(recent_payment.can_refund?).to be true
      
      refunded_payment = create(:payment, user: user, payable: membership, status: :refunded)
      expect(refunded_payment.can_refund?).to be false
    end
  end
end
```

## Scénarios de Test

### Scénario 1: Paiement standard d'une adhésion
```gherkin
Feature: Paiement d'adhésion
  Scenario: Paiement en espèces d'une adhésion Cirque
    Given un administrateur ou bénévole authentifié
    And un membre avec une adhésion Basic valide
    When l'administrateur/bénévole crée une adhésion Cirque pour le membre
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
    Given un administrateur ou bénévole authentifié
    And un membre avec une adhésion Cirque valide
    When l'administrateur/bénévole crée un carnet 10 séances pour le membre
    And ajoute un don de 15€
    And procède au paiement par carte bancaire
    Then le paiement total de 45€ est enregistré
    And le carnet est activé immédiatement
    And le don de 15€ est tracé séparément
    And un reçu standard avec mention du don est généré
    And un reçu fiscal pour le don est généré
```

### Scénario 3: Remboursement partiel
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