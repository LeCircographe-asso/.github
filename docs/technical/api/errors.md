# Gestion des Erreurs

## Format Standard
```json
{
  "status": "error",
  "error": {
    "code": "INVALID_MEMBERSHIP",
    "message": "Adhésion invalide",
    "details": {
      "field": "type",
      "reason": "Type d'adhésion non reconnu"
    }
  }
}
```

## Codes d'Erreur
| Code | HTTP | Description |
|------|------|-------------|
| UNAUTHORIZED | 401 | Token manquant/invalide |
| FORBIDDEN | 403 | Permissions insuffisantes |
| NOT_FOUND | 404 | Ressource non trouvée |
| VALIDATION_ERROR | 422 | Données invalides | 