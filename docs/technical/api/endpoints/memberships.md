# Endpoints Adhésions

## Liste des Adhésions
```http
GET /api/v1/memberships
```

### Paramètres
| Nom | Type | Description |
|-----|------|-------------|
| type | string | Type d'adhésion (basic/circus) |
| status | string | Statut (active/expired) |
| page | integer | Numéro de page |

### Réponse
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "type": "basic",
      "start_date": "2024-01-01",
      "end_date": "2024-12-31",
      "status": "active"
    }
  ],
  "meta": {
    "page": 1,
    "total": 100
  }
}
``` 