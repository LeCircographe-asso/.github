# Spécifications Techniques - Paiements

## Identification du document

| Domaine           | Paiement                            |
|-------------------|-------------------------------------|
| Version           | 1.0                                 |
| Référence         | SPEC-PAI-2023-01                    |
| Dernière révision | [DATE]                              |

## Vue d'ensemble

Ce document définit les spécifications techniques pour le domaine "Paiement" du système Circographe. Il décrit le modèle de données, les validations, les API, et les détails d'implémentation nécessaires au développement des fonctionnalités de gestion des paiements.

## Modèle de données

### Entité principale : `Payment`

#### Attributs

| Attribut             | Type               | Description                                       | Nullable |
|----------------------|--------------------|---------------------------------------------------|----------|
| `id`                 | Integer            | Identifiant unique (clé primaire)                 | Non      |
| `user_id`            | Integer            | Référence à l'utilisateur (clé étrangère)         | Non      |
| `payable_id`         | Integer            | ID de l'élément payé (polymorphique)              | Non      |
| `payable_type`       | String             | Type de l'élément payé (Membership/Contribution)  | Non      |
| `amount`             | Decimal            | Montant du paiement                               | Non      |
| `payment_method`     | Enum               | Méthode de paiement (cash, card, check)           | Non      |
| `status`             | Enum               | Statut (pending, processing, completed, failed, refunded) | Non |
| `donation_amount`    | Decimal            | Montant du don (si applicable)                    | Oui      |
| `donation_anonymous` | Boolean            | Si le don est anonyme                             | Oui      |
| `reference_number`   | String             | Numéro de référence unique                        | Non      |
| `receipt_sent`       | Boolean            | Si le reçu a été envoyé                           | Non      |
| `receipt_number`     | String             | Numéro du reçu                                    | Oui      |
| `notes`              | Text               | Notes supplémentaires                             | Oui      |
| `processed_by_id`    | Integer            | ID de l'administrateur ayant traité le paiement   | Oui      |
| `processed_at`       | DateTime           | Date et heure de traitement                       | Oui      |
| `created_at`         | DateTime           | Date et heure de création                         | Non      |
| `updated_at`         | DateTime           | Date et heure de dernière modification            | Non      |
| `refunded_at`        | DateTime           | Date et heure du remboursement (si applicable)    | Oui      |
| `refunded_amount`    | Decimal            | Montant remboursé (si applicable)                 | Oui      |
| `refunded_by_id`     | Integer            | ID de l'administrateur ayant effectué le remboursement | Oui |
| `refund_reason`      | String             | Raison du remboursement                           | Oui      |

#### Associations

| Association          | Type               | Description                                       |
|----------------------|--------------------|---------------------------------------------------|
| `user`               | belongs_to         | Utilisateur associé au paiement                   |
| `payable`            | belongs_to (polymorphic) | Élément payé (Membership/Contribution)      |
| `installments`       | has_many           | Versements associés (si paiement échelonné)       |
| `receipt`            | has_one            | Reçu associé au paiement                          |
| `processed_by`       | belongs_to         | Administrateur ayant traité le paiement           |
| `refunded_by`        | belongs_to         | Administrateur ayant remboursé le paiement        |

### Entité secondaire : `Installment`

#### Attributs

| Attribut             | Type               | Description                                       | Nullable |
|----------------------|--------------------|---------------------------------------------------|----------|
| `id`                 | Integer            | Identifiant unique (clé primaire)                 | Non      |
| `payment_id`         | Integer            | Référence au paiement principal                   | Non      |
| `amount`             | Decimal            | Montant du versement                              | Non      |
| `due_date`           | Date               | Date d'échéance                                   | Non      |
| `status`             | Enum               | Statut (pending, completed, failed)               | Non      |
| `payment_method`     | Enum               | Méthode de paiement (généralement check)          | Non      |
| `reference`          | String             | Référence (ex: numéro de chèque)                  | Oui      |
| `processed_by_id`    | Integer            | Admin ayant traité le versement                   | Oui      |
| `processed_at`       | DateTime           | Date et heure de traitement                       | Oui      |
| `created_at`         | DateTime           | Date et heure de création                         | Non      |
| `updated_at`         | DateTime           | Date et heure de dernière modification            | Non      |

