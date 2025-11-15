<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="servlet.MyCoursesServlet.CourseEnrollmentInfo"%>
<%@page import="servlet.MyCoursesServlet.CourseStats"%>
<%@page import="java.util.List"%>
<%@page import="model.Users"%>

<%
    Users user = null;
    int cartCount = 0;
    if (session != null) {
        user = (Users) session.getAttribute("account");
        // Lấy số lượng giỏ hàng từ session
        java.util.Map<String, model.CartItem> cart
                = (java.util.Map<String, model.CartItem>) session.getAttribute("cart");
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
        <title>Khóa Học Của Tôi - FlyUp</title>
        <meta name="description" content="Quản lý và theo dõi tiến trình học tập của bạn trên FlyUp">

        <!-- CSS -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="/Adaptive_Elearning/assets/css/home.css">

        <style>
            /* Custom styles for my-courses page */
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
                --secondary-50: #f9fafb;
                --secondary-100: #f3f4f6;
                --secondary-200: #e5e7eb;
                --secondary-300: #d1d5db;
                --secondary-400: #9ca3af;
                --secondary-500: #6b7280;
                --secondary-600: #4b5563;
                --secondary-700: #374151;
                --secondary-800: #1f2937;
                --secondary-900: #111827;
                --success-50: #f0fdf4;
                --success-500: #22c55e;
                --success-700: #15803d;
                --warning-50: #fefce8;
                --warning-500: #eab308;
                --warning-700: #a16207;
                --danger-50: #fef2f2;
                --danger-500: #ef4444;
                --danger-700: #b91c1c;
                --radius-sm: 0.375rem;
                --radius-md: 0.5rem;
                --radius-lg: 1rem;
                --radius-xl: 1.5rem;
                --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
                --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
                --gradient-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                --gradient-success: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                --animate-duration: 0.3s;
            }

            body {
                background: #f8f9fa;
                font-family: 'Inter', sans-serif;
            }

            /* Page Header */
            .page-header {
                background: #ff9e4f;
                color: white;
                padding: 4rem 0 3rem;
                margin-bottom: 3rem;
            }

            .page-header h1 {
                font-size: 2.5rem;
                font-weight: 800;
                margin-bottom: 1rem;
            }

            .page-header p {
                font-size: 1.125rem;
                opacity: 0.95;
            }

            /* Success Alert */
            .success-alert {
                background: var(--success-50);
                border-left: 4px solid var(--success-500);
                padding: 1.5rem;
                margin-bottom: 2rem;
                border-radius: var(--radius-lg);
                animation: slideInDown 0.5s ease-out;
            }

            .success-alert h5 {
                color: var(--success-700);
                font-weight: 600;
                margin-bottom: 0.5rem;
            }

            .success-alert p {
                color: var(--success-700);
                margin: 0;
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

            /* Stats Section */
            .stats-section {
                background: #fac601;
                color: white;
                padding: 2.5rem;
                border-radius: var(--radius-xl);
                margin-bottom: 3rem;
                box-shadow: var(--shadow-xl);
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 2rem;
                text-align: center;
            }

            .stat-item {
                padding: 1rem;
            }

            .stat-number {
                font-size: 3rem;
                font-weight: 800;
                display: block;
                margin-bottom: 0.5rem;
                text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .stat-label {
                font-size: 1rem;
                opacity: 0.95;
                font-weight: 500;
            }

            /* Courses Grid */
            .courses-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
                gap: 2rem;
                margin-bottom: 3rem;
            }

            /* Course Card */
            .course-card {
                background: white;
                border-radius: var(--radius-xl);
                overflow: hidden;
                box-shadow: var(--shadow-md);
                transition: all var(--animate-duration);
                height: 100%;
                display: flex;
                flex-direction: column;
            }

            .course-card:hover {
                transform: translateY(-8px);
                box-shadow: var(--shadow-xl);
            }

            .course-thumbnail-wrapper {
                position: relative;
                height: 220px;
                overflow: hidden;
                background: linear-gradient(135deg, var(--primary-100) 0%, var(--secondary-100) 100%);
            }

            .course-thumbnail {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.5s ease;
            }

            .course-card:hover .course-thumbnail {
                transform: scale(1.05);
            }

            .course-badge {
                position: absolute;
                top: 1rem;
                right: 1rem;
                background: rgba(255, 255, 255, 0.95);
                color: var(--primary-600);
                padding: 0.5rem 1rem;
                border-radius: var(--radius-md);
                font-size: 0.875rem;
                font-weight: 600;
                backdrop-filter: blur(10px);
            }

            .progress-overlay {
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
                padding: 1.5rem 1rem 1rem;
            }

            .progress-bar-wrapper {
                background: rgba(255, 255, 255, 0.2);
                height: 8px;
                border-radius: 10px;
                overflow: hidden;
                margin-bottom: 0.5rem;
            }

            .progress-bar-fill {
                height: 100%;
                background: linear-gradient(90deg, #10b981, #34d399);
                border-radius: 10px;
                transition: width 1s ease;
            }

            .progress-text {
                color: white;
                font-size: 0.875rem;
                font-weight: 600;
            }

            .course-content {
                padding: 1.5rem;
                flex: 1;
                display: flex;
                flex-direction: column;
            }

            .course-title {
                font-size: 1.25rem;
                font-weight: 700;
                color: var(--secondary-900);
                margin-bottom: 1rem;
                line-height: 1.4;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .course-meta {
                margin-bottom: 1rem;
                padding-bottom: 1rem;
                border-bottom: 1px solid var(--secondary-200);
            }

            .meta-item {
                display: flex;
                align-items: center;
                gap: 0.5rem;
                color: var(--secondary-600);
                font-size: 0.875rem;
                margin-bottom: 0.5rem;
            }

            .meta-item i {
                color: var(--primary-500);
                width: 16px;
            }

            .course-price {
                color: var(--primary-600);
                font-weight: 700;
                font-size: 1.125rem;
            }

            .course-status {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.5rem 1rem;
                border-radius: var(--radius-md);
                font-size: 0.875rem;
                font-weight: 600;
                margin-top: 0.5rem;
            }

            .status-active {
                background: var(--success-50);
                color: var(--success-700);
            }

            .status-completed {
                background: var(--primary-50);
                color: var(--primary-700);
            }

            .status-pending {
                background: var(--warning-50);
                color: var(--warning-700);
            }

            .course-actions {
                margin-top: auto;
                padding-top: 1rem;
            }

            .btn-continue {
                display: block;
                width: 100%;
                background: #92da62;
                color: white;
                padding: 0.875rem 1.5rem;
                border-radius: var(--radius-md);
                text-align: center;
                text-decoration: none;
                font-weight: 600;
                transition: all var(--animate-duration);
                border: none;
            }

            .btn-continue:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
                color: white;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 5rem 2rem;
                background: white;
                border-radius: var(--radius-xl);
                box-shadow: var(--shadow-md);
            }

            .empty-state-icon {
                font-size: 5rem;
                color: var(--secondary-300);
                margin-bottom: 2rem;
            }

            .empty-state h3 {
                font-size: 1.875rem;
                font-weight: 700;
                color: var(--secondary-900);
                margin-bottom: 1rem;
            }

            .empty-state p {
                font-size: 1.125rem;
                color: var(--secondary-600);
                margin-bottom: 2rem;
                max-width: 500px;
                margin-left: auto;
                margin-right: auto;
            }

            .btn-explore {
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                background: var(--gradient-primary);
                color: white;
                padding: 1rem 2rem;
                border-radius: var(--radius-md);
                text-decoration: none;
                font-weight: 600;
                font-size: 1.125rem;
                transition: all var(--animate-duration);
            }

            .btn-explore:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
                color: white;
            }

            /* Container */
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 1rem;
            }

            /* Fix dropdown menu display */
            .dropdown-menu.show {
                opacity: 1;
                visibility: visible;
                transform: translateY(0);
            }

            /* Responsive */
            @media (max-width: 768px) {
                .page-header h1 {
                    font-size: 2rem;
                }

                .stats-grid {
                    grid-template-columns: repeat(2, 1fr);
                    gap: 1rem;
                }

                .stat-number {
                    font-size: 2rem;
                }

                .courses-grid {
                    grid-template-columns: 1fr;
                    gap: 1.5rem;
                }

                .course-thumbnail-wrapper {
                    height: 180px;
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
                        <a href="/Adaptive_Elearning/contact" class="nav-link">Liên hệ</a>
                    </div>

                    <div class="nav-actions">
                        <% if (user != null) { %>
                        <a href="/Adaptive_Elearning/cart" class="cart-link">
                            <div class="cart-icon">
                                <i class="fas fa-shopping-cart"></i>
                                <span class="cart-badge" <% if (cartCount == 0) { %>style="display: none;"<% }%>><%= cartCount%></span>
                            </div>
                        </a>
                        <% }%>
                        <%-- User Dropdown Menu with Role-Based Access (includes login/register buttons) --%>
                        <%@ include file="/WEB-INF/includes/user-dropdown.jsp" %>
                    </div>
                </nav>
            </div>
        </header>

        <!-- Success Message -->
        <c:if test="${showSuccessMessage}">
            <div class="container" style="padding-top: 2rem;">
                <div class="success-alert">
                    <div style="display: flex; align-items: center; gap: 1rem;">
                        <i class="fas fa-check-circle" style="font-size: 2rem; color: var(--success-500);"></i>
                        <div style="flex: 1;">
                            <h5>🎉 Chúc mừng! Thanh toán thành công!</h5>
                            <p>${successMessage}</p>
                            <small style="color: var(--success-700);">
                                <i class="fas fa-info-circle"></i>
                                Các khóa học đã được thêm vĩnh viễn vào tài khoản của bạn
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Page Header -->
        <div class="page-header">
            <div class="container">
                <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 2rem;">
                    <div>
                        <h1>
                            <i class="fas fa-book-open" style="margin-right: 1rem;"></i>Khóa Học Của Tôi
                        </h1>
                        <p style="margin: 0; font-size: 1.125rem;">Quản lý và theo dõi tiến trình học tập của bạn</p>
                    </div>
                    <div>
                        <a href="/Adaptive_Elearning/" class="btn-explore" style="background: white; color: #1f2937;">
                            <i class="fas fa-search"></i>
                            Khám phá thêm
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="container" style="padding-bottom: 4rem;">
            <!-- Statistics -->
            <c:if test="${courseStats != null}">
                <div class="stats-section">
                    <div class="stats-grid">
                        <div class="stat-item">
                            <span class="stat-number">${courseStats.totalCourses}</span>
                            <span class="stat-label">Tổng khóa học</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number">${courseStats.completedCourses}</span>
                            <span class="stat-label">Đã hoàn thành</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number">${courseStats.inProgressCourses}</span>
                            <span class="stat-label">Đang học</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number">${courseStats.totalHours}</span>
                            <span class="stat-label">Giờ học</span>
                        </div>
                    </div>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty enrolledCourses}">
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-book-open"></i>
                        </div>
                        <h3>Chưa có khóa học nào</h3>
                        <p>Bạn chưa đăng ký khóa học nào. Hãy khám phá và tìm kiếm những khóa học phù hợp!</p>
                        <a href="/Adaptive_Elearning/" class="btn-explore">
                            <i class="fas fa-search"></i>
                            Khám phá khóa học
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="courses-grid">
                        <c:forEach var="courseInfo" items="${enrolledCourses}">
                            <div class="course-card">
                                <!-- Course Thumbnail -->
                                <div class="course-thumbnail-wrapper">
                                    <c:choose>
                                        <c:when test="${not empty courseInfo.course.thumbUrl}">
                                            <img src="${courseInfo.course.thumbUrl}" 
                                                 class="course-thumbnail" 
                                                 alt="${courseInfo.course.title}"
                                                 onerror="this.src='/Adaptive_Elearning/assets/images/default-course.jpg'">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="/Adaptive_Elearning/assets/images/default-course.jpg" 
                                                 class="course-thumbnail" 
                                                 alt="Default Course Image">
                                        </c:otherwise>
                                    </c:choose>

                                    <div class="course-badge">
                                        <i class="fas fa-layer-group"></i>
                                        ${courseInfo.course.level != null ? courseInfo.course.level : 'Cơ bản'}
                                    </div>

                                    <!-- Progress Overlay -->
                                    <div class="progress-overlay">
                                        <div class="progress-bar-wrapper">
                                            <div class="progress-bar-fill" 
                                                 style="width: ${courseInfo.progress}%">
                                            </div>
                                        </div>
                                        <div class="progress-text">Tiến độ: ${courseInfo.progress}%</div>
                                    </div>
                                </div>

                                <div class="course-content">
                                    <!-- Course Title -->
                                    <h3 class="course-title">
                                        ${courseInfo.course.title}
                                    </h3>

                                    <!-- Course Meta -->
                                    <div class="course-meta">
                                        <div class="meta-item">
                                            <i class="fas fa-users"></i>
                                            <span>${courseInfo.course.learnerCount != null ? courseInfo.course.learnerCount : 0} học viên</span>
                                        </div>
                                        <c:if test="${courseInfo.course.price != null && courseInfo.course.price > 0}">
                                            <div class="meta-item">
                                                <i class="fas fa-tag"></i>
                                                <span class="course-price">${String.format("%,.0f", courseInfo.course.price)} VNĐ</span>
                                            </div>
                                        </c:if>
                                        <div class="meta-item">
                                            <i class="fas fa-calendar"></i>
                                            <span>Đăng ký: 
                                                <c:choose>
                                                    <c:when test="${courseInfo.enrollment.creationTime != null}">
                                                        ${String.format('%1$td/%1$tm/%1$tY', courseInfo.enrollment.creationTime)}
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>

                                    <!-- Status -->
                                    <div>
                                        <c:choose>
                                            <c:when test="${courseInfo.enrollment.status == 'ACTIVE' || courseInfo.enrollment.status == 'Active' || courseInfo.enrollment.status == 'Ongoing'}">
                                                <span class="course-status status-active">
                                                    <i class="fas fa-play"></i>
                                                    Đang học
                                                </span>
                                            </c:when>
                                            <c:when test="${courseInfo.enrollment.status == 'COMPLETED' || courseInfo.enrollment.status == 'Completed'}">
                                                <span class="course-status status-completed">
                                                    <i class="fas fa-check"></i>
                                                    Hoàn thành
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="course-status status-pending">
                                                    <i class="fas fa-clock"></i>
                                                    ${courseInfo.enrollment.status}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="course-actions">
                                        <a href="/Adaptive_Elearning/my-courses/course-player?courseId=${courseInfo.course.id}"
                                           class="btn-continue">
                                            <i class="fas fa-play"></i>
                                            ${empty courseInfo.enrollment.lastViewedLectureId ? 'Bắt đầu học' : 'Tiếp tục học'}
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

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

                <div style="text-align: center; padding-top: 2rem; border-top: 1px solid #374151;">
                    <p>&copy; 2024 FlyUp. Tất cả quyền được bảo lưu.</p>
                </div>
            </div>
        </footer>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const userMenuBtn = document.querySelector('.user-menu-btn');
                const dropdownMenu = document.querySelector('.user-dropdown .dropdown-menu');

                if (userMenuBtn && dropdownMenu) {
                    userMenuBtn.addEventListener('click', function (e) {
                        e.stopPropagation();
                        dropdownMenu.classList.toggle('show');

                        const arrow = this.querySelector('.dropdown-arrow');
                        if (arrow) {
                            arrow.style.transform = dropdownMenu.classList.contains('show')
                                    ? 'rotate(180deg)'
                                    : 'rotate(0deg)';
                        }
                    });

                    document.addEventListener('click', function (e) {
                        if (!userMenuBtn.contains(e.target) && !dropdownMenu.contains(e.target)) {
                            dropdownMenu.classList.remove('show');
                            const arrow = userMenuBtn.querySelector('.dropdown-arrow');
                            if (arrow) {
                                arrow.style.transform = 'rotate(0deg)';
                            }
                        }
                    });
                }

                setTimeout(function () {
                    const alert = document.querySelector('.success-alert');
                    if (alert) {
                        alert.style.transition = 'opacity 0.5s ease-out';
                        alert.style.opacity = '0';
                        setTimeout(() => alert.remove(), 500);
                    }
                }, 5000);

                // Add loading animation to course cards
                const cards = document.querySelectorAll('.course-card');
                cards.forEach((card, index) => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';

                    setTimeout(() => {
                        card.style.transition = 'all 0.5s ease';
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, index * 100);
                });
            });
        </script>
    </body>
</html>