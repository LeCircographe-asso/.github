# Politiques d'Autorisation

```ruby
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def member?
    user.member?
  end

  def volunteer?
    user.volunteer?
  end

  def admin?
    user.admin?
  end

  def super_admin?
    user.super_admin?
  end
end

class MembershipPolicy < ApplicationPolicy
  def create?
    volunteer? || admin? || super_admin?
  end
  
  def update?
    admin? || super_admin?
  end
  
  def destroy?
    super_admin?
  end
end

class UserPolicy < ApplicationPolicy
  def update?
    user == record || admin? || super_admin?
  end
  
  def manage_roles?
    return false unless admin? || super_admin?
    return true if super_admin?
    return false if record.super_admin?
    return false if record.admin? && !super_admin?
    true
  end
end

class SchedulePolicy < ApplicationPolicy
  def index?
    true  # Accessible à tous
  end
end

class EventPolicy < ApplicationPolicy
  def index?
    true  # Liste publique
  end

  def show?
    true  # Détails publics
  end

  def mark_interested?
    user.present?  # Nécessite uniquement d'être connecté
  end
end
``` 