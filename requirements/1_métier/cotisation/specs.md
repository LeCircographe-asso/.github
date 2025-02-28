# Spécifications Techniques - Cotisations

## Identification du document

| Domaine           | Cotisation                           |
|-------------------|--------------------------------------|
| Version           | 1.0                                  |
| Référence         | SPEC-COT-2023-01                     |
| Dernière révision | [DATE]                               |

## Vue d'ensemble

Ce document définit les spécifications techniques pour le domaine "Cotisation" du système Circographe. Il décrit le modèle de données, les validations, les API, et les détails d'implémentation nécessaires au développement des fonctionnalités de gestion des cotisations.

## Modèle de données

### Entité principale : `Contribution`

#### Attributs

| Attribut             | Type               | Description                                       | Nullable |
|----------------------|--------------------|---------------------------------------------------|----------|
| `id`                 | Integer            | Identifiant unique (clé primaire)                 | Non      |
| `user_id`            | Integer            | Référence à l'utilisateur (clé étrangère)         | Non      |
| `contribution_type`  | Enum               | Type de cotisation (pass_day, entry_pack, subscription_quarterly, subscription_annual) | Non |
| `entries_count`      | Integer            | Nombre d'entrées pour les carnets                 | Oui      |
| `entries_left`       | Integer            | Nombre d'entrées restantes pour les carnets       | Oui      |
| `start_date`         | Date               | Date de début de validité                         | Non      |
| `end_date`           | Date               | Date de fin de validité                           | Oui      |
| `status`             | Enum               | Statut (pending, active, expired, cancelled)      | Non      |
| `amount`             | Decimal            | Montant payé                                      | Non      |
| `payment_status`     | Enum               | Statut du paiement (pending, completed, failed)   | Non      |
| `payment_method`     | Enum               | Méthode de paiement (cash, card, check, installment) | Non   |
| `created_at`         | DateTime           | Date et heure de création                         | Non      |
| `updated_at`         | DateTime           | Date et heure de dernière modification            | Non      |
| `cancelled_at`       | DateTime           | Date et heure d'annulation                        | Oui      |
| `cancelled_reason`   | String             | Motif d'annulation                                | Oui      |
| `cancelled_by_id`    | Integer            | ID de l'administrateur ayant annulé               | Oui      |

#### Associations

| Association          | Type               | Description                                       |
|----------------------|--------------------|---------------------------------------------------|
| `user`               | belongs_to         | Utilisateur auquel la cotisation est rattachée    |
| `entries`            | has_many           | Entrées liées à cette cotisation                  |
| `payments`           | has_many           | Paiements liés à cette cotisation                 |
| `cancelled_by`       | belongs_to         | Utilisateur ayant annulé la cotisation            |

### Entité secondaire : `Entry`

#### Attributs

| Attribut             | Type               | Description                                       | Nullable |
|----------------------|--------------------|---------------------------------------------------|----------|
| `id`                 | Integer            | Identifiant unique (clé primaire)                 | Non      |
| `contribution_id`    | Integer            | Référence à la cotisation (clé étrangère)         | Non      |
| `user_id`            | Integer            | Référence à l'utilisateur (clé étrangère)         | Non      |
| `recorded_by_id`     | Integer            | Admin/bénévole ayant enregistré l'entrée          | Non      |
| `entry_date`         | DateTime           | Date et heure de l'entrée                         | Non      |
| `cancelled`          | Boolean            | Indicateur d'annulation                           | Non      |
| `cancelled_at`       | DateTime           | Date et heure d'annulation                        | Oui      |
| `cancelled_reason`   | String             | Motif d'annulation                                | Oui      |
| `cancelled_by_id`    | Integer            | Admin ayant annulé l'entrée                       | Oui      |
| `created_at`         | DateTime           | Date et heure de création                         | Non      |
| `updated_at`         | DateTime           | Date et heure de dernière modification            | Non      |

#### Associations

| Association          | Type               | Description                                       |
|----------------------|--------------------|---------------------------------------------------|
| `contribution`       | belongs_to         | Cotisation utilisée pour cette entrée             |
| `user`               | belongs_to         | Utilisateur associé à cette entrée                |
| `recorded_by`        | belongs_to         | Utilisateur ayant enregistré l'entrée             |
| `cancelled_by`       | belongs_to         | Utilisateur ayant annulé l'entrée                 |

