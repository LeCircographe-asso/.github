# Composants Partagés

## Composants de Base

### Card Component
```erb
<%# app/views/shared/components/_card.html.erb %>
<div class="<%= flowbite_card_class %>">
  <% if local_assigns[:header] %>
    <div class="px-4 py-5 border-b border-gray-200 sm:px-6">
      <%= header %>
    </div>
  <% end %>

  <div class="px-4 py-5 sm:p-6">
    <%= content %>
  </div>

  <% if local_assigns[:footer] %>
    <div class="px-4 py-4 border-t border-gray-200 sm:px-6">
      <%= footer %>
    </div>
  <% end %>
</div>
```

### Modal Component
```erb
<%# app/views/shared/components/_modal.html.erb %>
<div id="<%= modal_id %>"
     data-controller="modal"
     data-modal-target="container"
     class="hidden fixed z-10 inset-0 overflow-y-auto"
     aria-labelledby="modal-title"
     role="dialog"
     aria-modal="true">
  <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
         data-modal-target="overlay"
         data-action="click->modal#close"></div>

    <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
      <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
        <%= content %>
      </div>
    </div>
  </div>
</div>
```

## Formulaires

### Form Builder
```ruby
# app/helpers/form_helper.rb
module FormHelper
  def circographe_form_with(**options, &block)
    options[:builder] = CircographeFormBuilder
    form_with(**options, &block)
  end
end

class CircographeFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    form_group(method, options) do
      super(method, default_field_options.merge(options))
    end
  end

  def email_field(method, options = {})
    form_group(method, options) do
      super(method, default_field_options.merge(options))
    end
  end

  private

  def form_group(method, options, &block)
    @template.content_tag(:div, class: "form-group") do
      label = label(method, options.delete(:label)) if options[:label] != false
      error = object.errors[method].first if object.errors[method].present?
      
      @template.safe_join([
        label,
        yield,
        error_tag(error)
      ].compact)
    end
  end

  def error_tag(error)
    return unless error
    @template.content_tag(:p, error, class: "mt-2 text-sm text-red-600")
  end

  def default_field_options
    {
      class: "mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
    }
  end
end
```

### Formulaire d'Adhésion
```erb
<%# app/views/memberships/_form.html.erb %>
<%= circographe_form_with(model: @membership, data: { controller: "membership-form" }) do |f| %>
  <div class="space-y-6">
    <%= f.text_field :name, 
        label: "Nom complet",
        placeholder: "Jean Dupont",
        required: true %>

    <%= f.email_field :email,
        label: "Email",
        placeholder: "jean@example.com",
        required: true %>

    <%= f.select :type,
        Membership::TYPES,
        { label: "Type d'adhésion" },
        { class: "select-input" } %>

    <div class="flex items-start">
      <%= f.check_box :reduced_price,
          label: "Tarif réduit",
          data: { 
            action: "change->membership-form#toggleJustification",
            membership_form_target: "reducedPrice"
          } %>
    </div>

    <div data-membership-form-target="justificationField" class="hidden">
      <%= f.file_field :justification,
          label: "Justificatif",
          accept: "image/*,.pdf",
          direct_upload: true %>
    </div>

    <div class="flex justify-end space-x-3">
      <%= link_to "Annuler",
          root_path,
          class: "btn-secondary" %>

      <%= f.submit "Créer l'adhésion",
          class: "btn-primary",
          data: { disable_with: "Création..." } %>
    </div>
  </div>
<% end %>
```

### Formulaire de Paiement
```erb
<%# app/views/payments/_form.html.erb %>
<%= circographe_form_with(model: @payment, data: { controller: "payment-form" }) do |f| %>
  <%= f.hidden_field :payable_type %>
  <%= f.hidden_field :payable_id %>

  <div class="space-y-4">
    <div class="flex justify-between items-center">
      <span class="text-gray-700">Montant à payer</span>
      <span class="text-lg font-semibold">
        <%= number_to_currency(@payment.amount) %>
      </span>
    </div>

    <%= f.select :payment_method,
        Payment::METHODS,
        { label: "Moyen de paiement" },
        { class: "select-input",
          data: { action: "change->payment-form#toggleFields" } } %>

    <div data-payment-form-target="cardFields" class="hidden space-y-4">
      <%= render "payments/card_fields", form: f %>
    </div>

    <div data-payment-form-target="cashFields" class="hidden">
      <%= render "payments/cash_fields", form: f %>
    </div>

    <%= f.submit "Payer",
        class: "w-full btn-primary",
        data: { disable_with: "Traitement..." } %>
  </div>
<% end %>
```

# app/helpers/authorization_helper.rb
module AuthorizationHelper
  def can?(action, record)
    policy = "#{record.class}Policy".constantize.new(current_user, record)
    policy.public_send("#{action}?")
  end
  
  def show_if(action, record, &block)
    capture(&block) if can?(action, record)
  end
end

# Utilisation dans les vues
<%= show_if(:update, @membership) do %>
  <%= link_to "Modifier", edit_membership_path(@membership) %>
<% end %>

### Composants UI
```erb
<%# app/views/shared/components/_button.html.erb %>
<button class="<%= flowbite_button_class(variant) %>">
  <%= content %>
</button>

<%# app/views/shared/components/_card.html.erb %>
<div class="<%= flowbite_card_class %>">
  <%= content %>
</div>
```

### Helpers Flowbite
```ruby
# app/helpers/flowbite_helper.rb
module FlowbiteHelper
  def flowbite_button_class(variant = :primary)
    case variant
    when :primary
      "text-white bg-blue-700 hover:bg-blue-800 focus:ring-4..."
    when :secondary
      "text-gray-900 bg-white border border-gray-300..."
    end
  end
end
``` 