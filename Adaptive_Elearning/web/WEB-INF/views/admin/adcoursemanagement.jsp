<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="controller.CourseManagementController"%>
<%@page import="controller.CourseManagementController.Course"%>
<%@page import="controller.CourseManagementController.CourseStats"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%
    CourseManagementController controller = new CourseManagementController();
    CourseStats stats = null;
    List<Course> courses = null;
    String errorMessage = null;
    
    String search = request.getParameter("search");
    if (search == null) search = "";
    
    // Pagination parameters
    String pageParam = request.getParameter("page");
    int currentPage = 1;
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
            if (currentPage < 1) currentPage = 1;
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    int coursesPerPage = 6; // 6 courses per page for better display
    int offset = (currentPage - 1) * coursesPerPage;
    
    // Calculate total pages
    int totalCourses = 0;
    int totalPages = 1;
    
    try {
        // Load statistics
        stats = controller.getCourseStats();
        
        // Get total courses count
        List<Course> allCourses = controller.getCourses(search, Integer.MAX_VALUE, 0);
        totalCourses = allCourses != null ? allCourses.size() : 0;
        totalPages = (int) Math.ceil((double) totalCourses / coursesPerPage);
        if (totalPages < 1) totalPages = 1;
        
        // Load courses for current page
        courses = controller.getCourses(search, coursesPerPage, offset);
        
    } catch (Exception e) {
        errorMessage = "Lỗi kết nối database: " + e.getMessage();
        e.printStackTrace();
        
        // Set default values
        stats = new CourseManagementController.CourseStats(0, 0, 0, 0);
        courses = new ArrayList<>();
    }
    
    // Session message handling
    String message = (String) session.getAttribute("message");
    String messageType = (String) session.getAttribute("messageType");
    if (message != null) {
        session.removeAttribute("message");
        session.removeAttribute("messageType");
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khóa học - CourseHub E-Learning</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: ''Inter'', ''Segoe UI'', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        .header {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header h1 {
            color: white;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .user-info {
            color: white;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .container {
            display: flex;
            min-height: calc(100vh - 80px);
        }

        .sidebar {
            width: 250px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 2rem 0;
            border-right: 1px solid rgba(255, 255, 255, 0.2);
        }

        .sidebar ul {
            list-style: none;
        }

        .sidebar li {
            margin: 0.5rem 0;
        }

        .sidebar a {
            color: white;
            text-decoration: none;
            padding: 1rem 2rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            transition: background 0.3s ease;
        }

        .sidebar a:hover,
        .sidebar a.active {
            background: rgba(255, 255, 255, 0.2);
        }

        .main-content {
            flex: 1;
            padding: 2rem;
            overflow-y: auto;
        }

        .message-alert {
            padding: 1rem 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 500;
            animation: slideIn 0.5s ease-out;
        }

        .message-alert.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message-alert.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        @keyframes slideIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        @keyframes slideOut {
            from { transform: translateY(0); opacity: 1; }
            to { transform: translateY(-20px); opacity: 0; }
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '''';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--accent-color);
        }

        .stat-card.total::before { --accent-color: #667eea; }
        .stat-card.ongoing::before { --accent-color: #28a745; }
        .stat-card.completed::before { --accent-color: #17a2b8; }
        .stat-card.draft::before { --accent-color: #ffc107; }

        .stat-info h3 {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }

        .stat-info .number {
            font-size: 2rem;
            font-weight: bold;
            color: #333;
        }

        .stat-icon {
            font-size: 2.5rem;
            color: #e0e7ff;
        }

        .search-section {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .search-form {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .search-form input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 2px solid #e0e7ff;
            border-radius: 10px;
            font-size: 1rem;
            outline: none;
            transition: border-color 0.3s ease;
        }

        .search-form input:focus {
            border-color: #667eea;
        }

        .search-form button {
            padding: 0.75rem 1.5rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            transition: transform 0.3s ease;
        }

        .search-form button:hover {
            transform: translateY(-2px);
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
        }

        .course-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .course-thumbnail {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            position: relative;
        }

        .course-thumbnail::after {
    
            position: absolute;
            top: 1rem;
            left: 1rem;
            font-size: 0.9rem;
            background: rgba(0,0,0,0.3);
            padding: 0.25rem 0.5rem;
            border-radius: 5px;
        }

        .course-content {
            padding: 1.5rem;
        }

        .course-title {
            font-size: 1.2rem;
            font-weight: bold;
            margin-bottom: 1rem;
            color: #333;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            color: #666;
            font-size: 0.9rem;
        }

        .course-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            text-align: center;
        }

        .stat-item {
            flex: 1;
        }

        .stat-number {
            font-size: 1.1rem;
            font-weight: bold;
            color: #333;
        }

        .stat-label {
            font-size: 0.8rem;
            color: #666;
            margin-top: 0.25rem;
        }

        .course-status {
            text-align: center;
            margin-top: 1rem;
        }

        .status-btn {
            padding: 0.5rem 1.5rem;
            border: 2px solid;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: capitalize;
            cursor: default;
        }

        .status-ongoing {
            background: #d4edda;
            border-color: #28a745;
            color: #155724;
        }

        .status-draft {
            background: #fff3cd;
            border-color: #ffc107;
            color: #856404;
        }

        .status-completed {
            background: #cce5ff;
            border-color: #17a2b8;
            color: #004085;
        }

        .status-off {
            background: #f8d7da;
            border-color: #dc3545;
            color: #721c24;
        }

        .course-actions {
            display: flex;
            gap: 0.5rem;
            margin: 1rem 0;
            justify-content: center;
        }

        .action-btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            min-width: 120px;
        }

        .start-btn {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }

        .start-btn:hover {
            background: linear-gradient(135deg, #218838, #1ea982);
            transform: translateY(-2px);
        }

        .stop-btn {
            background: linear-gradient(135deg, #dc3545, #fd7e14);
            color: white;
        }

        .stop-btn:hover {
            background: linear-gradient(135deg, #c82333, #e8630a);
            transform: translateY(-2px);
        }

        .no-courses {
            text-align: center;
            padding: 3rem;
            color: #666;
        }

        .no-courses i {
            font-size: 4rem;
            color: #ccc;
            margin-bottom: 1rem;
        }

        /* Pagination Styles */
        .pagination-container {
            margin-top: 40px;
            display: flex;
            flex-direction: column;
            gap: 20px;
            align-items: center;
        }

        .pagination {
            display: flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border-radius: 50px;
            padding: 12px 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .pagination-btn, .pagination-number {
            padding: 12px 16px;
            border-radius: 12px;
            text-decoration: none;
            color: #475569;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            min-width: 44px;
            justify-content: center;
            font-size: 14px;
        }

        .pagination-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
        }

        .pagination-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .pagination-number {
            background: transparent;
            border: 2px solid transparent;
        }

        .pagination-number:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: translateY(-1px);
        }

        .pagination-number.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .pagination-dots {
            color: #94a3b8;
            font-weight: bold;
            padding: 0 8px;
            font-size: 16px;
        }

        .pagination-info {
            color: #64748b;
            font-size: 14px;
            text-align: center;
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(10px);
            padding: 12px 20px;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        @media (max-width: 768px) {
            .pagination {
                flex-wrap: wrap;
                padding: 8px 12px;
                gap: 4px;
            }

            .pagination-btn, .pagination-number {
                padding: 8px 12px;
                font-size: 12px;
                min-width: 36px;
            }

            .pagination-info {
                font-size: 12px;
                padding: 8px 16px;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <h1><i class="fas fa-graduation-cap"></i> CourseHub E-Learning Admin</h1>
        <div class="user-info">
            <i class="fas fa-user-circle"></i>
            <span>Admin User</span>
        </div>
    </header>

    <div class="container">
        <nav class="sidebar">
            <ul>
                <li><a href="/adaptive_elearning/admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Tổng quan</a></li>
                <li><a href="/adaptive_elearning/admin_notification.jsp"><i class="fas fa-bell"></i> Thông báo</a></li>
                <li><a href="/adaptive_elearning/admin_createadmin.jsp"><i class="fas fa-user-plus"></i> Tạo Admin</a></li>
                <li><a href="/adaptive_elearning/admin_accountmanagement.jsp"><i class="fas fa-users"></i> Quản lý Tài Khoản</a></li>
                <li><a href="/adaptive_elearning/admin_reportedcourse.jsp"><i class="fas fa-flag"></i> Quản lý Khóa Học</a></li>
                <li><a href="/adaptive_elearning/admin_coursemanagement.jsp" class="active"><i class="fa-solid fa-bars-progress"></i> Các Khóa Học</a></li>
                <li><a href="/adaptive_elearning/admin_reportedgroup.jsp"><i class="fas fa-user-graduate"></i> Quản lý Nhóm</a></li>
                <li><a href="#"><i class="fas fa-chart-bar"></i> Home</a></li>
                <li><a href="#"><i class="fas fa-cog"></i> LogOut</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <% if (message != null) { %>
            <div class="message-alert <%= "success".equals(messageType) ? "success" : "error" %>" id="messageAlert">
                <i class="fas <%= "success".equals(messageType) ? "fa-check-circle" : "fa-exclamation-triangle" %>"></i> 
                <%= message %>
            </div>
            <% } %>
            
            <% if (errorMessage != null) { %>
            <div class="message-alert error">
                <i class="fas fa-exclamation-triangle"></i> <%= errorMessage %>
            </div>
            <% } %>
            
            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card total">
                    <div class="stat-info">
                        <h3>Tổng số khóa học</h3>
                        <div class="number"><%= stats != null ? stats.getTotalCourses() : 0 %></div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-book"></i>
                    </div>
                </div>

                <div class="stat-card ongoing">
                    <div class="stat-info">
                        <h3>Đang diễn ra</h3>
                        <div class="number"><%= stats != null ? stats.getOngoingCourses() : 0 %></div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-play-circle"></i>
                    </div>
                </div>

                <div class="stat-card completed">
                    <div class="stat-info">
                        <h3>Hoàn thành</h3>
                        <div class="number"><%= stats != null ? stats.getCompletedCourses() : 0 %></div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>

                <div class="stat-card draft">
                    <div class="stat-info">
                        <h3>Bản nháp</h3>
                        <div class="number"><%= stats != null ? stats.getDraftCourses() : 0 %></div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-edit"></i>
                    </div>
                </div>
            </div>

            <!-- Search Section -->
            <div class="search-section">
                <form class="search-form" method="get">
                    <input type="text" name="search" placeholder="Tìm kiếm khóa học theo tên..." value="<%= search %>">
                    <button type="submit"><i class="fas fa-search"></i> Tìm kiếm</button>
                </form>
            </div>
            
            <!-- Courses Grid -->
            <div class="courses-grid">
                <% if (courses != null && !courses.isEmpty()) { 
                    for (Course course : courses) { %>
                <div class="course-card">
                    <div class="course-thumbnail">
                        <% if (course.getThumbUrl() != null && !course.getThumbUrl().isEmpty()) { %>
                            <img src="<%= course.getThumbUrl() %>" alt="<%= course.getTitle() %>" style="width: 100%; height: 100%; object-fit: cover;">
                        <% } else { %>
                            <i class="fas fa-play-circle" style="font-size: 3rem; opacity: 0.7;"></i>
                        <% } %>
                    </div>
                    <div class="course-content">
                        <div class="course-title"><%= course.getTitle() %></div>
                        
                        <div class="course-meta">
                            <span>Trạng thái: <%= course.getStatus() %></span>
                            <span>Cấp độ: <%= course.getLevel() != null ? course.getLevel() : "Chưa phân loại" %></span>
                        </div>
                        
                        <% if (course.getInstructorName() != null && !course.getInstructorName().isEmpty()) { %>
                        <div class="course-instructor" style="color: #666; font-size: 0.9rem; margin-bottom: 1rem;">
                            <i class="fas fa-user"></i> Giảng viên: <%= course.getInstructorName() %>
                        </div>
                        <% } %>
                        
                        <div class="course-stats">
                            <div class="stat-item">
                                <div class="stat-number"><%= course.getLearnerCount() %></div>
                                <div class="stat-label">Học viên</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number"><%= course.getAverageRating() %> <i class="fas fa-star" style="color: #ffc107;"></i></div>
                                <div class="stat-label">Đánh giá</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">
                                    <% 
                                    java.text.NumberFormat formatter = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
                                    %>
                                    <%= formatter.format(course.getPrice()) %>₫
                                </div>
                                <div class="stat-label">Giá</div>
                            </div>
                        </div>
                             <div class="course-status">
                            <% 
                            String status = course.getStatus();
                            String statusClass = "status-ongoing";
                            String statusText = status;
                            
                            if ("Draft".equals(status)) {
                                statusClass = "status-draft";
                                statusText = "Bản nháp";
                            } else if ("Completed".equals(status)) {
                                statusClass = "status-completed";
                                statusText = "Hoàn thành";
                            } else if ("Off".equals(status)) {
                                statusClass = "status-off";
                                statusText = "Đã tắt";
                            } else if ("Ongoing".equals(status)) {
                                statusClass = "status-ongoing";
                                statusText = "Đang diễn ra";
                            }
                            %>
                            <span class="status-btn <%= statusClass %>"><%= statusText %></span>
                        </div>       
                        
                        <div class="course-actions">
                            <% if ("Off".equals(course.getStatus())) { %>
                                <form action="/adaptive_elearning/courseAction" method="post">
                                    <input type="hidden" name="action" value="start">
                                    <input type="hidden" name="courseId" value="<%= course.getId() %>">
                                    <input type="hidden" name="redirectPage" value="/adaptive_elearning/admin_coursemanagement.jsp">
                                    <button type="submit" class="action-btn start-btn" onclick="return confirm('Bạn có chắc chắn muốn bật khóa học này?')">
                                        <i class="fas fa-play"></i> Bật
                                    </button>
                                </form>
                            <% } else if (!"Completed".equals(course.getStatus())) { %>
                                <form action="/adaptive_elearning/courseAction" method="post">
                                    <input type="hidden" name="action" value="stop">
                                    <input type="hidden" name="courseId" value="<%= course.getId() %>">
                                    <input type="hidden" name="redirectPage" value="/adaptive_elearning/admin_coursemanagement.jsp">
                                    <button type="submit" class="action-btn stop-btn" onclick="return confirm('Bạn có chắc chắn muốn tắt khóa học này?')">
                                        <i class="fas fa-stop"></i> Tắt
                                    </button>
                                </form>
                            <% } %>
                        </div>
                        
                    
                    </div>
                </div>
                <% } 
                } else { %>
                    <div class="no-courses">
                        <i class="fas fa-search"></i>
                        <h3>Không tìm thấy khóa học nào</h3>
                        <p>Thử thay đổi từ khóa tìm kiếm để xem kết quả khác</p>
                    </div>
                <% } %>
            </div>
            
            <!-- Pagination -->
            <% if (totalPages > 1) { %>
            <div class="pagination-container">
                <div class="pagination">
                    <!-- Previous button -->
                    <% if (currentPage > 1) { %>
                    <a href="?<%= search != null && !search.isEmpty() ? "search=" + java.net.URLEncoder.encode(search, "UTF-8") + "&" : "" %>page=<%= currentPage - 1 %>" 
                       class="pagination-btn">
                        <i class="fas fa-chevron-left"></i> Trước
                    </a>
                    <% } %>
                    
                    <!-- Page numbers -->
                    <%
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, currentPage + 2);
                    
                    // Show first page if not in range
                    if (startPage > 1) {
                    %>
                    <a href="?<%= search != null && !search.isEmpty() ? "search=" + java.net.URLEncoder.encode(search, "UTF-8") + "&" : "" %>page=1" 
                       class="pagination-number">1</a>
                    <% if (startPage > 2) { %>
                    <span class="pagination-dots">...</span>
                    <% } %>
                    <% } %>
                    
                    <!-- Page range -->
                    <% for (int p = startPage; p <= endPage; p++) { %>
                    <% if (p == currentPage) { %>
                    <span class="pagination-number active"><%= p %></span>
                    <% } else { %>
                    <a href="?<%= search != null && !search.isEmpty() ? "search=" + java.net.URLEncoder.encode(search, "UTF-8") + "&" : "" %>page=<%= p %>" 
                       class="pagination-number"><%= p %></a>
                    <% } %>
                    <% } %>
                    
                    <!-- Show last page if not in range -->
                    <% if (endPage < totalPages) { %>
                    <% if (endPage < totalPages - 1) { %>
                    <span class="pagination-dots">...</span>
                    <% } %>
                    <a href="?<%= search != null && !search.isEmpty() ? "search=" + java.net.URLEncoder.encode(search, "UTF-8") + "&" : "" %>page=<%= totalPages %>" 
                       class="pagination-number"><%= totalPages %></a>
                    <% } %>
                    
                    <!-- Next button -->
                    <% if (currentPage < totalPages) { %>
                    <a href="?<%= search != null && !search.isEmpty() ? "search=" + java.net.URLEncoder.encode(search, "UTF-8") + "&" : "" %>page=<%= currentPage + 1 %>" 
                       class="pagination-btn">
                        Tiếp <i class="fas fa-chevron-right"></i>
                    </a>
                    <% } %>
                </div>
                
<!--                <div class="pagination-info">
                    Hiển thị <%= Math.min(offset + 1, totalCourses) %> - <%= Math.min(offset + coursesPerPage, totalCourses) %> 
                    trong tổng số <%= totalCourses %> khóa học
                </div>-->
            </div>
            <% } %>
        </main>
    </div>

    <script>
        // Auto-hide message after 5 seconds
        const messageAlert = document.getElementById('messageAlert');
        if (messageAlert) {
            setTimeout(function() {
                messageAlert.style.animation = 'slideOut 0.5s ease-out forwards';
                setTimeout(function() {
                    if (messageAlert && messageAlert.parentNode) {
                        messageAlert.remove();
                    }
                }, 500);
            }, 5000);
        }

        // Add loading animation to search
        const searchForm = document.querySelector('.search-form');
        if (searchForm) {
            searchForm.addEventListener('submit', function(e) {
                const button = this.querySelector('button');
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tìm...';
                button.disabled = true;
                
                // Re-enable after 3 seconds in case of issues
                setTimeout(function() {
                    if (button) {
                        button.innerHTML = originalText;
                        button.disabled = false;
                    }
                }, 3000);
            });
        }
    </script>
</body>
</html>
