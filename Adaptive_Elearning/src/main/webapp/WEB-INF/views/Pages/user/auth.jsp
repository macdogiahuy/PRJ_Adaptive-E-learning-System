<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Login & Register</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/auth.css">
        <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    </head>

    <body>
        <div class="container">
            <!-- Login Form -->
            <div class="form-box login">
                <form action="login" method="post">
                    <h1>Login</h1>

                    <c:if test="${not empty alertMessage}">
                        <c:choose>
                            <c:when test="${isBanned}">
                                <div class="alert alert-danger" style="background: linear-gradient(135deg, rgba(239, 68, 68, 0.9), rgba(220, 38, 38, 0.9)); border: 2px solid #DC2626; animation: shake 0.5s;">
                                    <i class="fas fa-ban" style="margin-right: 8px; font-size: 20px;"></i>
                                    <strong style="font-size: 18px;">Account Banned!</strong><br>
                                    <c:if test="${not empty bannedEmail}">
                                        <div style="margin: 5px 0; padding: 0px; background: rgba(0,0,0,0.2); border-radius: 5px;">
                                            <i class="fas fa-envelope" style="margin-right: 5px;"></i>
                                            Account: <strong>${bannedEmail}</strong>
                                        </div>
                                    </c:if>
                                    ${alertMessage}
                                    <br><br>
                                    
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert ${alertStatus ? 'alert-success' : 'alert-danger'}">
                                    ${alertMessage}
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <div class="input-box">
                        <input type="text" name="username" placeholder="Username or Email" value="${param.username != null ? param.username : ''}" required>
                        <i class='bx bxs-user'></i>
                    </div>

                    <div class="input-box">
                        <input type="password" name="password" placeholder="Password" required>
                        <i class='bx bxs-lock-alt'></i>
                    </div>

                    <div class="options">
                        <label>
                            <input type="checkbox" name="remember" value="yes"> Remember Me
                        </label>
                        <a href="${pageContext.request.contextPath}/forgot-password" class="forgot">Forgot Password?</a>
                    </div>

                    <button type="submit" class="btn">Login</button>
                    <p>or login with social platforms</p>

                    <div class="social-icons">
                        <a href="${pageContext.request.contextPath}/google-login"><i class='bx bxl-google'></i></a>
                    </div>
                </form>
            </div>

            <!-- Register Form -->
            <div class="form-box register">
                <form action="register" method="post">
                    <h1>Register</h1>

                    <c:if test="${not empty alertMessage}">
                        <div class="alert ${alertStatus ? 'alert-success' : 'alert-danger'}">
                            ${alertMessage}
                        </div>
                    </c:if>

                    <div class="input-box">
                        <input type="text" name="username" placeholder="Username" value="${param.username}" required>
                        <i class='bx bxs-user'></i>
                    </div>

                    <div class="input-box">
                        <input type="email" name="email" placeholder="Email" value="${param.email}" required>
                        <i class='bx bxs-envelope'></i>
                    </div>

                    <div class="input-box">
                        <input type="password" name="password" placeholder="Password" required>
                        <i class='bx bxs-lock-alt'></i>
                    </div>

                    <div class="input-box">
                        <input type="password" name="repassword" placeholder="Retype Password" required>
                        <i class='bx bxs-lock-alt'></i>
                    </div>

                    <button type="submit" class="btn">Register</button>
                    <p>or register with social platforms</p>
                    <div class="social-icons">
                        <a href="${pageContext.request.contextPath}/google-login"><i class='bx bxl-google'></i></a>
                    </div>
                </form>
            </div>

            <!-- Toggle Box -->
            <div class="toggle-box">
                <div class="toggle-panel toggle-left">
                    <h1>Hello, Welcome!</h1>
                    <p>Don't have an account?</p>
                    <button class="btn register-btn">Register</button>
                </div>

                <div class="toggle-panel toggle-right">
                    <h1>Welcome Back!</h1>
                    <p>Already have an account?</p>
                    <button class="btn login-btn">Login</button>
                </div>
            </div>
        </div>

        <script>
            const container = document.querySelector('.container');
            const registerBtn = document.querySelector('.register-btn');
            const loginBtn = document.querySelector('.login-btn');

            registerBtn.addEventListener('click', () => container.classList.add('active'));
            loginBtn.addEventListener('click', () => container.classList.remove('active'));
        </script>
    </body>
    <script>
        window.addEventListener("DOMContentLoaded", () => {
            const container = document.querySelector('.container');
            const showForm = '<c:out value="${showForm}" />';
            if (showForm === 'register') {
                container.classList.add('active');
            } else {
                container.classList.remove('active');
            }
        });
    </script>
</html>
