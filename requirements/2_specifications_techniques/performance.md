# ⚡ Performance et Optimisation - Le Circographe

<div align="right">
  <a href="./README.md">⬅️ Retour aux spécifications techniques</a> •
  <a href="../profile/README.md">📚 Documentation principale</a>
</div>

<p align="center"><i>🧭 Chemin: <a href="../profile/README.md">Documentation</a> > <a href="../README.md">Requirements</a> > <a href="./README.md">Spécifications Techniques</a> > <b>Performance et Optimisation</b></i></p>

## 📋 Vue d'ensemble

Ce document définit les stratégies et techniques d'optimisation de performance pour l'application Le Circographe, organisées par domaines métier et en conformité avec les meilleures pratiques de Rails 8.0.1.

## 🗄️ Optimisation des requêtes de base de données

### 1. Techniques N+1 et Eager Loading

Le problème N+1 est évité systématiquement grâce à l'utilisation de `includes`, `preload` et `eager_load` adaptés à chaque domaine métier :

```ruby
# ❌ Problème N+1 (à éviter)
# app/controllers/adhesion/adhesions_controller.rb
def index
  @adhesions = Adhesion::Adhesion.all
  # Chaque adhésion fera une requête pour user et type_adhesion
end

# ✅ Solution avec eager loading
# app/controllers/adhesion/adhesions_controller.rb
def index
  @adhesions = Adhesion::Adhesion.includes(:user, :type_adhesion)
  # Une seule requête pour les adhésions, users et types
end
```

### 2. Index de base de données optimisés

Les index sont stratégiquement définis pour chaque domaine métier :

```ruby
# app/db/migrate/YYYYMMDDHHMMSS_add_indexes_to_models.rb
class AddIndexesToModels < ActiveRecord::Migration[8.0]
  def change
    # Domaine Adhésion
    add_index :adhesions, [:user_id, :status]
    add_index :adhesions, [:date_debut, :date_fin]
    add_index :adhesions, :numero, unique: true
    
    # Domaine Cotisation
    add_index :souscriptions, [:adhesion_id, :status]
    add_index :souscriptions, [:formule_id, :date_fin]
    
    # Domaine Paiement
    add_index :paiements, [:paiementable_type, :paiementable_id]
    add_index :paiements, [:user_id, :created_at]
    
    # Domaine Présence
    add_index :presences, [:creneau_id, :date_pointage]
    add_index :presences, [:adhesion_id, :date_pointage]
    
    # Domaine Notification
    add_index :notifications, [:user_id, :status]
    add_index :notifications, [:categorie, :created_at]
  end
end
```

### 3. Bulk Operations

Les opérations en masse sont utilisées pour les actions sur plusieurs enregistrements :

```ruby
# ❌ Inefficace (à éviter)
adhesions.each do |adhesion|
  adhesion.update(status: 'active')
end

# ✅ Efficace
Adhesion::Adhesion.where(id: adhesion_ids).update_all(status: 'active')
```

## 🧠 Stratégies de mise en cache

### 1. Cache de fragment (Russian-Doll Caching)

Le cache en poupées russes est implémenté pour les vues complexes :

```erb
<%# app/views/adhesion/adhesions/index.html.erb %>
<% cache [current_user, 'adhesions_list', @adhesions.maximum(:updated_at)] do %>
  <h1>Liste des adhésions</h1>
  
  <div class="adhesions-list">
    <% @adhesions.each do |adhesion| %>
      <% cache adhesion do %>
        <%= render 'adhesion', adhesion: adhesion %>
      <% end %>
    <% end %>
  </div>
<% end %>
```

### 2. Caching des requêtes fréquentes

Les requêtes fréquentes sont mises en cache au niveau du modèle :

```ruby
# app/models/cotisation/formule.rb
module Cotisation
  class Formule < ApplicationRecord
    # ...
    
    # Cache des formules actives
    def self.actives_par_categorie
      Rails.cache.fetch("formules_actives_par_categorie", expires_in: 1.hour) do
        includes(:categorie)
          .where(active: true)
          .order(:categorie_id, :tarif)
          .group_by(&:categorie)
      end
    end
    
    # Invalidation automatique du cache
    after_save :invalider_cache
    after_destroy :invalider_cache
    
    private
    
    def invalider_cache
      Rails.cache.delete("formules_actives_par_categorie")
    end
  end
end
```

