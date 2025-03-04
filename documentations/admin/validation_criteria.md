# Critères de Validation Globaux - Le Circographe

Ce document définit les critères de validation globaux qui s'appliquent à l'ensemble des entités du système. Ces critères sont utilisés pour garantir la cohérence et l'intégrité des données.

## Principes généraux de validation

### Validation des données utilisateur

Toutes les données saisies par les utilisateurs doivent être validées selon les principes suivants :

1. **Validation côté client** : Première ligne de défense pour améliorer l'expérience utilisateur
2. **Validation côté serveur** : Obligatoire pour garantir la sécurité et l'intégrité des données
3. **Messages d'erreur** : Clairs, précis et orientés solution
4. **Validation contextuelle** : Adaptée au contexte d'utilisation (création, modification, etc.)

### Niveaux de validation

Le système implémente trois niveaux de validation :

| Niveau | Description | Implémentation |
|--------|-------------|----------------|
| **Validation de base** | Vérification du format et de la présence des données | ActiveRecord validations |
| **Validation métier** | Vérification de la cohérence avec les règles métier | Service objects, callbacks |
| **Validation système** | Vérification de l'intégrité du système | Contraintes de base de données |

## Critères de validation par type de données

### Identifiants

- **Format** : Gérés automatiquement par Rails (champ `id` auto-incrémenté par défaut), UUID v4 pour les identifiants externes si nécessaire
- **Unicité** : Garantie automatiquement par ActiveRecord
- **Immuabilité** : Les identifiants ne doivent jamais être modifiés après création

### Chaînes de caractères

- **Noms et prénoms** : 2-50 caractères, lettres, espaces, tirets et apostrophes autorisés
- **Adresses email** : Format RFC 5322, unicité dans le système, vérification par email de confirmation
- **Numéros de téléphone** : Format E.164 ou national, validation selon le pays
- **Mots de passe** : Minimum 12 caractères, au moins une majuscule, une minuscule, un chiffre et un caractère spécial

### Dates et heures

- **Dates** : Format ISO 8601 (YYYY-MM-DD)
- **Heures** : Format 24h (HH:MM)
- **Fuseaux horaires** : Stockés en UTC, affichés dans le fuseau horaire de l'utilisateur
- **Périodes** : Validation que la date de début précède la date de fin

### Valeurs numériques

- **Montants financiers** : Précision à 2 décimales, valeurs positives sauf exceptions documentées
- **Quantités** : Entiers positifs ou nuls
- **Pourcentages** : Valeurs entre 0 et 100, précision à 2 décimales

## Critères de validation par entité

### Membres

| Champ | Critères de validation | Niveau |
|-------|------------------------|--------|
| `email` | Format valide, unicité | Base |
| `nom`, `prenom` | 2-50 caractères | Base |
| `date_naissance` | Date valide, âge ≥ 16 ans | Métier |
| `telephone` | Format valide selon le pays | Base |
| `adresse` | Complétude et cohérence | Métier |

### Adhésions

| Champ | Critères de validation | Niveau |
|-------|------------------------|--------|
| `membre_id` | Existence du membre | Base |
| `type` | Valeur dans l'énumération (`basic`, `cirque`) | Base |
| `date_debut` | Date valide, ≥ date du jour | Métier |
| `date_fin` | Date valide, > date_debut, ≤ date_debut + 1 an | Métier |
| `statut` | Valeur dans l'énumération, cohérence avec les dates | Métier |

### Cotisations

| Champ | Critères de validation | Niveau |
|-------|------------------------|--------|
| `membre_id` | Existence du membre avec adhésion valide | Métier |
| `formule` | Valeur dans l'énumération | Base |
| `tarif` | Valeur dans l'énumération, cohérence avec la formule | Métier |
| `date_debut` | Date valide, ≥ date du jour | Métier |
| `date_fin` | Cohérence avec la formule et date_debut | Métier |

### Paiements

