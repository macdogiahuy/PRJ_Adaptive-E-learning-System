<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - EduHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assests/css/auth.css">
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
    <style>
        /* Additional styles for forgot password page */
        .forgot-container {
            width: 500px;
            height: auto;
            min-height: 400px;
            background: rgba(255,255,255,0.12);
            border-radius: 30px;
            box-shadow: 0 0 30px rgba(0, 0, 0, .5);
            backdrop-filter: blur(20px);
            overflow: hidden;
            position: relative;
        }
        
        .forgot-form-box {
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.9);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: #333;
            text-align: center;
            padding: 40px;
            position: relative;
        }
        
        .forgot-header {
            font-size: 2.5rem;
            font-weight: 600;
            margin-bottom: 20px;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .forgot-subtitle {
            font-size: 1rem;
            color: #666;
            margin-bottom: 30px;
            line-height: 1.5;
        }
        
        .back-button {
            position: absolute;
            top: 20px;
            left: 20px;
            background: none;
            border: none;
            font-size: 1.5rem;
            color: #667eea;
            cursor: pointer;
            transition: all 0.3s ease;
            padding: 10px;
            border-radius: 50%;
        }
        
        .back-button:hover {
            background: rgba(102, 126, 234, 0.1);
            transform: translateX(-3px);
        }
        
        .input-box {
            position: relative;
            width: 100%;
            margin: 20px 0;
        }
        
        .input-box input {
            width: 100%;
            padding: 15px 45px 15px 20px;
            background: rgba(255,255,255,0.8);
            border: 2px solid rgba(102, 126, 234, 0.3);
            border-radius: 15px;
            font-size: 1rem;
            color: #333;
            outline: none;
            transition: all 0.3s ease;
        }
        
        .input-box input:focus {
            border-color: #667eea;
            background: rgba(255,255,255,1);
            box-shadow: 0 0 10px rgba(102, 126, 234, 0.3);
        }
        
        .input-box i {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.2rem;
            color: #667eea;
        }
        
        .btn {
            width: 100%;
            height: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 15px;
            color: white;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin: 20px 0;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }
        
        .alert {
            padding: 15px;
            margin: 20px 0;
            border-radius: 10px;
            font-weight: 500;
            display: flex;
            align-items: center;
            animation: slideInDown 0.5s ease-out;
        }
        
        .alert-success {
            background: linear-gradient(135deg, rgba(34, 197, 94, 0.1), rgba(21, 128, 61, 0.1));
            border: 1px solid #22c55e;
            color: #15803d;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(220, 38, 38, 0.1));
            border: 1px solid #ef4444;
            color: #dc2626;
        }
        
        .alert i {
            margin-right: 10px;
            font-size: 1.2rem;
        }
        
        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .footer-links {
            margin-top: 30px;
            font-size: 0.9rem;
            color: #666;
        }
        
        .footer-links a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .footer-links a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .forgot-container {
                width: 90%;
                margin: 20px;
            }
            
            .forgot-form-box {
                padding: 30px 20px;
            }
            
            .forgot-header {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <div class="forgot-container">
        <div class="forgot-form-box">
            <a href="${pageContext.request.contextPath}/login" class="back-button" title="Back to Login">
                <i class='bx bx-arrow-back'></i>
            </a>
            
            <h1 class="forgot-header">Forgot Password?</h1>
            <p class="forgot-subtitle">
                Don't worry! Enter your email address and we'll send you a verification code to reset your password.
            </p>

            <c:if test="${not empty alertMessage}">
                <div class="alert ${alertStatus ? 'alert-success' : 'alert-danger'}">
                    <i class='bx ${alertStatus ? "bx-check-circle" : "bx-error-circle"}'></i>
                    ${alertMessage}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/forgot-password">
                <input type="hidden" name="csrf" value="${sessionScope.csrfToken}">
                
                <div class="input-box">
                    <input type="email" name="email" placeholder="Enter your email address" 
                           value="${param.email}" required autocomplete="email">
                    <i class='bx bx-envelope'></i>
                </div>
                
                <button type="submit" class="btn">
                    <i class='bx bx-send' style="margin-right: 8px;"></i>
                    Send Reset Code
                </button>
            </form>

            <div class="footer-links">
                <p>Remember your password? 
                    <a href="${pageContext.request.contextPath}/login">Back to Login</a>
                </p>
                <p>Don't have an account? 
                    <a href="${pageContext.request.contextPath}/register">Sign Up</a>
                </p>
            </div>
        </div>
    </div>

    <script>
        // Auto-focus email input
        document.addEventListener('DOMContentLoaded', function() {
            const emailInput = document.querySelector('input[name="email"]');
            if (emailInput && !emailInput.value) {
                emailInput.focus();
            }
        });
        
        // Add loading state to button
        document.querySelector('form').addEventListener('submit', function() {
            const button = this.querySelector('.btn');
            const originalText = button.innerHTML;
            button.innerHTML = '<i class="bx bx-loader-alt bx-spin" style="margin-right: 8px;"></i>Sending...';
            button.disabled = true;
            
            // Re-enable button after 3 seconds (fallback)
            setTimeout(() => {
                button.innerHTML = originalText;
                button.disabled = false;
            }, 3000);
        });
    </script>
</body>
</html>