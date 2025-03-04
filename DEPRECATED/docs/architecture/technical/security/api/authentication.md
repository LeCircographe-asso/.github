# Authentification API

## Obtention du Token
```http
POST /api/v1/auth/token
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

## Utilisation du Token
```http
GET /api/v1/memberships
Authorization: Bearer <token>
```

## Permissions par Rôle
| Endpoint | Member | Volunteer | Admin |
|----------|---------|-----------|--------|
| GET /memberships | ✅ | ✅ | ✅ |
| POST /memberships | ❌ | ✅ | ✅ |
| PUT /memberships | ❌ | ❌ | ✅ |
| DELETE /memberships | ❌ | ❌ | ✅ | 