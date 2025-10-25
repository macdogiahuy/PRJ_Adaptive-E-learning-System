<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%
    Users user = (Users) session.getAttribute("account");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    // Lấy thông tin checkout từ session
    Boolean checkoutSuccess = (Boolean) session.getAttribute("checkoutSuccess");
    String billId = (String) session.getAttribute("checkoutBillId");
    Double totalAmount = (Double) session.getAttribute("checkoutAmount");
    String paymentMethod = (String) session.getAttribute("checkoutMethod");
    String message = (String) session.getAttribute("checkoutMessage");
    
    if (checkoutSuccess == null || !checkoutSuccess) {
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
        return;
    }
    
    // Xóa thông tin checkout khỏi session để tránh reload lại trang
    session.removeAttribute("checkoutSuccess");
    session.removeAttribute("checkoutBillId");
    session.removeAttribute("checkoutAmount");
    session.removeAttribute("checkoutMethod");
    session.removeAttribute("checkoutMessage");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán Thành Công - CourseHub</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <style>
        .success-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }
        
        .success-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            padding: 3rem;
            text-align: center;
            max-width: 600px;
            width: 100%;
            margin: 1rem;
            animation: slideInUp 0.8s ease-out;
        }
        
        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .success-icon {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, #00c851 0%, #007e33 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
            position: relative;
            animation: bounceIn 1s ease-out 0.3s both;
        }
        
        .success-icon i {
            font-size: 3rem;
            color: white;
        }
        
        @keyframes bounceIn {
            0% {
                opacity: 0;
                transform: scale(0.3);
            }
            50% {
                opacity: 1;
                transform: scale(1.1);
            }
            100% {
                opacity: 1;
                transform: scale(1);
            }
        }
        
        .success-title {
            color: #2c3e50;
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 1rem;
            animation: fadeInDown 0.8s ease-out 0.5s both;
        }
        
        .success-message {
            color: #7f8c8d;
            font-size: 1.1rem;
            margin-bottom: 2rem;
            line-height: 1.6;
            animation: fadeInUp 0.8s ease-out 0.7s both;
        }
        
        .order-details {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 2rem;
            margin: 2rem 0;
            animation: fadeIn 1s ease-out 0.9s both;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #dee2e6;
        }
        
        .detail-row:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
            font-weight: bold;
            font-size: 1.1rem;
            color: #2c3e50;
        }
        
        .detail-label {
            color: #6c757d;
            font-weight: 500;
        }
        
        .detail-value {
            color: #2c3e50;
            font-weight: 600;
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50px;
            padding: 15px 40px;
            font-size: 1.1rem;
            font-weight: 600;
            color: white;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            animation: pulse 2s ease-in-out infinite;
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
            color: white;
            text-decoration: none;
        }
        
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(102, 126, 234, 0.7);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(102, 126, 234, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(102, 126, 234, 0);
            }
        }
        
        .btn-secondary-custom {
            background: transparent;
            border: 2px solid #6c757d;
            border-radius: 50px;
            padding: 12px 30px;
            color: #6c757d;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-right: 1rem;
        }
        
        .btn-secondary-custom:hover {
            background: #6c757d;
            color: white;
            text-decoration: none;
        }
        
        .payment-method-badge {
            display: inline-flex;
            align-items: center;
            background: #e3f2fd;
            color: #1976d2;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
        }
        
        .payment-method-badge.cod {
            background: #fff3e0;
            color: #f57c00;
        }
        
        .payment-method-badge.online {
            background: #e8f5e8;
            color: #388e3c;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Confetti Animation */
        .confetti {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            overflow: hidden;
        }
        
        .confetti-piece {
            position: absolute;
            width: 10px;
            height: 10px;
            background: #667eea;
            animation: confetti-fall 3s linear infinite;
        }
        
        @keyframes confetti-fall {
            0% {
                transform: translateY(-100vh) rotate(0deg);
                opacity: 1;
            }
            100% {
                transform: translateY(100vh) rotate(720deg);
                opacity: 0;
            }
        }
    </style>
</head>
<body>
    <!-- Confetti Effect -->
    <div class="confetti" id="confetti"></div>
    
    <div class="success-container">
        <div class="success-card">
            <!-- Success Icon -->
            <div class="success-icon">
                <i class="fas fa-check"></i>
            </div>
            
            <!-- Success Title -->
            <h1 class="success-title">
                Thanh Toán Thành Công!
            </h1>
            
            <!-- Success Message -->
            <p class="success-message">
                Cảm ơn bạn đã tin tướng CourseHub! Đơn hàng của bạn đã được xử lý thành công. 
                Bạn có thể bắt đầu học ngay bây giờ trong trang "Khóa học của tôi".
            </p>
            
            <!-- Order Details -->
            <div class="order-details">
                <h5 class="mb-3">
                    <i class="fas fa-receipt me-2"></i>Chi Tiết Đơn Hàng
                </h5>
                
                <div class="detail-row">
                    <span class="detail-label">
                        <i class="fas fa-hashtag me-2"></i>Mã đơn hàng:
                    </span>
                    <span class="detail-value">
                        <%= billId != null ? billId : "N/A" %>
                    </span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">
                        <i class="fas fa-user me-2"></i>Khách hàng:
                    </span>
                    <span class="detail-value">
                        <%= user.getUserName() %>
                    </span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">
                        <i class="fas fa-credit-card me-2"></i>Phương thức:
                    </span>
                    <span class="detail-value">
                        <span class="payment-method-badge <%= "COD".equals(paymentMethod) ? "cod" : "online" %>">
                            <% if ("COD".equals(paymentMethod)) { %>
                                <i class="fas fa-truck me-1"></i>Thanh toán khi nhận hàng
                            <% } else { %>
                                <i class="fas fa-qrcode me-1"></i>Thanh toán online
                            <% } %>
                        </span>
                    </span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">
                        <i class="fas fa-calendar me-2"></i>Thời gian:
                    </span>
                    <span class="detail-value">
                        <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %>
                    </span>
                </div>
                
                <div class="detail-row">
                    <span class="detail-label">
                        <i class="fas fa-tag me-2"></i>Tổng tiền:
                    </span>
                    <span class="detail-value text-primary">
                        <%= String.format("%,.0f", totalAmount != null ? totalAmount : 0.0) %> VNĐ
                    </span>
                </div>
            </div>
            
            <!-- Action Buttons -->
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/my-courses?checkout=success" 
                   class="btn-primary-custom">
                    <i class="fas fa-book-open me-2"></i>
                    Xem Khóa Học Của Tôi
                </a>
            </div>
            
            <div class="mt-3">
                <a href="${pageContext.request.contextPath}/" 
                   class="btn-secondary-custom">
                    <i class="fas fa-home me-2"></i>
                    Về Trang Chủ
                </a>
                
                <a href="${pageContext.request.contextPath}/dashboard" 
                   class="btn-secondary-custom">
                    <i class="fas fa-tachometer-alt me-2"></i>
                    Dashboard
                </a>
            </div>
            
            <!-- Additional Info -->
            <div class="mt-4 pt-3 border-top">
                <p class="text-muted mb-0" style="font-size: 0.9rem;">
                    <i class="fas fa-envelope me-2"></i>
                    Email xác nhận đã được gửi đến: <strong><%= user.getEmail() %></strong>
                </p>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Confetti effect
        function createConfetti() {
            const confettiContainer = document.getElementById('confetti');
            const colors = ['#667eea', '#764ba2', '#00c851', '#ffbb33', '#ff4444'];
            
            for (let i = 0; i < 50; i++) {
                const confettiPiece = document.createElement('div');
                confettiPiece.className = 'confetti-piece';
                confettiPiece.style.left = Math.random() * 100 + '%';
                confettiPiece.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confettiPiece.style.animationDelay = Math.random() * 3 + 's';
                confettiPiece.style.animationDuration = (Math.random() * 3 + 2) + 's';
                confettiContainer.appendChild(confettiPiece);
            }
            
            // Remove confetti after animation
            setTimeout(() => {
                confettiContainer.innerHTML = '';
            }, 5000);
        }
        
        // Start confetti when page loads
        window.addEventListener('load', () => {
            setTimeout(createConfetti, 500);
        });
        
        // Auto redirect after 10 seconds (optional)
        /*
        setTimeout(() => {
            window.location.href = '${pageContext.request.contextPath}/my-courses?checkout=success';
        }, 10000);
        */
    </script>
</body>
</html>