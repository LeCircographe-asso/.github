module Auditable
  extend ActiveSupport::Concern

  included do
    has_many :audit_logs, as: :auditable
    
    after_create :log_creation
    after_update :log_changes
    after_destroy :log_deletion
  end

  private

  def log_creation
    record_audit('create', changes: attributes)
  end

  def log_changes
    record_audit('update', changes: saved_changes) if saved_changes.any?
  end

  def log_deletion
    record_audit('delete', changes: attributes)
  end

  def record_audit(action, changes:)
    AuditLog.create!(
      action: action,
      auditable: self,
      user: Current.user,
      changes: changes,
      ip_address: Current.ip_address
    )
  end
end 