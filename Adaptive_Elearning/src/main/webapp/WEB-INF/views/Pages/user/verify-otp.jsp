<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP - CourseHub</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #667eea;
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary-color: #f093fb;
            --text-color: #333;
            --light-bg: #f8f9fa;
            --white: #ffffff;
            --shadow: 0 10px 30px rgba(0,0,0,0.1);
            --border-radius: 15px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--primary-gradient);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .auth-container {
            width: 100%;
            max-width: 400px;
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            transform: translateY(0);
            transition: all 0.3s ease;
        }

        .auth-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .auth-header {
            background: var(--primary-gradient);
            color: var(--white);
            padding: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .auth-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
            transform: rotate(45deg);
            animation: shimmer 3s infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
        }

        .auth-header h2 {
            margin: 0;
            font-size: 1.8rem;
            font-weight: 600;
            position: relative;
            z-index: 1;
        }

        .auth-header .subtitle {
            margin-top: 0.5rem;
            opacity: 0.9;
            font-size: 0.95rem;
            position: relative;
            z-index: 1;
        }

        .auth-body {
            padding: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 3rem;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: var(--light-bg);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            background: var(--white);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            font-size: 1.1rem;
            z-index: 1;
        }

        .btn-primary {
            width: 100%;
            padding: 0.75rem;
            background: var(--primary-gradient);
            border: none;
            border-radius: 10px;
            color: var(--white);
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .btn-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn-primary:hover::before {
            left: 100%;
        }

        .auth-footer {
            text-align: center;
            padding: 1rem 2rem 2rem;
            color: #6c757d;
        }

        .auth-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .auth-footer a:hover {
            color: var(--secondary-color);
            text-decoration: underline;
        }

        .alert {
            margin-bottom: 1.5rem;
            padding: 1rem;
            border-radius: 10px;
            border: none;
            font-weight: 500;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-danger {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .loading-state {
            opacity: 0.7;
            pointer-events: none;
        }

        .loading-state .btn-primary {
            background: #6c757d;
        }

        @media (max-width: 480px) {
            .auth-container {
                margin: 1rem;
                max-width: none;
            }
            
            .auth-header {
                padding: 1.5rem;
            }
            
            .auth-header h2 {
                font-size: 1.5rem;
            }
            
            .auth-body {
                padding: 1.5rem;
            }
        }

        .otp-input {
            text-align: center;
            font-size: 1.2rem;
            font-weight: 600;
            letter-spacing: 0.5rem;
            padding-left: 1rem !important;
        }

        .resend-section {
            text-align: center;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #e9ecef;
        }

        .countdown {
            color: var(--primary-color);
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-header">
            <h2><i class="fas fa-shield-alt me-2"></i>Verify OTP</h2>
            <div class="subtitle">Enter the 6-digit code sent to your email</div>
        </div>
        
        <div class="auth-body">
            <c:if test="${not empty alertMessage}">
                <div class="alert ${alertStatus ? 'alert-success' : 'alert-danger'}">
                    <i class="fas ${alertStatus ? 'fa-check-circle' : 'fa-exclamation-triangle'} me-2"></i>
                    ${alertMessage}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/verify-otp" id="verifyOtpForm">
                <input type="hidden" name="csrf" value="${sessionScope.csrfToken}">
                
                <div class="form-group">
                    <i class="fas fa-envelope input-icon"></i>
                    <input type="email" 
                           name="email" 
                           class="form-control" 
                           placeholder="Your email address"
                           value="${param.email}" 
                           required>
                </div>

                <div class="form-group">
                    <i class="fas fa-key input-icon"></i>
                    <input type="text" 
                           name="otp" 
                           class="form-control otp-input" 
                           placeholder="000000"
                           maxlength="6" 
                           pattern="[0-9]{6}"
                           autocomplete="one-time-code"
                           required>
                </div>

                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-check me-2"></i>Verify Code
                </button>
            </form>

            <div class="resend-section">
                <p class="mb-2">Didn't receive the code?</p>
                <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none">
                    <i class="fas fa-redo me-1"></i>Resend OTP
                </a>
            </div>
        </div>
        
        <div class="auth-footer">
            <a href="${pageContext.request.contextPath}/auth">
                <i class="fas fa-arrow-left me-1"></i>Back to Login
            </a>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('verifyOtpForm');
            const otpInput = document.querySelector('input[name="otp"]');
            
            // Auto-format OTP input
            otpInput.addEventListener('input', function(e) {
                this.value = this.value.replace(/\D/g, '');
                if (this.value.length === 6) {
                    this.style.borderColor = '#28a745';
                } else {
                    this.style.borderColor = '';
                }
            });

            // Auto-submit when 6 digits entered
            otpInput.addEventListener('input', function(e) {
                if (this.value.length === 6) {
                    setTimeout(() => {
                        form.submit();
                    }, 500);
                }
            });

            // Form submission loading state
            form.addEventListener('submit', function() {
                const container = document.querySelector('.auth-container');
                container.classList.add('loading-state');
                
                const submitBtn = form.querySelector('button[type="submit"]');
                const originalText = submitBtn.innerHTML;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Verifying...';
                
                setTimeout(() => {
                    if (container.classList.contains('loading-state')) {
                        container.classList.remove('loading-state');
                        submitBtn.innerHTML = originalText;
                    }
                }, 10000);
            });

            // Auto-dismiss alerts after 5 seconds
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-20px)';
                    setTimeout(() => {
                        alert.remove();
                    }, 300);
                }, 5000);
            });
        });
    </script>
</body>
</html>