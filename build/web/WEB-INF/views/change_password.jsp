<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Change Password</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .settings-container { max-width:600px; margin:28px auto; padding:18px; }
        .field-row { margin-bottom:12px; }
        .field-label { font-weight:600; }
        .error { color:#b91c1c; margin-bottom:8px; }
        .success { color:#059669; margin-bottom:8px; }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />
<div class="settings-container glass p-4">
    <h4>Change Password</h4>

    <c:if test="${not empty error}"><div class="error">${error}</div></c:if>
    <c:if test="${not empty sessionScope.success}"><div class="success">${sessionScope.success}</div></c:if>

    <form method="post" action="${pageContext.request.contextPath}/settings/password">
        <input type="hidden" name="id" value="${param.id}" />
        <div class="field-row">
            <div class="field-label">Current Password</div>
            <input type="password" name="currentPassword" class="form-control" required />
        </div>
        <div class="field-row">
            <div class="field-label">New Password</div>
            <input type="password" name="newPassword" class="form-control" required />
        </div>
        <div class="field-row">
            <div class="field-label">Confirm New Password</div>
            <input type="password" name="confirmPassword" class="form-control" required />
        </div>
        <div class="mt-2">
            <button type="submit" class="save-btn">Change Password</button>
        </div>
    </form>
</div>
</body>
</html>