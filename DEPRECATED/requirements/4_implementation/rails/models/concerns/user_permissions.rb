module UserPermissions
  extend ActiveSupport::Concern

  included do
    # Définition des permissions par rôle
    ROLE_PERMISSIONS = {
      volunteer: %i[
        check_memberships
        record_attendance
        view_daily_stats
      ],
      admin: %i[
        manage_memberships
        manage_payments
        view_reports
      ],
      super_admin: :all
    }.freeze
  end

  def can?(action)
    return true if super_admin?
    return false unless role_permissions
    
    role_permissions.include?(action)
  end

  private

  def role_permissions
    ROLE_PERMISSIONS[role&.to_sym]
  end
end 