### 3. Cache HTTP avec ETags et Last-Modified

L'application utilise les en-têtes HTTP pour optimiser le trafic réseau :

```ruby
# app/controllers/adhesion/adhesions_controller.rb
def show
  @adhesion = Adhesion::Adhesion.find(params[:id])
  
  # Cache HTTP avec ETag
  fresh_when(@adhesion, 
             etag: [@adhesion, current_user&.id],
             last_modified: @adhesion.updated_at)
end
```

### 4. Configuration du cache en production

```ruby
# config/environments/production.rb
Rails.application.configure do
  # Cache store
  config.cache_store = :redis_cache_store, {
    url: ENV["REDIS_URL"],
    expires_in: 1.day,
    race_condition_ttl: 10.seconds
  }
  
  # Active Storage service
  config.active_storage.service = :local
  
  # Fragment caching
  config.action_controller.perform_caching = true
  config.action_controller.enable_fragment_cache_logging = false
  
  # Asset caching
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{30.days.to_i}"
  }
end
```

## 🖥️ Optimisations front-end

### 1. Turbo Drive et Frames

Turbo Drive est utilisé pour éviter les rechargements complets et améliorer la navigation :

```erb
<%# app/views/layouts/application.html.erb %>
<!DOCTYPE html>
<html>
  <head>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    
    <%= stylesheet_link_tag "application", media: "all", "data-turbo-track": "reload" %>
    <%= javascript_importmap_tags %>
  </head>
  <body>
    <div id="flash-messages">
      <%= render "layouts/flash" %>
    </div>
    
    <main>
      <%= yield %>
    </main>
  </body>
</html>
```

### 2. Lazy Loading d'images

Les images sont chargées à la demande lors du défilement :

```erb
<%# app/views/shared/_user_avatar.html.erb %>
<%= image_tag user.avatar.variant(:thumb),
             loading: "lazy",
             class: "user-avatar",
             alt: "Avatar de #{user.full_name}" %>
```

### 3. Debouncing des événements JavaScript

Les événements fréquents sont "debounced" pour éviter les surcharges :

```javascript
// app/javascript/controllers/search_controller.js
import { Controller } from "@hotwired/stimulus"
import { debounce } from "@rails/activestorage/src/helpers"

export default class extends Controller {
  static targets = ["input", "results"]
  
  connect() {
    this.debouncedSearch = debounce(this.search.bind(this), 300)
  }
  
  onInput(event) {
    this.debouncedSearch(event.target.value)
  }
  
  async search(query) {
    // Recherche via Turbo Stream
    const searchUrl = `${this.element.dataset.searchUrl}?query=${encodeURIComponent(query)}`
    const response = await fetch(searchUrl, { headers: { "Accept": "text/vnd.turbo-stream.html" } })
    const html = await response.text()
    
    this.resultsTarget.innerHTML = html
  }
}
```

### 4. Optimisation des images avec Active Storage variants

```ruby
# app/models/user.rb
class User < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100], format: :webp
    attachable.variant :medium, resize_to_fill: [300, 300], format: :webp
    attachable.variant :large, resize_to_fill: [600, 600], format: :webp
  end
end
```

## 🧮 Optimisations par domaine métier

### Domaine Adhésion

```ruby
# app/controllers/adhesion/adhesions_controller.rb
module Adhesion
  class AdhesionsController < ApplicationController
    # Optimisation des listes
    def index
      @adhesions = Adhesion.includes(:user, :type_adhesion)
                          .order(created_at: :desc)
                          .page(params[:page])
                          .per(25)
      
      respond_to do |format|
        format.html
        format.turbo_stream if turbo_frame_request?
        format.json { render json: @adhesions }
      end
    end
    
    # Optimisation de la recherche
    def search
      @adhesions = if params[:query].present?
                     Adhesion.includes(:user, :type_adhesion)
                             .search_by_term(params[:query])
                             .page(params[:page])
                             .per(25)
                   else
                     Adhesion.none
                   end
      
      render turbo_stream: turbo_stream.update("search_results", 
                                             partial: "search_results",
                                             locals: { adhesions: @adhesions })
    end
  end
end
```

### Domaine Cotisation

