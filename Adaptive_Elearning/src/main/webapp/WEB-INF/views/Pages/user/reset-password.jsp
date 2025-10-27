<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - FlyUp</title>
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
            
            <h1 class="forgot-header">Reset Your Password</h1>
            <p class="forgot-subtitle">
                Create a new secure password for your account. Make sure it's strong and unique!
            </p>

            <c:if test="${not empty alertMessage}">
                <div class="alert ${alertStatus ? 'alert-success' : 'alert-danger'}">
                    <i class='bx ${alertStatus ? "bx-check-circle" : "bx-error-circle"}'></i>
                    ${alertMessage}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/reset-password" id="resetForm">
                <input type="hidden" name="csrf" value="${sessionScope.csrfToken}">
                
                <div class="input-box">
                    <input type="password" name="password" id="password" placeholder="New Password" 
                           required autocomplete="new-password">
                    <i class='bx bx-lock-alt'></i>
                    <i class='bx bx-show' id="togglePassword1" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer; color: rgba(255,255,255,0.7);"></i>
                </div>
                
                <div class="password-requirements" style="margin: 10px 0; padding: 10px; background: rgba(255,255,255,0.1); border-radius: 10px; font-size: 13px;text-align: left;">
                    <div id="req-length" style="color: #ada8df; margin: 5px 0;">
                        <i class='bx bx-x' style="font-size: 14px;"></i> At least 6 characters
                    </div>
                    <div id="req-letter" style="color: #ada8df; margin: 5px 0;">
                        <i class='bx bx-x' style="font-size: 14px;"></i> Contains letters
                    </div>
                    <div id="req-number" style="color: #ada8df; margin: 5px 0;">
                        <i class='bx bx-x' style="font-size: 14px;"></i> Contains numbers
                    </div>
                </div>
                
                <div class="input-box">
                    <input type="password" name="confirm" id="confirm" placeholder="Confirm New Password" 
                           required autocomplete="new-password">
                    <i class='bx bx-lock-alt'></i>
                    <i class='bx bx-show' id="togglePassword2" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer; color: rgba(255,255,255,0.7);"></i>
                </div>
                
                <div id="matchStatus" style="text-align: center; margin: 10px 0; font-size: 13px; font-weight: 500;"></div>
                
                <button type="submit" class="btn" id="submitBtn" disabled style="opacity: 0.6;">
                    <i class='bx bx-save' style="margin-right: 8px;"></i>
                    Update Password
                </button>
            </form>

            <div class="footer-links">
                <p>Remember your password? 
                    <a href="${pageContext.request.contextPath}/auth">Back to Login</a>
                </p>
            </div>
        </div>
    </div>
    
    <script>
        // Toggle password visibility
        document.getElementById('togglePassword1').addEventListener('click', function() {
            const passwordInput = document.getElementById('password');
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            this.classList.toggle('bx-show');
            this.classList.toggle('bx-hide');
        });
        
        document.getElementById('togglePassword2').addEventListener('click', function() {
            const confirmInput = document.getElementById('confirm');
            const type = confirmInput.getAttribute('type') === 'password' ? 'text' : 'password';
            confirmInput.setAttribute('type', type);
            this.classList.toggle('bx-show');
            this.classList.toggle('bx-hide');
        });
        
        function checkPasswordStrength(password) {
            const requirements = {
                length: password.length >= 6,
                letter: /[a-zA-Z]/.test(password),
                number: /\d/.test(password)
            };
            
            // Update UI
            Object.keys(requirements).forEach(req => {
                const element = document.getElementById('req-' + req);
                const icon = element.querySelector('i');
                
                if (requirements[req]) {
                    element.style.color = '#2ed573';
                    icon.classList.remove('bx-x');
                    icon.classList.add('bx-check');
                } else {
                    element.style.color = 'rgba(255,255,255,0.6)';
                    icon.classList.remove('bx-check');
                    icon.classList.add('bx-x');
                }
            });
            
            return Object.values(requirements).every(Boolean);
        }
        
        function checkPasswordMatch() {
            const password = document.getElementById('password').value;
            const confirm = document.getElementById('confirm').value;
            const status = document.getElementById('matchStatus');
            
            if (confirm === '') {
                status.textContent = '';
                return false;
            }
            
            if (password === confirm) {
                status.innerHTML = '<i class="bx bx-check"></i> Passwords match';
                status.style.color = '#2ed573';
                return true;
            } else {
                status.innerHTML = '<i class="bx bx-x"></i> Passwords do not match';
                status.style.color = '#ff4757';
                return false;
            }
        }
        
        function updateSubmitButton() {
            const password = document.getElementById('password').value;
            const isStrong = checkPasswordStrength(password);
            const isMatch = checkPasswordMatch();
            const submitBtn = document.getElementById('submitBtn');
            
            if (isStrong && isMatch && password.length > 0) {
                submitBtn.disabled = false;
                submitBtn.style.opacity = '1';
            } else {
                submitBtn.disabled = true;
                submitBtn.style.opacity = '0.6';
            }
        }
        
        document.getElementById('password').addEventListener('input', updateSubmitButton);
        document.getElementById('confirm').addEventListener('input', updateSubmitButton);
        
        document.getElementById('resetForm').addEventListener('submit', function() {
            const btn = document.getElementById('submitBtn');
            btn.innerHTML = '<i class="bx bx-loader-alt bx-spin" style="margin-right: 8px;"></i>Updating...';
            btn.disabled = true;
        });
    </script>

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