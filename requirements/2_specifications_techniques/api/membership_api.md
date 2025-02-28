# API Adhésion - Spécifications Techniques

Ce document détaille les spécifications techniques de l'API de gestion des adhésions du Circographe.

## Points de Terminaison (Endpoints)

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/api/v1/memberships` | Liste des adhésions |
| GET | `/api/v1/memberships/:id` | Détails d'une adhésion |
| POST | `/api/v1/memberships` | Création d'une adhésion |
| PUT | `/api/v1/memberships/:id` | Mise à jour d'une adhésion |
| DELETE | `/api/v1/memberships/:id` | Suppression d'une adhésion |
| POST | `/api/v1/memberships/:id/renew` | Renouvellement d'une adhésion |
| POST | `/api/v1/memberships/:id/cancel` | Annulation d'une adhésion |
| GET | `/api/v1/memberships/:id/card` | Carte de membre |
| GET | `/api/v1/memberships/:id/certificate` | Attestation d'adhésion |

## Modèle de Données

### Objet Membership

```json
{
  "id": "uuid",
  "type": "basic|circus",
  "user_id": "uuid",
  "status": "pending|active|expired|renewed|cancelled",
  "start_date": "2024-01-01",
  "end_date": "2024-12-31",
  "payment_id": "uuid",
  "amount_paid": 10.00,
  "created_at": "2024-01-01T12:00:00Z",
  "updated_at": "2024-01-01T12:00:00Z",
  "metadata": {
    "renewal_count": 0,
    "previous_membership_id": null,
    "special_conditions": null
  }
}
```

## Détails des Endpoints

### Liste des Adhésions

```
GET /api/v1/memberships
```

#### Paramètres de Requête

| Paramètre | Type | Description | Défaut |
|-----------|------|-------------|--------|
| `status` | string | Filtre par statut | tous |
| `type` | string | Filtre par type | tous |
| `user_id` | uuid | Filtre par utilisateur | tous |
| `active_on` | date | Filtre par date de validité | aujourd'hui |
| `page` | integer | Numéro de page | 1 |
| `per_page` | integer | Éléments par page | 20 |
| `sort` | string | Champ et direction de tri | created_at:desc |

#### Exemple de Réponse

```json
{
  "status": "success",
  "data": [
    {
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "type": "basic",
      "user_id": "123e4567-e89b-12d3-a456-426614174001",
      "status": "active",
      "start_date": "2024-01-01",
      "end_date": "2024-12-31",
      "payment_id": "123e4567-e89b-12d3-a456-426614174002",
      "amount_paid": 10.00,
      "created_at": "2024-01-01T12:00:00Z",
      "updated_at": "2024-01-01T12:00:00Z"
    },
    // ...
  ],
  "meta": {
    "pagination": {
      "current_page": 1,
      "per_page": 20,
      "total_pages": 3,
      "total_count": 57
    }
  }
}
```

### Détails d'une Adhésion

```
GET /api/v1/memberships/:id
```

#### Exemple de Réponse

```json
{
  "status": "success",
  "data": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "type": "basic",
    "user_id": "123e4567-e89b-12d3-a456-426614174001",
    "status": "active",
    "start_date": "2024-01-01",
    "end_date": "2024-12-31",
    "payment_id": "123e4567-e89b-12d3-a456-426614174002",
    "amount_paid": 10.00,
    "created_at": "2024-01-01T12:00:00Z",
    "updated_at": "2024-01-01T12:00:00Z",
    "metadata": {
      "renewal_count": 0,
      "previous_membership_id": null,
      "special_conditions": null
    },
    "user": {
      "id": "123e4567-e89b-12d3-a456-426614174001",
      "email": "user@example.com",
      "first_name": "Jean",
      "last_name": "Dupont"
    },
    "payment": {
      "id": "123e4567-e89b-12d3-a456-426614174002",
      "method": "card",
      "status": "completed",
      "amount": 10.00,
      "receipt_url": "/api/v1/payments/123e4567-e89b-12d3-a456-426614174002/receipt"
    }
  }
}
```

### Création d'une Adhésion

```
POST /api/v1/memberships
```

#### Corps de la Requête

```json
{
  "type": "basic",
  "user_id": "123e4567-e89b-12d3-a456-426614174001",
  "start_date": "2024-01-01",
  "payment": {
    "method": "card",
    "amount": 10.00
  }
}
```

#### Exemple de Réponse

```json
{
  "status": "success",
  "data": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "type": "basic",
    "user_id": "123e4567-e89b-12d3-a456-426614174001",
    "status": "pending",
    "start_date": "2024-01-01",
    "end_date": "2024-12-31",
    "payment_id": "123e4567-e89b-12d3-a456-426614174002",
    "amount_paid": 10.00,
    "created_at": "2024-01-01T12:00:00Z",
    "updated_at": "2024-01-01T12:00:00Z"
  }
}
```

### Renouvellement d'une Adhésion

```
POST /api/v1/memberships/:id/renew
```

#### Corps de la Requête

```json
{
  "payment": {
    "method": "card",
    "amount": 10.00
  }
}
```

#### Exemple de Réponse

```json
{
  "status": "success",
  "data": {
    "id": "123e4567-e89b-12d3-a456-426614174003",
    "type": "basic",
    "user_id": "123e4567-e89b-12d3-a456-426614174001",
    "status": "pending",
    "start_date": "2025-01-01",
    "end_date": "2025-12-31",
    "payment_id": "123e4567-e89b-12d3-a456-426614174004",
    "amount_paid": 10.00,
    "created_at": "2024-12-15T12:00:00Z",
    "updated_at": "2024-12-15T12:00:00Z",
    "metadata": {
      "renewal_count": 1,
      "previous_membership_id": "123e4567-e89b-12d3-a456-426614174000",
      "special_conditions": null
    }
  }
}
```

### Carte de Membre

```
GET /api/v1/memberships/:id/card
```

#### Paramètres de Requête

| Paramètre | Type | Description | Défaut |
|-----------|------|-------------|--------|
| `format` | string | Format de sortie (pdf, html, json) | pdf |

#### Exemple de Réponse

Pour `format=json` :

```json
{
  "status": "success",
  "data": {
    "membership_id": "123e4567-e89b-12d3-a456-426614174000",
    "user": {
      "id": "123e4567-e89b-12d3-a456-426614174001",
      "full_name": "Jean Dupont",
      "email": "user@example.com"
    },
    "type": "basic",
    "valid_from": "2024-01-01",
    "valid_until": "2024-12-31",
    "qr_code": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...",
    "card_number": "M-2024-0001"
  }
}
```

Pour `format=pdf` ou `format=html`, le contenu approprié est retourné avec les en-têtes correspondants.

## Codes d'Erreur Spécifiques

| Code | Description |
|------|-------------|
| `MEMBERSHIP_ALREADY_EXISTS` | Une adhésion active existe déjà pour cet utilisateur |
| `INVALID_MEMBERSHIP_TYPE` | Type d'adhésion invalide |
| `INVALID_DATE_RANGE` | Plage de dates invalide |
| `PAYMENT_REQUIRED` | Paiement requis pour cette opération |
| `MEMBERSHIP_NOT_RENEWABLE` | L'adhésion n'est pas renouvelable (trop tôt ou autre raison) |

## Règles Métier Implémentées

1. **Unicité des adhésions actives**
   - Un utilisateur ne peut avoir qu'une seule adhésion active de chaque type

2. **Calcul automatique de la date de fin**
   - La date de fin est calculée automatiquement (1 an après la date de début)

3. **Statuts et transitions**
   - Les transitions de statut suivent le diagramme d'états défini dans [membership_states.md](/docs/architecture/diagrams/membership_states.md)

4. **Renouvellement**
   - Le renouvellement est possible 30 jours avant la date de fin
   - Le renouvellement crée une nouvelle adhésion liée à l'ancienne

5. **Paiements**
   - Une adhésion nécessite un paiement valide pour devenir active
   - Le montant du paiement doit correspondre au tarif en vigueur

## Intégration avec d'autres Domaines

- **Utilisateurs**: Récupération des informations utilisateur
- **Paiements**: Création et validation des paiements
- **Cotisations**: Vérification des prérequis pour certaines cotisations
- **Présence**: Vérification de la validité de l'adhésion pour l'accès

---

*Version: 1.0 - Dernière mise à jour: Février 2024* 