#### Associations

| Association          | Type               | Description                                       |
|----------------------|--------------------|---------------------------------------------------|
| `payment`            | belongs_to         | Paiement principal                                |
| `processed_by`       | belongs_to         | Administrateur ayant traité le versement          |

### Entité tertiaire : `Receipt`

#### Attributs

| Attribut             | Type               | Description                                       | Nullable |
|----------------------|--------------------|---------------------------------------------------|----------|
| `id`                 | Integer            | Identifiant unique (clé primaire)                 | Non      |
| `payment_id`         | Integer            | Référence au paiement                             | Non      |
| `receipt_number`     | String             | Numéro unique du reçu                             | Non      |
| `receipt_type`       | Enum               | Type (standard, fiscal, installment_plan)         | Non      |
| `total_amount`       | Decimal            | Montant total                                     | Non      |
| `donation_amount`    | Decimal            | Montant du don                                    | Oui      |
| `issued_at`          | DateTime           | Date et heure d'émission                          | Non      |
| `sent_at`            | DateTime           | Date et heure d'envoi                             | Oui      |
| `sent_to_email`      | String             | Email de destination                              | Oui      |
| `pdf_path`           | String             | Chemin du fichier PDF                             | Oui      |
| `created_by_id`      | Integer            | Administrateur ayant créé le reçu                 | Non      |
| `created_at`         | DateTime           | Date et heure de création                         | Non      |
| `updated_at`         | DateTime           | Date et heure de dernière modification            | Non      |

#### Associations

| Association          | Type               | Description                                       |
|----------------------|--------------------|---------------------------------------------------|
| `payment`            | belongs_to         | Paiement associé                                  |
| `created_by`         | belongs_to         | Administrateur ayant créé le reçu                 |

### Entité associée : `Donation`

#### Attributs

| Attribut             | Type               | Description                                       | Nullable |
|----------------------|--------------------|---------------------------------------------------|----------|
| `id`                 | Integer            | Identifiant unique (clé primaire)                 | Non      |
| `payment_id`         | Integer            | Référence au paiement (si couplé)                 | Oui      |
| `user_id`            | Integer            | Référence à l'utilisateur donateur                | Oui      |
| `amount`             | Decimal            | Montant du don                                    | Non      |
| `anonymous`          | Boolean            | Si le don est anonyme                             | Non      |
| `fiscal_receipt_sent`| Boolean            | Si le reçu fiscal a été envoyé                    | Non      |
| `fiscal_receipt_number` | String          | Numéro du reçu fiscal                             | Oui      |
| `notes`              | Text               | Notes supplémentaires                             | Oui      |
| `created_at`         | DateTime           | Date et heure de création                         | Non      |
| `updated_at`         | DateTime           | Date et heure de dernière modification            | Non      |

#### Associations

| Association          | Type               | Description                                       |
|----------------------|--------------------|---------------------------------------------------|
| `payment`            | belongs_to         | Paiement associé (si couplé)                      |
| `user`               | belongs_to         | Utilisateur donateur (si non anonyme)             |
| `fiscal_receipt`     | has_one            | Reçu fiscal associé                               |

## Validations

### Validations du modèle `Payment`

