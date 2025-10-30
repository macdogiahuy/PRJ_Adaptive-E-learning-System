<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>

<%
    Users user = (Users) session.getAttribute("account");
    if (user == null || !"Instructor".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng Quan - Instructor Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: #f5f7fa;
            color: #333;
        }
        
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar - Same as instructor_courses.jsp */
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
            text-decoration: none;
            color: white;
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
        
        /* Main Content */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 30px;
        }
        
        .page-header {
            margin-bottom: 30px;
        }
        
        .page-title {
            font-size: 28px;
            font-weight: 700;
            color: #1e3c72;
            margin-bottom: 10px;
        }
        
        .page-subtitle {
            color: #666;
            font-size: 14px;
        }
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: all 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
        }
        
        .stat-icon.blue { background: #e3f2fd; color: #2196F3; }
        .stat-icon.green { background: #e8f5e9; color: #4CAF50; }
        .stat-icon.orange { background: #fff3e0; color: #FF9800; }
        .stat-icon.purple { background: #f3e5f5; color: #9C27B0; }
        
        .stat-info h3 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 5px;
            color: #1e3c72;
        }
        
        .stat-info p {
            font-size: 14px;
            color: #666;
            font-weight: 500;
        }
        
        .stat-change {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
            margin-top: 8px;
        }
        
        .stat-change.positive {
            color: #4CAF50;
        }
        
        .stat-change.negative {
            color: #f44336;
        }
        
        /* Content Sections */
        .content-section {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #1e3c72;
        }
        
        .section-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: #2196F3;
            color: white;
        }
        
        .btn-primary:hover {
            background: #1976D2;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(33, 150, 243, 0.4);
        }
        
        .btn-secondary {
            background: white;
            color: #666;
            border: 1px solid #ddd;
        }
        
        .btn-secondary:hover {
            background: #f5f5f5;
            border-color: #bbb;
        }
        
        /* Quick Actions Grid */
        .quick-actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
        }
        
        .action-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
        }
        
        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
        }
        
        .action-card i {
            font-size: 32px;
            margin-bottom: 10px;
            display: block;
        }
        
        .action-card span {
            font-size: 14px;
            font-weight: 500;
        }
        
        .action-card:nth-child(1) { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .action-card:nth-child(2) { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .action-card:nth-child(3) { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .action-card:nth-child(4) { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
        .action-card:nth-child(5) { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
        .action-card:nth-child(6) { background: linear-gradient(135deg, #30cfd0 0%, #330867 100%); }
        
        /* Activity List */
        .activity-list {
            list-style: none;
        }
        
        .activity-item {
            display: flex;
            align-items: start;
            gap: 15px;
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            transition: all 0.3s;
        }
        
        .activity-item:hover {
            background: #f9f9f9;
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        
        .activity-icon.blue { background: #e3f2fd; color: #2196F3; }
        .activity-icon.green { background: #e8f5e9; color: #4CAF50; }
        .activity-icon.orange { background: #fff3e0; color: #FF9800; }
        
        .activity-content {
            flex: 1;
        }
        
        .activity-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        
        .activity-desc {
            font-size: 13px;
            color: #666;
        }
        
        .activity-time {
            font-size: 12px;
            color: #999;
            white-space: nowrap;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <%@ include file="/WEB-INF/includes/instructor-sidebar.jsp" %>
        
        <!-- Main Content -->
        <main class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1 class="page-title">Tổng quan</h1>
                <p class="page-subtitle">Chào mừng trở lại, <%= user.getUserName() %>! Đây là tổng quan về hoạt động giảng dạy của bạn.</p>
            </div>
            
            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon blue">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3>1,247</h3>
                        <p>Tổng học viên</p>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>+12%</span>
                        </div>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon green">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="stat-info">
                        <h3>23</h3>
                        <p>Khóa học hoạt động</p>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>+5%</span>
                        </div>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon orange">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div class="stat-info">
                        <h3>87%</h3>
                        <p>Tỷ lệ hoàn thành</p>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>+8%</span>
                        </div>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon purple">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="stat-info">
                        <h3>45.600 đ</h3>
                        <p>Doanh thu tháng</p>
                        <div class="stat-change positive">
                            <i class="fas fa-arrow-up"></i>
                            <span>+15%</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Quick Actions -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Hành động nhanh</h2>
                </div>
                <div class="quick-actions-grid">
                    <button class="action-card" onclick="window.location.href='http://localhost:8080/Adaptive_Elearning/instructor-courses'">
                        <i class="fas fa-plus"></i>
                        <span>Tạo khóa học</span>
                    </button>
                    <button class="action-card" onclick="window.location.href='<%= request.getContextPath() %>/upload-resource'">
                        <i class="fas fa-upload"></i>
                        <span>Tải lên tài liệu</span>
                    </button>
                    <button class="action-card" onclick="window.location.href='<%= request.getContextPath() %>/create-assignment'">
                        <i class="fas fa-tasks"></i>
                        <span>Tạo bài tập</span>
                    </button>
                    <button class="action-card" onclick="window.location.href='<%= request.getContextPath() %>/send-notification'">
                        <i class="fas fa-envelope"></i>
                        <span>Gửi thông báo</span>
                    </button>
                    <button class="action-card" onclick="window.location.href='<%= request.getContextPath() %>/view-reports'">
                        <i class="fas fa-chart-bar"></i>
                        <span>Xem báo cáo</span>
                    </button>
                    <button class="action-card" onclick="window.location.href='<%= request.getContextPath() %>/schedule'">
                        <i class="fas fa-calendar-plus"></i>
                        <span>Lên lịch học</span>
                    </button>
                </div>
            </div>
            
            <!-- Recent Activity -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Hoạt động gần đây</h2>
                    <div class="section-actions">
                        <button class="btn btn-secondary">
                            <i class="fas fa-sync-alt"></i>
                            <span>Làm mới</span>
                        </button>
                    </div>
                </div>
                <ul class="activity-list">
                    <li class="activity-item">
                        <div class="activity-icon blue">
                            <i class="fas fa-user-plus"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">15 học viên mới đăng ký</div>
                            <div class="activity-desc">Khóa học "Java Programming Basics"</div>
                        </div>
                        <div class="activity-time">2 giờ trước</div>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon green">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">23 bài tập đã được nộp</div>
                            <div class="activity-desc">Assignment #5 - React Hooks</div>
                        </div>
                        <div class="activity-time">4 giờ trước</div>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon orange">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">8 đánh giá mới</div>
                            <div class="activity-desc">Trung bình 4.8/5 sao</div>
                        </div>
                        <div class="activity-time">1 ngày trước</div>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon blue">
                            <i class="fas fa-comment"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title">12 câu hỏi mới trong diễn đàn</div>
                            <div class="activity-desc">Python Data Science Course</div>
                        </div>
                        <div class="activity-time">2 ngày trước</div>
                    </li>
                </ul>
            </div>
            
            <!-- Navigation to Courses -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Khóa học của bạn</h2>
                    <div class="section-actions">
                        <button class="btn btn-primary" onclick="window.location.href='/Adaptive_Elearning/instructor-courses'">
                            <i class="fas fa-book"></i>
                            <span>Xem tất cả khóa học</span>
                        </button>
                    </div>
                </div>
                <p style="color: #666; font-size: 14px;">
                    Click vào "Khóa học" trong menu bên trái hoặc nút "Xem tất cả khóa học" để quản lý các khóa học của bạn.
                </p>
            </div>
        </main>
    </div>
</body>
</html>
