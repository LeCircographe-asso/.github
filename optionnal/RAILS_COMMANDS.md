# Guide des Commandes Rails 8 pour Le Circo

Ce guide détaille toutes les commandes nécessaires pour construire l'application Le Circo depuis zéro, en suivant les requirements spécifiques du projet.

## 🚀 Installation et Configuration Initiale

```bash
# Installation de Ruby et Rails
rbenv install 3.2.0
rbenv global 3.2.0
gem install rails -v 8.0.1

# Création du nouveau projet avec les configurations spécifiques
rails new lecirco --database=sqlite3 --css=tailwind --javascript=importmap

# Navigation vers le répertoire du projet
cd lecirco

# Installation des gems autorisées
bundle add turbo-rails
bundle add stimulus-rails
bundle add tailwindcss-rails
bundle add flowbite-rails
bundle add redis
bundle add sidekiq
bundle add image_processing
bundle add rspec-rails --group=development,test
bundle add factory_bot_rails --group=development,test
bundle add faker --group=development,test

# Configuration initiale
rails active_storage:install
rails action_text:install
rails turbo:install
rails turbo:install:redis
rails stimulus:install
rails tailwindcss:install
```

## 📦 Phase 1 : Core - Gestion des Membres

```bash
# Configuration de la sécurité
rails credentials:edit
rails generate initializer session_store
rails generate initializer security_headers

# Installation du système d'authentification native Rails 8
rails generate authentication:install
rails generate authentication:user User

# Configuration des modèles principaux
rails generate model Role name:string:uniq
rails generate model UserRole user:references role:references
rails generate model Session user:references \
  ip_address:string user_agent:string last_active_at:datetime \
  expires_at:datetime

# Configuration des modèles d'adhésion
rails generate model Membership \
  user:references type:string start_date:date end_date:date \
  reduced_price:boolean reduction_reason:string metadata:jsonb

rails generate model BasicMembership --parent=Membership
rails generate model CircusMembership --parent=Membership

# Configuration des modèles de gestion
rails generate model OpeningHour \
  day_of_week:integer start_time:time end_time:time \
  active:boolean recorded_by:references

rails generate model ScheduleException \
  date:date original_start:time original_end:time \
  modified_start:time modified_end:time type:string \
  reason:string description:text recorded_by:references

rails generate model MemberNote \
  user:references note_type:string content:text \
  recorded_by:references

rails generate model SecurityEvent \
  user:references action:string ip_address:string \
  user_agent:string metadata:jsonb

# Configuration des controllers principaux
rails generate controller Auth::Sessions new create destroy
rails generate controller Auth::Passwords new create edit update
rails generate controller Auth::Registrations new create
rails generate controller Auth::Profiles show edit update
rails generate controller Memberships index show new create edit update destroy
rails generate controller Admin::Dashboard index
rails generate controller Admin::Users index show edit update destroy
rails generate controller Admin::Settings index update
rails generate controller OpeningHours index new create edit update
rails generate controller ScheduleExceptions index new create edit update

# Configuration des jobs
rails generate job UserNotification
rails generate job MembershipExpiration
rails generate job DailyStats
rails generate job SecurityAudit

# Configuration des mailers
rails generate mailer User welcome password_reset membership_expiring
rails generate mailer Admin notification security_alert

# Configuration des migrations avec contraintes
rails generate migration CreateUsers \
  email:string:uniq password_digest:string:null_false \
  first_name:string:null_false last_name:string:null_false \
  phone:string:encrypted member_number:string:index \
  email_verified_at:datetime remember_token:string \
  birthdate:date address:text \
  emergency_contact:string:encrypted emergency_phone:string:encrypted \
  medical_info:text:encrypted active:boolean

rails generate migration CreateRoles \
  name:string:uniq:null_false

rails generate migration CreateUserRoles \
  user:references:null_false role:references:null_false

rails generate migration CreateMemberships \
  user:references:null_false type:string:null_false \
  start_date:date:null_false end_date:date:null_false \
  reduced_price:boolean reduction_reason:string \
  metadata:jsonb

rails generate migration CreateSubscriptions \
  user:references:null_false type:string:null_false \
  start_date:date:null_false end_date:date \
  entries_count:integer entries_left:integer \
  status:string payment_status:string \
  auto_renewal:boolean metadata:jsonb

rails generate migration CreatePayments \
  user:references:null_false payable:references{polymorphic}:null_false \
  amount:decimal{10-2}:null_false donation_amount:decimal{10-2} \
  payment_method:string:null_false receipt_number:string:uniq:null_false \
  installment_number:integer recorded_by:references:null_false \
  metadata:jsonb

rails generate migration CreateReceipts \
  payment:references:null_false user:references:null_false \
  generated_by:references:null_false number:string:uniq:null_false \
  amount:decimal{10-2}:null_false date:datetime:null_false

rails generate migration CreateTrainingSessions \
  date:date:null_false start_time:time:null_false \
  end_time:time:null_false attendees_count:integer \
  status:string:null_false recorded_by:references:null_false \
  metadata:jsonb

rails generate migration CreateAttendances \
  user:references:null_false training_session:references:null_false \
  subscription:references:null_false membership:references:null_false \
  check_in:datetime:null_false recorded_by:references:null_false \
  metadata:jsonb

rails generate migration CreateDailyStats \
  date:date:uniq:null_false total_attendees:integer \
  basic_members:integer circus_members:integer \
  daily_passes:integer pack_entries:integer \
  trimester_entries:integer annual_entries:integer \
  total_payments:decimal{10-2} card_payments:decimal{10-2} \
  cash_payments:decimal{10-2} check_payments:decimal{10-2} \
  total_donations:decimal{10-2} new_memberships:integer \
  renewed_memberships:integer new_subscriptions:integer

rails generate migration CreateMonthlyStats \
  month:date:uniq:null_false \
  average_daily_attendance:decimal{5-2} \
  peak_day:date peak_attendance:integer \
  revenue_growth:decimal{5-2} \
  member_retention_rate:decimal{5-2}

rails generate migration CreateClosures \
  start_date:date:null_false end_date:date:null_false \
  reason:string:null_false description:text \
  recorded_by:references:null_false

rails generate migration CreateMemberNotes \
  user:references:null_false note_type:string \
  content:text:null_false recorded_by:references:null_false

rails generate migration CreateOpeningHours \
  day_of_week:integer:null_false start_time:time:null_false \
  end_time:time:null_false active:boolean \
  recorded_by:references:null_false

rails generate migration CreateScheduleExceptions \
  date:date:null_false original_start:time original_end:time \
  modified_start:time modified_end:time type:string:null_false \
  reason:string description:text recorded_by:references:null_false

# Ajout des contraintes et index
rails generate migration AddConstraintsAndIndexes

class AddConstraintsAndIndexes < ActiveRecord::Migration[8.0]
  def change
    # Index composites
    add_index :attendances, [:user_id, :training_session_id], unique: true
    add_index :user_roles, [:user_id, :role_id], unique: true
    add_index :memberships, [:user_id, :type, :end_date]
    add_index :subscriptions, [:user_id, :type, :end_date]
    add_index :payments, [:payable_type, :payable_id]
    add_index :training_sessions, [:date, :start_time]
    
    # Index pour les recherches fréquentes
    add_index :users, :member_number
    add_index :users, :active
    add_index :memberships, :status
    add_index :subscriptions, :status
    add_index :payments, :payment_method
    add_index :training_sessions, :status
    
    # Index pour les statistiques
    add_index :daily_stats, :date
    add_index :monthly_stats, :month
    add_index :closures, [:start_date, :end_date]
    add_index :schedule_exceptions, :date
  end
end

# Ajout des contraintes de vérification
rails generate migration AddCheckConstraints

class AddCheckConstraints < ActiveRecord::Migration[8.0]
  def change
    # Contraintes sur les dates
    add_check_constraint :memberships, "end_date > start_date", name: "membership_dates_check"
    add_check_constraint :subscriptions, "end_date > start_date", name: "subscription_dates_check"
    add_check_constraint :closures, "end_date >= start_date", name: "closure_dates_check"
    
    # Contraintes sur les montants
    add_check_constraint :payments, "amount >= 0", name: "payment_amount_check"
    add_check_constraint :payments, "donation_amount >= 0", name: "donation_amount_check"
    
    # Contraintes sur les compteurs
    add_check_constraint :subscriptions, "entries_count >= 0", name: "entries_count_check"
    add_check_constraint :subscriptions, "entries_left >= 0", name: "entries_left_check"
    
    # Contraintes sur les horaires
    add_check_constraint :opening_hours, "end_time > start_time", name: "opening_hours_check"
    add_check_constraint :opening_hours, "day_of_week BETWEEN 0 AND 6", name: "day_of_week_check"
    
    # Contraintes sur les statistiques
    add_check_constraint :daily_stats, "total_attendees >= 0", name: "total_attendees_check"
    add_check_constraint :daily_stats, "total_payments >= 0", name: "total_payments_check"
  end
end

# Configuration des clés étrangères
rails generate migration AddForeignKeyConstraints

class AddForeignKeyConstraints < ActiveRecord::Migration[8.0]
  def change
    # Clés étrangères avec suppression en cascade où nécessaire
    add_foreign_key :user_roles, :users, on_delete: :cascade
    add_foreign_key :user_roles, :roles
    
    add_foreign_key :memberships, :users
    add_foreign_key :subscriptions, :users
    
    add_foreign_key :payments, :users
    add_foreign_key :payments, :users, column: :recorded_by
    
    add_foreign_key :receipts, :payments
    add_foreign_key :receipts, :users
    add_foreign_key :receipts, :users, column: :generated_by
    
    add_foreign_key :attendances, :users
    add_foreign_key :attendances, :training_sessions
    add_foreign_key :attendances, :subscriptions
    add_foreign_key :attendances, :memberships
    add_foreign_key :attendances, :users, column: :recorded_by
    
    add_foreign_key :training_sessions, :users, column: :recorded_by
    
    add_foreign_key :member_notes, :users
    add_foreign_key :member_notes, :users, column: :recorded_by
    
    add_foreign_key :opening_hours, :users, column: :recorded_by
    add_foreign_key :schedule_exceptions, :users, column: :recorded_by
    add_foreign_key :closures, :users, column: :recorded_by
  end
end

# Génération des migrations
rails db:create
rails db:migrate
```

