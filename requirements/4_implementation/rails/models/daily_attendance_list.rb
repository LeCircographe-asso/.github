class DailyAttendanceList < ApplicationRecord
  # Enums
  enum status: {
    pending: 0,    # Liste créée mais pas encore active
    active: 1,     # Liste ouverte aux pointages
    closed: 2,     # Liste fermée, plus de pointage possible
    cancelled: 3   # Annulée (fermeture exceptionnelle)
  }

  enum list_type: {
    training: 0,   # Entraînement normal
    event: 1,      # Événement spécial
    meeting: 2     # Réunion
  }

  # Validations
  validates :date, presence: true
  validates :list_type, presence: true
  validate :validate_opening_status
  validate :validate_no_duplicate_list

  # Callbacks
  before_validation :check_holiday
  before_validation :check_exceptional_closing

  # Scopes
  scope :for_date, ->(date) { where(date: date) }
  scope :active_lists, -> { where(status: :active) }

  def can_be_attended_by?(user)
    return false unless active?
    return false if holiday? || exceptional_closing?
    
    case list_type
    when 'training'
      user.can_access_training?
    when 'event'
      user.member?
    when 'meeting'
      user.staff?
    end
  end

  private

  def validate_opening_status
    if should_be_closed?
      errors.add(:base, opening_status_error_message)
      return false
    end
    true
  end

  def should_be_closed?
    holiday? || exceptional_closing? || outside_opening_hours?
  end

  def opening_status_error_message
    return "Jour férié" if holiday?
    return "Fermeture exceptionnelle" if exceptional_closing?
    return "En dehors des horaires d'ouverture" if outside_opening_hours?
  end

  def check_holiday
    self.holiday = HolidayService.holiday?(date)
    self.status = :cancelled if holiday?
  end

  def check_exceptional_closing
    self.exceptional_closing = ClosingService.closed_on?(date)
    self.status = :cancelled if exceptional_closing?
  end

  def validate_no_duplicate_list
    return unless new_record?
    
    if DailyAttendanceList.for_date(date).where(list_type: list_type).exists?
      errors.add(:base, "Une liste de ce type existe déjà pour cette date")
    end
  end

  def outside_opening_hours?
    return false if event? || meeting? # Ces types n'ont pas d'horaires fixes
    
    schedule = OpeningHoursService.schedule_for(date)
    !schedule.open?
  end
end 