# Assets et Ressources

## Configuration

### Tailwind CSS
```css
/* app/assets/stylesheets/application.tailwind.css */
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer components {
  .btn-primary {
    @apply py-2 px-4 bg-blue-500 text-white font-semibold rounded-lg shadow-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-opacity-75;
  }

  .btn-secondary {
    @apply py-2 px-4 bg-gray-500 text-white font-semibold rounded-lg shadow-md hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-400 focus:ring-opacity-75;
  }

  .form-input {
    @apply mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50;
  }
}
```

### JavaScript
```javascript
// app/javascript/application.js
import "@hotwired/turbo-rails"
import "./controllers"
import "@flowbite/flowbite"

// Configuration globale
window.addEventListener("turbo:load", () => {
  // Initialisation des composants Flowbite
  initFlowbite();
});
```

## Organisation des Assets

### Structure des Dossiers
```
app/assets/
├── images/
│   ├── icons/
│   └── logos/
├── stylesheets/
│   ├── application.tailwind.css
│   └── components/
└── builds/
    └── tailwind.css
```

### Images et Icons
```ruby
# app/helpers/icon_helper.rb
module IconHelper
  def icon(name, options = {})
    options[:class] = Array.wrap(options[:class])
    options[:class] << "w-5 h-5"
    
    render "shared/icons/#{name}", options
  end
end
```

### Gestion des Fonts
```css
/* app/assets/stylesheets/fonts.css */
@font-face {
  font-family: 'CircographeSans';
  src: url('../fonts/CircographeSans-Regular.woff2') format('woff2'),
       url('../fonts/CircographeSans-Regular.woff') format('woff');
  font-weight: normal;
  font-style: normal;
  font-display: swap;
}
``` 