### Entité tertiaire : `Payment`

#### Attributs

| Attribut             | Type               | Description                                       | Nullable |
|----------------------|--------------------|---------------------------------------------------|----------|
| `id`                 | Integer            | Identifiant unique (clé primaire)                 | Non      |
| `contribution_id`    | Integer            | Référence à la cotisation (clé étrangère)         | Non      |
| `amount`             | Decimal            | Montant du paiement                               | Non      |
| `payment_method`     | Enum               | Méthode de paiement                               | Non      |
| `payment_date`       | Date               | Date du paiement ou d'encaissement                | Non      |
| `status`             | Enum               | Statut (pending, completed, failed)               | Non      |
| `reference`          | String             | Référence du paiement                             | Oui      |
| `recorded_by_id`     | Integer            | Admin ayant enregistré le paiement                | Non      |
| `created_at`         | DateTime           | Date et heure de création                         | Non      |
| `updated_at`         | DateTime           | Date et heure de dernière modification            | Non      |

#### Associations

| Association          | Type               | Description                                       |
|----------------------|--------------------|---------------------------------------------------|
| `contribution`       | belongs_to         | Cotisation associée à ce paiement                 |
| `recorded_by`        | belongs_to         | Utilisateur ayant enregistré le paiement          |

## Validations

### Validations du modèle `Contribution`

```ruby
class Contribution < ApplicationRecord
  # Énumérations
  enum contribution_type: {
    pass_day: 0,
    entry_pack: 1,
    subscription_quarterly: 2, 
    subscription_annual: 3
  }
  
  enum status: {
    pending: 0,
    active: 1,
    expired: 2,
    cancelled: 3
  }
  
  enum payment_status: {
    pending: 0,
    completed: 1,
    failed: 2
  }
  
  enum payment_method: {
    cash: 0,
    card: 1,
    check: 2,
    installment: 3
  }
  
  # Associations
  belongs_to :user
  belongs_to :cancelled_by, class_name: 'User', optional: true
  has_many :entries, dependent: :nullify
  has_many :payments, dependent: :nullify
  
  # Validations
  validates :contribution_type, presence: true
  validates :status, presence: true
  validates :payment_status, presence: true
  validates :payment_method, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :start_date, presence: true
  validates :entries_count, presence: true, if: :entry_pack?
  validates :entries_left, presence: true, if: :entry_pack?
  validates :end_date, presence: true, if: :subscription?
  
  # Validations personnalisées
  validate :user_has_valid_cirque_membership
  validate :no_overlapping_subscriptions, if: :subscription?
  
  # Méthodes d'instance
  def subscription?
    subscription_quarterly? || subscription_annual?
  end
  
  def active_subscription?
    subscription? && active?
  end
  
  # Validation personnalisée : vérifie que l'utilisateur a une adhésion Cirque valide
  def user_has_valid_cirque_membership
    unless user&.has_valid_cirque_membership?
      errors.add(:user, "must have a valid Cirque membership")
    end
  end
  
  # Validation personnalisée : vérifie qu'il n'y a pas d'abonnement qui se chevauche
  def no_overlapping_subscriptions
    return unless start_date && end_date && user_id
    
    overlapping_subscriptions = user.contributions
                                   .where(status: :active)
                                   .where(contribution_type: [2, 3]) # Abonnements
                                   .where.not(id: id) # Exclure cette contribution si déjà sauvegardée
                                   .where("start_date <= ? AND end_date >= ?", end_date, start_date)
    
    if overlapping_subscriptions.exists?
      errors.add(:base, "User already has an active subscription during this period")
    end
  end
end
```

### Validations du modèle `Entry`

