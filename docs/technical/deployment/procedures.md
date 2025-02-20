# Déploiement et Mises à Jour

## Configuration Capistrano

### Installation
```ruby
# Gemfile
group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-sidekiq'
  gem 'capistrano-puma'
end

# config/deploy.rb
lock "~> 3.17.0"

set :application, "circographe"
set :repo_url, "git@github.com:organization/circographe.git"

set :deploy_to, "/var/www/circographe"
set :branch, 'main'

set :rbenv_type, :user
set :rbenv_ruby, '3.2.0'

set :linked_files, %w[config/database.yml config/master.key .env.production]
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets public/uploads]

set :keep_releases, 5
```

### Environnements
```ruby
# config/deploy/production.rb
server "circographe.fr",
  user: "deploy",
  roles: %w[app db web],
  ssh_options: {
    forward_agent: true,
    auth_methods: %w[publickey]
  }

set :rails_env, 'production'
set :puma_threads, [4, 16]
set :puma_workers, 2
```

## Procédures de Déploiement

### Première Installation
```bash
# Sur le serveur
adduser deploy
usermod -aG sudo deploy
mkdir -p /var/www/circographe
chown deploy:deploy /var/www/circographe

# Configuration Nginx
cat > /etc/nginx/sites-available/circographe << 'EOF'
upstream circographe {
  server unix:///var/www/circographe/shared/tmp/sockets/puma.sock;
}

server {
  listen 80;
  server_name circographe.fr;
  root /var/www/circographe/current/public;

  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }

  location / {
    try_files $uri @puma;
  }

  location @puma {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;
    proxy_pass http://circographe;
  }
}
EOF

ln -s /etc/nginx/sites-available/circographe /etc/nginx/sites-enabled/
```

### Déploiement Initial
```bash
# En local
cap production deploy:check
cap production deploy:initial

# Sur le serveur
cd /var/www/circographe/current
RAILS_ENV=production bundle exec rails db:seed
RAILS_ENV=production bundle exec rails assets:precompile
```

## Mises à Jour

### Procédure Standard
```bash
# Vérification des changements
git fetch origin
git log HEAD..origin/main

# Sauvegarde de la base
cap production backup:create

# Déploiement
cap production deploy

# En cas de problème
cap production deploy:rollback
```

### Migrations Majeures
```ruby
# lib/tasks/deployment.rake
namespace :deployment do
  desc 'Tâches de mise à jour majeure'
  task major_update: :environment do
    puts "Début de la mise à jour majeure..."
    
    ActiveRecord::Base.transaction do
      # Migration des données
      User.find_each do |user|
        user.update_column(:status, user.memberships.active.any? ? 'active' : 'inactive')
      end
      
      # Mise à jour des paramètres
      Setting.update_all(new_feature_enabled: true)
    end
    
    puts "Mise à jour terminée avec succès"
  end
end
```

## Monitoring Post-Déploiement

### Vérifications
```bash
# Logs applicatifs
tail -f /var/www/circographe/current/log/production.log

# Statut des services
systemctl status nginx
systemctl status sidekiq
systemctl status redis

# Performances
htop
```

### Rollback
```bash
# En cas d'erreur
cap production deploy:rollback

# Restauration base de données si nécessaire
cap production backup:download
cap production backup:restore BACKUP=20240215
```

### Notifications
```ruby
# app/services/deployment_notification_service.rb
class DeploymentNotificationService
  def self.notify(version:, status:, details: nil)
    message = {
      version: version,
      status: status,
      environment: Rails.env,
      timestamp: Time.current,
      details: details
    }

    # Notification Slack
    SlackNotifier.notify(message)
    
    # Notification Sentry
    Sentry.capture_message("Deployment: #{status}", extra: message)
  end
end
``` 