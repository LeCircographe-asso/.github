# 🧩 Composants Partagés - Le Circographe

<div align="right">
  <a href="../README.md">⬅️ Retour aux spécifications techniques</a> •
  <a href="./README.md">⬅️ Retour aux interfaces</a> •
  <a href="../../../profile/README.md">📚 Documentation principale</a>
</div>

<p align="center"><i>🧭 Chemin: <a href="../../../profile/README.md">Documentation</a> > <a href="../../README.md">Requirements</a> > <a href="../README.md">Spécifications Techniques</a> > <a href="./README.md">Interfaces</a> > <b>Composants Partagés</b></i></p>

## 📋 Vue d'ensemble

Cette documentation détaille les composants d'interface réutilisables pour l'application Le Circographe. Ces composants sont conçus pour maintenir une expérience utilisateur cohérente à travers les interfaces administrateur, bénévole et publique, tout en respectant l'organisation par domaines métier.

## 🔄 Bibliothèque de composants

Les composants sont implémentés selon les principes de Rails 8.0.1 avec Hotwire et Stimulus, organisés hiérarchiquement :

```
app/
├── components/                      # Utilisation de ViewComponent
│   ├── application_component.rb     # Classe de base
│   ├── card_component.rb           
│   ├── data_table_component.rb     
│   ├── form/                        # Composants de formulaire
│   │   ├── input_component.rb
│   │   ├── select_component.rb
│   │   └── ...
│   ├── navigation/                  # Composants de navigation
│   │   ├── breadcrumb_component.rb
│   │   ├── menu_component.rb
│   │   └── ...
│   └── domains/                     # Composants spécifiques aux domaines
│       ├── adhesion/
│       ├── cotisation/
│       └── ...
└── views/
    └── components/                  # Templates des composants
        ├── card/
        ├── data_table/
        └── ...
```

## 🎨 Principes de conception

### Design System

Tous les composants suivent un design system cohérent qui inclut :

- **Palette de couleurs** : Couleurs primaires, secondaires et sémantiques (succès, alerte, erreur)
- **Typographie** : Hiérarchie de texte avec tailles et poids de police définis
- **Espacement** : Système d'espacement basé sur une unité de base (0.25rem)
- **Ombres** : 3 niveaux d'élévation standard
- **Coins arrondis** : 3 variantes (petit, moyen, large)

### Accessibilité

Tous les composants sont conformes aux standards WCAG 2.1 niveau AA :

- Contraste suffisant (minimum 4.5:1 pour texte normal)
- Support complet du clavier
- Textes alternatifs pour tous les éléments visuels
- Structure sémantique avec les balises HTML5 appropriées

## 📦 Catalogue des composants principaux

### Composants de navigation

#### 1. Breadcrumb (fil d'Ariane)

```erb
<%# Usage du composant %>
<%= render(Navigation::BreadcrumbComponent.new) do |b| %>
  <% b.item(text: "Accueil", path: root_path) %>
  <% b.item(text: "Adhésions", path: adhesions_path) %>
  <% b.item(text: "Détails", current: true) %>
<% end %>
```

#### 2. Menu latéral

```erb
<%= render(Navigation::SidebarComponent.new(active_section: :adhesion)) %>
```

### Composants de données

#### 1. DataTable (Tableau de données)

```erb
<%= render(DataTableComponent.new(collection: @adhesions, 
                               columns: [:id, :nom, :type, :expiration],
                               sortable: true,
                               filterable: true)) do |t| %>
  <% t.column(:actions) do |item| %>
    <%= link_to "Voir", item, class: "btn btn-sm" %>
  <% end %>
<% end %>
```

#### 2. Card (Carte)

```erb
<%= render(CardComponent.new(title: "Statistiques",
                           icon: "chart-bar",
                           collapsible: true)) do %>
  <div class="stats-content">
    <!-- Contenu de la carte -->
  </div>
<% end %>
```

### Composants de formulaire

#### 1. Champs de formulaire

```erb
<%= form_with model: @adhesion do |f| %>
  <%= render Form::InputComponent.new(
    form: f,
    name: :nom,
    label: "Nom",
    hint: "Nom de famille de l'adhérent",
    required: true
  ) %>
  
  <%= render Form::SelectComponent.new(
    form: f,
    name: :type_adhesion,
    label: "Type d'adhésion",
    collection: Adhesion::TYPES,
    include_blank: "Sélectionner..."
  ) %>
<% end %>
```

