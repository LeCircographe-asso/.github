# 👷 Interface Bénévole - Le Circographe

<div align="right">
  <a href="../README.md">⬅️ Retour aux spécifications techniques</a> •
  <a href="../../../profile/README.md">📚 Documentation principale</a>
</div>

<p align="center"><i>🧭 Chemin: <a href="../../../profile/README.md">Documentation</a> > <a href="../../README.md">Requirements</a> > <a href="../README.md">Spécifications Techniques</a> > <a href="./README.md">Interfaces</a> > <b>Bénévole</b></i></p>

## 📋 Vue d'ensemble

L'interface bénévole de l'application Le Circographe est conçue pour les opérations quotidiennes de l'association. Elle offre un accès simplifié aux fonctionnalités essentielles pour l'accueil, la gestion des présences et le suivi des membres, tout en respectant la structure par domaines métier.

## 🏛️ Organisation de l'interface

L'interface bénévole est optimisée pour l'efficacité opérationnelle, avec une attention particulière à la facilité d'utilisation sur les tablettes utilisées à l'accueil:

```
app/views/
└── benevole/
    ├── dashboard/            # Vue d'ensemble
    ├── adhesion/             # Gestion des adhésions
    ├── cotisation/           # Vente de formules
    ├── paiement/             # Enregistrement des paiements
    ├── presence/             # Pointage des présences
    └── notification/         # Suivi des messages
```

## 🧩 Fonctionnalités par domaine métier

### 1. Dashboard Bénévole

```erb
<%# app/views/benevole/dashboard/index.html.erb %>
<div class="benevole-dashboard" data-controller="dashboard-refresh">
  <h1>Accueil Bénévole</h1>
  
  <%= turbo_frame_tag "quick_stats" do %>
    <div class="stats-grid">
      <div class="stat-card">
        <h3>Présences aujourd'hui</h3>
        <p class="stat-number"><%= @stats[:presences_today] %></p>
      </div>
      <div class="stat-card">
        <h3>Prochains arrivants</h3>
        <p class="stat-number"><%= @stats[:expected_arrivals] %></p>
      </div>
    </div>
  <% end %>
  
  <div class="action-buttons">
    <%= link_to "📝 Pointer une présence", new_benevole_presence_path, 
                class: "btn btn-primary btn-lg" %>
    <%= link_to "💳 Nouvelle vente", new_benevole_paiement_path, 
                class: "btn btn-secondary btn-lg" %>
  </div>
</div>
```

### 2. Module Adhésion

- **Fonctionnalités pour les bénévoles**:
  - Recherche d'adhérents
  - Consultation des informations d'adhésion
  - Vérification de la validité des adhésions
  - Validation des justificatifs pour tarifs réduits

```ruby
# app/controllers/benevole/adhesion_controller.rb
class Benevole::AdhesionController < Benevole::BaseController
  def search
    if params[:query].present?
      @adhesions = Adhesion.includes(:user)
                          .where("users.nom ILIKE ? OR users.prenom ILIKE ? OR users.email ILIKE ?", 
                                 "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%")
                          .references(:user)
    else
      @adhesions = Adhesion.none
    end
    
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update("search_results", 
                                  partial: "benevole/adhesion/search_results") }
    end
  end
  
  def validate_justificatif
    @adhesion = Adhesion.find(params[:id])
    @adhesion.update(justificatif_valide: true, 
                    validateur_id: current_user.id, 
                    date_validation: Time.current)
    
    redirect_to benevole_adhesion_path(@adhesion), notice: "Justificatif validé avec succès"
  end
end
```

### 3. Module Cotisation

- **Fonctionnalités pour les bénévoles**:
  - Consultation du catalogue des formules
  - Vente de formules aux adhérents
  - Vérification de la validité des formules
  - Renouvellement des formules expirées

### 4. Module Paiement

- **Fonctionnalités pour les bénévoles**:
  - Enregistrement des paiements (espèces, chèque, CB)
  - Impression des reçus
  - Consultation de l'historique des paiements
  - Génération de rapports journaliers

