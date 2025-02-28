# 🔒 Sécurité et Authentification - Le Circographe

<div align="right">
  <a href="./README.md">⬅️ Retour aux spécifications techniques</a> •
  <a href="../profile/README.md">📚 Documentation principale</a>
</div>

<p align="center"><i>🧭 Chemin: <a href="../profile/README.md">Documentation</a> > <a href="../README.md">Requirements</a> > <a href="./README.md">Spécifications Techniques</a> > <b>Sécurité et Authentification</b></i></p>

## 📋 Vue d'ensemble

Ce document définit les spécifications de sécurité et d'authentification pour l'application Le Circographe, organisées par domaines métier et en conformité avec les standards de Rails 8.0.1, sans dépendance à des gems tierces comme Devise.

## 🔐 Authentification native

### Implémentation avec Rails 8.0.1

L'application utilise le système d'authentification native de Rails 8.0.1 sans dépendance externe, basé sur `has_secure_password` :

```ruby
# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  
  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true
  
  # Associations
  belongs_to :role, class_name: 'Role::Role'
  has_many :sessions, dependent: :destroy
  
  # Callbacks
  before_save :downcase_email
  
  private
  
  def downcase_email
    self.email = email.downcase if email.present?
  end
end
```

```ruby
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
    # Page de connexion
  end
  
  def create
    user = User.find_by(email: params[:email].downcase)
    
    if user&.authenticate(params[:password])
      # Création de session avec token unique
      session = user.sessions.create!(
        user_agent: request.user_agent,
        ip_address: request.ip,
        expires_at: 2.weeks.from_now
      )
      
      # Stockage en cookie sécurisé
      cookies.encrypted[:session_token] = {
        value: session.token,
        expires: session.expires_at,
        httponly: true,
        secure: Rails.env.production?
      }
      
      # Journalisation de la connexion
      Role::AuditLog.create(
        user: user,
        action: 'login',
        resource_type: 'Session',
        ip_address: request.ip
      )
      
      redirect_to root_path, notice: "Connexion réussie"
    else
      flash.now[:alert] = "Email ou mot de passe incorrect"
      render :new, status: :unprocessable_entity
    end
  end
  
  def destroy
    # Déconnexion et invalidation du token
    if current_session
      current_session.update!(revoked_at: Time.current)
      Role::AuditLog.create(
        user: current_user,
        action: 'logout',
        resource_type: 'Session',
        ip_address: request.ip
      )
    end
    
    cookies.delete(:session_token)
    redirect_to root_path, notice: "Déconnexion réussie"
  end
end
```

### Récupération de mot de passe

Le système de récupération de mot de passe est implémenté comme suit :

```ruby
# app/controllers/password_resets_controller.rb
class PasswordResetsController < ApplicationController
  def new
    # Formulaire de demande de réinitialisation
  end
  
  def create
    user = User.find_by(email: params[:email].downcase)
    
    if user
      # Génération d'un token sécurisé à usage unique
      token = SecureRandom.urlsafe_base64(32)
      
      # Stockage du hachage du token avec expiration
      user.update!(
        reset_password_token: BCrypt::Password.create(token),
        reset_password_sent_at: Time.current
      )
      
      # Envoi de l'email
      UserMailer.password_reset(user, token).deliver_later
    end
    
    # Réponse identique que l'utilisateur existe ou non (sécurité)
    redirect_to root_path, notice: "Si votre email existe dans notre base, vous recevrez un lien de réinitialisation"
  end
  
  def edit
    @user = User.find_by(email: params[:email])
    @token = params[:token]
    
    unless valid_reset_token?(@user, @token)
      redirect_to new_password_reset_path, alert: "Ce lien de réinitialisation est invalide ou a expiré"
    end
  end
  
  def update
    @user = User.find_by(email: params[:email])
    @token = params[:token]
    
    if valid_reset_token?(@user, @token) && @user.update(password_params)
      # Invalidation du token après utilisation
      @user.update!(
        reset_password_token: nil,
        reset_password_sent_at: nil
      )
      
      # Révocation de toutes les sessions existantes
      @user.sessions.update_all(revoked_at: Time.current)
      
      redirect_to new_session_path, notice: "Votre mot de passe a été mis à jour avec succès"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  
  def valid_reset_token?(user, token)
    return false unless user && user.reset_password_token && user.reset_password_sent_at
    return false if user.reset_password_sent_at < 1.hour.ago
    
    BCrypt::Password.new(user.reset_password_token) == token
  end
end
```

## 🔑 Autorisation et contrôle d'accès

