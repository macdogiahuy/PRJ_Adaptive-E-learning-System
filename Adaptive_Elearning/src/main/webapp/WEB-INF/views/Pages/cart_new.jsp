<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.CartItem"%>
<%@page import="model.Users"%>
<%@page import="java.util.*"%>

<%
    // Get data from servlet
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Double totalAmount = (Double) request.getAttribute("totalAmount");
    Double totalDiscount = (Double) request.getAttribute("totalDiscount");
    Double finalAmount = (Double) request.getAttribute("finalAmount");
    Integer itemCount = (Integer) request.getAttribute("itemCount");
    Boolean emptyCart = (Boolean) request.getAttribute("emptyCart");
    String errorMessage = (String) request.getAttribute("errorMessage");
    
    // Get user from session
    Users user = (Users) session.getAttribute("account");
    
    // Set defaults
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
    
    <!-- CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/Adaptive_Elearning/assets/css/home.css">
    
    <style>
        .cart-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .cart-header {
            background: white;
            padding: 2rem;
            border-radius: var(--radius-lg);
            margin-bottom: 2rem;
            box-shadow: var(--shadow-sm);
        }
        
        .cart-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--secondary-900);
            margin-bottom: 0.5rem;
        }
        
        .cart-subtitle {
            color: var(--secondary-600);
        }
        
        .cart-content {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 2rem;
        }
        
        .cart-items {
            background: white;
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            box-shadow: var(--shadow-sm);
        }
        
        .cart-item {
            display: flex;
            gap: 1rem;
            padding: 1rem 0;
            border-bottom: 1px solid var(--secondary-200);
        }
        
        .cart-item:last-child {
            border-bottom: none;
        }
        
        .item-image {
            width: 120px;
            height: 80px;
            border-radius: var(--radius-md);
            overflow: hidden;
        }
        
        .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .item-details {
            flex: 1;
        }
        
        .item-title {
            font-weight: 600;
            color: var(--secondary-900);
            margin-bottom: 0.5rem;
        }
        
        .item-price {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--primary-600);
            margin-bottom: 1rem;
        }
        
        .item-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .quantity-control {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .quantity-btn {
            width: 32px;
            height: 32px;
            border: 1px solid var(--secondary-300);
            background: white;
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all var(--animate-duration);
        }
        
        .quantity-btn:hover {
            background: var(--secondary-100);
        }
        
        .quantity-input {
            width: 60px;
            text-align: center;
            border: 1px solid var(--secondary-300);
            border-radius: var(--radius-sm);
            padding: 0.5rem;
        }
        
        .remove-btn {
            color: var(--danger-500);
            background: var(--danger-50);
            border: none;
            padding: 0.5rem 1rem;
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: all var(--animate-duration);
        }
        
        .remove-btn:hover {
            background: var(--danger-100);
        }
        
        .cart-summary {
            background: white;
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            box-shadow: var(--shadow-sm);
            height: fit-content;
        }
        
        .summary-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.75rem;
        }
        
        .summary-total {
            border-top: 1px solid var(--secondary-200);
            padding-top: 0.75rem;
            font-weight: 700;
            font-size: 1.1rem;
        }
        
        .checkout-btn {
            width: 100%;
            background: var(--gradient-primary);
            color: white;
            border: none;
            padding: 1rem;
            border-radius: var(--radius-md);
            font-weight: 600;
            cursor: pointer;
            transition: all var(--animate-duration);
            margin-top: 1rem;
        }
        
        .checkout-btn:hover {
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }
        
        .empty-cart {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
        }
        
        .empty-icon {
            font-size: 4rem;
            color: var(--secondary-400);
            margin-bottom: 1rem;
        }
        
        .continue-shopping {
            background: var(--primary-500);
            color: white;
            text-decoration: none;
            padding: 0.75rem 1.5rem;
            border-radius: var(--radius-md);
            display: inline-block;
            margin-top: 1rem;
            transition: all var(--animate-duration);
        }
        
        .continue-shopping:hover {
            background: var(--primary-600);
            transform: translateY(-1px);
        }
        
        .error-message {
            background: var(--danger-50);
            color: var(--danger-600);
            padding: 1rem;
            border-radius: var(--radius-md);
            margin-bottom: 1rem;
            border: 1px solid var(--danger-200);
        }
        
        @media (max-width: 768px) {
            .cart-content {
                grid-template-columns: 1fr;
            }
            
            .cart-item {
                flex-direction: column;
                gap: 0.75rem;
            }
            
            .item-image {
                width: 100%;
                height: 200px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <nav class="nav-container">
                <a href="/Adaptive_Elearning/" class="logo">
                    <i class="fas fa-graduation-cap"></i>
                    <span>EduHub</span>
                </a>
                
                <div class="nav-menu">
                    <a href="/Adaptive_Elearning/" class="nav-link">Trang chủ</a>
                    <a href="#" class="nav-link">Khóa học</a>
                    <a href="#" class="nav-link">Giới thiệu</a>
                    <a href="#" class="nav-link">Liên hệ</a>
                </div>
                
                <div class="nav-actions">
                    <% if (user != null) { %>
                        <a href="/Adaptive_Elearning/cart-page" class="cart-link">
                            <div class="cart-icon">
                                <i class="fas fa-shopping-cart"></i>
                                <span class="cart-badge"><%= itemCount %></span>
                            </div>
                        </a>
                        <div class="user-info">
                            <span>Xin chào, <%= user.getFullName() %></span>
                        </div>
                    <% } else { %>
                        <a href="/Adaptive_Elearning/login" class="login-btn">Đăng nhập</a>
                    <% } %>
                </div>
            </nav>
        </div>
    </header>

    <!-- Main Content -->
    <main class="cart-container">
        <!-- Cart Header -->
        <div class="cart-header">
            <h1 class="cart-title">Giỏ hàng</h1>
            <p class="cart-subtitle">
                <%= emptyCart ? "Giỏ hàng của bạn đang trống" : "Bạn có " + itemCount + " khóa học trong giỏ hàng" %>
            </p>
        </div>

        <!-- Error Message -->
        <% if (errorMessage != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <%= errorMessage %>
            </div>
        <% } %>

        <% if (emptyCart) { %>
            <!-- Empty Cart -->
            <div class="empty-cart">
                <div class="empty-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <h3>Giỏ hàng trống</h3>
                <p>Hãy khám phá các khóa học tuyệt vời và thêm vào giỏ hàng!</p>
                <a href="/Adaptive_Elearning/" class="continue-shopping">
                    <i class="fas fa-arrow-left"></i>
                    Tiếp tục mua sắm
                </a>
            </div>
        <% } else { %>
            <!-- Cart Content -->
            <div class="cart-content">
                <!-- Cart Items -->
                <div class="cart-items">
                    <% for (CartItem item : cartItems) { %>
                        <div class="cart-item" data-course-id="<%= item.getCourseId() %>">
                            <div class="item-image">
                                <img src="<%= item.getThumbnail() != null ? item.getThumbnail() : "/Adaptive_Elearning/assets/images/course-default.jpg" %>" 
                                     alt="<%= item.getTitle() %>">
                            </div>
                            
                            <div class="item-details">
                                <h3 class="item-title"><%= item.getTitle() %></h3>
                                <div class="item-price">
                                    <%= String.format("%,.0f", item.getPrice()) %> VNĐ
                                </div>
                                
                                <div class="item-actions">
                                    <div class="quantity-control">
                                        <button class="quantity-btn" onclick="updateQuantity('<%= item.getCourseId() %>', '<%= item.getQuantity() - 1 %>')">
                                            <i class="fas fa-minus"></i>
                                        </button>
                                        <input type="number" class="quantity-input" 
                                               value="<%= item.getQuantity() %>" 
                                               min="1" max="10"
                                               onchange="updateQuantity('<%= item.getCourseId() %>', this.value)">
                                        <button class="quantity-btn" onclick="updateQuantity('<%= item.getCourseId() %>', '<%= item.getQuantity() + 1 %>')">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </div>
                                    
                                    <button class="remove-btn" onclick="removeItem('<%= item.getCourseId() %>')">
                                        <i class="fas fa-trash"></i>
                                        Xóa
                                    </button>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Cart Summary -->
                <div class="cart-summary">
                    <h3 class="summary-title">Tóm tắt đơn hàng</h3>
                    
                    <div class="summary-row">
                        <span>Tạm tính:</span>
                        <span><%= String.format("%,.0f", totalAmount) %> VNĐ</span>
                    </div>
                    
                    <% if (totalDiscount > 0) { %>
                        <div class="summary-row">
                            <span>Giảm giá:</span>
                            <span class="text-success">-<%= String.format("%,.0f", totalDiscount) %> VNĐ</span>
                        </div>
                    <% } %>
                    
                    <div class="summary-row summary-total">
                        <span>Tổng cộng:</span>
                        <span><%= String.format("%,.0f", finalAmount) %> VNĐ</span>
                    </div>
                    
                    <button class="checkout-btn" onclick="proceedToCheckout()">
                        <i class="fas fa-credit-card"></i>
                        Thanh toán
                    </button>
                    
                    <a href="/Adaptive_Elearning/" class="continue-shopping" style="display: block; text-align: center; margin-top: 1rem;">
                        Tiếp tục mua sắm
                    </a>
                </div>
            </div>
        <% } %>
    </main>

    <!-- JavaScript -->
    <script>
        function updateQuantity(courseId, quantity) {
            // Convert to number if it's a string
            const qty = parseInt(quantity);
            
            if (qty < 1) {
                removeItem(courseId);
                return;
            }
            
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/Adaptive_Elearning/cart-page';
            
            form.innerHTML = `
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="courseId" value="${courseId}">
                <input type="hidden" name="quantity" value="${qty}">
            `;
            
            document.body.appendChild(form);
            form.submit();
        }
        
        function removeItem(courseId) {
            if (confirm('Bạn có chắc muốn xóa khóa học này khỏi giỏ hàng?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '/Adaptive_Elearning/cart-page';
                
                form.innerHTML = `
                    <input type="hidden" name="action" value="remove">
                    <input type="hidden" name="courseId" value="${courseId}">
                `;
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function clearCart() {
            if (confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '/Adaptive_Elearning/cart-page';
                
                form.innerHTML = `<input type="hidden" name="action" value="clear">`;
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function proceedToCheckout() {
            // TODO: Implement checkout functionality
            alert('Chức năng thanh toán sẽ được triển khai sau!');
        }
        
        // Update cart badge on page load
        document.addEventListener('DOMContentLoaded', function() {
            const cartBadge = document.querySelector('.cart-badge');
            const itemCount = <%= itemCount != null ? itemCount : 0 %>;
            
            if (cartBadge) {
                if (itemCount > 0) {
                    cartBadge.textContent = itemCount;
                    cartBadge.style.display = 'flex';
                } else {
                    cartBadge.style.display = 'none';
                }
            }
        });
    </script>
</body>
</html>