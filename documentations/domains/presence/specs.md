# Spécifications Techniques - Présence

## Identification du document

| Domaine           | Présence                            |
|-------------------|-------------------------------------|
| Version           | 1.0                                 |
| Référence         | SPEC-PRE-2024-01                    |
| Dernière révision | Mars 2024                           |

## Vue d'ensemble

Ce document définit les spécifications techniques pour le domaine "Présence" du système Circographe. Il décrit le modèle de données, les validations, les services et les implémentations techniques des règles de présence.

## Modèles de données

### Modèle `AttendanceList`

```ruby
class AttendanceList < ApplicationRecord
  # Enums
  enum list_type: {
    daily: 0,
    event: 1
  }

  enum status: {
    created: 0,
    open: 1,
    closed: 2,
    archived: 3
  }

  # Associations
  has_many :attendances, dependent: :destroy
  belongs_to :event, optional: true
  belongs_to :created_by, class_name: 'User'
  has_one :statistic, class_name: 'AttendanceStatistic', dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :date, presence: true, uniqueness: { scope: :list_type, if: :daily? }
  validates :capacity, numericality: { greater_than_or_equal_to: 0 }
  validates :requires_cirque, inclusion: { in: [true, false] }
  validates :requires_contribution, inclusion: { in: [true, false] }

  # Callbacks
  before_validation :set_default_name, on: :create
  after_create :create_statistics

  # Methods
  def open!
    return false unless created?
    update(
      status: :open,
      opened_at: Time.current
    )
  end

  def close!
    return false unless open?
    update(
      status: :closed,
      closed_at: Time.current
    )
    AttendanceStatisticsCalculationJob.perform_later(id)
  end

  def archive!
    return false unless closed?
    update(
      status: :archived,
      archived_at: Time.current
    )
  end

  def available_spots
    return Float::INFINITY if capacity.zero?
    capacity - attendances.count
  end

  def can_register?(user)
    return false unless open?
    return false if available_spots <= 0
    return false if requires_cirque && !user.has_valid_cirque_membership?
    return false if requires_contribution && !user.has_valid_contribution?
    true
  end

  private

  def set_default_name
    return if name.present?
    self.name = daily? ? "Liste du #{I18n.l(date, format: :long)}" : "Événement #{date}"
  end

  def create_statistics
    create_statistic!
  end
end
```

### Modèle `Attendance`

```ruby
class Attendance < ApplicationRecord
  # Associations
  belongs_to :attendance_list
  belongs_to :user
  belongs_to :contribution, optional: true
  belongs_to :recorded_by, class_name: 'User'

  # Validations
  validates :entry_time, presence: true
  validates :user_id, uniqueness: { scope: :attendance_list_id }
  validate :list_must_be_open
  validate :user_must_meet_requirements
  validate :exit_time_after_entry_time, if: :exit_time

  # Methods
  def duration_minutes
    return nil unless exit_time
    ((exit_time - entry_time) / 60).round
  end

  def record_exit!(exit_at = Time.current)
    update!(exit_time: exit_at)
  end

  private

  def list_must_be_open
    errors.add(:attendance_list, "must be open") unless attendance_list&.open?
  end

  def user_must_meet_requirements
    return unless attendance_list && user
    errors.add(:user, "does not meet requirements") unless attendance_list.can_register?(user)
  end

  def exit_time_after_entry_time
    return unless entry_time && exit_time
    errors.add(:exit_time, "must be after entry time") if exit_time <= entry_time
  end
end
```

### Modèle `AttendanceStatistic`

