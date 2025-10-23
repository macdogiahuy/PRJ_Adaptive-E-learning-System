<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
  <title>Forgot Password</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/login.css">
</head>
<body>
<div class="form-box">
  <div class="login-container">
    <header>Forgot Password</header>

    <c:if test="${not empty alertMessage}">
      <div class="alert ${alertStatus ? 'alert-success' : 'alert-danger'}">${alertMessage}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/forgot-password">
      <input type="hidden" name="csrf" value="${sessionScope.csrfToken}">
      <div class="input-box">
        <input type="email" name="email" class="input-field" placeholder="Your email" required>
      </div>
      <div class="input-box">
        <input type="submit" class="submit" value="Send OTP">
      </div>
    </form>

    <div class="top">
      <span>Back to <a href="${pageContext.request.contextPath}/login">Login</a></span>
    </div>
  </div>
</div>
</body>
</html>
