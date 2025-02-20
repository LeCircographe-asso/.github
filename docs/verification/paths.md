# Vérification des Chemins

## Structure Actuelle
```
/requirements
├── 1_logique_metier/
│   ├── adhesions/
│   ├── systeme.md
│   ├── tarifs.md
│   └── reductions.md
│   └── presence/
│   └── paiements/
│   └── systeme.md
│   └── reglements.md
├── 2_specifications_techniques/
│   ├── architecture/
│   └── modeles/
│   └── services.md
└── 3_user_stories/
└── 4_implementation/
    └── rails/
```

## Points à Corriger
1. Déplacer `paiements/tarifs.md` vers `adhesions/`
2. Créer `modeles/receipt.rb`
3. Ajouter les tests manquants dans `spec/services/` 

## Structure des Fichiers

## Logique Métier
```
/requirements/1_logique_metier/
├── adhesions/
│   ├── systeme.md
│   ├── tarifs.md
│   └── reductions.md
├── presence/
│   ├── systeme.md
│   └── regles.md
└── paiements/
    ├── systeme.md
    └── reglements.md
```

## Spécifications Techniques
```
/requirements/2_specifications_techniques/
├── architecture/
│   ├── modeles.md
│   └── services.md
└── modeles/
    ├── user.rb
    ├── membership.rb
    ├── payment.rb
    └── receipt.rb
```

## Tests
```
/requirements/4_implementation/rails/spec/
├── models/
│   └── receipt_spec.rb
└── services/
    └── receipt_service_spec.rb
``` 