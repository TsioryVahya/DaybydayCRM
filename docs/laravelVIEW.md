# Blade Templates Laravel - Guide Complet avec Exemples

## Table des matières
1. [Les Bases de Blade](#-les-bases-de-blade)
2. [L'Héritage de Templates](#️-lhéritage-de-templates)
3. [L'Affichage des Données](#-laffichage-des-données)
4. [Les Structures de Contrôle](#-les-structures-de-contrôle)
5. [Les Boucles et la Variable $loop](#-les-boucles-et-la-variable-loop)
6. [Les Inclusions et Composants](#-les-inclusions-et-composants)
7. [Les Formulaires et CSRF](#-les-formulaires-et-csrf)
8. [Les Directives d'Authentification](#-les-directives-dauthentification)
9. [Blade et JavaScript](#-blade-et-javascript)
10. [Les Directives Personnalisées](#-les-directives-personnalisées)
11. [Les Bonnes Pratiques](#-les-bonnes-pratiques)

---

## 🧩 Les Bases de Blade

**Définition** — Blade est le moteur de templates simple mais puissant de Laravel. Les templates sont compilés en PHP pur et mis en cache. Les fichiers ont l'extension `.blade.php` et sont placés dans `resources/views/`.

### Affichage d'une vue
Retourner une vue depuis une route ou un contrôleur.

```php
// Route
Route::get('/accueil', function () {
    return view('accueil');
});
```

### Passage de données
Transmettre des variables à la vue.

```php
// Avec un tableau
return view('profil', ['nom' => 'Jean', 'age' => 25]);

// Ou avec compact()
return view('profil', compact('nom', 'age'));
```

### Commentaires Blade
Commentaires invisibles dans le HTML généré.

```blade
{{-- Ceci est un commentaire Blade --}}
```

[⬆ Retour au début](#table-des-matières)

---

## 🏗️ L'Héritage de Templates

### Layout principal
Définir un template de base avec des sections.

```blade
{{-- layouts/app.blade.php --}}
<!DOCTYPE html>
<html>
<head>
    <title>@yield('title', 'Titre par défaut')</title>
</head>
<body>
    @section('sidebar')
        <p>Sidebar par défaut</p>
    @show
    <div class="content">
        @yield('content')
    </div>
</body>
</html>
```

### Extension de layout
Une vue enfant hérite du layout avec `@extends`.

```blade
{{-- profil.blade.php --}}
@extends('layouts.app')

@section('title', 'Profil Utilisateur')

@section('sidebar')
    @parent
    <p>Ajout au sidebar existant</p>
@endsection

@section('content')
    <p>Contenu de la page profil</p>
@endsection
```

### Inclusion de sections
Inclure une section avec possibilité de valeur par défaut.

```blade
@yield('sidebar')
@yield('sidebar', 'Sidebar par défaut')
```

### Vérification de section
Vérifier si une section a du contenu.

```blade
@hasSection('sidebar')
    <div class="sidebar">@yield('sidebar')</div>
@endif

@sectionMissing('sidebar')
    <p>Pas de sidebar</p>
@endif
```

[⬆ Retour au début](#table-des-matières)

---

## 📢 L'Affichage des Données

### `{{ }}` — Affichage avec échappement (protection XSS)

```blade
Bonjour, {{ $nom }} !
L'âge est {{ $age }} ans.
Résultat: {{ 5 + 3 }}
```

### `{!! !!}` — HTML brut sans échappement
> ⚠️ Attention aux failles XSS, n'utiliser qu'avec des données de confiance.

```blade
{!! $contenuHtml !!}
{{-- Si $contenuHtml = "<strong>Texte</strong>" → Affiche en gras : Texte --}}
```

### `{{ $var or 'default' }}` — Valeur par défaut
Affiche une variable ou une valeur par défaut si elle n'existe pas.

```blade
{{ $utilisateur or 'Visiteur' }}
{{-- Affiche "Visiteur" si $utilisateur n'existe pas --}}
```

### `@json` — Tableau PHP vers JSON

```blade
<script>
    var user = @json($user);
    console.log(user.name);
</script>
```

### `Js::from()` — Alternative moderne (Laravel 8+)

```blade
<script>
    var user = {{ Js::from($user) }};
</script>
```

[⬆ Retour au début](#table-des-matières)

---

## 🔀 Les Structures de Contrôle

### `@if` / `@elseif` / `@else`

```blade
@if($age >= 18)
    <p>Vous êtes majeur</p>
@elseif($age >= 16)
    <p>Presque majeur</p>
@else
    <p>Vous êtes mineur</p>
@endif
```

### `@unless`
Inverse de `@if` — exécute si la condition est fausse.

```blade
@unless(Auth::check())
    <p>Vous n'êtes pas connecté</p>
@endunless
```

### `@isset`
Vérifie si une variable existe et n'est pas nulle.

```blade
@isset($utilisateur)
    <p>Nom: {{ $utilisateur->nom }}</p>
@endisset
```

### `@empty`
Vérifie si une variable est vide.

```blade
@empty($listeTaches)
    <p>Aucune tâche pour le moment</p>
@endempty
```

### `@switch`

```blade
@switch($role)
    @case('admin')
        <p>Accès administrateur</p>
        @break
    @case('editor')
        <p>Accès éditeur</p>
        @break
    @default
        <p>Accès limité</p>
@endswitch
```

### `@production`
Contenu uniquement en environnement de production.

```blade
@production
    <!-- Google Analytics -->
@endproduction
```

### `@env`
Contenu pour un environnement spécifique.

```blade
@env('local')
    <p>Mode débogage activé</p>
@endenv
```

[⬆ Retour au début](#table-des-matières)

---

## 🔁 Les Boucles et la Variable $loop

### `@for`

```blade
@for($i = 0; $i < 10; $i++)
    <p>Itération {{ $i }}</p>
@endfor
```

### `@foreach`

```blade
@foreach($utilisateurs as $utilisateur)
    <li>{{ $utilisateur->nom }}</li>
@endforeach
```

### `@forelse`
Comme `@foreach` avec gestion du cas vide.

```blade
@forelse($articles as $article)
    <article>{{ $article->titre }}</article>
@empty
    <p>Aucun article trouvé</p>
@endforelse
```

### `@while`

```blade
@while($i < 10)
    <p>{{ $i++ }}</p>
@endwhile
```

### `@continue`
Passe à l'itération suivante.

```blade
@foreach($items as $item)
    @continue($item->inactif)
    <p>{{ $item->nom }}</p>
@endforeach
```

### `@break`
Sort de la boucle.

```blade
@foreach($items as $item)
    @if($item->id == $recherche)
        <p>Trouvé: {{ $item->nom }}</p>
        @break
    @endif
@endforeach
```

### La variable `$loop` dans `@foreach`

| Propriété | Description |
| :--- | :--- |
| `$loop->first` | `true` à la première itération |
| `$loop->last` | `true` à la dernière itération |
| `$loop->index` | Index courant (commence à 0) |
| `$loop->iteration` | Itération courante (commence à 1) |
| `$loop->count` | Nombre total d'éléments |
| `$loop->remaining` | Nombre d'éléments restants |
| `$loop->depth` | Profondeur de la boucle (1 pour une boucle simple) |
| `$loop->parent` | Accès à la variable `$loop` de la boucle parente |

### Exemple complet avec `$loop`

```blade
@foreach($categories as $categorie)
    <h3>{{ $categorie->nom }}</h3>
    <ul>
    @foreach($categorie->articles as $article)
        @if($loop->parent->first && $loop->first)
            <li class="highlight">{{ $article->titre }} (Premier de la première catégorie)</li>
        @else
            <li>{{ $loop->iteration }}. {{ $article->titre }}</li>
        @endif
    @endforeach
    </ul>
    @if(!$loop->last)
        <hr>
    @endif
@endforeach
```

[⬆ Retour au début](#table-des-matières)
