<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Instructor Sidebar Component -->
<aside class="sidebar">
    <div class="sidebar-header">
        <a href="<%= request.getContextPath() %>/" class="logo">
            <i class="fas fa-graduation-cap"></i>
            <span>FlyUp Instructor</span>
        </a>
    </div>
    
    <nav>
        <ul class="nav-menu">
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/instructor-dashboard" class="nav-link <%= request.getRequestURI().contains("instructor_dashboard") ? "active" : "" %>">
                    <i class="fas fa-home"></i>
                    <span class="nav-text">Tổng quan</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/instructor-courses" class="nav-link <%= request.getRequestURI().contains("instructor-courses") || request.getRequestURI().contains("manage_courses") || request.getRequestURI().contains("create_course") ? "active" : "" %>">
                    <i class="fas fa-book"></i>
                    <span class="nav-text">Khóa học</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="#students" class="nav-link">
                    <i class="fas fa-users"></i>
                    <span class="nav-text">Học viên</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="#assignments" class="nav-link">
                    <i class="fas fa-tasks"></i>
                    <span class="nav-text">Bài tập</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="#discussions" class="nav-link">
                    <i class="fas fa-comments"></i>
                    <span class="nav-text">Thảo luận</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="#analytics" class="nav-link">
                    <i class="fas fa-chart-line"></i>
                    <span class="nav-text">Phân tích</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="#resources" class="nav-link">
                    <i class="fas fa-folder"></i>
                    <span class="nav-text">Tài liệu</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="#calendar" class="nav-link">
                    <i class="fas fa-calendar"></i>
                    <span class="nav-text">Lịch học</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="#settings" class="nav-link">
                    <i class="fas fa-cog"></i>
                    <span class="nav-text">Cài đặt</span>
                </a>
            </li>
        </ul>
    </nav>
</aside>

<style>
/* Sidebar Styles */
.sidebar {
    width: 260px;
    background: linear-gradient(180deg, #1e3c72 0%, #2a5298 100%);
    color: white;
    position: fixed;
    height: 100vh;
    overflow-y: auto;
    z-index: 1000;
}

.sidebar-header {
    padding: 20px;
    border-bottom: 1px solid rgba(255,255,255,0.1);
}

.logo {
    font-size: 24px;
    font-weight: bold;
    display: flex;
    align-items: center;
    gap: 10px;
    color: white;
    text-decoration: none;
}

.logo:hover {
    color: white;
    text-decoration: none;
}

.nav-menu {
    list-style: none;
    padding: 20px 0;
}

.nav-item {
    margin: 5px 0;
}

.nav-link {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 20px;
    color: rgba(255,255,255,0.8);
    text-decoration: none;
    transition: all 0.3s;
}

.nav-link:hover,
.nav-link.active {
    background: rgba(255,255,255,0.1);
    color: white;
    border-left: 3px solid #4CAF50;
}

.nav-link i {
    width: 20px;
    text-align: center;
}

/* Responsive */
@media (max-width: 768px) {
    .sidebar {
        transform: translateX(-100%);
    }
}
</style>