```ruby
class Payment < ApplicationRecord
  # Énumérations
  enum payment_method: {
    cash: 0,
    card: 1,
    check: 2
  }
  
  enum status: {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3,
    refunded: 4
  }
  
  # Associations
  belongs_to :user
  belongs_to :payable, polymorphic: true
  belongs_to :processed_by, class_name: 'User', optional: true
  belongs_to :refunded_by, class_name: 'User', optional: true
  has_many :installments, dependent: :destroy
  has_one :receipt, dependent: :destroy
  
  # Validations
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :payment_method, presence: true
  validates :status, presence: true
  validates :reference_number, presence: true, uniqueness: true
  validates :receipt_sent, inclusion: { in: [true, false] }
  
  validates :donation_amount, numericality: { greater_than: 0 }, allow_nil: true
  validates :donation_anonymous, inclusion: { in: [true, false] }, if: -> { donation_amount.present? }
  
  validates :processed_at, presence: true, if: -> { completed? || failed? }
  validates :processed_by_id, presence: true, if: -> { completed? || failed? }
  
  validates :refunded_at, presence: true, if: :refunded?
  validates :refunded_by_id, presence: true, if: :refunded?
  validates :refund_reason, presence: true, if: :refunded?
  validates :refunded_amount, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: -> (p) { p.amount } }, if: :refunded?
  
  # Callbacks
  before_validation :generate_reference_number, on: :create
  after_create :create_receipt_for_completed_payment
  
  # Méthodes
  def has_donation?
    donation_amount.present? && donation_amount > 0
  end
  
  def installment_plan?
    installments.count > 1
  end
  
  def can_refund?
    completed? && !refunded? && (created_at > 30.days.ago || payable_type == 'Membership')
  end
  
  def mark_as_completed(admin_user)
    update(
      status: :completed,
      processed_by_id: admin_user.id,
      processed_at: Time.current
    )
  end
  
  def process_refund(admin_user, amount, reason)
    return false unless can_refund?
    
    transaction do
      update(
        status: :refunded,
        refunded_by_id: admin_user.id,
        refunded_at: Time.current,
        refunded_amount: amount,
        refund_reason: reason
      )
      
      # Mettre à jour l'élément payé (adhésion, cotisation)
      case payable_type
      when 'Membership'
        payable.update(status: :cancelled)
      when 'Contribution'
        payable.update(status: :cancelled, cancelled_at: Time.current, cancelled_reason: reason, cancelled_by_id: admin_user.id)
      end
      
      # Créer un reçu d'annulation
      create_refund_receipt(admin_user)
    end
  end
  
  private
  
  def generate_reference_number
    return if reference_number.present?
    
    prefix = 'PAY'
    date_part = Time.current.strftime('%Y%m%d')
    random_part = SecureRandom.alphanumeric(4).upcase
    
    self.reference_number = "#{prefix}-#{date_part}-#{random_part}"
  end
  
  def create_receipt_for_completed_payment
    return unless completed?
    
    receipt_type = if has_donation?
                     'standard_with_donation'
                   elsif installment_plan?
                     'installment_plan'
                   else
                     'standard'
                   end
    
    ReceiptService.generate_receipt(self, receipt_type)
  end
  
  def create_refund_receipt(admin_user)
    ReceiptService.generate_refund_receipt(self, admin_user)
  end
end
```

### Validations du modèle `Installment`

```ruby
class Installment < ApplicationRecord
  # Énumérations
  enum status: {
    pending: 0,
    completed: 1,
    failed: 2
  }
  
  enum payment_method: {
    check: 0,
    card: 1,
    cash: 2
  }
  
  # Associations
  belongs_to :payment
  belongs_to :processed_by, class_name: 'User', optional: true
  
  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :due_date, presence: true
  validates :status, presence: true
  validates :payment_method, presence: true
  
  validates :processed_by_id, presence: true, if: -> { completed? || failed? }
  validates :processed_at, presence: true, if: -> { completed? || failed? }
  
  # Méthodes
  def mark_as_completed(admin_user)
    update(
      status: :completed,
      processed_by_id: admin_user.id,
      processed_at: Time.current
    )
    
    # Vérifier si tous les versements sont complétés
    payment.reload
    all_completed = payment.installments.all? { |i| i.completed? }
    
    if all_completed
      payment.update(status: :completed)
    end
  end
  
  def mark_as_failed(admin_user)
    update(
      status: :failed,
      processed_by_id: admin_user.id,
      processed_at: Time.current
    )
    
    # Mise à jour du paiement principal
    payment.update(status: :failed)
  end
end
```

### Validations du modèle `Receipt`

