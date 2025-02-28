# Authentification et Autorisation API

Ce document détaille les mécanismes d'authentification et d'autorisation utilisés par les API du Circographe.

## Authentification

### Mécanisme JWT

Le Circographe utilise JSON Web Tokens (JWT) pour l'authentification API. Ce mécanisme permet une authentification stateless et sécurisée.

#### Obtention d'un Token

Pour obtenir un token JWT, une requête doit être envoyée à l'endpoint d'authentification :

```
POST /api/v1/auth/login
```

Corps de la requête :

```json
{
  "email": "user@example.com",
  "password": "secure_password"
}
```

Réponse en cas de succès :

```json
{
  "status": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 28800,
    "token_type": "Bearer"
  }
}
```

#### Utilisation du Token

Le token doit être inclus dans l'en-tête `Authorization` de chaque requête API :

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Rafraîchissement du Token

Lorsqu'un token expire, un nouveau token peut être obtenu en utilisant le refresh token :

```
POST /api/v1/auth/refresh
```

Corps de la requête :

```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

Réponse en cas de succès :

```json
{
  "status": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 28800,
    "token_type": "Bearer"
  }
}
```

#### Déconnexion

Pour invalider un token (déconnexion) :

```
POST /api/v1/auth/logout
```

Corps de la requête :

```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Structure du Token

Le token JWT contient les informations suivantes dans sa charge utile (payload) :

```json
{
  "sub": "123e4567-e89b-12d3-a456-426614174000", // ID utilisateur
  "name": "Jean Dupont", // Nom complet
  "email": "user@example.com", // Email
  "role": "admin", // Rôle principal
  "permissions": ["read:users", "write:users", "read:memberships"], // Permissions
  "iat": 1613558255, // Issued At (timestamp)
  "exp": 1613587055, // Expiration (timestamp)
  "jti": "123e4567-e89b-12d3-a456-426614174001" // JWT ID unique
}
```

### Sécurité des Tokens

Les mesures de sécurité suivantes sont appliquées :

- **Durée de validité limitée** : 8 heures par défaut
- **Signature HMAC-SHA256** : Vérification de l'intégrité
- **Stockage sécurisé** : Les tokens ne doivent jamais être stockés en clair
- **Rotation des clés** : Les clés de signature sont rotées régulièrement
- **Révocation** : Possibilité de révoquer des tokens en cas de compromission

## Autorisation

### Modèle de Permissions

Le Circographe utilise un modèle d'autorisation basé sur les rôles et les permissions.

#### Rôles

Les rôles principaux sont :

| Rôle | Description |
|------|-------------|
| `guest` | Utilisateur non authentifié |
| `member` | Membre de base |
| `volunteer` | Bénévole avec permissions étendues |
| `admin` | Administrateur avec accès complet |

#### Permissions

Les permissions suivent le format `action:resource` :

| Permission | Description |
|------------|-------------|
| `read:users` | Lecture des informations utilisateur |
| `write:users` | Modification des informations utilisateur |
| `read:memberships` | Lecture des adhésions |
| `write:memberships` | Création/modification des adhésions |
| `read:subscriptions` | Lecture des cotisations |
| `write:subscriptions` | Création/modification des cotisations |
| `read:payments` | Lecture des paiements |
| `write:payments` | Création/modification des paiements |
| `read:attendances` | Lecture des présences |
| `write:attendances` | Enregistrement des présences |

### Vérification des Permissions

La vérification des permissions est effectuée à plusieurs niveaux :

1. **Middleware d'authentification** : Vérifie la validité du token
2. **Middleware d'autorisation** : Vérifie les permissions requises
3. **Contrôleurs** : Vérifications spécifiques au contexte

Exemple de middleware d'autorisation :

```ruby
class PermissionMiddleware
  def initialize(app, required_permissions)
    @app = app
    @required_permissions = required_permissions
  end

  def call(env)
    request = Rack::Request.new(env)
    token = extract_token(request)
    
    if token && has_permissions?(token, @required_permissions)
      @app.call(env)
    else
      [403, { 'Content-Type' => 'application/json' }, [{ 
        status: 'error',
        error: {
          code: 'FORBIDDEN',
          message: 'Insufficient permissions'
        }
      }.to_json]]
    end
  end
  
  private
  
  def extract_token(request)
    # Extraction du token depuis l'en-tête Authorization
  end
  
  def has_permissions?(token, required_permissions)
    # Vérification des permissions dans le token
  end
end
```

### Matrice de Permissions

La matrice complète des permissions par rôle est disponible dans le document [roles_permissions.md](/docs/architecture/diagrams/roles_permissions.md).

## Gestion des Erreurs d'Authentification

| Code HTTP | Code d'Erreur | Description |
|-----------|---------------|-------------|
| 401 | `UNAUTHORIZED` | Token manquant ou invalide |
| 403 | `FORBIDDEN` | Permissions insuffisantes |
| 419 | `TOKEN_EXPIRED` | Token expiré |
| 422 | `INVALID_CREDENTIALS` | Identifiants invalides |

Exemple de réponse d'erreur :

```json
{
  "status": "error",
  "error": {
    "code": "TOKEN_EXPIRED",
    "message": "Authentication token has expired",
    "details": {
      "expired_at": "2024-02-15T15:30:45Z"
    }
  }
}
```

## Bonnes Pratiques pour les Clients API

1. **Stockage sécurisé des tokens**
   - Utiliser le localStorage ou le sessionStorage pour les applications web
   - Utiliser le stockage sécurisé pour les applications mobiles

2. **Gestion de l'expiration**
   - Implémenter un mécanisme de rafraîchissement automatique
   - Rediriger vers la page de connexion en cas d'échec de rafraîchissement

3. **Sécurité des communications**
   - Utiliser HTTPS pour toutes les communications
   - Valider les certificats SSL

4. **Gestion des erreurs**
   - Traiter spécifiquement les erreurs 401 et 403
   - Implémenter des retry avec backoff pour les erreurs temporaires

## Intégration avec l'Authentification Rails

L'authentification API est intégrée avec le système d'authentification natif de Rails 8.0.1. Les sessions utilisateur et les tokens API partagent le même backend d'authentification.

---

*Version: 1.0 - Dernière mise à jour: Février 2024* 