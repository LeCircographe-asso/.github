# Spécifications Techniques - Présence

## Identification du document

| Domaine           | Présence                            |
|-------------------|-------------------------------------|
| Version           | 1.0                                 |
| Référence         | SPEC-PRE-2023-01                    |
| Dernière révision | [DATE]                              |

## Vue d'ensemble

Ce document définit les spécifications techniques pour le domaine "Présence" du système Circographe. Il décrit le modèle de données, les validations, les services et les implémentations techniques des règles de présence.

## Modèles de données

### Modèle `AttendanceList`

#### Attributs principaux
- `id`: Identifiant unique (Integer, PK)
- `list_type`: Type de liste (Enum: daily, event)
- `name`: Nom descriptif de la liste (String)
- `date`: Date de la liste (Date)
- `status`: Statut (Enum: created, open, closed, archived)
- `capacity`: Capacité maximale (Integer, 0 = illimitée)
- `requires_cirque`: Nécessite adhésion Cirque (Boolean)
- `requires_contribution`: Nécessite cotisation active (Boolean)
- `opened_at`, `closed_at`, `archived_at`: Horodatages des transitions d'état

#### Associations principales
- `has_many :attendances`: Entrées enregistrées sur cette liste
- `belongs_to :event, optional: true`: Événement associé (si type event)
- `belongs_to :created_by, class_name: 'User'`: Créateur de la liste
- `has_one :statistic, class_name: 'AttendanceStatistic'`: Statistiques de la liste

#### Méthodes clés
- `open!`: Ouvre la liste pour enregistrement
- `close!`: Clôture la liste (fin des enregistrements)
- `archive!`: Archive la liste après la période de consultation
- `available_spots`: Calcule le nombre de places disponibles
- `can_register?(user)`: Vérifie si un utilisateur peut s'enregistrer

### Modèle `Attendance`

#### Attributs principaux
- `id`: Identifiant unique (Integer, PK)
- `attendance_list_id`: Référence à la liste (Integer, FK)
- `user_id`: Référence à l'utilisateur (Integer, FK)
- `contribution_id`: Référence à la cotisation utilisée (Integer, FK, optional)
- `recorded_by_id`: Admin/bénévole enregistreur (Integer, FK)
- `entry_time`: Date et heure d'entrée (DateTime)
- `exit_time`: Date et heure de sortie (DateTime, optional)

#### Associations principales
- `belongs_to :attendance_list`: Liste de présence associée
- `belongs_to :user`: Utilisateur enregistré
- `belongs_to :contribution, optional: true`: Cotisation utilisée
- `belongs_to :recorded_by, class_name: 'User'`: Utilisateur ayant enregistré

#### Méthodes clés
- `duration_minutes`: Calcule la durée de présence
- `record_exit!(exit_at = Time.current)`: Enregistre le départ

### Modèle `AttendanceStatistic`

#### Attributs principaux
- `id`: Identifiant unique (Integer, PK)
- `attendance_list_id`: Référence à la liste (Integer, FK)
- `total_count`: Nombre total de présences (Integer)
- `unique_users_count`: Nombre d'utilisateurs uniques (Integer)
- `peak_hour`: Heure de pointe (String)
- `peak_hour_count`: Nombre d'entrées à l'heure de pointe (Integer)
- Nombreux compteurs par type de cotisation

#### Associations principales
- `belongs_to :attendance_list`: Liste associée aux statistiques

#### Méthodes clés
- `recalculate!`: Recalcule toutes les statistiques

## Validations clés

### Pour `AttendanceList`
- Une seule liste quotidienne par date
- Transitions d'état uniquement dans l'ordre défini (created → open → closed → archived)
- Nom automatique si non fourni
- La liste doit être ouverte pour permettre l'enregistrement des présences

### Pour `Attendance`
- Liste doit être ouverte pour enregistrement
- Utilisateur doit répondre aux conditions d'accès
- Unicité utilisateur par liste
- Heure de sortie doit être après heure d'entrée

### Pour `AttendanceStatistic`
- Valeurs numériques positives ou nulles
- Date de calcul obligatoire

## Services et Jobs

### Service d'enregistrement des présences

Le service `AttendanceRegistrationService` encapsule la logique d'enregistrement des présences:

```ruby
# Structure simplifiée
class AttendanceRegistrationService
  def initialize(attendance_list, user, recorded_by)
    # Initialise le service avec les paramètres nécessaires
  end
  
  def register
    # Vérifie les conditions d'accès
    # Recherche la cotisation à utiliser selon la priorité
    # Enregistre la présence
    # Décompte une entrée si applicable
  end
end
```

### Jobs automatisés

1. `AttendanceListOpeningJob`: Ouverture automatique des listes quotidiennes
2. `AttendanceListClosingJob`: Clôture automatique des listes quotidiennes
3. `AttendanceStatisticsCalculationJob`: Calcul des statistiques après clôture

## Intégration avec les autres domaines

### Intégration avec le domaine Adhésion
- Vérification de la validité de l'adhésion via `User#has_valid_cirque_membership?`
- Alertes automatiques pour adhésions expirant prochainement
- Redirection vers le processus de renouvellement si nécessaire

### Intégration avec le domaine Cotisation
- Utilisation de `ContributionUsageService.record_usage` pour décompter les entrées
- Sélection automatique de la cotisation selon la priorité définie
- Alertes pour carnets presque épuisés

### Intégration avec le domaine Paiement
- Interface pour l'achat de Pass Journée à l'entrée
- Calcul et enregistrement des statistiques de vente

## API et routes

```ruby
# Principales routes pour le domaine Présence
resources :attendance_lists do
  member do
    post :open
    post :close
  end
  resources :attendances, only: [:index, :create, :show, :update] do
    member do
      post :record_exit
    end
  end
  resource :statistics, only: [:show]
end

get 'attendances/user/:user_id', to: 'attendances#user_history'
get 'statistics/daily', to: 'statistics#daily'
get 'statistics/monthly', to: 'statistics#monthly'
```

## Sécurité

Les autorisations sont gérées via un système de politiques strictes:

- **Membres**: Consultation de leur propre historique uniquement
- **Bénévoles**: Gestion des listes du jour, enregistrement des entrées
- **Administrateurs**: Accès complet avec possibilité de modification

## Points d'attention pour les développeurs
1. Les listes quotidiennes sont créées automatiquement via une tâche cron
2. La vérification des droits d'accès doit être effectuée à chaque tentative d'enregistrement
3. La priorité d'utilisation des cotisations est implémentée dans le service d'enregistrement
4. Les statistiques sont générées automatiquement à la clôture des listes

---

*Document créé le [DATE] - Version 1.0* 