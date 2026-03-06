# Modèles Eloquent ORM - Guide Complet avec Exemples

## Table des matières
1. [Les Bases du Modèle Eloquent](#-les-bases-du-modèle-eloquent)
2. [Les Opérations CRUD de Base](#-les-opérations-crud-de-base)
3. [Les Relations Entre Modèles](#-les-relations-entre-modèles)
4. [L'Optimisation des Requêtes](#-loptimisation-des-requêtes)
5. [Les Scopes (Portées de Requête)](#-les-scopes-portées-de-requête)
6. [Mutateurs, Accesseurs et Casts](#-mutateurs-accesseurs-et-casts)
7. [Le Soft Delete](#-le-soft-delete)
8. [Les Collections Eloquent](#-les-collections-eloquent)

---

## 🧱 Les Bases du Modèle Eloquent

| Concept | Explication | Exemple concret |
| :--- | :--- | :--- |
| **Définition** | Un modèle Eloquent est une classe PHP qui représente une table de votre base de données. | `class User extends Model { }` représente la table `users`. |
| **Convention de nom** | Le nom de la classe est le singulier du nom de la table. | Classe `Article` → table `articles` <br> Classe `Categorie` → table `categories` |
| **Clé primaire** | Par défaut, elle est supposée être `id`. | Si votre clé primaire s'appelle `user_id` au lieu de `id`, il faut le préciser. |
| **Création** | `php artisan make:model NomDuModele` | `php artisan make:model Product -m` crée le modèle `Product` et sa migration. |
| **`$table`** | Pour spécifier un nom de table personnalisé. | `protected $table = 'my_products';` si votre table ne s'appelle pas `products`. |
| **`$primaryKey`** | Pour changer le nom de la clé primaire. | `protected $primaryKey = 'user_id';` si votre clé primaire n'est pas `id`. |
| **`$timestamps`** | Active ou désactive les colonnes `created_at` et `updated_at`. | `public $timestamps = false;` pour une table sans ces colonnes. |
| **`$fillable`** | Attributs assignables en masse (sécurité). | `protected $fillable = ['name', 'email', 'password'];` |
| **`$guarded`** | Attributs NON assignables en masse. | `protected $guarded = ['is_admin', 'id'];` (tout le reste est assignable) |
| **`$casts`** | Convertit automatiquement des colonnes. | `protected $casts = ['is_admin' => 'boolean', 'settings' => 'array'];` |

[⬆ Retour au début](#table-des-matières)

## 📡 Les Opérations CRUD de Base

| Opération | Explication | Exemple concret |
| :--- | :--- | :--- |
| **Créer - Méthode 1** | `Model::create()` avec tableau associatif. | `$user = User::create(['name' => 'Jean', 'email' => 'jean@mail.com']);` |
| **Créer - Méthode 2** | Nouvelle instance puis `save()`. | `$user = new User(); $user->name = 'Jean'; $user->email = 'jean@mail.com'; $user->save();` |
| **Lire - Tous** | `Model::all()` récupère tout. | `$tousLesUsers = User::all();` → Collection de tous les utilisateurs. |
| **Lire - Par ID** | `Model::find($id)` par clé primaire. | `$user = User::find(5);` → Récupère l'utilisateur avec ID = 5. |
| **Lire - Avec filtre** | `where()` puis `get()`. | `$admins = User::where('role', 'admin')->get();` → Tous les admins. |
| **Lire - Premier** | `first()` récupère le premier. | `$premierUser = User::where('age', '>', 18)->first();` |
| **Lire - Avec exception** | `findOrFail()` lance erreur 404 si non trouvé. | `$user = User::findOrFail(999);` → Si ID 999 n'existe pas, erreur 404. |
| **Mettre à jour** | Modifier puis `save()`. | `$user = User::find(1); $user->name = 'Nouveau nom'; $user->save();` |
| **Supprimer - Instance** | `delete()` sur une instance. | `$user = User::find(1); $user->delete();` |
| **Supprimer - Par ID** | `Model::destroy($id)`. | `User::destroy(5);` ou `User::destroy([1, 2, 3]);` pour plusieurs. |

[⬆ Retour au début](#table-des-matières)

## 🔗 Les Relations Entre Modèles

| Type | Explication | Exemple concret |
| :--- | :--- | :--- |
| **One to One** | Un utilisateur a un téléphone. | **Modèle User** : `public function phone() { return $this->hasOne(Phone::class); }` <br> **Utilisation** : `$telephone = $user->phone;` |
| **One to Many** | Un article a plusieurs commentaires. | **Modèle Post** : `public function comments() { return $this->hasMany(Comment::class); }` <br> **Utilisation** : `$commentaires = $post->comments;` |
| **Many to Many** | Un utilisateur a plusieurs rôles, et vice-versa. | **Modèle User** : `public function roles() { return $this->belongsToMany(Role::class); }` <br> **Utilisation** : `$roles = $user->roles;` <br> **Table pivot** : `role_user` avec `user_id` et `role_id`. |
| **Has Many Through** | Pays → Utilisateurs → Articles. | **Modèle Country** : `public function posts() { return $this->hasManyThrough(Post::class, User::class); }` <br> **Utilisation** : `$articlesDuPays = $country->posts;` |
| **Polymorphique** | Un commentaire peut être sur un article OU une vidéo. | **Modèle Comment** : `public function commentable() { return $this->morphTo(); }` <br> **Modèle Post** : `public function comments() { return $this->morphMany(Comment::class, 'commentable'); }` <br> **Modèle Video** : pareil que Post. <br> **Utilisation** : `$commentairesDeArticle = $post->comments;` et `$commentables = $comment->commentable;` |

[⬆ Retour au début](#table-des-matières)

## ⚡ L'Optimisation des Requêtes

| Concept | Explication | Exemple concret |
| :--- | :--- | :--- |
| **Problème N+1** | 1 requête parents + N requêtes enfants. | **Problème** : <br> `$posts = Post::all();` (1 requête) <br> `foreach($posts as $post) { echo $post->user->name; }` (N requêtes) <br> → Total : N+1 requêtes ! |
| **Eager Loading** | Charge tout en 2 requêtes max. | **Solution** : <br> `$posts = Post::with('user')->get();` (2 requêtes : une pour posts, une pour users) <br> `foreach($posts as $post) { echo $post->user->name; }` (0 requête supplémentaire) |
| **Chargement conditionnel** | Ne charge que certains champs. | `$users = User::with('posts:id,title,user_id')->get();` → Ne charge que l'ID, le titre et la clé étrangère des posts. |
| **Eager Loading multiple** | Charge plusieurs relations. | `$books = Book::with(['author', 'publisher'])->get();` |
| **Eager Loading imbriqué** | Charge relations de relations. | `$users = User::with('posts.comments')->get();` → Users, leurs posts, et les commentaires de ces posts. |

[⬆ Retour au début](#table-des-matières)

## 🎣 Les Scopes (Portées de Requête)

| Type | Explication | Exemple concret |
| :--- | :--- | :--- |
| **Local Scope** | Méthode `scopeQuelqueChose` dans le modèle. | **Dans modèle User** : <br> `public function scopeActif($query) { return $query->where('actif', true); }` <br> `public function scopeAgeMinimum($query, $age) { return $query->where('age', '>=', $age); }` <br> **Utilisation** : <br> `$actifs = User::actif()->get();` <br> `$adultes = User::ageMinimum(18)->get();` <br> `$actifsAdultes = User::actif()->ageMinimum(18)->get();` (peut se chaîner !) |
| **Global Scope** | S'applique à toutes les requêtes. | **Exemple SoftDeletes** : <br> `User::all();` → exclut automatiquement les soft deleted. <br> **Exemple personnalisé** : <br> `User::addGlobalScope('actif', function ($query) { $query->where('actif', true); });` → toutes les requêtes `User::...()` n'incluront que les utilisateurs actifs. |

[⬆ Retour au début](#table-des-matières)

## 🛠️ Mutateurs, Accesseurs et Casts

| Concept | Explication | Exemple concret |
| :--- | :--- | :--- |
| **Accesseur** | Transforme à la récupération. | **Dans modèle User** : <br> `public function getFullNameAttribute() { return "{$this->first_name} {$this->last_name}"; }` <br> `public function getCreatedAtFrenchAttribute() { return $this->created_at->format('d/m/Y H:i'); }` <br> **Utilisation** : <br> `echo $user->full_name;` → "Jean Dupont" <br> `echo $user->created_at_french;` → "15/03/2024 14:30" |
| **Mutateur** | Transforme avant sauvegarde. | **Dans modèle User** : <br> `public function setPasswordAttribute($value) { $this->attributes['password'] = bcrypt($value); }` <br> `public function setNameAttribute($value) { $this->attributes['name'] = ucfirst(strtolower($value)); }` <br> **Utilisation** : <br> `$user->password = 'secret';` → sauvegarde automatiquement le hash. <br> `$user->name = 'jean';` → sauvegarde comme "Jean". |
| **Casting** | Conversion automatique. | **Dans modèle User** : <br> `protected $casts = [ 'is_admin' => 'boolean', 'settings' => 'array', 'birthday' => 'date', 'last_login' => 'datetime', 'score' => 'integer', 'metadata' => 'collection' ];` <br> **Utilisation** : <br> `if ($user->is_admin) { ... }` → c'est déjà un booléen. <br> `$settings = $user->settings['theme'];` → automatiquement décodé depuis JSON. |

[⬆ Retour au début](#table-des-matières)

## 🗑️ Le Soft Delete

| Concept | Explication | Exemple concret |
| :--- | :--- | :--- |
| **Mise en place** | Ajouter SoftDeletes au modèle. | **Migration** : `$table->softDeletes();` <br> **Modèle** : `use SoftDeletes;` <br> **Utilisation normale** : <br> `$post = Post::find(1); $post->delete();` → `deleted_at` est rempli, mais l'enregistrement existe toujours. |
| **Requêtes normales** | Ignorent les soft deleted. | `$posts = Post::all();` → exclut les posts supprimés. |
| **Avec soft deleted** | `withTrashed()` les inclut. | `$tousLesPosts = Post::withTrashed()->get();` → inclut les supprimés. |
| **Seulement supprimés** | `onlyTrashed()`. | `$postsSupprimes = Post::onlyTrashed()->get();` → uniquement les supprimés. |
| **Restaurer** | `restore()` annule la suppression. | `$post = Post::withTrashed()->find(1); $post->restore();` → remet `deleted_at` à null. |
| **Forcer suppression** | `forceDelete()` supprime définitivement. | `$post = Post::withTrashed()->find(1); $post->forceDelete();` → supprime vraiment de la BD. |

[⬆ Retour au début](#table-des-matières)

## 📦 Les Collections Eloquent

| Méthode | Explication | Exemple concret |
| :--- | :--- | :--- |
| **`filter()`** | Filtre avec callback. | `$users = User::all();` <br> `$adultes = $users->filter(fn($user) => $user->age >= 18);` |
| **`map()`** | Modifie chaque élément. | `$nomsMajuscules = $users->map(fn($user) => strtoupper($user->name));` |
| **`reject()`** | Supprime selon condition. | `$mineurs = $users->reject(fn($user) => $user->age >= 18);` |
| **`contains()`** | Vérifie présence valeur. | `$users->contains('name', 'Jean');` → true/false |
| **`pluck()`** | Extrait une colonne. | `$emails = $users->pluck('email');` → collection des emails. <br> `$paires = $users->pluck('name', 'id');` → [1 => 'Jean', 2 => 'Pierre'] |
| **`sum()`** | Somme d'une colonne. | `$totalAge = $users->sum('age');` |
| **`avg()`** | Moyenne. | `$ageMoyen = $users->avg('age');` |
| **`groupBy()`** | Groupe par critère. | `$parRole = $users->groupBy('role');` → tableau avec clés 'admin', 'user', etc. |
| **`firstWhere()`** | Premier élément correspondant. | `$jean = $users->firstWhere('name', 'Jean');` |
| **`isEmpty()` / `isNotEmpty()`** | Vérifie si vide. | `if ($users->isNotEmpty()) { ... }` |
| **`toArray()`** | Convertit en tableau. | `$array = $users->toArray();` |
| **`toJson()`** | Convertit en JSON. | `$json = $users->toJson();` |

[⬆ Retour au début](#table-des-matières)

---

## 💡 Résumé des Bonnes Pratiques

| Pratique | Pourquoi ? |
| :--- | :--- |
| **Toujours définir `$fillable` ou `$guarded`** | Évite les failles de sécurité (mass assignment). |
| **Utiliser `with()` pour les relations** | Évite le problème N+1. |
| **Préférer `findOrFail()` quand nécessaire** | Gère élégamment les erreurs 404. |
| **Utiliser les scopes pour les requêtes réutilisables** | Rend le code plus propre et DRY. |
| **Caster les attributs (boolean, array, etc.)** | Évite de faire des conversions manuelles. |
| **Maîtriser les méthodes de collection** | Évite des requêtes SQL supplémentaires. |
