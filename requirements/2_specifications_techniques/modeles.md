# 📊 Modèles de Données - Le Circographe

<div align="right">
  <a href="./README.md">⬅️ Retour aux spécifications techniques</a> •
  <a href="../profile/README.md">📚 Documentation principale</a>
</div>

<p align="center"><i>🧭 Chemin: <a href="../profile/README.md">Documentation</a> > <a href="../README.md">Requirements</a> > <a href="./README.md">Spécifications Techniques</a> > <b>Modèles de Données</b></i></p>

## 📋 Vue d'ensemble

Ce document définit les modèles de données principaux de l'application Le Circographe, organisés par domaines métier. La conception respecte les principes de Rails 8.0.1 et utilise ActiveRecord avec SQLite3.

## 🏗️ Architecture des modèles

L'application utilise une architecture basée sur les domaines métier, avec des modèles associés à chaque domaine :

```
app/models/
├── application_record.rb                    # Classe de base
├── concerns/                                # Modules partagés
│   ├── auditable.rb                         # Traçabilité des actions
│   ├── searchable.rb                        # Recherche texte
│   └── validable.rb                         # Validations communes
├── adhesion/                                # Domaine Adhésion
│   ├── adhesion.rb                          # Modèle principal
│   ├── adhesion_type.rb                     # Types d'adhésion
│   └── justificatif.rb                      # Justificatifs tarif réduit
├── cotisation/                              # Domaine Cotisation
│   ├── formule.rb                           # Modèle principal
│   ├── souscription.rb                      # Souscription à une formule
│   └── categorie.rb                         # Catégorie de formule
├── paiement/                                # Domaine Paiement
│   ├── paiement.rb                          # Modèle principal
│   ├── recu.rb                              # Reçu de paiement
│   └── remboursement.rb                     # Remboursement
├── presence/                                # Domaine Présence
│   ├── presence.rb                          # Modèle principal
│   ├── creneau.rb                           # Créneaux horaires
│   └── exception.rb                         # Exceptions (fermetures)
├── role/                                    # Domaine Rôles
│   ├── role.rb                              # Modèle principal
│   ├── permission.rb                        # Permissions spécifiques
│   └── audit_log.rb                         # Journal d'audit
└── notification/                            # Domaine Notification
    ├── notification.rb                      # Modèle principal
    ├── modele_email.rb                      # Templates d'emails
    └── preference.rb                        # Préférences utilisateur
```

## 🧩 Modèles par domaines métier

### Domaine Adhésion

#### Modèle Adhesion

```ruby
# app/models/adhesion/adhesion.rb
module Adhesion
  class Adhesion < ApplicationRecord
    # Relations
    belongs_to :user
    belongs_to :type_adhesion, class_name: 'Adhesion::AdhesionType'
    has_many :paiements, as: :paiementable, class_name: 'Paiement::Paiement'
    has_one_attached :justificatif
    has_many :souscriptions, class_name: 'Cotisation::Souscription'
    has_many :presences, class_name: 'Presence::Presence'
    
    # Énumération
    enum status: {
      pending: 0,    # En attente
      active: 1,     # Active
      expired: 2,    # Expirée
      cancelled: 3   # Annulée
    }
    
    # Validations
    validates :numero, presence: true, uniqueness: true
    validates :date_debut, :date_fin, presence: true
    validate :date_fin_after_date_debut
    
    # Callbacks
    before_validation :generate_numero, on: :create
    after_create :notify_new_adhesion
    
    # Scopes
    scope :active_on, ->(date) { where('date_debut <= ? AND date_fin >= ?', date, date) }
    scope :expiring_soon, -> { active.where('date_fin <= ?', 30.days.from_now) }
    
    # Méthodes
    def active?(date = Date.current)
      date_debut <= date && date_fin >= date
    end
    
    def periode
      "#{date_debut.strftime('%d/%m/%Y')} au #{date_fin.strftime('%d/%m/%Y')}"
    end
    
    def renouveler
      Adhesion.create(
        user: user,
        type_adhesion: type_adhesion,
        date_debut: [date_fin + 1.day, Date.current].max,
        date_fin: [date_fin + 1.year, Date.current + 1.year].max
      )
    end
    
    private
    
    def date_fin_after_date_debut
      return unless date_debut && date_fin
      errors.add(:date_fin, "doit être postérieure à la date de début") if date_fin <= date_debut
    end
    
    def generate_numero
      derniere = Adhesion.where(type_adhesion: type_adhesion)
                        .order(created_at: :desc)
                        .first
      
      prefix = type_adhesion.code
      year = Date.current.year.to_s[-2..-1]  # Derniers 2 chiffres de l'année
      
      last_num = derniere&.numero&.match(/(\d+)$/)&.[](1).to_i || 0
      self.numero = "#{prefix}#{year}-#{(last_num + 1).to_s.rjust(4, '0')}"
    end
    
    def notify_new_adhesion
      Notification::Notification.create(
        user: user,
        title: "Nouvelle adhésion #{type_adhesion.nom}",
        content: "Votre adhésion #{numero} est valable du #{periode}.",
        category: 'adhesion'
      )
    end
  end
end
```

