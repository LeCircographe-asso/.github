# Workflows Administratifs - Le Circographe

Ce document décrit les workflows administratifs du Circographe, c'est-à-dire les processus métier qui impliquent des actions administratives. Ces workflows sont conçus pour garantir la cohérence des opérations et faciliter la gestion de l'association.

## Gestion des adhésions

### Processus d'adhésion

```mermaid
flowchart TD
    A[Demande d'adhésion] --> B{Formulaire complet?}
    B -->|Non| C[Demande de complétion]
    C --> A
    B -->|Oui| D[Vérification des informations]
    D --> E{Informations valides?}
    E -->|Non| F[Demande de correction]
    F --> A
    E -->|Oui| G[Création de l'adhésion]
    G --> H[Génération du paiement]
    H --> I{Paiement effectué?}
    I -->|Non| J[Relance de paiement]
    J --> I
    I -->|Oui| K[Validation de l'adhésion]
    K --> L[Envoi de la carte de membre]
    L --> M[Fin du processus]
```

#### Étapes détaillées

1. **Demande d'adhésion**
   - Le membre remplit le formulaire d'adhésion en ligne
   - Le système vérifie automatiquement la complétude du formulaire

2. **Vérification des informations**
   - L'administrateur vérifie les informations fournies
   - Vérification de l'âge, de l'adresse, etc.

3. **Création de l'adhésion**
   - Création de l'adhésion avec statut "En attente"
   - Attribution d'un numéro de membre

4. **Gestion du paiement**
   - Génération d'une facture pour l'adhésion
   - Suivi du paiement
   - Relances automatiques si nécessaire

5. **Validation de l'adhésion**
   - Changement du statut de l'adhésion à "Active"
   - Mise à jour des droits d'accès du membre

6. **Finalisation**
   - Envoi de la carte de membre (physique ou numérique)
   - Envoi d'un email de bienvenue

### Processus de renouvellement

```mermaid
flowchart TD
    A[Détection d'adhésion à renouveler] --> B[Notification au membre]
    B --> C{Membre souhaite renouveler?}
    C -->|Non| D[Fin de l'adhésion]
    C -->|Oui| E[Création du renouvellement]
    E --> F[Génération du paiement]
    F --> G{Paiement effectué?}
    G -->|Non| H[Relance de paiement]
    H --> G
    G -->|Oui| I[Validation du renouvellement]
    I --> J[Mise à jour de la date de fin]
    J --> K[Notification de confirmation]
    K --> L[Fin du processus]
```

#### Étapes détaillées

1. **Détection des adhésions à renouveler**
   - Tâche planifiée qui s'exécute quotidiennement
   - Identifie les adhésions qui expirent dans les 30 jours

2. **Notification aux membres**
   - Envoi d'emails automatiques à J-30, J-15 et J-7
   - Notification dans l'application

3. **Création du renouvellement**
   - Le membre confirme son souhait de renouveler
   - Création d'une nouvelle période d'adhésion

4. **Gestion du paiement**
   - Génération d'une facture pour le renouvellement
   - Suivi du paiement
   - Relances automatiques si nécessaire

5. **Validation du renouvellement**
   - Mise à jour de la date de fin de l'adhésion
   - Maintien des droits d'accès du membre

## Gestion des cotisations

### Processus d'achat de cotisation

```mermaid
flowchart TD
    A[Demande d'achat] --> B{Adhésion active?}
    B -->|Non| C[Redirection vers adhésion]
    B -->|Oui| D[Sélection de la formule]
    D --> E[Calcul du tarif]
    E --> F[Génération du paiement]
    F --> G{Paiement effectué?}
    G -->|Non| H[Annulation de la demande]
    G -->|Oui| I[Création de la cotisation]
    I --> J[Mise à jour des droits d'accès]
    J --> K[Notification de confirmation]
    K --> L[Fin du processus]
```

#### Étapes détaillées

1. **Vérification de l'adhésion**
   - Vérification que le membre a une adhésion active
   - Redirection vers le processus d'adhésion si nécessaire

2. **Sélection de la formule**
   - Le membre choisit la formule souhaitée
   - Le système calcule le tarif applicable (normal ou réduit)

3. **Gestion du paiement**
   - Génération d'une facture pour la cotisation
   - Suivi du paiement
   - Annulation automatique si non-paiement après 24h

4. **Création de la cotisation**
   - Enregistrement de la cotisation avec les dates de validité
   - Mise à jour des droits d'accès du membre