L'autorisation est gérée par un système de rôles et permissions défini dans le domaine métier "Rôles" :

### Système de permissions

```ruby
# app/models/role/permission.rb
module Role
  class Permission < ApplicationRecord
    # Relations
    belongs_to :role
    
    # Validations
    validates :action, :ressource, :domaine, presence: true
    validates :action, uniqueness: { scope: [:role_id, :ressource, :domaine] }
    
    # Actions standard
    ACTIONS = {
      index: 'lister',
      show: 'voir',
      create: 'créer',
      update: 'modifier',
      destroy: 'supprimer',
      approve: 'approuver',
      report: 'rapporter'
    }
    
    # Domaines standard (alignés sur les domaines métier)
    DOMAINES = %w[adhesion cotisation paiement presence roles notification]
  end
end
```

### Contrôleur de base avec autorisation

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :set_current_user
  
  # Protection CSRF
  protect_from_forgery with: :exception
  
  # Helpers d'autorisation disponibles dans les vues
  helper_method :current_user, :user_signed_in?, :authorized?
  
  private
  
  # Authentification
  def set_current_user
    return unless cookies.encrypted[:session_token]
    
    @current_session = Session.find_by(token: cookies.encrypted[:session_token])
    
    if @current_session && @current_session.valid_session?
      @current_user = @current_session.user
      # Mise à jour du timestamp pour prolonger la session
      @current_session.touch(:last_active_at)
    else
      cookies.delete(:session_token)
    end
  end
  
  def current_user
    @current_user
  end
  
  def current_session
    @current_session
  end
  
  def user_signed_in?
    !!current_user
  end
  
  # Autorisation
  def authorized?(action, ressource, domaine)
    return false unless user_signed_in?
    return true if current_user.role.admin?
    
    current_user.role.a_permission?(action, ressource, domaine)
  end
  
  def authorize!(action, ressource, domaine)
    unless authorized?(action, ressource, domaine)
      Role::AuditLog.create(
        user: current_user,
        action: "unauthorized_access",
        resource_type: ressource,
        resource_id: params[:id],
        ip_address: request.ip,
        details: "Tentative d'accès non autorisé: #{action} #{ressource} dans #{domaine}"
      )
      
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Vous n'êtes pas autorisé à effectuer cette action" }
        format.json { render json: { error: "Non autorisé" }, status: :forbidden }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "layouts/flash", locals: { alert: "Vous n'êtes pas autorisé à effectuer cette action" }) }
      end
    end
  end
  
  def authenticate_user!
    unless user_signed_in?
      store_location
      redirect_to new_session_path, alert: "Veuillez vous connecter pour accéder à cette page"
    end
  end
  
  def store_location
    session[:return_to] = request.fullpath if request.get?
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
end
```

### Contrôleur d'administration avec vérification de rôle

```ruby
# app/controllers/admin/base_controller.rb
module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin_or_benevole
    
    layout 'admin'
    
    private
    
    def require_admin_or_benevole
      unless current_user.role.nom.in?([Role::Role::ADMIN, Role::Role::BENEVOLE])
        redirect_to root_path, alert: "Accès réservé aux administrateurs et bénévoles"
      end
    end
  end
end
```

## 🔍 Journal d'audit et traçabilité

Le système maintient un journal complet de toutes les actions sensibles pour se conformer aux normes de sécurité :

```ruby
# app/models/role/audit_log.rb
module Role
  class AuditLog < ApplicationRecord
    # Relations
    belongs_to :user, optional: true
    
    # Validations
    validates :action, :resource_type, presence: true
    
    # Scopes
    scope :for_user, ->(user) { where(user: user) }
    scope :for_resource, ->(type, id = nil) { 
      if id
        where(resource_type: type, resource_id: id)
      else
        where(resource_type: type)
      end
    }
    scope :recent, -> { order(created_at: :desc).limit(100) }
    
    # Callbacks
    before_create :set_metadata
    
    private
    
    def set_metadata
      self.browser = user_agent.browser if user_agent.present?
      self.os = user_agent.platform if user_agent.present?
    end
  end
end
```

### Utilisation du journal d'audit

```ruby
# app/controllers/adhesion/adhesions_controller.rb
module Adhesion
  class AdhesionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_adhesion, only: [:show, :edit, :update, :destroy]
    before_action -> { authorize!(:update, "adhesion", "adhesion") }, only: [:edit, :update]
    
    def update
      if @adhesion.update(adhesion_params)
        # Journalisation de la modification
        Role::AuditLog.create(
          user: current_user,
          action: "update",
          resource_type: "Adhesion",
          resource_id: @adhesion.id,
          ip_address: request.ip,
          details: changes_description(@adhesion)
        )
        
        redirect_to @adhesion, notice: "Adhésion mise à jour avec succès"
      else
        render :edit
      end
    end
    
    private
    
    def changes_description(record)
      changes = record.previous_changes.except("updated_at")
      changes.map { |attr, (before, after)| "#{attr}: '#{before}' → '#{after}'" }.join(", ")
    end
    
    # Autres méthodes...
  end
