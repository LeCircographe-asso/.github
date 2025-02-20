# Critères d'Acceptation - Le Circographe

## 📱 PWA

### Installation
- [ ] L'application propose l'installation sur les appareils compatibles
- [ ] Le manifest contient toutes les icônes requises
- [ ] L'application s'installe correctement sur iOS et Android
- [ ] L'application s'installe sur le bureau (Windows/Mac)

### Mode Hors-ligne
- [ ] L'application fonctionne sans connexion internet
- [ ] Les données essentielles sont mises en cache
- [ ] Les actions sont mises en file d'attente quand hors-ligne
- [ ] La synchronisation se fait automatiquement au retour de la connexion

### Performance
- [ ] Le temps de chargement initial est < 3 secondes
- [ ] Le score Lighthouse PWA est > 90
- [ ] La taille du cache est < 50MB
- [ ] Les mises à jour sont silencieuses

## 📨 Notifications

### Configuration
- [ ] L'utilisateur peut activer/désactiver chaque type de notification
- [ ] L'utilisateur peut choisir ses plages horaires
- [ ] Les préférences sont sauvegardées immédiatement
- [ ] L'interface de configuration est intuitive

### Délivrance
- [ ] Les notifications email utilisent le bon template
- [ ] Les notifications push apparaissent sur tous les appareils
- [ ] Les notifications in-app sont mises à jour en temps réel
- [ ] Le groupage fonctionne correctement

### Performances
- [ ] Le délai d'envoi est < 5 secondes
- [ ] Le taux de délivrance est > 99%
- [ ] La charge serveur reste stable
- [ ] Les erreurs sont correctement loggées

### Sécurité
- [ ] Les tokens VAPID sont correctement gérés
- [ ] Les endpoints sont chiffrés
- [ ] Le rate limiting fonctionne
- [ ] Les permissions sont vérifiées

## 🔄 Synchronisation

### Données Offline
- [ ] Les données sont stockées localement
- [ ] Les modifications offline sont tracées
- [ ] Les conflits sont résolus selon les règles
- [ ] L'utilisateur est informé du statut de synchro

### Performance
- [ ] La synchronisation est rapide (< 2s)
- [ ] La consommation de batterie est optimisée
- [ ] La bande passante est minimisée
- [ ] Les erreurs sont gérées gracieusement

## 🔐 Authentification

### Inscription
- [ ] L'utilisateur peut créer un compte avec email/mot de passe
- [ ] Les validations de mot de passe sont appliquées (min 8 caractères)
- [ ] L'email de confirmation est envoyé
- [ ] Les doublons d'email sont détectés

### Connexion
- [ ] L'utilisateur peut se connecter avec ses identifiants
- [ ] L'option "Se souvenir de moi" fonctionne
- [ ] Les tentatives échouées sont limitées
- [ ] La redirection post-login fonctionne

## 👥 Adhésions

### Souscription
- [ ] L'utilisateur peut choisir son type d'adhésion
- [ ] Le tarif réduit nécessite un justificatif
- [ ] Le paiement est requis pour activer l'adhésion
- [ ] Les dates sont correctement calculées

### Gestion
- [ ] Les adhésions sont renouvelables
- [ ] Les notifications d'expiration sont envoyées
- [ ] L'historique est consultable
- [ ] Les modifications sont tracées

## 🎪 Entraînements

### Créneaux
- [ ] La limite de participants est respectée
- [ ] Les inscriptions/désinscriptions suivent les délais
- [ ] Les présences sont validées par un bénévole
- [ ] Les notifications de rappel sont envoyées

### Administration
- [ ] Les créneaux peuvent être créés/modifiés
- [ ] Les statistiques sont générées
- [ ] Les absences sont comptabilisées
- [ ] Les suspensions sont appliquées

## 💰 Paiements

### Transactions
- [ ] Les paiements en ligne fonctionnent
- [ ] Les paiements sur place sont enregistrables
- [ ] Les factures sont générées
- [ ] Les remboursements sont possibles

### Sécurité
- [ ] Les transactions sont sécurisées
- [ ] Les montants sont validés
- [ ] Les doublons sont évités
- [ ] L'historique est complet

## 👮 Rôles et Permissions