#### 2. Boutons d'action

```erb
<%= render Button::PrimaryComponent.new(text: "Enregistrer") %>
<%= render Button::SecondaryComponent.new(text: "Annuler", href: back_path) %>
```

## 🎭 Composants dynamiques avec Stimulus

### Modal (Fenêtre modale)

```erb
<%= render(ModalComponent.new(id: "confirmation-modal")) do |m| %>
  <% m.header do %>
    Confirmation
  <% end %>
  
  <% m.body do %>
    Êtes-vous sûr de vouloir effectuer cette action ?
  <% end %>
  
  <% m.footer do %>
    <%= render Button::DangerComponent.new(text: "Supprimer", 
                                         data: { action: "modal#confirm" }) %>
    <%= render Button::TextComponent.new(text: "Annuler", 
                                       data: { action: "modal#close" }) %>
  <% end %>
<% end %>
```

```javascript
// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]
  
  open() {
    this.dialogTarget.showModal()
  }
  
  close() {
    this.dialogTarget.close()
  }
  
  confirm() {
    // Traitement de la confirmation
    this.close()
  }
}
```

## 📱 Composants adaptatifs

Tous les composants sont conçus avec une approche mobile-first utilisant les classes Tailwind :

```erb
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
  <%= render CardComponent.new(title: "Adhésions") do %>
    <!-- Contenu de la carte -->
  <% end %>
</div>
```

## 🧠 État des composants

Les composants peuvent avoir plusieurs états :

- **Normal** : État par défaut
- **Hover** : Lorsque l'utilisateur survole l'élément
- **Focus** : Lorsque l'élément est sélectionné par clavier
- **Active** : Pendant une interaction (clic)
- **Disabled** : Lorsque l'interaction est désactivée
- **Loading** : Pendant le chargement des données

## 🔄 Intégration avec les domaines métier

Les composants sont adaptés aux besoins spécifiques des domaines métier :

| Domaine | Composants spécifiques |
|---------|------------------------|
| Adhésion | `AdhesionCardComponent`, `MembershipStatusBadgeComponent` |
| Cotisation | `FormuleCardComponent`, `SubscriptionProgressComponent` |
| Paiement | `PaymentMethodSelectionComponent`, `ReceiptComponent` |
| Présence | `AttendanceCheckinComponent`, `CapacityIndicatorComponent` |
| Rôles | `PermissionCheckboxComponent`, `RoleBadgeComponent` |
| Notification | `AlertComponent`, `NotificationCenterComponent` |

## 📋 Documentation du développeur

Chaque composant est documenté dans un format standardisé :

```ruby
# app/components/card_component.rb
class CardComponent < ApplicationComponent
  # == Props ==
  # @param title [String] Titre de la carte
  # @param icon [String] Nom de l'icône (FontAwesome)
  # @param variant [Symbol] :default, :primary, :success, :warning, :danger
  # @param collapsible [Boolean] Si la carte peut être repliée
  # @param footer [Boolean] Si un pied de carte doit être affiché
  def initialize(title:, icon: nil, variant: :default, collapsible: false, footer: false)
    @title = title
    @icon = icon
    @variant = variant
    @collapsible = collapsible
    @footer = footer
  end
end
```

---

<div align="center">
  <p>
    <a href="./README.md">⬅️ Retour aux interfaces</a> | 
    <a href="#-composants-partagés---le-circographe">⬆️ Haut de page</a>
  </p>
</div>

## Composants d'Interface

## Composants Partagés

### 1. Recherche Utilisateur
- Mise à jour en temps réel
- Suggestions intelligentes
- Affichage statut
- Actions contextuelles

### 2. Formulaires
- Validation instantanée
- Messages d'erreur clairs
- Auto-complétion
- Sauvegarde temporaire

### 3. Tableaux de Données
- Tri dynamique
- Filtrage avancé
- Pagination Turbo
- Actions en masse

### 4. Notifications
- Messages flash
- Alertes système
- Confirmations
- Erreurs

## Composants Spécifiques

### 1. Carte Membre
- Numéro unique
- Statut visuel (Basic/Cirque)
- Date de validité
- Informations essentielles

### 2. Pointage
- Recherche par numéro membre/email/nom/ prénom
- Validation rapide
- Confirmation visuelle
- Historique immédiat

### 3. Paiement
- Intégration SumUp
- Reçu automatique
- Confirmation visuelle
- Historique transaction 