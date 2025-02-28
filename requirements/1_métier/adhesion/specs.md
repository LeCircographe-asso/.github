# Spécifications Techniques - Adhésion

## Identification du Document
- **Domaine**: Adhésion
- **Version**: 1.0.0
- **Référence**: [Règles d'Adhésion](/requirements/1_métier/adhesion/regles.md)
- **Dernière révision**: [DATE]

## Modèles de Données

### Modèle `Membership`

#### Attributs
| Attribut | Type | Description | Contraintes |
|----------|------|-------------|-------------|
| id | Integer | Identifiant unique | Primary Key, Auto-increment |
| user_id | Integer | Référence à l'utilisateur | Foreign Key, Not Null |
| membership_type | Enum | Type d'adhésion (basic, cirque) | Not Null |
| start_date | Date | Date de début de validité | Not Null |
| end_date | Date | Date de fin de validité | Not Null |
| status | Enum | État (pending, active, expired, cancelled) | Not Null |
| discount_applied | Boolean | Si tarif réduit appliqué | Default: false |
| discount_verified_by | Integer | Admin ayant vérifié le tarif réduit | Foreign Key, Null |
| payment_id | Integer | Référence au paiement | Foreign Key, Null |
| created_at | Datetime | Date de création | Not Null |
| updated_at | Datetime | Date de dernière modification | Not Null |

#### Validations
```ruby
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :payment, optional: true
  belongs_to :discount_verifier, class_name: "User", optional: true
  
  enum membership_type: { basic: 0, cirque: 1 }
  enum status: { pending: 0, active: 1, expired: 2, cancelled: 3 }
  
  validates :membership_type, :start_date, :end_date, :status, presence: true
  validate :end_date_after_start_date
  validate :validate_basic_requirement, if: -> { cirque? }
  validate :validate_single_active_membership
  
  before_validation :set_expiration_date, on: :create
  
  scope :active, -> { where(status: :active) }
  scope :expired, -> { where(status: :expired) }
  scope :basic, -> { where(membership_type: :basic) }
  scope :cirque, -> { where(membership_type: :cirque) }
  
  def activate!
    update(status: :active)
  end
  
  def expire!
    update(status: :expired)
  end
  
  def cancel!
    update(status: :cancelled)
  end
  
  def active?
    status == "active" && end_date >= Date.today
  end
  
  def can_renew?
    active? && end_date <= Date.today + 1.month
  end
  
  def apply_discount(admin_user)
    update(discount_applied: true, discount_verified_by: admin_user.id)
  end
  
  private
  
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    
    if end_date < start_date
      errors.add(:end_date, "doit être après la date de début")
    end
  end
  
  def validate_basic_requirement
    return unless cirque?
    
    has_valid_basic = user.memberships.basic.active.any?
    
    unless has_valid_basic
      errors.add(:membership_type, "nécessite une adhésion Basic valide")
    end
  end
  
  def validate_single_active_membership
    return if id.present?
    
    existing = user.memberships.where(membership_type: membership_type, status: :active)
    
    if existing.any?
      errors.add(:membership_type, "une seule adhésion active de ce type est autorisée")
    end
  end
  
  def set_expiration_date
    self.end_date = start_date + 1.year if start_date.present? && end_date.blank?
  end
end
```

## API et Méthodes Publiques

### MembershipService

```ruby
class MembershipService
  def self.create_basic_membership(user, payment = nil)
    membership = user.memberships.new(
      membership_type: :basic,
      start_date: Date.today,
      status: payment.present? ? :active : :pending,
      payment: payment
    )
    
    membership.save!
    membership
  end
  
  def self.create_cirque_membership(user, discount: false, verified_by: nil, payment: nil)
    # Vérification de l'adhésion Basic
    unless user.memberships.basic.active.any?
      raise StandardError, "Une adhésion Basic valide est requise"
    end
    
    membership = user.memberships.new(
      membership_type: :cirque,
      start_date: Date.today,
      status: payment.present? ? :active : :pending,
      discount_applied: discount,
      discount_verified_by: verified_by&.id,
      payment: payment
    )
    
    membership.save!
    membership
  end
  
  def self.upgrade_to_cirque(user, discount: false, verified_by: nil, payment: nil)
    basic_membership = user.memberships.basic.active.first
    
    unless basic_membership
      raise StandardError, "Aucune adhésion Basic active trouvée"
    end
    
    membership = user.memberships.new(
      membership_type: :cirque,
      start_date: Date.today,
      end_date: basic_membership.end_date,
      status: payment.present? ? :active : :pending,
      discount_applied: discount,
      discount_verified_by: verified_by&.id,
      payment: payment
    )
    
    membership.save!
    membership
  end
  
  def self.renew_membership(membership, payment = nil)
    unless membership.can_renew?
      raise StandardError, "Cette adhésion ne peut pas encore être renouvelée"
    end
    
    new_membership = membership.user.memberships.new(
      membership_type: membership.membership_type,
      start_date: membership.end_date + 1.day,
      status: payment.present? ? :active : :pending,
      discount_applied: membership.discount_applied,
      discount_verified_by: membership.discount_verified_by,
      payment: payment
    )
    
    new_membership.save!
    new_membership
  end
  
  def self.check_and_expire_memberships
    Membership.active.where("end_date < ?", Date.today).find_each do |membership|
      membership.expire!
    end
  end
end
```

## Implémentation des États et Transitions

### État de l'Adhésion

1. **Pending**
   - Créé mais en attente de paiement
   - Pas encore utilisable

2. **Active**
   - Paiement validé
   - Utilisable pour accéder aux services
   - Sous-états implicites: Basic ou Cirque selon `membership_type`

3. **Expired**
   - Date de fin dépassée
   - Non utilisable
   - Historique conservé

4. **Cancelled**
   - Annulé par décision administrative
   - Non utilisable
   - Historique conservé

### Transitions Implémentées

- **Création → Pending**
  ```ruby
  membership = Membership.create!(
    user: user,
    membership_type: :basic, 
    start_date: Date.today,
    status: :pending
  )
  ```

- **Pending → Active**
  ```ruby
  membership.update!(status: :active, payment_id: payment.id)
  # ou
  membership.activate!
  ```

- **Active → Expired**
  ```ruby
  membership.expire!
  ```

- **Active → Cancelled**
  ```ruby
  membership.cancel!
  ```

- **Basic → Cirque (upgrade)**
  ```ruby
  MembershipService.upgrade_to_cirque(user)
  ```

## Calcul des Tarifs

### Logique de tarification
```ruby
class MembershipPriceCalculator
  BASIC_PRICE = 100  # En centimes (1€)
  CIRQUE_PRICE = 1000  # En centimes (10€)
  CIRQUE_DISCOUNTED_PRICE = 700  # En centimes (7€)
  UPGRADE_PRICE = 900  # En centimes (9€)
  UPGRADE_DISCOUNTED_PRICE = 600  # En centimes (6€)
  
  def self.calculate_price(type, discount: false, upgrade: false)
    case type
    when :basic
      BASIC_PRICE
    when :cirque
      if upgrade
        discount ? UPGRADE_DISCOUNTED_PRICE : UPGRADE_PRICE
      else
        discount ? CIRQUE_DISCOUNTED_PRICE : CIRQUE_PRICE
      end
    else
      raise ArgumentError, "Type d'adhésion inconnu"
    end
  end
  
  def self.calculate_total_for_user(user, selected_types, discount: false)
    total = 0
    
    # Si nouvelle adhésion Basic nécessaire
    if selected_types.include?(:basic) && !user.has_active_basic_membership?
      total += BASIC_PRICE
    end
    
    # Si nouvelle adhésion Cirque nécessaire
    if selected_types.include?(:cirque)
      if user.has_active_basic_membership?
        # Upgrade
        total += discount ? UPGRADE_DISCOUNTED_PRICE : UPGRADE_PRICE
      else
        # Nouvelle adhésion Cirque (inclut Basic automatiquement)
        total += BASIC_PRICE
        total += discount ? CIRQUE_DISCOUNTED_PRICE : CIRQUE_PRICE
      end
    end
    
    total
  end
end
```

## Cas d'usage
| Cas d'usage | Service method | Validation |
|-------------|---------------|------------|
| Création adhésion Basic | MembershipService.create_basic_membership | ✅ |
| Création adhésion Cirque | MembershipService.create_cirque_membership | ✅ |
| Upgrade Basic → Cirque | MembershipService.upgrade_to_cirque | ✅ |
| Renouvellement adhésion | MembershipService.renew_membership | ✅ |
| Vérification tarif réduit | membership.apply_discount | ✅ |
| Expiration automatique | MembershipService.check_and_expire_memberships | ✅ |

## Points d'attention pour les développeurs
1. L'adhésion Cirque doit toujours vérifier l'existence d'une adhésion Basic active
2. Les dates de validité doivent être correctement gérées lors des renouvellements
3. L'expiration automatique doit être programmée via une tâche cron
4. Les tarifs sont définis en centimes pour éviter les erreurs de calcul
5. Le statut des adhésions doit être mis à jour immédiatement après paiement validé 