```ruby
class Entry < ApplicationRecord
  # Associations
  belongs_to :contribution
  belongs_to :user
  belongs_to :recorded_by, class_name: 'User'
  belongs_to :cancelled_by, class_name: 'User', optional: true
  
  # Validations
  validates :entry_date, presence: true
  validates :cancelled, inclusion: { in: [true, false] }
  validates :cancelled_reason, presence: true, if: :cancelled
  validates :cancelled_by_id, presence: true, if: :cancelled
  validates :cancelled_at, presence: true, if: :cancelled
  
  # Validations personnalisées
  validate :contribution_active_at_entry_date
  validate :user_matches_contribution_user
  
  # Validation personnalisée : vérifie que la cotisation était active à la date d'entrée
  def contribution_active_at_entry_date
    return unless contribution && entry_date
    
    contrib = contribution
    
    # Vérifie le statut et les dates de validité
    valid_contrib = contrib.active? &&
                   contrib.start_date <= entry_date.to_date &&
                   (contrib.end_date.nil? || contrib.end_date >= entry_date.to_date)
    
    unless valid_contrib
      errors.add(:contribution, "was not active at entry date")
    end
    
    # Pour les carnets, vérifier qu'il reste des entrées
    if contrib.entry_pack? && (contrib.entries_left.nil? || contrib.entries_left <= 0)
      errors.add(:contribution, "has no entries left")
    end
  end
  
  # Validation personnalisée : vérifie que l'utilisateur correspond à celui de la cotisation
  def user_matches_contribution_user
    return unless contribution && user
    
    unless user_id == contribution.user_id
      errors.add(:user, "does not match the contribution user")
    end
  end
end
```

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
    completed: 1,
    failed: 2
  }
  
  # Associations
  belongs_to :contribution
  belongs_to :recorded_by, class_name: 'User'
  
  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_method, presence: true
  validates :payment_date, presence: true
  validates :status, presence: true
  
  # Callbacks
  after_save :update_contribution_payment_status
  
  private
  
  # Met à jour le statut de paiement de la cotisation
  def update_contribution_payment_status
    contrib = contribution
    
    # Calcule le total payé
    total_paid = contrib.payments.where(status: :completed).sum(:amount)
    
    # Détermine le statut de paiement de la cotisation
    if total_paid >= contrib.amount
      contrib.update(payment_status: :completed)
    elsif contrib.payments.where(status: :failed).exists?
      contrib.update(payment_status: :failed)
    else
      contrib.update(payment_status: :pending)
    end
  end
end
```

## APIs et Services

### Service de création de cotisation

```ruby
class ContributionCreationService
  attr_reader :errors
  
  def initialize(user, params)
    @user = user
    @params = params
    @errors = []
  end
  
  def create
    return false unless validate_prerequisites
    
    ActiveRecord::Base.transaction do
      create_contribution
      create_payments if @contribution.persisted?
      activate_if_payment_complete
      
      raise ActiveRecord::Rollback if @errors.any?
    end
    
    @errors.empty?
  end
  
  private
  
  def validate_prerequisites
    unless @user.has_valid_cirque_membership?
      @errors << "User must have a valid Cirque membership"
      return false
    end
    
    if subscription? && has_overlapping_subscription?
      @errors << "User already has an active subscription during this period"
      return false
    end
    
    true
  end
  
  def create_contribution
    @contribution = Contribution.new(contribution_params)
    @contribution.user = @user
    @contribution.start_date = Date.today
    
    # Configure selon le type
    case @params[:contribution_type]
    when 'pass_day'
      @contribution.amount = 4
      @contribution.end_date = Date.today
    when 'entry_pack'
      @contribution.amount = 30
      @contribution.entries_count = 10
      @contribution.entries_left = 10
    when 'subscription_quarterly'
      @contribution.amount = 65
      @contribution.end_date = 3.months.from_now.to_date
    when 'subscription_annual'
      @contribution.amount = 150
      @contribution.end_date = 1.year.from_now.to_date
    end
    
    # Statut initial
    @contribution.status = :pending
    @contribution.payment_status = :pending
    
    unless @contribution.save
      @errors += @contribution.errors.full_messages
    end
  end
  
  def create_payments
    if @params[:payment_method] == 'installment'
      create_installment_payments
    else
      payment = Payment.new(
        contribution: @contribution,
        amount: @contribution.amount,
        payment_method: @params[:payment_method],
        payment_date: Date.today,
        status: @params[:payment_completed] ? :completed : :pending,
        recorded_by_id: @params[:admin_id]
      )
      
      unless payment.save
        @errors += payment.errors.full_messages
      end
    end
  end
  
  def create_installment_payments
    return unless @contribution.amount >= 50
    
    installments_count = @params[:installments_count] || 3
    amount_per_installment = (@contribution.amount / installments_count).round(2)
    
    # Ajustement pour éviter les problèmes d'arrondi
    last_installment_amount = @contribution.amount - (amount_per_installment * (installments_count - 1))
    
    (0...installments_count).each do |i|
      payment_date = i.months.from_now.to_date
      
      amount = (i == installments_count - 1) ? last_installment_amount : amount_per_installment
      
      payment = Payment.new(
        contribution: @contribution,
        amount: amount,
        payment_method: :check,
        payment_date: payment_date,
        status: i == 0 ? :completed : :pending,
        reference: "Installment #{i+1}/#{installments_count}",
        recorded_by_id: @params[:admin_id]
      )
      
      unless payment.save
        @errors += payment.errors.full_messages
      end
    end
  end
  
  def activate_if_payment_complete
    if @contribution.payment_status == 'completed'
      @contribution.update(status: :active)
    end
  end
  
  def contribution_params
    {
      contribution_type: @params[:contribution_type],
      payment_method: @params[:payment_method]
    }
  end
  
  def subscription?
    ['subscription_quarterly', 'subscription_annual'].include?(@params[:contribution_type])
  end
  
  def has_overlapping_subscription?
    return false unless subscription?
    
    end_date = case @params[:contribution_type]
               when 'subscription_quarterly'
                 3.months.from_now.to_date
               when 'subscription_annual'
                 1.year.from_now.to_date
               end
    
    @user.contributions
         .where(status: :active)
         .where(contribution_type: [2, 3]) # Abonnements
         .where("start_date <= ? AND end_date >= ?", end_date, Date.today)
         .exists?
  end
