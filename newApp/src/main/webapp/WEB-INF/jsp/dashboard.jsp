<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DaybydayCRM - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <style>
        :root {
            --sidebar-width: 250px;
            --brand-color: #5d59a6;
        }
        body {
            background-color: #f8f9fa;
        }
        #wrapper {
            display: flex;
            width: 100%;
        }
        #sidebar-wrapper {
            min-height: 100vh;
            width: var(--sidebar-width);
            background-color: #343a40;
            color: white;
            transition: all 0.3s;
        }
        #page-content-wrapper {
            width: 100%;
            padding: 20px;
        }
        .sidebar-heading {
            padding: 1.5rem 1rem;
            font-size: 1.2rem;
            background-color: var(--brand-color);
            font-weight: bold;
        }
        .list-group-item {
            border: none;
            background-color: transparent;
            color: rgba(255,255,255,0.8);
            padding: 0.75rem 1.25rem;
            display: flex;
            align-items: center;
        }
        .list-group-item:hover {
            background-color: rgba(255,255,255,0.1);
            color: white;
        }
        .list-group-item.active {
            background-color: var(--brand-color);
            color: white;
        }
        .material-icons {
            margin-right: 10px;
            font-size: 20px;
        }
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            margin-bottom: 20px;
        }
        .stat-card .card-body {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .stat-icon {
            font-size: 40px;
            opacity: 0.3;
        }

        .card-link {
            text-decoration: none;
            color: inherit;
            display: block;
        }
    </style>
</head>
<body>
<div id="wrapper">
    <jsp:include page="components/sidebar.jsp" />

    <div id="page-content-wrapper">
        <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom mb-4 rounded shadow-sm">
            <div class="container-fluid">
                <span class="navbar-brand mb-0 h1">Dashboard Overview</span>
                <div class="d-flex">
                    <span class="text-muted">Welcome, Administrator</span>
                </div>
            </div>
        </nav>

        <div class="container-fluid">
            <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4">
                <div class="col">
                    <a class="card-link" href="/clients">
                        <div class="card stat-card bg-primary text-white">
                            <div class="card-body">
                                <div>
                                    <h6 class="card-subtitle mb-2">Total Clients</h6>
                                    <h2 class="card-title mb-0">${stats.totalClients}</h2>
                                </div>
                                <span class="material-icons stat-icon">people</span>
                            </div>
                        </div>
                    </a>
                </div>
                <div class="col">
                    <div class="card stat-card bg-success text-white">
                        <div class="card-body">
                            <div>
                                <h6 class="card-subtitle mb-2">Active Projects</h6>
                                <h2 class="card-title mb-0">${stats.activeProjects}</h2>
                            </div>
                            <span class="material-icons stat-icon">assignment</span>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="card stat-card bg-info text-white">
                        <div class="card-body">
                            <div>
                                <h6 class="card-subtitle mb-2">Pending Tasks</h6>
                                <h2 class="card-title mb-0">${stats.pendingTasks}</h2>
                            </div>
                            <span class="material-icons stat-icon">check_circle</span>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="card stat-card bg-warning text-dark">
                        <div class="card-body">
                            <div>
                                <h6 class="card-subtitle mb-2">Open Offers</h6>
                                <h2 class="card-title mb-0">${stats.openOffers}</h2>
                            </div>
                            <span class="material-icons stat-icon">local_offer</span>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="card stat-card bg-danger text-white">
                        <div class="card-body">
                            <div>
                                <h6 class="card-subtitle mb-2">Unpaid Invoices</h6>
                                <h2 class="card-title mb-0">${stats.unpaidInvoices}</h2>
                            </div>
                            <span class="material-icons stat-icon">receipt</span>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <div class="card stat-card bg-secondary text-white">
                        <div class="card-body">
                            <div>
                                <h6 class="card-subtitle mb-2">Payments this Month</h6>
                                <h2 class="card-title mb-0">${stats.totalPaymentsMonth}</h2>
                            </div>
                            <span class="material-icons stat-icon">payment</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-lg-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">Recent Projects</h5>
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th>Title</th>
                                    <th>Subtitle</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${recentProjects}" var="project">
                                    <tr>
                                        <td>${project['title']}</td>
                                        <td>${project['subtitle']}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">Recent Invoices</h5>
                        </div>
                        <div class="card-body p-0">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th>Title</th>
                                    <th>Subtitle</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${recentInvoices}" var="invoice">
                                    <tr>
                                        <td>${invoice['title']}</td>
                                        <td>${invoice['subtitle']}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
