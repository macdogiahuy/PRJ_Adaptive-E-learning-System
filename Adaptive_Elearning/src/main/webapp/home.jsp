<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="controller.CourseManagementController"%>
<%@page import="controller.CourseManagementController.Course"%>
<%@page import="java.util.*"%>
<%@page import="model.Users"%>

<%
    // Dữ liệu courses, phân trang, tìm kiếm
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    String search = (String) request.getAttribute("search");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalCourses = (Integer) request.getAttribute("totalCourses");
    String errorMessage = (String) request.getAttribute("errorMessage");

    if (search == null) {
        search = "http://localhost:8080/Adaptive_Elearning/home";
    }
    if (currentPage == null) {
        currentPage = 1;
    }
    if (totalPages == null) {
        totalPages = 1;
    }
    if (totalCourses == null) {
        totalCourses = 0;
    }

    Users u = null;
    int cartCount = 0;
    if (session != null) {
        u = (Users) session.getAttribute("account");
        // Lấy số lượng giỏ hàng từ session
        java.util.Map<String, model.CartItem> cart = 
            (java.util.Map<String, model.CartItem>) session.getAttribute("cart");
        if (cart != null) {
            cartCount = cart.size();
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FlyUp - Học mọi lúc, mọi nơi</title>
    <meta name="description" content="FlyUp - Khám phá hàng nghìn khóa học chất lượng cao từ các chuyên gia hàng đầu. Học mọi lúc, mọi nơi với chi phí hợp lý.">
    <meta name="keywords" content="học trực tuyến, khóa học online, giáo dục, kỹ năng, công nghệ">
    
    <!-- Preload critical resources -->
    <link rel="preload" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" as="style">
    <link rel="preload" href="/Adaptive_Elearning/assets/css/home.css" as="style">
    <link rel="preload" href="/Adaptive_Elearning/assets/js/home.js" as="script">
    
    <!-- CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/Adaptive_Elearning/assets/css/home.css">
    
    <!-- Alert Messages CSS -->
    <style>
        .alert-message {
            padding: 1rem 0;
            border-left: 4px solid;
            animation: slideInDown 0.5s ease-out;
            margin-bottom: 0;
        }
        
        .alert-success {
            background-color: #d4edda;
            border-color: #28a745;
            color: #155724;
        }
        
        .alert-info {
            background-color: #d1ecf1;
            border-color: #17a2b8;
            color: #0c5460;
        }
        
        .alert-content {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .alert-icon {
            font-size: 1.5rem;
        }
        
        .alert-text {
            flex: 1;
        }
        
        .alert-close {
            background: none;
            border: none;
            font-size: 1.2rem;
            cursor: pointer;
            opacity: 0.7;
            transition: opacity 0.3s ease;
        }
        
        .alert-close:hover {
            opacity: 1;
        }
        
        @keyframes slideInDown {
            from {
                transform: translateY(-100%);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
    </style>
    
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
                    <span>FlyUp</span>
                </a>
                
                <div class="nav-menu">
                    <a href="/Adaptive_Elearning/" class="nav-link active">Trang chủ</a>
                   
                   
                    <a href="/Adaptive_Elearning/about" class="nav-link">Giới thiệu</a>
                    <a href="/Adaptive_Elearning/contact" class="nav-link">Liên hệ</a>
                </div>
                
                <div class="nav-actions">
                    <% if (u != null) { %>
                        <a href="/Adaptive_Elearning/cart" class="cart-link">
                            <div class="cart-icon">
                                <i class="fas fa-shopping-cart"></i>
                                <span class="cart-badge" <% if (cartCount == 0) { %>style="display: none;"<% } %>><%= cartCount %></span>
                            </div>
                        </a>
                    <% } %>
                    <%-- User Dropdown Menu with Role-Based Access (includes login/register buttons) --%>
                    <%@ include file="/WEB-INF/includes/user-dropdown.jsp" %>
                </div>
            </nav>
        </div>
    </header>

    <!-- Logout/Login Success Messages -->
    <%
        Boolean showLogoutMessage = (Boolean) request.getAttribute("showLogoutMessage");
        String logoutMessage = (String) request.getAttribute("logoutMessage");
        Boolean showLoginMessage = (Boolean) request.getAttribute("showLoginMessage");
        String loginMessage = (String) request.getAttribute("loginMessage");
    %>
    
    <% if (showLogoutMessage != null && showLogoutMessage) { %>
    <div class="alert-message alert-success" id="logoutAlert">
        <div class="container">
            <div class="alert-content">
                <i class="fas fa-check-circle alert-icon"></i>
                <div class="alert-text">
                    <strong>Đăng xuất thành công!</strong>
                    <div><%= logoutMessage %></div>
                </div>
                <button type="button" class="alert-close" onclick="closeAlert('logoutAlert')">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    </div>
    <% } %>
    
    <% if (showLoginMessage != null && showLoginMessage) { %>
    <div class="alert-message alert-info" id="loginAlert">
        <div class="container">
            <div class="alert-content">
                <i class="fas fa-user-check alert-icon"></i>
                <div class="alert-text">
                    <strong>Đăng nhập thành công!</strong>
                    <div><%= loginMessage %></div>
                </div>
                <button type="button" class="alert-close" onclick="closeAlert('loginAlert')">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    </div>
    <% } %>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h1 class="hero-title">Học tập không giới hạn</h1>
            <p class="hero-subtitle">Khám phá hàng nghìn khóa học chất lượng cao từ các chuyên gia hàng đầu</p>
            
            <div class="search-container">
                <form class="search-form" action="/Adaptive_Elearning/" method="GET">
                    <input type="text" name="search" class="search-input" 
                           placeholder="Tìm kiếm khóa học..." value="<%= search %>">
                    <button type="submit" class="search-submit">
                        <i class="fas fa-search"></i>
                        Tìm kiếm
                    </button>
                </form>
            </div>
            
            <div class="hero-stats">
                <div class="stat-item">
                    <div class="stat-number"><%= totalCourses %></div>
                    <div class="stat-label">Khóa học</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">10K+</div>
                    <div class="stat-label">Học viên</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">50+</div>
                    <div class="stat-label">Giảng viên</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Courses Section -->
    <section class="courses-section" id="courses">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">
                    <%= !search.isEmpty() ? "Kết quả tìm kiếm: " + search : "Khóa học nổi bật" %>
                </h2>
                <p class="section-subtitle">
                    <%= !search.isEmpty() ? "Tìm thấy " + totalCourses + " khóa học" : "Những khóa học được yêu thích nhất từ cộng đồng học viên" %>
                </p>
            </div>
            
            <% if (errorMessage != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <div class="courses-grid">
                <% if (courses != null && !courses.isEmpty()) { 
                    for (Course course : courses) { 
                        String defaultImage = "/Adaptive_Elearning/assets/images/course-default.jpg";
                        String courseImage = (course.getThumbUrl() != null && !course.getThumbUrl().isEmpty()) 
                                           ? course.getThumbUrl() : defaultImage;
                %>
                    <article class="course-card" data-course-id="<%= course.getId() %>" style="cursor: pointer;">
                        <div class="course-image">
                            <img data-src="<%= courseImage %>" 
                                 alt="<%= course.getTitle() %>" 
                                 loading="lazy">
                            <div class="course-category">
                                <%= course.getLevel() != null ? course.getLevel() : "Chung" %>
                            </div>
                        </div>
                        
                        <div class="course-content">
                            <h3 class="course-title"><%= course.getTitle() %></h3>
                            <p class="course-description">
                                Khóa học chất lượng cao với nội dung được thiết kế bởi <%= course.getInstructorName() != null ? course.getInstructorName() : "chuyên gia" %>. 
                                Phù hợp cho người học ở mức độ <%= course.getLevel() != null ? course.getLevel().toLowerCase() : "mọi cấp độ" %>.
                            </p>
                            
                            <div class="course-meta">
                                <span class="meta-item">
                                    <i class="fas fa-star"></i>
                                    <%= String.format("%.1f", course.getAverageRating()) %> (<%= course.getRatingCount() %> đánh giá)
                                </span>
                                <span class="meta-item">
                                    <i class="fas fa-clock"></i>
                                    <%= course.getLevel() %> level
                                </span>
                                <span class="meta-item">
                                    <i class="fas fa-users"></i>
                                    <%= course.getLearnerCount() %> học viên
                                </span>
                            </div>
                            
                            <div class="course-footer">
                                <div class="course-price-wrapper">
                                    <% if (course.getPrice() > 0) { %>
                                        <span class="course-price">
                                            <%= course.getFormattedPrice() %>
                                        </span>
                                    <% } else { %>
                                        <span class="course-price free">Miễn phí</span>
                                    <% } %>
                                </div>
                                
                                <div class="course-actions">
                                    <% if (u != null) { %>
                                        <button class="add-to-cart-btn" 
                                                data-course-id="<%= course.getId() %>"
                                                type="button">
                                            <i class="fas fa-cart-plus"></i>
                                            Thêm vào giỏ
                                        </button>
                                    <% } else { %>
                                        <a href="/Adaptive_Elearning/login" class="enroll-btn">
                                            <i class="fas fa-play"></i>
                                            Đăng ký học
                                        </a>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </article>
                <% } 
                } else { %>
                    <div class="empty-state">
                        <div class="empty-icon">📚</div>
                        <h3>
                            <%= !search.isEmpty() ? "Không tìm thấy khóa học nào" : "Chưa có khóa học nào" %>
                        </h3>
                        <p>
                            <%= !search.isEmpty() ? 
                                "Thử tìm kiếm với từ khóa khác hoặc xem tất cả khóa học" : 
                                "Hệ thống đang cập nhật thêm khóa học mới. Vui lòng quay lại sau!" %>
                        </p>
                        <% if (!search.isEmpty()) { %>
                            <a href="/Adaptive_Elearning/" class="explore-btn">
                                Xem tất cả khóa học
                            </a>
                        <% } else { %>
                            <button class="explore-btn" onclick="window.location.reload()">
                                Tải lại trang
                            </button>
                        <% } %>
                    </div>
                <% } %>
            </div>
            
            <!-- Pagination -->
            <% if (totalPages > 1) { %>
                <div class="pagination-wrapper">
                    <div class="pagination">
                        <% if (currentPage > 1) { %>
                            <a href="?page=<%= currentPage - 1 %><%= !search.isEmpty() ? "&search=" + java.net.URLEncoder.encode(search, "UTF-8") : "" %>" 
                               class="page-btn">
                               <i class="fas fa-chevron-left"></i> Trước
                            </a>
                        <% } %>
                        
                        <% 
                        int startPage = Math.max(1, currentPage - 2);
                        int endPage = Math.min(totalPages, currentPage + 2);
                        
                        for (int i = startPage; i <= endPage; i++) { %>
                            <a href="?page=<%= i %><%= !search.isEmpty() ? "&search=" + java.net.URLEncoder.encode(search, "UTF-8") : "" %>" 
                               class="page-number <%= (i == currentPage) ? "active" : "" %>">
                               <%= i %>
                            </a>
                        <% } %>
                        
                        <% if (currentPage < totalPages) { %>
                            <a href="?page=<%= currentPage + 1 %><%= !search.isEmpty() ? "&search=" + java.net.URLEncoder.encode(search, "UTF-8") : "" %>" 
                               class="page-btn">
                               Sau <i class="fas fa-chevron-right"></i>
                            </a>
                        <% } %>
                    </div>
                    
                    <div class="pagination-info">
                        Trang <%= currentPage %> / <%= totalPages %> 
                        (Tổng cộng <%= totalCourses %> khóa học)
                    </div>
                </div>
            <% } %>
        </div>
    </section>

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
    <script src="/Adaptive_Elearning/assets/js/home.js"></script>
    
    <!-- Lazy loading fallback for older browsers -->
    <script>
        // Fallback for browsers without IntersectionObserver
        if (!('IntersectionObserver' in window)) {
            document.querySelectorAll('img[data-src]').forEach(img => {
                img.src = img.dataset.src;
            });
        }
        
        // Update cart count on page load
        document.addEventListener('DOMContentLoaded', function() {
            if (window.cartManager) {
                window.cartManager.updateCartBadge();
            }
            
            // Auto-dismiss alerts after 5 seconds
            setTimeout(() => {
                const alerts = document.querySelectorAll('.alert-message');
                alerts.forEach(alert => {
                    if (alert) {
                        alert.style.transition = 'opacity 0.5s ease-out';
                        alert.style.opacity = '0';
                        setTimeout(() => alert.remove(), 500);
                    }
                });
            }, 5000);
        });
        
        // Function to close alert manually
        function closeAlert(alertId) {
            const alert = document.getElementById(alertId);
            if (alert) {
                alert.style.transition = 'opacity 0.3s ease-out';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 300);
            }
        }

        // Debug: Test course card click
        console.log('Course cards found:', document.querySelectorAll('.course-card').length);
        document.querySelectorAll('.course-card').forEach((card, index) => {
            console.log(`Card ${index}:`, {
                hasCourseId: card.hasAttribute('data-course-id'),
                courseId: card.getAttribute('data-course-id'),
                cursor: window.getComputedStyle(card).cursor
            });
        });}
    </script>

    <!-- Gemini  Toggle Button & Popup -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@48,400,1,0">
    <style>
        #chatbot-toggler {position: fixed;bottom: 30px;right: 35px;border: none;height: 50px;width: 50px;display: flex;cursor: pointer;align-items: center;justify-content: center;border-radius: 50%;background: #1E90FF;box-shadow: 0 0 20px rgba(0,0,0,0.1);transition: all 0.2s ease;z-index:9999;}
        body.show-chatbot #chatbot-toggler {transform: rotate(90deg);}
        #chatbot-toggler span {color: #fff;position: absolute;}
        #chatbot-toggler span:last-child,body.show-chatbot #chatbot-toggler span:first-child {opacity: 0;}
        body.show-chatbot #chatbot-toggler span:last-child {opacity: 1;}
        .chatbot-popup {position: fixed;right: 35px;bottom: 90px;width: 420px;overflow: hidden;background: #fff;border-radius: 15px;opacity: 0;pointer-events: none;transform: scale(0.2);transform-origin: bottom right;box-shadow: 0 0 128px 0 rgba(0,0,0,0.1),0 32px 64px -48px rgba(0,0,0,0.5);transition: all 0.1s ease;z-index:9999;}
        body.show-chatbot .chatbot-popup {opacity: 1;pointer-events: auto;transform: scale(1);}
        .chat-header {display: flex;align-items: center;padding: 15px 22px;background: #1E90FF;justify-content: space-between;}
        .chat-header .header-info {display: flex;gap: 10px;align-items: center;}
        .header-info .chatbot-logo {width: 35px;height: 35px;padding: 6px;fill: #1E90FF;flex-shrink: 0;background: #fff;border-radius: 50%;}
        .header-info .logo-text {color: #fff;font-weight: 600;font-size: 1.31rem;letter-spacing: 0.02rem;}
        .chat-header #close-chatbot {border: none;color: #fff;height: 40px;width: 40px;font-size: 1.9rem;margin-right: -10px;padding-top: 2px;cursor: pointer;border-radius: 50%;background: none;transition: 0.2s ease;}
        .chat-header #close-chatbot:hover {background: #4169E1;}
        .chat-body {padding: 25px 22px;gap: 20px;display: flex;height: 460px;overflow-y: auto;margin-bottom: 82px;flex-direction: column;scrollbar-width: thin;scrollbar-color: #F0FFFF transparent;}
        .chat-body:hover {scrollbar-color: #F0FFFF transparent;}
        .chat-body .message {display: flex;gap: 11px;align-items: center;}
        .chat-body .message .bot-avatar {width: 35px;height: 35px;padding: 6px;fill: #fff;flex-shrink: 0;margin-bottom: 2px;align-self: flex-end;border-radius: 50%;background: #1E90FF;}
        .chat-body .message .message-text {padding: 12px 16px;max-width: 75%;font-size: 0.95rem;}
        .chat-body .bot-message.thinking .message-text {padding: 2px 16px;}
        .chat-body .bot-message .message-text {background: #F2F2FF;border-radius: 13px 13px 13px 3px;}
        .chat-body .user-message {flex-direction: column;align-items: flex-end;}
        .chat-body .user-message .message-text {color: #fff;background: #1E90FF;border-radius: 13px 13px 3px 13px;}
        .chat-body .user-message .attachment {width: 50%;margin-top: -7px;border-radius: 13px 3px 13px 13px;}
        .chat-body .bot-message .thinking-indicator {display: flex;gap: 4px;padding-block: 15px;}
        .chat-body .bot-message .thinking-indicator .dot {height: 7px;width: 7px;opacity: 0.7;border-radius: 50%;background: #6F6BC2;animation: dotPulse 1.8s ease-in-out infinite;}
        .chat-body .bot-message .thinking-indicator .dot:nth-child(1) {animation-delay: 0.2s;}
        .chat-body .bot-message .thinking-indicator .dot:nth-child(2) {animation-delay: 0.3s;}
        .chat-body .bot-message .thinking-indicator .dot:nth-child(3) {animation-delay: 0.4s;}
        @keyframes dotPulse {0%, 44% {transform: translateY(0);}28% {opacity: 0.4;transform: translateY(-4px);}44% {opacity: 0.2;}}
        .chat-footer {position: absolute;bottom: 0;width: 100%;background: #fff;padding: 15px 22px 20px;}
        .chat-footer .chat-form {display: flex;align-items: center;position: relative;background: #fff;border-radius: 32px;outline: 1px solid #CCCCE5;box-shadow: 0 0 8px rgba(0,0,0,0.06);transition: 0s ease,border-radius 0s;}
        .chat-form:focus-within {outline: 2px solid #1E90FF;}
        .chat-form .message-input {width: 100%;height: 47px;outline: none;resize: none;border: none;max-height: 180px;scrollbar-width: thin;border-radius: inherit;font-size: 0.95rem;padding: 14px 0 12px 18px;scrollbar-color: transparent transparent;}
        .chat-form .message-input:hover {scrollbar-color: #F0FFFF transparent;}
        .chat-form .chat-controls {gap: 3px;height: 47px;display: flex;padding-right: 6px;align-items: center;align-self: flex-end;}
        .chat-form .chat-controls button {height: 35px;width: 35px;border: none;cursor: pointer;color: #706DB0;border-radius: 50%;font-size: 1.15rem;background: none;transition: 0.2s ease;}
        .chat-form .chat-controls button:hover,body.show-emoji-picker .chat-controls #emoji-picker {color: #4169E1;background: #f1f1ff;}
        .chat-form .chat-controls #send-message {color: #fff;display: none;background: #1E90FF;}
        .chat-form .chat-controls #send-message:hover {background: #4169E1;}
        .chat-form .message-input:valid~.chat-controls #send-message {display: block;}
        .chat-form .file-upload-wrapper {position: relative;height: 35px;width: 35px;}
        .chat-form .file-upload-wrapper :where(button,img) {position: absolute;}
        .chat-form .file-upload-wrapper img {height: 100%;width: 100%;object-fit: cover;border-radius: 50%;}
        .chat-form .file-upload-wrapper #file-cancel {color: #ff0000;background: #fff;}
        .chat-form .file-upload-wrapper :where(img,#file-cancel),.chat-form .file-upload-wrapper.file-uploaded #file-upload {display: none;}
        .chat-form .file-upload-wrapper.file-uploaded img,.chat-form .file-upload-wrapper.file-uploaded:hover #file-cancel {display: block;}
        em-emoji-picker {position: absolute;left: 50%;top: -337px;width: 100%;max-width: 350px;visibility: hidden;max-height: 330px;transform: translateX(-50%);}
        body.show-emoji-picker em-emoji-picker {visibility: visible;}
        @media (max-width: 520px) {
            #chatbot-toggler {right: 20px;bottom: 20px;}
            .chatbot-popup {right: 0;bottom: 0;height: 100%;border-radius: 0;width: 100%;}
            .chatbot-popup .chat-header {padding: 12px 15px;}
            .chat-body {height: calc(90% - 55px);padding: 25px 15px;}
            .chat-footer {padding: 10px 15px 15px;}
            .chat-form .file-upload-wrapper.file-uploaded #file-cancel {opacity: 0;}
        }
    </style>
    <button id="chatbot-toggler">
        <span class="material-symbols-rounded">mode_comment</span>
        <span class="material-symbols-rounded">close</span>
    </button>
    <div class="chatbot-popup">
        <div class="chat-header">
            <div class="header-info">
                <svg class="chatbot-logo" xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 1024 1024"><path d="M738.3 287.6H285.7c-59 0-106.8 47.8-106.8 106.8v303.1c0 59 47.8 106.8 106.8 106.8h81.5v111.1c0 .7.8 1.1 1.4.7l166.9-110.6 41.8-.8h117.4l43.6-.4c59 0 106.8-47.8 106.8-106.8V394.5c0-59-47.8-106.9-106.8-106.9zM351.7 448.2c0-29.5 23.9-53.5 53.5-53.5s53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5-53.5-23.9-53.5-53.5zm157.9 267.1c-67.8 0-123.8-47.5-132.3-109h264.6c-8.6 61.5-64.5 109-132.3 109zm110-213.7c-29.5 0-53.5-23.9-53.5-53.5s23.9-53.5 53.5-53.5 53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5zM867.2 644.5V453.1h26.5c19.4 0 35.1 15.7 35.1 35.1v121.1c0 19.4-15.7 35.1-35.1 35.1h-26.5zM95.2 609.4V488.2c0-19.4 15.7-35.1 35.1-35.1h26.5v191.3h-26.5c-19.4 0-35.1-15.7-35.1-35.1zM561.5 149.6c0 23.4-15.6 43.3-36.9 49.7v44.9h-30v-44.9c-21.4-6.5-36.9-26.3-36.9-49.7 0-28.6 23.3-51.9 51.9-51.9s51.9 23.3 51.9 51.9z"/></svg>
                <h2 class="logo-text">Chatbot</h2>
            </div>
            <button id="close-chatbot" class="material-symbols-rounded">keyboard_arrow_down</button>
        </div>
        <div class="chat-body">
            <div class="message bot-message">
                <svg class="bot-avatar" xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 1024 1024"><path d="M738.3 287.6H285.7c-59 0-106.8 47.8-106.8 106.8v303.1c0 59 47.8 106.8 106.8 106.8h81.5v111.1c0 .7.8 1.1 1.4.7l166.9-110.6 41.8-.8h117.4l43.6-.4c59 0 106.8-47.8 106.8-106.8V394.5c0-59-47.8-106.9-106.8-106.9zM351.7 448.2c0-29.5 23.9-53.5 53.5-53.5s53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5-53.5-23.9-53.5-53.5zm157.9 267.1c-67.8 0-123.8-47.5-132.3-109h264.6c-8.6 61.5-64.5 109-132.3 109zm110-213.7c-29.5 0-53.5-23.9-53.5-53.5s23.9-53.5 53.5-53.5 53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5zM867.2 644.5V453.1h26.5c19.4 0 35.1 15.7 35.1 35.1v121.1c0 19.4-15.7 35.1-35.1 35.1h-26.5zM95.2 609.4V488.2c0-19.4 15.7-35.1 35.1-35.1h26.5v191.3h-26.5c-19.4 0-35.1-15.7-35.1-35.1zM561.5 149.6c0 23.4-15.6 43.3-36.9 49.7v44.9h-30v-44.9c-21.4-6.5-36.9-26.3-36.9-49.7 0-28.6 23.3-51.9 51.9-51.9s51.9 23.3 51.9 51.9z"/></svg>
                <div class="message-text">Xin chào 👋<br /> Tôi có thể giúp gì cho bạn hôm nay?</div>
            </div>
        </div>
        <div class="chat-footer">
            <form action="#" class="chat-form">
                <textarea placeholder="Message..." class="message-input" required></textarea>
                <div class="chat-controls">
                    <button type="button" id="emoji-picker" class="material-symbols-outlined">sentiment_satisfied</button>
                    <div class="file-upload-wrapper">
                        <input type="file" id="file-input" accept="image/*" hidden />
                        <img src="#" />
                        <button type="button" id="file-upload" class="material-symbols-rounded">attach_file</button>
                        <button type="button" id="file-cancel" class="material-symbols-rounded">close</button>
                    </div>
                    <button type="submit" id="send-message" class="material-symbols-rounded">arrow_upward</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Emoji Picker CDN -->
    <script type="module" src="https://cdn.jsdelivr.net/npm/emoji-mart@latest/dist/browser.js"></script>
    
    <script>
    // Gemini Chatbot JS - Full Implementation
    document.addEventListener('DOMContentLoaded', function() {
    const chatBody = document.querySelector(".chat-body");
    const messageInput = document.querySelector(".message-input");
    const sendMessageButton = document.querySelector("#send-message");
    const fileInput = document.querySelector("#file-input");
    const fileUploadWrapper = document.querySelector(".file-upload-wrapper");
    const fileCancelButton = document.querySelector("#file-cancel");
    const chatbotToggler = document.querySelector("#chatbot-toggler");
    const closeChatbot = document.querySelector("#close-chatbot");
    
    // API setup
    const API_KEY = "AIzaSyAi6pOLY_Rmv2_8mVfuLmaPMowD8Qkai-s";
    const API_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\${API_KEY}`;
    
    const userData = {
        message: null,
        file: {
            data: null,
            mime_type: null
        }
    };
    
    const chatHistory = [];
    const initialInputHeight = messageInput.scrollHeight;
    
    // Create message element with dynamic classes and return it
    const createMessageElement = (content, ...classes) => {
        const div = document.createElement("div");
        div.classList.add("message", ...classes);
        div.innerHTML = content;
        return div;
    };
    
    // Generate bot response using API
    const generateBotResponse = async (incomingMessageDiv) => {
        const messageElement = incomingMessageDiv.querySelector(".message-text");
        
        chatHistory.push({
            role: "user",
            parts: [{ text: userData.message }, ...(userData.file.data ? [{ inline_data: userData.file }] : [])],
        });
        
        // API request options
        const requestOptions = {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                contents: chatHistory
            })
        }
    
        try {
            // Fetch bot response from API
            const response = await fetch(API_URL, requestOptions);
            const data = await response.json();
            if (!response.ok) throw new Error(data.error.message);
    
            // Extract and display bot's response text
            const apiResponseText = data.candidates[0].content.parts[0].text.replace(/\*\*(.*?)\*\*/g, "$1").trim();
            messageElement.innerText = apiResponseText;
            chatHistory.push({
                role: "model",
                parts: [{ text: apiResponseText }]
            });
        } catch (error) {
            messageElement.innerText = error.message;
            messageElement.style.color = "#ff0000";
        } finally {
            userData.file = {};
            incomingMessageDiv.classList.remove("thinking");
            chatBody.scrollTo({ behavior: "smooth", top: chatBody.scrollHeight });
        }
    };
    
    // Handle outgoing user message
    const handleOutgoingMessage = (e) => {
        e.preventDefault();
        userData.message = messageInput.value.trim();
        messageInput.value = "";
        fileUploadWrapper.classList.remove("file-uploaded");
        messageInput.dispatchEvent(new Event("input"));
    
        // Create and display user message
        const messageContent = `<div class="message-text"></div>
                                \${userData.file.data ? `<img src="data:\${userData.file.mime_type};base64,\${userData.file.data}" class="attachment" />` : ""}`;
    
        const outgoingMessageDiv = createMessageElement(messageContent, "user-message");
        outgoingMessageDiv.querySelector(".message-text").innerText = userData.message;
        chatBody.appendChild(outgoingMessageDiv);
        chatBody.scrollTop = chatBody.scrollHeight;
    
        // Simulate bot response with thinking indicator after a delay
        setTimeout(() => {
            const messageContent = `<svg class="bot-avatar" xmlns="http://www.w3.org/2000/svg" width="50" height="50" viewBox="0 0 1024 1024">
                        <path d="M738.3 287.6H285.7c-59 0-106.8 47.8-106.8 106.8v303.1c0 59 47.8 106.8 106.8 106.8h81.5v111.1c0 .7.8 1.1 1.4.7l166.9-110.6 41.8-.8h117.4l43.6-.4c59 0 106.8-47.8 106.8-106.8V394.5c0-59-47.8-106.9-106.8-106.9zM351.7 448.2c0-29.5 23.9-53.5 53.5-53.5s53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5-53.5-23.9-53.5-53.5zm157.9 267.1c-67.8 0-123.8-47.5-132.3-109h264.6c-8.6 61.5-64.5 109-132.3 109zm110-213.7c-29.5 0-53.5-23.9-53.5-53.5s23.9-53.5 53.5-53.5 53.5 23.9 53.5 53.5-23.9 53.5-53.5 53.5zM867.2 644.5V453.1h26.5c19.4 0 35.1 15.7 35.1 35.1v121.1c0 19.4-15.7 35.1-35.1 35.1h-26.5zM95.2 609.4V488.2c0-19.4 15.7-35.1 35.1-35.1h26.5v191.3h-26.5c-19.4 0-35.1-15.7-35.1-35.1zM561.5 149.6c0 23.4-15.6 43.3-36.9 49.7v44.9h-30v-44.9c-21.4-6.5-36.9-26.3-36.9-49.7 0-28.6 23.3-51.9 51.9-51.9s51.9 23.3 51.9 51.9z"></path>
                    </svg>
                    <div class="message-text">
                        <div class="thinking-indicator">
                            <div class="dot"></div>
                            <div class="dot"></div>
                            <div class="dot"></div>
                        </div>
                    </div>`;
    
            const incomingMessageDiv = createMessageElement(messageContent, "bot-message", "thinking");
            chatBody.appendChild(incomingMessageDiv);
            chatBody.scrollTo({ behavior: "smooth", top: chatBody.scrollHeight });
            generateBotResponse(incomingMessageDiv);
        }, 600);
    };
    
    // Handle Enter key press for sending messages
    messageInput.addEventListener("keydown", (e) => {
        const userMessage = e.target.value.trim();
        if (e.key === "Enter" && userMessage && !e.shiftKey && window.innerWidth > 768) {
            handleOutgoingMessage(e);
        }
    });
    
    // Auto-resize textarea
    messageInput.addEventListener("input", () => {
        messageInput.style.height = `${initialInputHeight}px`;
        messageInput.style.height = `${messageInput.scrollHeight}px`;
        document.querySelector(".chat-form").style.borderRadius = messageInput.scrollHeight > initialInputHeight ? "15px" : "32px";
    });
    
    // Handle file input change event
    fileInput.addEventListener("change", (e) => {
        const file = e.target.files[0];
        if (!file) return;
        
        const reader = new FileReader();
        reader.onload = (e) => {
            fileUploadWrapper.querySelector("img").src = e.target.result;
            fileUploadWrapper.classList.add("file-uploaded");
            const base64String = e.target.result.split(",")[1];
    
            // Store file data in userData
            userData.file = {
                data: base64String,
                mime_type: file.type
            };
            
            fileInput.value = ""; 
        };
    
        reader.readAsDataURL(file);
    });
    
    // Cancel file upload
    fileCancelButton.addEventListener("click", () => {
        userData.file = {};
        fileUploadWrapper.classList.remove("file-uploaded");
    });
    
    // Emoji Picker Setup
    const pickerOptions = {
        onEmojiSelect: (emoji) => {
            const { selectionStart: start, selectionEnd: end } = messageInput;
            messageInput.setRangeText(emoji.native, start, end, "end");
            messageInput.focus();
        },
        onClickOutside: (e) => {
            if (e.target.id === "emoji-picker") {
                document.body.classList.toggle("show-emoji-picker");
            } else {
                document.body.classList.remove("show-emoji-picker");
            }
        }
    };
    
    const picker = new EmojiMart.Picker(pickerOptions);
    document.querySelector(".chat-form").appendChild(picker);
    
    // Event listeners
    sendMessageButton.addEventListener("click", (e) => handleOutgoingMessage(e));
    document.querySelector("#file-upload").addEventListener("click", () => fileInput.click());
    chatbotToggler.addEventListener("click", () => document.body.classList.toggle("show-chatbot"));
    closeChatbot.addEventListener("click", () => document.body.classList.remove("show-chatbot"));
    }); // End DOMContentLoaded
    </script>
</body>
</html>