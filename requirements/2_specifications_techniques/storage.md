# 📦 Spécifications Stockage

<div align="right">
  <a href="./README.md">⬅️ Retour aux spécifications techniques</a> •
  <a href="../../profile/README.md">📚 Documentation principale</a>
</div>

<p align="center"><i>🧭 Chemin: <a href="../../profile/README.md">Documentation</a> > <a href="../README.md">Requirements</a> > <a href="./README.md">Spécifications Techniques</a> > <b>Stockage</b></i></p>

## 📋 Vue d'ensemble

Ce document définit les spécifications de stockage pour les fichiers et contenus riches dans l'application Le Circographe, conformément aux standards de Rails 8.0.1.

## 🖼️ Active Storage

L'application utilise [Active Storage](https://guides.rubyonrails.org/active_storage_overview.html) natif de Rails 8.0.1 sans gem tierce.

### Configuration
- **Environnement de développement**: Stockage local (disk service)
- **Environnement de production**: Stockage local (pas de S3 pour simplifier le déploiement)
- **Analyseurs activés**: `image`, `video`, `audio`, `pdf` (analyseurs standards)
- **Traitement d'images**: Via la gem `image_processing` (listée dans les requirements)

### Types de fichiers acceptés
| Type | Formats | Taille max | Usage |
|------|---------|------------|-------|
| Images | jpg, png, gif | 2 MB | Photos de profil, galerie d'événements |
| Documents | pdf | 5 MB | Attestations, reçus, justificatifs |

### Sécurité
- **Validation de type MIME** activée via `content_type_allowlist`
- **URLs signées** avec expiration pour téléchargement sécurisé
- **Autorisation** via concerns partagés avec le système de rôles

### Variants prédéfinies
```ruby
# Configuration des variants standards pour les images
class User < ApplicationRecord
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [100, 100]
    attachable.variant :medium, resize_to_fill: [300, 300]
  end
end
```

## 📝 Action Text

Utilisé pour les contenus riches comme les descriptions d'événements et les annonces.

### Configuration
- **Toolbar personnalisée**: limitée aux formatages essentiels (gras, italique, listes, liens)
- **Intégration Active Storage**: pour les images inline
- **Sanitization HTML**: activée par défaut via Rails

### Exemple d'implémentation
```ruby
# Modèle avec Action Text pour la description
class Event < ApplicationRecord
  has_rich_text :description

  # Validations
  validates :description, presence: true
end
```

```erb
<%# Vue avec Action Text %>
<%= form_with model: @event do |form| %>
  <%= form.label :description %>
  <%= form.rich_text_area :description %>
<% end %>
```

## 🔄 Nettoyage et maintenance

- **Purge automatique** des fichiers orphelins via tâche rake planifiée
- **Rotation des fichiers** de log selon les standards Rails
- **Suppression en cascade** via `dependent: :purge_later` dans les modèles

## 📎 Référence aux domaines métier

| Domaine | Besoins de stockage |
|---------|---------------------|
| Adhésion | Justificatifs tarif réduit (PDF), photos de profil (image) |
| Paiement | Reçus générés (PDF), factures (PDF) |
| Présence | QR codes générés (image), trombinoscope (image) |

---

<div align="center">
  <p>
    <a href="./README.md">⬅️ Retour aux spécifications techniques</a> | 
    <a href="#-spécifications-stockage">⬆️ Haut de page</a>
  </p>
</div> 