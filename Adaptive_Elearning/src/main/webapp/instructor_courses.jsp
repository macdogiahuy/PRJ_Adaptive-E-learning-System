<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="servlet.InstructorCoursesServlet.CourseInfo"%>
<%@page import="java.util.List"%>
<%@page import="model.Users"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>

<%
    Users user = (Users) session.getAttribute("account");
    if (user == null || !"Instructor".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<CourseInfo> courses = (List<CourseInfo>) request.getAttribute("courses");
    Integer totalCourses = (Integer) request.getAttribute("totalCourses");
    Integer activeCourses = (Integer) request.getAttribute("activeCourses");
    Integer draftCourses = (Integer) request.getAttribute("draftCourses");
    Integer totalStudents = (Integer) request.getAttribute("totalStudents");
    
    if (courses == null) courses = new java.util.ArrayList<>();
    if (totalCourses == null) totalCourses = 0;
    if (activeCourses == null) activeCourses = 0;
    if (draftCourses == null) draftCourses = 0;
    if (totalStudents == null) totalStudents = 0;
    
    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khóa Học Của Tôi - Instructor Dashboard</title>
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
        
        /* Layout */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar */
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
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }
        
        .stat-icon.blue { background: #e3f2fd; color: #2196F3; }
        .stat-icon.green { background: #e8f5e9; color: #4CAF50; }
        .stat-icon.orange { background: #fff3e0; color: #FF9800; }
        .stat-icon.purple { background: #f3e5f5; color: #9C27B0; }
        
        .stat-info h3 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .stat-info p {
            font-size: 13px;
            color: #666;
        }
        
        /* Action Bar */
        .action-bar {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .search-box {
            flex: 1;
            max-width: 400px;
            position: relative;
        }
        
        .search-box input {
            width: 100%;
            padding: 10px 15px 10px 40px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }
        
        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }
        
        .filter-group {
            display: flex;
            gap: 10px;
        }
        
        .filter-btn {
            padding: 10px 15px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .filter-btn:hover {
            border-color: #2196F3;
            color: #2196F3;
        }
        
        .btn-primary {
            background: #2196F3;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-primary:hover {
            background: #1976D2;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(33, 150, 243, 0.4);
        }
        
        /* Courses Grid */
        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
        }
        
        .course-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        
        .course-thumbnail {
            width: 100%;
            height: 180px;
            object-fit: cover;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .course-body {
            padding: 20px;
        }
        
        .course-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 10px;
        }
        
        .course-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .status-active {
            background: #e8f5e9;
            color: #4CAF50;
        }
        
        .status-draft {
            background: #fff3e0;
            color: #FF9800;
        }
        
        .status-inactive {
            background: #ffebee;
            color: #f44336;
        }
        
        .course-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 10px;
            color: #1e3c72;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .course-meta {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
            font-size: 13px;
            color: #666;
        }
        
        .course-meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .course-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #f0f0f0;
        }
        
        .course-price {
            font-size: 20px;
            font-weight: 700;
            color: #2196F3;
        }
        
        .course-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn-icon {
            width: 35px;
            height: 35px;
            border-radius: 8px;
            border: 1px solid #ddd;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-icon:hover {
            border-color: #2196F3;
            color: #2196F3;
            background: #f0f7ff;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 12px;
        }
        
        .empty-state i {
            font-size: 64px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            font-size: 20px;
            margin-bottom: 10px;
            color: #333;
        }
        
        .empty-state p {
            color: #666;
            margin-bottom: 25px;
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
            
            .action-bar {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-box {
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                
                <div class="logo">
                     <a href="<%= request.getContextPath() %>/" class="logo">
                    <i class="fas fa-graduation-cap"></i>
                    
                    <span>FlyUp Instructor</span>
                </div>
            </div>
            
            <nav>
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a href="<%= request.getContextPath() %>/instructor_dashboard.jsp" class="nav-link">
                            <i class="fas fa-home"></i>
                            <span class="nav-text">Tổng quan</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="<%= request.getContextPath() %>/instructor-courses" class="nav-link active">
                            <i class="fas fa-book"></i>
                            <span class="nav-text">Tạo Khóa Học Mới</span>
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
        
        <!-- Main Content -->
        <main class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1 class="page-title">Khóa Học Của Tôi</h1>
                <p class="page-subtitle">Quản lý và theo dõi tất cả các khóa học bạn đang giảng dạy</p>
            </div>
            
            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon blue">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= totalCourses %></h3>
                        <p>Tổng khóa học</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon green">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= activeCourses %></h3>
                        <p>Đang hoạt động</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon orange">
                        <i class="fas fa-edit"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= draftCourses %></h3>
                        <p>Bản nháp</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon purple">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= formatter.format(totalStudents) %></h3>
                        <p>Tổng học viên</p>
                    </div>
                </div>
            </div>
            
            <!-- Action Bar -->
            <div class="action-bar">
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" placeholder="Tìm kiếm khóa học..." id="searchInput">
                </div>
                
                <div class="filter-group">
                    <select class="filter-btn" id="statusFilter">
                        <option value="all">Tất cả trạng thái</option>
                        <option value="Active">Đang hoạt động</option>
                        <option value="Draft">Bản nháp</option>
                        <option value="Inactive">Không hoạt động</option>
                    </select>
                    
                    <select class="filter-btn" id="sortFilter">
                        <option value="newest">Mới nhất</option>
                        <option value="oldest">Cũ nhất</option>
                        <option value="popular">Phổ biến nhất</option>
                        <option value="rating">Đánh giá cao</option>
                    </select>
                </div>
                
                <button class="btn-primary" onclick="window.location.href='<%= request.getContextPath() %>/create-course'">
                    <i class="fas fa-plus"></i>
                    <span>Tạo khóa học mới</span>
                </button>
            </div>
            
            <!-- Courses Grid -->
            <% if (courses.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-book-open"></i>
                    <h3>Chưa có khóa học nào</h3>
                    <p>Bắt đầu tạo khóa học đầu tiên của bạn để chia sẻ kiến thức với học viên</p>
                    <button class="btn-primary" onclick="window.location.href='<%= request.getContextPath() %>/create-course'">
                        <i class="fas fa-plus"></i>
                        <span>Tạo khóa học đầu tiên</span>
                    </button>
                </div>
            <% } else { %>
                <div class="courses-grid" id="coursesGrid">
                    <% for (CourseInfo course : courses) { 
                        String statusClass = "status-draft";
                        String statusText = "Bản nháp";
                        
                        if ("Active".equalsIgnoreCase(course.status)) {
                            statusClass = "status-active";
                            statusText = "Hoạt động";
                        } else if ("Inactive".equalsIgnoreCase(course.status)) {
                            statusClass = "status-inactive";
                            statusText = "Tạm dừng";
                        }
                    %>
                        <div class="course-card" data-status="<%= course.status %>" data-title="<%= course.title.toLowerCase() %>">
                            <% if (course.thumbUrl != null && !course.thumbUrl.isEmpty()) { %>
                                <img src="<%= course.thumbUrl %>" alt="<%= course.title %>" class="course-thumbnail">
                            <% } else { %>
                                <div class="course-thumbnail"></div>
                            <% } %>
                            
                            <div class="course-body">
                                <div class="course-header">
                                    <span class="course-status <%= statusClass %>"><%= statusText %></span>
                                </div>
                                
                                <h3 class="course-title"><%= course.title %></h3>
                                
                                <div class="course-meta">
                                    <div class="course-meta-item">
                                        <i class="fas fa-users"></i>
                                        <span><%= course.learnerCount %> học viên</span>
                                    </div>
                                    <div class="course-meta-item">
                                        <i class="fas fa-star"></i>
                                        <span><%= String.format("%.1f", course.rating) %> (<%= course.reviewCount %>)</span>
                                    </div>
                                </div>
                                
                                <div class="course-footer">
                                    <div class="course-price">
                                        <%= formatter.format(course.price) %> đ
                                    </div>
                                    
                                    <div class="course-actions">
                                        <button class="btn-icon" title="Chỉnh sửa" onclick="editCourse('<%= course.id %>')">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn-icon" title="Xem chi tiết" onclick="viewCourse('<%= course.id %>')">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn-icon" title="Thống kê" onclick="viewStats('<%= course.id %>')">
                                            <i class="fas fa-chart-bar"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </main>
    </div>
    
    <script>
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            filterCourses();
        });
        
        // Filter functionality
        document.getElementById('statusFilter').addEventListener('change', filterCourses);
        document.getElementById('sortFilter').addEventListener('change', sortCourses);
        
        function filterCourses() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            const cards = document.querySelectorAll('.course-card');
            
            cards.forEach(card => {
                const title = card.getAttribute('data-title');
                const status = card.getAttribute('data-status');
                
                const matchesSearch = title.includes(searchTerm);
                const matchesStatus = statusFilter === 'all' || status === statusFilter;
                
                if (matchesSearch && matchesStatus) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
        
        function sortCourses() {
            // TODO: Implement sorting
            const sortValue = document.getElementById('sortFilter').value;
            console.log('Sorting by:', sortValue);
        }
        
        function editCourse(courseId) {
            window.location.href = '<%= request.getContextPath() %>/edit-course?id=' + courseId;
        }
        
        function viewCourse(courseId) {
            window.location.href = '<%= request.getContextPath() %>/course-detail?id=' + courseId;
        }
        
        function viewStats(courseId) {
            window.location.href = '<%= request.getContextPath() %>/course-analytics?id=' + courseId;
        }
    </script>
</body>
</html>
