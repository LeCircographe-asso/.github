class AttendanceService
  def self.check_in(user, list, recorded_by:)
    ActiveRecord::Base.transaction do
      # 1. Vérification Adhésion
      membership = user.active_membership
      raise MembershipError, "Adhésion invalide" unless membership&.valid?

      # 2. Vérification Abonnement si nécessaire
      if list.training? && user.has_subscription?
        subscription = user.active_subscription
        raise SubscriptionError, "Abonnement épuisé" unless subscription.can_use?
      end

      # 3. Création Présence
      attendance = list.attendances.create!(
        user: user,
        recorded_by: recorded_by,
        subscription: subscription
      )

      # 4. Mise à jour Abonnement
      subscription&.decrement_entries! if list.training?

      # 5. Notifications
      NotificationService.notify_if_needed(user, membership, subscription)

      attendance
    end
  end
end 