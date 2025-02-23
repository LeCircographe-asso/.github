# Documentation des Diagrammes

## Vue d'ensemble
Cette documentation regroupe les diagrammes illustrant l'architecture et le fonctionnement du Circographe.

## Structure des Diagrammes

### 1. Flux Global (`flow.md`)
- Hiérarchie des rôles utilisateurs (Guest → Admin)
- Cycle de vie des adhésions et cotisations
- Système de paiement et donations
- Gestion des présences et statistiques
- Relations et dépendances entre composants

### 2. Séquences (`sequence/`)
#### Check-in (`check_in.md`)
- Processus de pointage d'un adhérent
- Vérifications :
  * Adhésion Basic valide
  * Adhésion Cirque pour entraînements
  * Cotisation active ou carnet valide
- Gestion des erreurs et notifications

#### Paiement (`payment.md`)
- Processus complet de paiement
- Gestion des tarifs réduits avec justificatifs
- Options de paiement :
  * CB via SumUp
  * Espèces avec reçu
  * Chèque avec bordereau
- Paiements échelonnés (> 50€)
- Donations et reçus fiscaux

### 3. Architecture (`architecture/`)
#### Modèles (`models.md`)
- Structure des données :
  * Users et rôles
  * Memberships (Basic/Cirque)
  * Subscriptions (séance/carnet/abonnement)
  * Payments et installments
  * Attendances et DailyLists
- Relations et dépendances
- Validations métier

### 4. États (`states/`)
#### Liste de Présence (`attendance_list.md`)
- Types de listes :
  * Entraînement (volunteer + admin)
  * Événement (volunteer + admin)
  * Réunion (admin uniquement)
- États : préparation → active → clôturée
- Transitions et validations
- Génération des statistiques

### 5. Composants (`components.md`)
- Architecture complète :
  * Frontend (Hotwire/Stimulus)
  * Backend (Rails 8/Concerns)
  * Services métier
  * Jobs background
  * Stockage (SQLite/Redis)
- Flux de données et interactions
- Monitoring et métriques

## Utilisation

Ces diagrammes servent à :
1. Documenter l'architecture technique
2. Illustrer la logique métier
3. Former les nouveaux développeurs
4. Faciliter la maintenance
5. Guider les évolutions futures

## Maintenance

Pour modifier un diagramme :
1. Utiliser la syntaxe Mermaid
2. Respecter les conventions de nommage
3. Maintenir la cohérence avec le code
4. Vérifier l'alignement avec les requirements
5. Mettre à jour ce README si nécessaire

## Conventions Mermaid

### Couleurs
- Frontend : #f9f (rose)
- Backend : #bbf (bleu)
- Services : #bfb (vert)
- Storage : #fbb (rouge)
- Adhésions : #dfd (vert clair)
- Cotisations : #ffd (jaune)
- Statistiques : #ddf (bleu clair)

### Relations
- `-->` : Dépendance directe
- `-.->` : Dépendance optionnelle
- `==>` : Flux de données
- `o--o` : Association
- `*--*` : Composition 