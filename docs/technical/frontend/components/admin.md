# Vues Admin

## Layout Admin

### Base Layout
```erb
<%# app/views/layouts/admin.html.erb %>
<!DOCTYPE html>
<html class="h-full bg-gray-100">
  <head>
    <title>Admin - <%= content_for?(:title) ? yield(:title) : "Le Circographe" %></title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application" %>
    <%= javascript_include_tag "application", defer: true %>
  </head>

  <body class="h-full">
    <div class="min-h-full">
      <%= render "admin/shared/navbar" %>
      <%= render "admin/shared/header" %>

      <main class="py-10">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
          <%= render "shared/flash" %>
          <%= yield %>
        </div>
      </main>
    </div>
  </body>
</html>
```

### Navigation Admin
```erb
<%# app/views/admin/shared/_navbar.html.erb %>
<nav class="bg-gray-800">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="flex items-center justify-between h-16">
      <div class="flex items-center">
        <div class="flex-shrink-0">
          <%= link_to admin_root_path, class: "text-white font-bold text-xl" do %>
            Le Circographe Admin
          <% end %>
        </div>
        
        <div class="hidden md:block">
          <div class="ml-10 flex items-baseline space-x-4">
            <%= link_to "Dashboard", admin_root_path, 
                class: active_link_class(admin_root_path, exact: true) %>
            <%= link_to "Utilisateurs", admin_users_path, 
                class: active_link_class(admin_users_path) %>
            <%= link_to "Statistiques", admin_stats_path, 
                class: active_link_class(admin_stats_path) %>
            <%= link_to "Paramètres", admin_settings_path, 
                class: active_link_class(admin_settings_path) %>
          </div>
        </div>
      </div>
    </div>
  </div>
</nav>
```

## Pages Admin

### Dashboard
```erb
<%# app/views/admin/dashboard/show.html.erb %>
<div class="bg-white shadow rounded-lg">
  <div class="px-4 py-5 sm:p-6">
    <h3 class="text-lg leading-6 font-medium text-gray-900">
      Vue d'ensemble
    </h3>
    
    <div class="mt-5 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
      <%= render "admin/shared/stat_card", 
          title: "Utilisateurs Actifs",
          value: @stats.active_users_count,
          change: @stats.users_change_percentage %>
          
      <%= render "admin/shared/stat_card", 
          title: "Revenus du Mois",
          value: number_to_currency(@stats.monthly_revenue),
          change: @stats.revenue_change_percentage %>
          
      <%= render "admin/shared/stat_card", 
          title: "Présences Aujourd'hui",
          value: @stats.daily_attendance_count,
          change: @stats.attendance_change_percentage %>
    </div>
  </div>
</div>

<div class="mt-8">
  <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">
    Activité Récente
  </h3>
  
  <%= render "admin/shared/activity_feed", activities: @recent_activities %>
</div>
```

### Gestion Utilisateurs
```erb
<%# app/views/admin/users/index.html.erb %>
<div class="bg-white shadow rounded-lg">
  <div class="px-4 py-5 sm:p-6">
    <div class="sm:flex sm:items-center">
      <div class="sm:flex-auto">
        <h1 class="text-xl font-semibold text-gray-900">Utilisateurs</h1>
      </div>
      <div class="mt-4 sm:mt-0 sm:ml-16 sm:flex-none">
        <%= link_to "Nouvel utilisateur", 
            new_admin_user_path,
            class: "btn-primary",
            data: { turbo_frame: "new_user" } %>
      </div>
    </div>

    <%= turbo_frame_tag "users_list" do %>
      <div class="mt-8 flex flex-col">
        <div class="-my-2 -mx-4 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
            <table class="min-w-full divide-y divide-gray-300">
              <thead>
                <tr>
                  <%= render "admin/shared/table_header", title: "Nom" %>
                  <%= render "admin/shared/table_header", title: "Email" %>
                  <%= render "admin/shared/table_header", title: "Statut" %>
                  <%= render "admin/shared/table_header", title: "Rôles" %>
                  <%= render "admin/shared/table_header", title: "Actions" %>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <%= render @users %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
      
      <div class="mt-4">
        <%= render "shared/pagination", pagy: @pagy %>
      </div>
    <% end %>
  </div>
</div> 

<div class="actions">
  <% if current_user.admin? %>
    <%= link_to "Modifier", edit_user_path(user), class: "btn-primary" %>
  <% end %>
  
  <% if current_user.volunteer? %>
    <%= link_to "Voir présences", user_attendances_path(user), class: "btn-secondary" %>
  <% end %>
</div> 