# Projet : DaybydayCRM

DaybydayCRM est une application de gestion de la relation client (CRM) construite avec le framework PHP Laravel. Elle permet de gérer les clients, les opportunités (leads), les projets, les tâches, les devis (offers) et la facturation.

## **Architecture des Données (Modèles)**

### **1. Gestion Clientèle**
- **[Client.php](app/Models/Client.php)** : Entité principale. Un client peut avoir plusieurs contacts, tâches, projets, devis et factures. Gère la suppression logique (`SoftDeletes`) et l'indexation de recherche (`SearchableTrait`).
- **[Contact.php](app/Models/Contact.php)** : Représente une personne de contact chez un client.
- **[Industry.php](app/Models/Industry.php)** : Secteurs d'activité des clients.

### **2. Opérations et Suivi**
- **[Lead.php](app/Models/Lead.php)** : Opportunités commerciales. Un lead peut être converti en client.
- **[Project.php](app/Models/Project.php)** : Regroupe un ensemble de tâches pour un client spécifique.
- **[Task.php](app/Models/Task.php)** : Unité de travail assignée à un utilisateur. Liée à un client ou à un projet.
- **[Status.php](app/Models/Status.php)** : Gère les états (ex: Nouveau, En cours, Fermé) pour les leads, projets et tâches.

### **3. Facturation et Ventes**
- **[Offer.php](app/Models/Offer.php)** : Devis envoyés aux clients.
- **[Invoice.php](app/Models/Invoice.php)** : Factures générées. Supporte le polymorphisme pour être liée à différentes sources (Tâches, Projets, etc.).
- **[InvoiceLine.php](app/Models/InvoiceLine.php)** : Détail des lignes de facture. Les prix sont stockés en centimes pour la précision.
- **[Payment.php](app/Models/Payment.php)** : Enregistrement des paiements reçus.
- **[Product.php](app/Models/Product.php)** : Catalogue de produits ou services.

### **4. Système et Sécurité**
- **[User.php](app/Models/User.php)** : Utilisateurs du CRM (Administrateurs, Gestionnaires, etc.). Utilise le système de rôles **Entrust**.
- **[Role.php](app/Models/Role.php)** & **[Permission.php](app/Models/Permission.php)** : Gestion des accès RBAC (Role-Based Access Control).
- **[Activity.php](app/Models/Activity.php)** : Journalisation de toutes les actions importantes (Audit Trail).
- **[Integration.php](app/Models/Integration.php)** : Configuration des services tiers (ex: Facturation externe).
- **[Document.php](app/Models/Document.php)** : Gestion centralisée des fichiers attachés via polymorphisme.

---

## **Composants Clés**

### **Helpers et Utilitaires**
- **[helpers.php](app/helpers.php)** : Fournit des fonctions globales pour le formatage des dates (`carbonDate`), la gestion de l'activité (`activity()`) et le formatage monétaire (`formatMoney()`).

### **Calculs Financiers**
- L'application utilise des classes dédiées dans `app/Repositories/Money` pour garantir des calculs précis, notamment en évitant les nombres à virgule flottante pour le stockage des montants.

### **Services**
- **Commentaires** : Un système de commentaires polymorphique (`Commentable`) est implémenté pour les leads, tâches et projets.
- **Délais** : Le trait `DeadlineTrait` gère les alertes sur les dates d'échéance.

---

## **Technologies Utilisées**
- **Framework** : Laravel
- **Base de données** : Relationnelle (MySQL par défaut)
- **Recherche** : Support pour ElasticSearch via `SearchableTrait`.
- **Facturation** : Laravel Cashier pour la gestion des abonnements.
- **Interface** : Utilisation intensive de Datatables pour l'affichage des données.
