<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DaybydayCRM - Clients</title>
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
        .table tbody tr:hover {
            background-color: #f5f5f5;
        }
        .btn-group-sm .btn {
            padding: 5px 10px;
            font-size: 12px;
        }
    </style>
</head>
<body>
<div id="wrapper">
    <jsp:include page="../components/sidebar.jsp" />

    <div id="page-content-wrapper">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Gestion des Clients</h2>
            <a href="/clients/create" class="btn btn-primary">
                <span class="material-icons">add</span>
                Nouveau Client
            </a>
        </div>

        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card bg-light">
                    <div class="card-body">
                        <h6 class="card-subtitle text-muted">Total Clients</h6>
                        <h3>${totalClients}</h3>
                    </div>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Liste des Clients</h5>
            </div>
            <div class="card-body">
                <c:if test="${empty clients}">
                    <div class="alert alert-info">
                        <span class="material-icons">info</span>
                        Aucun client trouvé
                    </div>
                </c:if>

                <c:if test="${not empty clients}">
                    <table class="table table-hover table-sm">
                        <thead class="table-light">
                        <tr>
                            <th>id</th>
                            <th>external_id</th>
                            <th>address</th>
                            <th>zipcode</th>
                            <th>city</th>
                            <th>company_name</th>
                            <th>vat</th>
                            <th>company_type</th>
                            <th>client_number</th>
                            <th>user_id</th>
                            <th>industry_id</th>
                            <th>deleted_at</th>
                            <th>created_at</th>
                            <th>updated_at</th>
                            <th style="width: 200px;">Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${clients}" var="client">
                            <tr>
                                <td><small>${client['id']}</small></td>
                                <td><small>${client['external_id']}</small></td>
                                <td><small>${client['address']}</small></td>
                                <td><small>${client['zipcode']}</small></td>
                                <td><small>${client['city']}</small></td>
                                <td><strong>${client['company_name']}</strong></td>
                                <td><small>${client['vat']}</small></td>
                                <td><small>${client['company_type']}</small></td>
                                <td><small>${client['client_number']}</small></td>
                                <td><small>${client['user_id']}</small></td>
                                <td><small>${client['industry_id']}</small></td>
                                <td><small>${client['deleted_at']}</small></td>
                                <td><small>${client['created_at']}</small></td>
                                <td><small>${client['updated_at']}</small></td>
                                <td>
                                    <div class="btn-group btn-group-sm" role="group">
                                        <a class="btn btn-info" href="/clients/${client['external_id']}">
                                            <span class="material-icons">visibility</span>
                                            Voir
                                        </a>
                                        <a class="btn btn-warning" href="/clients/${client['external_id']}/edit">
                                            <span class="material-icons">edit</span>
                                            Éditer
                                        </a>
                                        <form method="post" action="/clients/${client['external_id']}" style="display:inline;">
                                            <input type="hidden" name="_method" value="DELETE"/>
                                            <button type="submit" class="btn btn-danger">
                                                <span class="material-icons">delete</span>
                                                Supprimer
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
