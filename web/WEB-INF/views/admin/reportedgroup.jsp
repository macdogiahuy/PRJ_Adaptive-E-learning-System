<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%
    Map<String, Object> result = (Map<String, Object>) request.getAttribute("result");
    Map<String, Object> statistics = (Map<String, Object>) request.getAttribute("statistics");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    String searchReporter = (String) request.getAttribute("searchReporter");
    Integer entriesPerPage = (Integer) request.getAttribute("entriesPerPage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    Boolean databaseConnected = (Boolean) request.getAttribute("databaseConnected");
    
    List<Map<String, Object>> reportedGroups = null;
    int totalPages = 0;
    int totalRecords = 0;
    
    if (result != null) {
        reportedGroups = (List<Map<String, Object>>) result.get("reportedGroups");
        totalPages = (Integer) result.get("totalPages");
        totalRecords = (Integer) result.get("totalRecords");
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý nhóm bị báo cáo - CourseHub Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

        /* Sidebar */
        .sidebar { 
            width: 250px; 
            background: rgba(255, 255, 255, 0.1); 
            backdrop-filter: blur(10px); 
            padding: 1rem 0; 
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
            padding: 0.75rem 1.5rem; 
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

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 0px;
            padding: 1rem 2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%)
          
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

        /* Statistics Cards */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card .icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .stat-card.total .icon {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }

        .stat-card.pending .icon {
            background: linear-gradient(135deg, #f093fb, #f5576c);
            color: white;
        }

        .stat-card.alerted .icon {
            background: linear-gradient(135deg, #4facfe, #00f2fe);
            color: white;
        }

        .stat-card.dismissed .icon {
            background: linear-gradient(135deg, #43e97b, #38f9d7);
            color: white;
        }

        .stat-card h3 {
            font-size: 0.9rem;
            color: #64748b;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .stat-card .value {
            font-size: 2rem;
            font-weight: 700;
            color: #1e293b;
        }

        /* Content Card */
        .content-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .card-header {
            padding: 1.5rem 2rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.1);
            background: rgba(255, 255, 255, 0.5);
        }

        .card-header h2 {
            color: #1e293b;
            font-size: 1.3rem;
            font-weight: 600;
        }

        .card-body {
            padding: 2rem;
        }

        /* Filters */
        .filters {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-box {
            position: relative;
            flex: 1;
            max-width: 400px;
        }

        .search-box input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.5rem;
            border: 2px solid rgba(102, 126, 234, 0.2);
            border-radius: 10px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            background: white;
        }

        .search-box input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .search-box i {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: #64748b;
        }

        .entries-select {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .entries-select select {
            padding: 0.5rem;
            border: 2px solid rgba(102, 126, 234, 0.2);
            border-radius: 8px;
            background: white;
            font-size: 0.9rem;
        }

        /* Table */
        .table-container {
            overflow-x: auto;
            margin-bottom: 2rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }

        thead {
            background: linear-gradient(135deg, #667eea, #764ba2);
        }

        thead th {
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: white;
            font-size: 0.9rem;
        }

        tbody tr {
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            transition: background-color 0.2s ease;
        }

        tbody tr:hover {
            background: rgba(102, 126, 234, 0.05);
        }

        tbody td {
            padding: 1rem;
            font-size: 0.9rem;
            color: #475569;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-alert {
            background: linear-gradient(135deg, #f093fb, #f5576c);
            color: white;
        }

        .btn-dismiss {
            background: linear-gradient(135deg, #43e97b, #38f9d7);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        /* Status badges */
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .status-pending {
            background: rgba(249, 115, 22, 0.1);
            color: #ea580c;
        }

        .status-alerted {
            background: rgba(59, 130, 246, 0.1);
            color: #2563eb;
        }

        .status-dismissed {
            background: rgba(34, 197, 94, 0.1);
            color: #16a34a;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 2rem;
        }

        .pagination-info {
            color: #64748b;
            font-size: 0.9rem;
        }

        .pagination-controls {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        .pagination-controls a,
        .pagination-controls span {
            padding: 0.5rem 0.75rem;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .pagination-controls a {
            background: rgba(102, 126, 234, 0.1);
            color: #667eea;
        }

        .pagination-controls a:hover {
            background: #667eea;
            color: white;
        }

        .pagination-controls .current {
            background: #667eea;
            color: white;
        }

        .pagination-controls .disabled {
            background: rgba(0, 0, 0, 0.05);
            color: #94a3b8;
            cursor: not-allowed;
        }

        /* Loading and Error States */
        .loading {
            text-align: center;
            padding: 3rem;
            color: #64748b;
        }

        .loading i {
            font-size: 2rem;
            margin-bottom: 1rem;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .error-message {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.2);
            color: #dc2626;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        .success-message {
            background: rgba(34, 197, 94, 0.1);
            border: 1px solid rgba(34, 197, 94, 0.2);
            color: #16a34a;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
        }

        /* Responsive Design */
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
                margin-left: 0;
            }

            .stats-container {
                grid-template-columns: 1fr;
            }

            .filters {
                flex-direction: column;
                align-items: stretch;
            }

            .search-box {
                max-width: none;
            }

            .table-container {
                font-size: 0.8rem;
            }

            .pagination {
                flex-direction: column;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <h1><i class="fas fa-flag"></i> Reported Groups Management - CourseHub E-Learning</h1>
        <div class="user-info"><span>Xin chào, Admin</span><i class="fas fa-user-circle"></i></div>
    </header>

    <div class="container">
        <!-- Sidebar -->
        <nav class="sidebar">
           <ul>
                <li><a href="/Adaptive_Elearning/admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Tổng quan</a></li>
                <li><a href="/Adaptive_Elearning/admin_notification.jsp"><i class="fas fa-bell"></i> Thông báo</a></li>
                <li><a href="/Adaptive_Elearning/admin_createadmin.jsp"><i class="fas fa-user-plus"></i> Tạo Admin</a></li>
                <li><a href="/Adaptive_Elearning/admin_accountmanagement.jsp"><i class="fas fa-users"></i> Quản lý Tài Khoản</a></li>
                <li><a href="/Adaptive_Elearning/admin_reportedcourse.jsp"><i class="fas fa-flag"></i> Quản lý Khóa Học</a></li>
                 <li><a href="/Adaptive_Elearning/admin_coursemanagement.jsp"><i class="fa-solid fa-bars-progress"></i> Các Khóa Học</a></li>
                <li><a href="/Adaptive_Elearning/admin_reportedgroup.jsp" class="active"><i class="fas fa-user-graduate"></i> Quản lý Nhóm</a></li>
                <li><a href="#"><i class="fas fa-chart-bar"></i> Home</a></li>
                <li><a href="#"><i class="fas fa-cog"></i> LogOut</a></li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <h2><i class="fas fa-flag"></i> Quản lý nhóm bị báo cáo</h2>
            </div>

            <!-- Success/Error Messages -->
            <% if (request.getParameter("alertSuccess") != null) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i> Đã thông báo thành công cho quản trị viên!
            </div>
            <% } %>

            <% if (request.getParameter("dismissSuccess") != null) { %>
            <div class="success-message">
                <i class="fas fa-check-circle"></i> Đã bỏ qua báo cáo thành công!
            </div>
            <% } %>

            <% if (request.getParameter("alertError") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i> Không thể thông báo cho quản trị viên. Vui lòng thử lại!
            </div>
            <% } %>

            <% if (request.getParameter("dismissError") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i> Không thể bỏ qua báo cáo. Vui lòng thử lại!
            </div>
            <% } %>

            <% if (errorMessage != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
            </div>
            <% } %>

            <!-- Statistics Cards -->
            <% if (statistics != null) { %>
            <div class="stats-container">
                <div class="stat-card total">
                    <div class="icon"><i class="fas fa-flag"></i></div>
                    <h3>Tổng số báo cáo</h3>
                    <div class="value"><%= statistics.get("totalReports") %></div>
                </div>
                
                <% 
                Map<String, Integer> statusStats = (Map<String, Integer>) statistics.get("statusStats");
                int pendingCount = statusStats.getOrDefault("Pending", 0) + statusStats.getOrDefault("", 0);
                int alertedCount = statusStats.getOrDefault("AlertedAdmin", 0);
                int dismissedCount = statusStats.getOrDefault("Dismissed", 0);
                %>
                
                <div class="stat-card pending">
                    <div class="icon"><i class="fas fa-clock"></i></div>
                    <h3>Đang chờ xử lý</h3>
                    <div class="value"><%= pendingCount %></div>
                </div>
                
                <div class="stat-card alerted">
                    <div class="icon"><i class="fas fa-bell"></i></div>
                    <h3>Đã thông báo Admin</h3>
                    <div class="value"><%= alertedCount %></div>
                </div>
                
                <div class="stat-card dismissed">
                    <div class="icon"><i class="fas fa-check"></i></div>
                    <h3>Đã bỏ qua</h3>
                    <div class="value"><%= dismissedCount %></div>
                </div>
            </div>
            <% } %>

            <!-- Main Content Card -->
            <div class="content-card">
                <div class="card-header">
                    <h2>Danh sách nhóm bị báo cáo</h2>
                </div>
                <div class="card-body">
                    <!-- Filters -->
                    <form method="GET" action="admin_reportedgroup.jsp" class="filters">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" name="searchReporter" placeholder="Tìm kiếm theo tên người báo cáo..." 
                                   value="<%= searchReporter != null ? searchReporter : "" %>">
                        </div>
                        <div class="entries-select">
                            <label>Hiển thị:</label>
                            <select name="entries" onchange="this.form.submit()">
                                <option value="10" <%= entriesPerPage == 10 ? "selected" : "" %>>10</option>
                                <option value="25" <%= entriesPerPage == 25 ? "selected" : "" %>>25</option>
                                <option value="50" <%= entriesPerPage == 50 ? "selected" : "" %>>50</option>
                                <option value="100" <%= entriesPerPage == 100 ? "selected" : "" %>>100</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                    </form>

                    <!-- Table -->
                    <% if (databaseConnected != null && !databaseConnected) { %>
                    <div class="loading">
                        <i class="fas fa-database"></i>
                        <p>Không thể kết nối đến cơ sở dữ liệu</p>
                    </div>
                    <% } else if (reportedGroups == null) { %>
                    <div class="loading">
                        <i class="fas fa-spinner"></i>
                        <p>Đang tải dữ liệu...</p>
                    </div>
                    <% } else { %>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Người báo cáo</th>
                                    <th>Tên nhóm</th>
                                    <th>Nội dung báo cáo</th>
                                    <th>Ngày báo cáo</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (reportedGroups.isEmpty()) { %>
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 2rem; color: #64748b;">
                                        <i class="fas fa-inbox" style="font-size: 2rem; margin-bottom: 1rem; display: block;"></i>
                                        Không có dữ liệu báo cáo nào
                                    </td>
                                </tr>
                                <% } else { %>
                                <% 
                                int startIndex = (currentPage - 1) * entriesPerPage;
                                for (int i = 0; i < reportedGroups.size(); i++) {
                                    Map<String, Object> report = reportedGroups.get(i);
                                    String status = (String) report.get("status");
                                    if (status == null || status.trim().isEmpty()) {
                                        status = "Pending";
                                    }
                                %>
                                <tr>
                                    <td><%= startIndex + i + 1 %></td>
                                    <td>
                                        <strong><%= report.get("reporterName") %></strong><br>
                                        <small style="color: #64748b;"><%= report.get("reporterEmail") %></small>
                                    </td>
                                    <td><%= report.get("groupName") != null ? report.get("groupName") : "N/A" %></td>
                                    <td><%= report.get("message") %></td>
                                    <td><%= sdf.format((Date) report.get("creationTime")) %></td>
                                    <td>
                                        <% if ("Pending".equals(status) || status.trim().isEmpty()) { %>
                                        <span class="status-badge status-pending">Đang chờ</span>
                                        <% } else if ("AlertedAdmin".equals(status)) { %>
                                        <span class="status-badge status-alerted">Đã thông báo</span>
                                        <% } else if ("Dismissed".equals(status)) { %>
                                        <span class="status-badge status-dismissed">Đã bỏ qua</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <% if ("Pending".equals(status) || status.trim().isEmpty()) { %>
                                            <form method="POST" action="admin_reportedgroup.jsp" style="display: inline;">
                                                <input type="hidden" name="action" value="alertAdmin">
                                                <input type="hidden" name="reportId" value="<%= report.get("id") %>">
                                                <button type="submit" class="btn btn-alert" 
                                                        onclick="return confirm('Bạn có chắc muốn thông báo cho quản trị viên về báo cáo này?')">
                                                    <i class="fas fa-bell"></i> Thông báo Admin
                                                </button>
                                            </form>
                                            <form method="POST" action="admin_reportedgroup.jsp" style="display: inline;">
                                                <input type="hidden" name="action" value="dismiss">
                                                <input type="hidden" name="reportId" value="<%= report.get("id") %>">
                                                <button type="submit" class="btn btn-dismiss"
                                                        onclick="return confirm('Bạn có chắc muốn bỏ qua báo cáo này?')">
                                                    <i class="fas fa-times"></i> Bỏ qua
                                                </button>
                                            </form>
                                            <% } else { %>
                                            <span style="color: #64748b; font-size: 0.8rem;">Đã xử lý</span>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <% if (totalPages > 1) { %>
                    <div class="pagination">
                        <div class="pagination-info">
                            Hiển thị <%= Math.min((currentPage - 1) * entriesPerPage + 1, totalRecords) %> - 
                            <%= Math.min(currentPage * entriesPerPage, totalRecords) %> 
                            trong tổng số <%= totalRecords %> báo cáo
                        </div>
                        <div class="pagination-controls">
                            <% if (currentPage > 1) { %>
                            <a href="?page=<%= currentPage - 1 %>&searchReporter=<%= searchReporter %>&entries=<%= entriesPerPage %>">
                                <i class="fas fa-chevron-left"></i> Trước
                            </a>
                            <% } else { %>
                            <span class="disabled"><i class="fas fa-chevron-left"></i> Trước</span>
                            <% } %>

                            <% 
                            int startPage = Math.max(1, currentPage - 2);
                            int endPage = Math.min(totalPages, currentPage + 2);
                            
                            for (int i = startPage; i <= endPage; i++) {
                                if (i == currentPage) {
                            %>
                            <span class="current"><%= i %></span>
                            <% } else { %>
                            <a href="?page=<%= i %>&searchReporter=<%= searchReporter %>&entries=<%= entriesPerPage %>"><%= i %></a>
                            <% } 
                            } %>

                            <% if (currentPage < totalPages) { %>
                            <a href="?page=<%= currentPage + 1 %>&searchReporter=<%= searchReporter %>&entries=<%= entriesPerPage %>">
                                Sau <i class="fas fa-chevron-right"></i>
                            </a>
                            <% } else { %>
                            <span class="disabled">Sau <i class="fas fa-chevron-right"></i></span>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</body>
</html>