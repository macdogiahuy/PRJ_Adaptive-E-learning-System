<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="controller.CourseManagementController" %>
<%@ page import="controller.CourseManagementController.Course" %>
<%@ page import="controller.CourseManagementController.CourseStats" %>
<%@ page import="java.util.List" %>
<%
    CourseManagementController controller = new CourseManagementController();
    CourseStats stats = controller.getCourseStats();
    
    String searchQuery = request.getParameter("search");
    if (searchQuery == null) searchQuery = "";
    
    int currentPage = 1;
    try {
        if (request.getParameter("page") != null) {
            currentPage = Integer.parseInt(request.getParameter("page"));
        }
    } catch (NumberFormatException e) {
        currentPage = 1;
    }
    
    int itemsPerPage = 12;
    List<Course> courses = controller.getCourses(searchQuery, itemsPerPage, (currentPage - 1) * itemsPerPage);
    int totalCourses = controller.getTotalCoursesCount(searchQuery);
    int totalPages = (int) Math.ceil((double) totalCourses / itemsPerPage);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Management - CourseHub E-Learning</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
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

        .page-title {
            margin-bottom: 2rem;
        }

        .page-title h1 {
            color: white;
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .page-title p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1.1rem;
        }

        .stats-container {
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
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--accent-color);
        }

        .stat-card.users::before { --accent-color: #667eea; }
        .stat-card.courses::before { --accent-color: #f093fb; }
        .stat-card.enrollments::before { --accent-color: #4facfe; }
        .stat-card.notifications::before { --accent-color: #43e97b; }

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

        .stat-info .change {
            color: #28a745;
            font-size: 0.8rem;
        }

        .stat-icon {
            font-size: 2rem;
            opacity: 0.3;
        }

        .content-section {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 2.5rem;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .section-header h2 {
            color: #2d3748;
            font-size: 1.75rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .search-container {
            margin-bottom: 2rem;
        }

        .search-bar {
            display: flex;
            align-items: center;
            background: #f7fafc;
            border: 2px solid #e2e8f0;
            border-radius: 16px;
            padding: 0.75rem 1.25rem;
            transition: all 0.3s ease;
            max-width: 500px;
        }

        .search-bar:focus-within {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .search-bar input {
            flex: 1;
            background: transparent;
            border: none;
            color: #2d3748;
            font-size: 1rem;
            outline: none;
            font-weight: 500;
        }

        .search-bar input::placeholder {
            color: #a0aec0;
        }

        .search-bar button {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-left: 0.75rem;
        }

        .search-bar button:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }

        .course-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.05);
            position: relative;
        }

        .course-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }

        .course-thumbnail {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: linear-gradient(135deg, #f7fafc, #edf2f7);
        }

        .course-thumbnail-placeholder {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #f7fafc, #edf2f7);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #a0aec0;
            font-size: 2rem;
        }

        .course-info {
            padding: 1.75rem;
        }

        .course-title {
            font-size: 1.125rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
            color: #2d3748;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 1rem 0;
        }

        .course-level {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 0.375rem 0.875rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .course-price {
            font-size: 1.25rem;
            font-weight: 800;
            color: #48bb78;
        }

        .course-status {
            margin-top: 1rem;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-ongoing { 
            background: rgba(72, 187, 120, 0.1); 
            color: #2f855a; 
            border: 1px solid rgba(72, 187, 120, 0.2);
        }
        .status-draft { 
            background: rgba(237, 137, 54, 0.1); 
            color: #c05621; 
            border: 1px solid rgba(237, 137, 54, 0.2);
        }
        .status-completed { 
            background: rgba(66, 153, 225, 0.1); 
            color: #2c5282; 
            border: 1px solid rgba(66, 153, 225, 0.2);
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 1rem;
        }

        .pagination button {
            background: white;
            border: 2px solid #e2e8f0;
            color: #4a5568;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .pagination button:hover:not(:disabled) {
            border-color: #667eea;
            color: #667eea;
            transform: translateY(-1px);
        }

        .pagination button:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

        .pagination .current-page {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 600;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #a0aec0;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: #4a5568;
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                order: 2;
            }
            
            .sidebar ul {
                display: flex;
                overflow-x: auto;
                padding: 1rem;
                gap: 0.5rem;
            }
            
            .sidebar li {
                margin: 0;
                flex-shrink: 0;
            }

            .main-content {
                order: 1;
                padding: 1rem;
            }

            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }

            .courses-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>
            <i class="fas fa-graduation-cap"></i>
            Course Management - CourseHub E-Learning
        </h1>
        <div class="user-info">
            <span>Xin chào, Admin</span>
            <i class="fas fa-user-circle"></i>
        </div>
    </div>

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
            <div class="page-title">
                <h1><i class="fas fa-book-open"></i> Course Management</h1>
                <p>Quản lý và theo dõi tất cả khóa học trong hệ thống</p>
            </div>

            <!-- Statistics Section -->
            <div class="stats-container">
                <div class="stat-card users">
                    <div class="stat-info">
                        <h3>Tổng số khóa học</h3>
                        <div class="number"><%= stats.getTotalCourses() %></div>
                        <div class="change">Tổng cộng trong hệ thống</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-book"></i>
                    </div>
                </div>
                <div class="stat-card courses">
                    <div class="stat-info">
                        <h3>Khóa học đang diễn ra</h3>
                        <div class="number"><%= stats.getOngoingCourses() %></div>
                        <div class="change">Đang hoạt động</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-play-circle"></i>
                    </div>
                </div>
                <div class="stat-card enrollments">
                    <div class="stat-info">
                        <h3>Khóa học hoàn thành</h3>
                        <div class="number"><%= stats.getCompletedCourses() %></div>
                        <div class="change">Đã hoàn thành</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
                <div class="stat-card notifications">
                    <div class="stat-info">
                        <h3>Bản nháp</h3>
                        <div class="number"><%= stats.getDraftCourses() %></div>
                        <div class="change">Chờ xuất bản</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-edit"></i>
                    </div>
                </div>
            </div>

            <!-- Courses Section -->
            <div class="content-section">
                <div class="section-header">
                    <h2><i class="fas fa-list-alt"></i> Danh sách khóa học</h2>
                </div>

                <!-- Search Bar -->
                <div class="search-container">
                    <form class="search-bar" method="get">
                        <input type="text" name="search" placeholder="Tìm kiếm khóa học theo tên..." value="<%= searchQuery %>">
                        <button type="submit"><i class="fas fa-search"></i> Tìm kiếm</button>
                    </form>
                </div>

                <!-- Courses Grid -->
                <div class="courses-grid">
                    <% if (courses != null && !courses.isEmpty()) { 
                        for (Course course : courses) { %>
                        <div class="course-card">
                            <% if (course.getThumbUrl() != null && !course.getThumbUrl().isEmpty()) { %>
                                <img src="<%= course.getThumbUrl() %>" alt="Course Thumbnail" class="course-thumbnail">
                            <% } else { %>
                                <div class="course-thumbnail-placeholder">
                                    <i class="fas fa-book-open"></i>
                                </div>
                            <% } %>
                            
                            <div class="course-info">
                                <h3 class="course-title"><%= course.getTitle() %></h3>
                                
                                <div class="course-meta">
                                    <span class="course-level"><%= course.getLevel() %></span>
                                    <span class="course-price">$<%= String.format("%,.0f", course.getPrice()) %></span>
                                </div>
                                
                                <div class="course-status">
                                    <% String status = course.getStatus();
                                       String statusClass = "status-ongoing"; // default
                                       if ("Draft".equalsIgnoreCase(status)) statusClass = "status-draft";
                                       else if ("Completed".equalsIgnoreCase(status)) statusClass = "status-completed";
                                    %>
                                    <span class="status-badge <%= statusClass %>"><%= status %></span>
                                </div>
                            </div>
                        </div>
                    <% } 
                    } else { %>
                        <div class="empty-state">
                            <i class="fas fa-search"></i>
                            <h3>Không tìm thấy khóa học nào</h3>
                            <p>Thử thay đổi từ khóa tìm kiếm hoặc xóa bộ lọc để xem tất cả khóa học</p>
                        </div>
                    <% } %>
                </div>

                <!-- Pagination -->
                <% if (totalPages > 1) { %>
                <div class="pagination">
                    <button onclick="goToPage(<%= currentPage - 1 %>)" <%= currentPage <= 1 ? "disabled" : "" %>>
                        <i class="fas fa-chevron-left"></i> Trước
                    </button>
                    
                    <span class="current-page">Trang <%= currentPage %> / <%= totalPages %></span>
                    
                    <button onclick="goToPage(<%= currentPage + 1 %>)" <%= currentPage >= totalPages ? "disabled" : "" %>>
                        Sau <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
                <% } %>
            </div>
        </main>
    </div>

    <script>
        function goToPage(page) {
            if (page >= 1 && page <= <%= totalPages %>) {
                const url = new URL(window.location);
                url.searchParams.set('page', page);
                window.location.href = url.toString();
            }
        }

        // Add smooth scrolling
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            });
        });

        // Add loading animation to search
        document.querySelector('.search-bar form').addEventListener('submit', function(e) {
            const button = this.querySelector('button');
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tìm...';
        });
    </script>
</body>
</html>