<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Users"%>
<%@page import="model.Courses"%>
<%@page import="model.Categories"%>
<%@page import="java.util.List"%>
<%@page import="java.text.DecimalFormat"%>

<%
    Users user = (Users) session.getAttribute("account");
    if (user == null || (!("Instructor".equalsIgnoreCase(user.getRole()) || "Admin".equalsIgnoreCase(user.getRole())))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Courses> courses = (List<Courses>) request.getAttribute("courses");
    @SuppressWarnings("unchecked")
    List<Categories> categories = (List<Categories>) request.getAttribute("categories");
    Integer totalCourses = (Integer) request.getAttribute("totalCourses");
    
    DecimalFormat df = new DecimalFormat("#,###");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Khóa học - Instructor Dashboard</title>
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
        
        /* Main Content */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 30px;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .page-title-section h1 {
            font-size: 28px;
            font-weight: 700;
            color: #1e3c72;
            margin-bottom: 5px;
        }
        
        .page-subtitle {
            color: #666;
            font-size: 14px;
        }
        
        .btn {
            padding: 12px 24px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
        }
        
        /* Stats Cards */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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
        
        .stat-info h3 {
            font-size: 24px;
            font-weight: 700;
            color: #1e3c72;
        }
        
        .stat-info p {
            font-size: 13px;
            color: #666;
        }
        
        /* Filters */
        .filters-section {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }
        
        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .filter-group label {
            font-size: 13px;
            font-weight: 600;
            color: #555;
        }
        
        .filter-group input,
        .filter-group select {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .filter-group input:focus,
        .filter-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        /* Courses Table */
        .courses-section {
            background: white;
            border-radius: 12px;
            padding: 25px;
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
        
        .courses-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .courses-table thead {
            background: #f8f9fa;
        }
        
        .courses-table th {
            padding: 15px;
            text-align: left;
            font-size: 13px;
            font-weight: 600;
            color: #555;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .courses-table td {
            padding: 15px;
            border-top: 1px solid #f0f0f0;
            vertical-align: middle;
        }
        
        .courses-table tbody tr {
            transition: all 0.3s;
        }
        
        .courses-table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .course-thumb {
            width: 80px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .course-title {
            font-weight: 600;
            color: #1e3c72;
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .badge-ongoing { background: #e3f2fd; color: #2196F3; }
        .badge-completed { background: #e8f5e9; color: #4CAF50; }
        .badge-draft { background: #fff3e0; color: #FF9800; }
        
        .rating-stars {
            color: #ffc107;
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        
        .btn-icon {
            width: 35px;
            height: 35px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
        }
        
        .btn-view { background: #e3f2fd; color: #2196F3; }
        .btn-edit { background: #fff3e0; color: #FF9800; }
        .btn-delete { background: #ffebee; color: #f44336; }
        
        .btn-icon:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        
        .empty-state i {
            font-size: 64px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            font-size: 20px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            color: #999;
            margin-bottom: 20px;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
            
            .page-header {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
            }
            
            .courses-table {
                display: block;
                overflow-x: auto;
            }
            
            .stats-row {
                grid-template-columns: 1fr;
            }
        }
        
        /* Success Message */
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideInDown 0.4s ease-out;
        }
        
        .alert-success {
            background: #e8f5e9;
            color: #2e7d32;
            border-left: 4px solid #4CAF50;
        }
        
        .alert-error {
            background: #ffebee;
            color: #c62828;
            border-left: 4px solid #f44336;
        }
        
        .alert.fade-out {
            animation: fadeOut 0.4s ease-out forwards;
        }
        
        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes fadeOut {
            from {
                opacity: 1;
                transform: translateY(0);
            }
            to {
                opacity: 0;
                transform: translateY(-20px);
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
                <div class="page-title-section">
                    <h1>Quản lý Khóa học</h1>
                    <p class="page-subtitle">Tạo và quản lý các khóa học của bạn</p>
                </div>
                <a href="<%= request.getContextPath() %>/instructor-courses/create" class="btn btn-primary">
                    <i class="fas fa-plus"></i>
                    Tạo khóa học mới
                </a>
            </div>
            
            <!-- Success/Error Messages -->
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success" id="successAlert">
                    <i class="fas fa-check-circle"></i>
                    <% if ("created".equals(request.getParameter("success"))) { %>
                        Khóa học đã được tạo thành công!
                    <% } else if ("updated".equals(request.getParameter("success"))) { %>
                        Khóa học đã được cập nhật thành công!
                    <% } else if ("deleted".equals(request.getParameter("success"))) { %>
                        Khóa học đã được xóa thành công!
                    <% } %>
                </div>
            <% } %>
            
            <!-- Stats Cards -->
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon blue">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= totalCourses != null ? totalCourses : 0 %></h3>
                        <p>Tổng khóa học</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon green">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%
                            int totalStudents = 0;
                            if (courses != null) {
                                for (Courses c : courses) {
                                    totalStudents += c.getLearnerCount();
                                }
                            }
                            out.print(totalStudents);
                        %></h3>
                        <p>Tổng học viên</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon orange">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%
                            double avgRating = 0.0;
                            int ratingCount = 0;
                            if (courses != null) {
                                for (Courses c : courses) {
                                    if (c.getRatingCount() > 0) {
                                        avgRating += (double) c.getTotalRating() / c.getRatingCount();
                                        ratingCount++;
                                    }
                                }
                                if (ratingCount > 0) {
                                    avgRating = avgRating / ratingCount;
                                }
                            }
                            out.print(String.format("%.1f", avgRating));
                        %></h3>
                        <p>Đánh giá trung bình</p>
                    </div>
                </div>
            </div>
            
            <!-- Filters -->
            <div class="filters-section">
                <div class="filters-grid">
                    <div class="filter-group">
                        <label>Tìm kiếm</label>
                        <input type="text" id="searchInput" placeholder="Tìm kiếm khóa học...">
                    </div>
                    <div class="filter-group">
                        <label>Danh mục</label>
                        <select id="categoryFilter">
                            <option value="">Tất cả danh mục</option>
                            <% if (categories != null) {
                                for (Categories cat : categories) { %>
                                    <option value="<%= cat.getId() %>"><%= cat.getTitle() %></option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label>Trạng thái</label>
                        <select id="statusFilter">
                            <option value="">Tất cả trạng thái</option>
                            <option value="Ongoing">Đang diễn ra</option>
                            <option value="Completed">Hoàn thành</option>
                            <option value="Draft">Nháp</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label>Cấp độ</label>
                        <select id="levelFilter">
                            <option value="">Tất cả cấp độ</option>
                            <option value="Beginner">Beginner</option>
                            <option value="Intermediate">Intermediate</option>
                            <option value="Advanced">Advanced</option>
                            <option value="All">All</option>
                        </select>
                    </div>
                </div>
            </div>
            
            <!-- Courses Table -->
            <div class="courses-section">
                <div class="section-header">
                    <h2 class="section-title">Danh sách khóa học (<%= totalCourses != null ? totalCourses : 0 %>)</h2>
                </div>
                
                <% if (courses != null && !courses.isEmpty()) { %>
                    <table class="courses-table">
                        <thead>
                            <tr>
                                <th>Hình ảnh</th>
                                <th>Tiêu đề</th>
                                <th>Trạng thái</th>
                                <th>Giá</th>
                                <th>Giảm giá</th>
                                <th>Cấp độ</th>
                                <th>Học viên</th>
                                <th>Đánh giá</th>
                                <th>Danh mục</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Courses course : courses) { 
                                double rating = course.getRatingCount() > 0 ? 
                                               (double) course.getTotalRating() / course.getRatingCount() : 0.0;
                            %>
                                <tr data-category="<%= course.getLeafCategoryId() != null ? course.getLeafCategoryId().getId() : "" %>" 
                                    data-status="<%= course.getStatus() %>" 
                                    data-level="<%= course.getLevel() %>"
                                    data-title="<%= course.getTitle().toLowerCase() %>">
                                    <td>
                                        <img src="<%= course.getThumbUrl() != null && !course.getThumbUrl().isEmpty() ? 
                                                    course.getThumbUrl() : request.getContextPath() + "/assets/images/default-course.jpg" %>" 
                                             alt="<%= course.getTitle() %>" 
                                             class="course-thumb">
                                    </td>
                                    <td>
                                        <div class="course-title" title="<%= course.getTitle() %>">
                                            <%= course.getTitle() %>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="badge <%= "Ongoing".equals(course.getStatus()) ? "badge-ongoing" : 
                                                               "Completed".equals(course.getStatus()) ? "badge-completed" : 
                                                               "badge-draft" %>">
                                            <%= course.getStatus() %>
                                        </span>
                                    </td>
                                    <td><%= df.format(course.getPrice()) %> VNĐ</td>
                                    <td><%= course.getDiscount() > 0 ? (int)course.getDiscount() + "%" : "-" %></td>
                                    <td><%= course.getLevel() %></td>
                                    <td><%= course.getLearnerCount() %></td>
                                    <td>
                                        <span class="rating-stars">
                                            <% for (int i = 1; i <= 5; i++) { %>
                                                <i class="<%= i <= rating ? "fas" : "far" %> fa-star"></i>
                                            <% } %>
                                        </span>
                                        (<%= String.format("%.1f", rating) %>)
                                    </td>
                                    <td><%= course.getLeafCategoryId() != null ? course.getLeafCategoryId().getTitle() : "-" %></td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn-icon btn-view" title="Xem" 
                                                    onclick="viewCourse('<%= course.getId() %>')">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn-icon btn-edit" title="Sửa" 
                                                    onclick="editCourse('<%= course.getId() %>')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn-icon btn-delete" title="Xóa" 
                                                    onclick="deleteCourse('<%= course.getId() %>', '<%= course.getTitle() %>')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-book-open"></i>
                        <h3>Chưa có khóa học nào</h3>
                        <p>Bắt đầu tạo khóa học đầu tiên của bạn!</p>
                        <a href="<%= request.getContextPath() %>/instructor-courses/create" class="btn btn-primary">
                            <i class="fas fa-plus"></i>
                            Tạo khóa học mới
                        </a>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
    
    <script>
        // Auto-hide success alert after 5 seconds
        window.addEventListener('DOMContentLoaded', function() {
            const successAlert = document.getElementById('successAlert');
            
            if (successAlert) {
                setTimeout(function() {
                    successAlert.classList.add('fade-out');
                    setTimeout(function() {
                        successAlert.remove();
                    }, 400);
                }, 5000);
            }
        });
        
        // Search functionality
        document.getElementById('searchInput').addEventListener('keyup', filterCourses);
        document.getElementById('categoryFilter').addEventListener('change', filterCourses);
        document.getElementById('statusFilter').addEventListener('change', filterCourses);
        document.getElementById('levelFilter').addEventListener('change', filterCourses);
        
        function filterCourses() {
            const searchValue = document.getElementById('searchInput').value.toLowerCase();
            const categoryValue = document.getElementById('categoryFilter').value;
            const statusValue = document.getElementById('statusFilter').value;
            const levelValue = document.getElementById('levelFilter').value;
            
            const rows = document.querySelectorAll('.courses-table tbody tr');
            
            rows.forEach(row => {
                const title = row.getAttribute('data-title');
                const category = row.getAttribute('data-category');
                const status = row.getAttribute('data-status');
                const level = row.getAttribute('data-level');
                
                const matchSearch = !searchValue || title.includes(searchValue);
                const matchCategory = !categoryValue || category === categoryValue;
                const matchStatus = !statusValue || status === statusValue;
                const matchLevel = !levelValue || level === levelValue;
                
                if (matchSearch && matchCategory && matchStatus && matchLevel) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
        
        function viewCourse(courseId) {
            window.location.href = '<%= request.getContextPath() %>/instructor-courses/view/' + courseId;
        }
        
        function editCourse(courseId) {
            window.location.href = '<%= request.getContextPath() %>/instructor-courses/edit/' + courseId;
        }
        
        function deleteCourse(courseId, courseTitle) {
            if (confirm('Bạn có chắc chắn muốn xóa khóa học "' + courseTitle + '"?\nHành động này không thể hoàn tác!')) {
                fetch('<%= request.getContextPath() %>/instructor-courses', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=delete&courseId=' + courseId
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        window.location.href = '<%= request.getContextPath() %>/instructor-courses?success=deleted';
                    } else {
                        alert('Lỗi: ' + data.message);
                    }
                })
                .catch(error => {
                    alert('Có lỗi xảy ra khi xóa khóa học');
                    console.error('Error:', error);
                });
            }
        }
    </script>
</body>
</html>