```ruby
class Receipt < ApplicationRecord
  # Énumérations
  enum receipt_type: {
    standard: 0,
    standard_with_donation: 1,
    fiscal: 2,
    installment_plan: 3,
    refund: 4
  }
  
  # Associations
  belongs_to :payment
  belongs_to :created_by, class_name: 'User'
  
  # Validations
  validates :receipt_number, presence: true, uniqueness: true
  validates :receipt_type, presence: true
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :issued_at, presence: true
  validates :created_by_id, presence: true
  
  validates :donation_amount, presence: true, numericality: { greater_than: 0 }, if: -> { standard_with_donation? || fiscal? }
  
  # Callbacks
  before_validation :generate_receipt_number, on: :create
  after_create :send_receipt_to_user
  
  # Méthodes
  def mark_as_sent(email = nil)
    email ||= payment.user.email
    update(sent_at: Time.current, sent_to_email: email)
    payment.update(receipt_sent: true)
  end
  
  def generate_pdf
    pdf_service = ReceiptPdfService.new(self)
    pdf_path = pdf_service.generate
    update(pdf_path: pdf_path)
    pdf_path
  end
  
  private
  
  def generate_receipt_number
    return if receipt_number.present?
    
    prefix = case receipt_type
             when 'standard', 'standard_with_donation'
               'REC'
             when 'fiscal'
               'FISC'
             when 'installment_plan'
               'INST'
             when 'refund'
               'RFND'
             end
    
    date_part = issued_at.strftime('%Y%m%d')
    sequence = Receipt.where('created_at >= ?', Date.today.beginning_of_day).count + 1
    
    self.receipt_number = "#{prefix}-#{date_part}-#{sequence.to_s.rjust(4, '0')}"
  end
  
  def send_receipt_to_user
    return if payment.user.nil? || payment.user.email.blank?
    
    ReceiptMailer.send_receipt(self).deliver_later
    mark_as_sent(payment.user.email)
  end
end
```

### Validations du modèle `Donation`

```ruby
class Donation < ApplicationRecord
  # Associations
  belongs_to :payment, optional: true
  belongs_to :user, optional: true
  has_one :fiscal_receipt, -> { where(receipt_type: :fiscal) }, class_name: 'Receipt', as: :receipable
  
  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :anonymous, inclusion: { in: [true, false] }
  validates :fiscal_receipt_sent, inclusion: { in: [true, false] }
  
  validate :user_required_unless_anonymous
  
  # Callbacks
  after_create :generate_fiscal_receipt, if: -> { !anonymous && amount >= 10 }
  
  # Méthodes
  def generate_fiscal_receipt
    return if fiscal_receipt_sent
    
    admin = User.find_by(role: 'admin') || User.first
    receipt = Receipt.create!(
      payment_id: payment_id,
      receipt_type: :fiscal,
      total_amount: amount,
      donation_amount: amount,
      issued_at: Time.current,
      created_by_id: admin.id
    )
    
    update(fiscal_receipt_sent: true, fiscal_receipt_number: receipt.receipt_number)
  end
  
  private
  
  def user_required_unless_anonymous
    if !anonymous && user_id.nil?
      errors.add(:user_id, "doit être présent pour un don non anonyme")
    end
  end
end
```

## Services

### PaymentService

