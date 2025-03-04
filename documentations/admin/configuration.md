# Guide de Configuration - Le Circographe

Ce document détaille les différentes options de configuration disponibles pour les administrateurs du Circographe. Il couvre les paramètres système, les règles métier configurables et les options de personnalisation.

## Paramètres système

### Configuration générale

| Paramètre | Description | Valeurs possibles | Valeur par défaut |
|-----------|-------------|-------------------|-------------------|
| `nom_association` | Nom de l'association | Texte | "Le Circographe" |
| `email_contact` | Email de contact principal | Email valide | "contact@circographe.org" |
| `telephone_contact` | Téléphone de contact | Format international | "+33123456789" |
| `adresse_siege` | Adresse du siège social | Texte | "123 Rue du Cirque, 75001 Paris" |
| `fuseau_horaire` | Fuseau horaire de l'application | Valeur IANA | "Europe/Paris" |
| `langue_principale` | Langue principale de l'interface | Code ISO | "fr" |

### Configuration des emails

| Paramètre | Description | Valeurs possibles | Valeur par défaut |
|-----------|-------------|-------------------|-------------------|
| `expediteur_email` | Adresse d'expédition des emails | Email valide | "noreply@circographe.org" |
| `nom_expediteur` | Nom d'affichage de l'expéditeur | Texte | "Le Circographe" |
| `signature_email` | Signature ajoutée aux emails | Texte HTML | "L'équipe du Circographe" |
| `copie_emails` | Adresses en copie des emails | Liste d'emails | [] |

### Configuration des notifications

| Paramètre | Description | Valeurs possibles | Valeur par défaut |
|-----------|-------------|-------------------|-------------------|
| `notifications_adhesion` | Notifications pour les adhésions | true/false | true |
| `notifications_cotisation` | Notifications pour les cotisations | true/false | true |
| `notifications_paiement` | Notifications pour les paiements | true/false | true |
| `notifications_presence` | Notifications pour les présences | true/false | true |
| `delai_rappel_adhesion` | Délai de rappel avant expiration (jours) | Entier | 30 |
| `frequence_rappel_adhesion` | Fréquence des rappels (jours) | Entier | 7 |

## Règles métier configurables

### Configuration des adhésions

| Paramètre | Description | Valeurs possibles | Valeur par défaut |
|-----------|-------------|-------------------|-------------------|
| `duree_adhesion` | Durée d'une adhésion (jours) | Entier | 365 |
| `age_minimum_adhesion` | Âge minimum pour adhérer | Entier | 16 |
| `montant_adhesion_basic` | Montant de l'adhésion Basic (€) | Décimal | 20.00 |
| `montant_adhesion_cirque` | Montant de l'adhésion Cirque (€) | Décimal | 30.00 |
| `delai_paiement_adhesion` | Délai de paiement (jours) | Entier | 7 |
| `validation_automatique` | Validation automatique après paiement | true/false | true |

### Configuration des cotisations

| Paramètre | Description | Valeurs possibles | Valeur par défaut |
|-----------|-------------|-------------------|-------------------|
| `montant_seance_unique` | Prix d'une séance unique (€) | Décimal | 15.00 |
| `montant_carte_10` | Prix d'une carte 10 séances (€) | Décimal | 120.00 |
| `montant_abonnement_mensuel` | Prix d'un abonnement mensuel (€) | Décimal | 50.00 |
| `montant_abonnement_annuel` | Prix d'un abonnement annuel (€) | Décimal | 450.00 |
| `reduction_tarif_reduit` | Pourcentage de réduction tarif réduit (%) | Décimal | 20.00 |
| `validite_carte_10` | Durée de validité carte 10 séances (jours) | Entier | 180 |

### Configuration des présences

| Paramètre | Description | Valeurs possibles | Valeur par défaut |
|-----------|-------------|-------------------|-------------------|
| `capacite_maximale` | Capacité maximale par défaut | Entier | 30 |
| `duree_seance_defaut` | Durée par défaut d'une séance (minutes) | Entier | 120 |
| `delai_inscription` | Délai minimum avant inscription (heures) | Entier | 2 |
| `delai_annulation` | Délai minimum avant annulation (heures) | Entier | 24 |
| `penalite_absence` | Pénalité pour absence non justifiée | true/false | true |

### Configuration des paiements

| Paramètre | Description | Valeurs possibles | Valeur par défaut |
|-----------|-------------|-------------------|-------------------|
| `modes_paiement` | Modes de paiement acceptés | Liste | ["cb", "virement", "cheque", "especes"] |
| `delai_encaissement` | Délai d'encaissement (jours) | Entier | 3 |
| `generation_recus` | Génération automatique des reçus | true/false | true |
| `generation_factures` | Génération automatique des factures | true/false | true |
| `prefixe_facture` | Préfixe pour les numéros de facture | Texte | "FACT-" |
| `prefixe_recu` | Préfixe pour les numéros de reçu | Texte | "RECU-" |

## Personnalisation de l'interface

### Apparence générale

| Paramètre | Description | Valeurs possibles | Valeur par défaut |
|-----------|-------------|-------------------|-------------------|
| `logo_url` | URL du logo de l'association | URL valide | "/assets/logo.png" |
| `couleur_primaire` | Couleur primaire (thème) | Code hexadécimal | "#4A86E8" |
| `couleur_secondaire` | Couleur secondaire (thème) | Code hexadécimal | "#FF9900" |
| `favicon_url` | URL de l'icône favicon | URL valide | "/assets/favicon.ico" |

### Textes personnalisables

| Paramètre | Description | Valeurs possibles | Valeur par défaut |
|-----------|-------------|-------------------|-------------------|
| `message_accueil` | Message sur la page d'accueil | Texte HTML | "Bienvenue au Circographe" |
| `message_adhesion` | Message sur la page d'adhésion | Texte HTML | "Rejoignez notre association" |
| `conditions_utilisation` | Conditions d'utilisation | Texte HTML | "..." |
| `politique_confidentialite` | Politique de confidentialité | Texte HTML | "..." |

## Comment modifier la configuration

### Via l'interface d'administration

1. Connectez-vous avec un compte administrateur
2. Accédez au menu "Configuration" dans le panneau d'administration
3. Sélectionnez la section à modifier
4. Effectuez vos modifications
5. Cliquez sur "Enregistrer"

### Via le fichier de configuration

Pour les déploiements personnalisés, vous pouvez modifier le fichier `config/application.yml` :

```yaml
# Exemple de configuration personnalisée
production:
  nom_association: "Le Circographe Paris"
  email_contact: "contact@circographe-paris.org"
  montant_adhesion_basic: 25.00
  montant_adhesion_cirque: 35.00
  capacite_maximale: 25
  couleur_primaire: "#336699"
```

## Bonnes pratiques

### Sécurité

- Limitez l'accès à la configuration aux administrateurs de confiance
- Documentez les changements de configuration importants
- Testez les modifications de configuration dans un environnement de test avant de les appliquer en production

### Performance

- Évitez de modifier fréquemment les paramètres qui affectent les calculs financiers
- Planifiez les modifications importantes pendant les périodes de faible activité
- Surveillez l'impact des modifications sur les performances du système

## Ressources supplémentaires

- [Règles métier globales](business_rules.md) - Règles fondamentales régissant l'application
- [Workflows administratifs](workflows.md) - Processus de gestion de l'application
- [Guide des rapports](reporting.md) - Génération et interprétation des rapports
- [Documentation technique](../technical/README.md) - Architecture et implémentation

---

*Dernière mise à jour: Mars 2023*
