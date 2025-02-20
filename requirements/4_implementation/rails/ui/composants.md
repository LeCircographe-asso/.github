# Guide d'Implémentation - Composants UI

## Configuration Flowbite Rails

```ruby
# Gemfile
gem 'flowbite-rails'
```

## Composants Partagés

### SearchBar Component
```ruby
# app/components/search_bar_component.rb
class SearchBarComponent < ViewComponent::Base
  def initialize(form_url:, placeholder: "Rechercher...")
    @form_url = form_url
    @placeholder = placeholder
  end

  private

  attr_reader :form_url, :placeholder
end
```

```erb
<%# app/components/search_bar_component.html.erb %>
<div class="flex items-center" data-controller="search">
  <%= form_with url: @form_url, method: :get, data: { turbo_frame: "results" } do |f| %>
    <div class="relative">
      <%= f.text_field :query,
          class: "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full pl-10 p-2.5",
          placeholder: @placeholder,
          data: { 
            action: "input->search#perform",
            search_target: "input" 
          } %>
      <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
        <svg class="w-4 h-4 text-gray-500" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 20">
          <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z"/>
        </svg>
      </div>
    </div>
  <% end %>
</div>
```

### MemberCard Component
```ruby
# app/components/member_card_component.rb
class MemberCardComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  def member_status_color
    case
    when @user.active_circus_membership? then "green"
    when @user.active_basic_membership? then "blue"
    else "gray"
    end
  end
end
```

```erb
<%# app/components/member_card_component.html.erb %>
<div class="max-w-sm p-6 bg-white border border-gray-200 rounded-lg shadow">
  <div class="flex items-center justify-between mb-4">
    <h5 class="text-xl font-bold text-gray-900">
      <%= @user.full_name %>
    </h5>
    <span class="bg-<%= member_status_color %>-100 text-<%= member_status_color %>-800 text-xs font-medium px-2.5 py-0.5 rounded">
      <%= @user.membership_status %>
    </span>
  </div>
  
  <div class="text-sm text-gray-500 mb-4">
    <p>N° Membre: <%= @user.member_number %></p>
    <p>Validité: <%= @user.membership_validity %></p>
  </div>

  <div class="flex gap-2">
    <%= link_to "Détails", user_path(@user), class: "text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5" %>
    <%= button_to "Présence", check_in_user_path(@user), class: "text-gray-900 bg-white border border-gray-300 hover:bg-gray-100 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5" if @user.can_check_in? %>
  </div>
</div>
```

### Flash Messages
```erb
<%# app/views/shared/_flash.html.erb %>
<% flash.each do |type, message| %>
  <div data-controller="flash" 
       data-flash-target="message"
       class="<%= flash_class(type) %> flex items-center p-4 mb-4 rounded-lg"
       role="alert">
    <%= message %>
    <button data-action="flash#dismiss" class="ml-auto">
      <svg class="w-4 h-4" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 14 14">
        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 6 6m0 0 6 6M7 7l6-6M7 7l-6 6"/>
      </svg>
    </button>
  </div>
<% end %>
``` 