#### Modèle AdhesionType

```ruby
# app/models/adhesion/adhesion_type.rb
module Adhesion
  class AdhesionType < ApplicationRecord
    # Relations
    has_many :adhesions
    
    # Validations
    validates :nom, :code, :tarif, presence: true
    validates :code, uniqueness: true, length: { is: 2 }
    
    # Types d'adhésion standard
    BASIC = 'BA'      # Adhésion Basic
    CIRQUE = 'CI'     # Adhésion Cirque
    
    # Méthodes
    def description_complete
      "#{nom} (#{tarif} €) - #{description}"
    end
  end
end
```

### Domaine Cotisation

#### Modèle Formule

```ruby
# app/models/cotisation/formule.rb
module Cotisation
  class Formule < ApplicationRecord
    # Relations
    belongs_to :categorie, class_name: 'Cotisation::Categorie'
    has_many :souscriptions
    
    # Validations
    validates :nom, :description, :tarif, :duree_jours, presence: true
    validates :tarif, numericality: { greater_than: 0 }
    
    # Scopes
    scope :actives, -> { where(active: true) }
    scope :par_categorie, ->(categorie) { where(categorie: categorie) }
    
    # Méthodes
    def duree_humaine
      case duree_jours
      when 30..31 then "1 mois"
      when 89..92 then "3 mois"
      when 180..183 then "6 mois" 
      when 364..366 then "1 an"
      else "#{duree_jours} jours"
      end
    end
    
    def details
      "#{nom} - #{duree_humaine} (#{tarif} €)"
    end
  end
end
```

#### Modèle Souscription

```ruby
# app/models/cotisation/souscription.rb
module Cotisation
  class Souscription < ApplicationRecord
    # Relations
    belongs_to :adhesion, class_name: 'Adhesion::Adhesion'
    belongs_to :formule
    has_many :paiements, as: :paiementable, class_name: 'Paiement::Paiement'
    has_many :presences, class_name: 'Presence::Presence'
    
    # Énumération
    enum status: {
      pending: 0,    # En attente de paiement
      active: 1,     # Active
      expired: 2,    # Expirée
      cancelled: 3   # Annulée
    }
    
    # Validations
    validates :date_debut, :date_fin, presence: true
    validates :sessions_restantes, presence: true, if: :formule_avec_sessions?
    
    # Callbacks
    before_validation :set_dates, on: :create
    after_create :notify_new_souscription
    
    # Scopes
    scope :actives, -> { where(status: :active) }
    scope :expirant_bientot, -> { actives.where('date_fin <= ?', 7.days.from_now) }
    
    # Méthodes
    def formule_avec_sessions?
      formule.sessions_total.present? && formule.sessions_total.positive?
    end
    
    def decrementer_sessions
      return unless formule_avec_sessions?
      
      if sessions_restantes > 0
        update(sessions_restantes: sessions_restantes - 1)
      else
        errors.add(:base, "Plus de sessions disponibles")
        throw(:abort)
      end
    end
    
    def active?(date = Date.current)
      status == 'active' && date_debut <= date && date_fin >= date
    end
    
    private
    
    def set_dates
      self.date_debut ||= Date.current
      self.date_fin ||= date_debut + formule.duree_jours.days
      self.sessions_restantes ||= formule.sessions_total if formule_avec_sessions?
    end
    
    def notify_new_souscription
      Notification::Notification.create(
        user: adhesion.user,
        title: "Nouvelle formule #{formule.nom}",
        content: "Votre formule est valable du #{date_debut.strftime('%d/%m/%Y')} au #{date_fin.strftime('%d/%m/%Y')}.",
        category: 'cotisation'
      )
    end
  end
end
```

