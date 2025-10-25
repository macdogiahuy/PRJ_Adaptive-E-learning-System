<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Register</title>
     <link rel="stylesheet" href="assests/css/register.css">
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
</head>
<body>
     <!-- Thanh navigation -->
    <div class="navbar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Logo">
        </div>
        <div class="nav-button">
            <a href="${pageContext.request.contextPath}/login" class="btn-signin">Login</a>
        </div>
    </div>
    <div class="form-box">
        <div class="register-container" id="register">
            <header>Register</header>

            <!-- Hiển thị alert -->
            <c:if test="${not empty alertMessage}">
                <div class="alert ${alertStatus ? 'alert-success' : 'alert-danger'}">
                    ${alertMessage}
                </div>
            </c:if>

            <form action="register" method="post">
                <div class="input-box">
                    <input type="text" name="username" class="input-field" placeholder="Username" value="${param.username}">
                    <i class="bx bx-user"></i>
                </div>

                <div class="input-box">
                    <input type="email" name="email" class="input-field" placeholder="Email" value="${param.email}">
                    <i class="bx bx-envelope"></i>
                </div>

                <div class="input-box">
                    <input type="password" name="password" class="input-field" placeholder="Password">
                    <i class="bx bx-lock-alt"></i>
                </div>

                <div class="input-box">
                    <input type="password" name="repassword" class="input-field" placeholder="Retype Password">
                    <i class="bx bx-lock-alt"></i>
                </div>

                <div class="input-box">
                    <input type="submit" class="submit" value="Register">
                </div>

                <div class="top">
                    <span>Have an account? <a href="${pageContext.request.contextPath}/login">Login</a></span>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