| Champ | Critères de validation | Niveau |
|-------|------------------------|--------|
| `membre_id` | Existence du membre | Base |
| `montant` | > 0, précision à 2 décimales | Base |
| `date_paiement` | Date valide, ≤ date du jour | Métier |
| `mode_paiement` | Valeur dans l'énumération | Base |
| `statut` | Valeur dans l'énumération, transitions valides | Métier |

### Présences

| Champ | Critères de validation | Niveau |
|-------|------------------------|--------|
| `membre_id` | Existence du membre avec adhésion et cotisation valides | Métier |
| `activite_id` | Existence de l'activité | Base |
| `date` | Date valide, cohérence avec l'activité | Métier |
| `heure_arrivee` | Heure valide, ≤ heure_depart | Métier |
| `heure_depart` | Heure valide, ≥ heure_arrivee | Métier |

## Validation des transitions d'état

Certaines entités suivent un cycle de vie avec des transitions d'état spécifiques :

### Adhésions

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│  En attente │─────►│   Active    │─────►│   Expirée   │
└─────────────┘      └─────────────┘      └─────────────┘
       │                    │                    │
       │                    │                    │
       ▼                    ▼                    ▼
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│  Annulée    │      │  Suspendue  │─────►│  Résiliée   │
└─────────────┘      └─────┬───────┘      └─────────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │  Réactivée  │
                    └─────────────┘
```

### Paiements

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│  En attente │─────►│   Validé    │─────►│   Encaissé  │
└─────────────┘      └─────────────┘      └─────────────┘
       │                    │
       │                    │
       ▼                    ▼
┌─────────────┐      ┌─────────────┐
│   Annulé    │      │  Remboursé  │
└─────────────┘      └─────────────┘
```

## Implémentation technique

### Validation ActiveRecord

Exemple de validation pour le modèle `Membre` :

```ruby
class Membre < ApplicationRecord
  validates :email, presence: true, 
                   format: { with: URI::MailTo::EMAIL_REGEXP },
                   uniqueness: { case_sensitive: false }
  
  validates :nom, :prenom, presence: true,
                          length: { minimum: 2, maximum: 50 },
                          format: { with: /\A[a-zA-ZÀ-ÿ\s\-']+\z/ }
  
  validates :date_naissance, presence: true
  validate :age_minimum_requis
  
  private
  
  def age_minimum_requis
    if date_naissance.present? && date_naissance > 16.years.ago.to_date
      errors.add(:date_naissance, "doit correspondre à un âge d'au moins 16 ans")
    end
  end
end
```

### Validation avec Service Objects

Exemple de service object pour la validation d'une adhésion :

```ruby
class AdhesionValidationService
  def initialize(adhesion)
    @adhesion = adhesion
    @errors = []
  end
  
  def valid?
    validate_membre_eligibility
    validate_dates_coherence
    validate_status_transition
    @errors.empty?
  end
  
  def errors
    @errors
  end
  
  private
  
  def validate_membre_eligibility
    membre = @adhesion.membre
    if membre.nil?
      @errors << "Le membre n'existe pas"
    elsif membre.adhesions.active.where.not(id: @adhesion.id).exists?
      @errors << "Le membre a déjà une adhésion active"
    end
  end
  
  def validate_dates_coherence
    if @adhesion.date_debut.nil? || @adhesion.date_fin.nil?
      @errors << "Les dates de début et de fin sont obligatoires"
    elsif @adhesion.date_debut >= @adhesion.date_fin
      @errors << "La date de début doit être antérieure à la date de fin"
    elsif @adhesion.date_fin > @adhesion.date_debut + 1.year
      @errors << "La durée maximale d'une adhésion est d'un an"
    end
  end
  
  def validate_status_transition
    # Logique de validation des transitions d'état
  end
end
```

## Ressources supplémentaires

- [Règles métier globales](business_rules.md) - Règles fondamentales régissant l'application
- [Workflows administratifs](workflows.md) - Processus de gestion de l'application
- [Documentation technique](../technical/README.md) - Architecture et implémentation

---

*Dernière mise à jour: Mars 2023*
