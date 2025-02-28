# 🔐 Interface Administrateur - Le Circographe

<div align="right">
  <a href="../README.md">⬅️ Retour aux spécifications techniques</a> •
  <a href="../../../profile/README.md">📚 Documentation principale</a>
</div>

<p align="center"><i>🧭 Chemin: <a href="../../../profile/README.md">Documentation</a> > <a href="../../README.md">Requirements</a> > <a href="../README.md">Spécifications Techniques</a> > <a href="./README.md">Interfaces</a> > <b>Admin</b></i></p>

## 📋 Vue d'ensemble

L'interface administrateur de l'application Le Circographe est conçue selon les principes de Rails 8.0.1, en utilisant Hotwire (Turbo + Stimulus) et Tailwind CSS. Elle est organisée par domaines métier pour faciliter l'accès aux fonctionnalités.

## 🏛️ Architecture de l'interface

L'interface administrateur est structurée selon les principes modernes de Rails:

```
app/
├── controllers/
│   └── admin/
│       ├── base_controller.rb      # Contrôleur de base avec authentification
│       ├── adhesion_controller.rb  # Gestion des adhésions
│       ├── cotisation_controller.rb # Gestion des cotisations
│       └── ...
├── views/
│   └── admin/
│       ├── shared/                 # Composants partagés
│       │   ├── _sidebar.html.erb   # Menu latéral par domaine
│       │   └── _header.html.erb    # En-tête avec fil d'Ariane 
│       ├── adhesion/               # Vues par domaine
│       ├── cotisation/
│       └── ...
└── javascript/
    └── controllers/                # Contrôleurs Stimulus
        ├── admin/
        │   ├── search_controller.js
        │   ├── filter_controller.js
        │   └── ...
```

## 🧩 Organisation par domaines métier

### 1. Dashboard Général (Vue d'ensemble)

```ruby
# app/controllers/admin/dashboard_controller.rb
class Admin::DashboardController < Admin::BaseController
  def index
    @stats = {
      adhesions: {
        total: Adhesion.count,
        active: Adhesion.active.count,
        expiring_soon: Adhesion.expiring_within(30.days).count
      },
      cotisations: {
        total: Cotisation.count,
        monthly_revenue: Paiement.this_month.sum(:montant)
      },
      presences: {
        today: Presence.today.count,
        this_week: Presence.this_week.count
      }
    }
    
    @recent_activities = Activity.includes(:user).order(created_at: :desc).limit(10)
    @alerts = Alert.active.order(priority: :desc)
  end
end
```

Vue correspondante avec composants Turbo Streams pour mises à jour en temps réel.

### 2. Module Adhésion

- **Fonctionnalités**:
  - Gestion des membres (création, édition, désactivation)
  - Renouvellements d'adhésion
  - Tarifs réduits et justificatifs
  - Import/export des données

```erb
<%# app/views/admin/adhesion/index.html.erb %>
<div class="admin-container" data-controller="filter sort">
  <h1>Gestion des adhésions</h1>
  
  <div class="filters">
    <%= render "admin/shared/filters", 
              target: "adhesions",
              options: [:status, :type, :expiration] %>
  </div>
  
  <%= turbo_frame_tag "adhesions_list" do %>
    <div class="table-responsive">
      <table class="table">
        <thead>
          <tr>
            <th data-action="click->sort#toggle" data-sort-key="id">ID</th>
            <th data-action="click->sort#toggle" data-sort-key="nom">Nom</th>
            <th data-action="click->sort#toggle" data-sort-key="type">Type</th>
            <th data-action="click->sort#toggle" data-sort-key="expiration">Expiration</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <%= render partial: "adhesion", collection: @adhesions %>
        </tbody>
      </table>
    </div>
    
    <%= paginate @adhesions %>
  <% end %>
</div>
```

### 3. Module Cotisation

- **Fonctionnalités**:
  - Gestion des formules d'accès
  - Configuration des tarifs
  - Suivi des cotisations
  - Statistiques de conversion

### 4. Module Paiement

- **Fonctionnalités**:
  - Suivi des transactions financières
  - Rapports comptables
  - Gestion des reçus et factures
  - Exports pour la comptabilité

```ruby
# app/controllers/admin/paiement_controller.rb
class Admin::PaiementController < Admin::BaseController
  def reports
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_month
    @end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.today
    
    @paiements = Paiement.includes(:user, :paiementable)
                          .where(created_at: @start_date..@end_date)
                          .order(created_at: :desc)
                          
    @totals = {
      adhesions: @paiements.where(paiementable_type: "Adhesion").sum(:montant),
      cotisations: @paiements.where(paiementable_type: "Cotisation").sum(:montant),
      global: @paiements.sum(:montant)
    }
    
    respond_to do |format|
      format.html
      format.csv { send_data @paiements.to_csv, filename: "paiements-#{@start_date}-#{@end_date}.csv" }
      format.pdf { render pdf: "rapport-financier" }
    end
  end
end
```

### 5. Module Présence

- **Fonctionnalités**:
  - Gestion des créneaux et horaires
  - Suivi des présences par session
  - Statistiques de fréquentation
  - Gestion des exceptions et fermetures

### 6. Module Rôles

- **Fonctionnalités**:
  - Attribution des rôles système
  - Gestion des droits d'accès
  - Audit des actions par utilisateur
  - Sécurité et conformité

### 7. Module Notification

- **Fonctionnalités**:
  - Configuration des messages du système
  - Modèles d'e-mails
  - Notifications programmées
  - Historique des communications

## 🛠️ Composants techniques

### Interactions Turbo/Hotwire

```ruby
# Exemple de mise à jour en temps réel des statistiques
# app/controllers/admin/dashboard_controller.rb

def refresh_stats
  @stats = calculate_current_stats
  
  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: [
        turbo_stream.update("adhesion-stats", partial: "admin/dashboard/stats", locals: { domain: :adhesion, stats: @stats[:adhesion] }),
        turbo_stream.update("cotisation-stats", partial: "admin/dashboard/stats", locals: { domain: :cotisation, stats: @stats[:cotisation] })
      ]
    end
  end
end
```

### Accessibilité

Toutes les interfaces administratives respectent les normes WCAG 2.1 niveau AA:
- Contraste de couleurs adéquat
- Étiquettes pour les champs de formulaire
- Navigation au clavier
- États focalisables

### Sécurité

- Protection CSRF intégrée
- Mécanisme d'authentification à deux facteurs
- Journalisation des actions sensibles
- Délai d'inactivité avec déconnexion automatique

## 🔄 Intégration avec les domaines métier

| Domaine | Interface administrateur |
|---------|--------------------------|
| Adhésion | Gestion des membres, renouvellements, modifications |
| Cotisation | Configuration des formules, modification des tarifs |
| Paiement | Rapports financiers, historique des transactions |
| Présence | Gestion des créneaux, statistiques de fréquentation |
| Rôles | Attribution des accès, audit des actions |
| Notification | Templates, programmation des notifications |

## 📱 Responsive Design

L'interface administrateur est entièrement responsive pour permettre une gestion sur mobile:
- Layout fluide avec Tailwind CSS
- Tableaux adaptables sur petits écrans
- Menu latéral rétractable
- Actions prioritaires accessibles sur mobile

## 📆 Historique des mises à jour

- **28 février 2024** : Révision et mise à jour des liens
- **26 février 2024** : Création du document complet sur l'interface administrateur

---

<div align="center">
  <p>
    <a href="../README.md">⬅️ Retour aux spécifications techniques</a> | 
    <a href="#-interface-administrateur---le-circographe">⬆️ Haut de page</a>
  </p>
</div>