```ruby
# app/models/cotisation/souscription.rb
module Cotisation
  class Souscription < ApplicationRecord
    # Custom counter cache pour les statistiques
    after_create_commit :increment_counter_cache
    after_destroy_commit :decrement_counter_cache
    
    # Requêtes optimisées
    scope :actives_avec_details, -> {
      where(status: :active)
        .includes(:adhesion, :formule)
        .includes(adhesion: :user)
    }
    
    # Recalcul asynchrone via job
    after_save :schedule_stats_recalculation, if: :saved_change_to_status?
    
    private
    
    def increment_counter_cache
      Rails.cache.increment("stats:souscriptions:#{formule_id}:count")
    end
    
    def decrement_counter_cache
      Rails.cache.decrement("stats:souscriptions:#{formule_id}:count")
    end
    
    def schedule_stats_recalculation
      SouscriptionStatsJob.perform_later(formule_id)
    end
  end
end
```

### Domaine Paiement

```ruby
# app/models/paiement/paiement.rb
module Paiement
  class Paiement < ApplicationRecord
    # Utilisation de scope pour les requêtes communes
    scope :par_periode, ->(debut, fin) {
      where(created_at: debut..fin)
    }
    
    scope :avec_details, -> {
      includes(:user, :recu, paiementable: :type_adhesion)
    }
    
    # Statistiques avec groupage SQL
    def self.statistiques_mensuelles(annee)
      select("EXTRACT(MONTH FROM created_at) as mois, 
              SUM(montant) as total,
              COUNT(*) as nombre")
        .where("EXTRACT(YEAR FROM created_at) = ?", annee)
        .group("EXTRACT(MONTH FROM created_at)")
        .order("mois")
    end
  end
end
```

### Domaine Présence

```ruby
# app/controllers/presence/presences_controller.rb
module Presence
  class PresencesController < ApplicationController
    # Mise en cache des statistiques de présence
    def statistiques
      @date_debut = params[:date_debut] || Date.current.beginning_of_month
      @date_fin = params[:date_fin] || Date.current
      
      # Cache des statistiques avec clé basée sur les dates
      @statistiques = Rails.cache.fetch(["presence-stats", @date_debut, @date_fin], expires_in: 1.hour) do
        generer_statistiques(@date_debut, @date_fin)
      end
      
      respond_to do |format|
        format.html
        format.json { render json: @statistiques }
        format.csv { send_data statistiques_csv, filename: "presences-#{@date_debut}-#{@date_fin}.csv" }
      end
    end
    
    private
    
    def generer_statistiques(debut, fin)
      # Requête optimisée avec agrégation SQL
      Presence.joins(:creneau)
              .where(date_pointage: debut..fin)
              .group("creneaux.jour_semaine")
              .group("date_pointage")
              .count
              .transform_keys { |k| { jour: k[0], date: k[1] } }
    end
  end
end
```

### Domaine Notification

```ruby
# Optimisation de l'envoi de notifications en masse
module Notification
  class EnvoiMasseJob < ApplicationJob
    queue_as :notifications
    
    def perform(notification_ids)
      # Traitement par lot de 100
      Notification.where(id: notification_ids).find_in_batches(batch_size: 100) do |groupe|
        groupe.each do |notification|
          NotificationDeliveryJob.perform_later(notification.id)
        end
      end
    end
  end
  
  class NotificationDeliveryJob < ApplicationJob
    queue_as :notifications
    
    def perform(notification_id)
      notification = Notification.find_by(id: notification_id)
      return unless notification
      
      # Envoi optimisé selon le canal
      case notification.canal
      when 'email'
        NotificationMailer.send_notification(notification).deliver_now
      when 'sms'
        SmsService.new(notification).deliver
      when 'app'
        broadcast_notification(notification)
      end
      
      notification.update(envoyee_at: Time.current)
    end
    
    private
    
    def broadcast_notification(notification)
      Turbo::StreamsChannel.broadcast_append_to(
        "notifications:#{notification.user_id}",
        target: "notifications_list",
        partial: "notifications/notification",
        locals: { notification: notification }
      )
    end
  end
end
```

## 📈 Surveillance et analyse de performance

### 1. Métriques de performance

```ruby
# config/initializers/performance_metrics.rb
Rails.application.configure do
  # Surveillance des temps de réponse
  ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    controller = event.payload[:controller]
    action = event.payload[:action]
    status = event.payload[:status]
    duration = event.duration
    
    # Stockage des métriques (personnalisé selon l'implémentation)
    PerformanceMetric.record(
      controller: controller,
      action: action,
      status: status,
      duration: duration
    )
  end
end
```

