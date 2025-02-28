# Scripts Utilitaires - Le Circographe

Ce dossier contient des scripts utilitaires pour faciliter la maintenance et l'amélioration de la documentation du projet Le Circographe.

## Scripts Disponibles

### Vérification des Liens Cassés

Le script `check_broken_links.rb` permet de vérifier et de corriger automatiquement les liens cassés dans la documentation.

#### Utilisation

```bash
# Vérifier les liens cassés sans les corriger
ruby check_broken_links.rb

# Vérifier et tenter de corriger automatiquement les liens cassés
ruby check_broken_links.rb --fix
```

#### Fonctionnalités

- Détecte les liens cassés dans tous les fichiers Markdown
- Suggère des corrections basées sur des patterns connus
- Peut corriger automatiquement les liens en mode `--fix`
- Génère un rapport détaillé des problèmes trouvés

#### Patterns de Correction

Le script corrige automatiquement les patterns suivants :

| Ancien Pattern | Nouveau Pattern |
|----------------|-----------------|
| `/requirements/1_logique_metier/` | `/requirements/1_métier/` |
| `adhesions/` | `adhesion/` |
| `paiements/` | `paiement/` |
| `cotisations/` | `cotisation/` |
| `utilisateurs/` | `roles/` |
| `notifications/` | `notification/` |
| `presences/` | `presence/` |
| `systeme.md` | `regles.md` |
| `tarifs.md` | `regles.md` |
| `reglements.md` | `regles.md` |
| `types.md` | `regles.md` |

## Ajout de Nouveaux Scripts

Pour ajouter un nouveau script utilitaire :

1. Créez le script dans ce dossier
2. Rendez-le exécutable avec `chmod +x nom_du_script`
3. Documentez-le dans ce README
4. Ajoutez des commentaires explicatifs dans le script lui-même

## Bonnes Pratiques

- Tous les scripts doivent inclure une aide (`--help`)
- Les scripts doivent être idempotents (pouvoir être exécutés plusieurs fois sans effet secondaire)
- Privilégier les scripts qui peuvent fonctionner en mode "dry-run" (simulation)
- Documenter clairement les modifications que le script va effectuer

---

*Dernière mise à jour : Février 2024* 