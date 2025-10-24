<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Cart"%>
<%@page import="model.CartItem"%>
<%@page import="model.Users"%>
<%@page import="java.util.*"%>

<%
    // Get cart data from servlet
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Double totalAmount = (Double) request.getAttribute("totalAmount");
    Double totalDiscount = (Double) request.getAttribute("totalDiscount");
    Double finalAmount = (Double) request.getAttribute("finalAmount");
    Integer itemCount = (Integer) request.getAttribute("itemCount");
    Boolean emptyCart = (Boolean) request.getAttribute("emptyCart");
    String errorMessage = (String) request.getAttribute("errorMessage");
    
    // Get user from session
    Users user = null;
    if (session != null) {
        user = (Users) session.getAttribute("account");
    }
    
    // Set defaults if null
    if (cartItems == null) cartItems = new ArrayList<>();
    if (totalAmount == null) totalAmount = 0.0;
    if (totalDiscount == null) totalDiscount = 0.0;
    if (finalAmount == null) finalAmount = 0.0;
    if (itemCount == null) itemCount = 0;
    if (emptyCart == null) emptyCart = cartItems.isEmpty();
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - EduHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-50: #eff6ff;
            --primary-100: #dbeafe;
            --primary-200: #bfdbfe;
            --primary-300: #93c5fd;
            --primary-400: #60a5fa;
            --primary-500: #3b82f6;
            --primary-600: #2563eb;
            --primary-700: #1d4ed8;
            --primary-800: #1e40af;
            --primary-900: #1e3a8a;

            --secondary-50: #f8fafc;
            --secondary-100: #f1f5f9;
            --secondary-200: #e2e8f0;
            --secondary-300: #cbd5e1;
            --secondary-400: #94a3b8;
            --secondary-500: #64748b;
            --secondary-600: #475569;
            --secondary-700: #334155;
            --secondary-800: #1e293b;
            --secondary-900: #0f172a;

            --success-50: #f0fdf4;
            --success-100: #dcfce7;
            --success-200: #bbf7d0;
            --success-500: #22c55e;
            --success-600: #16a34a;
            --success-700: #15803d;

            --danger-50: #fef2f2;
            --danger-100: #fee2e2;
            --danger-200: #fecaca;
            --danger-500: #ef4444;
            --danger-600: #dc2626;
            --danger-700: #b91c1c;

            --warning-50: #fffbeb;
            --warning-100: #fef3c7;
            --warning-200: #fde68a;
            --warning-500: #f59e0b;
            --warning-600: #d97706;

            --gradient-primary: linear-gradient(135deg, var(--primary-600), var(--primary-400));
            --gradient-success: linear-gradient(135deg, var(--success-600), var(--success-400));
            --gradient-danger: linear-gradient(135deg, var(--danger-600), var(--danger-400));

            --radius-sm: 0.375rem;
            --radius-md: 0.5rem;
            --radius-lg: 0.75rem;
            --radius-xl: 1rem;
            --radius-full: 9999px;

            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
            --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);

            --animate-duration: 0.2s;
            --animate-ease: cubic-bezier(0.4, 0, 0.2, 1);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--secondary-50);
            color: var(--secondary-900);
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        /* Header */
        .header {
            background: white;
            border-bottom: 1px solid var(--secondary-200);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
            color: var(--secondary-900);
        }

        .logo h1 {
            font-family: 'Manrope', sans-serif;
            font-weight: 800;
            font-size: 1.5rem;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--secondary-600);
            font-weight: 500;
            transition: color var(--animate-duration);
        }

        .nav-links a:hover,
        .nav-links a.active {
            color: var(--primary-600);
        }

        /* Main Content */
        .main {
            padding: 2rem 0;
            min-height: calc(100vh - 200px);
        }

        .page-header {
            margin-bottom: 2rem;
        }

        .page-title {
            font-family: 'Manrope', sans-serif;
            font-size: 2rem;
            font-weight: 700;
            color: var(--secondary-900);
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            color: var(--secondary-600);
            font-size: 1.1rem;
        }

        /* Cart Layout */
        .cart-layout {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 2rem;
        }

        .cart-items {
            background: white;
            border-radius: var(--radius-lg);
            border: 1px solid var(--secondary-200);
            overflow: hidden;
        }

        .cart-items-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--secondary-200);
            background: var(--secondary-50);
        }

        .cart-items-title {
            font-family: 'Manrope', sans-serif;
            font-weight: 600;
            color: var(--secondary-900);
        }

        .cart-item {
            padding: 1.5rem;
            border-bottom: 1px solid var(--secondary-100);
            display: flex;
            gap: 1rem;
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .item-image {
            width: 120px;
            height: 80px;
            border-radius: var(--radius-md);
            overflow: hidden;
            flex-shrink: 0;
        }

        .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .item-content {
            flex: 1;
        }

        .item-title {
            font-family: 'Manrope', sans-serif;
            font-weight: 600;
            color: var(--secondary-900);
            margin-bottom: 0.5rem;
            line-height: 1.4;
        }

        .item-instructor {
            color: var(--secondary-600);
            font-size: 0.875rem;
            margin-bottom: 0.5rem;
        }

        .item-level {
            display: inline-block;
            background: var(--primary-50);
            color: var(--primary-700);
            padding: 0.25rem 0.5rem;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 500;
        }

        .item-actions {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 1rem;
        }

        .item-price {
            text-align: right;
        }

        .current-price {
            font-family: 'Manrope', sans-serif;
            font-weight: 700;
            color: var(--primary-600);
            font-size: 1.25rem;
        }

        .original-price {
            color: var(--secondary-400);
            text-decoration: line-through;
            font-size: 0.875rem;
        }

        .remove-btn {
            background: none;
            border: none;
            color: var(--danger-500);
            cursor: pointer;
            padding: 0.5rem;
            border-radius: var(--radius-md);
            transition: all var(--animate-duration);
        }

        .remove-btn:hover {
            background: var(--danger-50);
            color: var(--danger-600);
        }

        /* Cart Summary */
        .cart-summary {
            background: white;
            border-radius: var(--radius-lg);
            border: 1px solid var(--secondary-200);
            padding: 1.5rem;
            height: fit-content;
            position: sticky;
            top: 100px;
        }

        .summary-title {
            font-family: 'Manrope', sans-serif;
            font-weight: 600;
            color: var(--secondary-900);
            margin-bottom: 1rem;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            color: var(--secondary-600);
        }

        .summary-row.total {
            border-top: 1px solid var(--secondary-200);
            padding-top: 1rem;
            margin-top: 1rem;
            font-weight: 600;
            color: var(--secondary-900);
            font-size: 1.1rem;
        }

        .summary-row .value {
            font-weight: 500;
        }

        .summary-row.total .value {
            color: var(--primary-600);
            font-family: 'Manrope', sans-serif;
            font-weight: 700;
        }

        .discount-amount {
            color: var(--success-600) !important;
        }

        .checkout-btn {
            width: 100%;
            background: var(--gradient-primary);
            color: white;
            border: none;
            padding: 1rem;
            border-radius: var(--radius-lg);
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all var(--animate-duration);
            margin-top: 1rem;
        }

        .checkout-btn:hover {
            transform: translateY(-1px);
            box-shadow: var(--shadow-lg);
        }

        .checkout-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }

        /* Empty Cart */
        .empty-cart {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: var(--radius-lg);
            border: 1px solid var(--secondary-200);
        }

        .empty-icon {
            font-size: 4rem;
            color: var(--secondary-300);
            margin-bottom: 1rem;
        }

        .empty-title {
            font-family: 'Manrope', sans-serif;
            font-weight: 600;
            color: var(--secondary-900);
            margin-bottom: 0.5rem;
        }

        .empty-text {
            color: var(--secondary-600);
            margin-bottom: 2rem;
        }

        .continue-shopping-btn {
            background: var(--gradient-primary);
            color: white;
            text-decoration: none;
            padding: 0.75rem 1.5rem;
            border-radius: var(--radius-lg);
            font-weight: 500;
            transition: all var(--animate-duration);
            display: inline-block;
        }

        .continue-shopping-btn:hover {
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .cart-layout {
                grid-template-columns: 1fr;
            }

            .cart-item {
                flex-direction: column;
                gap: 1rem;
            }

            .item-image {
                width: 100%;
                height: 200px;
            }

            .item-actions {
                flex-direction: row;
                justify-content: space-between;
                align-items: center;
            }

            .nav-links {
                display: none;
            }
        }

        /* Loading States */
        .loading {
            opacity: 0.7;
            pointer-events: none;
        }

        .loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 20px;
            height: 20px;
            border: 2px solid transparent;
            border-top: 2px solid var(--primary-500);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <a href="home" class="logo">
                    <img src="assets/images/logo.png" alt="EduHub" width="32" height="32">
                    <h1>EduHub</h1>
                </a>
                
                <nav class="nav-links">
                    <a href="home">Trang chủ</a>
                    <a href="courses">Khóa học</a>
                    <a href="cart" class="active">Giỏ hàng (<%= totalItems %>)</a>
                    <% if (user != null) { %>
                        <a href="profile">Hồ sơ</a>
                        <a href="logout">Đăng xuất</a>
                    <% } else { %>
                        <a href="login.jsp">Đăng nhập</a>
                    <% } %>
                </nav>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Giỏ hàng của bạn</h1>
                <p class="page-subtitle">
                    <% if (totalItems > 0) { %>
                        Bạn có <%= totalItems %> khóa học trong giỏ hàng
                    <% } else { %>
                        Giỏ hàng của bạn đang trống
                    <% } %>
                </p>
            </div>

            <% if (cartItems.isEmpty()) { %>
                <!-- Empty Cart -->
                <div class="empty-cart">
                    <div class="empty-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <h2 class="empty-title">Giỏ hàng trống</h2>
                    <p class="empty-text">
                        Bạn chưa thêm khóa học nào vào giỏ hàng. 
                        Hãy khám phá các khóa học tuyệt vời của chúng tôi!
                    </p>
                    <a href="home" class="continue-shopping-btn">
                        <i class="fas fa-arrow-left"></i>
                        Tiếp tục mua sắm
                    </a>
                </div>
            <% } else { %>
                <!-- Cart with Items -->
                <div class="cart-layout">
                    <!-- Cart Items -->
                    <div class="cart-items">
                        <div class="cart-items-header">
                            <h2 class="cart-items-title">Khóa học đã chọn</h2>
                        </div>
                        
                        <% for (CartItem item : cartItems) { %>
                        <div class="cart-item" data-course-id="<%= item.getCourseId() %>">
                            <div class="item-image">
                                <img src="<%= item.getCourseImage() != null && !item.getCourseImage().isEmpty() 
                                          ? item.getCourseImage() : "assets/images/default.jpg" %>" 
                                     alt="<%= item.getCourseName() %>">
                            </div>
                            
                            <div class="item-content">
                                <h3 class="item-title"><%= item.getCourseName() %></h3>
                                <p class="item-instructor">
                                    <i class="fas fa-user"></i>
                                    <%= item.getInstructorName() != null ? item.getInstructorName() : "Chưa có thông tin" %>
                                </p>
                                <span class="item-level">
                                    <%= item.getLevel() != null ? item.getLevel() : "Tất cả cấp độ" %>
                                </span>
                            </div>
                            
                            <div class="item-actions">
                                <div class="item-price">
                                    <div class="current-price">
                                        <%= String.format("%,.0f", item.getFinalPrice()) %>₫
                                    </div>
                                    <% if (item.hasDiscount()) { %>
                                    <div class="original-price">
                                        <%= String.format("%,.0f", item.getOriginalPrice()) %>₫
                                    </div>
                                    <% } %>
                                </div>
                                
                                <button class="remove-btn" onclick="removeFromCart('<%= item.getCourseId() %>')" 
                                        title="Xóa khỏi giỏ hàng">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </div>
                        <% } %>
                    </div>

                    <!-- Cart Summary -->
                    <div class="cart-summary">
                        <h3 class="summary-title">Tóm tắt đơn hàng</h3>
                        
                        <div class="summary-row">
                            <span>Số khóa học:</span>
                            <span class="value"><%= cartItems.size() %></span>
                        </div>
                        
                        <div class="summary-row">
                            <span>Tổng tiền gốc:</span>
                            <span class="value"><%= String.format("%,.0f", cart.getTotalOriginalPrice()) %>₫</span>
                        </div>
                        
                        <% if (discountAmount > 0) { %>
                        <div class="summary-row">
                            <span>Giảm giá:</span>
                            <span class="value discount-amount">-<%= String.format("%,.0f", discountAmount) %>₫</span>
                        </div>
                        <% } %>
                        
                        <div class="summary-row total">
                            <span>Tổng thanh toán:</span>
                            <span class="value"><%= String.format("%,.0f", totalPrice) %>₫</span>
                        </div>
                        
                        <button class="checkout-btn" onclick="checkout()">
                            <i class="fas fa-credit-card"></i>
                            Thanh toán ngay
                        </button>
                        
                        <a href="home" class="continue-shopping-btn" style="display: block; text-align: center; margin-top: 1rem;">
                            <i class="fas fa-arrow-left"></i>
                            Tiếp tục mua sắm
                        </a>
                    </div>
                </div>
            <% } %>
        </div>
    </main>

    <script>
        // Configuration from server
        var isLoggedIn = <%= (user != null) %>;
        var totalPrice = '<%= String.format("%,.0f", totalPrice) %>';
        var itemCount = <%= cartItems.size() %>;
        var currentCartCount = <%= totalItems %>;

        // Remove item from cart
        function removeFromCart(courseId) {
            if (!confirm('Bạn có chắc muốn xóa khóa học này khỏi giỏ hàng?')) {
                return;
            }

            const cartItem = document.querySelector(`[data-course-id="${courseId}"]`);
            if (cartItem) {
                cartItem.classList.add('loading');
            }

            fetch('remove-from-cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'courseId=' + encodeURIComponent(courseId)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Remove item from DOM
                    if (cartItem) {
                        cartItem.remove();
                    }
                    
                    // Reload page to update totals
                    window.location.reload();
                } else {
                    if (cartItem) {
                        cartItem.classList.remove('loading');
                    }
                    alert(data.message || 'Có lỗi xảy ra khi xóa khóa học');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                if (cartItem) {
                    cartItem.classList.remove('loading');
                }
                alert('Có lỗi xảy ra. Vui lòng thử lại.');
            });
        }

        // Checkout process
        function checkout() {
            if (!isLoggedIn) {
                alert('Vui lòng đăng nhập để thanh toán');
                window.location.href = 'login.jsp?redirect=cart';
                return;
            }

            if (confirm('Bạn có chắc muốn thanh toán ' + totalPrice + '₫ cho ' + itemCount + ' khóa học?')) {
                // TODO: Implement actual checkout process
                alert('Tính năng thanh toán sẽ được triển khai trong phiên bản tới!');
            }
        }

        // Auto-update cart periodically
        setInterval(function() {
            fetch('cart-count')
            .then(response => response.json())
            .then(data => {
                if (data.success && data.cartCount !== currentCartCount) {
                    // Cart changed, reload page
                    window.location.reload();
                }
            })
            .catch(error => {
                console.error('Error checking cart:', error);
            });
        }, 30000); // Check every 30 seconds
    </script>
</body>
</html>