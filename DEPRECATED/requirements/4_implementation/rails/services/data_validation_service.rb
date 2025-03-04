class DataValidationService
  def self.validate_user_status(user)
    # Validation de cohérence
    errors = []

    # 1. Vérification adhésion de base
    if user.circus_membership? && !user.basic_membership?
      errors << "Adhésion cirque sans adhésion de base"
    end

    # 2. Vérification des dates
    user.memberships.active.each do |membership|
      if membership.start_date > membership.end_date
        errors << "Dates d'adhésion invalides pour #{membership.type}"
      end

      if membership.overlapping_memberships.exists?
        errors << "Chevauchement d'adhésions pour #{membership.type}"
      end
    end

    # 3. Vérification des abonnements
    user.subscriptions.active.each do |subscription|
      unless user.circus_membership?
        errors << "Abonnement actif sans adhésion cirque"
      end

      if subscription.sessions_remaining.negative?
        errors << "Nombre de séances négatif pour l'abonnement ##{subscription.id}"
      end
    end

    # 4. Vérification des présences
    user.attendances.today.each do |attendance|
      if attendance.duplicates.exists?
        errors << "Présence multiple pour la même session"
      end
    end

    # Retourne les erreurs trouvées
    errors
  end

  def self.fix_data_issues!(user)
    ActiveRecord::Base.transaction do
      # 1. Correction des adhésions
      fix_membership_issues!(user)
      
      # 2. Correction des abonnements
      fix_subscription_issues!(user)
      
      # 3. Correction des présences
      fix_attendance_issues!(user)

      # 4. Journal des corrections
      log_fixes(user)
    end
  end

  private

  def self.fix_membership_issues!(user)
    # Désactive les adhésions en doublon
    user.memberships.active.group_by(&:type).each do |type, memberships|
      if memberships.size > 1
        memberships[1..-1].each { |m| m.update!(status: :cancelled) }
      end
    end
  end

  def self.fix_subscription_issues!(user)
    # Désactive les abonnements sans adhésion valide
    unless user.circus_membership?
      user.subscriptions.active.update_all(status: :suspended)
    end

    # Corrige les nombres de séances négatifs
    user.subscriptions.where('sessions_remaining < 0')
        .update_all(sessions_remaining: 0)
  end

  def self.fix_attendance_issues!(user)
    # Supprime les doublons de présence
    user.attendances.today.group_by(&:daily_attendance_list_id).each do |_, attendances|
      if attendances.size > 1
        attendances[1..-1].each(&:destroy)
      end
    end
  end

  def self.log_fixes(user)
    DataFixLog.create!(
      user: user,
      fixed_at: Time.current,
      details: {
        memberships_fixed: user.memberships.where(status: :cancelled).count,
        subscriptions_fixed: user.subscriptions.where(status: :suspended).count,
        attendances_fixed: user.attendances.today.count
      }
    )
  end
end 