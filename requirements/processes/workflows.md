# Workflows Métier

## Processus d'Adhésion
```mermaid
graph TD
    A[Utilisateur] -->|Inscription site| B[Compte créé]
    B -->|Sur place| C[Choix adhésion]
    C -->|1€| D[Basic]
    C -->|10€/7€| E[Circus]
    D -->|Upgrade 9€/6€| E
```

## Processus de Paiement
```mermaid
graph TD
    A[Paiement] -->|Vérification| B{Type}
    B -->|Adhésion| C[Basic/Circus]
    B -->|Abonnement| D[Pack séances]
    B -->|Donation| E[Don libre]
    C --> F[Reçu]
    D --> F
    E --> F
```

## Processus d'Entraînement
```mermaid
graph TD
    A[Ouverture] -->|Bénévole| B[Pointage]
    B -->|Adhérent Circus| C[Accès]
    B -->|Non autorisé| D[Refus]
    C --> E[Fermeture]
```

## Règles de Transition
1. Utilisateur → Adhérent
   - Inscription validée
   - Paiement effectué
   - Sur place uniquement

2. Basic → Circus
   - Adhésion Basic active
   - Paiement upgrade
   - Sur place uniquement

3. Adhérent → Bénévole
   - Adhésion active requise
   - Validation admin 