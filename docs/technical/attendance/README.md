# Documentation Technique - Système de Présence

## Vue d'ensemble
Le système de présence permet de gérer plusieurs listes en parallèle :
- Liste d'entraînement quotidienne (automatique)
- Listes additionnelles (réunions, événements)
- Gestion indépendante des présences
- Décompte intelligent des séances

## Types de Liste et Permissions

1. **Entraînement**
   - Création : automatique quotidienne
   - Check-in : Bénévoles et Admins
   - Décompte des séances selon abonnement
   - Titre standardisé

2. **Événement**
   - Création : Admin uniquement
   - Check-in : Bénévoles et Admins
   - Configuration spécifique par événement

3. **Réunion**
   - Création : Admin uniquement
   - Check-in : Admin uniquement
   - Pas de décompte de séances
   - Titre personnalisable

## Gestion des Séances
- Une seule séance décomptée par jour
- Indépendant du nombre de listes
- Priorité à la liste d'entraînement

## Interface Utilisateur
- Vue consolidée des listes du jour
- Création rapide de nouvelles listes
- Pointage simplifié
- Alertes intelligentes

## Modèles
- `DailyAttendanceList` : Liste de présence quotidienne
- `Attendance` : Entrée individuelle dans la liste

## Automatisation
- Tâche CRON quotidienne pour créer la liste du jour
- Pas de création le lundi
- Une seule liste par jour

## Interface Bénévole
- Scan de carte ou recherche par nom
- Validation automatique des droits
- Décompte automatique des séances
- Vue en temps réel des présents

## Rapports
- Export CSV/Excel
- Statistiques de fréquentation
- Historique des pointages 