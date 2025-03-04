# Plan de Migration de la Documentation

Ce document détaille le plan pour migrer le contenu existant vers la nouvelle structure de documentation, avec un focus sur les développeurs et les administrateurs qui définissent les règles métier.

## Vue d'ensemble de la nouvelle structure

```
/documentations/
├── README.md                     # Point d'entrée principal avec navigation claire
├── domains/                      # Documentation des domaines métier
│   ├── adhesion/                 # Chaque domaine a son propre dossier
│   │   ├── README.md             # Spécifications techniques
│   │   ├── rules.md              # Règles métier
│   │   ├── specs.md              # Spécifications détaillées
│   │   └── validation.md         # Critères de validation
│   ├── cotisation/
│   ├── paiement/
│   ├── presence/
│   ├── roles/
│   └── notification/
├── technical/                    # Documentation technique pour développeurs
│   ├── README.md                 # Guide technique principal
│   ├── architecture.md           # Architecture du système
│   ├── models.md                 # Modèles de données et relations
│   ├── api.md                    # Documentation API
│   ├── setup.md                  # Configuration de l'environnement
│   └── workflows.md              # Flux de travail de développement
├── admin/                        # Documentation pour administrateurs
│   ├── business_rules.md         # Règles métier globales
│   ├── validation_criteria.md    # Critères de validation
│   ├── workflows.md              # Workflows administratifs
│   ├── configuration.md          # Guide de configuration
│   └── reporting.md              # Guide des rapports
├── guide/                        # Guides utilisateur (secondaire)
│   ├── admin/                    # Guides pour administrateurs
│   └── member/                   # Guides pour membres
├── assets/                       # Images, diagrammes, etc.
│   ├── diagrams/
│   └── screenshots/
└── glossary.md                   # Glossaire centralisé
```

## Correspondance avec l'ancienne structure

| Contenu existant | Nouvelle destination | Priorité | Statut |
|------------------|----------------------|----------|--------|
| `requirements/README.md` | `documentations/README.md` | Haute | ✅ |
| `requirements/1_métier/index.md` | `documentations/domains/README.md` | Haute | ❌ |
| `requirements/1_métier/adhesion/regles.md` | `documentations/domains/adhesion/rules.md` | Haute | ✅ |
| `requirements/1_métier/adhesion/specs.md` | `documentations/domains/adhesion/specs.md` | Haute | ✅ |
| `requirements/1_métier/adhesion/validation.md` | `documentations/domains/adhesion/validation.md` | Haute | ✅ |
| `requirements/1_métier/cotisation/regles.md` | `documentations/domains/cotisation/rules.md` | Haute | ✅ |
| `requirements/1_métier/cotisation/specs.md` | `documentations/domains/cotisation/specs.md` | Haute | ✅ |
| `requirements/1_métier/cotisation/validation.md` | `documentations/domains/cotisation/validation.md` | Haute | ✅ |
| `requirements/2_specifications_techniques/*` | `documentations/technical/*.md` | Haute | ❌ |
| `requirements/4_implementation/*` | `documentations/technical/*.md` | Haute | ❌ |
| `docs/architecture/*` | `documentations/technical/*.md` | Haute | ❌ |
| `docs/glossaire/README.md` | `documentations/glossary.md` | Moyenne | ✅ |
| `docs/utilisateur/README.md` | `documentations/guide/README.md` | Basse | ❌ |
| `docs/utilisateur/guides/*_admin.md` | `documentations/guide/admin/*.md` | Basse | ❌ |
| `docs/utilisateur/guides/*_membre.md` | `documentations/guide/member/*.md` | Basse | ❌ |
| `docs/images/*` | `documentations/assets/screenshots/*` | Moyenne | ❌ |

## Étapes de migration

### Phase 1: Préparation et structure (Priorité Haute)

1. **Créer la structure de base** ✅
   - Créer tous les dossiers nécessaires
   - Créer les fichiers README.md principaux

2. **Analyser le contenu existant**
   - Identifier tous les fichiers à migrer
   - Déterminer les correspondances exactes

### Phase 2: Migration du contenu technique (Priorité Haute)

1. **Migrer la documentation technique**
   ```bash
   cp docs/architecture/* documentations/technical/
   cp requirements/2_specifications_techniques/* documentations/technical/
   cp requirements/4_implementation/* documentations/technical/
   ```

2. **Créer/Mettre à jour le README.md technique**
   - Utiliser le modèle de `documentations/technical/README.md`
   - Intégrer les informations techniques existantes

3. **Migrer les règles métier globales**
   ```bash
   # Créer à partir des règles existantes
   touch documentations/admin/business_rules.md
   ```

### Phase 3: Migration des domaines métier (Priorité Haute)

Pour chaque domaine métier (adhésion, cotisation, paiement, présence, rôles, notification):

1. **Migrer les règles métier** ✅ (Adhésion, Cotisation)
   ```bash
   cp requirements/1_métier/[domaine]/regles.md documentations/domains/[domaine]/rules.md
   ```

2. **Migrer les spécifications techniques** ✅ (Adhésion, Cotisation)
   ```bash
   cp requirements/1_métier/[domaine]/specs.md documentations/domains/[domaine]/specs.md
   ```

3. **Migrer les critères de validation** ✅ (Adhésion, Cotisation)
   ```bash
   cp requirements/1_métier/[domaine]/validation.md documentations/domains/[domaine]/validation.md
   ```

4. **Créer/Mettre à jour le README.md du domaine** ✅ (Adhésion, Cotisation)
   - Utiliser le modèle de `documentations/domains/adhesion/README.md`
   - Adapter le contenu au domaine spécifique

### Phase 4: Migration des ressources (Priorité Moyenne)

1. **Migrer le glossaire**
   ```bash
   cp docs/glossaire/README.md documentations/glossary.md
   ```

2. **Migrer les images et diagrammes**
   ```bash
   cp docs/images/* documentations/assets/screenshots/
   # Identifier et copier les diagrammes depuis diverses sources
   ```

### Phase 5: Migration de la documentation utilisateur (Priorité Basse)

1. **Migrer les guides administrateur**
   ```bash
   cp docs/utilisateur/guides/*_admin.md documentations/guide/admin/
   # Renommer les fichiers pour supprimer le suffixe _admin
   ```

2. **Migrer les guides membre**
   ```bash
   cp docs/utilisateur/guides/*_membre.md documentations/guide/member/
   # Renommer les fichiers pour supprimer le suffixe _membre
   ```

### Phase 6: Mise à jour des liens et finalisation

1. **Mettre à jour tous les liens internes**
   - Parcourir tous les fichiers markdown
   - Mettre à jour les liens pour qu'ils pointent vers la nouvelle structure

2. **Vérifier les liens**
   - Tester tous les liens pour s'assurer qu'ils fonctionnent correctement

3. **Basculer vers la nouvelle structure**
   ```bash
   mv docs docs_old
   mv requirements requirements_old
   mv documentations docs
   ```

## Conseils pour la migration

- **Prioriser le contenu technique**: Commencer par migrer la documentation technique et les domaines métier
- **Procéder par domaine**: Migrer un domaine complet à la fois
- **Tester régulièrement**: Vérifier que les liens fonctionnent après chaque étape
- **Conserver l'ancienne structure**: Ne pas supprimer l'ancienne structure avant d'être sûr que tout fonctionne
- **Utiliser Git**: Committer après chaque étape importante pour pouvoir revenir en arrière si nécessaire

---

*Dernière mise à jour: Mars 2023* 