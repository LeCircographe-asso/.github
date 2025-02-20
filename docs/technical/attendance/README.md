# Documentation Technique - Système de Présence

## Vue d'ensemble
Le système de présence du Circographe est volontairement simple :
- Une liste unique par jour
- Pas de créneaux horaires
- Fermé le lundi

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