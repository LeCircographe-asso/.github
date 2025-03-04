# Composants Flowbite

## Installation et Configuration

### Installation
```ruby
# Gemfile
gem 'flowbite-rails'

# app/assets/stylesheets/application.tailwind.css
@import "flowbite";
```

### Configuration JavaScript
```javascript
// app/javascript/application.js
import "@flowbite/flowbite"
```

## Composants Principaux

### Navigation
```erb
<%# app/views/shared/_navbar.html.erb %>
<nav class="bg-white border-gray-200 px-2 sm:px-4 py-2.5 dark:bg-gray-900">
  <div class="container flex flex-wrap justify-between items-center mx-auto">
    <%= link_to root_path, class: "flex items-center" do %>
      <span class="self-center text-xl font-semibold whitespace-nowrap dark:text-white">
        Le Circographe
      </span>
    <% end %>
    
    <div class="hidden w-full md:block md:w-auto" id="navbar-default">
      <ul class="flex flex-col p-4 mt-4 bg-gray-50 rounded-lg border border-gray-100 md:flex-row md:space-x-8 md:mt-0 md:text-sm md:font-medium md:border-0 md:bg-white dark:bg-gray-800 md:dark:bg-gray-900 dark:border-gray-700">
        <%= render "shared/nav_items" %>
      </ul>
    </div>
  </div>
</nav>
```

### Formulaires
```erb
<%# app/views/memberships/_form.html.erb %>
<div class="mb-6">
  <%= form.label :type, class: "block mb-2 text-sm font-medium text-gray-900 dark:text-white" %>
  <%= form.select :type, 
      Membership.types_for_select,
      {},
      class: "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5" %>
</div>

<div class="flex items-start mb-6">
  <%= form.label :reduced_price, class: "flex items-center" do %>
    <%= form.check_box :reduced_price, 
        class: "w-4 h-4 bg-gray-50 rounded border border-gray-300 focus:ring-3 focus:ring-blue-300" %>
    <span class="ml-2 text-sm font-medium text-gray-900 dark:text-gray-300">
      Tarif réduit
    </span>
  <% end %>
</div>
```

### Tableaux
```erb
<%# app/views/admin/users/index.html.erb %>
<div class="relative overflow-x-auto shadow-md sm:rounded-lg">
  <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
    <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
      <tr>
        <th scope="col" class="px-6 py-3">Membre</th>
        <th scope="col" class="px-6 py-3">Email</th>
        <th scope="col" class="px-6 py-3">Statut</th>
        <th scope="col" class="px-6 py-3">Actions</th>
      </tr>
    </thead>
    <tbody>
      <%= render @users %>
    </tbody>
  </table>
</div>
```

### Modales
```erb
<%# app/views/shared/_modal.html.erb %>
<div id="<%= modal_id %>" 
     data-modal-backdrop="static" 
     tabindex="-1" 
     class="fixed top-0 left-0 right-0 z-50 hidden w-full p-4 overflow-x-hidden overflow-y-auto md:inset-0 h-[calc(100%-1rem)] max-h-full">
  <div class="relative w-full max-w-2xl max-h-full">
    <div class="relative bg-white rounded-lg shadow dark:bg-gray-700">
      <%= render "shared/modal_header" %>
      <div class="p-6 space-y-6">
        <%= yield %>
      </div>
      <%= render "shared/modal_footer" %>
    </div>
  </div>
</div>
``` 