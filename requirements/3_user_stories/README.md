# 📖 User Stories - Le Circographe

<div align="right">
  <a href="../README.md">⬅️ Retour aux requirements</a> •
  <a href="../../profile/README.md">📚 Documentation principale</a>
</div>

<p align="center"><i>🧭 Chemin: <a href="../../profile/README.md">Documentation</a> > <a href="../README.md">Requirements</a> > <b>User Stories</b></i></p>

## 🔍 Vue d'ensemble

Ce dossier contient toutes les user stories de l'application, réorganisées par domaine métier pour aligner parfaitement les besoins utilisateurs avec l'architecture fonctionnelle de l'application.

## 📂 Structure

```
3_user_stories/
├── README.md           # Vue d'ensemble et organisation
├── adhesion.md         # Stories liées aux adhésions (Basic et Cirque)
├── cotisation.md       # Stories liées aux formules de cotisation
├── paiement.md         # Stories liées aux paiements et reçus
├── presence.md         # Stories liées au pointage et statistiques
├── roles.md            # Stories liées à la gestion des rôles et permissions
├── notification.md     # Stories liées aux communications automatisées
└── public.md           # Stories pour utilisateurs non connectés
```

## 📋 Format Standard

Chaque user story suit le format :
```
En tant que [ROLE]
Je veux [ACTION]
Afin de [OBJECTIF]

Critères d'acceptation :
1. [CRITERE_1]
2. [CRITERE_2]
...
```

## 🧩 Organisation par Domaine Métier

<table>
  <tr>
    <th>Domaine</th>
    <th>Description</th>
    <th>Lien</th>
  </tr>
  <tr>
    <td><strong>Adhésion</strong></td>
    <td>
      <ul>
        <li>Création et gestion des adhésions</li>
        <li>Renouvellement d'adhésion</li>
        <li>Upgrade d'adhésion (Basic vers Cirque)</li>
      </ul>
    </td>
    <td><a href="./adhesion.md">📄 adhesion.md</a></td>
  </tr>
  <tr>
    <td><strong>Cotisation</strong></td>
    <td>
      <ul>
        <li>Achat et gestion des formules</li>
        <li>Consultation des séances restantes</li>
        <li>Renouvellement des formules</li>
      </ul>
    </td>
    <td><a href="./cotisation.md">📄 cotisation.md</a></td>
  </tr>
  <tr>
    <td><strong>Paiement</strong></td>
    <td>
      <ul>
        <li>Transactions financières</li>
        <li>Génération et consultation des reçus</li>
        <li>Gestion des remboursements</li>
      </ul>
    </td>
    <td><a href="./paiement.md">📄 paiement.md</a></td>
  </tr>
  <tr>
    <td><strong>Présence</strong></td>
    <td>
      <ul>
        <li>Pointage aux entraînements</li>
        <li>Consultation des listes de présence</li>
        <li>Statistiques de fréquentation</li>
      </ul>
    </td>
    <td><a href="./presence.md">📄 presence.md</a></td>
  </tr>
  <tr>
    <td><strong>Rôles</strong></td>
    <td>
      <ul>
        <li>Attribution des rôles système</li>
        <li>Gestion des permissions</li>
        <li>Rôles associatifs</li>
      </ul>
    </td>
    <td><a href="./roles.md">📄 roles.md</a></td>
  </tr>
  <tr>
    <td><strong>Notification</strong></td>
    <td>
      <ul>
        <li>Rappels d'échéance</li>
        <li>Confirmations de transaction</li>
        <li>Préférences de communication</li>
      </ul>
    </td>
    <td><a href="./notification.md">📄 notification.md</a></td>
  </tr>
  <tr>
    <td><strong>Public</strong></td>
    <td>
      <ul>
        <li>Création de compte</li>
        <li>Consultation des informations publiques</li>
        <li>Contact et demandes</li>
      </ul>
    </td>
    <td><a href="./public.md">📄 public.md</a></td>
  </tr>
</table>

## 🎯 Priorités

<details>
  <summary><strong>Niveaux de priorité des user stories</strong></summary>

### P0 - Critique
- Inscription et authentification
- Gestion des adhésions
- Pointage présence
- Paiements de base

### P1 - Important
- Gestion des cotisations
- Attribution des rôles
- Statistiques basiques
- Notifications essentielles

### P2 - Utile
- Rapports avancés
- Export de données
- Personnalisation
- Fonctionnalités secondaires
</details>

## ✅ Validation

Chaque domaine possède ses propres critères d'acceptation détaillés dans le fichier correspondant, alignés avec les critères définis dans les fichiers `validation.md` de chaque domaine métier.

## 🔄 Mapping avec les anciens fichiers

<details>
  <summary><strong>Voir la correspondance avec l'ancienne structure</strong></summary>

| Nouveau Document | Anciens Documents |
|------------------|-------------------|
| [adhesion.md](docs/business/regles/adhesion.md) | adherent.md (partiellement), user_stories.md (sections adhésion) |
| [cotisation.md](docs/business/regles/cotisation.md) | adherent.md (sections cotisation), user_stories.md (sections cotisation) |
| [paiement.md](docs/business/regles/paiement.md) | adherent.md (sections paiement), benevole.md (validation paiements) |
| [presence.md](docs/business/regles/presence.md) | adherent.md (sections présence), benevole.md (gestion présence) |
| [roles.md](docs/business/regles/roles.md) | admin.md, super_admin.md, benevole.md (sections rôles) |
| [notification.md](docs/business/regles/notification.md) | Extraits de tous les anciens fichiers (sections notifications) |
| [public.md](requirements/3_user_stories/public.md) | public.md (restructuré) |
</details>

## 🔄 Maintenance

<details>
  <summary><strong>Processus de mise à jour</strong></summary>

### 1. Mise à Jour
- Revue régulière des stories par domaine
- Ajout de nouveaux besoins dans le domaine approprié
- Archivage des stories obsolètes

### 2. Documentation
- Maintenir la cohérence avec les fichiers de règles métier
- Documenter les changements
- Tracer les décisions

### 3. Tests
- Aligner les scénarios de test avec les critères dans validation.md
- Vérifier la couverture fonctionnelle
- Documenter les résultats
</details>

---

<div align="center">
  <p>
    <a href="../README.md">⬅️ Retour aux requirements</a> | 
    <a href="#-user-stories---le-circographe">⬆️ Haut de page</a>
  </p>
</div> 