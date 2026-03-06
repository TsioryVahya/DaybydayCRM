# Laravel - Gestion des Exceptions - Guide Complet

## Table des matières
1. [Les Bases de la Gestion d'Exceptions](#-les-bases-de-la-gestion-dexceptions)
2. [Configuration du Handler (Laravel 10 et antérieurs)](#️-configuration-du-handler-laravel-10-et-antérieurs)
3. [Configuration du Handler (Laravel 11+)](#️-configuration-du-handler-laravel-11)
4. [Création d'Exceptions Personnalisées](#-création-dexceptions-personnalisées)
5. [Exceptions Reportables et Renderables](#-exceptions-reportables-et-renderables)
6. [Les Helpers et Fonctions Utiles](#️-les-helpers-et-fonctions-utiles)
7. [Gestion des Exceptions par Type](#-gestion-des-exceptions-par-type)
8. [Pages d'Erreur Personnalisées](#-pages-derreur-personnalisées)
9. [Test des Exceptions](#-test-des-exceptions)
10. [Les Bonnes Pratiques](#-les-bonnes-pratiques)

---

## 🚨 Les Bases de la Gestion d'Exceptions

### Configuration
Le fichier `config/app.php` contient l'option `debug` qui détermine la quantité d'informations affichées.

```env
# En développement
APP_DEBUG=true

# En production
APP_DEBUG=false
```

### Handler principal
Toutes les exceptions sont gérées par `App\Exceptions\Handler`, situé dans `app/Exceptions/Handler.php`.

### Rôle du Handler
- `report()` : enregistre l'exception dans les logs
- `render()` : convertit l'exception en réponse HTTP

[⬆ Retour au début](#table-des-matières)

---

## ⚙️ Configuration du Handler (Laravel 10 et antérieurs)

### `reportable()`
Enregistre un callback pour rapporter un type d'exception spécifique.

```php
// Dans app/Exceptions/Handler.php
public function register(): void
{
    $this->reportable(function (InvalidOrderException $e) {
        Log::error('Commande invalide: '.$e->getMessage());
    });
}
```

### `renderable()`
Enregistre un callback pour rendre un type d'exception en réponse HTTP.

```php
// Dans Handler.php
public function register(): void
{
    $this->renderable(function (NotFoundHttpException $e, $request) {
        if ($request->is('api/*')) {
            return response()->json([
                'message' => 'Ressource non trouvée'
            ], 404);
        }
    });
}
```

### `stop()`
Empêche la propagation vers le logging par défaut après traitement personnalisé.

```php
$this->reportable(function (CustomException $e) {
    // Traitement personnalisé
})->stop();
```

[⬆ Retour au début](#table-des-matières)

---

## ⚙️ Configuration du Handler (Laravel 11+)

### `withExceptions()`
Configuration via `bootstrap/app.php` avec la nouvelle syntaxe.

```php
// Dans bootstrap/app.php
->withExceptions(function (Exceptions $exceptions) {
    $exceptions->report(function (InvalidOrderException $e) {
        // Traitement personnalisé
    });

    $exceptions->render(function (NotFoundHttpException $e, Request $request) {
        if ($request->is('api/*')) {
            return response()->json(['message' => 'Not found'], 404);
        }
    });
})
```

### `dontReport()`
Ignorer certains types d'exceptions (ne pas les logger).

```php
$exceptions->dontReport([
    InvalidOrderException::class,
    ValidationException::class
]);
```

### `level()`
Définir le niveau de log spécifique pour une exception.

```php
use PDOException;
use Psr\Log\LogLevel;

$exceptions->level(PDOException::class, LogLevel::CRITICAL);
```

### `context()`
Ajouter du contexte global à toutes les exceptions loggées.

```php
$exceptions->context(fn () => [
    'app_name' => config('app.name'),
    'environment' => app()->environment(),
    'request_id' => request()->header('X-Request-ID')
]);
```

### `throttle()`
Limiter le nombre de reports pour une exception (anti-DDOS).

```php
$exceptions->throttle(function (Throwable $e) {
    return Redis::throttle('key')->allow(10)->every(60);
});
```

### `stop()`
Arrêter la propagation (version Laravel 11).

```php
$exceptions->report(function (CustomException $e) {
    // Traitement
})->stop();
```

[⬆ Retour au début](#table-des-matières)

---

## 🎯 Création d'Exceptions Personnalisées

### Création
Commande Artisan pour générer une classe d'exception :

```bash
php artisan make:exception BusinessException
```

### Exception simple
Classe qui étend la classe `Exception` de PHP.

```php
// app/Exceptions/BusinessException.php
namespace App\Exceptions;

use Exception;

class BusinessException extends Exception
{
    // Logique personnalisée
}
```

### Exception avec contexte
Ajouter des données contextuelles pour faciliter le debugging.

```php
// app/Exceptions/InvalidOrderException.php
class InvalidOrderException extends Exception
{
    protected $orderId;

    public function __construct($orderId, $message = "", $code = 0)
    {
        parent::__construct($message, $code);
        $this->orderId = $orderId;
    }

    public function context(): array
    {
        return ['order_id' => $this->orderId];
    }
}
```

### Exception abstraite
Créer une hiérarchie d'exceptions pour mieux organiser.

```php
abstract class BusinessException extends Exception
{
    public function __construct(string $message, int $code = 500)
    {
        parent::__construct($message, $code);
    }
}

class PaymentException extends BusinessException {}
class StockException extends BusinessException {}
```

[⬆ Retour au début](#table-des-matières)

---

## 📢 Exceptions Reportables et Renderables

### Méthode `report()`
Définir la logique de reporting directement dans l'exception.

```php
// Dans la classe d'exception
public function report(): void
{
    Log::error('Commande invalide', [
        'order_id' => $this->orderId,
        'message' => $this->getMessage()
    ]);

    // Envoi d'email à l'admin
    Mail::send(...);
}
```

### Méthode `render()`
Définir la réponse HTTP directement dans l'exception.

```php
public function render(Request $request): Response
{
    if ($request->expectsJson()) {
        return response()->json([
            'message' => $this->getMessage(),
            'order_id' => $this->orderId
        ], 422);
    }

    return response()->view('errors.invalid-order', [
        'orderId' => $this->orderId
    ], 422);
}
```

### Retourner `false`
Retourner `false` pour utiliser le rendu par défaut de Laravel.

```php
public function render(Request $request): Response|bool
{
    if ($request->is('api/*')) {
        return response()->json(['error' => $this->getMessage()], 400);
    }

    return false; // Utilise le rendu par défaut (page 500)
}
```

### `shouldReport()`
Contrôler si l'exception doit être reportée.

```php
public function shouldReport(): bool
{
    // Ne pas reporter en environnement local
    return !app()->environment('local');
}
```

[⬆ Retour au début](#table-des-matières)

---

## 🛠️ Les Helpers et Fonctions Utiles

### `abort()`
Lance une exception HTTP avec code et message.

```php
abort(404);
abort(403, 'Action non autorisée');
abort(500, 'Erreur serveur');
```

### `abort_if()`
Lance une exception si la condition est vraie.

```php
abort_if(!$user->isAdmin(), 403, 'Accès refusé');
abort_if($post->trashed(), 404, 'Article supprimé');
```

### `abort_unless()`
Lance une exception sauf si la condition est vraie.

```php
abort_unless($user->hasVerifiedEmail(), 403, 'Email non vérifié');
```

### `report()`
Reporte une exception sans interrompre le flux de l'application.

```php
try {
    // Opération risquée
} catch (Throwable $e) {
    report($e);
    return response()->json(['error' => 'Erreur technique'], 500);
}
```

### `Log::error()`
Enregistre une erreur dans les logs (facade).

```php
use Illuminate\Support\Facades\Log;

Log::error('Message d\'erreur', ['context' => $data]);
Log::info('Information');
Log::warning('Avertissement');
Log::critical('Erreur critique');
```

### `logger()`
Helper global pour logger.

```php
logger('Message simple');
logger(['data' => $data]);
logger()->error('Erreur avec contexte', $context);
```

### `throw_if()`
Lance une exception si la condition est vraie.

```php
throw_if($amount <= 0, InvalidArgumentException::class, 'Montant invalide');
```

### `throw_unless()`
Lance une exception sauf si la condition est vraie.

```php
throw_unless($user, UserNotFoundException::class);
```

[⬆ Retour au début](#table-des-matières)

---

## 📋 Gestion des Exceptions par Type

### `QueryException`
Erreurs de base de données (contrainte, connexion, etc.).

```php
use Illuminate\Database\QueryException;

try {
    DB::table('users')->insert([...]);
} catch (QueryException $e) {
    Log::error('Erreur DB: '.$e->getMessage());
    return response()->json([
        'error' => 'Erreur base de données',
        'code' => $e->errorInfo[1] ?? null
    ], 500);
}
```

### `ModelNotFoundException`
Modèle Eloquent non trouvé avec `findOrFail()`.

```php
use Illuminate\Database\Eloquent\ModelNotFoundException;

try {
    $user = User::findOrFail($id);
} catch (ModelNotFoundException $e) {
    return response()->json([
        'message' => 'Utilisateur non trouvé'
    ], 404);
}
```

### `ValidationException`
Erreurs de validation des formulaires/requêtes.

```php
use Illuminate\Validation\ValidationException;

try {
    $request->validate([
        'email' => 'required|email'
    ]);
} catch (ValidationException $e) {
    return response()->json([
        'errors' => $e->errors(),
        'message' => 'Données invalides'
    ], 422);
}
```

### `AuthenticationException`
Non authentifié ou session expirée.

```php
use Illuminate\Auth\AuthenticationException;

public function render($request, AuthenticationException $e)
{
    if ($request->expectsJson()) {
        return response()->json([
            'message' => 'Non authentifié'
        ], 401);
    }
    return redirect()->guest('login');
}
```

### `AuthorizationException`
Non autorisé (Policy).

```php
use Illuminate\Auth\Access\AuthorizationException;

try {
    $this->authorize('update', $post);
} catch (AuthorizationException $e) {
    return response()->json([
        'message' => 'Action non autorisée'
    ], 403);
}
```

### `NotFoundHttpException`
Route non trouvée (404).

```php
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

$exceptions->render(function (NotFoundHttpException $e, $request) {
    if ($request->is('api/*')) {
        return response()->json([
            'message' => 'Endpoint non trouvé'
        ], 404);
    }
    return response()->view('errors.404', [], 404);
});
```

### `MethodNotAllowedHttpException`
Méthode HTTP non autorisée pour la route.

```php
use Symfony\Component\HttpKernel\Exception\MethodNotAllowedHttpException;

$exceptions->render(function (MethodNotAllowedHttpException $e) {
    return response()->json([
        'message' => 'Méthode non autorisée',
        'allowed' => $e->getHeaders()['Allow'] ?? null
    ], 405);
});
```

### `ThrottleRequestsException`
Trop de requêtes (rate limiting).

```php
use Symfony\Component\HttpKernel\Exception\TooManyRequestsHttpException;

$exceptions->render(function (TooManyRequestsHttpException $e) {
    return response()->json([
        'message' => 'Trop de requêtes. Réessayez plus tard.',
        'retry_after' => $e->getHeaders()['Retry-After'] ?? null
    ], 429);
});
```

[⬆ Retour au début](#table-des-matières)

---

## 🎨 Pages d'Erreur Personnalisées

### Vues d'erreur
Créer des vues pour chaque code HTTP dans le dossier `errors` :

```
resources/views/errors/404.blade.php
resources/views/errors/403.blade.php
resources/views/errors/500.blade.php
resources/views/errors/419.blade.php  (CSRF)
resources/views/errors/503.blade.php  (maintenance)
```

### Contenu de la vue
Accès à l'exception via la variable `$exception`.

```blade
{{-- resources/views/errors/404.blade.php --}}
<!DOCTYPE html>
<html>
<head>
    <title>Page non trouvée</title>
    <style>
        body { font-family: sans-serif; text-align: center; padding: 50px; }
        h1 { font-size: 50px; }
        .error { color: #e3342f; }
    </style>
</head>
<body>
    <h1 class="error">404</h1>
    <h2>Page non trouvée</h2>
    @if($exception->getMessage())
        <p>{{ $exception->getMessage() }}</p>
    @else
        <p>La page que vous recherchez n'existe pas.</p>
    @endif
    <a href="/">Retour à l'accueil</a>
</body>
</html>
```

### Publication des vues
Publier les vues d'erreur par défaut de Laravel pour les personnaliser :

```bash
php artisan vendor:publish --tag=laravel-errors
# Crée toutes les vues d'erreur dans resources/views/errors/
```

### Vue spécifique par code
Laravel utilise automatiquement la vue correspondant au code HTTP :
- Si `500.blade.php` existe → utilisée pour les erreurs 500
- Sinon → vue par défaut

### Données disponibles

| Variable | Description |
| :--- | :--- |
| `$exception` | L'instance de l'exception |
| `$exception->getMessage()` | Message d'erreur |
| `$exception->getCode()` | Code d'erreur |
| `$exception->getStatusCode()` | Code HTTP (pour les exceptions HTTP) |

### Layout personnalisé

```blade
{{-- resources/views/errors/layout.blade.php --}}
<!DOCTYPE html>
<html>
<head>
    <title>@yield('title')</title>
    <link rel="stylesheet" href="/css/errors.css">
</head>
<body>
    <div class="error-container">
        @yield('content')
    </div>
</body>
</html>
```

Puis dans `404.blade.php` :

```blade
@extends('errors.layout')
@section('title', '404 - Page non trouvée')
@section('content')
    <h1>404</h1>
    <p>{{ $exception->getMessage() ?? 'Page non trouvée' }}</p>
@endsection
```

[⬆ Retour au début](#table-des-matières)

---

## 🧪 Test des Exceptions

### `Exceptions::fake()`
Simuler le reporting d'exceptions dans les tests.

```php
use Illuminate\Support\Facades\Exceptions;

public function test_exception_reporting()
{
    Exceptions::fake();

    // Code qui devrait lancer une exception
    $response = $this->post('/api/test', []);

    // Vérifier que l'exception a été reportée
    Exceptions::assertReported(ServiceUnavailableException::class);
}
```

### `assertReported()`
Vérifier qu'une exception spécifique a été reportée.

```php
Exceptions::assertReported(CustomException::class);
Exceptions::assertReported(function (CustomException $e) {
    return $e->getMessage() === 'Message spécifique';
});
```

### `assertNotReported()`
Vérifier qu'une exception n'a PAS été reportée.

```php
Exceptions::assertNotReported(CustomException::class);
```

### `assertNothingReported()`
Vérifier qu'aucune exception n'a été reportée.

```php
Exceptions::assertNothingReported();
```

### `withoutExceptionHandling()`
Désactiver la gestion des exceptions pour tester le comportement brut.

```php
$this->withoutExceptionHandling();
$response = $this->get('/route');
```

### `withExceptionHandling()`
Réactiver la gestion des exceptions après l'avoir désactivée.

```php
$this->withExceptionHandling();
```

### `expectsException()`
Attendre une exception dans un test.

```php
$this->expectException(InvalidArgumentException::class);
$this->expectExceptionMessage('Message attendu');
$this->expectExceptionCode(422);
```

[⬆ Retour au début](#table-des-matières)

---

## ✅ Les Bonnes Pratiques

| Pratique | Pourquoi ? | Exemple |
| :--- | :--- | :--- |
| **Ne pas afficher les erreurs en production** | Éviter de révéler des informations sensibles | `APP_DEBUG=false` + pages d'erreur personnalisées |
| **Catégoriser les exceptions** | Meilleure organisation et maintenance | `BusinessException`, `DatabaseException`, `ApiException` |
| **Utiliser les exceptions personnalisées** | Plus expressif que les exceptions génériques | `throw new InsufficientStockException($productId)` |
| **Ajouter du contexte** | Facilite le debugging | Inclure l'ID utilisateur, l'ID commande, etc. dans les logs |
| **Distinguer les exceptions** | Ne pas logger les erreurs 404 | `$exceptions->dontReport(NotFoundHttpException::class)` |
| **Logger avec niveaux appropriés** | Facilite le filtrage des logs | `Log::info()`, `Log::error()`, `Log::critical()` |
| **Gérer les exceptions API différemment** | Les API doivent retourner du JSON | Vérifier `$request->expectsJson()` ou `$request->is('api/*')` |
| **Centraliser la logique** | Éviter les try/catch partout | Utiliser le Handler pour la logique commune |
| **Tester les exceptions** | S'assurer que les exceptions sont bien levées | Tests avec `expectsException` et `Exceptions::fake()` |
| **Documenter les exceptions** | Pour que les autres développeurs sachent quoi attraper | Docblock avec `@throws` sur les méthodes |

[⬆ Retour au début](#table-des-matières)

---

## 📊 Résumé des Exceptions Courantes de Laravel

| Exception | Description | Code HTTP |
| :--- | :--- | :--- |
| `ModelNotFoundException` | Modèle Eloquent non trouvé | 404 |
| `QueryException` | Erreur de base de données | 500 |
| `ValidationException` | Données invalides | 422 |
| `AuthenticationException` | Non authentifié | 401 |
| `AuthorizationException` | Non autorisé | 403 |
| `NotFoundHttpException` | Route non trouvée | 404 |
| `MethodNotAllowedHttpException` | Méthode HTTP non autorisée | 405 |
| `TooManyRequestsHttpException` | Rate limiting dépassé | 429 |
| `TokenMismatchException` | CSRF token invalide | 419 |
| `MaintenanceModeException` | Application en maintenance | 503 |
| `ThrottleRequestsException` | Trop de tentatives | 429 |

---

## 🎯 Conclusion

La gestion des exceptions dans Laravel est puissante et flexible :
- **Centralisée** via le Handler
- **Personnalisable** avec des exceptions sur mesure
- **Contextuelle** selon le type de requête (web, API)
- **Testable** avec les fakers d'exceptions
- **Sécurisée** en masquant les détails en production

En maîtrisant ces concepts, vous créerez des applications robustes qui gèrent élégamment les erreurs et offrent une bonne expérience utilisateur même en cas de problème.
