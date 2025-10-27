<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%@page import="java.util.*"%>

<%
    // Get user from session
    Users user = (Users) session.getAttribute("account");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển Giảng viên - FlyUp</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="/Adaptive_Elearning/assets/css/instructor-dashboard-modern.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <a href="/Adaptive_Elearning/" class="logo">
                    <i class="fas fa-graduation-cap"></i>
                    <span>FlyUp</span>
                </a>
            </div>
            
            <nav>
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a href="#dashboard" class="nav-link active">
                            <i class="fas fa-home"></i>
                            <span class="nav-text">Tổng quan</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="#courses" class="nav-link">
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
                            <i class="fas fa-chart-bar"></i>
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

        <!-- Main Content -->
        <main class="main-content">
            <!-- Header -->
            <header class="dashboard-header">
                <div class="header-left">
                    <button class="sidebar-toggle">
                        <i class="fas fa-bars"></i>
                    </button>
                    <h1 class="page-title">Bảng điều khiển</h1>
                </div>
                
                <div class="header-right">
                    <!-- Search Box -->
                    <div class="search-container">
                        <div class="search-box">
                            <i class="fas fa-search search-icon"></i>
                            <input type="text" class="search-input" placeholder="Tìm kiếm khóa học, học viên... (Ctrl+K)">
                        </div>
                    </div>
                    
                    <!-- Notifications -->
                    <div class="notifications">
                        <button class="notification-btn">
                            <i class="fas fa-bell"></i>
                            <span class="notification-badge">3</span>
                        </button>
                    </div>
                    
                    <!-- User Menu -->
                    <div class="user-menu">
                        <div class="user-avatar">
                            <% 
                                String fullName = user.getFullName();
                                String initial = "U"; // Default initial
                                if (fullName != null && !fullName.trim().isEmpty()) {
                                    initial = fullName.substring(0, 1).toUpperCase();
                                } else if (user.getUserName() != null && !user.getUserName().trim().isEmpty()) {
                                    initial = user.getUserName().substring(0, 1).toUpperCase();
                                }
                            %>
                            <%= initial %>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <div class="stat-number">0</div>
                        <div class="stat-label">Tổng học viên</div>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>+12%</span>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon">
                                <i class="fas fa-book"></i>
                            </div>
                        </div>
                        <div class="stat-number">0</div>
                        <div class="stat-label">Khóa học hoạt động</div>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>+5%</span>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon">
                                <i class="fas fa-chart-line"></i>
                            </div>
                        </div>
                        <div class="stat-number">0%</div>
                        <div class="stat-label">Tỷ lệ hoàn thành</div>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>+8%</span>
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-icon">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                        </div>
                        <div class="stat-number">0 VNĐ</div>
                        <div class="stat-label">Doanh thu tháng</div>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>+15%</span>
                        </div>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="chart-container">
                    <div class="chart-header">
                        <h3 class="chart-title">Tiến độ học viên</h3>
                        <div class="chart-filters">
                            <button class="filter-btn active" data-filter="week">Tuần</button>
                            <button class="filter-btn" data-filter="month">Tháng</button>
                            <button class="filter-btn" data-filter="year">Năm</button>
                        </div>
                    </div>
                    <div class="chart-content">
                        <canvas id="studentProgressChart" width="800" height="300"></canvas>
                    </div>
                </div>

                <!-- Course Management -->
                <div class="table-container">
                    <div class="table-header">
                        <h3 class="table-title">Khóa học của tôi</h3>
                        <div class="table-actions">
                            <button class="btn btn-primary">
                                <i class="fas fa-plus"></i>
                                Tạo khóa học mới
                            </button>
                            <button class="btn btn-secondary" onclick="dashboard.exportData('csv')">
                                <i class="fas fa-download"></i>
                                Xuất dữ liệu
                            </button>
                        </div>
                    </div>
                    
                    <div class="table-content">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Tên khóa học</th>
                                    <th>Học viên</th>
                                    <th>Tiến độ</th>
                                    <th>Đánh giá</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody id="courseTableBody">
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 2rem;">
                                        <div class="spinner"></div>
                                        <p>Đang tải dữ liệu...</p>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="chart-container">
                    <div class="chart-header">
                        <h3 class="chart-title">Hoạt động gần đây</h3>
                        <button class="btn btn-secondary" onclick="dashboard.refreshData()">
                            <i class="fas fa-sync-alt"></i>
                            Làm mới
                        </button>
                    </div>
                    <div class="activity-list">
                        <div style="text-align: center; padding: 2rem;">
                            <div class="spinner"></div>
                            <p>Đang tải hoạt động...</p>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="quick-actions">
                    <h3>Hành động nhanh</h3>
                    <div class="action-grid">
                        <button class="action-card">
                            <i class="fas fa-plus"></i>
                            <span>Tạo khóa học</span>
                        </button>
                        <button class="action-card">
                            <i class="fas fa-upload"></i>
                            <span>Tải lên tài liệu</span>
                        </button>
                        <button class="action-card">
                            <i class="fas fa-tasks"></i>
                            <span>Tạo bài tập</span>
                        </button>
                        <button class="action-card">
                            <i class="fas fa-envelope"></i>
                            <span>Gửi thông báo</span>
                        </button>
                        <button class="action-card">
                            <i class="fas fa-chart-bar"></i>
                            <span>Xem báo cáo</span>
                        </button>
                        <button class="action-card">
                            <i class="fas fa-calendar-plus"></i>
                            <span>Lên lịch học</span>
                        </button>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- JavaScript - Optimized loading -->
    <script defer src="/Adaptive_Elearning/assets/js/performance-optimizer.js"></script>
    <script defer src="/Adaptive_Elearning/assets/js/instructor-dashboard-modern.js"></script>
    
    <!-- Initialize Dashboard -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Set global user name for JavaScript
            window.userName = '<%= (user.getFullName() != null && !user.getFullName().trim().isEmpty()) ? user.getFullName() : user.getUserName() %>';
            
            console.log('Dashboard initialized for user:', window.userName);
            
            // Populate course table with sample data - reduced delay
            setTimeout(() => {
                if (typeof populateCourseTable === 'function') {
                    populateCourseTable();
                }
            }, 800);
        });
        
        function populateCourseTable() {
            const tableBody = document.getElementById('courseTableBody');
            const sampleCourses = [
                {
                    name: 'Lap trinh JavaScript co ban',
                    students: 156,
                    progress: 78,
                    rating: 4.8,
                    status: 'active',
                    id: 1
                },
                {
                    name: 'React JS Advanced',
                    students: 89,
                    progress: 65,
                    rating: 4.6,
                    status: 'active',
                    id: 2
                },
                {
                    name: 'Node.js Backend Development',
                    students: 123,
                    progress: 82,
                    rating: 4.9,
                    status: 'active',
                    id: 3
                },
                {
                    name: 'Python Data Science',
                    students: 234,
                    progress: 91,
                    rating: 4.7,
                    status: 'completed',
                    id: 4
                }
            ];
            
            tableBody.innerHTML = sampleCourses.map(course => `
                <tr>
                    <td>
                        <div style="display: flex; align-items: center; gap: 0.75rem;">
                            <div style="width: 40px; height: 40px; background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white;">
                                <i class="fas fa-book"></i>
                            </div>
                            <div>
                                <div style="font-weight: 600; color: #0f172a;">${course.name}</div>
                                <small style="color: #64748b;">Cap nhat 2 ngay truoc</small>
                            </div>
                        </div>
                    </td>
                    <td>
                        <span style="font-weight: 600; color: #0f172a;">${course.students}</span> hoc vien
                    </td>
                    <td>
                        <div style="display: flex; align-items: center; gap: 0.5rem;">
                            <div class="progress-bar" style="flex: 1;">
                                <div class="progress-fill" style="width: ${course.progress}%;"></div>
                            </div>
                            <span style="font-weight: 600; min-width: 40px; color: #0f172a;">${course.progress}%</span>
                        </div>
                    </td>
                    <td>
                        <div style="display: flex; align-items: center; gap: 0.25rem;">
                            <i class="fas fa-star" style="color: #f59e0b;"></i>
                            <span style="font-weight: 600; color: #0f172a;">${course.rating}</span>
                        </div>
                    </td>
                    <td>
                        <span class="status-badge ${course.status}">
                          
                        </span>
                    </td>
                    <td>
                        <div style="display: flex; gap: 0.5rem;">
                            <button class="btn btn-sm btn-secondary" data-action="view" data-id="${course.id}">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="btn btn-sm btn-primary" data-action="edit" data-id="${course.id}">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-sm btn-danger" data-action="delete" data-id="${course.id}">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            `).join('');
        }
    </script>
</body>
</html>

