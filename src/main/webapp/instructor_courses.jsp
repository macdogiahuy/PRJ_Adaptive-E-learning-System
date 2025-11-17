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
        
        /* Keyframe Animations */
        @keyframes pulse-glow {
            0%, 100% {
                box-shadow: 0 0 0 0 rgba(102, 126, 234, 0.7);
            }
            50% {
                box-shadow: 0 0 0 8px rgba(102, 126, 234, 0);
            }
        }
        
        @keyframes shine {
            0% {
                transform: translateX(-100%) translateY(-100%) rotate(30deg);
            }
            100% {
                transform: translateX(100%) translateY(100%) rotate(30deg);
            }
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
        .badge-off { background: #ffebee; color: #f44336; }
        
        .approval-badge {
            display: inline-flex;
            align-items: center;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            gap: 5px;
        }
        
        .approval-badge i {
            font-size: 13px;
        }
        
        .approval-cell {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .approval-pending { background: #fff3cd; color: #856404; }
        .approval-approved { background: #d4edda; color: #155724; }
        .approval-rejected { 
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
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
        
        .btn-view { 
            background: #e53434;
            color: #fff;
            border: none;
            font-weight: 500;
            position: relative;
            overflow: hidden;
            animation: pulse-glow 2s ease-in-out infinite;
        }
        
        .btn-view::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }
        
        .btn-view::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(
                90deg,
                transparent,
                rgba(255, 255, 255, 0.3),
                transparent
            );
            transform: translateX(-100%) translateY(-100%) rotate(30deg);
        }
        
        .btn-view:hover::after {
            animation: shine 0.8s ease-in-out;
        }
        
        .btn-view:hover::before {
            width: 300px;
            height: 300px;
        }
        
        .btn-view i {
            position: relative;
            z-index: 1;
            font-size: 15px;
        }
        
        .btn-edit { background: #fff3e0; color: #FF9800; }
        .btn-delete { background: #ffebee; color: #f44336; }
        
        .btn-icon:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        
        .btn-view:hover {
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
            animation: none;
            transform: translateY(-3px) scale(1.05);
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
                                <th>Phê duyệt</th>
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
                                        <span class="badge <%= "ongoing".equalsIgnoreCase(course.getStatus()) ? "badge-ongoing" : 
                                                               "completed".equalsIgnoreCase(course.getStatus()) ? "badge-completed" :
                                                               "off".equalsIgnoreCase(course.getStatus()) ? "badge-off" :
                                                               "badge-draft" %>">
                                            <%= course.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <%
                                            String approvalStatus = "pending"; // Default
                                            String rejectionReason = "";
                                            try {
                                                // Try to get approval status using reflection (will work after adding fields)
                                                java.lang.reflect.Method getApprovalStatus = course.getClass().getMethod("getApprovalStatus");
                                                approvalStatus = (String) getApprovalStatus.invoke(course);
                                                if (approvalStatus == null) approvalStatus = "pending";
                                            } catch (Exception e) {
                                                // Field not yet added, use default
                                            }
                                            
                                            try {
                                                java.lang.reflect.Method getRejectionReason = course.getClass().getMethod("getRejectionReason");
                                                rejectionReason = (String) getRejectionReason.invoke(course);
                                                if (rejectionReason == null) rejectionReason = "";
                                            } catch (Exception e) {
                                                // Field not yet added
                                            }
                                        %>
                                        <div class="approval-cell">
                                            <span class="approval-badge <%= "approved".equalsIgnoreCase(approvalStatus) ? "approval-approved" : 
                                                                             "rejected".equalsIgnoreCase(approvalStatus) ? "approval-rejected" :
                                                                             "approval-pending" %>">
                                                <% if ("approved".equalsIgnoreCase(approvalStatus)) { %>
                                                    <i class="fas fa-check-circle"></i> Đã duyệt
                                                <% } else if ("rejected".equalsIgnoreCase(approvalStatus)) { %>
                                                    <i class="fas fa-times-circle"></i> Từ chối
                                                <% } else { %>
                                                    <i class="fas fa-clock"></i> Chờ duyệt
                                                <% } %>
                                            </span>
                                            <% if ("rejected".equalsIgnoreCase(approvalStatus) && rejectionReason != null && !rejectionReason.isEmpty()) { %>
                                                <button class="btn-icon btn-view" title="Xem lý do từ chối" 
                                                        data-course-title="<%= course.getTitle().replace("\"", "&quot;") %>"
                                                        data-rejection-reason="<%= rejectionReason.replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>"
                                                        onclick="showRejectionReasonModal(this)">
                                                    <i class="fas fa-info-circle"></i>
                                                </button>
                                            <% } %>
                                        </div>
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
        
        // Rejection Reason Modal
        function showRejectionReasonModal(button) {
            const courseTitle = button.getAttribute('data-course-title');
            const rejectionReason = button.getAttribute('data-rejection-reason');
            
            // Decode HTML entities
            const decodeHTML = (html) => {
                const txt = document.createElement('textarea');
                txt.innerHTML = html;
                return txt.value;
            };
            
            const decodedTitle = decodeHTML(courseTitle || '');
            const decodedReason = decodeHTML(rejectionReason || 'Không có lý do cụ thể');
            
            const modal = document.createElement('div');
            modal.className = 'rejection-modal';
            modal.innerHTML = `
                <div class="rejection-modal-overlay"></div>
                <div class="rejection-modal-content">
                    <div class="rejection-modal-header">
                        <h3><i class="fas fa-times-circle"></i> Lý do từ chối khóa học</h3>
                        <button class="rejection-close-btn">×</button>
                    </div>
                    <div class="rejection-modal-body">
                        <div class="rejection-course-title">
                            <strong>Khóa học:</strong> <span class="course-title-text"></span>
                        </div>
                        <div class="rejection-reason-box">
                            <strong>Lý do từ chối:</strong>
                            <p class="rejection-reason-text"></p>
                        </div>
                    </div>
                    <div class="rejection-modal-footer">
                        <button class="btn-modal-close">
                            <i class="fas fa-times"></i> Đóng
                        </button>
                    </div>
                </div>
            `;
            
            // Set text content safely
            modal.querySelector('.course-title-text').textContent = decodedTitle;
            modal.querySelector('.rejection-reason-text').textContent = decodedReason;
            
            // Add event listeners
            modal.querySelector('.rejection-modal-overlay').addEventListener('click', () => modal.remove());
            modal.querySelector('.rejection-close-btn').addEventListener('click', () => modal.remove());
            modal.querySelector('.btn-modal-close').addEventListener('click', () => modal.remove());
            
            document.body.appendChild(modal);
            
            // Add modal styles if not exist
            if (!document.getElementById('rejectionModalStyles')) {
                const style = document.createElement('style');
                style.id = 'rejectionModalStyles';
                style.textContent = `
                    .rejection-modal {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        z-index: 10000;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        animation: fadeIn 0.3s;
                    }
                    
                    @keyframes fadeIn {
                        from { opacity: 0; }
                        to { opacity: 1; }
                    }
                    
                    .rejection-modal-overlay {
                        position: absolute;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.6);
                        backdrop-filter: blur(5px);
                    }
                    
                    .rejection-modal-content {
                        position: relative;
                        background: white;
                        border-radius: 15px;
                        max-width: 600px;
                        width: 90%;
                        max-height: 80vh;
                        overflow-y: auto;
                        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                        animation: slideUp 0.3s;
                    }
                    
                    @keyframes slideUp {
                        from {
                            transform: translateY(50px);
                            opacity: 0;
                        }
                        to {
                            transform: translateY(0);
                            opacity: 1;
                        }
                    }
                    
                    .rejection-modal-header {
                        padding: 25px;
                        border-bottom: 2px solid #f0f0f0;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }
                    
                    .rejection-modal-header h3 {
                        margin: 0;
                        color: #dc3545;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        font-size: 1.3rem;
                    }
                    
                    .rejection-close-btn {
                        background: none;
                        border: none;
                        font-size: 2rem;
                        color: #999;
                        cursor: pointer;
                        line-height: 1;
                        transition: color 0.3s;
                    }
                    
                    .rejection-close-btn:hover {
                        color: #333;
                    }
                    
                    .rejection-modal-body {
                        padding: 25px;
                    }
                    
                    .rejection-course-title {
                        margin-bottom: 20px;
                        padding: 15px;
                        background: #f8f9fa;
                        border-radius: 10px;
                        color: #333;
                    }
                    
                    .rejection-reason-box {
                        padding: 20px;
                        background: #fff3cd;
                        border-left: 4px solid #ffc107;
                        border-radius: 8px;
                    }
                    
                    .rejection-reason-box strong {
                        display: block;
                        margin-bottom: 10px;
                        color: #856404;
                        font-size: 1rem;
                    }
                    
                    .rejection-reason-box p {
                        margin: 0;
                        color: #856404;
                        line-height: 1.6;
                        white-space: pre-wrap;
                    }
                    
                    .rejection-modal-footer {
                        padding: 20px 25px;
                        border-top: 2px solid #f0f0f0;
                        text-align: right;
                    }
                    
                    .btn-modal-close {
                        padding: 10px 25px;
                        background: #6c757d;
                        color: white;
                        border: none;
                        border-radius: 8px;
                        cursor: pointer;
                        font-weight: 600;
                        transition: all 0.3s;
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                    }
                    
                    .btn-modal-close:hover {
                        background: #5a6268;
                        transform: translateY(-2px);
                    }
                `;
                document.head.appendChild(style);
            }
        }
    </script>
</body>
</html>
