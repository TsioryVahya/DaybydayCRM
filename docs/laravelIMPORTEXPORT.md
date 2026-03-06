# Laravel - Import et Export de Données (CSV, Excel) - Guide Complet

## Table des matières

1. [Introduction et Installation](#-introduction-et-installation)
2. [Les Exports - Concepts de Base](#-les-exports---concepts-de-base)
3. [Les Exports Avancés](#-les-exports-avancés)
4. [Les Imports - Concepts de Base](#-les-imports---concepts-de-base)
5. [Les Imports Avancés](#-les-imports-avancés)
6. [Gestion des Grands Fichiers](#-gestion-des-grands-fichiers)
7. [Import avec Jobs et Queues](#-import-avec-jobs-et-queues)
8. [Validation et Gestion d&#39;Erreurs](#-validation-et-gestion-derreurs)
9. [Format CSV et OpenOffice](#-format-csv-et-openoffice)
10. [Interface Utilisateur (Blade)](#-interface-utilisateur-blade)
11. [Les Bonnes Pratiques](#-les-bonnes-pratiques)

---



## 📦 Introduction et Installation

**Laravel Excel** est un wrapper élégant autour de PhpSpreadsheet qui simplifie les exports et imports. Développé par Spartner (anciennement Maatwebsite), c'est le package le plus populaire pour Excel dans Laravel.

### Installation

```bash
composer require maatwebsite/excel
```

### Publication de la config

```bash
php artisan vendor:publish --provider="Maatwebsite\Excel\ExcelServiceProvider"
```

Le fichier de configuration est ensuite disponible dans `config/excel.php`. Il permet de configurer les exports, imports, queues, etc.

> **Compatibilité :** Version 3.1 — Laravel ^5.8 et PHP ^7.2|^8.0

[⬆ Retour au début](#table-des-matières)

---

## 📤 Les Exports - Concepts de Base

### Création d'une classe d'export

```bash
php artisan make:export UsersExport --model=User
```

### Export simple

Exporter une collection Eloquent.

```php
// app/Exports/UsersExport.php
namespace App\Exports;

use App\Models\User;
use Maatwebsite\Excel\Concerns\FromCollection;

class UsersExport implements FromCollection
{
    public function collection()
    {
        return User::all();
    }
}
```

### Export dans un contrôleur

```php
// Dans UserController.php
use App\Exports\UsersExport;
use Maatwebsite\Excel\Facades\Excel;

public function export()
{
    return Excel::download(new UsersExport, 'utilisateurs.xlsx');
}
```

### Route pour l'export

```php
// Dans web.php
Route::get('/users/export', [UserController::class, 'export'])->name('users.export');
```

### Formats de fichier supportés

```php
Excel::download(new UsersExport, 'users.xlsx');
Excel::download(new UsersExport, 'users.csv', \Maatwebsite\Excel\Excel::CSV);
Excel::download(new UsersExport, 'users.ods', \Maatwebsite\Excel\Excel::ODS);
```

### Ajout d'en-têtes avec `WithHeadings`

```php
use Maatwebsite\Excel\Concerns\WithHeadings;

class UsersExport implements FromCollection, WithHeadings
{
    public function headings(): array
    {
        return [
            'ID',
            'Nom',
            'Email',
            'Date de création'
        ];
    }

    public function collection()
    {
        return User::all(['id', 'name', 'email', 'created_at']);
    }
}
```

[⬆ Retour au début](#table-des-matières)

---

## 🚀 Les Exports Avancés

### `WithMapping` — Formatage des données

Formater chaque ligne avant export.

```php
use Maatwebsite\Excel\Concerns\WithMapping;

class UsersExport implements FromCollection, WithMapping
{
    public function map($user): array
    {
        return [
            $user->id,
            $user->name,
            $user->email,
            $user->created_at->format('d/m/Y H:i'),
            $user->is_admin ? 'Oui' : 'Non',
            $user->profile?->phone ?? 'Non renseigné'
        ];
    }
}
```

### `WithMapping` avec relations

```php
public function map($user): array
{
    return [
        $user->id,
        $user->name,
        $user->posts_count,                          // Avec withCount
        $user->company->name ?? 'N/A',               // Relation
        $user->roles->pluck('name')->implode(', ')   // Collection
    ];
}
```

### `WithEvents` — Stylisation

```php
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Events\AfterSheet;

class ProductsExport implements FromCollection, WithHeadings, WithEvents
{
    public function registerEvents(): array
    {
        return [
            AfterSheet::class => function(AfterSheet $event) {
                $headingCount = count($this->headings());
                $columnRange = 'A1:' . \PhpOffice\PhpSpreadsheet\Cell\Coordinate::stringFromColumnIndex($headingCount) . '1';

                // Gras pour les en-têtes
                $event->sheet->getDelegate()->getStyle($columnRange)->getFont()->setBold(true);

                // Fond gris pour les en-têtes
                $event->sheet->getDelegate()->getStyle($columnRange)->getFill()
                    ->setFillType('solid')->getStartColor()->setARGB('FFCCCCCC');

                // Largeur automatique des colonnes
                foreach (range('A', \PhpOffice\PhpSpreadsheet\Cell\Coordinate::stringFromColumnIndex($headingCount)) as $column) {
                    $event->sheet->getDelegate()->getColumnDimension($column)->setAutoSize(true);
                }
            },
        ];
    }
}
```

### `WithColumnWidths` — Largeur des colonnes

```php
use Maatwebsite\Excel\Concerns\WithColumnWidths;

class ProductsExport implements WithColumnWidths
{
    public function columnWidths(): array
    {
        return [
            'A' => 10,
            'B' => 30,
            'C' => 50,
            'D' => 15
        ];
    }
}
```

### `WithStyles` — Styling simplifié

```php
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;

class ProductsExport implements WithStyles
{
    public function styles(Worksheet $sheet)
    {
        return [
            1    => ['font' => ['bold' => true]],             // Ligne 1 en gras
            'A'  => ['font' => ['size' => 12]],               // Colonne A
            'B'  => ['alignment' => ['horizontal' => 'center']],
        ];
    }
}
```

### `FromQuery` — Export avec chunking automatique

```php
use Maatwebsite\Excel\Concerns\FromQuery;

class UsersExport implements FromQuery
{
    public function query()
    {
        return User::query()->with('profile')->where('active', true);
    }
    // Gère automatiquement le chunking pour les grands jeux de données
}
```

### `WithChunkCount` — Taille des chunks personnalisée

```php
use Maatwebsite\Excel\Concerns\WithChunkCount;

class UsersExport implements FromQuery, WithChunkCount
{
    public function chunkSize(): int
    {
        return 500; // Par défaut 100
    }
}
```

### `FromView` — Export depuis une vue Blade

```php
use Maatwebsite\Excel\Concerns\FromView;
use Illuminate\Contracts\View\View;

class ProductsExport implements FromView
{
    public function view(): View
    {
        return view('exports.products', [
            'products' => Product::with('category')->get()
        ]);
    }
}
```

Vue Blade correspondante :

```blade
{{-- resources/views/exports/products.blade.php --}}
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
</head>
<body>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Catégorie</th>
                <th>Prix</th>
                <th>Stock</th>
            </tr>
        </thead>
        <tbody>
            @foreach($products as $product)
            <tr>
                <td>{{ $product->id }}</td>
                <td>{{ $product->name }}</td>
                <td>{{ $product->category->name }}</td>
                <td>{{ number_format($product->price, 2) }} €</td>
                <td>{{ $product->stock }}</td>
            </tr>
            @endforeach
        </tbody>
    </table>
</body>
</html>
```

### Export paramétré (filtres par dates)

```php
// Dans la classe d'export
class OrdersExport implements FromQuery
{
    protected $startDate;
    protected $endDate;

    public function __construct($startDate, $endDate)
    {
        $this->startDate = $startDate;
        $this->endDate = $endDate;
    }

    public function query()
    {
        return Order::whereBetween('created_at', [$this->startDate, $this->endDate]);
    }
}

// Dans le contrôleur
return Excel::download(new OrdersExport($start, $end), 'commandes.xlsx');
```

[⬆ Retour au début](#table-des-matières)

---

## 📥 Les Imports - Concepts de Base

### Création d'une classe d'import

```bash
php artisan make:import UsersImport --model=User
```

### `ToModel` — Import vers un modèle Eloquent

```php
// app/Imports/UsersImport.php
namespace App\Imports;

use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Maatwebsite\Excel\Concerns\ToModel;

class UsersImport implements ToModel
{
    public function model(array $row)
    {
        return new User([
            'name'     => $row[0],
            'email'    => $row[1],
            'password' => Hash::make($row[2]),
        ]);
    }
}
```

### Import dans un contrôleur

```php
// Dans UserController.php
use App\Imports\UsersImport;
use Maatwebsite\Excel\Facades\Excel;

public function import(Request $request)
{
    $request->validate(['file' => 'required|mimes:xlsx,csv']);

    Excel::import(new UsersImport, $request->file('file'));

    return back()->with('success', 'Import réussi !');
}
```

### Route pour l'import

```php
// Dans web.php
Route::post('/users/import', [UserController::class, 'import'])->name('users.import');
```

### `WithHeadingRow` — Utiliser la première ligne comme clés

```php
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class UsersImport implements ToModel, WithHeadingRow
{
    public function model(array $row)
    {
        // Accès par nom de colonne : $row['name'], $row['email']
        return new User([
            'name'     => $row['name'],
            'email'    => $row['email'],
            'password' => Hash::make($row['password']),
        ]);
    }
}
```

### `HeadingRowFormatter` — Formater les noms d'en-têtes

```php
use Maatwebsite\Excel\Imports\HeadingRowFormatter;

HeadingRowFormatter::extend('custom', function($value) {
    return str_replace(' ', '_', strtolower($value));
});
// 'Nom Complet' devient 'nom_complet'
```

[⬆ Retour au début](#table-des-matières)

---

## 🔧 Les Imports Avancés

### `WithValidation` — Valider chaque ligne

```php
use Maatwebsite\Excel\Concerns\WithValidation;

class UsersImport implements ToModel, WithValidation, WithHeadingRow
{
    public function rules(): array
    {
        return [
            'name'     => 'required|string|max:255',
            'email'    => 'required|email|unique:users,email',
            'password' => 'required|min:8',
        ];
    }

    public function customValidationMessages()
    {
        return [
            'email.unique' => 'L\'email :input existe déjà dans la base.',
        ];
    }
}
```

### `SkipsOnFailure` — Continuer malgré les erreurs

```php
use Maatwebsite\Excel\Concerns\SkipsOnFailure;
use Maatwebsite\Excel\Concerns\WithValidation;
use Maatwebsite\Excel\Validators\Failure;

class UsersImport implements ToModel, WithValidation, SkipsOnFailure
{
    protected $failures = [];

    public function onFailure(Failure ...$failures)
    {
        $this->failures = array_merge($this->failures, $failures);
    }

    public function getFailures(): array
    {
        return $this->failures;
    }
}
```

### `SkipsOnError` — Ignorer les erreurs et continuer

```php
use Maatwebsite\Excel\Concerns\SkipsOnError;

class UsersImport implements ToModel, SkipsOnError
{
    public function onError(\Throwable $e)
    {
        Log::error('Erreur import: ' . $e->getMessage());
    }
}
```

### `WithLimit` — Limiter le nombre de lignes importées

```php
use Maatwebsite\Excel\Concerns\WithLimit;

class UsersImport implements ToModel, WithLimit
{
    public function limit(): int
    {
        return 1000; // N'importer que les 1000 premières lignes
    }
}
```

### `WithBatchInserts` — Insertion par lots

```php
use Maatwebsite\Excel\Concerns\WithBatchInserts;

class UsersImport implements ToModel, WithBatchInserts
{
    public function batchSize(): int
    {
        return 500; // Insère par lots de 500
    }
}
```

### `WithChunkReading` — Lecture par chunks

```php
use Maatwebsite\Excel\Concerns\WithChunkReading;

class UsersImport implements ToModel, WithChunkReading
{
    public function chunkSize(): int
    {
        return 1000; // Lit 1000 lignes à la fois
    }
}
```

### Combinaison optimale pour grands fichiers

```php
class UsersImport implements ToModel, WithBatchInserts, WithChunkReading
{
    public function batchSize(): int  { return 500; }
    public function chunkSize(): int  { return 1000; }
}
```

### Hooks `BeforeSheet` / `AfterSheet`

```php
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Events\BeforeSheet;

class MultiSheetImport implements WithEvents
{
    public function registerEvents(): array
    {
        return [
            BeforeSheet::class => function(BeforeSheet $event) {
                $sheetName = $event->getSheet()->getTitle();
                Log::info("Traitement de la feuille: " . $sheetName);
            },
        ];
    }
}
```

### Transformation et calculs lors de l'import

```php
public function model(array $row)
{
    // Trouver ou créer la catégorie
    $category = Category::firstOrCreate(['name' => $row['category']]);

    return new Product([
        'name'        => $row['name'],
        'description' => $row['description'] ?? '',
        'price'       => is_numeric($row['price']) ? floatval($row['price']) : 0,
        'category_id' => $category->id,
    ]);
}
```

[⬆ Retour au début](#table-des-matières)

---

## 🐘 Gestion des Grands Fichiers

### Problématique et solutions

| Problème                           | Solution                                             |
| :---------------------------------- | :--------------------------------------------------- |
| **Timeout PHP**               | Utiliser les Queues (traitement en arrière-plan)    |
| **Mémoire insuffisante**     | `WithChunkReading` (lecture par morceaux)          |
| **Performances DB**           | `WithBatchInserts` (lots de 500/1000 insertions)   |
| **Fichiers très volumineux** | `SplFileObject` (CSV de plusieurs centaines de Mo) |

### Configuration de la queue

```env
QUEUE_CONNECTION=database
# ou
QUEUE_CONNECTION=redis
```

```bash
php artisan queue:table
php artisan migrate
```

### Job principal — `ProcessImportJob`

```php
// app/Jobs/ProcessImportJob.php
namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class ProcessImportJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public $timeout = 1200; // 20 minutes
    public $tries = 3;

    public function __construct(private string $filePath, private int $totalLines = 0)
    {}

    public function handle(): void
    {
        $fileStream = fopen($this->filePath, 'r');
        $headers = fgetcsv($fileStream); // Lire l'en-tête

        $batch = [];
        $batchSize = 100;

        while (($line = fgetcsv($fileStream)) !== false) {
            $batch[] = array_combine($headers, $line);

            if (count($batch) >= $batchSize) {
                ProcessProductBatchJob::dispatch($batch);
                $batch = [];
            }
        }

        if (!empty($batch)) {
            ProcessProductBatchJob::dispatch($batch);
        }

        fclose($fileStream);
        unlink($this->filePath); // Nettoyer le fichier temporaire
    }
}
```

### Job par batch — `ProcessProductBatchJob`

```php
// app/Jobs/ProcessProductBatchJob.php
namespace App\Jobs;

use App\Models\Product;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class ProcessProductBatchJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct(private array $batch)
    {}

    public function handle(): void
    {
        foreach ($this->batch as $row) {
            try {
                Product::updateOrCreate(
                    ['sku' => $row['sku']],
                    [
                        'name'  => $row['name'],
                        'price' => $row['price'],
                        'stock' => $row['stock']
                    ]
                );
            } catch (\Exception $e) {
                Log::error("Erreur sur produit {$row['sku']}: " . $e->getMessage());
            }
        }
    }
}
```

### Contrôleur avec queue

```php
public function import(Request $request)
{
    $request->validate(['file' => 'required|mimes:xlsx,csv|max:20480']);

    $path = $request->file('file')->store('imports');
    $fullPath = storage_path('app/' . $path);

    // Compter le nombre de lignes pour le suivi
    $lineCount = 0;
    if (($handle = fopen($fullPath, 'r')) !== false) {
        while (fgetcsv($handle) !== false) $lineCount++;
        fclose($handle);
    }

    ProcessImportJob::dispatch($fullPath, $lineCount - 1); // -1 pour l'en-tête

    return back()->with('success', "Import de {$lineCount} lignes lancé en arrière-plan");
}
```

### Lancer le worker

```bash
php artisan queue:work
# Pour la production, utiliser Supervisor
```

### Configuration Supervisor (production)

```ini
; /etc/supervisor/conf.d/laravel-worker.conf
[program:laravel-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/html/project/artisan queue:work --sleep=3 --tries=3 --max-time=3600
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
user=www-data
numprocs=8
redirect_stderr=true
stdout_logfile=/var/www/html/project/storage/logs/worker.log
stopwaitsecs=3600
```

```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start "laravel-worker:*"
sudo supervisorctl status
```

### `SplFileObject` — Alternative pour très gros CSV

```php
$filePath = storage_path('app/imports/large_file.csv');
$file = new \SplFileObject($filePath, 'r');
$file->setFlags(\SplFileObject::READ_CSV | \SplFileObject::SKIP_EMPTY | \SplFileObject::DROP_NEW_LINE);
$file->setCsvControl(',');

$headers = $file->fgetcsv(); // Lire les en-têtes

while (!$file->eof()) {
    $row = $file->fgetcsv();
    if ($row && $row[0] !== null) {
        // Traiter la ligne
    }
}
```

### Association en-têtes / valeurs

```php
$headers = array_map(function($header) {
    return strtolower(str_replace(' ', '_', $header));
}, $file->fgetcsv());

while (!$file->eof() && ($values = $file->fgetcsv()) !== false) {
    if (count($headers) !== count($values)) {
        continue; // Ligne invalide
    }
    $row = array_combine($headers, $values);
    // $row['name'], $row['email'], etc.
}
```

[⬆ Retour au début](#table-des-matières)

---

## ✅ Validation et Gestion d'Erreurs

### Validation du fichier uploadé

```php
$request->validate([
    'file' => 'required|file|mimes:xlsx,xls,csv|max:10240' // 10 Mo max
]);
```

### Affichage des erreurs de validation dans la vue

```blade
@error('file')
    <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
@enderror
```

### Collecte des erreurs d'import

```php
// Dans le contrôleur
$import = new UsersImport();
Excel::import($import, $request->file('file'));

$failures  = $import->getFailures();
$errorCount = count($failures);

if ($errorCount > 0) {
    session(['import_errors' => $failures]);
    return back()->with('warning', "Import terminé avec $errorCount erreurs");
}

return back()->with('success', 'Import réussi sans erreur !');
```

### Afficher les erreurs détaillées dans la vue

```blade
@if(session('import_errors'))
    <div class="bg-yellow-100 border border-yellow-400 text-yellow-700 px-4 py-3 rounded mb-4">
        <h3 class="font-bold">Erreurs d'import ({{ count(session('import_errors')) }})</h3>
        <ul class="list-disc pl-5 mt-2">
            @foreach(session('import_errors') as $failure)
                <li>Ligne {{ $failure->row() }} : {{ implode(', ', $failure->errors()) }}</li>
            @endforeach
        </ul>
    </div>
@endif
```

### Seuil d'erreurs autorisées

```php
protected $maxErrorPercentage = 10; // 10% max

public function onFailure(Failure ...$failures)
{
    $this->failures = array_merge($this->failures, $failures);
    $errorPercentage = (count($this->failures) / $this->totalRows) * 100;

    if ($errorPercentage > $this->maxErrorPercentage) {
        throw new \Exception("Trop d'erreurs: " . round($errorPercentage, 2) . "%");
    }
}
```

### Stratégies de gestion des erreurs

| Stratégie                | Comportement                                          |
| :------------------------ | :---------------------------------------------------- |
| **Stop on Error**   | Arrête à la première erreur                        |
| **Skip Errors**     | Continue en ignorant les lignes erronées             |
| **Seuil d'erreurs** | Arrête si le pourcentage d'erreurs dépasse un seuil |

### Preview avant import

1. Lire les 10 premières lignes
2. Afficher un aperçu dans un tableau
3. Validation côté serveur des formats
4. Import final avec les données validées

[⬆ Retour au début](#table-des-matières)

---

## 📋 Format CSV et OpenOffice

### Délimiteur personnalisé

```php
// Directement à l'import
Excel::import(new UsersImport, $file, null, \Maatwebsite\Excel\Excel::CSV, ['delimiter' => ';']);

// Ou dans la classe avec WithCustomCsvSettings
use Maatwebsite\Excel\Concerns\WithCustomCsvSettings;

class UsersImport implements WithCustomCsvSettings
{
    public function getCsvSettings(): array
    {
        return [
            'delimiter'      => ';',
            'enclosure'      => '"',
            'escape'         => '\\',
            'input_encoding' => 'UTF-8',
        ];
    }
}
```

### Export en CSV

```php
return Excel::download(new UsersExport, 'users.csv', \Maatwebsite\Excel\Excel::CSV, [
    'Content-Type' => 'text/csv'
]);
```

### Gestion de l'encodage (ISO-8859-1 vs UTF-8)

```php
// Pour l'export
return Excel::download(new UsersExport, 'users.csv', \Maatwebsite\Excel\Excel::CSV, [
    'Content-Encoding' => 'UTF-8',
    'Content-Type'     => 'text/csv; charset=UTF-8',
]);

// Pour l'import
$csvSettings = ['input_encoding' => 'ISO-8859-1'];
```

### Format OpenOffice (ODS)

```php
// Export ODS
return Excel::download(new UsersExport, 'users.ods', \Maatwebsite\Excel\Excel::ODS);

// Import ODS
Excel::import(new UsersImport, 'file.ods', null, \Maatwebsite\Excel\Excel::ODS);

// Avec paramètres
Excel::import(new UsersImport, $file, null, \Maatwebsite\Excel\Excel::ODS, [
    'delimiter' => ',',
]);
```

[⬆ Retour au début](#table-des-matières)

---

## 🎨 Interface Utilisateur (Blade)

### Formulaire d'upload complet

```blade
{{-- resources/views/products/import.blade.php --}}
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Import / Export Produits</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center p-4">
    <div class="max-w-2xl w-full bg-white rounded-xl shadow-lg p-8">
        <h1 class="text-3xl font-bold text-center mb-8 text-gray-800">
            Gestion des Produits
        </h1>

        {{-- Messages flash --}}
        @if(session('success'))
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-lg mb-6 flex items-start">
                <svg class="w-5 h-5 mr-2 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                </svg>
                <span>{{ session('success') }}</span>
            </div>
        @endif

        @if(session('warning'))
            <div class="bg-yellow-100 border border-yellow-400 text-yellow-700 px-4 py-3 rounded-lg mb-6">
                <div class="flex items-start">
                    <svg class="w-5 h-5 mr-2 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
                    </svg>
                    <span>{{ session('warning') }}</span>
                </div>

                {{-- Erreurs détaillées --}}
                @if(session('import_errors'))
                    <div class="mt-4 border-t border-yellow-300 pt-4">
                        <h4 class="font-bold mb-2">Détail des erreurs :</h4>
                        <div class="max-h-64 overflow-y-auto">
                            <table class="min-w-full text-sm">
                                <thead class="bg-yellow-200">
                                    <tr>
                                        <th class="px-3 py-2 text-left">Ligne</th>
                                        <th class="px-3 py-2 text-left">Erreurs</th>
                                        <th class="px-3 py-2 text-left">Valeurs</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-yellow-200">
                                    @foreach(session('import_errors') as $failure)
                                    <tr>
                                        <td class="px-3 py-2 align-top font-mono">{{ $failure->row() }}</td>
                                        <td class="px-3 py-2 align-top">
                                            <ul class="list-disc list-inside">
                                                @foreach($failure->errors() as $error)
                                                    <li class="text-red-600">{{ $error }}</li>
                                                @endforeach
                                            </ul>
                                        </td>
                                        <td class="px-3 py-2 align-top font-mono text-xs">
                                            {{ json_encode($failure->values(), JSON_UNESCAPED_UNICODE) }}
                                        </td>
                                    </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                    </div>
                @endif
            </div>
        @endif

        {{-- Section Import --}}
        <div class="mb-8 border-b border-gray-200 pb-8">
            <h2 class="text-xl font-semibold mb-4 text-gray-700">📥 Importer des produits</h2>
            <form action="{{ route('products.import') }}" method="POST" enctype="multipart/form-data" class="space-y-4">
                @csrf

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">
                        Fichier Excel / CSV
                    </label>
                    <input type="file" name="file" id="file" accept=".xlsx,.xls,.csv,.ods" required
                           class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4
                                  file:rounded-lg file:border-0 file:text-sm file:font-semibold
                                  file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100
                                  cursor-pointer border border-gray-300 rounded-lg p-1">
                    <p class="text-xs text-gray-500 mt-1">
                        Formats acceptés : XLSX, XLS, CSV, ODS (max 10 Mo)
                    </p>
                    @error('file')
                        <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                    @enderror
                </div>

                <div class="flex items-center space-x-4">
                    <button type="submit"
                            class="bg-blue-600 text-white py-2 px-6 rounded-lg hover:bg-blue-700
                                   transition duration-200 font-medium focus:outline-none focus:ring-2
                                   focus:ring-blue-500 focus:ring-offset-2">
                        Importer
                    </button>

                    <a href="{{ route('products.download-template') }}"
                       class="text-blue-600 hover:text-blue-800 text-sm flex items-center">
                        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
                        </svg>
                        Télécharger un template
                    </a>
                </div>
            </form>
        </div>

        {{-- Section Export --}}
        <div class="mb-8 border-b border-gray-200 pb-8">
            <h2 class="text-xl font-semibold mb-4 text-gray-700">📤 Exporter des produits</h2>
            <div class="flex flex-wrap gap-3">
                <a href="{{ route('products.export', ['format' => 'xlsx']) }}"
                   class="bg-green-600 text-white py-2 px-6 rounded-lg hover:bg-green-700
                          transition duration-200 font-medium inline-flex items-center">
                    Excel (XLSX)
                </a>

                <a href="{{ route('products.export', ['format' => 'csv']) }}"
                   class="bg-green-600 text-white py-2 px-6 rounded-lg hover:bg-green-700
                          transition duration-200 font-medium inline-flex items-center">
                    CSV
                </a>

                <a href="{{ route('products.export', ['format' => 'ods']) }}"
                   class="bg-green-600 text-white py-2 px-6 rounded-lg hover:bg-green-700
                          transition duration-200 font-medium inline-flex items-center">
                    OpenOffice (ODS)
                </a>
            </div>
        </div>

        {{-- Aperçu des produits --}}
        <div>
            <h2 class="text-xl font-semibold mb-4 text-gray-700">📋 Aperçu des produits</h2>
            <div class="bg-gray-50 rounded-lg p-4">
                @php
                    $recentProducts = App\Models\Product::latest()->take(5)->get();
                @endphp

                @if($recentProducts->count() > 0)
                    <div class="overflow-x-auto">
                        <table class="min-w-full text-sm">
                            <thead class="bg-gray-200">
                                <tr>
                                    <th class="px-4 py-2 text-left">ID</th>
                                    <th class="px-4 py-2 text-left">Nom</th>
                                    <th class="px-4 py-2 text-left">Prix</th>
                                    <th class="px-4 py-2 text-left">Stock</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-300">
                                @foreach($recentProducts as $product)
                                <tr>
                                    <td class="px-4 py-2">{{ $product->id }}</td>
                                    <td class="px-4 py-2">{{ $product->name }}</td>
                                    <td class="px-4 py-2">{{ number_format($product->price, 2) }} €</td>
                                    <td class="px-4 py-2">{{ $product->stock }}</td>
                                </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                @else
                    <p class="text-gray-500 text-center py-4">Aucun produit pour le moment</p>
                @endif
            </div>
        </div>
    </div>
</body>
</html>
```

[⬆ Retour au début](#table-des-matières)
