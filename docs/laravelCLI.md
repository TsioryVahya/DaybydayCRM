# Commandes CLI Laravel (Artisan)

**Note**: La liste exacte des commandes disponibles peut légèrement varier en fonction de la version de Laravel que vous utilisez. Pour voir toutes les commandes disponibles dans votre projet, exécutez simplement `php artisan list` dans votre terminal.

## Table des matières
1. [Commandes Générales et d'Information](#commandes-générales-et-dinformation)
2. [Commandes de Génération de Code (Make)](#commandes-de-génération-de-code-make)
3. [Commandes de Base de Données](#commandes-de-base-de-données)
4. [Commandes de Cache et d'Optimisation](#commandes-de-cache-et-doptimisation)
5. [Commandes de Développement et de Maintenance](#commandes-de-développement-et-de-maintenance)
6. [Commandes de Routes et de Tests](#commandes-de-routes-et-de-tests)
7. [Commandes de File d'Attente (Queue)](#commandes-de-file-dattente-queue)

---

## Commandes Générales et d'Information

| Commande | Explication |
| :--- | :--- |
| `php artisan list` | Affiche la liste de toutes les commandes Artisan disponibles. |
| `php artisan help [commande]` | Affiche l'aide et les options disponibles pour une commande spécifique. |
| `php artisan --version` | Affiche la version actuelle de votre installation Laravel. |
| `php artisan env` | Affiche l'environnement actuel de l'application (local, production, etc.). |
| `php artisan inspire` | Affiche une citation inspirante. |
| `php artisan tinker` | Ouvre un shell interactif (REPL) pour interagir directement avec votre application Laravel. |

## Commandes de Génération de Code (Make)

| Commande | Explication |
| :--- | :--- |
| `php artisan make:controller [Nom]` | Crée un nouveau contrôleur. L'option `--resource` génère un contrôleur avec les méthodes RESTful prédéfinies. |
| `php artisan make:model [Nom]` | Crée un nouveau modèle Eloquent. L'option `-m` crée également un fichier de migration associé. |
| `php artisan make:migration [nom]` | Crée un nouveau fichier de migration pour la base de données. |
| `php artisan make:seeder [Nom]` | Crée une nouvelle classe "Seeder" pour remplir la base de données avec des données de test. |
| `php artisan make:factory [Nom]` | Crée une nouvelle "factory" pour générer des données factices (fake data) pour vos modèles. |
| `php artisan make:middleware [Nom]` | Crée une nouvelle classe de middleware. |
| `php artisan make:request [Nom]` | Crée une nouvelle classe de requête pour la validation des données. |
| `php artisan make:command [Nom]` | Crée une nouvelle commande Artisan personnalisée. |
| `php artisan make:event [Nom]` | Crée une nouvelle classe d'événement. |
| `php artisan make:listener [Nom]` | Crée une nouvelle classe d'écouteur d'événement. |
| `php artisan make:job [Nom]` | Crée une nouvelle classe de job pour les files d'attente (queues). |
| `php artisan make:policy [Nom]` | Crée une nouvelle classe de politique d'autorisation. |
| `php artisan make:notification [Nom]` | Crée une nouvelle classe de notification. |
| `php artisan make:mail [Nom]` | Crée une nouvelle classe pour l'envoi d'emails (Mailable). |
| `php artisan make:rule [Nom]` | Crée une nouvelle règle de validation personnalisée. |
| `php artisan make:resource [Nom]` | Crée une nouvelle ressource API pour transformer vos modèles en JSON. |
| `php artisan make:test [Nom]` | Crée un nouveau fichier de test. |

## Commandes de Base de Données

| Commande | Explication |
| :--- | :--- |
| `php artisan migrate` | Exécute toutes les migrations qui n'ont pas encore été lancées. |
| `php artisan migrate:rollback` | Annule la dernière opération de migration (le dernier lot). |
| `php artisan migrate:refresh` | Annule toutes les migrations et les relance (utile en développement). |
| `php artisan migrate:fresh` | Supprime toutes les tables de la base de données et relance toutes les migrations. |
| `php artisan migrate:status` | Affiche le statut (effectué ou non) de chaque migration. |
| `php artisan db:seed` | Exécute les "Seeders" pour peupler la base de données. |
| `php artisan db:show` | Affiche des informations sur votre base de données (taille, tables, etc.). |
| `php artisan schema:dump` | Crée un dump du schéma de la base de données (utile pour les tests). |

## Commandes de Cache et d'Optimisation

| Commande | Explication |
| :--- | :--- |
| `php artisan cache:clear` | Vide le cache de l'application. |
| `php artisan config:cache` | Crée un fichier de cache pour la configuration, ce qui accélère le chargement en production. |
| `php artisan config:clear` | Supprime le fichier de cache de la configuration. |
| `php artisan route:cache` | Crée un fichier de cache pour les routes, ce qui accélère l'enregistrement en production. |
| `php artisan route:clear` | Supprime le fichier de cache des routes. |
| `php artisan view:cache` | Pré-compile toutes les vues Blade dans le cache. |
| `php artisan view:clear` | Supprime tous les fichiers de vues compilés du cache. |
| `php artisan event:cache` | Crée un fichier de cache pour les événements et leurs écouteurs. |
| `php artisan event:clear` | Supprime le cache des événements. |
| `php artisan optimize` | Optimise l'application en mettant en cache les configurations, routes et vues. `optimize:clear` fait l'inverse. |
| `php artisan clear-compiled` | Supprime le fichier de classes compilées (`services.php`). |

## Commandes de Développement et de Maintenance

| Commande | Explication |
| :--- | :--- |
| `php artisan serve` | Lance le serveur de développement PHP intégré, généralement à l'adresse `http://localhost:8000`. |
| `php artisan key:generate` | Génère une nouvelle clé d'application et la place dans votre fichier `.env`. |
| `php artisan storage:link` | Crée un lien symbolique (shortcut) de `public/storage` vers `storage/app/public` pour rendre les fichiers accessibles publiquement. |
| `php artisan down` | Met l'application en mode maintenance (affiche une vue "503"). |
| `php artisan up` | Remet l'application en ligne (hors mode maintenance). |
| `php artisan schedule:run` | Exécute les tâches planifiées définies dans le noyau de la console. |

## Commandes de Routes et de Tests

| Commande | Explication |
| :--- | :--- |
| `php artisan route:list` | Affiche une liste de toutes les routes enregistrées dans l'application. |
| `php artisan test` | Lance l'exécution des tests de l'application (via PHPUnit ou Pest). |

## Commandes de File d'Attente (Queue)

| Commande | Explication |
| :--- | :--- |
| `php artisan queue:work` | Démarre un worker qui traite les jobs de la file d'attente. |
| `php artisan queue:listen` | Écoute une file d'attente donnée. |
| `php artisan queue:restart` | Redemande poliment aux workers de redémarrer après leur job en cours. |
| `php artisan queue:failed` | Liste tous les jobs qui ont échoué. |
| `php artisan queue:retry [id]` | Relance un job qui a échoué. |
| `php artisan queue:flush` | Supprime tous les jobs échoués. |