# API RESTful du Circographe

## Vue d'ensemble

Le Circographe expose une API RESTful qui permet d'accéder aux principales fonctionnalités de l'application. Cette API est sécurisée par authentification par token JWT.

## Points de terminaison API

L'application expose une API RESTful pour chaque domaine métier:

| Domaine | Endpoint de base | Description |
|---------|-----------------|---------------|
| Adhésion | `/api/v1/memberships` | Gestion des adhésions |
| Cotisation | `/api/v1/subscriptions` | Gestion des cotisations |
| Paiement | `/api/v1/payments` | Gestion des paiements |
| Présence | `/api/v1/attendances` | Gestion des présences |
| Rôles | `/api/v1/roles` | Gestion des rôles |
| Notification | `/api/v1/notifications` | Gestion des notifications |

## Authentification

Pour accéder à l'API, vous devez inclure un token JWT dans l'en-tête `Authorization` de chaque requête:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNjc2NDU1NDg4LCJleHAiOjE2NzY0NTkwODgsImp0aSI6IjljNDA4OTcyLWIzZTMtNGQ0Yy04MTEzLWExMmQxMDU5ZGE4YSJ9.qHBPZnBVFrM_U_VgQb42Ujbb6PInQQUAFrKwJhgiBLk
```

Pour obtenir un token, utilisez le point de terminaison `/api/v1/auth/login` avec les identifiants de l'utilisateur.

## Format des données

Toutes les requêtes et réponses utilisent le format JSON:

```json
{
  "data": {
    "id": "1",
    "type": "membership",
    "attributes": {
      "start_date": "2023-01-01",
      "end_date": "2023-12-31",
      "status": "active"
    },
    "relationships": {
      "user": {
        "data": { "id": "42", "type": "user" }
      }
    }
  }
}
```

## Exemples d'utilisation

### Récupérer les adhésions

```http
GET /api/v1/memberships HTTP/1.1
Authorization: Bearer <token>
```

Réponse:

```json
{
  "data": [
    {
      "id": "1",
      "type": "membership",
      "attributes": {
        "start_date": "2023-01-01",
        "end_date": "2023-12-31",
        "status": "active"
      }
    },
    {
      "id": "2",
      "type": "membership",
      "attributes": {
        "start_date": "2023-02-15",
        "end_date": "2024-02-14",
        "status": "active"
      }
    }
  ],
  "meta": {
    "total_count": 2,
    "page": 1,
    "per_page": 25
  }
}
```

### Créer une adhésion

```http
POST /api/v1/memberships HTTP/1.1
Authorization: Bearer <token>
Content-Type: application/json

{
  "data": {
    "type": "membership",
    "attributes": {
      "start_date": "2023-03-01",
      "end_date": "2024-02-29",
      "status": "pending"
    },
    "relationships": {
      "user": {
        "data": { "id": "42", "type": "user" }
      }
    }
  }
}
```

## Pagination

Tous les endpoints qui retournent des collections supportent la pagination. Utilisez les paramètres `page` et `per_page`:

```
GET /api/v1/memberships?page=2&per_page=10
```

## Filtrage

Utilisez le paramètre `filter` pour filtrer les résultats:

```
GET /api/v1/memberships?filter[status]=active
```

## Gestion des erreurs

Les erreurs sont retournées avec un code HTTP approprié et un corps JSON décrivant l'erreur:

```json
{
  "errors": [
    {
      "status": "422",
      "title": "Validation Error",
      "detail": "La date de fin doit être postérieure à la date de début",
      "source": {
        "pointer": "/data/attributes/end_date"
      }
    }
  ]
}
```

---

*Dernière mise à jour: Mars 2023*
