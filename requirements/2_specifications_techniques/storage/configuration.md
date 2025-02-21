# Configuration Storage

## Développement
```ruby
# config/environments/development.rb
config.active_storage.service = :local
config.action_text.attachment_tag_name = "action-text-attachment"

# Configuration des variants d'images
config.active_storage.variant_processor = :mini_magick
```

## Production
```ruby
# config/environments/production.rb
config.active_storage.service = :local  # Même en prod on reste en local
config.active_storage.variant_processor = :mini_magick

# Optimisation
config.active_storage.replace_on_assign_to_many = false
config.active_storage.track_variants = true
```

## Services Configuration
```yaml
# config/storage.yml
local:
  service: Disk
  root: <%= Rails.root.join("storage") %>
``` 