### Domaine Paiement

#### Modèle Paiement

```ruby
# app/models/paiement/paiement.rb
module Paiement
  class Paiement < ApplicationRecord
    # Relations
    belongs_to :user
    belongs_to :paiementable, polymorphic: true
    has_one :recu, dependent: :destroy
    
    # Énumération
    enum mode_paiement: {
      especes: 0,
      cheque: 1,
      carte: 2,
      virement: 3
    }
    
    enum statut: {
      en_attente: 0,
      complete: 1,
      annule: 2,
      rembourse: 3
    }
    
    # Validations
    validates :montant, presence: true, numericality: { greater_than: 0 }
    validates :mode_paiement, presence: true
    validates :reference, uniqueness: true, allow_nil: true
    
    # Callbacks
    before_create :generer_reference
    after_create :generer_recu
    after_save :mettre_a_jour_paiementable, if: :saved_change_to_statut?
    
    # Scopes
    scope :du_jour, -> { where(created_at: Time.current.beginning_of_day..Time.current.end_of_day) }
    scope :du_mois, -> { where(created_at: Time.current.beginning_of_month..Time.current.end_of_month) }
    scope :par_type, ->(type) { where(paiementable_type: type) }
    
    # Méthodes
    def libelle
      case paiementable_type
      when 'Adhesion::Adhesion'
        "Adhésion #{paiementable.numero}"
      when 'Cotisation::Souscription'
        "Formule #{paiementable.formule.nom}"
      else
        "Paiement ##{id}"
      end
    end
    
    private
    
    def generer_reference
      loop do
        date = Date.current.strftime('%y%m%d')
        aleatoire = SecureRandom.alphanumeric(6).upcase
        self.reference = "P#{date}-#{aleatoire}"
        break unless Paiement.exists?(reference: reference)
      end
    end
    
    def generer_recu
      Recu.create(paiement: self, numero: "R-#{reference}")
    end
    
    def mettre_a_jour_paiementable
      if statut == 'complete' && paiementable.respond_to?(:activer)
        paiementable.activer
      elsif statut == 'annule' && paiementable.respond_to?(:annuler)
        paiementable.annuler
      end
    end
  end
end
```

### Domaine Présence

#### Modèle Presence

```ruby
# app/models/presence/presence.rb
module Presence
  class Presence < ApplicationRecord
    # Relations
    belongs_to :adhesion, class_name: 'Adhesion::Adhesion'
    belongs_to :souscription, class_name: 'Cotisation::Souscription', optional: true
    belongs_to :creneau
    belongs_to :pointeur, class_name: 'User', optional: true
    
    # Validations
    validates :date_pointage, presence: true
    validate :adhesion_active
    validate :souscription_valide, if: :souscription
    validate :creneau_disponible
    
    # Callbacks
    before_validation :set_date_pointage, on: :create
    after_create :decrementer_souscription
    
    # Scopes
    scope :du_jour, -> { where(date_pointage: Date.current) }
    scope :de_la_semaine, -> { where(date_pointage: Date.current.beginning_of_week..Date.current.end_of_week) }
    scope :par_creneau, ->(creneau) { where(creneau: creneau) }
    
    # Méthodes
    def auto_pointage?
      pointeur.nil?
    end
    
    private
    
    def set_date_pointage
      self.date_pointage ||= Date.current
    end
    
    def adhesion_active
      unless adhesion.active?(date_pointage)
        errors.add(:adhesion, "n'est pas active à la date du pointage")
      end
    end
    
    def souscription_valide
      unless souscription.active?(date_pointage)
        errors.add(:souscription, "n'est pas active à la date du pointage")
      end
      
      if souscription.formule_avec_sessions? && souscription.sessions_restantes <= 0
        errors.add(:souscription, "n'a plus de sessions disponibles")
      end
    end
    
    def creneau_disponible
      return unless creneau
      
      # Vérifier s'il y a une exception pour ce jour
      exception = Presence::Exception.find_by(
        date: date_pointage,
        creneau: creneau
      )
      
      if exception&.fermeture?
        errors.add(:creneau, "n'est pas disponible à cette date (fermeture exceptionnelle)")
        return
      end
      
      # Vérifier la capacité
      presences_count = Presence.where(creneau: creneau, date_pointage: date_pointage).count
      capacite = exception&.capacite_temporaire || creneau.capacite
      
      if presences_count >= capacite
        errors.add(:creneau, "a atteint sa capacité maximale")
      end
    end
    
    def decrementer_souscription
      souscription&.decrementer_sessions
    end
  end
end
```