end
```

## 🔐 Mesures de sécurité additionnelles

### Protection contre les attaques communes

1. **Protection CSRF**
   ```ruby
   # Déjà activée par défaut
   protect_from_forgery with: :exception
   ```

2. **Protection contre l'injection SQL**
   ```ruby
   # Bonne pratique (utiliser les méthodes ActiveRecord)
   User.where(role: 'admin')  # ✅ Sécurisé
   
   # À éviter absolument
   User.where("role = '#{role}'")  # ❌ Vulnérable à l'injection
   ```

3. **Protection XSS**
   ```erb
   <%# Échappement automatique dans ERB %>
   <%= user_input %>  <%# ✅ Sécurisé, échappé automatiquement %>
   
   <%# Dangereux, à utiliser uniquement pour du contenu de confiance %>
   <%= raw user_input %>  <%# ❌ Vulnérable au XSS %>
   ```

4. **Sanitisation du contenu HTML (Action Text)**
   ```ruby
   # config/initializers/action_text.rb
   Rails.application.config.action_text.sanitizer = ->(html) do
     Rails::HTML::SafeListSanitizer.new.sanitize(
       html,
       tags: %w(h1 h2 h3 h4 h5 h6 p blockquote pre strong em b i ul ol li),
       attributes: %w(href title class)
     )
   end
   ```

### Gestion des sessions

1. **Expiration des sessions**
   ```ruby
   # app/models/session.rb
   class Session < ApplicationRecord
     belongs_to :user
     
     before_create :set_token
     
     def valid_session?
       !revoked_at? && expires_at > Time.current
     end
     
     def expired?
       expires_at <= Time.current
     end
     
     private
     
     def set_token
       self.token = loop do
         random_token = SecureRandom.urlsafe_base64(32)
         break random_token unless Session.exists?(token: random_token)
       end
     end
   end
   ```

2. **Tâche de nettoyage des sessions expirées**
   ```ruby
   # app/jobs/cleanup_sessions_job.rb
   class CleanupSessionsJob < ApplicationJob
     queue_as :low
     
     def perform
       # Supprimer les sessions expirées
       Session.where('expires_at < ?', Time.current).delete_all
       
       # Supprimer les sessions inactives depuis plus de 2 semaines
       Session.where('last_active_at < ?', 2.weeks.ago).delete_all
     end
   end
   ```

### Limitation des tentatives de connexion

```ruby
# app/models/concerns/throttleable.rb
module Throttleable
  extend ActiveSupport::Concern
  
  included do
    def self.throttle(ip_address, max_attempts: 5, lock_time: 30.minutes)
      key = "login_attempts:#{ip_address}"
      count = Rails.cache.read(key).to_i
      
      if count >= max_attempts
        remaining_seconds = (Rails.cache.read("#{key}:locked_until").to_i - Time.current.to_i)
        return { throttled: true, remaining_seconds: remaining_seconds } if remaining_seconds > 0
        
        # Réinitialisation après la période de blocage
        Rails.cache.delete(key)
        Rails.cache.delete("#{key}:locked_until")
        count = 0
      end
      
      # Incrémenter le compteur
      Rails.cache.write(key, count + 1, expires_in: 1.hour)
      
      # Verrouiller si le maximum est atteint
      if count + 1 >= max_attempts
        locked_until = Time.current + lock_time
        Rails.cache.write("#{key}:locked_until", locked_until.to_i, expires_in: lock_time)
        return { throttled: true, remaining_seconds: lock_time.to_i }
      end
      
      { throttled: false, attempts: count + 1, max_attempts: max_attempts }
    end
    
    def self.reset_throttle(ip_address)
      Rails.cache.delete("login_attempts:#{ip_address}")
      Rails.cache.delete("login_attempts:#{ip_address}:locked_until")
    end
  end