```ruby
class PaymentService
  attr_reader :errors
  
  def initialize(user, admin, params)
    @user = user
    @admin = admin
    @params = params
    @errors = []
  end
  
  def create_payment
    ActiveRecord::Base.transaction do
      # Création du paiement principal
      @payment = Payment.new(payment_params)
      
      unless @payment.save
        @errors += @payment.errors.full_messages
        raise ActiveRecord::Rollback
      end
      
      # Si paiement échelonné, création des versements
      if installment_plan?
        create_installments
      end
      
      # Enregistrement du don si présent
      if has_donation?
        create_donation
      end
      
      # Mise à jour de l'élément payé
      update_payable_status
      
      # Si paiement immédiat, marquer comme complété
      if immediate_payment?
        @payment.mark_as_completed(@admin)
      end
    end
    
    @errors.empty? ? @payment : false
  end
  
  def process_refund(payment, amount, reason)
    return false unless payment.can_refund?
    
    success = payment.process_refund(@admin, amount, reason)
    
    unless success
      @errors += payment.errors.full_messages
    end
    
    success
  end
  
  private
  
  def payment_params
    {
      user: @user,
      payable: find_payable,
      amount: calculate_amount,
      payment_method: @params[:payment_method],
      status: immediate_payment? ? :completed : :pending,
      donation_amount: donation_amount,
      donation_anonymous: @params[:donation_anonymous] || false,
      processed_by: immediate_payment? ? @admin : nil,
      processed_at: immediate_payment? ? Time.current : nil,
      notes: @params[:notes],
      receipt_sent: false
    }
  end
  
  def find_payable
    case @params[:payable_type]
    when 'Membership'
      Membership.find(@params[:payable_id])
    when 'Contribution'
      Contribution.find(@params[:payable_id])
    else
      @errors << "Type d'élément payé invalide"
      nil
    end
  end
  
  def calculate_amount
    case @params[:payable_type]
    when 'Membership'
      membership = Membership.find(@params[:payable_id])
      membership.membership_type == 'basic' ? 1 : (membership.discount_applied? ? 7 : 10)
    when 'Contribution'
      contribution = Contribution.find(@params[:payable_id])
      case contribution.contribution_type
      when 'pass_day'
        4
      when 'entry_pack'
        30
      when 'subscription_quarterly'
        65
      when 'subscription_annual'
        150
      end
    else
      0
    end
  end
  
  def has_donation?
    donation_amount.present? && donation_amount > 0
  end
  
  def donation_amount
    @params[:donation_amount].presence&.to_f
  end
  
  def installment_plan?
    @params[:installment_plan] && @params[:installments_count].to_i > 1 && calculate_amount >= 50
  end
  
  def immediate_payment?
    @params[:payment_method] != 'check' || !installment_plan?
  end
  
  def create_installments
    count = @params[:installments_count].to_i
    return if count <= 1
    
    total_amount = calculate_amount
    installment_amount = (total_amount / count).round(2)
    
    # Ajustement pour éviter les problèmes d'arrondi
    final_amount = total_amount - (installment_amount * (count - 1))
    
    (0...count).each do |i|
      due_date = i.months.from_now.to_date
      amount = (i == count - 1) ? final_amount : installment_amount
      
      installment = @payment.installments.build(
        amount: amount,
        due_date: due_date,
        status: i == 0 && @params[:payment_method] == 'check' ? :completed : :pending,
        payment_method: @params[:payment_method],
        reference: i == 0 ? @params[:check_number] : nil,
        processed_by: i == 0 && @params[:payment_method] == 'check' ? @admin : nil,
        processed_at: i == 0 && @params[:payment_method] == 'check' ? Time.current : nil
      )
      
      unless installment.save
        @errors += installment.errors.full_messages
        raise ActiveRecord::Rollback
      end
    end
  end
  
  def create_donation
    donation = Donation.new(
      payment: @payment,
      user: @params[:donation_anonymous] ? nil : @user,
      amount: donation_amount,
      anonymous: @params[:donation_anonymous] || false,
      fiscal_receipt_sent: false,
      notes: @params[:donation_notes]
    )
    
    unless donation.save
      @errors += donation.errors.full_messages
      raise ActiveRecord::Rollback
    end
  end
  
  def update_payable_status
    case @params[:payable_type]
    when 'Membership'
      membership = Membership.find(@params[:payable_id])
      membership.update(status: immediate_payment? ? :active : :pending)
    when 'Contribution'
      contribution = Contribution.find(@params[:payable_id])
      contribution.update(
        status: immediate_payment? ? :active : :pending,
        payment_status: immediate_payment? ? :completed : :pending
      )
    end
  end
end
```

### ReceiptService

```ruby
class ReceiptService
  def self.generate_receipt(payment, type = 'standard')
    admin = payment.processed_by || User.find_by(role: 'admin') || User.first
    
    receipt = Receipt.create!(
      payment: payment,
      receipt_type: type,
      total_amount: payment.amount,
      donation_amount: payment.donation_amount,
      issued_at: Time.current,
      created_by_id: admin.id
    )
    
    # Génération du PDF
    receipt.generate_pdf
    
    receipt
  end
  
  def self.generate_refund_receipt(payment, admin_user)
    receipt = Receipt.create!(
      payment: payment,
      receipt_type: :refund,
      total_amount: payment.refunded_amount,
      issued_at: Time.current,
      created_by_id: admin_user.id
    )
    
    # Génération du PDF
    receipt.generate_pdf
    
    receipt
  end
  
  def self.generate_annual_fiscal_receipts(year = Date.today.year - 1)
    start_date = Date.new(year, 1, 1)
    end_date = Date.new(year, 12, 31)
    
    # Trouver tous les dons pour l'année spécifiée
    donations = Donation.where(created_at: start_date..end_date)
                       .where(anonymous: false)
                       .where("amount >= ?", 10)
                       .group_by(&:user_id)
    
    receipts = []
    admin = User.find_by(role: 'admin') || User.first
    
    donations.each do |user_id, user_donations|
      next unless user_id
      
      user = User.find(user_id)
      total_amount = user_donations.sum(&:amount)
      
      receipt = Receipt.create!(
        payment_id: user_donations.first.payment_id,
        receipt_type: :fiscal,
        total_amount: total_amount,
        donation_amount: total_amount,
        issued_at: Time.current,
        created_by_id: admin.id
      )
      
      # Génération du PDF
      receipt.generate_pdf
      
      # Envoi du reçu
      ReceiptMailer.send_annual_fiscal_receipt(receipt, user, year).deliver_later
      receipt.mark_as_sent(user.email)
      
      receipts << receipt
    end
    
    receipts
  end
end
```

