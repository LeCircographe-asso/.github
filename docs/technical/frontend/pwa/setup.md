# Configuration PWA

## Installation

### Manifest
```json
// public/manifest.json
{
  "name": "Le Circographe",
  "short_name": "Circographe",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#4f46e5",
  "icons": [
    {
      "src": "/icons/icon-192x192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/icons/icon-512x512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

### Service Worker
```javascript
// app/javascript/service_worker.js
const CACHE_VERSION = 'v1';
const CACHE_NAME = `circographe-${CACHE_VERSION}`;

const CACHED_ASSETS = [
  '/',
  '/offline.html',
  '/manifest.json',
  '/assets/application.css',
  '/assets/application.js',
  '/icons/icon-192x192.png',
  '/icons/icon-512x512.png'
];

// Installation du Service Worker
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(CACHED_ASSETS))
  );
});

// Activation et nettoyage des anciens caches
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames
          .filter(name => name.startsWith('circographe-') && name !== CACHE_NAME)
          .map(name => caches.delete(name))
      );
    })
  );
});

// Stratégie de cache : Network First avec fallback sur le cache
self.addEventListener('fetch', event => {
  event.respondWith(
    fetch(event.request)
      .catch(() => {
        return caches.match(event.request)
          .then(response => {
            if (response) {
              return response;
            }
            if (event.request.mode === 'navigate') {
              return caches.match('/offline.html');
            }
            return null;
          });
      })
  );
});

self.addEventListener('push', event => {
  const data = event.data.json();
  
  self.registration.showNotification(data.title, {
    body: data.body,
    icon: '/icon.png',
    badge: '/badge.png',
    data: data.url
  });
});
```

## Configuration Rails

### Initializer
```ruby
# config/initializers/pwa.rb
Rails.application.config.middleware.insert_before(
  Rack::Runtime,
  Rack::Static,
  urls: ["/manifest.json"],
  root: Rails.root.join("public")
)
```

### Layout
```erb
<%# app/views/layouts/application.html.erb %>
<!DOCTYPE html>
<html>
  <head>
    <!-- ... autres meta tags ... -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#4f46e5">
    <link rel="manifest" href="/manifest.json">
    <link rel="apple-touch-icon" href="/icons/icon-192x192.png">
  </head>
  <!-- ... -->
</html>
```

## Fonctionnalités Offline

### Page Offline
```erb
<%# public/offline.html %>
<!DOCTYPE html>
<html>
<head>
  <title>Hors ligne - Le Circographe</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <style>
    /* Styles pour la page offline */
  </style>
</head>
<body>
  <div class="offline-container">
    <h1>Pas de connexion internet</h1>
    <p>Certaines fonctionnalités peuvent être limitées en mode hors ligne.</p>
  </div>
</body>
</html>
```

### Synchronisation
```javascript
// app/javascript/controllers/sync_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "status" ]

  connect() {
    this.checkOnlineStatus()
    window.addEventListener('online', this.checkOnlineStatus.bind(this))
    window.addEventListener('offline', this.checkOnlineStatus.bind(this))
  }

  checkOnlineStatus() {
    if (navigator.onLine) {
      this.syncData()
      this.statusTarget.textContent = "Connecté"
    } else {
      this.statusTarget.textContent = "Hors ligne"
    }
  }

  async syncData() {
    // Synchronisation des données stockées localement
    const pendingActions = await this.getPendingActions()
    if (pendingActions.length > 0) {
      await this.processPendingActions(pendingActions)
    }
  }
}
```

## Stockage Local

### IndexedDB Configuration
```javascript
// app/javascript/services/db_service.js
import { openDB } from 'idb'

const dbName = 'circographe-db'
const dbVersion = 1

export async function initDB() {
  return openDB(dbName, dbVersion, {
    upgrade(db) {
      if (!db.objectStoreNames.contains('attendances')) {
        db.createObjectStore('attendances', { keyPath: 'id', autoIncrement: true })
      }
      if (!db.objectStoreNames.contains('pendingActions')) {
        db.createObjectStore('pendingActions', { keyPath: 'id', autoIncrement: true })
      }
    }
  })
} 