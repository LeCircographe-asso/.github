# Gestion des Erreurs

## Erreurs Utilisateur
### Adhésions
- Adhésion déjà active
- Adhésion expirée
- Type d'adhésion invalide (Basic/Cirque uniquement)
- Justificatif manquant/invalide (étudiant, RSA, mineurs)
- Chevauchement de dates
- Adhésion Basic manquante pour Cirque

### Cotisations
- Adhésion Cirque requise manquante
- Type de cotisation invalide :
  * Séance unique (4€, jour même)
  * Carnet de 10 séances
  * Trimestriel (3 mois)
  * Annuel (12 mois)
- Paiement incorrect
- Quota de séances dépassé
- Nombre de séances négatif

### Listes de Présence
- Présence déjà enregistrée sur la liste
- Accès non autorisé à la liste (Reunion = admin uniquement)
- Adhésion/cotisation invalide pour la liste
- Liste de présence clôturée
- Type de liste invalide (Entraînement Libre/Evènement/Reunion)

### Paiements
- Montant incorrect
- Méthode de paiement invalide (SumUp/espèces/chèque uniquement)
- Reçu non généré
- Transaction incomplète
- Double paiement détecté

## Erreurs Système
### Base de données
- Indisponible
- Erreur d'intégrité (relations)
- Timeout
- Conflit de verrou
- Erreur de concurrence
- Doublon détecté
- Contrainte unique violée

### Services
- Paiement indisponible (SumUp)
- Email non envoyé
- Cache invalide
- File d'attente pleine
- Erreur de synchronisation
- PDF non généré

### Traçabilité
- Journalisation incomplète
- Audit manquant
- Suivi des corrections impossible
- Historique des accès incomplet
- Alertes de sécurité non envoyées
- Logs de paiement manquants
- Traces de présence incomplètes

## Gestion et Récupération
### Actions Automatiques
- Correction des données impossible
- Nettoyage des doublons échoué
- Notification des admins échouée
- Sauvegarde échouée
- Restauration impossible

### Documentation
- Erreurs fréquentes
- Solutions proposées
- Procédures de correction
- Contact support
- Guide de dépannage 