end
```

### Service d'enregistrement d'entrée

```ruby
class EntryRecordService
  attr_reader :errors, :entry
  
  def initialize(user, admin)
    @user = user
    @admin = admin
    @errors = []
    @entry = nil
  end
  
  def record_entry
    return false unless validate_user
    
    contribution = find_best_contribution
    
    return false unless contribution
    
    ActiveRecord::Base.transaction do
      @entry = Entry.new(
        contribution: contribution,
        user: @user,
        recorded_by: @admin,
        entry_date: DateTime.now,
        cancelled: false
      )
      
      unless @entry.save
        @errors += @entry.errors.full_messages
        raise ActiveRecord::Rollback
      end
      
      # Si c'est un carnet, décrémenter les entrées
      if contribution.entry_pack?
        contribution.entries_left -= 1
        
        unless contribution.save
          @errors += contribution.errors.full_messages
          raise ActiveRecord::Rollback
        end
        
        # Si plus d'entrées, marquer comme expiré
        if contribution.entries_left <= 0
          contribution.update(status: :expired)
        end
      end
    end
    
    @errors.empty?
  end
  
  private
  
  def validate_user
    unless @user.has_valid_cirque_membership?
      @errors << "User does not have a valid Cirque membership"
      return false
    end
    
    true
  end
  
  def find_best_contribution
    # Logique de priorité:
    # 1. Abonnements actifs
    # 2. Carnets avec entrées
    # 3. Pass journée non utilisé aujourd'hui
    
    # Chercher un abonnement actif
    active_subscription = @user.contributions
                             .where(status: :active)
                             .where("contribution_type IN (2, 3)") # Abonnements trimestriel ou annuel
                             .where("start_date <= ?", Date.today)
                             .where("end_date >= ?", Date.today)
                             .first
    
    return active_subscription if active_subscription
    
    # Chercher un carnet avec entrées
    active_pack = @user.contributions
                      .where(status: :active)
                      .where(contribution_type: 1) # Carnet
                      .where("entries_left > 0")
                      .first
    
    return active_pack if active_pack
    
    # Chercher un pass journée valide aujourd'hui
    today_pass = @user.contributions
                     .where(status: :active)
                     .where(contribution_type: 0) # Pass journée
                     .where(start_date: Date.today)
                     .where(end_date: Date.today)
                     .first
    
    return today_pass if today_pass
    
    # Aucune cotisation valide trouvée
    @errors << "No valid contribution found for this user"
    nil
  end
end
```

## Implémentation et contraintes techniques

### Migration pour la table `contributions`

```ruby
class CreateContributions < ActiveRecord::Migration[6.1]
  def change
    create_table :contributions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :contribution_type, null: false
      t.integer :entries_count
      t.integer :entries_left
      t.date :start_date, null: false
      t.date :end_date
      t.integer :status, null: false, default: 0
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.integer :payment_status, null: false, default: 0
      t.integer :payment_method, null: false
      t.datetime :cancelled_at
      t.string :cancelled_reason
      t.references :cancelled_by, foreign_key: { to_table: :users }

      t.timestamps
    end
    
    add_index :contributions, [:user_id, :contribution_type, :status]
    add_index :contributions, [:start_date, :end_date]
  end