### Gestion des Rôles
- [ ] Les rôles prédéfinis sont disponibles (admin, bénévole, membre)
- [ ] Les rôles peuvent être assignés/retirés
- [ ] Les rôles temporaires expirent correctement
- [ ] L'historique des modifications est tracé

### Permissions
- [ ] Les actions sont correctement restreintes selon le rôle
- [ ] Les menus et boutons sont conditionnellement affichés
- [ ] Les tentatives d'accès non autorisé sont bloquées
- [ ] Les permissions sont vérifiées côté serveur

### Bénévoles
- [ ] La formation est marquée comme complétée
- [ ] Les accès sont accordés progressivement
- [ ] Les actions des bénévoles sont auditées
- [ ] Les demandes de permissions sont gérées

### Administration
- [ ] La vue d'ensemble des rôles est disponible
- [ ] Les rapports d'activité sont générés
- [ ] Les conflits de rôles sont évités
- [ ] La révocation immédiate est possible

## 🎨 Interface Utilisateur

### Design System
- [ ] Les composants Flowbite sont correctement intégrés
- [ ] La charte graphique est respectée
- [ ] Les composants sont réutilisables
- [ ] Le design est responsive

### Accessibilité
- [ ] Le contraste est suffisant (WCAG AA)
- [ ] La navigation au clavier fonctionne
- [ ] Les attributs ARIA sont présents
- [ ] Les textes alternatifs sont définis

### Performance UI
- [ ] Les animations sont fluides
- [ ] Le First Contentful Paint est < 1.5s
- [ ] Les images sont optimisées
- [ ] Le layout est stable (pas de CLS)

### Expérience Utilisateur
- [ ] Les formulaires ont une validation instantanée
- [ ] Les messages d'erreur sont clairs
- [ ] Les actions critiques ont une confirmation
- [ ] Le feedback utilisateur est immédiat

## 🧪 Tests et Qualité

### Tests Unitaires
- [ ] La couverture de code est > 90%
- [ ] Les modèles sont testés exhaustivement
- [ ] Les services ont des tests isolés
- [ ] Les helpers sont testés

### Tests d'Intégration
- [ ] Les flux principaux sont testés
- [ ] Les cas d'erreur sont couverts
- [ ] Les webhooks sont testés
- [ ] Les jobs sont vérifiés

### Tests System
- [ ] Les parcours utilisateur sont automatisés
- [ ] Les tests sont stables
- [ ] Les screenshots sont générés
- [ ] Les performances sont mesurées

### Qualité du Code
- [ ] RuboCop passe sans erreur
- [ ] Les best practices Rails sont respectées
- [ ] La documentation est à jour
- [ ] Les migrations sont sécurisées

## 📊 Monitoring et Maintenance

### Logs et Métriques
- [ ] Les logs sont centralisés et structurés
- [ ] Les métriques clés sont collectées
- [ ] Les alertes sont configurées
- [ ] Les dashboards sont disponibles

### Performance
- [ ] Le temps de réponse moyen est < 200ms
- [ ] L'utilisation CPU/RAM est optimale
- [ ] Les requêtes N+1 sont évitées
- [ ] Les indices sont optimisés

### Sauvegardes
- [ ] Les backups sont automatisés
- [ ] La restauration est testée
- [ ] Les données sont chiffrées
- [ ] La rétention est respectée

### Maintenance
- [ ] Les mises à jour sont planifiées
- [ ] Les dépendances sont à jour
- [ ] Les migrations sont sans downtime
- [ ] Le rollback est possible

## 🔒 Sécurité Globale

### Protection des Données
- [ ] Les données sensibles sont chiffrées au repos
- [ ] Les mots de passe sont correctement hashés (bcrypt)
- [ ] Les sessions sont sécurisées
- [ ] Les tokens sont stockés de manière sécurisée

### Sécurité des Requêtes
- [ ] Protection CSRF active
- [ ] En-têtes de sécurité configurés
- [ ] Validation des entrées stricte
- [ ] Protection contre les injections SQL

### Audit et Traçabilité
- [ ] Les actions sensibles sont journalisées
- [ ] Les tentatives d'intrusion sont détectées
- [ ] Les sessions suspectes sont terminées
- [ ] L'historique des connexions est conservé

### Conformité
- [ ] Les exigences RGPD sont respectées
- [ ] Les CGU sont à jour
- [ ] Les données sont exportables
- [ ] La durée de conservation est respectée

## 🔌 API et Intégration

