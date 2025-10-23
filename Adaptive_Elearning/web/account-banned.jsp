<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Banned - CourseHub E-Learning</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        /* Animated background */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 50%, rgba(255, 0, 150, 0.2) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(255, 100, 0, 0.2) 0%, transparent 50%),
                radial-gradient(circle at 40% 20%, rgba(100, 0, 255, 0.2) 0%, transparent 50%);
            pointer-events: none;
            animation: backgroundShift 20s ease-in-out infinite;
        }

        @keyframes backgroundShift {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.8; transform: scale(1.1); }
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 30px;
            padding: 3rem;
            max-width: 600px;
            width: 90%;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            text-align: center;
            position: relative;
            z-index: 1;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .icon-container {
            width: 120px;
            height: 120px;
            margin: 0 auto 2rem;
            background: linear-gradient(135deg, #EF4444 0%, #DC2626 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 10px 30px rgba(239, 68, 68, 0.4);
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
                box-shadow: 0 10px 30px rgba(239, 68, 68, 0.4);
            }
            50% {
                transform: scale(1.05);
                box-shadow: 0 15px 40px rgba(239, 68, 68, 0.6);
            }
        }

        .icon-container i {
            font-size: 4rem;
            color: white;
        }

        h1 {
            font-size: 2.5rem;
            color: #1F2937;
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .subtitle {
            font-size: 1.2rem;
            color: #6B7280;
            margin-bottom: 2rem;
        }

        .message-box {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.1) 0%, rgba(220, 38, 38, 0.05) 100%);
            border: 2px solid rgba(239, 68, 68, 0.3);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            text-align: left;
        }

        .message-box h3 {
            color: #DC2626;
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .message-box p {
            color: #4B5563;
            line-height: 1.6;
            margin-bottom: 0.5rem;
        }

        .email-info {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1rem;
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .email-info strong {
            color: #DC2626;
            display: block;
            margin-bottom: 0.5rem;
        }

        .email-info code {
            background: rgba(239, 68, 68, 0.1);
            padding: 0.3rem 0.6rem;
            border-radius: 5px;
            color: #DC2626;
            font-family: 'Courier New', monospace;
        }

        .contact-section {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(139, 92, 246, 0.05) 100%);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .contact-section h3 {
            color: #6366F1;
            font-size: 1.1rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            justify-content: center;
        }

        .contact-methods {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #4B5563;
            font-size: 0.9rem;
        }

        .contact-item i {
            color: #6366F1;
        }

        .buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 1rem 2rem;
            border-radius: 12px;
            border: none;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #6366F1 0%, #8B5CF6 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.5);
        }

        .btn-secondary {
            background: white;
            color: #6366F1;
            border: 2px solid #6366F1;
        }

        .btn-secondary:hover {
            background: #6366F1;
            color: white;
            transform: translateY(-2px);
        }

        .timestamp {
            margin-top: 2rem;
            color: #9CA3AF;
            font-size: 0.85rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 2rem 1.5rem;
            }

            h1 {
                font-size: 2rem;
            }

            .icon-container {
                width: 100px;
                height: 100px;
            }

            .icon-container i {
                font-size: 3rem;
            }

            .buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon-container">
            <i class="fas fa-ban"></i>
        </div>

        <h1>Account Banned</h1>
        <p class="subtitle">Your account has been suspended</p>

        <div class="message-box">
            <h3>
                <i class="fas fa-exclamation-triangle"></i>
                Access Denied
            </h3>
            <p>Your account has been banned by the administrator and you cannot access the system at this time.</p>
            
            <% 
                String email = request.getParameter("email");
                if (email != null && !email.trim().isEmpty()) { 
            %>
            <div class="email-info">
                <strong>Banned Account:</strong>
                <code><%= email %></code>
            </div>
            <% } %>
        </div>

        <div class="contact-section">
            <h3>
                <i class="fas fa-headset"></i>
                Need Help?
            </h3>
            <p style="margin-bottom: 1rem; color: #6B7280;">If you believe this is a mistake, please contact our support team:</p>
            
            <div class="contact-methods">
                <div class="contact-item">
                    <i class="fas fa-envelope"></i>
                    <span>support@coursehub.com</span>
                </div>
                <div class="contact-item">
                    <i class="fas fa-phone"></i>
                    <span>+84 123 456 789</span>
                </div>
            </div>
        </div>

        <div class="buttons">
            <a href="<%= request.getContextPath() %>/login" class="btn btn-primary">
                <i class="fas fa-sign-in-alt"></i>
                Back to Login
            </a>
            <a href="<%= request.getContextPath() %>/home" class="btn btn-secondary">
                <i class="fas fa-home"></i>
                Go to Homepage
            </a>
        </div>

        <div class="timestamp">
            <i class="fas fa-clock"></i>
            <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date()) %>
        </div>
    </div>

    <script>
        // Add floating animation to icon
        const icon = document.querySelector('.icon-container');
        let rotation = 0;
        
        setInterval(() => {
            rotation += 0.5;
            if (rotation > 10) rotation = -10;
            icon.style.transform = `rotate(${rotation}deg)`;
        }, 50);

        // Auto-focus on buttons for accessibility
        document.querySelector('.btn-primary').focus();
    </script>
</body>
</html>
