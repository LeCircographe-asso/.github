# Structure de la Base de Données

## Tables Principales

### users
| Colonne | Type | Description |
|---------|------|-------------|
| email | string | null: false, index: { unique: true } |
| password_digest | string | null: false |
| first_name | string | null: false |
| last_name | string | null: false |
| phone | string | |
| member_number | string | Format: YYYYNNN, index: true |
| birthdate | date | |
| address | text | |
| emergency_contact | string | |
| emergency_phone | string | |
| timestamps | datetime | created_at/updated_at |

### roles
| Colonne | Type | Description |
|---------|------|-------------|
| name | string | null: false, enum: [:member, :volunteer, :admin, :super_admin] |
| timestamps | datetime | created_at/updated_at |

### user_roles
| Colonne | Type | Description |
|---------|------|-------------|
| user | references | null: false, foreign_key: true |
| role | references | null: false, foreign_key: true |
| timestamps | datetime | created_at/updated_at |
| index | | [:user_id, :role_id], unique: true |

### memberships
| Colonne | Type | Description |
|---------|------|-------------|
| user | references | null: false, foreign_key: true |
| type | string | null: false, enum: [:basic, :circus] |
| start_date | date | null: false |
| end_date | date | null: false |
| reduced_price | boolean | default: false |
| reduction_reason | string | |
| timestamps | datetime | created_at/updated_at |
| check_constraint | | "end_date > start_date" |

### subscriptions
| Colonne | Type | Description |
|---------|------|-------------|
| user | references | null: false, foreign_key: true |
| type | string | null: false, enum: [:daily, :pack_10, :trimester, :annual] |
| start_date | date | null: false |
| end_date | date | null pour pack |
| entries_count | integer | Pour les carnets |
| entries_left | integer | Pour les carnets |
| timestamps | datetime | created_at/updated_at |
| check_constraint | | "entries_left <= entries_count" |

### payments
| Colonne | Type | Description |
|---------|------|-------------|
| user | references | null: false, foreign_key: true |
| payable | references | null: false, polymorphic: true |
| amount | decimal | null: false, precision: 10, scale: 2 |
| donation_amount | decimal | precision: 10, scale: 2, default: 0.0 |
| payment_method | string | null: false, enum: [:card, :cash, :check] |
| receipt_number | string | null: false, unique: true, format: YYYYMMDD-TYPE-NNN |
| installment_number | integer | Pour paiement en plusieurs fois |
| recorded_by | references | null: false, foreign_key: { to_table: :users } |
| timestamps | datetime | created_at/updated_at |

### attendances
| Colonne | Type | Description |
|---------|------|-------------|
| user | references | null: false, foreign_key: true |
| subscription | references | null: false, foreign_key: true |
| check_in | datetime | null: false |
| recorded_by | references | null: false, foreign_key: { to_table: :users } |
| timestamps | datetime | created_at/updated_at |
| index | | [:user_id, :check_in], unique: true | 