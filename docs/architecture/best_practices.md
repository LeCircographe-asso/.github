# Architecture et Bonnes Pratiques

## Structure du Projet

### Organisation des Dossiers
```
app/
├── controllers/
│   ├── admin/           # Interface d'administration
│   ├── api/             # API endpoints
│   └── concerns/        # Modules partagés
├── models/
│   └── concerns/        # Modules partagés
├── services/           # Logique métier complexe
├── policies/          # Règles d'autorisation
├── presenters/        # Présentation des données
├── queries/           # Requêtes complexes
└── views/
    ├── layouts/       # Templates de base
    └── shared/        # Composants réutilisables

lib/
├── tasks/            # Tâches Rake
└── services/         # Services système

spec/
├── factories/        # Factories pour les tests
├── support/         # Helpers de test
└── system/          # Tests d'intégration
```

## Principes SOLID

### Single Responsibility
```ruby
# ❌ Mauvais exemple
class Membership
  def create_membership
    # Logique de création
    # Envoi d'email
    # Génération PDF
    # Notification Slack
  end
end

# ✅ Bon exemple
class MembershipCreator
  def initialize(user:, type:)
    @user = user
    @type = type
  end

  def call
    membership = create_membership
    notify_creation(membership)
    membership
  end

  private

  def create_membership
    Membership.create!(
      user: @user,
      type: @type,
      start_date: Time.current,
      end_date: 1.year.from_now
    )
  end

  def notify_creation(membership)
    MembershipMailer.welcome_email(membership).deliver_later
    MembershipNotifier.new(membership).notify
  end
end
```

### Open/Closed
```ruby
# app/models/concerns/payable.rb
module Payable
  extend ActiveSupport::Concern

  included do
    has_many :payments, as: :payable
  end

  def calculate_price
    raise NotImplementedError
  end
end

class Membership < ApplicationRecord
  include Payable

  def calculate_price
    case type
    when 'basic'
      1.0
    when 'circus'
      reduced_price? ? 7.0 : 10.0
    end
  end
end
```

## Design Patterns

### Service Objects
```ruby
# app/services/base_service.rb
class BaseService
  def self.call(*args)
    new(*args).call
  end
end

# app/services/memberships/upgrade_service.rb
module Memberships
  class UpgradeService < BaseService
    def initialize(user:, reduced_price: false)
      @user = user
      @reduced_price = reduced_price
    end

    def call
      return failure("Adhésion simple requise") unless @user.active_basic_membership?
      return failure("Déjà membre cirque") if @user.active_circus_membership?

      ActiveRecord::Base.transaction do
        membership = create_circus_membership
        process_payment(membership)
        notify_upgrade(membership)
        
        success(membership)
      end
    rescue => e
      failure(e.message)
    end

    private

    def create_circus_membership
      @user.memberships.create!(
        type: 'CircusMembership',
        start_date: Time.current,
        end_date: 1.year.from_now,
        reduced_price: @reduced_price
      )
    end

    def success(data)
      OpenStruct.new(success?: true, data: data)
    end

    def failure(message)
      OpenStruct.new(success?: false, error: message)
    end
  end
end
```

### Query Objects
```ruby
# app/queries/base_query.rb
class BaseQuery
  attr_reader :relation

  def initialize(relation = default_relation)
    @relation = relation
  end

  def call
    relation
  end

  private

  def default_relation
    raise NotImplementedError
  end
end

# app/queries/active_memberships_query.rb
class ActiveMembershipsQuery < BaseQuery
  def initialize(relation = Membership.all)
    super
  end

  def call
    relation
      .where('start_date <= ?', Date.current)
      .where('end_date >= ?', Date.current)
      .includes(:user)
      .order(end_date: :asc)
  end
end
```

### Presenters
```ruby
# app/presenters/membership_presenter.rb
class MembershipPresenter < SimpleDelegator
  def status_badge
    case status
    when 'active'
      h.content_tag(:span, 'Actif', class: 'badge badge-success')
    when 'expired'
      h.content_tag(:span, 'Expiré', class: 'badge badge-danger')
    when 'pending'
      h.content_tag(:span, 'En attente', class: 'badge badge-warning')
    end
  end

  def remaining_days
    return 0 if expired?
    (end_date - Date.current).to_i
  end

  def price_display
    amount = reduced_price? ? '7€' : '10€'
    "#{amount}/an"
  end

  private

  def h
    ApplicationController.helpers
  end
end
``` 