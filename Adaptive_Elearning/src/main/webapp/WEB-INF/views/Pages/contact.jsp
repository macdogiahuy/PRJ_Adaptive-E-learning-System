<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>

<%
    Users user = null;
    int cartCount = 0;
    if (session != null) {
        user = (Users) session.getAttribute("account");
        // Lấy số lượng giỏ hàng từ session
        java.util.Map<String, model.CartItem> cart = 
            (java.util.Map<String, model.CartItem>) session.getAttribute("cart");
        if (cart != null) {
            cartCount = cart.size();
        }
    }
    String message = (String) request.getAttribute("message");
    String messageType = (String) request.getAttribute("messageType");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên hệ - FlyUp</title>
    <meta name="description" content="Liên hệ với FlyUp để được hỗ trợ, giải đáp thắc mắc hoặc đóng góp ý kiến. Chúng tôi luôn sẵn sàng lắng nghe bạn!">
    
    <!-- CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/Adaptive_Elearning/assets/css/home.css">
    
    <style>
        .contact-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }
        
        .hero-section {
            text-align: center;
            padding: 4rem 0;
            background: #ff9e4f;
            border-radius: var(--radius-lg);
            margin-bottom: 4rem;
        }
        
        .hero-title {
            font-size: 3rem;
            font-weight: 800;
            color: var(--secondary-900);
            margin-bottom: 1rem;
            background: white;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .hero-subtitle {
            font-size: 1.25rem;
            color: white;
            max-width: 600px;
            margin: 0 auto;
            line-height: 1.6;
        }
        
        .contact-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            margin-bottom: 4rem;
        }
        
        .contact-form-section {
            background: white;
            padding: 2.5rem;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
        }
        
        .form-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--secondary-900);
            margin-bottom: 1.5rem;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            display: block;
            font-weight: 600;
            color: var(--secondary-700);
            margin-bottom: 0.5rem;
        }
        
        .form-input {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 1px solid var(--secondary-300);
            border-radius: var(--radius-md);
            font-size: 1rem;
            transition: all var(--animate-duration);
        }
        
        .form-input:focus {
            outline: none;
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .form-textarea {
            resize: vertical;
            min-height: 120px;
        }
        
        .form-button {
            width: 100%;
            background: var(--gradient-primary);
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: var(--radius-md);
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all var(--animate-duration);
        }
        
        .form-button:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        
        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }
        
        .info-card {
            background: white;
            padding: 2rem;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            transition: all var(--animate-duration);
        }
        
        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }
        
        .info-icon {
            width: 60px;
            height: 60px;
            background: var(--gradient-primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin-bottom: 1rem;
        }
        
        .info-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--secondary-900);
            margin-bottom: 0.5rem;
        }
        
        .info-description {
            color: var(--secondary-600);
            line-height: 1.6;
        }
        
        .info-details {
            margin-top: 1rem;
        }
        
        .info-detail {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            color: var(--secondary-700);
        }
        
        .info-detail i {
            width: 20px;
            color: var(--primary-500);
        }
        
        .map-section {
            background: white;
            padding: 2rem;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            margin-bottom: 4rem;
        }
        
        .map-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--secondary-900);
            margin-bottom: 1rem;
            text-align: center;
        }
        
        .map-container {
            width: 100%;
            height: 400px;
            border-radius: var(--radius-md);
            overflow: hidden;
            border: 1px solid var(--secondary-200);
        }
        
        .map-placeholder {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, var(--primary-100) 0%, var(--secondary-100) 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: var(--secondary-600);
        }
        
        .map-placeholder i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--primary-500);
        }
        
        .faq-section {
            background: white;
            padding: 2.5rem;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
        }
        
        .faq-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--secondary-900);
            margin-bottom: 2rem;
            text-align: center;
        }
        
        .faq-item {
            border-bottom: 1px solid var(--secondary-200);
            padding: 1.5rem 0;
        }
        
        .faq-item:last-child {
            border-bottom: none;
        }
        
        .faq-question {
            font-weight: 600;
            color: var(--secondary-900);
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            transition: color var(--animate-duration);
        }
        
        .faq-question:hover {
            color: var(--primary-600);
        }
        
        .faq-answer {
            color: var(--secondary-600);
            line-height: 1.6;
            margin-top: 1rem;
            display: none;
        }
        
        .faq-answer.show {
            display: block;
        }
        
        .faq-icon {
            transition: transform var(--animate-duration);
        }
        
        .faq-icon.rotate {
            transform: rotate(180deg);
        }
        
        .alert {
            padding: 1rem 1.5rem;
            border-radius: var(--radius-md);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .alert-success {
            background: var(--success-50);
            color: var(--success-700);
            border: 1px solid var(--success-200);
        }
        
        .alert-error {
            background: var(--danger-50);
            color: var(--danger-700);
            border: 1px solid var(--danger-200);
        }
        
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2rem;
            }
            
            .contact-content {
                grid-template-columns: 1fr;
                gap: 2rem;
            }
            
            .contact-form-section {
                padding: 1.5rem;
            }
            
            .info-card {
                padding: 1.5rem;
            }
            
            .map-section {
                padding: 1.5rem;
            }
            
            .faq-section {
                padding: 1.5rem;
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
                    <span>FlyUp</span>
                </a>
                
                <div class="nav-menu">
                    <a href="/Adaptive_Elearning/" class="nav-link">Trang chủ</a>
                    <a href="/Adaptive_Elearning/courses" class="nav-link">Khóa học</a>
                    <a href="/Adaptive_Elearning/about" class="nav-link">Giới thiệu</a>
                    <a href="/Adaptive_Elearning/contact" class="nav-link active">Liên hệ</a>
                </div>
                
                <div class="nav-actions">
                    <% if (user != null) { %>
                        <a href="/Adaptive_Elearning/cart" class="cart-link">
                            <div class="cart-icon">
                                <i class="fas fa-shopping-cart"></i>
                                <span class="cart-badge" <% if (cartCount == 0) { %>style="display: none;"<% } %>><%= cartCount %></span>
                            </div>
                        </a>
                        <div class="user-dropdown">
                            <button class="user-menu-btn" type="button">
                                <div class="user-avatar">
                                    <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                                        <img src="<%= user.getAvatarUrl() %>" alt="Avatar" class="avatar-img">
                                    <% } else { %>
                                        <i class="fas fa-user-circle"></i>
                                    <% } %>
                                </div>
                                <div class="user-info">
                                    <span class="user-name"><%= user.getUserName() %></span>
                                    <i class="fas fa-chevron-down dropdown-arrow"></i>
                                </div>
                            </button>
                            <div class="dropdown-menu">
                                <div class="dropdown-header">
                                    <div class="user-details">
                                        <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().isEmpty()) { %>
                                            <img src="<%= user.getAvatarUrl() %>" alt="Avatar" class="dropdown-avatar">
                                        <% } else { %>
                                            <div class="dropdown-avatar-placeholder">
                                                <i class="fas fa-user-circle"></i>
                                            </div>
                                        <% } %>
                                        <div class="user-text">
                                            <div class="user-fullname"><%= user.getUserName() %></div>
                                            <div class="user-email"><%= user.getEmail() %></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="dropdown-divider"></div>
                                <div class="dropdown-items">
                                    <a href="/Adaptive_Elearning/dashboard" class="dropdown-item">
                                        <i class="fas fa-tachometer-alt"></i>
                                        <span>Dashboard</span>
                                    </a>
                    <a href="/Adaptive_Elearning/my-courses" class="dropdown-item">
                                        <i class="fas fa-book"></i>
                                        <span>Khóa học đã đăng ký</span>
                                    </a>
                                    <a href="/Adaptive_Elearning/profile" class="dropdown-item">
                                        <i class="fas fa-user-edit"></i>
                                        <span>Chỉnh sửa hồ sơ</span>
                                    </a>
                                    <a href="/Adaptive_Elearning/settings" class="dropdown-item">
                                        <i class="fas fa-cog"></i>
                                        <span>Cài đặt</span>
                                    </a>
                                </div>
                                <div class="dropdown-divider"></div>
                                <div class="dropdown-items">
                                    <a href="/Adaptive_Elearning/logout" class="dropdown-item logout-item">
                                        <i class="fas fa-sign-out-alt"></i>
                                        <span>Đăng xuất</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    <% } else { %>
                        <a href="/Adaptive_Elearning/login" class="login-btn">Đăng nhập</a>
                        <a href="/Adaptive_Elearning/register" class="register-btn">Đăng ký</a>
                    <% } %>
                </div>
            </nav>
        </div>
    </header>

    <!-- Main Content -->
    <main class="contact-container">
        <!-- Hero Section -->
        <section class="hero-section">
            <h1 class="hero-title">Liên hệ với chúng tôi</h1>
            <p class="hero-subtitle">
                Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn. Hãy liên hệ với chúng tôi qua bất kỳ kênh nào thuận tiện nhất.
            </p>
        </section>

        <!-- Contact Content -->
        <section class="contact-content">
            <!-- Contact Form -->
            <div class="contact-form-section">
                <h2 class="form-title">Gửi tin nhắn</h2>
                
                <% if (message != null) { %>
                    <div class="alert <%= messageType != null && messageType.equals("success") ? "alert-success" : "alert-error" %>">
                        <i class="fas fa-<%= messageType != null && messageType.equals("success") ? "check-circle" : "exclamation-triangle" %>"></i>
                        <%= message %>
                    </div>
                <% } %>
                
                <form action="/Adaptive_Elearning/contact" method="POST" id="contactForm">
                    <div class="form-group">
                        <label for="name" class="form-label">Họ và tên *</label>
                        <input type="text" id="name" name="name" class="form-input" required 
                               value="<%= user != null ? user.getFullName() : "" %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="email" class="form-label">Email *</label>
                        <input type="email" id="email" name="email" class="form-input" required 
                               value="<%= user != null ? user.getEmail() : "" %>">
                    </div>
                    
                    <div class="form-group">
                        <label for="phone" class="form-label">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" class="form-input">
                    </div>
                    
                    <div class="form-group">
                        <label for="subject" class="form-label">Chủ đề *</label>
                        <select id="subject" name="subject" class="form-input" required>
                            <option value="">Chọn chủ đề</option>
                            <option value="support">Hỗ trợ kỹ thuật</option>
                            <option value="course">Thắc mắc về khóa học</option>
                            <option value="payment">Vấn đề thanh toán</option>
                            <option value="partnership">Hợp tác</option>
                            <option value="feedback">Góp ý, phản hồi</option>
                            <option value="other">Khác</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="message" class="form-label">Nội dung *</label>
                        <textarea id="message" name="message" class="form-input form-textarea" 
                                  placeholder="Mô tả chi tiết thắc mắc hoặc yêu cầu của bạn..." required></textarea>
                    </div>
                    
                    <button type="submit" class="form-button">
                        <i class="fas fa-paper-plane"></i>
                        Gửi tin nhắn
                    </button>
                </form>
            </div>

            <!-- Contact Info -->
            <div class="contact-info">
                <div class="info-card">
                    <div class="info-icon">
                        <i class="fas fa-map-marker-alt"></i>
                    </div>
                    <h3 class="info-title">Địa chỉ văn phòng</h3>
                    <p class="info-description">Ghé thăm văn phòng của chúng tôi để được tư vấn trực tiếp</p>
                    <div class="info-details">
                        <div class="info-detail">
                            <i class="fas fa-building"></i>
                            <span>Tầng 15, Tòa nhà ABC, 123 Đường XYZ</span>
                        </div>
                        <div class="info-detail">
                            <i class="fas fa-map"></i>
                            <span>Quận 1, TP. Hồ Chí Minh</span>
                        </div>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-icon">
                        <i class="fas fa-phone"></i>
                    </div>
                    <h3 class="info-title">Điện thoại</h3>
                    <p class="info-description">Liên hệ hotline để được hỗ trợ nhanh chóng</p>
                    <div class="info-details">
                        <div class="info-detail">
                            <i class="fas fa-phone-alt"></i>
                            <span>Hotline: 1900 1234</span>
                        </div>
                        <div class="info-detail">
                            <i class="fas fa-mobile-alt"></i>
                            <span>Mobile: 0901 234 567</span>
                        </div>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <h3 class="info-title">Email</h3>
                    <p class="info-description">Gửi email cho chúng tôi, chúng tôi sẽ phản hồi trong 24 giờ</p>
                    <div class="info-details">
                        <div class="info-detail">
                            <i class="fas fa-envelope"></i>
                            <span>support@FlyUp.vn</span>
                        </div>
                        <div class="info-detail">
                            <i class="fas fa-envelope-open"></i>
                            <span>info@FlyUp.vn</span>
                        </div>
                    </div>
                </div>

                <div class="info-card">
                    <div class="info-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h3 class="info-title">Giờ làm việc</h3>
                    <p class="info-description">Thời gian hỗ trợ khách hàng</p>
                    <div class="info-details">
                        <div class="info-detail">
                            <i class="fas fa-calendar-week"></i>
                            <span>Thứ 2 - Thứ 6: 8:00 - 18:00</span>
                        </div>
                        <div class="info-detail">
                            <i class="fas fa-calendar-day"></i>
                            <span>Thứ 7: 8:00 - 12:00</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Map Section -->
        <section class="map-section">
            <h2 class="map-title">Vị trí văn phòng</h2>
            <div class="map-container">
                <div class="map-placeholder">
                    <i class="fas fa-map-marked-alt"></i>
                    <h3>Bản đồ sẽ được tích hợp sau</h3>
                    <p>Tầng 15, Tòa nhà ABC, 123 Đường XYZ, Quận 1, TP. HCM</p>
                </div>
            </div>
        </section>

        <!-- FAQ Section -->
        <section class="faq-section">
            <h2 class="faq-title">Câu hỏi thường gặp</h2>
            
            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <span>Làm thế nào để đăng ký khóa học?</span>
                    <i class="fas fa-chevron-down faq-icon"></i>
                </div>
                <div class="faq-answer">
                    Bạn có thể đăng ký khóa học bằng cách tạo tài khoản, chọn khóa học mong muốn, thêm vào giỏ hàng và tiến hành thanh toán. Sau khi thanh toán thành công, bạn sẽ có quyền truy cập vào khóa học ngay lập tức.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <span>Tôi có thể học offline không?</span>
                    <i class="fas fa-chevron-down faq-icon"></i>
                </div>
                <div class="faq-answer">
                    Hiện tại, tất cả các khóa học của chúng tôi đều được cung cấp online. Tuy nhiên, bạn có thể tải xuống tài liệu và xem video offline trong một số khóa học có hỗ trợ tính năng này.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <span>Chính sách hoàn tiền như thế nào?</span>
                    <i class="fas fa-chevron-down faq-icon"></i>
                </div>
                <div class="faq-answer">
                    Chúng tôi có chính sách hoàn tiền 100% trong vòng 7 ngày đầu tiên nếu bạn không hài lòng với khóa học. Sau thời gian này, việc hoàn tiền sẽ được xem xét dựa trên từng trường hợp cụ thể.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <span>Tôi có nhận được chứng chỉ sau khi hoàn thành khóa học không?</span>
                    <i class="fas fa-chevron-down faq-icon"></i>
                </div>
                <div class="faq-answer">
                    Có, sau khi hoàn thành khóa học và vượt qua các bài kiểm tra, bạn sẽ nhận được chứng chỉ hoàn thành có thể tải xuống và chia sẻ trên các mạng xã hội nghề nghiệp.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question" onclick="toggleFAQ(this)">
                    <span>Làm sao để liên hệ với giảng viên?</span>
                    <i class="fas fa-chevron-down faq-icon"></i>
                </div>
                <div class="faq-answer">
                    Mỗi khóa học đều có diễn đàn thảo luận và hệ thống Q&A để bạn có thể đặt câu hỏi cho giảng viên. Ngoài ra, một số khóa học có session live để tương tác trực tiếp với giảng viên.
                </div>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-brand">
                    <h3>FlyUp</h3>
                    <p>Nền tảng học trực tuyến hàng đầu Việt Nam, mang đến những khóa học chất lượng cao với chi phí hợp lý.</p>
                </div>
                
                <div class="footer-section">
                    <h4 class="footer-title">Khóa học</h4>
                    <ul class="footer-links">
                        <li><a href="#">Lập trình</a></li>
                        <li><a href="#">Thiết kế</a></li>
                        <li><a href="#">Marketing</a></li>
                        <li><a href="#">Kinh doanh</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4 class="footer-title">Hỗ trợ</h4>
                    <ul class="footer-links">
                        <li><a href="#">Trung tâm trợ giúp</a></li>
                        <li><a href="#">Liên hệ</a></li>
                        <li><a href="#">Câu hỏi thường gặp</a></li>
                        <li><a href="#">Báo cáo lỗi</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4 class="footer-title">Kết nối</h4>
                    <ul class="footer-links">
                        <li><a href="#"><i class="fab fa-facebook"></i> Facebook</a></li>
                        <li><a href="#"><i class="fab fa-youtube"></i> YouTube</a></li>
                        <li><a href="#"><i class="fab fa-linkedin"></i> LinkedIn</a></li>
                        <li><a href="#"><i class="fab fa-twitter"></i> Twitter</a></li>
                    </ul>
                </div>
            </div>
            
            <div style="text-align: center; padding-top: 2rem; border-top: 1px solid #374151; display: flex; justify-content: center; align-items: center; gap: 30px; flex-wrap: wrap;">
                <p>&copy; 2024 FlyUp. Tất cả quyền được bảo lưu.</p>
                <%@ include file="/WEB-INF/components/online-users-counter.jsp" %>
            </div>
        </div>
    </footer>

    <!-- JavaScript -->
    <script>
        // User dropdown functionality
        document.addEventListener('DOMContentLoaded', function() {
            const userMenuBtn = document.querySelector('.user-menu-btn');
            const dropdownMenu = document.querySelector('.user-dropdown .dropdown-menu');
            
            if (userMenuBtn && dropdownMenu) {
                userMenuBtn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    dropdownMenu.classList.toggle('show');
                    
                    // Rotate arrow
                    const arrow = this.querySelector('.dropdown-arrow');
                    if (arrow) {
                        arrow.style.transform = dropdownMenu.classList.contains('show') 
                            ? 'rotate(180deg)' 
                            : 'rotate(0deg)';
                    }
                });
                
                // Close dropdown when clicking outside
                document.addEventListener('click', function(e) {
                    if (!userMenuBtn.contains(e.target) && !dropdownMenu.contains(e.target)) {
                        dropdownMenu.classList.remove('show');
                        const arrow = userMenuBtn.querySelector('.dropdown-arrow');
                        if (arrow) {
                            arrow.style.transform = 'rotate(0deg)';
                        }
                    }
                });
            }
        });

        function toggleFAQ(element) {
            const answer = element.nextElementSibling;
            const icon = element.querySelector('.faq-icon');
            
            answer.classList.toggle('show');
            icon.classList.toggle('rotate');
        }

        // Form validation
        document.getElementById('contactForm').addEventListener('submit', function(e) {
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const subject = document.getElementById('subject').value;
            const message = document.getElementById('message').value.trim();

            if (!name || !email || !subject || !message) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ các trường bắt buộc!');
                return false;
            }

            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert('Vui lòng nhập email hợp lệ!');
                return false;
            }

            return true;
        });

        // Auto-hide alert messages
        window.addEventListener('load', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    setTimeout(() => {
                        alert.style.display = 'none';
                    }, 300);
                }, 5000);
            });
        });
    </script>
</body>
</html>