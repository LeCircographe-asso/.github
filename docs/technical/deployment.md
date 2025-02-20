# Guide de Déploiement

## Prérequis

### Système
```bash
# Versions requises
Ruby 3.2.0+
PostgreSQL 14+
Redis 6+
Nginx
Node.js 16+
```

### Gems Production
```ruby
# Gemfile
group :production do
  gem 'pg'                    # PostgreSQL
  gem 'redis'                 # Cache & Sessions
  gem 'sidekiq'              # Background Jobs
  gem 'rack-attack'          # Sécurité
  gem 'lograge'              # Logs
end
```

## Configuration Production

### Base de Données
```yaml
# config/database.yml
production:
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  database: circographe_production
  username: <%= ENV['DB_USERNAME'] %>
  password: <%= ENV['DB_PASSWORD'] %>
```

### Serveur Web
```nginx
# /etc/nginx/sites-available/circographe
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
```

## Procédure de Déploiement

### 1. Préparation
```bash
# Sur le serveur
adduser deploy
mkdir -p /var/www/circographe
chown deploy:deploy /var/www/circographe

# Configuration SSH
ssh-copy-id deploy@server
```

### 2. Installation
```bash
# Installation des dépendances
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib nginx redis-server

# Configuration Ruby
rbenv install 3.2.0
rbenv global 3.2.0
gem install bundler

# Installation de l'application
git clone https://github.com/circographe/app.git
cd app
bundle install --deployment --without development test
```

### 3. Configuration
```bash
# Variables d'environnement
cat > .env.production << EOF
RAILS_ENV=production
SECRET_KEY_BASE=<generated_key>
DB_USERNAME=circographe
DB_PASSWORD=<secure_password>
REDIS_URL=redis://localhost:6379/1
EOF

# Base de données
rails db:create RAILS_ENV=production
rails db:migrate RAILS_ENV=production
```

### 4. Services
```bash
# Puma
bundle exec puma -C config/puma.rb

# Sidekiq
bundle exec sidekiq -C config/sidekiq.yml

# Nginx
sudo service nginx restart
```

## Maintenance

### Backups
```bash
# Base de données
pg_dump circographe_production > backup_$(date +%Y%m%d).sql

# Assets et uploads
tar -czf uploads_$(date +%Y%m%d).tar.gz public/uploads/
```

### Monitoring
```bash
# Logs
tail -f log/production.log

# Processus
ps aux | grep puma
ps aux | grep sidekiq

# Performances
htop
```

### Mise à Jour
```bash
git pull origin main
bundle install --deployment
rails assets:precompile
rails db:migrate
touch tmp/restart.txt
sudo service nginx restart
``` 