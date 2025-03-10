# Documentation API RESTful

## Vue d'ensemble

Cette documentation détaille les API RESTful exposées par Le Circographe. Les API sont organisées par domaine métier et suivent les principes REST.

## Authentication et autorisation

Toutes les API requièrent une authentification par token JWT. Pour obtenir un token, utilisez l'endpoint `/api/v1/auth/login`.

Exemple:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

## Format des réponses

Toutes les réponses suivent le format JSON:API.

## Domaines API

### Adhésion

**Base URL**: `/api/v1/memberships`

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/` | Liste des adhésions |
| GET | `/:id` | Détail d'une adhésion |
| POST | `/` | Créer une adhésion |
| PUT | `/:id` | Mettre à jour une adhésion |
| DELETE | `/:id` | Supprimer une adhésion |

### Cotisation

**Base URL**: `/api/v1/subscriptions`

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/` | Liste des cotisations |
| GET | `/:id` | Détail d'une cotisation |
| POST | `/` | Créer une cotisation |
| PUT | `/:id` | Mettre à jour une cotisation |
| DELETE | `/:id` | Supprimer une cotisation |

### Paiement

**Base URL**: `/api/v1/payments`

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/` | Liste des paiements |
| GET | `/:id` | Détail d'un paiement |
| POST | `/` | Créer un paiement |
| PUT | `/:id` | Mettre à jour un paiement |
| DELETE | `/:id` | Supprimer un paiement |

### Présence

**Base URL**: `/api/v1/attendances`

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/` | Liste des présences |
| GET | `/:id` | Détail d'une présence |
| POST | `/` | Créer une présence |
| PUT | `/:id` | Mettre à jour une présence |
| DELETE | `/:id` | Supprimer une présence |

### Rôles

**Base URL**: `/api/v1/roles`

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/` | Liste des rôles |
| GET | `/:id` | Détail d'un rôle |
| POST | `/` | Créer un rôle |
| PUT | `/:id` | Mettre à jour un rôle |
| DELETE | `/:id` | Supprimer un rôle |

### Notification

**Base URL**: `/api/v1/notifications`

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/` | Liste des notifications |
| GET | `/:id` | Détail d'une notification |
| POST | `/` | Créer une notification |
| PUT | `/:id` | Mettre à jour une notification |
| DELETE | `/:id` | Supprimer une notification |

## Filtrage et pagination

Toutes les APIs supportent le filtrage et la pagination:

```
GET /api/v1/memberships?page=2&per_page=10&filter[status]=active
```

## Gestion des erreurs

Les erreurs sont retournées avec le code HTTP approprié et un corps détaillant l'erreur:

```json
{
  "errors": [
    {
      "status": "422",
      "title": "Validation Error",
      "detail": "La date de fin doit être postérieure à la date de début"
    }
  ]
}
```

Pour plus de détails sur chaque API, consultez la documentation technique complète.

---

*Dernière mise à jour: Mars 2023* 