```ruby
class AttendanceStatistic < ApplicationRecord
  # Associations
  belongs_to :attendance_list

  # Validations
  validates :total_count, :unique_users_count, 
    numericality: { greater_than_or_equal_to: 0 }
  validates :peak_hour_count,
    numericality: { greater_than_or_equal_to: 0 }
  validates :calculated_at, presence: true

  # Methods
  def recalculate!
    calculate_totals
    calculate_peak_hours
    calculate_contribution_types
    save!
  end

  private

  def calculate_totals
    attendances = attendance_list.attendances
    self.total_count = attendances.count
    self.unique_users_count = attendances.select(:user_id).distinct.count
  end

  def calculate_peak_hours
    hours = attendance_list.attendances
      .group_by_hour(:entry_time)
      .count

    max_hour = hours.max_by { |_, count| count }
    return unless max_hour

    self.peak_hour = max_hour[0].strftime("%H:00")
    self.peak_hour_count = max_hour[1]
  end

  def calculate_contribution_types
    contributions = attendance_list.attendances
      .joins(:contribution)
      .group('contributions.type')
      .count

    self.annual_pass_count = contributions['AnnualPass'] || 0
    self.quarterly_pass_count = contributions['QuarterlyPass'] || 0
    self.session_card_count = contributions['SessionCard'] || 0
    self.day_pass_count = contributions['DayPass'] || 0
  end
end
```

## Services

### Service d'enregistrement des présences

```ruby
class AttendanceRegistrationService
  def initialize(attendance_list, user, recorded_by)
    @list = attendance_list
    @user = user
    @recorded_by = recorded_by
  end

  def register
    return false unless @list.can_register?(@user)

    ActiveRecord::Base.transaction do
      contribution = select_contribution
      create_attendance(contribution)
      deduct_entry(contribution) if contribution
    end
  rescue ActiveRecord::RecordInvalid => e
    false
  end

  private

  def select_contribution
    return nil unless @list.requires_contribution
    ContributionSelectionService.new(@user).select_for_entry
  end

  def create_attendance(contribution)
    Attendance.create!(
      attendance_list: @list,
      user: @user,
      contribution: contribution,
      recorded_by: @recorded_by,
      entry_time: Time.current
    )
  end

  def deduct_entry(contribution)
    ContributionUsageService.record_usage(contribution)
  end
end
```

## Jobs automatisés

```ruby
class AttendanceListOpeningJob < ApplicationJob
  queue_as :default

  def perform
    return unless CircographeConfig.open_today?

    AttendanceList.create!(
      list_type: :daily,
      date: Date.current,
      requires_cirque: true,
      requires_contribution: true,
      created_by: SystemUser.instance
    ).open!
  end
end

class AttendanceListClosingJob < ApplicationJob
  queue_as :default

  def perform
    AttendanceList.open.daily.find_each do |list|
      list.close!
    end
  end
end

class AttendanceStatisticsCalculationJob < ApplicationJob
  queue_as :default

  def perform(attendance_list_id)
    list = AttendanceList.find(attendance_list_id)
    list.statistic.recalculate!
  end
end
```

## Politiques d'accès

```ruby
class AttendanceListPolicy < ApplicationPolicy
  def index?
    user.admin? || user.volunteer?
  end

  def show?
    user.admin? || user.volunteer?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def open?
    user.admin? || user.volunteer?
  end

  def close?
    user.admin? || user.volunteer?
  end
end

class AttendancePolicy < ApplicationPolicy
  def index?
    user.admin? || user.volunteer?
  end

  def show?
    user.admin? || user.volunteer? || record.user_id == user.id
  end

  def create?
    user.admin? || user.volunteer?
  end

  def record_exit?
    user.admin? || user.volunteer?
  end

  def user_history?
    user.admin? || user.volunteer? || record.user_id == user.id
  end
end
```

## Points d'attention pour les développeurs

1. Les listes quotidiennes sont créées automatiquement via une tâche cron
2. La vérification des droits d'accès doit être effectuée à chaque tentative d'enregistrement
3. La priorité d'utilisation des cotisations est implémentée dans le service d'enregistrement
4. Les statistiques sont générées automatiquement à la clôture des listes
5. Les transitions d'état des listes doivent suivre l'ordre défini
6. Les données de présence sont sensibles et doivent être traitées avec précaution 