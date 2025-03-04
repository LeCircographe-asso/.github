# Spécifications Techniques - Paiements

## Identification du document

| Domaine           | Paiement                            |
|-------------------|-------------------------------------|
| Version           | 1.0                                 |
| Référence         | SPEC-PAI-2023-01                    |
| Dernière révision | Mars 2024                           |

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

## Validations

### Validations du modèle `Payment`

```ruby
class Payment < ApplicationRecord
  # Enums
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
  validates :refunded_amount, presence: true, 
    numericality: { greater_than: 0, less_than_or_equal_to: -> (p) { p.amount } }, 
    if: :refunded?

  # Methods
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
      
      # Update the paid item
      case payable_type
      when 'Membership'
        payable.update(status: :cancelled)
      when 'Contribution'
        payable.update(
          status: :cancelled, 
          cancelled_at: Time.current, 
          cancelled_reason: reason, 
          cancelled_by_id: admin_user.id
        )
      end
      
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
                   
    create_receipt!(
      receipt_type: receipt_type,
      total_amount: amount,
      donation_amount: donation_amount,
      created_by: processed_by
    )
  end
end
```

## Génération des documents

### Reçus et références

```ruby
class Payment < ApplicationRecord
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
                   
    create_receipt!(
      receipt_type: receipt_type,
      total_amount: amount,
      donation_amount: donation_amount,
      created_by: processed_by
    )
  end
end
```

## Sécurité et Permissions

### Politique d'accès

```ruby
class PaymentPolicy < ApplicationPolicy
  def index?
    user.admin? || user.volunteer?
  end
  
  def show?
    user.admin? || user.volunteer? || record.user_id == user.id
  end
  
  def create?
    user.admin? || user.volunteer?
  end
  
  def update?
    user.admin? || user.volunteer?
  end
  
  def refund?
    user.admin? && record.can_refund?
  end
  
  def process_installment?
    user.admin? || user.volunteer?
  end
end
```

## Tests

Les tests unitaires et d'intégration sont essentiels pour garantir le bon fonctionnement du système de paiement. Voir le fichier de validation pour les scénarios de test détaillés.

## Intégration avec les autres domaines

Le domaine de paiement interagit principalement avec :

- **Adhésion** : Activation des adhésions après paiement
- **Cotisation** : Gestion des abonnements et carnets
- **Notification** : Envoi des reçus et rappels d'échéance
- **Présence** : Vérification des paiements pour l'accès

## Performance et Optimisation

- Utilisation d'index sur les colonnes fréquemment recherchées
- Mise en cache des reçus générés
- Traitement asynchrone des tâches longues (génération de reçus fiscaux)
- Utilisation de transactions pour garantir l'intégrité des données

## Sécurité

- Validation stricte des montants et des types de paiement
- Traçabilité complète des opérations (audit trail)
- Restrictions d'accès basées sur les rôles
- Protection contre les doubles paiements
- Validation des données côté serveur

## Maintenance

- Archivage automatique des anciens paiements
- Nettoyage périodique des fichiers temporaires
- Monitoring des erreurs de paiement
- Sauvegarde régulière des données sensibles

## Implémentation

### Modèle Payment

```ruby
class Payment < ApplicationRecord
  # Enums
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
  validates :refunded_amount, presence: true, 
    numericality: { greater_than: 0, less_than_or_equal_to: -> (p) { p.amount } }, 
    if: :refunded?

  # Public methods
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
      
      case payable_type
      when 'Membership'
        payable.update(status: :cancelled)
      when 'Contribution'
        payable.update(
          status: :cancelled, 
          cancelled_at: Time.current, 
          cancelled_reason: reason, 
          cancelled_by_id: admin_user.id
        )
      end
      
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
                   
    create_receipt!(
      receipt_type: receipt_type,
      total_amount: amount,
      donation_amount: donation_amount,
      created_by: processed_by
    )
  end
end
```

### Politique d'accès

```ruby
class PaymentPolicy < ApplicationPolicy
  def index?
    user.admin? || user.volunteer?
  end
  
  def show?
    user.admin? || user.volunteer? || record.user_id == user.id
  end
  
  def create?
    user.admin? || user.volunteer?
  end
  
  def update?
    user.admin? || user.volunteer?
  end
  
  def refund?
    user.admin? && record.can_refund?
  end
  
  def process_installment?
    user.admin? || user.volunteer?
  end
end
```

## Tests et Validation

Les tests unitaires et d'intégration sont essentiels pour garantir le bon fonctionnement du système de paiement. Voir le fichier de validation pour les scénarios de test détaillés.

## Intégration avec les autres domaines

Le domaine de paiement interagit principalement avec :

- **Adhésion** : Activation des adhésions après paiement
- **Cotisation** : Gestion des abonnements et carnets
- **Notification** : Envoi des reçus et rappels d'échéance
- **Présence** : Vérification des paiements pour l'accès
