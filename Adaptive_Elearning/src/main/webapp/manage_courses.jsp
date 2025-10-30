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
    
    if (courses == null) courses = new java.util.ArrayList<>();
    
    NumberFormat formatter = NumberFormat.getInstance(new Locale("vi", "VN"));
    
    String successMsg = (String) session.getAttribute("successMsg");
    if (successMsg != null) {
        session.removeAttribute("successMsg");
    }
    
    String errorMsg = (String) session.getAttribute("errorMsg");
    if (errorMsg != null) {
        session.removeAttribute("errorMsg");
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Courses - Instructor Dashboard</title>
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .page-title {
            font-size: 32px;
            font-weight: 600;
            color: #333;
        }
        
        .btn-create {
            background: #2196F3;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .btn-create:hover {
            background: #1976D2;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(33, 150, 243, 0.4);
        }
        
        /* Success Alert */
        .alert-success {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #4CAF50;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Error Alert */
        .alert-error {
            background: #ffebee;
            color: #c62828;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #f44336;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Table Container */
        .table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        thead {
            background: #f8f9fa;
        }
        
        th {
            padding: 15px 20px;
            text-align: left;
            font-size: 13px;
            font-weight: 600;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        td {
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }
        
        tbody tr:hover {
            background: #f9fafb;
        }
        
        .course-title-cell {
            max-width: 300px;
        }
        
        .course-title-link {
            color: #2196F3;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
        }
        
        .course-title-link:hover {
            text-decoration: underline;
        }
        
        .course-image {
            width: 80px;
            height: 60px;
            object-fit: cover;
            border-radius: 6px;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-ongoing {
            background: #e8f5e9;
            color: #4CAF50;
        }
        
        .status-draft {
            background: #fff3e0;
            color: #FF9800;
        }
        
        .price-cell {
            font-weight: 600;
            color: #333;
        }
        
        .level-cell {
            color: #666;
        }
        
        .learner-count {
            text-align: center;
            font-weight: 500;
        }
        
        .rating-cell {
            text-align: center;
        }
        
        .rating-value {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
            color: #FF9800;
            font-weight: 500;
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
            margin-bottom: 10px;
            color: #666;
        }
        
        .empty-state p {
            color: #999;
            margin-bottom: 25px;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }
            
            .main-content {
                margin-left: 0;
                padding: 20px;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .table-container {
                overflow-x: auto;
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
                <h1 class="page-title">Manage Courses</h1>
                <button class="btn-create" onclick="window.location.href='<%= request.getContextPath() %>/create-course'">
                    <i class="fas fa-plus"></i>
                    <span>Create a new course</span>
                </button>
            </div>
            
            <!-- Success Message -->
            <% if (successMsg != null) { %>
                <div class="alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span><%= successMsg %></span>
                </div>
            <% } %>
            
            <!-- Error Message -->
            <% if (errorMsg != null) { %>
                <div class="alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= errorMsg %></span>
                </div>
            <% } %>
            
            <!-- Courses Table -->
            <div class="table-container">
                <% if (courses.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="fas fa-book-open"></i>
                        <h3>No courses yet</h3>
                        <p>Create your first course to start teaching</p>
                        <button class="btn-create" onclick="window.location.href='<%= request.getContextPath() %>/create-course'">
                            <i class="fas fa-plus"></i>
                            <span>Create a new course</span>
                        </button>
                    </div>
                <% } else { %>
                    <table>
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Image</th>
                                <th>Status</th>
                                <th>Price</th>
                                <th>Discount</th>
                                <th>Discount Expiry</th>
                                <th>Level</th>
                                <th>LearnerCount</th>
                                <th>Average Rating</th>
                                <th>Category</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (CourseInfo course : courses) { 
                                String statusClass = "Ongoing".equalsIgnoreCase(course.getStatus()) ? "status-ongoing" : "status-draft";
                            %>
                                <tr>
                                    <td class="course-title-cell">
                                        <a href="<%= request.getContextPath() %>/course-detail?id=<%= course.getId() %>" 
                                           class="course-title-link">
                                            <%= course.getTitle() %>
                                        </a>
                                    </td>
                                    <td>
                                        <img src="<%= course.getThumbUrl() %>" 
                                             alt="<%= course.getTitle() %>" 
                                             class="course-image"
                                             onerror="this.src='<%= request.getContextPath() %>/assets/images/course-placeholder.jpg'">
                                    </td>
                                    <td>
                                        <span class="status-badge <%= statusClass %>">
                                            <%= course.getStatus() %>
                                        </span>
                                    </td>
                                    <td class="price-cell">
                                        <%= formatter.format(course.getPrice()) %>đ
                                    </td>
                                    <td>
                                        <%= course.getDiscount() > 0 ? formatter.format(course.getDiscount()) + "đ" : "-" %>
                                    </td>
                                    <td>
                                        <%= course.getDiscountExpiry() != null ? course.getDiscountExpiry() : "-" %>
                                    </td>
                                    <td class="level-cell">
                                        <%= course.getLevel() %>
                                    </td>
                                    <td class="learner-count">
                                        <%= course.getLearnerCount() %>
                                    </td>
                                    <td class="rating-cell">
                                        <div class="rating-value">
                                            <i class="fas fa-star"></i>
                                            <span><%= String.format("%.2f", course.getRating()) %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <%= course.getCategoryTitle() != null ? course.getCategoryTitle() : "-" %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>