end
```

### Migration pour la table `entries`

```ruby
class CreateEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :entries do |t|
      t.references :contribution, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :recorded_by, null: false, foreign_key: { to_table: :users }
      t.datetime :entry_date, null: false
      t.boolean :cancelled, null: false, default: false
      t.datetime :cancelled_at
      t.string :cancelled_reason
      t.references :cancelled_by, foreign_key: { to_table: :users }

      t.timestamps
    end
    
    add_index :entries, :entry_date
    add_index :entries, [:user_id, :entry_date]
  end
end
```

### Migration pour la table `payments`

```ruby
class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    create_table :payments do |t|
      t.references :contribution, null: false, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.integer :payment_method, null: false
      t.date :payment_date, null: false
      t.integer :status, null: false, default: 0
      t.string :reference
      t.references :recorded_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    
    add_index :payments, [:contribution_id, :status]
    add_index :payments, :payment_date
  end
end
```

### Performances et considérations techniques

1. **Indexation** : Des index ont été définis pour optimiser les requêtes les plus fréquentes :
   - `user_id`, `contribution_type` et `status` pour filtrer rapidement les cotisations actives d'un utilisateur
   - `start_date` et `end_date` pour vérifier les chevauchements d'abonnements
   - `entry_date` pour filtrer les entrées par date
   - `contribution_id` et `status` pour vérifier les paiements d'une cotisation

2. **Transactions** : Utilisation systématique de transactions pour garantir l'intégrité des données lors des opérations complexes comme la création de cotisations avec paiements échelonnés.

3. **Service objects** : Implémentation de la logique métier dans des services pour :
   - Simplifier les contrôleurs
   - Faciliter les tests unitaires
   - Isoler les règles métier complexes
   - Permettre la réutilisation du code

4. **Callbacks** : Utilisation limitée des callbacks aux cas où ils sont réellement nécessaires, comme la mise à jour du statut de paiement d'une cotisation.

5. **Énumérations** : Utilisation des `enum` de Rails pour les statuts et types, offrant une API plus expressive et des méthodes utilitaires.

6. **Validations conditionnelles** : Application des validations uniquement lorsqu'elles sont pertinentes, par exemple `entries_count` n'est requis que pour les carnets.

## Intégration

### Routes API

```ruby
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :contributions, only: [:index, :show, :create] do
        member do
          post :cancel
        end
        collection do
          get :active
        end
      end
      
      resources :entries, only: [:index, :create, :show] do
        member do
          post :cancel
        end
        collection do
          get :today
        end
      end
      
      resources :payments, only: [:index, :create, :show, :update]
    end
  end
end
```

### Webhook pour les notifications

Définition d'un endpoint pour recevoir des notifications de paiement externe :

```ruby
post '/api/v1/payment_callback', to: 'api/v1/payments#webhook'
```

Le contrôleur implémentera la logique de vérification de la signature, de l'authentification et de la mise à jour du statut de paiement.

## Sécurité

1. **Autorisations** : Utilisation de Pundit pour définir des politiques d'accès :
   - Seuls les administrateurs peuvent créer des cotisations
   - Seuls les administrateurs peuvent annuler une cotisation
   - Les utilisateurs peuvent voir uniquement leurs propres cotisations
   - Seuls les administrateurs peuvent accéder aux paiements

2. **Journalisation** : Toutes les opérations administratives (création, annulation, modification) sont journalisées avec les informations de l'utilisateur qui a effectué l'action.

3. **Validation des données** : Toutes les entrées utilisateur sont validées avant d'être traitées.

4. **Protection CSRF** : Application des protections CSRF standard de Rails.

## Aspects visuels et UI

La mise en œuvre des interfaces utilisateur doit suivre les wireframes approuvés par l'équipe (non inclus dans ce document). Les vues principales à créer sont :

1. Liste des cotisations actives d'un membre
2. Formulaire de création de cotisation 
3. Interface d'enregistrement d'entrée
4. Tableau de bord administratif des cotisations
5. Rapports statistiques

---

*Document créé le [DATE] - Version 1.0* 