# Documentation API - Le Circographe

Cette section contient la documentation technique des API du Circographe, destinée aux développeurs internes et aux intégrateurs externes.

## Vue d'ensemble

Le Circographe expose une API REST complète permettant d'interagir avec toutes les fonctionnalités de l'application. Cette API est utilisée par le frontend de l'application et peut également être utilisée par des applications tierces.

## Organisation de la Documentation

| Document | Description |
|----------|-------------|
| [docs/architecture/README.md](docs/architecture/README.md) | Ce document |
| [endpoints.md](endpoints.md) | Liste complète des endpoints API |
| [docs/architecture/technical/api/auth.md](docs/architecture/technical/api/auth.md) | Documentation sur l'authentification et l'autorisation |
| [versioning.md](versioning.md) | Politique de versionnement des API |
| [docs/architecture/technical/security/api/errors.md](docs/architecture/technical/security/api/errors.md) | Codes d'erreur et gestion des erreurs |
| [examples.md](examples.md) | Exemples d'utilisation des API |

## Spécifications Techniques

Les spécifications détaillées de chaque API sont disponibles dans le dossier [requirements/2_specifications_techniques/api/](requirements/2_specifications_techniques/api/membership_api.md).

## Principes de Conception

### Architecture REST

Les API suivent les principes REST :
- Utilisation des méthodes HTTP standard (GET, POST, PUT, DELETE)
- Ressources identifiées par des URLs
- Stateless (sans état)
- Représentation des ressources en JSON

### Authentification

L'authentification se fait via JWT (JSON Web Token) :
- Les tokens sont obtenus via l'endpoint `/api/v1/auth/login`
- Les tokens ont une durée de validité limitée (8 heures par défaut)
- Les tokens de rafraîchissement permettent d'obtenir de nouveaux tokens sans re-authentification

### Autorisation

L'autorisation est basée sur les rôles et les permissions :
- Chaque endpoint nécessite des permissions spécifiques
- Les permissions sont associées aux rôles
- Les rôles sont assignés aux utilisateurs

### Versionnement

Les API sont versionnées via le chemin URL :
- Format : `/api/v{major}/resource`
- Exemple : `/api/v1/memberships`

La politique de versionnement complète est détaillée dans [versioning.md](versioning.md).

## Utilisation avec le Frontend

### Intégration avec Turbo

Les API sont utilisées par le frontend via Turbo :
- Les requêtes sont effectuées via `fetch`
- Les réponses JSON sont traitées pour mettre à jour l'interface utilisateur
- Les erreurs sont gérées de manière cohérente

### Exemple d'Intégration

```javascript
// Exemple d'utilisation de l'API avec Turbo
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list"]
  
  async connect() {
    try {
      const response = await fetch("/api/v1/memberships", {
        headers: {
          "Authorization": `Bearer ${this.getToken()}`
        }
      })
      
      if (response.ok) {
        const data = await response.json()
        this.updateList(data.data)
      } else {
        this.handleError(response)
      }
    } catch (error) {
      console.error("Error fetching memberships:", error)
    }
  }
  
  updateList(memberships) {
    // Mise à jour de l'interface utilisateur
  }
  
  handleError(response) {
    // Gestion des erreurs
  }
  
  getToken() {
    // Récupération du token JWT
    return localStorage.getItem("jwt_token")
  }
}
```

## Documentation Interactive

Une documentation interactive des API est disponible via Swagger UI à l'adresse `/api/docs` en environnement de développement.

## Sécurité

Les API sont sécurisées selon les meilleures pratiques :
- HTTPS obligatoire en production
- Protection CSRF pour les endpoints sensibles
- Rate limiting pour prévenir les abus
- Validation des entrées pour prévenir les injections

## Monitoring et Logs

Les appels API sont monitorés et journalisés :
- Logs d'accès pour chaque requête
- Logs d'erreur pour les requêtes échouées
- Métriques de performance (temps de réponse, taux d'erreur)

## Intégration avec d'autres Systèmes

Les API peuvent être utilisées pour intégrer Le Circographe avec d'autres systèmes :
- Systèmes de gestion d'association
- Applications mobiles
- Systèmes de contrôle d'accès
- Outils d'analyse et de reporting

---

*Version: 1.0 - Dernière mise à jour: Février 2024* 