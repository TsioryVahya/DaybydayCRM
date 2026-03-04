<?php

namespace App\Api\v1\Controllers;

use App\Models\Client;
use App\Models\Invoice;
use App\Models\Lead;
use App\Models\Offer;
use App\Models\Payment;
use App\Models\Project;
use App\Models\Task;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use DB;

class DashboardController extends Controller
{
    public function stats()
    {
        return response()->json([
            'totals' => [
                'clients' => Client::count(),
                'projects' => Project::count(),
                'tasks' => Task::count(),
                'offers' => Offer::count(),
                'invoices' => Invoice::count(),
                'payments' => Payment::count(),
                'payment_amount' => Payment::sum('amount') / 100,
            ],
            'graphs' => [
                'monthly_invoices' => $this->getMonthlyInvoices(),
                'task_status' => $this->getTaskStatusDistribution(),
                'payment_sources' => $this->getPaymentSourceDistribution(),
            ]
        ]);
    }

    public function details($type)
    {
        $data = [];
        switch ($type) {
            case 'clients':
                $data = Client::latest()->take(10)->get(['company_name as title','company_type as subtitle', 'created_at','external_id as external_id']);
                break;
            case 'projects':
                $data = Project::latest()->take(10)->get(['title', 'deadline as subtitle', 'created_at','external_id as external_id']);
                break;
            case 'tasks':
                $data = Task::latest()->take(10)->get(['title', 'deadline as subtitle', 'created_at']);
                break;
            case 'offers':
                $data = Offer::latest()->take(10)->get(['external_id as title', 'status as subtitle', 'created_at']);
                break;
            case 'invoices':
                $data = Invoice::latest()->take(10)->get(['external_id as title', 'status as subtitle', 'created_at']);
                break;
            case 'payments':
                $data = Payment::latest()->take(10)->get(['amount as title', 'payment_source as subtitle', 'created_at']);
                foreach($data as $d) { $d->title = ($d->title / 100) . ' €'; }
                break;
        }

        return response()->json($data);
    }

    private function getMonthlyInvoices()
    {
        return Invoice::select(DB::raw('count(id) as count'), DB::raw("DATE_FORMAT(created_at, '%M') as month"))
            ->groupBy('month')
            ->orderBy('created_at')
            ->get();
    }

    private function getTaskStatusDistribution()
    {
        return Task::join('statuses', 'tasks.status_id', '=', 'statuses.id')
            ->select('statuses.title as label', DB::raw('count(tasks.id) as value'))
            ->groupBy('statuses.title')
            ->get();
    }

    private function getPaymentSourceDistribution()
    {
        return Payment::select('payment_source as label', DB::raw('count(id) as value'))
            ->groupBy('payment_source')
            ->get();
    }
}
