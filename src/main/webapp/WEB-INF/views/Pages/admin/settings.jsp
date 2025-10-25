<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Admin Settings</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" />
    <style>
        .settings-card { max-width: 900px; margin: 20px auto; }
        .help-text { font-size: 0.9rem; color: #666; }
    </style>
</head>
<body>
    <div class="container settings-card">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">Site Settings</h5>
            </div>
            <div class="card-body">
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">${errorMessage}</div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${successMessage}</div>
                </c:if>

                <form method="post" class="row g-3">
                    <div class="col-12">
                        <label class="form-label">Site title</label>
                        <input name="siteTitle" class="form-control" value="${settings.siteTitle}" />
                        <div class="help-text">Appears in the browser title and top bar.</div>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Site description</label>
                        <textarea name="siteDescription" class="form-control" rows="2">${settings.siteDescription}</textarea>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Items per page</label>
                        <input name="itemsPerPage" class="form-control" value="${settings.itemsPerPage}" />
                        <div class="help-text">Number of items shown per page in lists (e.g., courses).</div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Allow registration</label>
                        <select name="allowRegistration" class="form-select">
                            <option value="true" <c:if test="${settings.allowRegistration == 'true'}">selected</c:if>>Enabled</option>
                            <option value="false" <c:if test="${settings.allowRegistration == 'false'}">selected</c:if>>Disabled</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Maintenance mode</label>
                        <select name="maintenanceMode" class="form-select">
                            <option value="false" <c:if test="${settings.maintenanceMode == 'false'}">selected</c:if>>Off</option>
                            <option value="true" <c:if test="${settings.maintenanceMode == 'true'}">selected</c:if>>On</option>
                        </select>
                        <div class="help-text">When on, show a maintenance banner; useful for deploys.</div>
                    </div>

                    <div class="col-12 text-end">
                        <button class="btn btn-primary" type="submit">Save settings</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