## 🔄 Phase 2 : Abonnements & Paiements

```bash
# Génération des modèles de paiement
rails generate model Subscription \
  user:references type:string start_date:date end_date:date \
  entries_count:integer entries_left:integer status:string \
  payment_status:string auto_renewal:boolean metadata:jsonb

rails generate model Payment \
  user:references payable:references{polymorphic} \
  amount:decimal{10-2} donation_amount:decimal{10-2} \
  payment_method:string receipt_number:string:uniq \
  installment_number:integer recorded_by:references \
  metadata:jsonb

rails generate model Receipt \
  payment:references user:references generated_by:references \
  number:string:uniq amount:decimal{10-2} date:datetime

# Configuration des jobs de paiement
rails generate job PaymentProcess
rails generate job ReceiptGeneration
rails generate job SubscriptionRenewal

# Configuration des mailers de paiement
rails generate mailer Payment confirmation receipt renewal_notice

# Configuration des controllers
rails generate controller Subscriptions index show new create edit update
rails generate controller Payments new create show
rails generate controller Receipts show download
rails generate controller Admin::Payments index show update
rails generate controller Admin::Subscriptions index show update

# Active Storage pour les reçus
rails generate migration AddReceiptAttachmentToPayments
```

## 📊 Phase 3 : Présence & Sessions