```erb
<%# app/views/benevole/paiement/new.html.erb %>
<div class="payment-form">
  <h1>Enregistrer un paiement</h1>
  
  <%= form_with(model: [:benevole, @paiement], data: { controller: "payment-form" }) do |f| %>
    <div class="form-group">
      <%= f.label :adhesion_id, "Adhérent" %>
      <%= f.select :adhesion_id, 
                  @adhesions.map { |a| ["#{a.user.nom} #{a.user.prenom} - #{a.numero}", a.id] },
                  { include_blank: "Sélectionner un adhérent" },
                  { data: { controller: "tom-select" } } %>
    </div>
    
    <div class="form-group">
      <%= f.label :paiementable_type, "Type d'achat" %>
      <%= f.select :paiementable_type, 
                  [["Adhésion", "Adhesion"], ["Cotisation", "Cotisation"]],
                  {},
                  { data: { action: "change->payment-form#toggleItems" } } %>
    </div>
    
    <div data-payment-form-target="itemsContainer">
      <!-- Affichage dynamique des items selon le type sélectionné -->
    </div>
    
    <div class="form-group">
      <%= f.label :mode_paiement, "Mode de paiement" %>
      <%= f.select :mode_paiement, Paiement::MODES_PAIEMENT %>
    </div>
    
    <div class="form-group">
      <%= f.label :montant, "Montant" %>
      <%= f.number_field :montant, step: 0.01, data: { payment_form_target: "amount" } %>
    </div>
    
    <div class="form-actions">
      <%= f.submit "Enregistrer le paiement", class: "btn btn-primary" %>
      <%= link_to "Annuler", benevole_dashboard_path, class: "btn btn-text" %>
    </div>
  <% end %>
</div>
```

### 5. Module Présence

- **Fonctionnalités pour les bénévoles**:
  - Pointage des présences (scan QR code ou recherche)
  - Gestion de la file d'attente
  - Suivi temps réel du nombre de présents
  - Consultation des créneaux et exceptions

```ruby
# app/controllers/benevole/presence_controller.rb
class Benevole::PresenceController < Benevole::BaseController
  def new
    @presence = Presence.new
    @creneaux_jour = Creneau.for_day(Date.today.wday)
                           .where("heure_debut <= ? AND heure_fin >= ?", 
                                 Time.current, Time.current)
  end
  
  def create
    @presence = Presence.new(presence_params)
    @presence.pointeur = current_user
    
    respond_to do |format|
      if @presence.save
        format.html { redirect_to benevole_presences_path, notice: "Présence enregistrée" }
        format.turbo_stream { 
          render turbo_stream: [
            turbo_stream.prepend("presences_list", partial: "presence", locals: { presence: @presence }),
            turbo_stream.update("presence_form", partial: "form", locals: { presence: Presence.new }),
            turbo_stream.update("current_count", 
                               html: "#{Presence.active.count}/#{@presence.creneau.capacite}")
          ]
        }
      else
        format.html { render :new }
        format.turbo_stream { 
          render turbo_stream: turbo_stream.update("presence_form", 
                                                 partial: "form", 
                                                 locals: { presence: @presence })
        }
      end
    end
  end
  
  def scan_qrcode
    qr_data = params[:qr_data]
    adhesion_id = extract_adhesion_id_from_qr(qr_data)
    @adhesion = Adhesion.find_by(id: adhesion_id)
    
    respond_to do |format|
      format.turbo_stream {
        if @adhesion&.active?
          render turbo_stream: turbo_stream.update("scan_result", 
                                                 partial: "adhesion_found", 
                                                 locals: { adhesion: @adhesion })
        else
          render turbo_stream: turbo_stream.update("scan_result", 
                                                 partial: "adhesion_invalid")
        end
      }
    end
  end
end
```

### 6. Module Notification

- **Fonctionnalités pour les bénévoles**:
  - Consultation des messages du système
  - Envoi de notifications aux adhérents présents
  - Suivi des communications importantes

## 🛠️ Technologies utilisées

- **Frontend**: Hotwire (Turbo + Stimulus) pour des interactions fluides
- **UI**: Interface adaptée aux tablettes, avec boutons larges et visibilité optimale
- **Performance**: Optimisations pour les opérations rapides à l'accueil
- **Accessibilité**: WCAG 2.1 niveau AA pour tous les composants

## 📱 Optimisations pour tablettes

L'interface bénévole est principalement utilisée sur tablettes à l'accueil:

- Boutons plus grands et espacés pour faciliter l'interaction tactile
- Organisation des éléments pour minimiser le défilement
- Regroupement des actions fréquentes en haut de l'écran
- Mode hors-ligne avec synchronisation ultérieure
- Gestion optimisée du scanner pour le pointage rapide

## 🔄 Flux opérationnels optimisés

### Flux d'accueil d'un adhérent

1. Scan du QR code ou recherche de l'adhérent
2. Vérification automatique de la validité de l'adhésion et des cotisations
3. Enregistrement de la présence en un clic
4. Affichage du récapitulatif avec photo de profil

### Flux de vente

1. Recherche de l'adhérent
2. Sélection de la formule à vendre
3. Choix du mode de paiement
4. Enregistrement et impression du reçu

## 🌐 Intégration avec le système

- Synchronisation en temps réel avec les modifications administrateur
- Alertes automatiques pour les problèmes critiques (capacité atteinte, etc.)
- Journal des opérations pour la traçabilité

---

<div align="center">
  <p>
    <a href="../README.md">⬅️ Retour aux spécifications techniques</a> | 
    <a href="#-interface-bénévole---le-circographe">⬆️ Haut de page</a>
  </p>
</div> 