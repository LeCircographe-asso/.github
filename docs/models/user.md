# User Model

## Méthodes

### Rôles et Permissions
```ruby
def member?
  roles.exists?(name: 'member')
end

def volunteer?
  roles.exists?(name: 'volunteer')
end

def admin?
  roles.exists?(name: 'admin')
end
```

### Adhésions
```ruby
def active_membership
  memberships.active.last
end

def membership_status
  active_membership.present? ? 'Actif' : 'Inactif'
end
```

### Présences
```ruby
def can_attend?(list)
  return false unless active_membership
  list.can_be_attended_by?(self)
end
```

## Callbacks

### Avant Création
```ruby
before_create :set_default_role
```

### Après Création
```ruby
after_create :send_welcome_email
``` 