```bash
# Génération des modèles de présence
rails generate model TrainingSession \
  date:date start_time:time end_time:time \
  attendees_count:integer status:string \
  recorded_by:references metadata:jsonb

rails generate model Attendance \
  user:references training_session:references \
  subscription:references membership:references \
  check_in:datetime recorded_by:references \
  metadata:jsonb

rails generate model DailyStat \
  date:date:uniq total_attendees:integer \
  basic_members:integer circus_members:integer \
  daily_passes:integer pack_entries:integer \
  trimester_entries:integer annual_entries:integer \
  total_payments:decimal{10-2} card_payments:decimal{10-2} \
  cash_payments:decimal{10-2} check_payments:decimal{10-2} \
  total_donations:decimal{10-2} new_memberships:integer \
  renewed_memberships:integer new_subscriptions:integer

rails generate model MonthlyStat \
  month:date:uniq average_daily_attendance:decimal{5-2} \
  peak_day:date peak_attendance:integer \
  revenue_growth:decimal{5-2} member_retention_rate:decimal{5-2}

# Configuration des jobs de statistiques
rails generate job AttendanceNotification
rails generate job DailyStatsCalculation
rails generate job MonthlyStatsCalculation

# Configuration des controllers
rails generate controller TrainingSessions index show new create edit update
rails generate controller Attendances create update destroy
rails generate controller Calendar index show
rails generate controller Stats index daily monthly yearly
rails generate controller Admin::Stats index export
```

