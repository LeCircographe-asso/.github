# Le Circographe - Documentation Officielle 📚

<div align="center">
  <img src="/docs/images/logo.png" alt="Logo Le Circographe" width="200"/>
  <p><i>Une application de gestion complète pour association de cirque</i></p>
  
  ![Version](https://img.shields.io/badge/version-1.3.0-blue)
  ![Rails](https://img.shields.io/badge/Rails-8.0.1-red)
  ![License](https://img.shields.io/badge/license-MIT-green)
</div>

<div align="right">
  <a href="/README.md">⬅️ Retour au projet</a>
</div>

## 🎯 Vue d'ensemble
Le Circographe est une application de gestion complète pour une association de cirque, développée avec Ruby on Rails 8.0.1. Cette documentation couvre l'ensemble des aspects techniques, fonctionnels et organisationnels du projet.

## 🧭 Navigation

- [📘 Guide de démarrage rapide](#guide-de-démarrage-rapide)
- [🏛️ Structure de la documentation](#structure-de-la-documentation)
- [🔄 Domaines métier](#domaines-métier)
- [📋 Guides par cas d'usage](#guides-par-cas-dusage)
- [📝 Contribution](#contribution)
- [📞 Support](#support-et-contact)

## 📘 Guide de démarrage rapide

| Documentation | Description |
|---------------|-------------|
| [🔧 Installation](../docs/architecture/README.md) | Comment installer l'application |
| [🚀 Premier pas](../docs/architecture/README.md) | Guide de prise en main rapide |
| [❓ FAQ](docs/faq.md) | Questions fréquemment posées |

## 🏛️ Structure de la documentation

Notre documentation est organisée de manière hiérarchique pour faciliter la navigation:

### 📁 [Requirements](../docs/architecture/README.md)

- [📁 Métier](../..../../requirements/1_métier/index.md) - Règles et spécifications métier
- [📁 Spécifications Techniques](../docs/architecture/README.md) - Détails d'implémentation
- [📁 User Stories](../docs/architecture/README.md) - Scénarios utilisateur par domaine
- [📁 Implémentation](../docs/architecture/README.md) - Guide d'implémentation

### 📁 [Docs](../docs/glossaire.md)

- [📁 Architecture](../..../../docs/architecture/README.md) - Documentation technique
- [📁 Business](../docs/architecture/README.md) - Documentation métier
- [📁 Utilisateur](../docs/architecture/README.md) - Guides pour les utilisateurs finaux

## 🔄 Domaines métier

Notre application est organisée autour de six domaines métier clairement définis, chacun avec ses propres responsabilités:

<table>
  <tr>
    <th>Domaine</th>
    <th>Description</th>
    <th>Documentation</th>
  </tr>
  <tr>
    <td><strong>Adhésion</strong></td>
    <td>
      Gestion des adhésions Basic et Cirque, incluant:
      <ul>
        <li>Création et renouvellement</li>
        <li>Upgrade Basic → Cirque</li>
        <li>Cycle de vie des adhésions</li>
      </ul>
    </td>
    <td>
      <a href="/requirements/1_métier/adhesion/index.md">Règles métier</a><br>
      <a href="/requirements/3_user_stories/adhesion.md">User stories</a>
    </td>
  </tr>
  <tr>
    <td><strong>Cotisation</strong></td>
    <td>
      Formules d'accès aux entraînements:
      <ul>
        <li>Séances uniques, cartes 10 séances</li>
        <li>Abonnements mensuels et annuels</li>
        <li>Tarifications normale et réduite</li>
      </ul>
    </td>
    <td>
      <a href="/requirements/1_métier/cotisation/index.md">Règles métier</a><br>
      <a href="/requirements/3_user_stories/cotisation.md">User stories</a>
    </td>
  </tr>
  <tr>
    <td><strong>Paiement</strong></td>
    <td>
      Transactions financières:
      <ul>
        <li>Gestion des paiements et reçus</li>
        <li>Traitement des dons et reçus fiscaux</li>
        <li>Rapports financiers</li>
      </ul>
    </td>
    <td>
      <a href="/requirements/1_métier/paiement/index.md">Règles métier</a><br>
      <a href="/requirements/3_user_stories/paiement.md">User stories</a>
    </td>
  </tr>
  <tr>
    <td><strong>Présence</strong></td>
    <td>
      Suivi des entraînements:
      <ul>
        <li>Pointage et contrôle d'accès</li>
        <li>Statistiques de fréquentation</li>
        <li>Gestion de la capacité</li>
      </ul>
    </td>
    <td>
      <a href="/requirements/1_métier/presence/index.md">Règles métier</a><br>
      <a href="/requirements/3_user_stories/presence.md">User stories</a>
    </td>
  </tr>
  <tr>
    <td><strong>Rôles</strong></td>
    <td>
      Gestion des accès:
      <ul>
        <li>Rôles système (permissions)</li>
        <li>Rôles associatifs (fonctions)</li>
        <li>Audit des actions</li>
      </ul>
    </td>
    <td>
      <a href="/requirements/1_métier/roles/index.md">Règles métier</a><br>
      <a href="/requirements/3_user_stories/roles.md">User stories</a>
    </td>
  </tr>
  <tr>
    <td><strong>Notification</strong></td>
    <td>
      Communication automatisée:
      <ul>
        <li>Rappels et confirmations</li>
        <li>Alertes système</li>
        <li>Préférences de notification</li>
      </ul>
    </td>
    <td>
      <a href="/requirements/1_métier/notification/index.md">Règles métier</a><br>
      <a href="/requirements/3_user_stories/notification.md">User stories</a>
    </td>
  </tr>
</table>

## 📋 Guides par cas d'usage

Pour faciliter la navigation, nous proposons des guides par cas d'usage qui traversent les différents domaines:

### 👥 Gestion des membres

<details>
  <summary><strong>Voir les guides et références</strong></summary>
  
  - [Guide complet](docs/utilisateur/guides/membres.md)
  - Domaines associés:
    - [Adhésion](../..../../requirements/1_métier/adhesion/index.md)
    - [Rôles](../..../../requirements/1_métier/roles/index.md)
    - [Notification](../..../../requirements/1_métier/notification/index.md)
</details>

### 💰 Gestion financière

<details>
  <summary><strong>Voir les guides et références</strong></summary>
  
  - [Guide complet](docs/utilisateur/guides/finances.md)
  - Domaines associés:
    - [Paiement](../..../../requirements/1_métier/paiement/index.md)
    - [Adhésion](../..../../requirements/1_métier/adhesion/index.md)
    - [Cotisation](../..../../requirements/1_métier/cotisation/index.md)
</details>

### 📊 Suivi et statistiques

<details>
  <summary><strong>Voir les guides et références</strong></summary>
  
  - [Guide complet](docs/utilisateur/guides/statistiques.md)
  - Domaines associés:
    - [Présence](../..../../requirements/1_métier/presence/index.md)
    - [Paiement](../..../../requirements/1_métier/paiement/index.md)
</details>

## 📝 Contribution

<details>
  <summary><strong>Guide de contribution</strong></summary>
  
  1. Fork le projet
  2. Créer une branche (`git checkout -b feature/AmazingFeature`)
  3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
  4. Push vers la branche (`git push origin feature/AmazingFeature`)
  5. Ouvrir une Pull Request
</details>

<details>
  <summary><strong>Standards de documentation</strong></summary>
  
  - Utiliser le Markdown pour tous les documents
  - Suivre les templates fournis
  - Maintenir les liens entre documents
  - Mettre à jour le glossaire si nécessaire
</details>

## 🏷️ Versions

- v1.0.0 - Version initiale
- v1.1.0 - Ajout gestion des dons
- v1.2.0 - Intégration comptabilité
- v1.3.0 - Réorganisation de la documentation

## 📞 Support et contact

### Support technique
- **Email** : tech@lecirco.org
- **Slack** : #tech-support

### Support métier
- **Email** : business@lecirco.org
- **Slack** : #business-support

---

<div align="center">
  <p>
    <a href="/README.md">⬅️ Retour au projet</a> | 
    <a href="#le-circographe---documentation-officielle-">⬆️ Haut de page</a>
  </p>
  
  <p>Ce projet est sous licence MIT - voir le fichier <a href="/LICENSE.md">LICENSE.md</a> pour plus de détails.</p>
</div> 