### 2. Surveillance des requêtes lentes

```ruby
# Configuration pour tracer les requêtes SQL lentes
# config/initializers/slow_query_logger.rb
ActiveSupport::Notifications.subscribe "sql.active_record" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  duration = event.duration
  
  if duration > 200 # ms
    Rails.logger.warn("Requête SQL lente (#{duration.round}ms): #{event.payload[:sql]}")
    
    # En environnement de développement, stockage pour analyse
    if Rails.env.development?
      path = Rails.root.join("log/slow_queries.log")
      File.open(path, "a") do |f|
        f.puts "[#{Time.current}] #{duration.round}ms: #{event.payload[:sql]}"
        f.puts "Called from: #{caller[0..5].join("\n ")}"
        f.puts "\n"
      end
    end
  end
end
```

### 3. Profiling en développement

```ruby
# lib/tasks/performance.rake
namespace :performance do
  desc "Analyse de performance avec Rack Mini Profiler"
  task :profile_pages, [:url] => :environment do |t, args|
    url = args[:url] || "http://localhost:3000/"
    
    require 'rack-mini-profiler'
    profiler = Rack::MiniProfiler::PageTimerStruct.new({})
    
    # Chargement d'une page spécifique et analyse
    response = HTTParty.get(url)
    
    # Affichage des résultats
    puts "Analyse de #{url}"
    puts "Temps total: #{profiler.duration_ms}ms"
    puts "Requêtes SQL: #{profiler.sql_timings.count} (#{profiler.sql_timings_duration_ms}ms)"
    puts "Requêtes lentes:"
    
    profiler.sql_timings.select { |t| t[:duration_ms] > 50 }.each do |timing|
      puts "  - #{timing[:duration_ms]}ms: #{timing[:sql][0..100]}..."
    end
  end
end
```

### 4. Outils de monitoring

L'application est configurée pour utiliser des outils de monitoring standards :

- **New Relic** pour la surveillance des performances en production
- **Rack Mini Profiler** pour les analyses ponctuelles en développement
- **Bullet** pour détecter les problèmes N+1 en développement
- **Scout APM** pour le profilage de mémoire et CPU

```ruby
# Gemfile (développement)
group :development do
  gem 'bullet'
  gem 'rack-mini-profiler'
  gem 'memory_profiler'
end

# Gemfile (production)
group :production do
  gem 'scout_apm'
end
```

## 🚀 Stratégies d'optimisation avancées

### 1. Dénormalisation stratégique

La dénormalisation est utilisée stratégiquement pour les requêtes fréquentes :

```ruby
# app/models/adhesion/adhesion.rb
module Adhesion
  class Adhesion < ApplicationRecord
    # Champs dénormalisés pour éviter des jointures fréquentes
    before_save :update_denormalized_fields
    
    private
    
    def update_denormalized_fields
      if user_id_changed? || saved_change_to_user_id?
        self.user_name = user.full_name
        self.user_email = user.email
      end
      
      if type_adhesion_id_changed? || saved_change_to_type_adhesion_id?
        self.type_nom = type_adhesion.nom
        self.tarif = type_adhesion.tarif
      end
    end
  end
end

# Migration correspondante
class AddDenormalizedFields < ActiveRecord::Migration[8.0]
  def change
    add_column :adhesions, :user_name, :string
    add_column :adhesions, :user_email, :string
    add_column :adhesions, :type_nom, :string
    add_column :adhesions, :tarif, :decimal, precision: 8, scale: 2
    
    # Index sur les champs fréquemment recherchés
    add_index :adhesions, :user_name
    add_index :adhesions, :user_email
  end
end
```

### 2. Pagination et chargement incrémental

La pagination est utilisée pour toutes les listes :

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Helper de pagination commun
  def paginate(collection)
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 20).to_i
    
    # Limitation pour éviter les abus
    per_page = [per_page, 100].min
    
    collection.page(page).per(per_page)
  end
end

# Vue avec pagination et chargement incrémental
<%# app/views/shared/_pagination.html.erb %>
<div class="pagination" data-controller="infinite-scroll">
  <% if collection.next_page %>
    <%= link_to "Charger plus", 
                url_for(page: collection.next_page),
                class: "load-more",
                data: { 
                  action: "infinite-scroll#loadMore",
                  target: "infinite-scroll.nextPageLink" 
                } %>
  <% end %>