## 🎨 Configuration Frontend et UI

```bash
# Configuration de Stimulus
rails generate stimulus attendance_checker
rails generate stimulus payment_handler
rails generate stimulus calendar
rails generate stimulus chart
rails generate stimulus notification
rails generate stimulus search
rails generate stimulus form_validation

# Configuration des composants Tailwind
rails generate tailwindcss:component Button
rails generate tailwindcss:component Card
rails generate tailwindcss:component Alert
rails generate tailwindcss:component Modal
rails generate tailwindcss:component Table
rails generate tailwindcss:component Form
rails generate tailwindcss:component Navigation

# Configuration des vues avec Flowbite
rails generate component Navigation
rails generate component Dashboard
rails generate component Calendar
rails generate component Stats
rails generate component UserCard
rails generate component PaymentForm
rails generate component AttendanceList
```

## 🔧 Configuration Action Text et Active Storage

```bash
# Configuration d'Action Text
rails action_text:install

# Configuration des uploaders
rails generate uploader Document
rails generate uploader Avatar
rails generate uploader Receipt
rails generate uploader MedicalCertificate
rails generate uploader JustificationDocument

# Configuration des variants Active Storage
rails generate migration AddVariantsToActiveStorage
```

## 🧪 Configuration des Tests

```bash
# Installation de RSpec avec configuration complète
rails generate rspec:install

# Configuration des tests de modèles
rails generate rspec:model User
rails generate rspec:model Membership
rails generate rspec:model Subscription
rails generate rspec:model Payment
rails generate rspec:model TrainingSession
rails generate rspec:model Attendance
rails generate rspec:model DailyStat

# Configuration des tests de controllers
rails generate rspec:controller Auth::Sessions
rails generate rspec:controller Memberships
rails generate rspec:controller Payments
rails generate rspec:controller TrainingSessions

# Configuration des tests de fonctionnalités
rails generate rspec:feature Authentication
rails generate rspec:feature MembershipManagement
rails generate rspec:feature PaymentProcess
rails generate rspec:feature AttendanceTracking

# Configuration des factories
rails generate factory_bot:model User
rails generate factory_bot:model Membership
rails generate factory_bot:model Subscription
rails generate factory_bot:model Payment
rails generate factory_bot:model TrainingSession
rails generate factory_bot:model Attendance
rails generate factory_bot:model DailyStat
```

## 🔍 Commandes Utiles pour le Développement

```bash
# Démarrage des services
rails server
bundle exec sidekiq
redis-server

# Console Rails avec environnement
rails console
RAILS_ENV=test rails console

# Visualisation des routes
rails routes
rails routes | grep admin
rails routes | grep api

# Gestion de la base de données
rails db:drop db:create db:migrate db:seed
rails db:test:prepare
rails db:seed:replant  # Pour les seeds de développement

# Génération de la documentation
rails generate annotate:install
rails generate docs:app
```

## 📝 Commandes pour les Tests et la Qualité

```bash
# Exécution des tests avec options
rspec
rspec spec/models
rspec spec/controllers
rspec spec/features --format documentation

# Analyse de la couverture de tests
COVERAGE=true rspec

# Vérification de la qualité du code
rails zeitwerk:check
rails stats
bundle exec rubocop
bundle exec brakeman
```

## 🚀 Commandes de Déploiement et Maintenance

```bash
# Compilation des assets
rails assets:precompile
rails assets:clean

# Configuration de la production
rails credentials:edit
rails db:migrate RAILS_ENV=production

# Tâches de maintenance
rails db:sessions:trim  # Nettoyage des sessions
rails log:clear
rails tmp:clear
rails runner 'DailyStatsCalculation.perform_now'
```

## 📚 Documentation de Référence

- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [Rails 8 Authentication from Scratch](https://guides.rubyonrails.org/authentication.html)
- [Hotwire Documentation](https://hotwired.dev/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Flowbite Documentation](https://flowbite.com/docs/getting-started/introduction/)
- [Action Text Overview](https://guides.rubyonrails.org/action_text_overview.html)
- [Active Storage Overview](https://guides.rubyonrails.org/active_storage_overview.html)
- [Testing Rails Applications](https://guides.rubyonrails.org/testing.html)
- [Active Job Basics](https://guides.rubyonrails.org/active_job_basics.html)
- [Action Mailer Basics](https://guides.rubyonrails.org/action_mailer_basics.html)
- [Security Guide](https://guides.rubyonrails.org/security.html) 