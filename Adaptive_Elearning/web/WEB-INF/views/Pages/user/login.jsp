<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="assets/css/login.css">
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
</head>
<body>
     <!-- Thanh navigation -->
    <div class="navbar">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Logo">
        </div>
        <div class="nav-button">
            <a href="${pageContext.request.contextPath}/register" class="btn-signin">Register</a>
        </div>
    </div>

    <div class="form-box">
        <div class="login-container" id="login">
            <header>Welcome</header>

            <!-- Hiển thị alert -->
            <c:if test="${not empty alertMessage}">
                <div class="alert ${alertStatus ? 'alert-success' : 'alert-danger'}">
                    ${alertMessage}
                </div>
            </c:if>

            <form action="login" method="post">
                <div class="input-box">
                    <input type="text" name="username" class="input-field" placeholder="Username or Email" value="${param.username}">
                    <i class="bx bx-user"></i>
                </div>

                <div class="input-box">
                    <input type="password" name="password" class="input-field" placeholder="Password">
                    <i class="bx bx-lock-alt"></i>
                </div>

                <div class="options">
                    <label>
                        <input type="checkbox" name="rememberMe"> Remember Me
                    </label>
                    <a href="forgot-password.jsp" class="forgot">Forgot password?</a>
                </div>

                <div class="input-box">
                    <input type="submit" class="submit" value="Sign In">
                </div>
            </form>

            <!-- Divider Or -->
            <div class="divider">
                <span>Or</span>
            </div>

            <!-- Nút Google -->
            <div class="google-login">
                <a href="google-login" class="google-btn">
                    <img src="${pageContext.request.contextPath}/assets/images/google-icon.png" alt="Google"> 
                    Sign in with Google
                </a>
            </div>

            <!-- Link dưới -->
            <div class="top">
                <span>Don't have an account? <a href="${pageContext.request.contextPath}/register">Sign Up</a></span>
            </div>
        </div>
    </div>
</body>
</html>
