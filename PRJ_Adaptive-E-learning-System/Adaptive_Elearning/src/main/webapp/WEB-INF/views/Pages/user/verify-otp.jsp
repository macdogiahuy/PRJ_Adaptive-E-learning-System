<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
  <title>Verify OTP</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/login.css">
</head>
<body>
<div class="form-box">
  <div class="login-container">
    <header>Verify OTP</header>

    <c:if test="${not empty alertMessage}">
      <div class="alert ${alertStatus ? 'alert-success' : 'alert-danger'}">${alertMessage}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/verify-otp">
      <input type="hidden" name="csrf" value="${sessionScope.csrfToken}">
      <div class="input-box">
        <input type="email" name="email" class="input-field" placeholder="Your email" value="${param.email}" required>
      </div>
      <div class="input-box">
        <input type="number" name="otp" maxlength="6" pattern="\\d{6}" class="input-field" placeholder="6-digit code" required>
      </div>
      <div class="input-box">
        <input type="submit" class="submit" value="Verify">
      </div>
    </form>

    <div class="top">
      <span>Didn’t get code? <a href="${pageContext.request.contextPath}/forgot-password">Resend</a></span>
    </div>
  </div>
</div>
</body>
</html>