## Implémentation et migrations

### Migration pour la table `payments`

```ruby
class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :payable, polymorphic: true, null: false
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.integer :payment_method, null: false
      t.integer :status, null: false, default: 0
      t.decimal :donation_amount, precision: 8, scale: 2
      t.boolean :donation_anonymous, default: false
      t.string :reference_number, null: false
      t.boolean :receipt_sent, null: false, default: false
      t.string :receipt_number
      t.text :notes
      t.references :processed_by, foreign_key: { to_table: :users }
      t.datetime :processed_at
      t.datetime :refunded_at
      t.decimal :refunded_amount, precision: 8, scale: 2
      t.references :refunded_by, foreign_key: { to_table: :users }
      t.string :refund_reason

      t.timestamps
    end
    
    add_index :payments, :reference_number, unique: true
    add_index :payments, [:payable_type, :payable_id]
    add_index :payments, :status
  end
end
```

### Migration pour la table `installments`

```ruby
class CreateInstallments < ActiveRecord::Migration[6.1]
  def change
    create_table :installments do |t|
      t.references :payment, null: false, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.date :due_date, null: false
      t.integer :status, null: false, default: 0
      t.integer :payment_method, null: false
      t.string :reference
      t.references :processed_by, foreign_key: { to_table: :users }
      t.datetime :processed_at

      t.timestamps
    end
    
    add_index :installments, [:payment_id, :due_date]
    add_index :installments, :status
  end
end
```

### Migration pour la table `receipts`

```ruby
class CreateReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :receipts do |t|
      t.references :payment, null: false, foreign_key: true
      t.string :receipt_number, null: false
      t.integer :receipt_type, null: false
      t.decimal :total_amount, precision: 8, scale: 2, null: false
      t.decimal :donation_amount, precision: 8, scale: 2
      t.datetime :issued_at, null: false
      t.datetime :sent_at
      t.string :sent_to_email
      t.string :pdf_path
      t.references :created_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    
    add_index :receipts, :receipt_number, unique: true
    add_index :receipts, :receipt_type
  end
end
```

### Migration pour la table `donations`

```ruby
class CreateDonations < ActiveRecord::Migration[6.1]
  def change
    create_table :donations do |t|
      t.references :payment, foreign_key: true
      t.references :user, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.boolean :anonymous, null: false, default: false
      t.boolean :fiscal_receipt_sent, null: false, default: false
      t.string :fiscal_receipt_number
      t.text :notes

      t.timestamps
    end
    
    add_index :donations, :anonymous
    add_index :donations, :amount
  end
end
```

## Considérations techniques

### Sécurité

1. **Autorisations** : Utilisation de Pundit pour définir des politiques d'accès :
   - Seuls les administrateurs peuvent traiter et rembourser les paiements
   - Les utilisateurs peuvent voir uniquement leurs propres paiements
   - Validation administrative obligatoire pour tout remboursement

2. **Journalisation** : Toutes les actions financières sont tracées avec les informations de l'utilisateur qui les a effectuées.

3. **Validation des montants** : Vérification systématique des montants pour éviter les erreurs.

4. **Gestion des références** : Chaque paiement et reçu reçoit une référence unique pour garantir la traçabilité.

### Performance

1. **Indexation** : Des index sont définis sur les champs fréquemment utilisés pour les recherches et filtrages :
   - `reference_number` pour les recherches rapides de paiements
   - `receipt_number` pour les recherches de reçus
   - `status` pour filtrer les paiements par état
   - `payment_id` et `due_date` pour accéder rapidement aux versements échelonnés

