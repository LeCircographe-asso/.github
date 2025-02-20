# Interface Administrateur

## Dashboard Administratif

### 1. Vue d'Ensemble
- Statistiques temps réel
- Alertes système
- Actions en attente
- Rapports rapides

### 2. Gestion des Membres
```ruby
# Fonctionnalités
- Liste complète des membres
- Filtres avancés
- Export de données
- Actions groupées
```

### 3. Gestion Financière
- Suivi des paiements
- Gestion des dons
- Rapports financiers
- Exports comptables

## Outils Administratifs

### 1. Gestion des Rôles
- Attribution des rôles
- Révocation des accès
- Historique des modifications
- Audit des actions

### 2. Configuration Système
- Paramètres généraux
- Types d'adhésion/cotisation
- Tarifs et réductions
- Messages système

### 3. Reporting
- Statistiques détaillées
- Rapports personnalisés
- Exports automatisés
- Archivage des données

## Sécurité

### 1. Logs Système
- Journal des actions
- Alertes de sécurité
- Tentatives de connexion
- Modifications sensibles

### 2. Sauvegarde
- Backup automatique
- Restauration données
- Archives sécurisées
- Audit trail 

## Gestion des Horaires

### 1. Vue d'ensemble
- Tableau des horaires par jour
- Statut actif/inactif
- Capacité actuelle
- Exceptions à venir
- Statistiques de fréquentation

### 2. Gestion des Créneaux
- Création de nouveaux créneaux
  * Choix du jour
  * Définition horaires
  * Capacité maximale
  * Description
  * État (actif/inactif)
- Modification des créneaux existants
  * Ajustement des horaires
  * Modification de la capacité
  * Mise à jour description
- Désactivation temporaire
  * Conservation de l'historique
  * Possibilité de réactivation

### 3. Gestion des Exceptions
- Création d'exceptions
  * Date spécifique
  * Créneau concerné
  * Type (fermeture/modification)
  * Description pour les utilisateurs
- Types d'exceptions :
  * Fermeture exceptionnelle
  * Changement d'horaires
  * Modification de capacité
  * Événements spéciaux
- Gestion des récurrences
  * Exception unique
  * Série d'exceptions
  * Exceptions périodiques

### 4. Notifications
- Configuration des notifications
  * Changements d'horaires
  * Fermetures exceptionnelles
  * Événements spéciaux
- Canaux de communication
  * Email
  * Site web
  * Application mobile
- Destinataires
  * Tous les membres
  * Membres actifs uniquement
  * Membres avec réservation

### 5. Rapports et Statistiques
- Fréquentation par créneau
  * Moyenne de présence
  * Pics d'affluence
  * Tendances
- Analyse des exceptions
  * Impact sur la fréquentation
  * Statistiques annulation
- Export des données
  * Format CSV/Excel
  * Période personnalisable
  * Filtres avancés

## Interface de Gestion

### Actions Rapides
```ruby
# Composants Turbo Frames
- Modification rapide des horaires
- Ajout d'exception
- Changement de capacité
- Toggle actif/inactif
```

### Formulaires
```ruby
# Création/Modification de Créneau
form_with(model: @schedule) do |f|
  f.select :day_of_week, Schedule::DAYS_OF_WEEK
  f.time_field :start_time
  f.time_field :end_time
  f.number_field :capacity
  f.text_area :description
  f.check_box :active
end

# Création d'Exception
form_with(model: @schedule_exception) do |f|
  f.date_field :date
  f.text_field :description
  f.check_box :is_closed
  f.select :schedule_id, Schedule.all
end
```

### Tableaux de Bord
```ruby
# Vue Hebdomadaire
<div class="grid grid-cols-7 gap-4">
  <% Schedule::DAYS_OF_WEEK.each do |day| %>
    <div class="day-column">
      <h3><%= day.capitalize %></h3>
      <%= render @schedules.for_day(day) %>
    </div>
  <% end %>
</div>

# Liste des Exceptions
<div class="exceptions-list">
  <%= render partial: "exception",
             collection: @schedule_exceptions,
             locals: { admin: true } %>
</div>
```

### Composants Interactifs
```ruby
# Modification Instantanée
<%= turbo_frame_tag dom_id(schedule, :capacity) do %>
  <%= form_with(model: schedule, data: { controller: "auto-submit" }) do |f| %>
    <%= f.number_field :capacity,
                      data: { action: "change->auto-submit#submit" } %>
  <% end %>
<% end %>

# Toggle Statut
<%= button_to toggle_active_admin_schedule_path(schedule),
              method: :patch,
              class: "toggle-button",
              data: { turbo_frame: dom_id(schedule, :status) } do %>
  <%= schedule.active? ? "Désactiver" : "Activer" %>
<% end %> 