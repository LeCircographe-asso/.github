# Système de Présence

## Principes de Base
- Une liste de présence unique est créée automatiquement chaque jour (sauf lundi)
- Le Circographe est fermé tous les lundis
- Pas de notion de créneaux horaires dans le système de présence
- Un adhérent ne peut être pointé qu'une seule fois par jour

## Types d'Adhérents
1. **Adhérent Basic**
   - Peut être ajouté à la liste de présence
   - Pas de décompte de séances

2. **Adhérent Cirque**
   - Peut être ajouté à la liste de présence
   - Décompte des séances si abonnement de type "pack"

## Rôles et Permissions
1. **Bénévole**
   - Voir la liste du jour
   - Ajouter un adhérent à la liste
   - Voir l'historique récent (2 semaines)

2. **Administrateur**
   - Toutes les permissions bénévole
   - Voir l'historique complet
   - Modifier/supprimer des entrées
   - Exporter les données

## Processus de Pointage
1. Le bénévole accueille l'adhérent
2. Vérifie son adhésion (Basic ou Cirque)
3. Vérifie son abonnement si nécessaire
4. Ajoute l'adhérent à la liste du jour
5. Le système :
   - Vérifie que l'adhérent n'est pas déjà pointé
   - Décompte une séance si applicable
   - Enregistre qui a effectué le pointage 