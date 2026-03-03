DaybydayCRM — Documentation du Projet

Vue d’ensemble
- DaybydayCRM est une application CRM libre et auto‑hébergée basée sur Laravel 7.
- Back-end: PHP 7.3/7.4, Laravel 7, MySQL/MariaDB, Redis (optionnel), Elasticsearch (optionnel).
- Front-end: Laravel Mix (Webpack), SCSS, JS.

Prérequis
- Docker Desktop (recommandé) OU PHP 7.4, Composer, Node.js et MySQL installés localement.
- Fichier d’environnement: voir [.env.example](file:///w:/ITU/S6/PREPA/DaybydayCRM/.env.example).

Démarrage Rapide (Docker recommandé)
1) Démarrer les services:
- docker-compose up -d
- Fichier de stack: [docker-compose.yml](file:///w:/ITU/S6/PREPA/DaybydayCRM/docker-compose.yml)
2) Installer les dépendances PHP:
- docker-compose exec php composer install
3) Générer la clé et préparer la base:
- docker-compose exec php php artisan key:generate
- docker-compose exec php php artisan migrate --seed
4) Accéder à l’application:
- http://localhost

Installation Locale (sans Docker)
1) Créer le fichier .env et configurer la base:
- Copier .env.example en .env et renseigner DB_* (hôte, base, utilisateur, mot de passe).
- Fichier: [.env.example](file:///w:/ITU/S6/PREPA/DaybydayCRM/.env.example)
2) PHP et Composer:
- Utiliser PHP 7.4. Installer les extensions: fileinfo, zip, openssl, mbstring, pdo_mysql, curl.
- S’assurer que extension_dir pointe vers W:\php-7.4.33-Win32-vc15-x64\ext dans php.ini.
- composer install
- php artisan key:generate
3) Base de données:
- php artisan migrate --seed
4) Front-end:
- npm install
- npm run dev
- Si Node ≥ 17: définir la variable NODE_OPTIONS=--openssl-legacy-provider avant npm run dev.
5) Lancer le serveur local:
- php artisan serve (http://localhost:8000)

Comptes de Démonstration (seed)
- Un utilisateur administrateur est généré par les seeders:
- Email: admin@admin.com (voir [UsersTableSeeder.php](file:///w:/ITU/S6/PREPA/DaybydayCRM/database/seeds/UsersTableSeeder.php)).
- Le mot de passe est défini par les seeders/fixtures du projet. Si besoin, le réinitialiser via php artisan tinker ou la page “Forgot password”.

Réinitialisation des Données
- Une commande de réinitialisation a été ajoutée pour vider caches et recréer le schéma:
- php artisan app:reset-data
- Options:
- --no-seed pour ne pas exécuter les seeders
- --force pour exécuter en production (à éviter)
- Implémentation: [ResetData.php](file:///w:/ITU/S6/PREPA/DaybydayCRM/app/Console/Commands/ResetData.php), enregistrée dans [Kernel.php](file:///w:/ITU/S6/PREPA/DaybydayCRM/app/Console/Kernel.php#L15-L18).

Export/Visualisation du MCD
- SQL (structure uniquement): [BDD/mcd_simple.sql](file:///w:/ITU/S6/PREPA/DaybydayCRM/BDD/mcd_simple.sql)
- phpMyAdmin (Designer): Base → Designer → Exporter le schéma (PDF/PNG/SVG).
- MySQL Workbench: Database → Reverse Engineer → EER Diagram.
- DBeaver: clic droit sur le schéma → ER Diagram → Export.

Architecture du Code (Laravel)
- Application: [app/](file:///w:/ITU/S6/PREPA/DaybydayCRM/app)
- Contrôleurs HTTP: [app/Http/Controllers](file:///w:/ITU/S6/PREPA/DaybydayCRM/app/Http/Controllers)
- Modèles: [app/Models](file:///w:/ITU/S6/PREPA/DaybydayCRM/app/Models)
- Requêtes/Validations: [app/Http/Requests](file:///w:/ITU/S6/PREPA/DaybydayCRM/app/Http/Requests)
- Services/Répertoires métiers: [app/Services](file:///w:/ITU/S6/PREPA/DaybydayCRM/app/Services)
- Observers/Listeners/Events: [app/Observers](file:///w:/ITU/S6/PREPA/DaybydayCRM/app/Observers), [app/Events](file:///w:/ITU/S6/PREPA/DaybydayCRM/app/Events), [app/Listeners](file:///w:/ITU/S6/PREPA/DaybydayCRM/app/Listeners)
- Migrations/Seeders: [database/migrations](file:///w:/ITU/S6/PREPA/DaybydayCRM/database/migrations), [database/seeds](file:///w:/ITU/S6/PREPA/DaybydayCRM/database/seeds)
- Config: [config/](file:///w:/ITU/S6/PREPA/DaybydayCRM/config)

Commandes Utiles
- Composer: composer install, composer dump-autoload, composer update
- Artisan:
- php artisan migrate, migrate:fresh, db:seed
- php artisan route:list, config:cache, cache:clear
- php artisan app:reset-data (voir plus haut)
- Node/Front:
- npm run dev, npm run prod

Intégrations et Services Optionnels
- Redis: cache/session (configurable via REDIS_*).
- Elasticsearch: désactivable via ELASTICSEARCH_ENABLED (voir [config/elasticsearch.php](file:///w:/ITU/S6/PREPA/DaybydayCRM/config/elasticsearch.php)).
- Facturation/Stripe: packages Cashier et stripe-php (extensions PHP curl requise).

Dépannage Rapide
- Erreurs Composer liées à PHP 8.x: utiliser PHP 7.4 pour ce projet.
- Extensions manquantes (fileinfo, zip, curl): activer dans php.ini et vérifier extension_dir.
- Erreur Webpack “digital envelope routines”: définir NODE_OPTIONS=--openssl-legacy-provider pour Node ≥ 17.

Licence
- MIT. Voir composer.json ([composer.json](file:///w:/ITU/S6/PREPA/DaybydayCRM/composer.json)).

