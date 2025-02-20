class AttendanceService
  def self.check_in(user, list, recorded_by:)
    ActiveRecord::Base.transaction do
      # 1. Vérification de l'adhésion
      membership = user.active_membership
      raise MembershipError, "Adhésion invalide" unless membership&.valid?
      
      # Vérification expiration proche
      if membership.expires_soon?
        NotificationService.notify_expiration(user, membership)
      end

      # 2. Vérification de l'abonnement si nécessaire
      if list.training? && user.has_subscription?
        subscription = user.active_subscription
        raise SubscriptionError, "Abonnement épuisé" unless subscription.can_use?
        
        # Décompte automatique des séances
        subscription.decrement_entries!
        
        # Alerte si proche de la fin
        if subscription.low_entries?
          NotificationService.notify_low_entries(user, subscription)
        end
      end

      # 3. Création de la présence
      attendance = list.attendances.create!(
        user: user,
        recorded_by: recorded_by,
        subscription: subscription
      )

      # 4. Notifications si nécessaire
      NotificationService.notify_if_needed(user, membership, subscription)

      attendance
    end
  end
end 