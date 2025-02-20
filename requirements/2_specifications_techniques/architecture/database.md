# Structure de la Base de Données

## Tables Principales

### users
| Colonne | Type | Description |
|---------|------|-------------|
| email | string | Unique, index |
| password_digest | string | Crypté |
| first_name | string | |
| last_name | string | |
| phone | string | |
| member_number | string | Format: YYYYNNN |
| birthdate | date | |
| address | text | |
| emergency_contact | string | |
| emergency_phone | string | |
| timestamps | datetime | created_at/updated_at |

### roles
| Colonne | Type | Description |
|---------|------|-------------|
| name | string | volunteer/admin/super_admin |
| timestamps | datetime | created_at/updated_at |

### user_roles
| Colonne | Type | Description |
|---------|------|-------------|
| user_id | references | Foreign Key |
| role_id | references | Foreign Key |
| timestamps | datetime | created_at/updated_at |

### memberships
| Colonne | Type | Description |
|---------|------|-------------|
| user_id | references | Foreign Key |
| type | string | basic/circus |
| start_date | date | |
| end_date | date | |
| reduced_price | boolean | default: false |
| timestamps | datetime | created_at/updated_at |

### subscriptions
| Colonne | Type | Description |
|---------|------|-------------|
| user_id | references | Foreign Key |
| type | string | daily/pack/quarterly/yearly |
| start_date | date | |
| end_date | date | Null pour pack |
| entries_count | integer | Pour les carnets |
| entries_left | integer | Pour les carnets |
| timestamps | datetime | created_at/updated_at |

### payments
| Colonne | Type | Description |
|---------|------|-------------|
| user_id | references | Foreign Key |
| payable | references | Polymorphic (Membership/Subscription) |
| amount | decimal | precision: 10, scale: 2 |
| donation_amount | decimal | precision: 10, scale: 2 |
| payment_method | string | cash/card/check |
| receipt_number | string | YYYYMMDD-TYPE-NNN |
| installment_number | integer | Pour paiement en plusieurs fois |
| recorded_by | references | Foreign Key (users) |
| timestamps | datetime | created_at/updated_at |

### attendances
| Colonne | Type | Description |
|---------|------|-------------|
| user_id | references | Foreign Key |
| subscription_id | references | Foreign Key |
| check_in | datetime | |
| recorded_by | references | Foreign Key (users) |
| timestamps | datetime | created_at/updated_at | 