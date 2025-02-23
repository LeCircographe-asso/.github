# Implémentation du Système de Présence

## Modèles

### Liste de Présence
```ruby
class DailyAttendanceList < ApplicationRecord
  enum list_type: {
    training: 0,    # Entraînement quotidien
    event: 1,       # Événement spécial
    meeting: 2      # Réunion
  }

  has_many :attendances
  has_many :users, through: :attendances
  
  validates :date, presence: true
  validates :title, presence: true
  validates :list_type, presence: true
  
  # Une seule liste d'entraînement par jour
  validates :date, uniqueness: { 
    scope: :list_type,
    if: :training?
  }
end
```

### Présence Individuelle
```ruby
class Attendance < ApplicationRecord
  belongs_to :daily_attendance_list
  belongs_to :user
  
  validates :user_id, uniqueness: { 
    scope: :daily_attendance_list_id,
    message: "déjà présent sur cette liste"
  }
  
  before_save :check_membership
  after_save :deduct_session, if: :should_deduct_session?
  
  private
  
  def check_membership
    raise NotAuthorized unless user.member?
  end
  
  def should_deduct_session?
    daily_attendance_list.training? && 
    user.circus? &&
    user.has_session_pack?
  end
end
```

## Tâches Automatisées

### Création Liste Quotidienne
```ruby
class CreateDailyAttendanceListJob < ApplicationJob
  def perform
    return if Date.today.monday? # Fermé le lundi
    
    DailyAttendanceList.create!(
      date: Date.today,
      list_type: :training,
      title: "Entraînement #{I18n.l(Date.today, format: :long)}"
    )
  end
end
```

## Contrôleur Principal

```ruby
class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_volunteer_or_admin!
  
  def index
    @lists = DailyAttendanceList
      .includes(:attendances, :users)
      .where(date: Date.today)
  end
  
  def create
    @list = DailyAttendanceList.find(params[:list_id])
    @user = User.find_by_card_id(params[:card_id])
    
    @attendance = @list.attendances.build(user: @user)
    
    if @attendance.save
      render turbo_stream: [
        turbo_stream.append("attendances", @attendance),
        turbo_stream.update("flash", "Présence enregistrée")
      ]
    else
      render turbo_stream: turbo_stream.update(
        "flash",
        "Erreur : #{@attendance.errors.full_messages.join(", ")}"
      )
    end
  end
end
```

## Vues Turbo

### Liste des Présences
```erb
<%= turbo_frame_tag "attendance_lists" do %>
  <% @lists.each do |list| %>
    <div class="list-card" data-controller="attendance">
      <h3><%= list.title %></h3>
      
      <%= turbo_frame_tag "attendances_#{list.id}" do %>
        <%= render list.attendances %>
      <% end %>
      
      <%= form_with(model: Attendance.new, data: { turbo: true }) do |f| %>
        <%= f.text_field :card_id,
          data: { 
            action: "attendance#scan",
            attendance_target: "input"
          } %>
      <% end %>
    </div>
  <% end %>
<% end %>
```

## Stimulus Controller

```javascript
// attendance_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input" ]
  
  scan(event) {
    if (event.key === "Enter") {
      this.element.requestSubmit()
      this.inputTarget.value = ""
    }
  }
}
```

## Sécurité et Validation

### Middleware de Validation
```ruby
class AttendanceAuthorizationMiddleware
  def call(controller)
    return unless controller.current_user
    validate_attendance_permissions(controller)
  end
  
  private
  
  def validate_attendance_permissions(controller)
    unless controller.current_user.can_manage_attendance?
      raise NotAuthorized, "Accès non autorisé aux listes de présence"
    end
  end
end
```

### Politique de Sécurité
- Validation des permissions à chaque action
- Vérification des adhésions actives
- Protection contre les doublons
- Journalisation des modifications 