## Gestion des présences

### Processus de pointage

```mermaid
flowchart TD
    A[Arrivée du membre] --> B[Scan de la carte]
    B --> C{Membre identifié?}
    C -->|Non| D[Recherche manuelle]
    D --> E{Membre trouvé?}
    E -->|Non| F[Création d'un incident]
    E -->|Oui| G[Vérification des droits]
    C -->|Oui| G
    G --> H{Droits valides?}
    H -->|Non| I[Notification du problème]
    I --> J[Résolution du problème]
    J --> G
    H -->|Oui| K[Enregistrement de l'entrée]
    K --> L[Mise à jour du compteur]
    L --> M[Fin du processus]
```

#### Étapes détaillées

1. **Identification du membre**
   - Scan de la carte de membre ou QR code
   - Recherche manuelle si nécessaire

2. **Vérification des droits**
   - Vérification de l'adhésion active
   - Vérification de la cotisation valide pour l'activité
   - Vérification des restrictions éventuelles

3. **Enregistrement de la présence**
   - Horodatage de l'entrée
   - Mise à jour du compteur de présences
   - Notification à l'administrateur si la capacité maximale est atteinte

### Processus de gestion des activités

```mermaid
flowchart TD
    A[Planification de l'activité] --> B[Création dans le système]
    B --> C[Publication aux membres]
    C --> D{Inscriptions nécessaires?}
    D -->|Non| E[Activité en accès libre]
    D -->|Oui| F[Ouverture des inscriptions]
    F --> G[Suivi des inscriptions]
    G --> H{Capacité atteinte?}
    H -->|Oui| I[Fermeture des inscriptions]
    H -->|Non| G
    I --> J[Gestion de la liste d'attente]
    E --> K[Jour de l'activité]
    J --> K
    K --> L[Pointage des présences]
    L --> M[Clôture de l'activité]
    M --> N[Génération des statistiques]
    N --> O[Fin du processus]
```

## Gestion financière

### Processus de suivi des paiements

```mermaid
flowchart TD
    A[Réception d'un paiement] --> B[Identification du membre]
    B --> C[Identification de l'objet]
    C --> D{Type de paiement?}
    D -->|Adhésion| E[Association à l'adhésion]
    D -->|Cotisation| F[Association à la cotisation]
    D -->|Don| G[Enregistrement du don]
    E --> H[Validation du paiement]
    F --> H
    G --> H
    H --> I[Émission du reçu]
    I --> J{Don?}
    J -->|Oui| K[Émission du reçu fiscal]
    J -->|Non| L[Fin du processus]
    K --> L
```

### Processus de gestion des impayés

```mermaid
flowchart TD
    A[Détection d'un impayé] --> B[Première relance]
    B --> C{Paiement effectué?}
    C -->|Oui| D[Clôture de l'incident]
    C -->|Non| E[Deuxième relance]
    E --> F{Paiement effectué?}
    F -->|Oui| D
    F -->|Non| G[Relance téléphonique]
    G --> H{Paiement effectué?}
    H -->|Oui| D
    H -->|Non| I[Suspension des droits]
    I --> J{Résolution sous 30 jours?}
    J -->|Oui| K[Réactivation des droits]
    K --> D
    J -->|Non| L[Résiliation définitive]
    L --> M[Fin du processus]
```

## Gestion des rapports

### Processus de génération des rapports

```mermaid
flowchart TD
    A[Planification du rapport] --> B{Type de rapport?}
    B -->|Financier| C[Extraction des données financières]
    B -->|Fréquentation| D[Extraction des données de présence]
    B -->|Adhésions| E[Extraction des données d'adhésion]
    C --> F[Application des filtres]
    D --> F
    E --> F
    F --> G[Génération du rapport]
    G --> H[Sauvegarde du rapport]
    H --> I[Notification aux destinataires]
    I --> J{Diffusion automatique?}
    J -->|Oui| K[Envoi par email]
    J -->|Non| L[Stockage pour consultation]
    K --> M[Fin du processus]
    L --> M
```

## Ressources supplémentaires

- [Règles métier globales](business_rules.md) - Règles fondamentales régissant l'application
- [Critères de validation](validation_criteria.md) - Critères de validation pour chaque entité
- [Guide de configuration](configuration.md) - Paramètres de configuration de l'application
- [Guide des rapports](reporting.md) - Génération et interprétation des rapports

---

*Dernière mise à jour: Mars 2023*
