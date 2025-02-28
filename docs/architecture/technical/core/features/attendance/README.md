# Documentation Technique - Système de Présence

## Vue d'ensemble
Le système de présence permet de gérer plusieurs types de listes en parallèle avec une interface Hotwire/Stimulus pour une expérience fluide.

## Points Clés
- Création automatique des listes d'entraînement
- Interface temps réel avec Turbo
- Validation des droits et adhésions
- Décompte intelligent des séances

## Structure Technique
- Modèles : `DailyAttendanceList`, `Attendance`
- Controllers : `AttendancesController`
- Jobs : `CreateDailyAttendanceListJob`
- Vues Turbo et Stimulus

## Documentation Détaillée
- [Implémentation Technique](./implementation.md)
- [Règles Métier](../../requirements/1_métier/presence/systeme.md)

## Interfaces
- Scan de carte ou recherche par nom
- Validation automatique des droits
- Vue en temps réel des présents
- Export de données

## Sécurité
- Validation des permissions
- Protection contre les doublons
- Journalisation des modifications

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