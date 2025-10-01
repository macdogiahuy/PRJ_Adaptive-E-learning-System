<%@page import="controller.CourseManagementController"%>
<%@page import="controller.CourseManagementController.Course"%>
<%@page import="controller.CourseManagementController.CourseStats"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Lấy dữ liệu từ request attributes (đã được xử lý bởi controller)
    CourseStats stats = (CourseStats) request.getAttribute("courseStats");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalCourses = (Integer) request.getAttribute("totalCourses");
    String searchQuery = (String) request.getAttribute("searchQuery");
    
    // Get entries per page parameter
    String entriesParam = request.getParameter("entries");
    int entriesPerPage = 12;
    try {
        if (entriesParam != null) {
            entriesPerPage = Integer.parseInt(entriesParam);
        }
    } catch (NumberFormatException e) {
        entriesPerPage = 12;
    }
    
    // Fallback nếu không có dữ liệu từ attributes
    if (stats == null || courses == null) {
        CourseManagementController controller = new CourseManagementController();
        searchQuery = request.getParameter("search");
        if (searchQuery == null) searchQuery = "";
        
        int pageNum = 1;
        try {
            if (request.getParameter("page") != null) {
                pageNum = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            pageNum = 1;
        }
        
        courses = controller.getCourses(searchQuery, entriesPerPage, (pageNum - 1) * entriesPerPage);
        stats = controller.getCourseStats();
        int total = controller.getTotalCoursesCount(searchQuery);
        totalPages = (int) Math.ceil((double) total / entriesPerPage);
        currentPage = pageNum;
        totalCourses = total;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Management - CourseHub E-Learning</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
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
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: #f093fb;
        }

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
            font-size: 0.8rem;
            margin-top: 0.25rem;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            background: #f093fb;
        }

        .controls {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .search-box {
            flex: 1;
            max-width: 400px;
            position: relative;
        }

        .search-box input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.5rem;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 0.9rem;
            outline: none;
            transition: border-color 0.3s ease;
        }

        .search-box input:focus {
            border-color: #667eea;
        }

        .search-box i {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
        }

        .entries-select {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
        }

        .entries-select select {
            padding: 0.5rem;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            outline: none;
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
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
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.15);
        }

        .course-thumbnail {
            width: 100%;
            height: 200px;
            background-color: #f8f9fa;
            background-size: cover;
            background-position: center;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 16px;
        }

        .course-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .course-status {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: bold;
            text-transform: uppercase;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .course-content {
            padding: 1.5rem;
        }

        .course-title {
            font-size: 1.1rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            font-size: 0.85rem;
            color: #666;
        }

        .course-level {
            background: #e9ecef;
            padding: 0.25rem 0.5rem;
            border-radius: 15px;
            font-size: 0.75rem;
        }

        .course-rating {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            color: #ffc107;
        }

        .course-pricing {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .price-section {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .current-price {
            font-size: 1.2rem;
            font-weight: bold;
            color: #dc3545;
        }

        .original-price {
            font-size: 0.9rem;
            color: #6c757d;
            text-decoration: line-through;
        }

        .learners-count {
            font-size: 0.8rem;
            color: #666;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .no-courses {
            text-align: center;
            padding: 3rem;
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .no-courses i {
            font-size: 3rem;
            color: #ccc;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>
            <i class="fa-solid fa-graduation-cap"></i>
            Course Management
        </h1>
        <div class="user-info">
            <span>Xin chào, Admin</span>
            <i class="fas fa-user-circle"></i>
        </div>
    </div>

    <div class="container">
        <nav class="sidebar">
            <ul>
                <li><a href="/adaptive_elearning/admin_dashboard.jsp" ><i class="fas fa-tachometer-alt"></i> Tổng quan</a></li>
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
            <!-- Statistics Card -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-info">
                        <h3>Tổng số khóa học</h3>
                        <div class="number"><%= stats.getTotalCourses() %></div>
                        <div class="change" style="color: #28a745;">
                            <i class="fas fa-arrow-up"></i> Đang hoạt động
                        </div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                </div>
            </div>

            <!-- Controls -->
            <div class="controls">
                <form method="GET" style="display: flex; gap: 1rem; align-items: center; flex-wrap: wrap; width: 100%;">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" name="search" placeholder="Tìm kiếm khóa học..." value="<%= searchQuery %>" />
                    </div>
                    
                    <div class="entries-select">
                        <span>Hiển thị</span>
                        <select name="entries" onchange="this.form.submit()">
                            <option value="5" <%= entriesPerPage == 5 ? "selected" : "" %>>5</option>
                            <option value="10" <%= entriesPerPage == 10 ? "selected" : "" %>>10</option>
                            <option value="25" <%= entriesPerPage == 25 ? "selected" : "" %>>25</option>
                            <option value="50" <%= entriesPerPage == 50 ? "selected" : "" %>>50</option>
                        </select>
                        <span>mục</span>
                    </div>
                    
                    <input type="hidden" name="page" value="<%= currentPage %>" />
                </form>
            </div>

            <!-- Courses Grid -->
            <% if (courses != null && !courses.isEmpty()) { %>
                <div class="courses-grid">
                    <% for (Course course : courses) { %>
                        <div class="course-card">
                            <div class="course-thumbnail">
                                <% if (course.getThumbUrl() != null && !course.getThumbUrl().isEmpty()) { %>
                                    <img src="<%= course.getThumbUrl() %>" alt="Course Thumbnail" />
                                <% } else { %>
                                    Thumbnail (750x422)
                                <% } %>
                                <div class="course-status <%= "Active".equals(course.getStatus()) ? "status-active" : "status-inactive" %>">
                                    <%= course.getStatus() %>
                                </div>
                            </div>
                            
                            <div class="course-content">
                                <div class="course-title"><%= course.getTitle() %></div>
                                
                                <div class="course-meta">
                                    <span class="course-level"><%= course.getLevel() %></span>
                                    <div class="course-rating">
                                        <i class="fas fa-star"></i>
                                        <span><%= String.format("%.1f", course.getTotalRating()) %></span>
                                    </div>
                                </div>
                                
                                <div class="course-pricing">
                                    <div class="price-section">
                                        <% if (course.getDiscount() > 0) { %>
                                            <span class="current-price"><%= course.getFormattedDiscountedPrice() %></span>
                                            <span class="original-price"><%= course.getFormattedPrice() %></span>
                                        <% } else { %>
                                            <span class="current-price"><%= course.getFormattedPrice() %></span>
                                        <% } %>
                                    </div>
                                    
                                    <div class="learners-count">
                                        <i class="fas fa-users"></i>
                                        <span><%= course.getLearnerCount() %> học viên</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="no-courses">
                    <i class="fas fa-graduation-cap"></i>
                    <h3>Không tìm thấy khóa học nào</h3>
                    <p>Thử thay đổi từ khóa tìm kiếm hoặc làm mới trang.</p>
                </div>
            <% } %>
        </main>
    </div>

    <script>
        // Auto submit search form when typing
        let searchTimeout;
        const searchInput = document.querySelector('input[name="search"]');
        if (searchInput) {
            searchInput.addEventListener('input', function() {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    this.form.submit();
                }, 500);
            });
        }
    </script>
</body>
</html>