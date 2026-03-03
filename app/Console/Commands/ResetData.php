<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Cache;

class ResetData extends Command
{
    protected $signature = 'app:reset-data {--no-seed : Ne pas exécuter les seeders} {--force : Forcer en production}';

    protected $description = 'Réinitialise la base de données (migrate:fresh) et vide les caches. Optionnellement exécute les seeders.';

    public function handle()
    {
        $isProduction = App::environment('production');
        $noSeed = (bool) $this->option('no-seed');
        $force = (bool) $this->option('force');

        if ($isProduction && !$force) {
            $this->error('Environnement production détecté. Utilisez --force pour continuer.');
            return 1;
        }

        $this->info('Nettoyage des caches (config, route, view, cache)...');
        Artisan::call('config:clear');
        Artisan::call('route:clear');
        Artisan::call('view:clear');
        Artisan::call('cache:clear');
        try {
            Cache::flush();
        } catch (\Throwable $e) {
            // ignore si non supporté
        }

        $this->info('Exécution de migrate:fresh ' . ($noSeed ? '(sans seeders)' : 'avec seeders') . ' ...');
        $params = [];
        if (!$noSeed) {
            $params['--seed'] = true;
        }
        $exitCode = Artisan::call('migrate:fresh', $params);
        $this->line(Artisan::output());

        if ($exitCode !== 0) {
            $this->error('migrate:fresh a échoué.');
            return $exitCode;
        }

        $this->info('Réinitialisation terminée.');
        return 0;
    }
}

