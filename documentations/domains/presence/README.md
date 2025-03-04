# Domaine Présence

## Vue d'ensemble

Le domaine Présence gère l'enregistrement et le suivi des présences des membres aux entraînements et activités du Circographe. Il permet de valider les conditions d'accès, de générer des statistiques de fréquentation et d'assurer la traçabilité des présences pour des raisons de sécurité et de gestion.

## Fonctionnalités principales

- Gestion des listes de présence quotidiennes
- Gestion des listes d'événements spéciaux
- Validation des conditions d'accès
- Suivi des entrées et sorties
- Génération de statistiques
- Gestion de la capacité des lieux

## Rôles et permissions

- **Administrateur**
  - Création et configuration des listes de présence
  - Gestion complète des listes et des présences
  - Accès aux statistiques détaillées
  - Configuration des paramètres d'accès

- **Bénévole**
  - Enregistrement des présences
  - Consultation des listes du jour
  - Vérification des conditions d'accès
  - Accès aux statistiques basiques

## Documentation technique

- [Spécifications techniques](specs.md)
- [Règles métier](rules.md)
- [Critères de validation](validation.md)

## Intégrations

Le domaine Présence interagit avec :

- **Adhésion** : Vérification des adhésions valides
- **Cotisation** : Validation et décompte des entrées
- **Paiement** : Achat de Pass Journée à l'entrée
- **Notification** : Alertes de capacité et rappels

## Points d'attention

1. **Sécurité**
   - Traçabilité complète des entrées/sorties
   - Validation stricte des conditions d'accès
   - Protection des données personnelles

2. **Performance**
   - Optimisation des requêtes fréquentes
   - Mise en cache des validations d'accès
   - Calcul asynchrone des statistiques

3. **Fiabilité**
   - Gestion robuste des états des listes
   - Validation des transitions d'état
   - Prévention des doublons

## Modèles de données principaux

- `AttendanceList` : Liste de présence
- `Attendance` : Entrée individuelle
- `AttendanceStatistic` : Statistiques de présence

## Workflows principaux

1. **Liste quotidienne**
   ```mermaid
   graph TD
   A[Création automatique] --> B[Ouverture]
   B --> C[Enregistrement présences]
   C --> D[Clôture]
   D --> E[Archivage]
   ```

2. **Enregistrement présence**
   ```mermaid
   graph TD
   A[Identification membre] --> B{Vérification adhésion}
   B -->|Valide| C{Vérification cotisation}
   C -->|Valide| D[Enregistrement entrée]
   B -->|Invalide| E[Refus accès]
   C -->|Invalide| F[Proposition Pass Journée]
   ```

## Maintenance

- Archivage automatique des anciennes listes
- Nettoyage périodique des données temporaires
- Monitoring des erreurs d'accès
- Sauvegarde régulière des données

## Bonnes pratiques

1. **Enregistrement des présences**
   - Vérifier systématiquement les conditions d'accès
   - Utiliser le service d'enregistrement pour la cohérence
   - Gérer les cas particuliers via les exceptions

2. **Gestion des listes**
   - Respecter le cycle de vie des listes
   - Utiliser les jobs automatisés pour les tâches planifiées
   - Maintenir les statistiques à jour

3. **Sécurité**
   - Valider les permissions utilisateur
   - Tracer toutes les opérations sensibles
   - Protéger les données personnelles 