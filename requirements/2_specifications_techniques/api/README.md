# API - Spécifications Techniques

Ce dossier contient les spécifications techniques des API du Circographe, organisées par domaine métier.

## Vue d'ensemble

L'application Le Circographe expose plusieurs API pour permettre l'intégration avec d'autres systèmes et le développement d'applications tierces. Ces API suivent les principes REST et utilisent JSON comme format d'échange.

## Organisation des Spécifications

Les spécifications API sont organisées par domaine métier :

| Fichier | Description |
|---------|-------------|
| [requirements/2_specifications_techniques/api/membership_api.md](requirements/2_specifications_techniques/api/membership_api.md) | API pour la gestion des adhésions |
| [subscription_api.md](subscription_api.md) | API pour la gestion des cotisations |
| [payment_api.md](payment_api.md) | API pour la gestion des paiements |
| [attendance_api.md](attendance_api.md) | API pour la gestion des présences |
| [notification_api.md](notification_api.md) | API pour la gestion des notifications |
| [user_api.md](user_api.md) | API pour la gestion des utilisateurs et rôles |

## Principes Généraux

### Authentification

Toutes les API nécessitent une authentification via JWT (JSON Web Token). Les tokens sont obtenus via l'endpoint `/api/v1/auth/login` et doivent être inclus dans l'en-tête `Authorization` de chaque requête.

```
Authorization: Bearer <token>
```

### Versionnement

Les API sont versionnées via le chemin URL. La version actuelle est `v1`.

```
/api/v1/resources
```

### Format des Réponses

Toutes les réponses sont au format JSON et suivent la structure suivante :

```json
{
  "status": "success",
  "data": { ... },
  "meta": { ... }
}
```

En cas d'erreur :

```json
{
  "status": "error",
  "error": {
    "code": "ERROR_CODE",
    "message": "Description de l'erreur"
  }
}
```

### Pagination

Les endpoints retournant des collections supportent la pagination via les paramètres `page` et `per_page`.

```
GET /api/v1/resources?page=2&per_page=20
```

La réponse inclut des métadonnées de pagination :

```json
{
  "status": "success",
  "data": [ ... ],
  "meta": {
    "pagination": {
      "current_page": 2,
      "per_page": 20,
      "total_pages": 5,
      "total_count": 97
    }
  }
}
```

### Filtrage et Tri

Le filtrage est supporté via des paramètres de requête :

```
GET /api/v1/resources?status=active&created_after=2023-01-01
```

Le tri est supporté via le paramètre `sort` :

```
GET /api/v1/resources?sort=created_at:desc,name:asc
```

## Codes d'Erreur Communs

| Code | Description |
|------|-------------|
| `UNAUTHORIZED` | Authentification requise ou token invalide |
| `FORBIDDEN` | Permissions insuffisantes |
| `RESOURCE_NOT_FOUND` | Ressource non trouvée |
| `VALIDATION_ERROR` | Données de requête invalides |
| `RATE_LIMIT_EXCEEDED` | Limite de requêtes dépassée |
| `INTERNAL_ERROR` | Erreur interne du serveur |

## Intégration avec le Frontend

Les API sont utilisées par le frontend via Turbo et Stimulus. Les requêtes sont effectuées via `fetch` et les réponses sont traitées pour mettre à jour l'interface utilisateur.

## Documentation Complète

Une documentation interactive des API est disponible via Swagger UI à l'adresse `/api/docs` en environnement de développement.

---

*Version: 1.0 - Dernière mise à jour: Février 2024* 