### Domaine Rôles

#### Modèle Role

```ruby
# app/models/role/role.rb
module Role
  class Role < ApplicationRecord
    # Relations
    has_many :users
    has_many :permissions
    
    # Validations
    validates :nom, presence: true, uniqueness: true
    
    # Rôles prédéfinis
    ADMIN = 'admin'
    BENEVOLE = 'benevole'
    ADHERENT = 'adherent'
    
    # Méthodes
    def permissions_par_domaine
      permissions.group_by(&:domaine)
    end
    
    def a_permission?(action, ressource, domaine)
      permissions.exists?(
        action: action.to_s,
        ressource: ressource.to_s,
        domaine: domaine.to_s
      )
    end
    
    def admin?
      nom == ADMIN
    end
  end
end
```

### Domaine Notification

#### Modèle Notification

```ruby
# app/models/notification/notification.rb
module Notification
  class Notification < ApplicationRecord
    # Relations
    belongs_to :user
    
    # Énumération
    enum priorite: {
      basse: 0,
      normale: 1,
      haute: 2,
      critique: 3
    }, _default: :normale
    
    enum status: {
      non_lue: 0,
      lue: 1,
      archivee: 2
    }, _default: :non_lue
    
    # Validations
    validates :titre, :contenu, :categorie, presence: true
    
    # Scopes
    scope :actives, -> { where.not(status: :archivee) }
    scope :non_lues, -> { where(status: :non_lue) }
    scope :par_categorie, ->(categorie) { where(categorie: categorie) }
    
    # Callbacks
    after_create :envoyer_email, if: :email_requis?
    
    # Méthodes
    def marquer_comme_lue
      update(status: :lue, date_lecture: Time.current)
    end
    
    private
    
    def email_requis?
      priorite.in?(['haute', 'critique']) || 
      Notification::Preference.find_by(user: user, categorie: categorie)&.email
    end
    
    def envoyer_email
      # Envoi d'email via ActionMailer
    end
  end
end
```

## 🔄 Relations entre domaines

Le diagramme ci-dessous illustre les relations entre les principaux modèles des différents domaines :

```
┌────────────────┐         ┌────────────────┐         ┌────────────────┐
│    Adhésion    │         │   Cotisation   │         │    Paiement    │
├────────────────┤         ├────────────────┤         ├────────────────┤
│ Adhesion       │◄────────┤ Souscription   │         │ Paiement       │
│ AdhesionType   │         │ Formule        │         │ Recu           │
└───────┬────────┘         │ Categorie      │◄────────┤ Remboursement  │
        │                  └────────┬───────┘         └────────┬───────┘
        │                           │                          │
        │                           │                          │
        ▼                           ▼                          ▼
┌────────────────┐         ┌────────────────┐         ┌────────────────┐
│    Présence    │         │     Rôles      │         │  Notification  │
├────────────────┤         ├────────────────┤         ├────────────────┤
│ Presence       │         │ Role           │         │ Notification   │
│ Creneau        │         │ Permission     │         │ ModeleEmail    │
│ Exception      │         │ AuditLog       │         │ Preference     │
└────────────────┘         └────────────────┘         └────────────────┘
```

