<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.CartItem"%>
<%@page import="model.Users"%>
<%@page import="java.util.*"%>

<%
    // Lấy thông tin từ request
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    Double totalAmount = (Double) request.getAttribute("totalAmount");
    Integer cartCount = (Integer) request.getAttribute("cartCount");
    
    if (cartItems == null) {
        cartItems = new ArrayList<>();
    }
    if (totalAmount == null) {
        totalAmount = 0.0;
    }
    if (cartCount == null) {
        cartCount = 0;
    }
    
    Users u = null;
    if (session != null) {
        u = (Users) session.getAttribute("account");
    }
    
    // Kiểm tra đăng nhập
    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - EduHub</title>
    <meta name="description" content="Giỏ hàng khóa học của bạn tại EduHub">
    
    <!-- CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/Adaptive_Elearning/assets/css/home.css">
    <link rel="stylesheet" href="/Adaptive_Elearning/assets/css/cart.css">
    
    <!-- Favicon -->
    <link rel="icon" href="/Adaptive_Elearning/assets/images/favicon.ico" type="image/x-icon">
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
                    <a href="/Adaptive_Elearning/courses" class="nav-link">Khóa học</a>
                    <a href="/Adaptive_Elearning/about" class="nav-link">Giới thiệu</a>
                    <a href="/Adaptive_Elearning/contact" class="nav-link">Liên hệ</a>
                </div>
                
                <div class="nav-actions">
                    <a href="/Adaptive_Elearning/cart" class="cart-link active">
                        <div class="cart-icon">
                            <i class="fas fa-shopping-cart"></i>
                            <span class="cart-badge" id="cartBadge"><%= cartCount %></span>
                        </div>
                    </a>
                    <div class="user-dropdown">
                        <button class="user-menu-btn" type="button">
                            <div class="user-avatar">
                                <% if (u.getAvatarUrl() != null && !u.getAvatarUrl().isEmpty()) { %>
                                    <img src="<%= u.getAvatarUrl() %>" alt="Avatar" class="avatar-img">
                                <% } else { %>
                                    <i class="fas fa-user-circle"></i>
                                <% } %>
                            </div>
                            <div class="user-info">
                                <span class="user-name"><%= u.getUserName() %></span>
                                <i class="fas fa-chevron-down dropdown-arrow"></i>
                            </div>
                        </button>
                        <div class="dropdown-menu">
                            <a href="/Adaptive_Elearning/profile" class="dropdown-item">
                                <i class="fas fa-user"></i> Hồ sơ
                            </a>
                            <a href="/Adaptive_Elearning/my-courses" class="dropdown-item">
                                <i class="fas fa-book"></i> Khóa học của tôi
                            </a>
                            <a href="/Adaptive_Elearning/settings" class="dropdown-item">
                                <i class="fas fa-cog"></i> Cài đặt
                            </a>
                            <div class="dropdown-divider"></div>
                            <a href="/Adaptive_Elearning/logout" class="dropdown-item">
                                <i class="fas fa-sign-out-alt"></i> Đăng xuất
                            </a>
                        </div>
                    </div>
                </div>
            </nav>
        </div>
    </header>

    <!-- Main Content -->
    <main class="cart-main">
        <div class="container">
            <div class="cart-header">
                <h1 class="cart-title">
                    <i class="fas fa-shopping-cart"></i>
                    Giỏ hàng của bạn
                </h1>
                <p class="cart-subtitle">
                    <% if (cartCount > 0) { %>
                        Bạn có <strong><%= cartCount %></strong> khóa học trong giỏ hàng
                    <% } else { %>
                        Giỏ hàng của bạn đang trống
                    <% } %>
                </p>
            </div>

            <% if (cartItems.isEmpty()) { %>
                <!-- Empty Cart State -->
                <div class="empty-cart">
                    <div class="empty-cart-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <h2>Giỏ hàng trống</h2>
                    <p>Bạn chưa thêm khóa học nào vào giỏ hàng.</p>
                    <a href="/Adaptive_Elearning/" class="btn-primary">
                        <i class="fas fa-search"></i>
                        Khám phá khóa học
                    </a>
                </div>
            <% } else { %>
                <!-- Cart Content -->
                <div class="cart-content">
                    <div class="cart-items-section">
                        <div class="cart-items-header">
                            <h3>
                                <i class="fas fa-shopping-bag"></i>
                                Khóa học trong giỏ
                            </h3>
                            <button type="button" class="btn-clear-cart" onclick="clearCart()">
                                <i class="fas fa-trash-alt"></i>
                                Xóa tất cả
                            </button>
                        </div>

                        <div class="cart-items-list">
                            <% for (CartItem item : cartItems) { %>
                                <div class="cart-item" data-course-id="<%= item.getCourseId() %>">
                                    <div class="cart-item-image">
                                        <img src="<%= item.getCourseImage() != null ? item.getCourseImage() : "/Adaptive_Elearning/assets/images/course-default.jpg" %>" 
                                             alt="<%= item.getCourseName() %>">
                                    </div>
                                    
                                    <div class="cart-item-info">
                                        <h4 class="cart-item-title"><%= item.getCourseName() %></h4>
                                        <p class="cart-item-instructor">
                                            <i class="fas fa-user"></i>
                                            <%= item.getInstructorName() %>
                                        </p>
                                        <div class="cart-item-meta">
                                            <span class="meta-badge">
                                                <i class="fas fa-signal"></i>
                                                <%= item.getLevel() %>
                                            </span>
                                        </div>
                                    </div>
                                    
                                    <div class="cart-item-price">
                                        <% if (item.getDiscountPrice() > 0 && item.getDiscountPrice() < item.getOriginalPrice()) { 
                                            double discountPercent = ((item.getOriginalPrice() - item.getDiscountPrice()) / item.getOriginalPrice()) * 100;
                                        %>
                                            <span class="discount-badge">-<%= String.format("%.0f", discountPercent) %>%</span>
                                            <span class="original-price"><%= String.format("%,.0f đ", item.getOriginalPrice()) %></span>
                                            <span class="final-price"><%= String.format("%,.0f đ", item.getDiscountPrice()) %></span>
                                        <% } else { %>
                                            <span class="final-price"><%= String.format("%,.0f đ", item.getOriginalPrice()) %></span>
                                        <% } %>
                                    </div>
                                    
                                    <div class="cart-item-actions">
                                        <button type="button" class="btn-remove" 
                                                onclick="removeFromCart('<%= item.getCourseId() %>')"
                                                title="Xóa khỏi giỏ hàng">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- Cart Summary -->
                    <div class="cart-summary">
                        <h3>
                            <i class="fas fa-receipt"></i>
                            Tổng đơn hàng
                        </h3>
                        
                        <div class="summary-row">
                            <span>Tạm tính:</span>
                            <span id="subtotal"><%= String.format("%,.0f đ", totalAmount) %></span>
                        </div>
                        
                        <div class="summary-row">
                            <span>Giảm giá:</span>
                            <span class="discount-amount">0 đ</span>
                        </div>
                        
                        <div class="summary-divider"></div>
                        
                        <div class="summary-total">
                            <span>Tổng cộng:</span>
                            <span class="total-amount" id="totalAmount"><%= String.format("%,.0f đ", totalAmount) %></span>
                        </div>
                        
                        <button type="button" class="btn-checkout" onclick="checkout()">
                            <i class="fas fa-lock"></i>
                            Thanh toán an toàn
                        </button>
                        
                        <a href="/Adaptive_Elearning/" class="btn-continue-shopping">
                            <i class="fas fa-arrow-left"></i>
                            Tiếp tục mua sắm
                        </a>
                        
                        <!-- Trust Badges -->
                        <div class="trust-badges">
                            <div class="trust-badge">
                                <i class="fas fa-shield-alt"></i>
                                <span>Thanh toán an toàn & bảo mật</span>
                            </div>
                            <div class="trust-badge">
                                <i class="fas fa-undo"></i>
                                <span>Hoàn tiền trong 30 ngày</span>
                            </div>
                            <div class="trust-badge">
                                <i class="fas fa-infinity"></i>
                                <span>Truy cập trọn đời</span>
                            </div>
                            <div class="trust-badge">
                                <i class="fas fa-certificate"></i>
                                <span>Cấp chứng chỉ sau khóa học</span>
                            </div>
                        </div>
                        
                        <div class="payment-methods">
                            <p class="payment-title">Phương thức thanh toán</p>
                            <div class="payment-icons">
                                <i class="fab fa-cc-visa" title="Visa"></i>
                                <i class="fab fa-cc-mastercard" title="Mastercard"></i>
                                <i class="fab fa-cc-paypal" title="PayPal"></i>
                                <i class="fas fa-university" title="Chuyển khoản ngân hàng"></i>
                                <i class="fab fa-cc-amazon-pay" title="Amazon Pay"></i>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <p>&copy; 2024 EduHub. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <!-- Toast Notification -->
    <div id="toast" class="toast"></div>

    <!-- Scripts -->
    <script>
        // Xóa khóa học khỏi giỏ hàng
        function removeFromCart(courseId) {
            if (!confirm('Bạn có chắc muốn xóa khóa học này khỏi giỏ hàng?')) {
                return;
            }
            
            fetch('/Adaptive_Elearning/cart?action=remove&courseId=' + courseId, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'success');
                    // Reload trang sau 500ms
                    setTimeout(() => {
                        window.location.reload();
                    }, 500);
                } else {
                    showToast(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra. Vui lòng thử lại!', 'error');
            });
        }
        
        // Xóa tất cả khóa học
        function clearCart() {
            if (!confirm('Bạn có chắc muốn xóa tất cả khóa học khỏi giỏ hàng?')) {
                return;
            }
            
            fetch('/Adaptive_Elearning/cart?action=clear', {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast(data.message, 'success');
                    setTimeout(() => {
                        window.location.reload();
                    }, 500);
                } else {
                    showToast(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Có lỗi xảy ra. Vui lòng thử lại!', 'error');
            });
        }
        
        // Thanh toán
        function checkout() {
            showToast('Chức năng thanh toán đang được phát triển!', 'info');
            // TODO: Implement checkout functionality
            // window.location.href = '/Adaptive_Elearning/checkout';
        }
        
        // Hiển thị toast notification
        function showToast(message, type = 'info') {
            const toast = document.getElementById('toast');
            toast.textContent = message;
            toast.className = 'toast show ' + type;
            
            setTimeout(() => {
                toast.className = 'toast';
            }, 3000);
        }
        
        // Dropdown menu
        document.querySelector('.user-menu-btn').addEventListener('click', function() {
            document.querySelector('.dropdown-menu').classList.toggle('show');
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(event) {
            if (!event.target.closest('.user-dropdown')) {
                document.querySelector('.dropdown-menu').classList.remove('show');
            }
        });
    </script>
</body>
</html>