end
```

Utilisation dans le contrôleur de sessions :

```ruby
# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  include Throttleable
  
  def create
    # Vérification du throttling
    throttle_result = self.class.throttle(request.ip)
    
    if throttle_result[:throttled]
      minutes = (throttle_result[:remaining_seconds] / 60.0).ceil
      flash.now[:alert] = "Trop de tentatives de connexion. Veuillez réessayer dans #{minutes} minute(s)."
      render :new, status: :too_many_requests
      return
    end
    
    user = User.find_by(email: params[:email].downcase)
    
    if user&.authenticate(params[:password])
      # Réinitialisation du compteur en cas de succès
      self.class.reset_throttle(request.ip)
      
      # Suite du processus de connexion...
    else
      flash.now[:alert] = "Email ou mot de passe incorrect"
      render :new, status: :unprocessable_entity
    end
  end
end
```

## 📜 Politique d'accès par domaine métier

### Domaine Adhésion

| Action | Admin | Bénévole | Adhérent |
|--------|-------|----------|----------|
| Créer  | ✅    | ✅       | ✅ (soi-même) |
| Voir   | ✅    | ✅       | ✅ (soi-même) |
| Lister | ✅    | ✅       | ❌       |
| Modifier | ✅  | ✅       | ❌       |
| Supprimer | ✅ | ❌       | ❌       |
| Renouveler | ✅ | ✅      | ✅ (soi-même) |

### Domaine Cotisation

| Action | Admin | Bénévole | Adhérent |
|--------|-------|----------|----------|
| Créer formule | ✅ | ❌    | ❌       |
| Voir formule  | ✅ | ✅     | ✅       |
| Souscrire     | ✅ | ✅     | ✅ (soi-même) |
| Modifier prix | ✅ | ❌     | ❌       |

### Domaine Paiement

| Action | Admin | Bénévole | Adhérent |
|--------|-------|----------|----------|
| Enregistrer | ✅ | ✅      | ❌       |
| Voir        | ✅ | ✅      | ✅ (soi-même) |
| Annuler     | ✅ | ❌      | ❌       |
| Rembourser  | ✅ | ❌      | ❌       |

### Domaine Présence

| Action | Admin | Bénévole | Adhérent |
|--------|-------|----------|----------|
| Pointer      | ✅ | ✅     | ✅ (soi-même) |
| Voir stats   | ✅ | ✅     | ✅ (soi-même) |
| Gérer créneau| ✅ | ❌     | ❌       |

### Domaine Rôles

| Action | Admin | Bénévole | Adhérent |
|--------|-------|----------|----------|
| Gérer rôles   | ✅ | ❌   | ❌       |
| Affecter rôle | ✅ | ❌   | ❌       |
| Voir journal  | ✅ | ✅ (partiel) | ❌  |

### Domaine Notification

| Action | Admin | Bénévole | Adhérent |
|--------|-------|----------|----------|
| Créer | ✅     | ✅ (limitée) | ❌     |
| Voir  | ✅     | ✅           | ✅ (soi-même) |
| Configurer | ✅ | ❌         | ✅ (soi-même) |

## 🔄 Intégration avec la gestion de données sensibles

### Protection des données personnelles (RGPD)

```ruby
# app/models/concerns/personal_data.rb
module PersonalData
  extend ActiveSupport::Concern
  
  included do
    # Attributs considérés comme données personnelles
    def self.personal_data_attributes(*attrs)
      @personal_data_attributes = attrs if attrs.any?
      @personal_data_attributes || []
    end
    
    # Export des données personnelles au format JSON pour le RGPD
    def export_personal_data
      attributes.slice(*self.class.personal_data_attributes)
    end
    
    # Anonymisation lors de la suppression d'un compte
    def anonymize!
      self.class.personal_data_attributes.each do |attr|
        case column_for_attribute(attr).type
        when :string, :text
          # Anonymisation des chaînes
          self[attr] = "ANONYMIZED-#{SecureRandom.hex(8)}"
        when :datetime, :date
          # Conservation des dates approximatives
          self[attr] = self[attr].beginning_of_month if self[attr]
        when :integer, :decimal, :float
          # Mise à zéro des valeurs numériques
          self[attr] = 0
        when :boolean
          # Conservation des booléens
        end
      end
      
      save(validate: false)
    end
  end
end

# Utilisation dans le modèle User
class User < ApplicationRecord
  include PersonalData
  
  personal_data_attributes :email, :first_name, :last_name, :phone, :address
  
  # Reste du modèle...
end
```

## 📆 Historique des mises à jour

- **28 février 2024** : Révision et mise à jour des liens
- **27 février 2024** : Création du document complet sur la sécurité et l'authentification

---

<div align="center">
  <p>
    <a href="./README.md">⬅️ Retour aux spécifications techniques</a> | 
    <a href="#-sécurité-et-authentification---le-circographe">⬆️ Haut de page</a>
  </p>
</div> 