<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
  <title>Reset Password</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/login.css">
</head>
<body>
<div class="form-box">
  <div class="login-container">
    <header>Reset Password</header>

    <c:if test="${not empty alertMessage}">
      <div class="alert ${alertStatus ? 'alert-success' : 'alert-danger'}">${alertMessage}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/reset-password">
      <input type="hidden" name="csrf" value="${sessionScope.csrfToken}">
      <div class="input-box">
        <input type="password" name="password" class="input-field" placeholder="New password" required>
      </div>
      <div class="input-box">
        <input type="password" name="confirm" class="input-field" placeholder="Confirm password" required>
      </div>
      <div class="input-box">
        <input type="submit" class="submit" value="Update Password">
      </div>
    </form>

    <div class="top">
      <span>Back to <a href="${pageContext.request.contextPath}/login">Login</a></span>
    </div>
  </div>
</div>
</body>
</html>
