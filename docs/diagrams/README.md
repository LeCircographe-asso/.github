# Documentation des Diagrammes

## Vue d'ensemble
Cette documentation regroupe les différents diagrammes illustrant l'architecture et le fonctionnement du système.

## Structure des Diagrammes

### 1. Flux Global (`flow.md`)
- Représente la hiérarchie des utilisateurs
- Montre les relations entre adhésions et présences
- Illustre les permissions des différents rôles

### 2. Séquences (`sequence/`)
#### Check-in (`check_in.md`)
- Processus de pointage d'un adhérent
- Vérifications effectuées
- Gestion des erreurs

#### Paiement (`payment.md`)
- Processus de paiement complet
- Gestion des tarifs réduits
- Traitement des dons
- Génération des reçus

### 3. Architecture (`architecture/`)
#### Modèles (`models.md`)
- Structure des données
- Relations entre les modèles
- Attributs principaux
- Méthodes clés

### 4. États (`states/`)
#### Liste de Présence (`attendance_list.md`)
- Cycle de vie d'une liste
- États possibles
- Transitions autorisées

### 5. Composants (`components.md`)
- Architecture globale de l'application
- Organisation des services
- Flux de données
- Interactions entre composants

## Utilisation

Ces diagrammes servent à :
1. Comprendre le système
2. Former les nouveaux développeurs
3. Documenter les choix d'architecture
4. Faciliter la maintenance

## Maintenance

Pour modifier un diagramme :
1. Utiliser la syntaxe Mermaid
2. Respecter les conventions de nommage
3. Mettre à jour ce README si nécessaire
4. Vérifier la cohérence avec les autres diagrammes 