## 🛡️ Validations et contraintes d'intégrité

### Validations au niveau du modèle

- **Champs obligatoires** : Utilisation de `validates :field, presence: true`
- **Unicité** : Utilisation de `validates :field, uniqueness: true`  
- **Format** : Utilisation de `validates :field, format: { with: /regex/ }`
- **Numériques** : Utilisation de `validates :field, numericality: { greater_than: 0 }`
- **Personnalisées** : Méthodes `validate :custom_method`

### Contraintes au niveau de la base de données

```ruby
# Exemple de migration avec contraintes
class CreateAdhesions < ActiveRecord::Migration[8.0]
  def change
    create_table :adhesions do |t|
      t.string :numero, null: false, index: { unique: true }
      t.references :user, null: false, foreign_key: true
      t.references :type_adhesion, null: false, foreign_key: { to_table: :adhesion_types }
      t.date :date_debut, null: false
      t.date :date_fin, null: false
      t.integer :status, null: false, default: 0
      t.timestamps
    end
    
    # Index composites pour les recherches fréquentes
    add_index :adhesions, [:user_id, :status]
    add_index :adhesions, [:date_debut, :date_fin]
  end
end
```

## 🔍 Requêtes et performances

### Requêtes optimisées

```ruby
# Éviter les problèmes N+1
adhesions = Adhesion::Adhesion.includes(:user, :type_adhesion, :paiements)
                             .where(status: :active)
                             .order(date_fin: :asc)

# Utiliser des jointures pour filtrer
actifs_avec_formule = Adhesion::Adhesion.joins(souscriptions: :formule)
                                       .where(souscriptions: { status: :active })
                                       .where(formules: { nom: 'Premium' })
                                       .distinct

# Statistiques efficaces
stats = Presence::Presence.select("DATE_TRUNC('month', date_pointage) as mois, COUNT(*) as total")
                         .group("DATE_TRUNC('month', date_pointage)")
                         .order("mois DESC")
```

### Indexes stratégiques

Les index suivants sont définis pour optimiser les requêtes fréquentes :

- `adhesions.user_id` et `adhesions.type_adhesion_id`
- `adhesions.numero` (unique)
- `souscriptions.adhesion_id` et `souscriptions.formule_id`
- `paiements.user_id` et `paiements.reference` (unique)
- Index composite `presences.creneau_id, presences.date_pointage`
- Index composite `adhesions.date_debut, adhesions.date_fin, adhesions.status`

## 🔄 Callbacks et cycle de vie des objets

Les callbacks sont utilisés de manière judicieuse pour maintenir l'intégrité des données et automatiser certaines tâches :

- **before_validation** : Pour générer des identifiants uniques
- **after_create** : Pour créer des enregistrements associés
- **after_save** : Pour mettre à jour des objets liés
- **before_destroy** : Pour vérifier si une suppression est autorisée

## 📚 Documentation Ruby dans le code

Tous les modèles doivent inclure une documentation claire au format YARD :

```ruby
# app/models/adhesion/adhesion.rb

##
# Représente une adhésion à l'association.
#
# Une adhésion est la relation de base entre un utilisateur et l'association.
# Elle définit la période pendant laquelle l'utilisateur est considéré comme adhérent
# et permet l'accès aux différentes fonctionnalités selon son type.
#
# @attr [String] numero Numéro unique d'adhésion (format: XX23-0001)
# @attr [Date] date_debut Date de début de validité
# @attr [Date] date_fin Date de fin de validité
# @attr [Integer] status Statut de l'adhésion (enum)
#
class Adhesion < ApplicationRecord
  # ...
end
```

---

<div align="center">
  <p>
    <a href="./README.md">⬅️ Retour aux spécifications techniques</a> | 
    <a href="#-modèles-de-données---le-circographe">⬆️ Haut de page</a>
  </p>
</div> 