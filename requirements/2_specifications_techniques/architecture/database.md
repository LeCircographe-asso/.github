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
| training_session | references | null: false, foreign_key: true |
| subscription | references | null: false, foreign_key: true |
| membership | references | null: false, foreign_key: true |
| check_in | datetime | null: false |
| recorded_by | references | null: false, foreign_key: { to_table: :users } |
| timestamps | datetime | created_at/updated_at |
| index | | [:user_id, :training_session_id], unique: true |

### training_sessions
| Colonne | Type | Description |
|---------|------|-------------|
| date | date | null: false |
| start_time | time | null: false |
| end_time | time | null: false |
| attendees_count | integer | default: 0 |
| status | string | null: false, enum: [:scheduled, :ongoing, :completed, :cancelled] |
| recorded_by | references | null: false, foreign_key: { to_table: :users } |
| timestamps | datetime | created_at/updated_at |
| index | | [:date, :start_time], unique: true |
| check_constraint | | "end_time > start_time" |

### daily_stats
| Colonne | Type | Description |
|---------|------|-------------|
| date | date | null: false, unique: true |
| total_attendees | integer | default: 0 |
| basic_members | integer | default: 0 |
| circus_members | integer | default: 0 |
| daily_passes | integer | default: 0 |
| pack_entries | integer | default: 0 |
| trimester_entries | integer | default: 0 |
| annual_entries | integer | default: 0 |
| total_payments | decimal | precision: 10, scale: 2, default: 0 |
| card_payments | decimal | precision: 10, scale: 2, default: 0 |
| cash_payments | decimal | precision: 10, scale: 2, default: 0 |
| check_payments | decimal | precision: 10, scale: 2, default: 0 |
| total_donations | decimal | precision: 10, scale: 2, default: 0 |
| new_memberships | integer | default: 0 |
| renewed_memberships | integer | default: 0 |
| new_subscriptions | integer | default: 0 |
| timestamps | datetime | created_at/updated_at |

### monthly_stats
| Colonne | Type | Description |
|---------|------|-------------|
| month | date | null: false, unique: true |
| average_daily_attendance | decimal | precision: 5, scale: 2 |
| peak_day | date | |
| peak_attendance | integer | |
| revenue_growth | decimal | precision: 5, scale: 2 |
| member_retention_rate | decimal | precision: 5, scale: 2 |
| timestamps | datetime | created_at/updated_at |

### closures
| Colonne | Type | Description |
|---------|------|-------------|
| start_date | date | null: false |
| end_date | date | null: false |
| reason | string | null: false, enum: [:holiday, :maintenance, :event, :other] |
| description | text | |
| recorded_by | references | null: false, foreign_key: { to_table: :users } |
| timestamps | datetime | created_at/updated_at |
| check_constraint | | "end_date >= start_date" |

### member_notes
| Colonne | Type | Description |
|---------|------|-------------|
| user | references | null: false, foreign_key: true |
| note_type | string | enum: [:payment, :attendance, :behavior, :medical, :other] |
| content | text | null: false |
| recorded_by | references | null: false, foreign_key: { to_table: :users } |
| timestamps | datetime | created_at/updated_at |

### opening_hours
| Colonne | Type | Description |
|---------|------|-------------|
| day_of_week | integer | null: false, 0-6 (Dimanche-Samedi) |
| start_time | time | null: false |
| end_time | time | null: false |
| active | boolean | default: true |
| recorded_by | references | null: false, foreign_key: { to_table: :users } |
| timestamps | datetime | created_at/updated_at |
| index | | [:day_of_week, :start_time], unique: true |
| check_constraint | | "end_time > start_time" |

### schedule_exceptions
| Colonne | Type | Description |
|---------|------|-------------|
| date | date | null: false |
| original_start | time | |
| original_end | time | |
| modified_start | time | |
| modified_end | time | |
| type | string | null: false, enum: [:closure, :special_hours] |
| reason | string | enum: [:holiday, :maintenance, :event, :other] |
| description | text | |
| recorded_by | references | null: false, foreign_key: { to_table: :users } |
| timestamps | datetime | created_at/updated_at | 