# API Documentation

## Vue d'ensemble
L'API du Circographe permet la gestion des :
- Adhésions et abonnements
- Présences aux entraînements
- Paiements et reçus
- Statistiques et rapports

## Points d'Entrée Principaux
```
/api/v1/
├── memberships/     # Gestion des adhésions
├── subscriptions/   # Gestion des abonnements
├── attendances/     # Gestion des présences
└── payments/        # Gestion des paiements
```

## Authentification
- Basée sur les tokens JWT
- Permissions basées sur les rôles
- Rate limiting par IP et par token

## Formats de Réponse
```json
{
  "status": "success",
  "data": {
    // Données de la réponse
  },
  "meta": {
    "page": 1,
    "total": 100
  }
}
```

## Versions
- v1 : Version actuelle
- v2 : En développement (beta) 