</div>

# Contrôleur Stimulus pour chargement infini
// app/javascript/controllers/infinite_scroll_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["nextPageLink", "items"]
  
  connect() {
    this.setupIntersectionObserver()
  }
  
  setupIntersectionObserver() {
    const options = { rootMargin: "200px" }
    
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.loadMore()
        }
      })
    }, options)
    
    if (this.hasNextPageLinkTarget) {
      this.observer.observe(this.nextPageLinkTarget)
    }
  }
  
  async loadMore() {
    const url = this.nextPageLinkTarget.href
    
    try {
      const response = await fetch(url, {
        headers: { "Accept": "text/vnd.turbo-stream.html" }
      })
      
      const html = await response.text()
      this.itemsTarget.insertAdjacentHTML("beforeend", html)
      
      // Mise à jour du lien pour la page suivante
      const parser = new DOMParser()
      const doc = parser.parseFromString(html, "text/html")
      const newLink = doc.querySelector(".load-more")
      
      if (newLink) {
        this.nextPageLinkTarget.href = newLink.href
      } else {
        this.nextPageLinkTarget.remove()
      }
    } catch (error) {
      console.error("Erreur de chargement:", error)
    }
  }
}
```

### 3. Compression et minification

```ruby
# config/environments/production.rb
Rails.application.configure do
  # Compression des réponses
  config.middleware.use Rack::Deflater
  
  # Minification CSS/JS
  config.assets.js_compressor = :terser
  config.assets.css_compressor = :csso
  
  # Compression des images
  config.active_storage.variable_content_types += [
    "image/webp", "image/avif"
  ]
  
  # Précompilation des assets
  config.assets.compile = false
  config.assets.precompile += %w( *.js *.css *.svg *.eot *.woff *.ttf )
end
```

### 4. Tâches d'arrière-plan

Les opérations lourdes sont déléguées à des tâches d'arrière-plan :

```ruby
# app/jobs/application_job.rb
class ApplicationJob < ActiveJob::Base
  # Configuration commune
  retry_on ActiveRecord::Deadlocked
  discard_on ActiveJob::DeserializationError
  
  # Files d'attente prioritaires
  queue_as do
    case self.class.name
    when /NotificationJob/, /AlertJob/
      :high_priority
    when /ReportJob/, /StatisticsJob/
      :low_priority
    else
      :default
    end
  end
  
  # Instrumentation
  around_perform do |job, block|
    start = Time.current
    block.call
    duration = Time.current - start
    
    Rails.logger.info("Job #{job.class.name} completed in #{duration.round(2)}s")
  end
end

# Exemple d'utilisation pour une fonctionnalité lourde
# app/controllers/paiement/rapports_controller.rb
module Paiement
  class RapportsController < ApplicationController
    def generate
      # Génération asynchrone
      job = RapportFinancierJob.perform_later(
        date_debut: params[:date_debut],
        date_fin: params[:date_fin],
        format: params[:format],
        user_id: current_user.id
      )
      
      respond_to do |format|
        format.html { redirect_to rapports_path, notice: "Génération du rapport en cours..." }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(
            "rapport_status",
            partial: "rapport_pending",
            locals: { job_id: job.job_id }
          )
        }
      end
    end
  end
end
```

## 🔧 Bonnes pratiques de développement

### 1. Guidelines de performance

- Toujours paginer les résultats des requêtes
- Utiliser systématiquement `includes` pour éviter les N+1
- Privilégier `where` avec condition sur `find_by` ou `find` dans les boucles
- Préférer `update_all` et `delete_all` pour les modifications en masse
- Minimiser les requêtes SQL dans les boucles
- Mettre en cache les résultats des requêtes fréquentes
- Surveiller la taille des réponses JSON
- Utiliser les counter caches pour les associations fréquemment comptées

### 2. Détection des problèmes N+1 en développement

```ruby
# config/environments/development.rb
Rails.application.configure do
  # Configuration de Bullet pour détecter les N+1
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
    Bullet.skip_html_injection = false
  end
end
```

---

<div align="center">
  <p>
    <a href="./README.md">⬅️ Retour aux spécifications techniques</a> | 
    <a href="#-performance-et-optimisation---le-circographe">⬆️ Haut de page</a>
  </p>
</div> 