# Système de Rôles et Adhésions

## 1. Rôles Système (admin_role)
```ruby
enum role: {
  none: 0,        # User par défaut
  volunteer: 1,   # Bénévole
  admin: 2,       # Administrateur
  super_admin: 3  # Super Administrateur
}
```

### Permissions par Rôle
1. **Guest** (non connecté)
   - Consultation informations publiques
   - Création de compte

2. **User** (role: 0)
   - Gestion profil personnel
   - Consultation informations publiques
   - Newsletter (inscription/désinscription)
   - Pas de droits de gestion

3. **Volunteer** (role: 1)
   - Pointage des présences
   - Gestion des adhésions et cotisations (paiements)
   - Création listes exceptionnelles
   - Statistiques basiques (2 semaines)
   - Nécessite adhésion active

4. **Admin** (role: 2)
   - Gestion complète adhésions/cotisations
   - Validation tarifs réduits
   - Configuration système
   - Statistiques complètes
   - Gestion des bénévoles
   - Pas d'obligation d'adhésion

5. **Super Admin** (role: 3)
   - Toutes les permissions Admin
   - Gestion des administrateurs
   - Configuration système avancée
   - Accès aux logs système
   - Seul à pouvoir promouvoir des admins
   - Pas d'obligation d'adhésion

## 2. États d'Adhésion (membership)
```ruby
enum membership: {
  none: 0,    # Non adhérent
  basic: 1,   # Adhésion Basic
  circus: 2   # Adhésion Cirque
}
```

### Accès par Adhésion
1. **Non-Adhérent** (membership: 0)
   - Compte créé uniquement
   - Consultation informations publiques

2. **Basic** (membership: 1)
   - Coût : 1€/an
   - Accès événements
   - Newsletter et AG
   - Peut être ajouté aux listes de présence
   - Pas d'accès entraînements

3. **Cirque** (membership: 2)
   - Coût : 10€/7€ (tarif réduit)
   - Nécessite Basic valide
   - Peut être ajouté aux listes de présence
   - Accès entraînements (avec cotisation)
   - Historique personnel

## 3. Transitions et Validations

### Création Compte → Adhésion
1. Création compte (role: 0, membership: 0)
2. Vérification identité sur place
3. Paiement adhésion Basic (membership: 1)
4. Option adhésion Cirque (membership: 2)

### Attribution Rôle Volunteer
1. Nécessite adhésion active
2. Validation par Admin
3. Formation basique

### Attribution Rôle Admin
1. Validation par Super Admin uniquement
2. Formation complète requise
3. Pas d'obligation d'adhésion active

### Révocation/Suspension
- Possible par Admin uniquement (pour Volunteer)
- Possible par Super Admin uniquement (pour Admin)
- Conservation historique
- Notification automatique
- Possibilité réactivation

## 4. Validations Système
```ruby
class User < ApplicationRecord
  validates :role, presence: true
  validates :membership, presence: true
  
  validate :volunteer_requires_membership
  validate :admin_no_membership_required
  validate :circus_requires_basic
  validate :admin_promotion_by_super_admin_only
end
```