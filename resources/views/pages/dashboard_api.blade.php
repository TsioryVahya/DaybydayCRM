@extends('layouts.master')

@section('content')
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">{{ __('API Dashboard') }}</h1>
    </div>
</div>

<!-- Totals Cards -->
<div class="row">
    <div class="col-md-2">
        <div class="panel panel-primary text-center" style="cursor:pointer" onclick="loadDetails('clients')">
            <div class="panel-heading">
                <h3 id="total-clients">0</h3>
                <p>{{ __('Clients') }}</p>
            </div>
        </div>
    </div>
    <div class="col-md-2">
        <div class="panel panel-success text-center" style="cursor:pointer" onclick="loadDetails('projects')">
            <div class="panel-heading">
                <h3 id="total-projects">0</h3>
                <p>{{ __('Projects') }}</p>
            </div>
        </div>
    </div>
    <div class="col-md-2">
        <div class="panel panel-info text-center" style="cursor:pointer" onclick="loadDetails('tasks')">
            <div class="panel-heading">
                <h3 id="total-tasks">0</h3>
                <p>{{ __('Tasks') }}</p>
            </div>
        </div>
    </div>
    <div class="col-md-2">
        <div class="panel panel-warning text-center" style="cursor:pointer" onclick="loadDetails('offers')">
            <div class="panel-heading">
                <h3 id="total-offers">0</h3>
                <p>{{ __('Offers') }}</p>
            </div>
        </div>
    </div>
    <div class="col-md-2">
        <div class="panel panel-danger text-center" style="cursor:pointer" onclick="loadDetails('invoices')">
            <div class="panel-heading">
                <h3 id="total-invoices">0</h3>
                <p>{{ __('Invoices') }}</p>
            </div>
        </div>
    </div>
    <div class="col-md-2">
        <div class="panel panel-default text-center" style="cursor:pointer" onclick="loadDetails('payments')">
            <div class="panel-heading">
                <h3 id="total-payments">0</h3>
                <p>{{ __('Payments') }}</p>
            </div>
        </div>
    </div>
</div>

<!-- Graphs Row -->
<div class="row" style="margin-top: 2em;">
    <div class="col-md-4">
        <div class="panel panel-default">
            <div class="panel-heading">Invoices per Month</div>
            <div class="panel-body">
                <canvas id="invoiceChart"></canvas>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-default">
            <div class="panel-heading">Task Status Distribution</div>
            <div class="panel-body">
                <canvas id="taskChart"></canvas>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-default">
            <div class="panel-heading">Payment Sources</div>
            <div class="panel-body">
                <canvas id="paymentChart"></canvas>
            </div>
        </div>
    </div>
</div>

<!-- Modal for Details -->
<div class="modal fade" id="detailsModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span>&times;</span></button>
                <h4 class="modal-title" id="modalTitle">Details</h4>
            </div>
            <div class="modal-body">
                <ul class="list-group" id="detailsList">
                    <!-- Dynamic content -->
                </ul>
            </div>
        </div>
    </div>
</div>

@stop

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
$(document).ready(function() {
    loadStats();
});

function loadStats() {
    $.ajax({
        url: 'http://localhost:8080/api/stats',
        method: 'GET',
        success: function(data) {
            // Fill Totals
            $('#total-clients').text(data.totals.clients);
            $('#total-projects').text(data.totals.projects);
            $('#total-tasks').text(data.totals.tasks);
            $('#total-offers').text(data.totals.offers);
            $('#total-invoices').text(data.totals.invoices);
            $('#total-payments').text(data.totals.payment_amount.toFixed(2) + ' €');

            // Charts
            initInvoiceChart(data.graphs.monthly_invoices);
            initTaskChart(data.graphs.task_status);
            initPaymentChart(data.graphs.payment_sources);
        }
    });
}

function loadDetails(type) {
    $('#modalTitle').text('Recent ' + type.charAt(0).toUpperCase() + type.slice(1));
    $('#detailsList').empty().append('<li class="list-group-item">Loading...</li>');
    $('#detailsModal').modal('show');

    $.ajax({
        url: 'http://localhost:8080/api/details/' + type,
        method: 'GET',
        success: function(data) {
            $('#detailsList').empty();
            data.forEach(function(item) {
                $('#detailsList').append(
                    '<li class="list-group-item">' +
                    '<strong>' + item.title + '</strong><br>' +
                    '<small class="text-muted">' + (item.subtitle || '') + ' - ' + item.created_at + '</small>' +
                    '</li>'
                );
            });
        }
    });
}

function initInvoiceChart(data) {
    const ctx = document.getElementById('invoiceChart');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: data.map(i => i.month),
            datasets: [{
                label: 'Invoices',
                data: data.map(i => i.count),
                borderColor: '#3498db',
                fill: false
            }]
        }
    });
}

function initTaskChart(data) {
    const ctx = document.getElementById('taskChart');
    new Chart(ctx, {
        type: 'pie',
        data: {
            labels: data.map(i => i.label),
            datasets: [{
                data: data.map(i => i.value),
                backgroundColor: ['#e74c3c', '#2ecc71', '#f1c40f', '#9b59b6']
            }]
        }
    });
}

function initPaymentChart(data) {
    const ctx = document.getElementById('paymentChart');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: data.map(i => i.label),
            datasets: [{
                label: 'Payments',
                data: data.map(i => i.value),
                backgroundColor: '#1abc9c'
            }]
        }
    });
}
</script>
@endpush
