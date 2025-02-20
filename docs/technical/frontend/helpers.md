# Helpers et Utilitaires

## View Helpers

### Flash Helper
```ruby
# app/helpers/flash_helper.rb
module FlashHelper
  def flash_class(type)
    case type.to_sym
    when :notice, :success
      "bg-green-100 text-green-800 border border-green-300"
    when :error, :alert
      "bg-red-100 text-red-800 border border-red-300"
    when :warning
      "bg-yellow-100 text-yellow-800 border border-yellow-300"
    else
      "bg-blue-100 text-blue-800 border border-blue-300"
    end
  end

  def flash_icon(type)
    case type.to_sym
    when :notice, :success
      render "shared/icons/check_circle"
    when :error, :alert
      render "shared/icons/x_circle"
    when :warning
      render "shared/icons/exclamation"
    else
      render "shared/icons/information"
    end
  end
end
```

### Application Helper
```ruby
# app/helpers/application_helper.rb
module ApplicationHelper
  include Pagy::Frontend

  def title(page_title)
    content_for(:title) { page_title }
  end

  def active_link_class(path, exact: false)
    if exact
      current_page?(path) ? "bg-gray-900 text-white" : "text-gray-300 hover:bg-gray-700 hover:text-white"
    else
      request.path.start_with?(path) ? "bg-gray-900 text-white" : "text-gray-300 hover:bg-gray-700 hover:text-white"
    end
  end

  def format_date(date)
    return unless date
    l(date, format: :long)
  end

  def format_price(amount)
    number_to_currency(amount, unit: "€", format: "%n %u")
  end
end
```

### Admin Helper
```ruby
# app/helpers/admin_helper.rb
module AdminHelper
  def status_badge(status)
    case status
    when "active"
      tag.span("Actif", class: "px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800")
    when "inactive"
      tag.span("Inactif", class: "px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800")
    when "pending"
      tag.span("En attente", class: "px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800")
    end
  end

  def admin_table_classes
    "min-w-full divide-y divide-gray-200"
  end

  def admin_th_classes
    "px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
  end

  def admin_td_classes
    "px-6 py-4 whitespace-nowrap text-sm text-gray-500"
  end
end
``` 