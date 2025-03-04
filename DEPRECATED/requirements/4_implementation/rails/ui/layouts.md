# Guide d'Implémentation - Layouts

## Layout Application

```erb
<%# app/views/layouts/application.html.erb %>
<!DOCTYPE html>
<html>
  <head>
    <title>Le Circographe</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>
  </head>

  <body class="min-h-screen bg-gray-50">
    <%= render "shared/navbar" %>
    
    <main class="container mx-auto px-4 py-8">
      <%= render "shared/flash" %>
      <%= yield %>
    </main>

    <%= render "shared/footer" %>
  </body>
</html>
```

## Layout Admin

```erb
<%# app/views/layouts/admin.html.erb %>
<!DOCTYPE html>
<html>
  <head>
    <title>Admin - Le Circographe</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>

    <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
    <%= javascript_include_tag "application", "data-turbo-track": "reload", defer: true %>
  </head>

  <body class="min-h-screen bg-gray-100">
    <div class="flex">
      <%= render "admin/shared/sidebar" %>
      
      <div class="flex-1">
        <%= render "admin/shared/header" %>
        
        <main class="p-8">
          <%= render "shared/flash" %>
          <%= yield %>
        </main>
      </div>
    </div>
  </body>
</html>
```

## Composants de Navigation

### Navbar
```erb
<%# app/views/shared/_navbar.html.erb %>
<nav class="bg-white border-gray-200 dark:bg-gray-900">
  <div class="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4">
    <%= link_to root_path, class: "flex items-center" do %>
      <%= image_tag "logo.png", class: "h-8 mr-3" %>
      <span class="self-center text-2xl font-semibold whitespace-nowrap dark:text-white">
        Le Circographe
      </span>
    <% end %>

    <div class="flex items-center md:order-2">
      <% if user_signed_in? %>
        <%= render "shared/user_menu" %>
      <% else %>
        <%= link_to "Connexion", new_user_session_path, class: "text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5" %>
      <% end %>
    </div>
  </div>
</nav>
```

### Sidebar Admin
```erb
<%# app/views/admin/shared/_sidebar.html.erb %>
<aside class="w-64 min-h-screen bg-gray-800" aria-label="Sidebar">
  <div class="px-3 py-4 overflow-y-auto">
    <ul class="space-y-2 font-medium">
      <li>
        <%= link_to admin_root_path, class: "flex items-center p-2 text-gray-900 rounded-lg dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700 group" do %>
          <svg class="w-5 h-5 text-gray-500 transition duration-75 dark:text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 22 21">
            <path d="M16.975 11H10V4.025a1 1 0 0 0-1.066-.998 8.5 8.5 0 1 0 9.039 9.039.999.999 0 0 0-1-1.066h.002Z"/>
            <path d="M12.5 0c-.157 0-.311.01-.565.027A1 1 0 0 0 11 1.02V10h8.975a1 1 0 0 0 1-.935c.013-.188.028-.374.028-.565A8.51 8.51 0 0 0 12.5 0Z"/>
          </svg>
          <span class="ml-3">Dashboard</span>
        <% end %>
      </li>
      <!-- Autres liens du menu -->
    </ul>
  </div>
</aside>
``` 