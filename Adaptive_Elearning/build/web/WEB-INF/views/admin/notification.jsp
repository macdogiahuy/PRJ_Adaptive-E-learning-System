<%@page import="controller.NotificationController"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Get parameters
    String pageParam = request.getParameter("page");
    String searchType = request.getParameter("type");
    String entriesParam = request.getParameter("entries");
    
    int currentPage = 1;
    if (pageParam != null && !pageParam.trim().isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    int recordsPerPage = 10; // default
    if (entriesParam != null && !entriesParam.trim().isEmpty()) {
        try {
            int entries = Integer.parseInt(entriesParam);
            if (entries == 5 || entries == 7 || entries == 10) {
                recordsPerPage = entries;
            }
        } catch (NumberFormatException e) {
            recordsPerPage = 10;
        }
    }
    
    if (searchType == null) {
        searchType = "";
    }
    
    // Initialize variables
    Map<String, Object> notificationData = null;
    List<String> notificationTypes = null;
    String error = null;
    
    // Load data using NotificationController
    try {
        NotificationController controller = new NotificationController();
        
        // Test connection first
        if (controller.testDatabaseConnection()) {
            // Load notifications with pagination and search
            notificationData = controller.getNotifications(currentPage, searchType, recordsPerPage);
            notificationTypes = controller.getNotificationTypes();
        } else {
            error = "Không thể kết nối tới database CourseHubDB";
        }
    } catch (Exception e) {
        e.printStackTrace();
        error = "Lỗi: " + e.getMessage();
    }
    
    // Set default values if data loading failed
    if (notificationData == null) {
        notificationData = new java.util.HashMap<>();
        notificationData.put("notifications", new ArrayList<>());
        notificationData.put("currentPage", 1);
        notificationData.put("totalPages", 0);
        notificationData.put("totalRecords", 0);
        notificationData.put("recordsPerPage", recordsPerPage);
    }
    
    if (notificationTypes == null) {
        notificationTypes = new ArrayList<>();
    }
    
    // Extract data for easy access
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> notifications = (List<Map<String, Object>>) notificationData.get("notifications");
    
    int totalPages = (Integer) notificationData.get("totalPages");
    int totalRecords = (Integer) notificationData.get("totalRecords");
    
    // Date formatter
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
%>
<%
    // Handle POST requests for status updates
    String action = request.getParameter("action");
    if ("updateStatus".equals(action)) {
        String notificationIdParam = request.getParameter("notificationId");
        String newStatus = request.getParameter("newStatus");
        
        if (notificationIdParam != null && newStatus != null) {
            try {
                controller.NotificationController controller = new controller.NotificationController();
                
                boolean success = controller.updateNotificationStatus(notificationIdParam, newStatus);
                if (success) {
                    // Redirect back with success message
                    response.sendRedirect("notification.jsp?updated=success");
                    return;
                } else {
                    // Redirect back with error message
                    response.sendRedirect("notification.jsp?updated=error");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("notification.jsp?updated=error");
                return;
            }
        }
    }
    

%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications - CourseHub E-Learning</title>
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
            padding: 0;
        }

        .sidebar li {
            margin-bottom: 0.5rem;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem 2rem;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .sidebar a:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .sidebar a.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-right: 3px solid #fff;
        }

        .main-content {
            flex: 1;
            padding: 2rem;
            overflow-y: auto;
        }

        .error-message {
            background: #ff6b6b;
            color: white;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .page-header {
            background: rgba(255, 255, 255, 0.95);
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .page-header h2 {
            color: #333;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .search-section {
            background: rgba(255, 255, 255, 0.95);
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .search-form {
            display: flex;
            gap: 1rem;
            align-items: end;
        }

        .form-group {
            flex: 1;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #333;
        }

        .form-group select,
        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-group select:focus,
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
        }

        .btn-success {
            background: #28a745;
            color: white;
            font-size: 0.9rem;
            padding: 0.5rem 1rem;
        }

        .btn-success:hover {
            background: #218838;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
            font-size: 0.9rem;
            padding: 0.5rem 1rem;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .notification-table {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .table-header {
            padding: 1.5rem;
            border-bottom: 1px solid #e1e5e9;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-header h3 {
            color: #333;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .table-stats {
            color: #666;
            font-size: 0.9rem;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e1e5e9;
        }

        th {
            background: #f8f9fa;
            font-weight: 600;
            color: #333;
        }

        tbody tr:hover {
            background: #f8f9fa;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-approved {
            background: #d4edda;
            color: #155724;
        }

        .status-dismissed {
            background: #f8d7da;
            color: #721c24;
        }

        .no-data {
            text-align: center;
            padding: 3rem;
            color: #666;
        }

        .no-data i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .pagination {
            padding: 1.5rem;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            border-top: 1px solid #e1e5e9;
        }

        .pagination a,
        .pagination span {
            padding: 0.5rem 1rem;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .pagination a {
            color: #667eea;
            border: 1px solid #e1e5e9;
        }

        .pagination a:hover {
            background: #667eea;
            color: white;
        }

        .pagination .current {
            background: #667eea;
            color: white;
            border: 1px solid #667eea;
        }

        .pagination .disabled {
            color: #ccc;
            border: 1px solid #f0f0f0;
            cursor: not-allowed;
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                order: 2;
            }

            .main-content {
                order: 1;
            }

            .search-form {
                flex-direction: column;
            }

            .form-group {
                margin-bottom: 1rem;
            }

            .table-container {
                font-size: 0.9rem;
            }

            th, td {
                padding: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <h1>
            <i class="fas fa-bell"></i>
            Notifications - CourseHub E-Learning
        </h1>
        <div class="user-info">
            <span>Xin chào, Admin</span>
            <i class="fas fa-user-circle"></i>
        </div>
    </header>

    <div class="container">
        <nav class="sidebar">
       
                <ul>
                <li><a href="/adaptive_elearning/admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Tổng quan</a></li>
                <li><a href="/adaptive_elearning/admin_notification.jsp"  class="active"><i class="fas fa-bell"></i> Thông báo</a></li>
                <li><a href="/adaptive_elearning/admin_createadmin.jsp"><i class="fas fa-user-plus"></i> Tạo Admin</a></li>
                <li><a href="/adaptive_elearning/admin_accountmanagement.jsp"><i class="fas fa-users"></i> Quản lý Tài Khoản</a></li>
                <li><a href="/adaptive_elearning/admin_reportedcourse.jsp" ><i class="fas fa-flag"></i> Quản lý Khóa Học</a></li>
                  <li><a href="/adaptive_elearning/admin_coursemanagement.jsp"><i class="fa-solid fa-bars-progress"></i> Các Khóa Học</a></li>
                <li><a href="/adaptive_elearning/admin_reportedgroup.jsp"><i class="fas fa-user-graduate"></i> Quản lý Nhóm</a></li>
                <li><a href="#"><i class="fas fa-chart-bar"></i> Home</a></li>
                <li><a href="#"><i class="fas fa-cog"></i> LogOut</a></li>
            </ul>
       
        </nav>

        <main class="main-content">
            <% if (error != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    <%= error %>
                </div>
            <% } %>

            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fas fa-bell"></i> Quản lý Thông báo</h2>
                <p>Quản lý và theo dõi các thông báo trong hệ thống</p>
            </div>

            <!-- Search Section -->
            <div class="search-section">
                <form class="search-form" method="GET" action="admin_notification.jsp">
                    <div class="form-group">
                        <label for="entries">Show:</label>
                        <select name="entries" id="entries" onchange="updateEntries()">
                            <option value="5" <%= recordsPerPage == 5 ? "selected" : "" %>>5 entries</option>
                            <option value="7" <%= recordsPerPage == 7 ? "selected" : "" %>>7 entries</option>
                            <option value="10" <%= recordsPerPage == 10 ? "selected" : "" %>>10 entries</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="type">Lọc theo Type:</label>
                        <select name="type" id="type">
                            <option value="">Tất cả</option>
                            <% for (String type : notificationTypes) { %>
                                <option value="<%= type %>" <%= searchType.equals(type) ? "selected" : "" %>>
                                    <%= type %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                    <input type="hidden" name="page" value="1">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-search"></i> Tìm kiếm
                    </button>
                </form>
            </div>

            <!-- Notifications Table -->
            <div class="notification-table">
                <div class="table-header">
                    <h3><i class="fas fa-list"></i> Danh sách Thông báo</h3>
                    <div class="table-stats">
                        Hiển thị <%= notifications.size() %> trên tổng <%= totalRecords %> thông báo (Showing <%= recordsPerPage %> entries per page)
                    </div>
                </div>

                <div class="table-container">
                    <% if (notifications.isEmpty()) { %>
                        <div class="no-data">
                            <i class="fas fa-inbox"></i>
                            <p>Không có thông báo nào</p>
                        </div>
                    <% } else { %>
                        <table>
                            <thead>
                                <tr>
                                    <th>Type</th>
                                    <th>Creator Id</th>
                                    <th>Creation Time</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Map<String, Object> notification : notifications) { 
                                    String status = (String) notification.get("status");
                                    String statusClass = "status-pending";
                                    if ("Approved".equals(status)) {
                                        statusClass = "status-approved";
                                    } else if ("Dismissed".equals(status)) {
                                        statusClass = "status-dismissed";
                                    }
                                %>
                                <tr>
                                    <td><%= notification.get("type") %></td>
                                    <td><%= notification.get("creatorId") %></td>
                                    <td>
                                        <% if (notification.get("creationTime") != null) { %>
                                            <%= dateFormat.format(notification.get("creationTime")) %>
                                        <% } else { %>
                                            N/A
                                        <% } %>
                                    </td>
                                    <td>
                                        <span class="status-badge <%= statusClass %>">
                                            <%= status != null ? status : "Pending" %>
                                        </span>
                                    </td>
                                    <td>
                                        <% 
                                        String notificationId = (String) notification.get("id");
                                        if (!"Approved".equals(status)) { %>
                                            <button class="btn btn-success" onclick="updateStatus('<%= notificationId %>', 'Approved')">
                                                <i class="fas fa-check"></i> Approve
                                            </button>
                                        <% } %>
                                        <% if (!"Dismissed".equals(status)) { %>
                                            <button class="btn btn-danger" onclick="updateStatus('<%= notificationId %>', 'Dismissed')">
                                                <i class="fas fa-times"></i> Dismiss
                                            </button>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>

                <!-- Pagination -->
                <% if (totalPages > 1) { %>
                    <div class="pagination">
                        <% if (currentPage > 1) { %>
                            <a href="?page=<%= currentPage - 1 %>&type=<%= searchType %>&entries=<%= recordsPerPage %>">
                                <i class="fas fa-chevron-left"></i> Previous
                            </a>
                        <% } else { %>
                            <span class="disabled">
                                <i class="fas fa-chevron-left"></i> Previous
                            </span>
                        <% } %>

                        <% 
                        int startPage = Math.max(1, currentPage - 2);
                        int endPage = Math.min(totalPages, currentPage + 2);
                        
                        for (int i = startPage; i <= endPage; i++) { %>
                            <% if (i == currentPage) { %>
                                <span class="current"><%= i %></span>
                            <% } else { %>
                                <a href="?page=<%= i %>&type=<%= searchType %>&entries=<%= recordsPerPage %>"><%= i %></a>
                            <% } %>
                        <% } %>

                        <% if (currentPage < totalPages) { %>
                            <a href="?page=<%= currentPage + 1 %>&type=<%= searchType %>&entries=<%= recordsPerPage %>">
                                Next <i class="fas fa-chevron-right"></i>
                            </a>
                        <% } else { %>
                            <span class="disabled">
                                Next <i class="fas fa-chevron-right"></i>
                            </span>
                        <% } %>
                    </div>
                <% } %>
            </div>
        </main>
    </div>

    <script>
        function updateStatus(notificationId, status) {
            if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái này?')) {
                // Create form to submit POST request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '/adaptive_elearning/notification.jsp';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'notificationId';
                idInput.value = notificationId;
                
                const statusInput = document.createElement('input');
                statusInput.type = 'hidden';
                statusInput.name = 'newStatus';
                statusInput.value = status;
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'updateStatus';
                
                form.appendChild(idInput);
                form.appendChild(statusInput);
                form.appendChild(actionInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function updateEntries() {
            const entriesSelect = document.getElementById('entries');
            const typeSelect = document.getElementById('type');
            const selectedEntries = entriesSelect.value;
            const selectedType = typeSelect.value;
            
            // Redirect with new entries parameter
            const url = 'admin_notification.jsp?page=1&entries=' + selectedEntries + '&type=' + encodeURIComponent(selectedType);
            window.location.href = url;
        }
    </script>
</body>
</html>