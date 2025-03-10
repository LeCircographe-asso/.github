# FAQ pour les Administrateurs

## Questions générales

### Q: Qu'est-ce que Le Circographe ?
**R:** Le Circographe est une application de gestion pour les associations de cirque, développée avec Ruby on Rails 8.0.1. Elle permet de gérer les adhésions, cotisations, paiements, présences, rôles et notifications au sein de l'association.

### Q: Quelles sont les principales fonctionnalités disponibles pour les administrateurs ?
**R:** Les administrateurs peuvent gérer les adhérents, configurer les tarifs, suivre les paiements, générer des rapports, gérer les activités et les présences, et configurer les paramètres de l'application.

### Q: Comment puis-je accéder à l'interface d'administration ?
**R:** Connectez-vous à l'application avec vos identifiants administrateur, puis accédez au tableau de bord d'administration via le menu principal ou en vous rendant à l'URL `/admin`.

## Gestion des adhérents

### Q: Comment ajouter un nouvel adhérent ?
**R:** Allez dans la section "Adhérents" du tableau de bord d'administration, cliquez sur "Ajouter un adhérent", puis remplissez le formulaire avec les informations requises. Consultez la section "Gestion des membres" pour plus de détails.

### Q: Comment renouveler une adhésion ?
**R:** Recherchez l'adhérent concerné, accédez à sa fiche, puis cliquez sur "Renouveler l'adhésion". Vous pouvez également effectuer des renouvellements en masse via la section "Renouvellements".

### Q: Comment gérer les statuts spéciaux des adhérents ?
**R:** Les statuts spéciaux (ex: membre du conseil d'administration, bénévole) sont gérés via les rôles. Accédez à la fiche de l'adhérent, puis utilisez la section "Rôles" pour attribuer ou retirer des rôles.

## Gestion financière

### Q: Comment configurer les tarifs des cotisations ?
**R:** Accédez à la section "Configuration" puis "Tarifs". Vous pouvez y définir différentes grilles tarifaires selon les critères de votre association. Consultez le guide de configuration pour plus de détails.

### Q: Comment enregistrer un paiement ?
**R:** Accédez à la fiche de l'adhérent concerné, section "Paiements", puis cliquez sur "Ajouter un paiement". Renseignez le montant, la méthode de paiement et l'objet du paiement. Consultez la section "Gestion financière" pour plus de détails.

### Q: Comment générer une facture ou un reçu ?
**R:** Dans la section "Paiements" de la fiche adhérent, sélectionnez le paiement concerné puis cliquez sur "Générer un reçu" ou "Générer une facture".

## Rapports et statistiques

### Q: Comment générer un rapport sur les adhésions ?
**R:** Accédez à la section "Rapports" du tableau de bord d'administration, puis sélectionnez "Rapport d'adhésions". Vous pouvez filtrer les données par période et exporter le rapport en différents formats. Consultez le guide des rapports pour plus de détails.

### Q: Comment suivre les paiements en attente ?
**R:** Accédez à la section "Finances" puis "Paiements en attente". Ce tableau de bord présente tous les paiements dus et non réglés, avec possibilité de filtrage et de relance automatique.

### Q: Comment analyser la fréquentation des activités ?
**R:** Accédez à la section "Rapports" puis "Analyse des présences". Vous pouvez visualiser les statistiques de présence par activité, période ou adhérent.

## Configuration système

### Q: Comment configurer les notifications automatiques ?
**R:** Accédez à la section "Configuration" puis "Notifications". Vous pouvez y définir les modèles de messages et les déclencheurs pour les notifications automatiques. Consultez le guide de configuration pour plus de détails.

### Q: Comment gérer les autorisations des utilisateurs ?
**R:** Accédez à la section "Configuration" puis "Rôles et permissions". Vous pouvez y définir des rôles personnalisés avec des ensembles spécifiques de permissions.

### Q: Comment sauvegarder les données de l'application ?
**R:** Le système effectue des sauvegardes automatiques quotidiennes. Pour effectuer une sauvegarde manuelle, accédez à la section "Configuration" puis "Maintenance" et cliquez sur "Générer une sauvegarde".

## Dépannage

### Q: Un utilisateur ne peut pas se connecter, que faire ?
**R:** Vérifiez que son compte est actif dans la section "Adhérents". Vous pouvez réinitialiser son mot de passe en cliquant sur "Réinitialiser le mot de passe" depuis sa fiche.

### Q: Comment corriger une erreur dans un paiement enregistré ?
**R:** Accédez à la fiche de l'adhérent, section "Paiements", trouvez le paiement concerné et cliquez sur "Modifier". Si le paiement a déjà été confirmé, vous devrez créer une correction ou un remboursement selon votre politique interne.

### Q: Les emails automatiques ne sont pas envoyés, que faire ?
**R:** Vérifiez la configuration des emails dans la section "Configuration" puis "Email". Assurez-vous que le service d'envoi d'emails est actif et correctement configuré. Vous pouvez également consulter les logs dans la section "Maintenance".

---

*Dernière mise à jour: Mars 2023*
