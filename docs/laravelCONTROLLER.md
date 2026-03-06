# es Controllers Laravel - Guide Complet avec Exemples

## Table des matières

1. [Les Bases du Controller](#-les-bases-du-controller)
2. [Création des Controllers](#-création-des-controllers)
3. [Types de Controllers](#-types-de-controllers)
4. [Les Méthodes du Controller](#-les-méthodes-du-controller)
5. [L&#39;Injection de Dépendances](#-linjection-de-dépendances)
6. [La Gestion des Requêtes](#-la-gestion-des-requêtes)
7. [Les Réponses du Controller](#-les-réponses-du-controller)
8. [Le RESTful (Resource Controller)](#-le-restful-resource-controller)
9. [Le Middleware dans les Controllers](#-le-middleware-dans-les-controllers)
10. [Les Bonnes Pratiques](#-les-bonnes-pratiques)

---

## 🎯 Les Bases du Controller

| Concept               | Explication                                                                                | Exemple concret                                                                                         |
| :-------------------- | :----------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------ |
| **Définition** | Un controller est une classe PHP qui regroupe la logique de traitement des requêtes HTTP. | `class UserController extends Controller { }`                                                         |
| **Rôle**       | Il fait le lien entre les routes et la logique métier (modèles, services).               | Requête GET `/users` → `UserController@index` → récupère les utilisateurs → retourne une vue. |
| **Emplacement** | Les controllers sont stockés dans `app/Http/Controllers/`.                              | `app/Http/Controllers/UserController.php`                                                             |
| **Base**        | Tous les controllers héritent de la classe `Controller` de base.                        | `class ProductController extends Controller { }`                                                      |

---

## 🏗️ Création des Controllers

| Commande            | Explication                                   | Résultat                                                   |
| :------------------ | :-------------------------------------------- | :---------------------------------------------------------- |
| **Simple**    | `php artisan make:controller NomController` | Crée une classe vide dans le dossier Controllers.          |
| **Invokable** | `... --invokable`                           | Crée un controller avec l'unique méthode `__invoke()`.  |
| **Resource**  | `... --resource`                            | Génère les 7 méthodes CRUD (index, create, store, etc.). |
| **API**       | `... --api`                                 | Version resource sans les méthodes `create` et `edit`. |
| **Modèle**   | `... --model=Post`                          | Lie le modèle et ajoute le type-hinting automatiquement.   |
| **Dossier**   | `... Admin/UserController`                  | Crée le controller dans un sous-dossier spécifique.       |

---

## 📋 Types de Controllers

### Controller classique

Regroupe plusieurs méthodes pour une même ressource.

```php
class PageController extends Controller {
    public function home() { return view('home'); }
    public function about() { return view('about'); }
}
```

### Invokable Controller

Utilisé pour une action unique.

```php
// Définition
class DashboardController extends Controller {
    public function __invoke() {
        return view('dashboard');
    }
}
// Route simplifiée
Route::get('/dashboard', DashboardController::class);
```

---

## ⚙️ Les Méthodes du Controller

| Méthode                  | Rôle                   | Exemple de code                                                         |
| :------------------------ | :---------------------- | :---------------------------------------------------------------------- |
| **`index()`**     | Liste les ressources    | `$posts = Post::all(); return view('posts.index', compact('posts'));` |
| **`create()`**    | Formulaire d'ajout      | `return view('posts.create');`                                        |
| **`store()`**     | Sauvegarde les données | `Post::create($request->validated());`                                |
| **`show($post)`** | Affiche un élément    | `return view('posts.show', compact('post'));`                         |
| **`edit($post)`** | Formulaire d'édition   | `return view('posts.edit', compact('post'));`                         |
| **`update()`**    | Met à jour             | `$post->update($request->validated());`                               |
| **`destroy()`**   | Supprime                | `$post->delete(); return redirect()->route('posts.index');`           |

---

## 💉 L'Injection de Dépendances

* **Injection par constructeur** : Laravel résout les dépendances automatiquement via le conteneur de services.
* **Injection dans les méthodes** : Utile pour injecter la `Request` ou des services spécifiques à une action.
* **Route Model Binding implicite** : Laravel injecte l'instance du modèle correspondant à l'ID présent dans l'URL.
* **Binding avec clé personnalisée** : On peut spécifier un champ comme le `slug` dans la route : `/posts/{post:slug}`.

---

## 📨 La Gestion des Requêtes

### Accès aux données

* `$request->all()` : Récupère toutes les données.
* `$request->input('name')` : Récupère un champ spécifique.
* `$request->has('email')` : Vérifie la présence d'un champ.

### Validation (Form Request)

Il est recommandé d'utiliser des classes dédiées pour la validation :

```bash
php artisan make:request PostRequest
```

```php
public function store(PostRequest $request) {
    Post::create($request->validated()); // Données déjà validées
}
```

---

## 📤 Les Réponses du Controller

| Type de réponse                 | Syntaxe                                                  |
| :------------------------------- | :------------------------------------------------------- |
| **Vue**                    | `return view('posts.index', compact('posts'));`        |
| **Redirection**            | `return redirect()->route('posts.index');`             |
| **Redirection avec Flash** | `return back()->with('success', 'Action réussie !');` |
| **JSON (API)**             | `return response()->json($data, 200);`                 |
| **Téléchargement**       | `return response()->download($pathToFile);`            |
| **Fichier (Affichage)**    | `return response()->file($pathToFile);`                |

---

## 🔄 Le RESTful (Resource Controller)

Une seule déclaration de route suffit pour les 7 actions standards :

```php
Route::resource('posts', PostController::class);
```

### Actions Resource

| Verbe  | URL               | Méthode    | Nom de route      |
| :----- | :---------------- | :---------- | :---------------- |
| GET    | `/posts`        | `index`   | `posts.index`   |
| GET    | `/posts/create` | `create`  | `posts.create`  |
| POST   | `/posts`        | `store`   | `posts.store`   |
| GET    | `/posts/{post}` | `show`    | `posts.show`    |
| DELETE | `/posts/{post}` | `destroy` | `posts.destroy` |

---

## 🛡️ Le Middleware dans les Controllers

On peut assigner des middlewares directement dans le constructeur :

```php
class PostController extends Controller {
    public function __construct() {
        $this->middleware('auth'); // Pour toutes les méthodes
        $this->middleware('admin')->only('destroy'); // Uniquement la suppression
        $this->middleware('log')->except('index', 'show'); // Sauf la lecture
    }
}
```

---

## ✅ Les Bonnes Pratiques

* **Thin Controllers** : Gardez vos controllers légers ; déportez la logique métier dans des Services ou des Actions.
* **Form Requests** : Ne validez pas les données directement dans le controller.
* **Route Model Binding** : Laissez Laravel récupérer vos modèles automatiquement.
* **Single Responsibility** : Un controller ne doit gérer qu'un seul type de ressource.
* **API Resources** : Utilisez les classes Resources pour transformer vos modèles en JSON proprement.

---