### Documentation API
- [ ] La documentation OpenAPI est complète
- [ ] Les exemples de requêtes sont fournis
- [ ] Les réponses sont documentées
- [ ] Les erreurs sont standardisées

### Sécurité API
- [ ] L'authentification par token fonctionne
- [ ] Le rate limiting est appliqué
- [ ] Les permissions sont vérifiées
- [ ] Les logs sont détaillés

### Versioning
- [ ] Le versioning est cohérent (v1, v2, etc.)
- [ ] La rétrocompatibilité est maintenue
- [ ] La dépréciation est documentée
- [ ] Les migrations sont guidées

### Intégrations
- [ ] Les webhooks sont fiables
- [ ] Les callbacks sont gérés
- [ ] Les timeouts sont configurés
- [ ] Les erreurs sont gérées proprement

## 🌍 Internationalisation

### Traductions
- [ ] Les textes sont externalisés dans les fichiers i18n
- [ ] Les dates et heures sont localisées
- [ ] Les nombres et devises sont formatés
- [ ] Les pluralisations sont gérées

### Configuration Locale
- [ ] Le fuseau horaire est correctement géré
- [ ] Le format de date est adapté par locale
- [ ] Les unités sont converties si nécessaire
- [ ] Les paramètres régionaux sont respectés

### Accessibilité Linguistique
- [ ] L'interface détecte la langue du navigateur
- [ ] Le changement de langue est persistant
- [ ] Les emails sont traduits
- [ ] Les PDF générés sont localisés

### SEO Multilingue
- [ ] Les balises hreflang sont présentes
- [ ] Les URLs sont localisées
- [ ] Les métadonnées sont traduites
- [ ] Le contenu est indexable par langue

## 📬 Jobs et Emails

### Jobs Background (Sidekiq)
- [ ] Les jobs sont correctement enqueués
- [ ] La reprise sur erreur fonctionne
- [ ] Les jobs sont monitorés
- [ ] Les performances sont optimisées

### Files d'Attente
- [ ] Les priorités sont respectées
- [ ] Les deadlines sont gérées
- [ ] Les jobs zombies sont détectés
- [ ] La rétention est configurée

### Emails
- [ ] Les templates sont responsives
- [ ] Les pièces jointes fonctionnent
- [ ] Les liens de tracking sont actifs
- [ ] Les bounces sont gérés

### Délivrabilité
- [ ] Les SPF/DKIM sont configurés
- [ ] Les templates sont validés
- [ ] Les quotas sont respectés
- [ ] Les statistiques sont disponibles

## 🚀 Déploiement et Infrastructure

### Environnements
- [ ] Dev, Staging et Production sont identiques
- [ ] Les variables d'environnement sont sécurisées
- [ ] Les secrets sont gérés correctement
- [ ] Les configurations sont versionnées

### Pipeline CI/CD
- [ ] Les tests sont automatisés
- [ ] Le linting est vérifié
- [ ] Les assets sont précompilés
- [ ] Le déploiement est automatique

### Infrastructure
- [ ] Les ressources sont correctement dimensionnées
- [ ] La scalabilité est possible
- [ ] Les certificats SSL sont valides
- [ ] Les redirections sont configurées

### Procédures
- [ ] Le rollback est testé
- [ ] Les procédures d'urgence sont documentées
- [ ] Le plan de reprise est validé
- [ ] Les accès sont sécurisés

# Système de Rôles et Adhésions

## Rôles
- Utilisateur : compte créé mais sans adhésion (par défaut)
- Membre : personne ayant payé une adhésion (Basic ou Circus)
- Bénévole : adhérent avec accès basique au dashboard admin
- Admin : accès complet au système

## Permissions par Rôle
### Utilisateur (par défaut)
- Gestion du profil basique :
  * Modification email/mot de passe uniquement
- Newsletter :
  * Inscription/désinscription
- Consultation uniquement :
  * Voir les types d'adhésion disponibles
  * Voir les événements publics
  * Voir les informations de l'association
- Pas d'accès aux fonctionnalités de souscription en ligne
  * L'adhésion se fait uniquement sur place
  * Pas de paiement en ligne

### Membre (nécessite une adhésion)
[... reste des permissions membres ...]

## Types d'Adhésion (souscription sur place uniquement)
[... reste des types d'adhésion ...] 