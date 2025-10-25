<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Change Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <jsp:include page="/WEB-INF/views/Pages/user/header.jsp" />
    <div class="container my-5">
        <div class="row">
            <div class="col-lg-4">
                <div class="card p-3 rounded-4 shadow-sm">
                    <h5>Settings</h5>
                    <div class="list-group">
                        <a class="list-group-item list-group-item-action" href="${pageContext.request.contextPath}/profile">Profile Settings</a>
                        <a class="list-group-item list-group-item-action active" href="#">Change Password</a>
                    </div>
                </div>
            </div>
            <div class="col-lg-8">
                <div class="card p-4 rounded-4 shadow-sm">
                    <h3>Change Password</h3>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>
                    <form method="post" action="${pageContext.request.contextPath}/change-password">
                        <div class="mb-3">
                            <label class="form-label">Current Password</label>
                            <input type="password" name="currentPassword" class="form-control" required />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">New Password</label>
                            <input type="password" name="newPassword" class="form-control" required />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Confirm New Password</label>
                            <input type="password" name="confirmPassword" class="form-control" required />
                        </div>
                        <button type="submit" class="btn btn-primary">Change Password</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>