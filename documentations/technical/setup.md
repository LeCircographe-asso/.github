# Guide d'Installation et de Configuration - Le Circographe

Ce guide détaille les étapes nécessaires pour installer et configurer l'application Le Circographe dans différents environnements.

## Prérequis

Avant de commencer, assurez-vous d'avoir installé les éléments suivants :

- **Ruby** (version 3.2.0 ou supérieure)
- **Rails** (version 8.0.1)
- **SQLite3** (pour le développement et les tests)
- **Node.js** (version 18.x ou supérieure)
- **Yarn** (version 1.22.x ou supérieure)
- **Redis** (pour le cache)

## Installation en environnement de développement

### 1. Cloner le dépôt

```bash
git clone https://github.com/votre-organisation/circographe.git
cd circographe
```

### 2. Installer les dépendances

```bash
# Installer les gems Ruby
bundle install

# Installer les packages JavaScript
yarn install
```

### 3. Configurer la base de données

```bash
# Créer la base de données
rails db:create

# Exécuter les migrations
rails db:migrate

# Charger les données de test (optionnel)
rails db:seed
```

### 4. Configurer les variables d'environnement

Créez un fichier `.env` à la racine du projet et ajoutez les variables suivantes :

```
# Environnement Rails
RAILS_ENV=development

# Configuration de la base de données
DATABASE_URL=sqlite3:db/development.sqlite3

# Configuration Redis (cache)
REDIS_URL=redis://localhost:6379/0

# Configuration des emails
SMTP_ADDRESS=smtp.example.com
SMTP_PORT=587
SMTP_USERNAME=your_username
SMTP_PASSWORD=your_password
SMTP_DOMAIN=example.com

# Clés d'API (si nécessaire)
STRIPE_API_KEY=your_stripe_api_key
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
```

### 5. Démarrer le serveur

```bash
# Démarrer le serveur Rails
rails server

# Dans un autre terminal, démarrer le serveur Webpack
bin/webpack-dev-server
```

L'application sera accessible à l'adresse http://localhost:3000.

## Installation en environnement de production

### 1. Préparer le serveur

Assurez-vous que votre serveur dispose des éléments suivants :

- Ruby 3.2.0+
- Node.js 18.x+
- Yarn 1.22.x+
- SQLite3
- Redis
- Nginx (recommandé)

### 2. Cloner et configurer l'application

```bash
# Cloner le dépôt
git clone https://github.com/votre-organisation/circographe.git
cd circographe

# Installer les dépendances
bundle install --without development test
yarn install --production

# Compiler les assets
RAILS_ENV=production bundle exec rails assets:precompile

# Configurer la base de données
RAILS_ENV=production bundle exec rails db:create
RAILS_ENV=production bundle exec rails db:migrate
```

### 3. Configurer Nginx

Créez un fichier de configuration Nginx pour l'application :

```nginx
server {
    listen 80;
    server_name circographe.example.com;

    root /chemin/vers/circographe/public;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 1y;
        add_header Cache-Control public;
    }
}
```

### 4. Configurer le service systemd

Créez un fichier de service systemd pour l'application :

```ini
[Unit]
Description=Le Circographe Rails Application
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/chemin/vers/circographe
ExecStart=/bin/bash -lc 'bundle exec rails server -e production'
Restart=always
Environment=RAILS_ENV=production

[Install]
WantedBy=multi-user.target
```

### 5. Démarrer l'application

```bash
# Activer et démarrer le service
sudo systemctl enable circographe
sudo systemctl start circographe

# Redémarrer Nginx
sudo systemctl restart nginx
```

## Configuration avancée

### Configuration de Redis pour le cache

Le Circographe utilise Redis pour le cache. Voici comment configurer Redis dans `config/environments/production.rb` :

```ruby
config.cache_store = :redis_cache_store, {
  url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/0" },
  expires_in: 1.day
}
```

### Configuration des emails

Pour configurer l'envoi d'emails, modifiez le fichier `config/environments/production.rb` :

```ruby
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address:              ENV['SMTP_ADDRESS'],
  port:                 ENV['SMTP_PORT'],
  domain:               ENV['SMTP_DOMAIN'],
  user_name:            ENV['SMTP_USERNAME'],
  password:             ENV['SMTP_PASSWORD'],
  authentication:       'plain',
  enable_starttls_auto: true
}
```

### Configuration des tâches planifiées

Le Circographe utilise ActiveJob pour les tâches en arrière-plan. Voici comment configurer les tâches planifiées avec Whenever :

```ruby
# config/schedule.rb
every 1.day, at: '4:30 am' do
  runner "MembershipExpirationJob.perform_later"
end

every 1.week, at: '5:00 am' do
  runner "WeeklyReportJob.perform_later"
end
```

## Dépannage

### Problèmes courants

#### La base de données ne se connecte pas

Vérifiez que SQLite3 est correctement installé et que le fichier de base de données existe :

```bash
sqlite3 --version
ls -la db/
```

#### Les emails ne sont pas envoyés

Vérifiez la configuration SMTP et testez l'envoi d'un email depuis la console Rails :

```bash
rails console
ActionMailer::Base.mail(to: 'test@example.com', subject: 'Test', body: 'Test email').deliver_now
```

#### Les tâches en arrière-plan ne s'exécutent pas

Vérifiez que Redis est en cours d'exécution et que la configuration ActiveJob est correcte :

```bash
redis-cli ping  # Devrait répondre "PONG"
```

## Ressources supplémentaires

- [Documentation Ruby on Rails](https://guides.rubyonrails.org/)
- [Documentation SQLite](https://www.sqlite.org/docs.html)
- [Documentation Redis](https://redis.io/documentation)
- [Documentation Nginx](https://nginx.org/en/docs/)

---

*Dernière mise à jour: Mars 2023*
