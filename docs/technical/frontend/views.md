# Structure des Vues

## Layouts

### Application Layout
```erb
<%# app/views/layouts/application.html.erb %>
<!DOCTYPE html>
<html class="h-full bg-gray-100">
  <head>
    <title><%= content_for?(:title) ? yield(:title) : "Le Circographe" %></title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>
  </head>

  <body class="h-full">
    <%= render "shared/navbar" %>
    
    <main class="py-10">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <%= render "shared/flash" %>
        <%= yield %>
      </div>
    </main>
    
    <%= render "shared/footer" %>
  </body>
</html>
```

### Admin Layout
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

## Composants Partagés

### Flash Messages
```erb
<%# app/views/shared/_flash.html.erb %>
<% flash.each do |type, message| %>
  <div class="<%= flash_class(type) %> mb-4" 
       role="alert"
       data-controller="flash"
       data-flash-target="message">
    <div class="flex items-center">
      <%= flash_icon(type) %>
      <p class="ml-3"><%= message %></p>
    </div>
    <button data-action="flash#dismiss" class="ml-auto">
      <span class="sr-only">Fermer</span>
      <%= render "shared/icons/close" %>
    </button>
  </div>
<% end %>
```

### Pagination
```erb
<%# app/views/shared/_pagination.html.erb %>
<% if @pagy.pages > 1 %>
  <nav class="border-t border-gray-200 px-4 flex items-center justify-between sm:px-0">
    <%== pagy_nav(@pagy) %>
    <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
      <div>
        <p class="text-sm text-gray-700">
          Affichage de
          <span class="font-medium"><%= @pagy.from %></span>
          à
          <span class="font-medium"><%= @pagy.to %></span>
          sur
          <span class="font-medium"><%= @pagy.count %></span>
          résultats
        </p>
      </div>
    </div>
  </nav>
<% end %>
```

### Breadcrumbs
```erb
<%# app/views/shared/_breadcrumbs.html.erb %>
<nav class="flex" aria-label="Breadcrumb">
  <ol role="list" class="flex items-center space-x-4">
    <li>
      <div>
        <%= link_to root_path, class: "text-gray-400 hover:text-gray-500" do %>
          <%= render "shared/icons/home" %>
          <span class="sr-only">Accueil</span>
        <% end %>
      </div>
    </li>
    
    <% breadcrumbs.each do |crumb| %>
      <li>
        <div class="flex items-center">
          <%= render "shared/icons/chevron_right" %>
          <%= link_to crumb.title, 
              crumb.path,
              class: "ml-4 text-sm font-medium text-gray-500 hover:text-gray-700" %>
        </div>
      </li>
    <% end %>
  </ol>
</nav>
``` 