# Règles Métier - Notification

## Identification du document

| Domaine           | Notification                         |
|-------------------|-------------------------------------|
| Version           | 1.0                                 |
| Référence         | REGLE-NOT-2023-01                   |
| Dernière révision | [DATE]                              |

## 1. Définition et objectif

Le domaine des notifications définit l'ensemble des règles et processus liés à la communication avec les membres et utilisateurs du système Circographe. Son objectif est d'assurer une communication efficace, pertinente et non intrusive entre l'association et ses membres, tout en respectant les préférences individuelles et les réglementations sur la protection des données.

## 2. Types de notifications

### 2.1 Classification par importance

| Niveau d'importance | Description                                                   | Exemples                                 |
|---------------------|---------------------------------------------------------------|------------------------------------------|
| Critique            | Information essentielle nécessitant une attention immédiate    | Fermeture d'urgence, modification majeure d'un événement |
| Important           | Information significative mais ne nécessitant pas d'action immédiate | Rappel d'adhésion expirant, nouvel événement |
| Informatif          | Information utile mais non critique                          | Statistiques mensuelles, nouveautés de l'association |
| Optionnel           | Contenu complémentaire, non essentiel au fonctionnement      | Newsletter, conseils d'entraînement |

### 2.2 Classification par canal de communication

| Canal              | Caractéristiques                                              | Utilisations typiques                    |
|--------------------|---------------------------------------------------------------|------------------------------------------|
| Email              | Formel, documenté, peut contenir des attachements             | Confirmations, reçus, informations détaillées |
| Notification in-app | Visible uniquement lors de l'utilisation de l'application     | Alertes système, actions requises dans l'application |
| Push mobile        | Immédiat, visible même hors application                       | Rappels d'événements, informations importantes |
| Courrier postal    | Formel, officiel, accessible à tous                           | Convocations AG, documents officiels (cas exceptionnels uniquement) |

### 2.3 Classification par source

| Source             | Description                                                   | Exemples                                 |
|--------------------|---------------------------------------------------------------|------------------------------------------|
| Système            | Généré automatiquement par le système                         | Confirmations d'actions, rappels d'échéance |
| Administratif      | Émis par les responsables administratifs                      | Annonces officielles, informations sur l'association |
| Événementiel       | Lié aux activités et événements                               | Annonces de cours, ateliers, spectacles  |
| Communautaire      | Généré par l'activité de la communauté                        | Forums, partages, interactions entre membres |

## 3. Règles générales de notification

### 3.1 Principes fondamentaux

| Principe           | Description                                                   |
|--------------------|---------------------------------------------------------------|
| Pertinence         | Chaque notification doit être utile et pertinente pour son destinataire |
| Timing approprié   | Envoi à un moment opportun pour maximiser l'utilité et minimiser la gêne |
| Non-intrusivité    | Respect de la vie privée et des préférences utilisateur       |
| Clarté             | Message clair, concis, avec action attendue explicite si nécessaire |
| Accessibilité      | Contenu accessible quel que soit le handicap éventuel         |

### 3.2 Règles de fréquence et regroupement

| Règle              | Description                                                   |
|--------------------|---------------------------------------------------------------|
| Limite quotidienne | Maximum 2 notifications non critiques par jour par utilisateur |
| Regroupement       | Les notifications similaires doivent être regroupées quand possible |
| Délai minimal      | Au moins 4h entre deux notifications non critiques (sauf opt-in explicite) |
| Plages horaires    | Pas de notifications non urgentes entre 21h et 8h             |
| Jour de repos      | Pas de notifications administratives ou promotionnelles le dimanche |

### 3.3 Règles de consentement et préférences

| Aspect             | Règle                                                         |
|--------------------|---------------------------------------------------------------|
| Opt-in par défaut  | Notifications critiques et importantes activées par défaut    |
| Opt-out possible   | Possibilité de désactiver toutes notifications sauf légales   |
| Granularité        | Contrôle fin par type et canal de notification                |
| Modification       | Interface simple pour modifier les préférences à tout moment  |
| Rappel des choix   | Résumé périodique des préférences actuelles (1 fois par an)   |