2. **Pagination** : Implémentation de la pagination pour les listes de paiements et reçus.

3. **Génération asynchrone** : Les reçus PDF volumineux seront générés et envoyés de manière asynchrone via Active Job.

### Interface utilisateur

1. **Dashboard administrateur** : Interface dédiée pour le suivi des paiements, remboursements et statistiques.

2. **Rapports financiers** : Génération automatisée de rapports quotidiens et mensuels.

3. **Notifications** : Alertes pour les paiements échelonnés à encaisser, les anomalies et les rappels de reçus fiscaux.

## API et endpoints

### API pour les paiements

```ruby
# routes.rb
namespace :api do
  namespace :v1 do
    resources :payments, only: [:index, :show, :create] do
      member do
        post :refund
        post :process_installment
      end
      collection do
        get :pending
        get :search
      end
    end
    
    resources :receipts, only: [:index, :show, :create] do
      member do
        get :download
        post :send_email
      end
      collection do
        post :generate_fiscal_receipts
      end
    end
    
    resources :donations, only: [:index, :show, :create]
  end
end
```

## Intégrations

### Intégration avec le système d'email

```ruby
# app/mailers/receipt_mailer.rb
class ReceiptMailer < ApplicationMailer
  def send_receipt(receipt)
    @receipt = receipt
    @payment = receipt.payment
    @user = @payment.user
    
    # Génération du PDF si nécessaire
    pdf_path = @receipt.pdf_path || @receipt.generate_pdf
    
    attachments["receipt_#{@receipt.receipt_number}.pdf"] = File.read(pdf_path)
    
    mail(
      to: @user.email,
      subject: "Votre reçu #{@receipt.receipt_number} - Le Circographe"
    )
  end
  
  def send_annual_fiscal_receipt(receipt, user, year)
    @receipt = receipt
    @user = user
    @year = year
    
    # Génération du PDF si nécessaire
    pdf_path = @receipt.pdf_path || @receipt.generate_pdf
    
    attachments["recu_fiscal_#{@year}_#{@receipt.receipt_number}.pdf"] = File.read(pdf_path)
    
    mail(
      to: @user.email,
      subject: "Votre reçu fiscal #{@year} - Le Circographe"
    )
  end
  
  def payment_installment_reminder(installment)
    @installment = installment
    @payment = installment.payment
    @user = @payment.user
    
    mail(
      to: @user.email,
      subject: "Rappel d'échéance de paiement - Le Circographe"
    )
  end
  
  def donation_thank_you(donation)
    @donation = donation
    @user = donation.user
    
    return if @donation.anonymous || @user.nil?
    
    mail(
      to: @user.email,
      subject: "Merci pour votre don - Le Circographe"
    )
  end
end
```

### Intégration avec les tâches planifiées

```ruby
# lib/tasks/payments.rake
namespace :payments do
  desc "Process pending installments scheduled for today"
  task process_due_installments: :environment do
    today = Date.today
    due_installments = Installment.where(status: :pending, due_date: today)
    
    due_installments.each do |installment|
      admin = User.find_by(role: 'admin') || User.first
      
      if installment.payment_method == 'check'
        # Marquer comme complété automatiquement (chèque déjà collecté)
        installment.mark_as_completed(admin)
      else
        # Envoyer rappel pour les autres méthodes
        ReceiptMailer.payment_installment_reminder(installment).deliver_now
      end
    end
  end
  
  desc "Generate annual fiscal receipts for previous year"
  task generate_annual_fiscal_receipts: :environment do
    prev_year = Date.today.year - 1
    
    # Ne s'exécute qu'en janvier
    if Date.today.month == 1
      ReceiptService.generate_annual_fiscal_receipts(prev_year)
    end
  end
  
  desc "Send payment expiration alerts"
  task send_installment_reminders: :environment do
    upcoming_date = 7.days.from_now.to_date
    
    upcoming_installments = Installment.where(status: :pending, due_date: upcoming_date)
    
    upcoming_installments.each do |installment|
      ReceiptMailer.payment_installment_reminder(installment).deliver_now
    end
  end
end
```

---

*Document créé le [DATE] - Version 1.0* 