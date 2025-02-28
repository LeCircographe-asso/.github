# Vérification des Chemins

## Structure Actuelle
```
/requirements
├── 1_métier/
│   ├── adhesion/
│   ├── cotisation/
│   ├── paiement/
│   ├── presence/
│   ├── roles/
│   └── notification/
├── 2_specifications_techniques/
│   ├── README.md
│   ├── interfaces/
│   ├── modeles.md
│   ├── securite.md
│   ├── performance.md
│   ├── tests.md
│   ├── storage.md
│   └── api/
└── 3_user_stories/
└── 4_implementation/
    └── rails/
```

## Points à Corriger
1. Créer les dossiers API manquants
2. Ajouter les diagrammes référencés
3. Compléter la documentation des templates
4. Standardiser les noms de fichiers

## Structure des Fichiers

## Logique Métier
```
/requirements/1_métier/
├── adhesion/
│   ├── index.md
│   ├── regles.md
│   ├── specs.md
│   └── validation.md
├── cotisation/
│   ├── index.md
│   ├── regles.md
│   ├── specs.md
│   └── validation.md
├── paiement/
│   ├── index.md
│   ├── regles.md
│   ├── specs.md
│   └── validation.md
├── presence/
│   ├── index.md
│   ├── regles.md
│   ├── specs.md
│   └── validation.md
├── roles/
│   ├── index.md
│   ├── regles.md
│   ├── specs.md
│   └── validation.md
└── notification/
    ├── index.md
    ├── regles.md
    ├── specs.md
    └── validation.md
```

## Spécifications Techniques
```
/requirements/2_specifications_techniques/
├── README.md
├── interfaces/
│   ├── README.md
│   ├── admin.md
│   ├── benevole.md
│   └── composants.md
├── api/
│   ├── README.md
│   ├── membership_api.md
│   ├── subscription_api.md
│   ├── payment_api.md
│   ├── attendance_api.md
│   └── notification_api.md
├── modeles.md
├── securite.md
├── performance.md
├── tests.md
└── storage.md
```

## Documentation Technique
```
/docs/architecture/
├── README.md
├── diagrams/
│   ├── README.md
│   ├── membership_states.md
│   ├── subscription_states.md
│   ├── payment_flow.md
│   ├── check_in_flow.md
│   ├── notification_flow.md
│   └── roles_permissions.md
├── templates/
│   ├── README.md
│   ├── payment_receipt.md
│   ├── membership_card.md
│   └── notification_templates.md
└── technical/
    ├── README.md
    ├── api/
    │   ├── README.md
    │   ├── endpoints.md
    │   ├── auth.md
    │   └── versioning.md
    ├── core/
    ├── frontend/
    ├── security/
    └── performance/
``` 