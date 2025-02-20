# Architecture Base de Données

## Schéma Général

### Users
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email STRING UNIQUE,
  member_number STRING UNIQUE,
  first_name STRING,
  last_name STRING,
  phone STRING,
  created_at DATETIME,
  updated_at DATETIME
);

CREATE INDEX idx_users_member_number ON users(member_number);
```

### Memberships
```sql
CREATE TABLE memberships (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  type STRING,
  start_date DATE,
  end_date DATE,
  reduced_price BOOLEAN,
  created_at DATETIME,
  updated_at DATETIME,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE INDEX idx_memberships_user ON memberships(user_id);
CREATE INDEX idx_memberships_dates ON memberships(start_date, end_date);
```

### Subscriptions
```sql
CREATE TABLE subscriptions (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  type STRING,
  start_date DATE,
  end_date DATE,
  entries_count INTEGER,
  created_at DATETIME,
  updated_at DATETIME,
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_dates ON subscriptions(start_date, end_date);
```

## Relations Clés

### User → Memberships
- Relation one-to-many
- Un utilisateur peut avoir plusieurs adhésions
- Historique conservé

### User → Subscriptions
- Relation one-to-many
- Une seule cotisation active à la fois
- Historique conservé

### Membership → Payments
- Relation polymorphique
- Traçabilité des paiements
- Lien avec les reçus 