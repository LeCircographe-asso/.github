# Template de Reçu de Paiement

Ce document définit la structure et le contenu des reçus de paiement générés par l'application Le Circographe.

## Aperçu

Le reçu de paiement est un document officiel émis après validation d'un paiement. Il sert de preuve de transaction et peut être utilisé à des fins comptables et fiscales.

## Structure du Template

```
┌─────────────────────────────────────────────────┐
│ [Logo]           REÇU DE PAIEMENT               │
│                                                 │
│ Association Le Circographe                      │
│ 123 Rue du Cirque, 75000 Paris                  │
│ SIRET: 123 456 789 00012                        │
│                                                 │
│ N° {{receiptNumber}}        Date: {{issueDate}} │
│                                                 │
│ PAYÉ PAR                                        │
│ {{memberName}}                                  │
│ {{memberAddress}}                               │
│ {{memberEmail}}                                 │
│                                                 │
│ DÉTAILS DU PAIEMENT                             │
│ ┌─────────────────┬──────────┬───────────────┐ │
│ │ Description     │ Quantité │ Montant       │ │
│ ├─────────────────┼──────────┼───────────────┤ │
│ │ {{itemDesc}}    │ {{qty}}  │ {{amount}} €  │ │
│ │ {{itemDesc2}}   │ {{qty2}} │ {{amount2}} € │ │
│ └─────────────────┴──────────┴───────────────┘ │
│                                                 │
│ Sous-total: {{subtotal}} €                      │
│ TVA (0%): {{vat}} €                             │
│ TOTAL: {{total}} €                              │
│                                                 │
│ MÉTHODE DE PAIEMENT                             │
│ {{paymentMethod}}                               │
│ {{paymentDetails}}                              │
│                                                 │
│ STATUT: {{paymentStatus}}                       │
│                                                 │
│ Ce reçu est généré électroniquement et ne       │
│ nécessite pas de signature.                     │
│                                                 │
│ Association à but non lucratif - TVA non        │
│ applicable, art. 293B du CGI                    │
└─────────────────────────────────────────────────┘
```

## Variables Dynamiques

| Variable | Description | Exemple |
|----------|-------------|---------|
| `{{receiptNumber}}` | Numéro unique du reçu | R-2024-0001 |
| `{{issueDate}}` | Date d'émission du reçu | 15/02/2024 |
| `{{memberName}}` | Nom complet du membre | Jean Dupont |
| `{{memberAddress}}` | Adresse postale du membre | 10 rue des Lilas, 75001 Paris |
| `{{memberEmail}}` | Email du membre | jean.dupont@example.com |
| `{{itemDesc}}` | Description de l'article | Adhésion Basic 2024 |
| `{{qty}}` | Quantité | 1 |
| `{{amount}}` | Montant unitaire | 10.00 |
| `{{subtotal}}` | Sous-total avant taxes | 10.00 |
| `{{vat}}` | Montant de TVA | 0.00 |
| `{{total}}` | Montant total | 10.00 |
| `{{paymentMethod}}` | Méthode de paiement | Espèces / Chèque / Virement |
| `{{paymentDetails}}` | Détails du paiement | Chèque N°1234567 Banque XYZ |
| `{{paymentStatus}}` | Statut du paiement | PAYÉ / EN ATTENTE |

## Formats Disponibles

Le reçu est généré dans les formats suivants :
- PDF (format par défaut)
- HTML (pour affichage dans l'application)
- JSON (pour intégration API)

## Règles d'Utilisation

1. **Numérotation**
   - Format: R-YYYY-XXXX (Année-Numéro séquentiel)
   - Séquence réinitialisée chaque année civile
   - Numéros strictement croissants

2. **Conservation**
   - Durée légale: 10 ans
   - Stockage sécurisé avec chiffrement
   - Accessible au membre dans son espace personnel

3. **Mentions Légales**
   - Inclusion obligatoire du SIRET
   - Mention du statut fiscal (TVA non applicable)
   - Référence à l'article 293B du CGI

4. **Validation**
   - Vérification des montants (somme des lignes = total)
   - Cohérence des informations membre
   - Unicité du numéro de reçu

## Exemples

### Exemple 1: Reçu d'Adhésion

```json
{
  "receiptNumber": "R-2024-0001",
  "issueDate": "15/02/2024",
  "memberName": "Jean Dupont",
  "memberAddress": "10 rue des Lilas, 75001 Paris",
  "memberEmail": "jean.dupont@example.com",
  "items": [
    {
      "description": "Adhésion Basic 2024",
      "quantity": 1,
      "amount": 10.00
    }
  ],
  "subtotal": 10.00,
  "vat": 0.00,
  "total": 10.00,
  "paymentMethod": "Espèces",
  "paymentDetails": "",
  "paymentStatus": "PAYÉ"
}
```

### Exemple 2: Reçu de Cotisation avec Don

```json
{
  "receiptNumber": "R-2024-0002",
  "issueDate": "16/02/2024",
  "memberName": "Marie Martin",
  "memberAddress": "25 avenue Victor Hugo, 75016 Paris",
  "memberEmail": "marie.martin@example.com",
  "items": [
    {
      "description": "Cotisation Mensuelle",
      "quantity": 1,
      "amount": 30.00
    },
    {
      "description": "Don à l'association",
      "quantity": 1,
      "amount": 15.00
    }
  ],
  "subtotal": 45.00,
  "vat": 0.00,
  "total": 45.00,
  "paymentMethod": "Chèque",
  "paymentDetails": "Chèque N°1234567 Banque XYZ",
  "paymentStatus": "PAYÉ"
}
```

## Intégration avec d'autres Domaines

- **Paiement**: Généré automatiquement après validation d'un paiement
- **Adhésion**: Lié à l'activation d'une adhésion
- **Cotisation**: Lié à l'activation d'une cotisation
- **Notification**: Envoyé par email après génération

---

*Version: 1.0 - Dernière mise à jour: Février 2024*