## 4. Notifications spécifiques par domaine

### 4.1 Notifications liées aux adhésions

| Événement          | Type          | Canaux par défaut | Délai                               |
|--------------------|---------------|-------------------|-------------------------------------|
| Nouvelle adhésion  | Important     | Email, In-app     | Immédiat après confirmation         |
| Adhésion expirant  | Important     | Email, Push       | 30, 15 et 5 jours avant expiration  |
| Adhésion expirée   | Important     | Email, In-app     | Le jour de l'expiration             |
| Renouvellement     | Important     | Email             | Immédiat après confirmation         |

### 4.2 Notifications liées aux cotisations

| Événement                 | Type          | Canaux par défaut | Délai                               |
|---------------------------|---------------|-------------------|-------------------------------------|
| Achat cotisation          | Important     | Email, In-app     | Immédiat après confirmation         |
| Abonnement expirant       | Important     | Email, Push       | 14 et 7 jours avant expiration      |
| Carnet presque épuisé     | Important     | Email, In-app     | À 2 entrées restantes               |
| Confirmation utilisation  | Informatif    | In-app            | Après enregistrement de présence    |

### 4.3 Notifications liées aux paiements

| Événement                 | Type          | Canaux par défaut | Délai                               |
|---------------------------|---------------|-------------------|-------------------------------------|
| Confirmation paiement     | Important     | Email             | Immédiat après transaction          |
| Reçu fiscal (don)         | Important     | Email             | Dans les 7 jours suivant le don     |
| Paiement échoué           | Critique      | Email, Push       | Immédiat après échec                |
| Paiement en attente       | Important     | Email             | 3 jours après création si non finalisé |

### 4.4 Notifications liées aux présences

| Événement                 | Type          | Canaux par défaut | Délai                               |
|---------------------------|---------------|-------------------|-------------------------------------|
| Confirmation présence     | Informatif    | In-app            | Immédiat après enregistrement       |
| Capacité max. atteinte    | Important     | In-app, Site web  | En temps réel                       |
| Rapport hebdomadaire      | Informatif    | Email             | Chaque lundi (pour admins)          |
| Statistiques mensuelles   | Informatif    | Email             | 1er du mois (pour admins)           |

### 4.5 Notifications liées aux rôles

| Événement                 | Type          | Canaux par défaut | Délai                               |
|---------------------------|---------------|-------------------|-------------------------------------|
| Attribution nouveau rôle  | Important     | Email, In-app     | Immédiat après confirmation         |
| Fin de mandat approchant  | Important     | Email             | 30 jours avant la fin du mandat     |
| Rappel responsabilités    | Informatif    | Email             | Trimestriel pour certains rôles     |
| Formation requise         | Important     | Email, Push       | 14 jours avant la session           |

## 5. Contenu et format des notifications

### 5.1 Structure standard d'une notification

Toute notification doit comporter les éléments suivants :
1. **Source** : Identification claire de l'émetteur (Circographe)
2. **Objet** : Résumé concis et explicite du contenu
3. **Corps** : Contenu principal, clair et concis
4. **Action(s)** : Si applicable, action(s) attendue(s) clairement identifiée(s)
5. **Échéance** : Si applicable, délai pour agir
6. **Contact** : Moyen de contacter l'association si besoin
7. **Désinscription** : Moyen de gérer ses préférences de notification

### 5.2 Guides stylistiques par canal

| Canal              | Longueur maximale | Ton                  | Éléments visuels                    |
|--------------------|-------------------|----------------------|-------------------------------------|
| Email              | Variable          | Formel à semi-formel | Logo, couleurs, mise en page structurée |
| In-app             | 200 caractères    | Conversationnel      | Icônes, code couleur par importance |
| Push               | 80 caractères     | Direct, accrocheur   | Icône simple                        |

### 5.3 Personnalisation

