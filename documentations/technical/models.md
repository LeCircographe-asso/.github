# Modèles de données

## Diagramme de classes

**Note:** Les diagrammes sont en cours de développement et seront ajoutés ultérieurement. 
Le diagramme sera situé dans `../assets/diagrams/class_diagram.png`.

## Relations principales

```ruby
# User (Utilisateur)
class User < ApplicationRecord
  has_many :memberships
  has_many :subscriptions, through: :memberships
  has_many :attendances
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :notifications
end

# Membership (Adhésion)
class Membership < ApplicationRecord
  belongs_to :user
  has_many :subscriptions
  has_many :payments, as: :payable
end

# Subscription (Cotisation)
class Subscription < ApplicationRecord
  belongs_to :membership
  belongs_to :activity_type, optional: true
  has_many :payments, as: :payable
end

# Payment (Paiement)
class Payment < ApplicationRecord
  belongs_to :payable, polymorphic: true
  belongs_to :user
end

# Attendance (Présence)
class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :activity
end

# Activity (Activité)
class Activity < ApplicationRecord
  belongs_to :activity_type
  has_many :attendances
end

# Role (Rôle)
class Role < ApplicationRecord
  has_many :user_roles
  has_many :users, through: :user_roles
  has_many :role_permissions
  has_many :permissions, through: :role_permissions
end

# Notification
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true, optional: true
end
```

## Validations principales

### User
- Email unique et valide
- Mot de passe sécurisé
- Nom et prénom obligatoires

### Membership
- Dates de début et fin de validité
- Statut d'adhésion
- Association obligatoire avec un utilisateur

### Subscription
- Dates de validité
- Montant
- Type d'activité (optionnel)

### Payment
- Montant
- Date de paiement
- Méthode de paiement
- Entité payée (adhésion ou cotisation)

### Attendance
- Date et heure
- Utilisateur et activité obligatoires

## Callbacks et méthodes importantes

- Création automatique d'une notification lors de l'inscription
- Vérification de la validité des adhésions et cotisations
- Calcul des montants restants à payer

---

*Dernière mise à jour: Mars 2023*
