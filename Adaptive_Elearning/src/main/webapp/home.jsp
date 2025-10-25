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
    <title>EduHub - Học mọi lúc, mọi nơi</title>
    <meta name="description" content="EduHub - Khám phá hàng nghìn khóa học chất lượng cao từ các chuyên gia hàng đầu. Học mọi lúc, mọi nơi với chi phí hợp lý.">
    <meta name="keywords" content="học trực tuyến, khóa học online, giáo dục, kỹ năng, công nghệ">
    
    <!-- Preload critical resources -->
    <link rel="preload" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" as="style">
    <link rel="preload" href="/Adaptive_Elearning/assets/css/home.css" as="style">
    <link rel="preload" href="/Adaptive_Elearning/assets/js/home.js" as="script">
    
    <!-- CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/Adaptive_Elearning/assets/css/home.css">
    
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
                    <a href="/Adaptive_Elearning/" class="nav-link active">Trang chủ</a>
                    <a href="/Adaptive_Elearning/courses" class="nav-link">Khóa học</a>
                    <% if (u != null) { %>
                        <a href="/Adaptive_Elearning/my-courses" class="nav-link">Khóa học của tôi</a>
                    <% } %>
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
                                <div class="dropdown-header">
                                    <div class="user-details">
                                        <% if (u.getAvatarUrl() != null && !u.getAvatarUrl().isEmpty()) { %>
                                            <img src="<%= u.getAvatarUrl() %>" alt="Avatar" class="dropdown-avatar">
                                        <% } else { %>
                                            <div class="dropdown-avatar-placeholder">
                                                <i class="fas fa-user-circle"></i>
                                            </div>
                                        <% } %>
                                        <div class="user-text">
                                            <div class="user-fullname"><%= u.getUserName() %></div>
                                            <div class="user-email"><%= u.getEmail() %></div>
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
                                    <a href="/Adaptive_Elearning/login" class="dropdown-item logout-item">
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
                    <article class="course-card">
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
                    <h3>EduHub</h3>
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
            
            <div style="text-align: center; padding-top: 2rem; border-top: 1px solid #374151;">
                <p>&copy; 2024 EduHub. Tất cả quyền được bảo lưu.</p>
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
        });
    </script>
</body>
</html>