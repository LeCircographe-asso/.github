# Configuration Hotwire

## Installation

### Gems
```ruby
# Gemfile
gem "turbo-rails"
gem "stimulus-rails"
```

### JavaScript
```javascript
// app/javascript/application.js
import "@hotwired/turbo-rails"
import "./controllers"
```

## Turbo Frames

### Liste Paginée
```erb
<%# app/views/users/index.html.erb %>
<%= turbo_frame_tag "users_list" do %>
  <div class="users-grid">
    <%= render @users %>
  </div>
  
  <%== pagy_nav(@pagy, link_extra: 'data-turbo-frame="users_list"') %>
<% end %>
```

### Formulaire Dynamique
```erb
<%# app/views/memberships/new.html.erb %>
<%= turbo_frame_tag "new_membership" do %>
  <%= form_with(model: @membership, data: { controller: "membership-form" }) do |f| %>
    <div data-membership-form-target="fields">
      <%= render "form_fields", f: f %>
    </div>
    
    <%= f.submit "Créer", 
        class: "btn-primary",
        data: { action: "membership-form#submit" } %>
  <% end %>
<% end %>
```

## Stimulus Controllers

### Recherche en Direct
```javascript
// app/javascript/controllers/search_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "results" ]
  
  connect() {
    this.timeout = null
  }
  
  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.performSearch()
    }, 300)
  }
  
  async performSearch() {
    const query = this.inputTarget.value
    const response = await fetch(`/search?q=${query}`, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
    
    if (response.ok) {
      const html = await response.text()
      Turbo.renderStreamMessage(html)
    }
  }
}
```

### Gestion Formulaire
```javascript
// app/javascript/controllers/form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "submit", "spinner" ]
  
  connect() {
    this.submitting = false
  }
  
  async submit(event) {
    if (this.submitting) return
    
    this.submitting = true
    this.showSpinner()
    
    try {
      await this.submitForm(event)
    } catch (error) {
      console.error("Erreur soumission:", error)
    } finally {
      this.submitting = false
      this.hideSpinner()
    }
  }
  
  showSpinner() {
    this.spinnerTarget.classList.remove("hidden")
    this.submitTarget.disabled = true
  }
  
  hideSpinner() {
    this.spinnerTarget.classList.add("hidden")
    this.submitTarget.disabled = false
  }
}
``` 