| Élément            | Règle                                                         |
|--------------------|---------------------------------------------------------------|
| Nom utilisateur    | Inclure dans toutes les communications directes               |
| Historique         | Référencer les actions précédentes quand pertinent            |
| Préférences        | Adapter le contenu selon les préférences connues              |
| Langue             | Respecter la langue choisie par l'utilisateur                 |

## 6. Gestion des notifications

### 6.1 Cycle de vie d'une notification

| État               | Description                                                   | Durée de conservation                  |
|--------------------|---------------------------------------------------------------|----------------------------------------|
| Créée              | Notification générée mais pas encore envoyée                  | N/A                                    |
| Envoyée            | Transmise au destinataire via le canal choisi                 | Conservation dans le système           |
| Délivrée           | Confirmation de réception par le dispositif du destinataire   | État enregistré si possible            |
| Lue                | Ouverte/vue par le destinataire                               | État enregistré si possible            |
| Actionnée          | Action effectuée suite à la notification                      | État enregistré                        |
| Archivée           | Conservée pour référence mais plus active                     | 6 mois minimum                         |
| Supprimée          | Effacée du système                                            | Après la période de conservation       |

### 6.2 Conservation et archivage

| Type               | Période de conservation active | Période d'archivage               |
|--------------------|--------------------------------|-----------------------------------|
| Notifications critiques | 3 mois                    | 2 ans                             |
| Notifications importantes | 2 mois                  | 1 an                              |
| Notifications informatives | 1 mois                 | 6 mois                            |
| Notifications optionnelles | 2 semaines             | 3 mois                            |

### 6.3 Règles de reprise en cas d'échec

| Scénario           | Règle                                                         |
|--------------------|---------------------------------------------------------------|
| Échec d'envoi      | Jusqu'à 3 tentatives, espacées de 10 minutes                  |
| Canal indisponible | Repli automatique sur canal secondaire si critique ou important |
| Contact impossible | Enregistrement dans le dossier utilisateur pour suivi manuel  |

## 7. Confidentialité et conformité

### 7.1 Protection des données

| Aspect             | Règle                                                         |
|--------------------|---------------------------------------------------------------|
| Données sensibles  | Jamais incluses directement dans les notifications            |
| Chiffrement        | Communications chiffrées de bout en bout                      |
| Accès au contenu   | Limité aux destinataires légitimes et administrateurs autorisés |
| Conservation       | Conforme à la politique générale de protection des données    |

### 7.2 Conformité légale

| Réglementation     | Mesures spécifiques                                           |
|--------------------|---------------------------------------------------------------|
| RGPD               | Base légale identifiée pour chaque type de notification       |
| Droit à l'oubli    | Procédure de suppression de l'historique des notifications    |
| Droit d'accès      | Interface de consultation de l'historique des notifications   |
| Anti-spam          | Respect des législations anti-spam et communications électroniques |

## 8. Tableaux récapitulatifs

### 8.1 Matrice de notification par rôle

| Type de notification | Membre | Bénévole | Administrateur | Super Admin |
|---------------------|--------|----------|----------------|-------------|
| Adhésion            | ✅     | ✅       | ✅             | ✅          |
| Cotisation          | ✅     | ✅       | ✅             | ✅          |
| Présence            | ✅     | ✅       | ✅             | ✅          |
| Admin. quotidienne  | ❌     | ✅       | ✅             | ✅          |
| Statistiques        | ❌     | ❌       | ✅             | ✅          |
| Système             | ❌     | ❌       | ❌             | ✅          |

### 8.2 Matrice canaux/importance

| Canal        | Critique | Important | Informatif | Optionnel |
|--------------|----------|-----------|------------|-----------|
| Email        | ✅       | ✅        | ✅         | ✅        |
| In-app       | ✅       | ✅        | ✅         | ✅        |
| Push         | ✅       | ✅        | ❌         | ❌        |
| Postal       | ⚠️*      | ⚠️*       | ❌         | ❌        |

*Uniquement pour communications officielles ou en l'absence d'alternative électronique

---

*Document créé le [DATE] - Version 1.0*