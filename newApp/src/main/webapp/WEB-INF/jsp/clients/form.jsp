<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DaybydayCRM - Client</title>
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
        .material-icons {
            margin-right: 10px;
            font-size: 20px;
        }
    </style>
</head>
<body>
<div id="wrapper">
    <jsp:include page="../components/sidebar.jsp" />

    <div id="page-content-wrapper">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <c:choose>
                <c:when test="${isEdit}"><h2>Éditer un client</h2></c:when>
                <c:otherwise><h2>Créer un nouveau client</h2></c:otherwise>
            </c:choose>

            <a href="/clients" class="btn btn-secondary">
                <span class="material-icons">arrow_back</span>
                Retour
            </a>
        </div>

        <div class="card">
            <div class="card-body">
                <form action="/clients" method="POST">
                    <c:if test="${isEdit}">
                        <input type="hidden" name="external_id" value="${client['external_id']}" />
                    </c:if>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Nom de contact</label>
                            <input type="text" class="form-control" name="name" value="${client['name']}" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" name="email" value="${client['email']}" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Entreprise</label>
                            <input type="text" class="form-control" name="company" value="${client['company_name']}" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Téléphone</label>
                            <input type="tel" class="form-control" name="phone" value="${client['phone']}">
                        </div>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">
                            <span class="material-icons">save</span>
                            <c:choose>
                                <c:when test="${isEdit}">Modifier</c:when>
                                <c:otherwise>Créer</c:otherwise>
                            </c:choose>
                        </button>
                        <a href="/clients" class="btn btn-secondary">Annuler</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
