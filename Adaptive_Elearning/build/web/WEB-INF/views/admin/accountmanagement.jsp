<%@page import="controller.AccountManagementController"%>
<%@page import="java.sql.*"%>
<%@page import="dao.DBConnection"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Handle POST requests for actions
    String method = request.getMethod();
    if ("POST".equals(method)) {
        String action = request.getParameter("action");
        
        if ("updateRole".equals(action)) {
            String userId = request.getParameter("userId");
            String newRole = request.getParameter("newRole");
            
            try {
                AccountManagementController controller = new AccountManagementController();
                boolean success = controller.updateUserRole(userId, newRole);
                
                if (success) {
                    response.sendRedirect("admin_accountmanagement.jsp?updated=success");
                } else {
                    response.sendRedirect("admin_accountmanagement.jsp?updated=error&msg=Update failed");
                }
                return;
            } catch (Exception e) {
                response.sendRedirect("admin_accountmanagement.jsp?updated=error&msg=" + e.getMessage());
                return;
            }
        } else if ("deactivateUser".equals(action)) {
            String userId = request.getParameter("userId");
            
            try {
                AccountManagementController controller = new AccountManagementController();
                boolean success = controller.deactivateUser(userId);
                
                if (success) {
                    response.sendRedirect("admin_accountmanagement.jsp?deactivated=success");
                } else {
                    response.sendRedirect("admin_accountmanagement.jsp?deactivated=error&msg=Deactivation failed");
                }
                return;
            } catch (Exception e) {
                response.sendRedirect("admin_accountmanagement.jsp?deactivated=error&msg=" + e.getMessage());
                return;
            }
        }
    }
    
    // Get parameters for GET requests
    String pageParam = request.getParameter("page");
    String searchRole = request.getParameter("role");
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
            if (entries == 5 || entries == 7 || entries == 10 || entries == 15) {
                recordsPerPage = entries;
            }
        } catch (NumberFormatException e) {
            recordsPerPage = 10;
        }
    }
    
    if (searchRole == null) {
        searchRole = "";
    }
    
    // Initialize variables
    List<Map<String, Object>> users = new ArrayList<>();
    List<String> userRoles = new ArrayList<>();
    Map<String, Object> userStats = new java.util.HashMap<>();
    String error = null;
    String success = null;
    int totalPages = 0;
    int totalRecords = 0;
    int totalUsers = 0;
    long totalSystemBalance = 0L;
    Map<String, Integer> roleStats = new java.util.HashMap<>();
    
    // Check for status messages
    String updated = request.getParameter("updated");
    String deactivated = request.getParameter("deactivated");
    String errorMsg = request.getParameter("msg");
    
    if ("success".equals(updated)) {
        success = "Cập nhật vai trò người dùng thành công!";
    } else if ("error".equals(updated)) {
        error = "Lỗi khi cập nhật vai trò: " + (errorMsg != null ? errorMsg : "Unknown error");
    } else if ("success".equals(deactivated)) {
        success = "Vô hiệu hóa người dùng thành công!";
    } else if ("error".equals(deactivated)) {
        error = "Lỗi khi vô hiệu hóa người dùng: " + (errorMsg != null ? errorMsg : "Unknown error");
    }
    
    // Load data from database
    try {
        Connection conn = DBConnection.getConnection();
        if (conn != null) {
            // Get user roles (cache-friendly query)
            String roleQuery = "SELECT DISTINCT Role FROM Users WHERE Role IS NOT NULL AND Role != '' ORDER BY Role";
            PreparedStatement roleStmt = conn.prepareStatement(roleQuery);
            ResultSet roleRs = roleStmt.executeQuery();
            
            while (roleRs.next()) {
                String role = roleRs.getString("Role");
                if (role != null && !role.trim().isEmpty()) {
                    userRoles.add(role);
                }
            }
            roleRs.close();
            roleStmt.close();
            
            // Count total users and get role statistics (optimized query)
            String countQuery = "SELECT COUNT(*) as total, SUM(CAST(ISNULL(SystemBalance, 0) as BIGINT)) as totalBalance FROM Users WHERE Role IS NOT NULL";
            PreparedStatement countStmt = conn.prepareStatement(countQuery);
            ResultSet countRs = countStmt.executeQuery();
            
            if (countRs.next()) {
                totalUsers = countRs.getInt("total");
                Object balanceObj = countRs.getObject("totalBalance");
                totalSystemBalance = (balanceObj != null) ? countRs.getLong("totalBalance") : 0L;
            }
            countRs.close();
            countStmt.close();
            
            // Get role statistics
            String roleStatsQuery = "SELECT Role, COUNT(*) as count FROM Users WHERE Role IS NOT NULL GROUP BY Role";
            PreparedStatement roleStatsStmt = conn.prepareStatement(roleStatsQuery);
            ResultSet roleStatsRs = roleStatsStmt.executeQuery();
            
            while (roleStatsRs.next()) {
                String role = roleStatsRs.getString("Role");
                int count = roleStatsRs.getInt("count");
                roleStats.put(role, count);
            }
            roleStatsRs.close();
            roleStatsStmt.close();
            
            // Build users query with pagination and search
            String usersQuery = "SELECT Id, FullName, Email, Role, CreationTime, SystemBalance FROM Users";
            String whereClause = "";
            
            if (!searchRole.isEmpty()) {
                whereClause = " WHERE Role = ?";
            }
            
            // Count filtered records
            String countFilteredQuery = "SELECT COUNT(*) as total FROM Users" + whereClause;
            PreparedStatement countFilteredStmt = conn.prepareStatement(countFilteredQuery);
            if (!searchRole.isEmpty()) {
                countFilteredStmt.setString(1, searchRole);
            }
            ResultSet countFilteredRs = countFilteredStmt.executeQuery();
            
            if (countFilteredRs.next()) {
                totalRecords = countFilteredRs.getInt("total");
                totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            }
            countFilteredRs.close();
            countFilteredStmt.close();
            
            // Get users with pagination
            String paginatedQuery = usersQuery + whereClause + " ORDER BY CreationTime DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            PreparedStatement paginatedStmt = conn.prepareStatement(paginatedQuery);
            
            int paramIndex = 1;
            if (!searchRole.isEmpty()) {
                paginatedStmt.setString(paramIndex++, searchRole);
            }
            paginatedStmt.setInt(paramIndex++, (currentPage - 1) * recordsPerPage);
            paginatedStmt.setInt(paramIndex, recordsPerPage);
            
            ResultSet usersRs = paginatedStmt.executeQuery();
            
            while (usersRs.next()) {
                Map<String, Object> user = new java.util.HashMap<>();
                user.put("id", usersRs.getString("Id"));
                user.put("fullName", usersRs.getString("FullName"));
                user.put("email", usersRs.getString("Email"));
                user.put("role", usersRs.getString("Role"));
                user.put("creationTime", usersRs.getTimestamp("CreationTime"));
                
                // Handle SystemBalance as Long
                String balanceStr = usersRs.getString("SystemBalance");
                long balance = 0L;
                if (balanceStr != null && !balanceStr.trim().isEmpty()) {
                    try {
                        balance = Long.parseLong(balanceStr);
                    } catch (NumberFormatException e) {
                        balance = 0L;
                    }
                }
                user.put("systemBalance", balance);
                
                users.add(user);
            }
            usersRs.close();
            paginatedStmt.close();
            conn.close();
        } else {
            error = "Không thể kết nối tới database CourseHubDB";
        }
    } catch (Exception e) {
        e.printStackTrace();
        error = "Lỗi khi tải dữ liệu: " + e.getMessage();
    }
    
    // Date and number formatters
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Management - CourseHub E-Learning</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; color: #333; }
        .header { background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(10px); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255, 255, 255, 0.2); }
        .header h1 { color: white; font-size: 1.5rem; display: flex; align-items: center; gap: 0.5rem; }
        .user-info { color: white; display: flex; align-items: center; gap: 0.5rem; }
        .container { display: flex; min-height: calc(100vh - 80px); }
        .sidebar { width: 250px; background: rgba(255, 255, 255, 0.1); backdrop-filter: blur(10px); padding: 2rem 0; border-right: 1px solid rgba(255, 255, 255, 0.2); }
        .sidebar ul { list-style: none; padding: 0; }
        .sidebar li { margin-bottom: 0.5rem; }
        .sidebar a { display: flex; align-items: center; gap: 0.75rem; padding: 1rem 2rem; color: rgba(255, 255, 255, 0.8); text-decoration: none; transition: all 0.3s ease; }
        .sidebar a:hover { background: rgba(255, 255, 255, 0.1); color: white; }
        .sidebar a.active { background: rgba(255, 255, 255, 0.2); color: white; border-right: 3px solid #fff; }
        .main-content { flex: 1; padding: 2rem; overflow-y: auto; }
        .page-header { background: rgba(255, 255, 255, 0.95); padding: 2rem; border-radius: 12px; margin-bottom: 2rem; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .page-header h2 { color: #333; margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.5rem; }
        
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1.5rem; margin-bottom: 2rem; }
        .stat-card { background: rgba(255, 255, 255, 0.95); padding: 1.5rem; border-radius: 12px; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); display: flex; align-items: center; gap: 1rem; }
        .stat-icon { width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.2rem; }
        .stat-icon.users { background: #667eea; }
        .stat-icon.balance { background: #43e97b; }
        .stat-icon.admin { background: #f093fb; }
        .stat-icon.student { background: #4facfe; }
        .stat-icon.instructor { background: #ff6b6b; }
        .stat-info h3 { color: #333; font-size: 1rem; margin-bottom: 0.25rem; }
        .stat-info p { color: #666; font-size: 0.9rem; }
        
        .search-section { background: rgba(255, 255, 255, 0.95); padding: 1.5rem; border-radius: 12px; margin-bottom: 2rem; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); }
        .search-form { display: flex; gap: 1rem; align-items: end; }
        .form-group { flex: 1; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: 500; color: #333; }
        .form-group select { width: 100%; padding: 0.75rem; border: 2px solid #e1e5e9; border-radius: 8px; font-size: 1rem; transition: border-color 0.3s ease; }
        .form-group select:focus { outline: none; border-color: #667eea; }
        .btn { padding: 0.75rem 1.5rem; border: none; border-radius: 8px; font-size: 1rem; cursor: pointer; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 0.5rem; text-decoration: none; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3); }
        .btn-sm { padding: 0.4rem 0.8rem; font-size: 0.85rem; }
        .btn-warning { background: #ffc107; color: #212529; }
        .btn-warning:hover { background: #e0a800; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-danger:hover { background: #c82333; }
        
        .users-table { background: rgba(255, 255, 255, 0.95); border-radius: 12px; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1); overflow: hidden; }
        .table-header { padding: 1.5rem; border-bottom: 1px solid #e1e5e9; display: flex; justify-content: space-between; align-items: center; }
        .table-header h3 { color: #333; display: flex; align-items: center; gap: 0.5rem; }
        .table-stats { color: #666; font-size: 0.9rem; }
        .table-container { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 1rem; text-align: left; border-bottom: 1px solid #e1e5e9; }
        th { background: #f8f9fa; font-weight: 600; color: #333; }
        tbody tr:hover { background: #f8f9fa; }
        .role-badge { padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.85rem; font-weight: 500; }
        .role-admin { background: #f8d7da; color: #721c24; }
        .role-student { background: #d4edda; color: #155724; }
        .role-instructor { background: #d1ecf1; color: #0c5460; }
        .role-inactive { background: #f8f9fa; color: #6c757d; }
        .balance { font-weight: 600; color: #28a745; }
        .no-data { text-align: center; padding: 3rem; color: #666; }
        .no-data i { font-size: 3rem; margin-bottom: 1rem; opacity: 0.5; }
        
        .pagination { padding: 1.5rem; display: flex; justify-content: center; align-items: center; gap: 0.5rem; border-top: 1px solid #e1e5e9; }
        .pagination a, .pagination span { padding: 0.5rem 1rem; text-decoration: none; border-radius: 6px; transition: all 0.3s ease; }
        .pagination a { color: #667eea; border: 1px solid #e1e5e9; }
        .pagination a:hover { background: #667eea; color: white; }
        .pagination .current { background: #667eea; color: white; border: 1px solid #667eea; }
        .pagination .disabled { color: #ccc; border: 1px solid #f0f0f0; cursor: not-allowed; }
        
        .alert { padding: 1rem; border-radius: 8px; margin-bottom: 2rem; display: flex; align-items: center; gap: 0.5rem; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        
        .loading { display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: rgba(0,0,0,0.8); color: white; padding: 2rem; border-radius: 8px; z-index: 9999; }
        .loading i { animation: spin 1s linear infinite; margin-right: 0.5rem; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        
        @media (max-width: 768px) {
            .container { flex-direction: column; }
            .sidebar { width: 100%; order: 2; }
            .main-content { order: 1; }
            .search-form { flex-direction: column; }
            .form-group { margin-bottom: 1rem; }
            .stats-grid { grid-template-columns: 1fr; }
            .table-container { font-size: 0.9rem; }
            th, td { padding: 0.5rem; }
        }
    </style>
</head>
<body>
    <header class="header">
        <h1><i class="fas fa-users-cog"></i> Account Management - CourseHub E-Learning</h1>
        <div class="user-info"><span>Xin chào, Admin</span><i class="fas fa-user-circle"></i></div>
    </header>

    <div class="container">
        <nav class="sidebar">
           <ul>
                <li><a href="/adaptive_elearning/admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Tổng quan</a></li>
                <li><a href="/adaptive_elearning/admin_notification.jsp"><i class="fas fa-bell"></i> Thông báo</a></li>
                <li><a href="/adaptive_elearning/admin_createadmin.jsp"><i class="fas fa-user-plus"></i> Tạo Admin</a></li>
                <li><a href="/adaptive_elearning/admin_accountmanagement.jsp" class="active"><i class="fas fa-users"></i> Quản lý Tài Khoản</a></li>
                <li><a href="/adaptive_elearning/admin_reportedcourse.jsp" ><i class="fas fa-flag"></i> Quản lý Khóa Học</a></li>
                 <li><a href="/adaptive_elearning/admin_coursemanagement.jsp"><i class="fa-solid fa-bars-progress"></i> Các Khóa Học</a></li>
                <li><a href="/adaptive_elearning/admin_reportedgroup.jsp"><i class="fas fa-user-graduate"></i> Quản lý Nhóm</a></li>
                <li><a href="#"><i class="fas fa-chart-bar"></i> Home</a></li>
                <li><a href="#"><i class="fas fa-cog"></i> LogOut</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fas fa-users-cog"></i> Quản lý tài khoản người dùng</h2>
                <p>Quản lý và theo dõi tất cả tài khoản người dùng trong hệ thống với khả năng tìm kiếm, phân trang và cập nhật vai trò</p>
            </div>

            <!-- Status Messages -->
            <% if (success != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= success %>
                </div>
            <% } %>

            <% if (error != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <%= error %>
                </div>
            <% } %>

            <!-- Statistics -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon users">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= totalUsers %></h3>
                        <p>Tổng số người dùng</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon balance">
                        <i class="fas fa-coins"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= currencyFormat.format(totalSystemBalance) %></h3>
                        <p>Tổng số dư hệ thống</p>
                    </div>
                </div>
                
                <% 
                int adminCount = roleStats.containsKey("Admin") ? roleStats.get("Admin") : 0;
                int studentCount = (roleStats.containsKey("Student") ? roleStats.get("Student") : 0) + 
                                   (roleStats.containsKey("Learner") ? roleStats.get("Learner") : 0);
                int instructorCount = roleStats.containsKey("Instructor") ? roleStats.get("Instructor") : 0;
                %>
                
                <div class="stat-card">
                    <div class="stat-icon admin">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= adminCount %></h3>
                        <p>Quản trị viên</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon student">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= studentCount %></h3>
                        <p>Học viên</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon instructor">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= instructorCount %></h3>
                        <p>Giảng viên</p>
                    </div>
                </div>
            </div>

            <!-- Search Section -->
            <div class="search-section">
                <form class="search-form" method="GET" action="admin_accountmanagement.jsp">
                    <div class="form-group">
                        <label for="entries">Show:</label>
                        <select name="entries" id="entries" onchange="updateEntries()">
                            <option value="5" <%= recordsPerPage == 5 ? "selected" : "" %>>5 entries</option>
                            <option value="7" <%= recordsPerPage == 7 ? "selected" : "" %>>7 entries</option>
                            <option value="10" <%= recordsPerPage == 10 ? "selected" : "" %>>10 entries</option>
                            <option value="15" <%= recordsPerPage == 15 ? "selected" : "" %>>15 entries</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="role">Lọc theo Role:</label>
                        <select name="role" id="role">
                            <option value="">Tất cả</option>
                            <% for (String role : userRoles) { %>
                                <option value="<%= role %>" <%= searchRole.equals(role) ? "selected" : "" %>>
                                    <%= role %>
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

            <!-- Users Table -->
            <div class="users-table">
                <div class="table-header">
                    <h3><i class="fas fa-list"></i> Danh sách người dùng</h3>
                    <div class="table-stats">
                        <span>Hiển thị <%= users.size() %> trên tổng <strong><%= totalRecords %></strong> người dùng</span>
                        <% if (!searchRole.isEmpty()) { %>
                            | Lọc theo: <strong><%= searchRole %></strong>
                        <% } %>
                    </div>
                </div>

                <div class="table-container">
                    <% if (users.isEmpty()) { %>
                        <div class="no-data">
                            <i class="fas fa-users"></i>
                            <p>Không có người dùng nào</p>
                        </div>
                    <% } else { %>
                        <table>
                            <thead>
                                <tr>
                                    <th>Full Name</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Creation Time</th>
                                    <th>System Balance</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Map<String, Object> user : users) { 
                                    String role = (String) user.get("role");
                                    String roleClass = "role-student";
                                    if ("Admin".equals(role)) {
                                        roleClass = "role-admin";
                                    } else if ("Instructor".equals(role)) {
                                        roleClass = "role-instructor";
                                    } else if ("Learner".equals(role) || "Student".equals(role)) {
                                        roleClass = "role-student";
                                    } else if ("Inactive".equals(role)) {
                                        roleClass = "role-inactive";
                                    }
                                %>
                                <tr>
                                    <td><%= user.get("fullName") != null ? user.get("fullName") : "N/A" %></td>
                                    <td><%= user.get("email") != null ? user.get("email") : "N/A" %></td>
                                    <td>
                                        <span class="role-badge <%= roleClass %>">
                                            <%= role != null ? role : "Unknown" %>
                                        </span>
                                    </td>
                                    <td>
                                        <% if (user.get("creationTime") != null) { %>
                                            <%= dateFormat.format(user.get("creationTime")) %>
                                        <% } else { %>
                                            N/A
                                        <% } %>
                                    </td>
                                    <td>
                                        <span class="balance">
                                            <%= currencyFormat.format((Long) user.get("systemBalance")) %>
                                        </span>
                                    </td>
                                    <td>
                                        <% String userId = (String) user.get("id"); %>
                                        <% if (!"Inactive".equals(role)) { %>
                                            <button class="btn btn-warning btn-sm" onclick="updateRole('<%= userId %>', '<%= role %>')">
                                                <i class="fas fa-edit"></i> Edit Role
                                            </button>
                                            <button class="btn btn-danger btn-sm" onclick="deactivateUser('<%= userId %>')">
                                                <i class="fas fa-ban"></i> Ban
                                            </button>
                                        <% } else { %>
                                            <span style="color: #ccc;">Inactive</span>
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
                            <a href="?page=<%= currentPage - 1 %>&role=<%= searchRole %>&entries=<%= recordsPerPage %>">
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
                                <a href="?page=<%= i %>&role=<%= searchRole %>&entries=<%= recordsPerPage %>"><%= i %></a>
                            <% } %>
                        <% } %>

                        <% if (currentPage < totalPages) { %>
                            <a href="?page=<%= currentPage + 1 %>&role=<%= searchRole %>&entries=<%= recordsPerPage %>">
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

    <!-- Loading Indicator -->
    <div id="loading" class="loading">
        <i class="fas fa-spinner"></i>
        Đang xử lý...
    </div>

    <script>
        function updateRole(userId, currentRole) {
            const roles = ['Admin', 'Learner', 'Instructor'];
            const newRole = prompt('Chọn vai trò mới:\n1. Admin\n2. Learner\n3. Instructor\n\nNhập số (1-3):', '2');
            
            if (newRole && newRole >= '1' && newRole <= '3') {
                const roleIndex = parseInt(newRole) - 1;
                const selectedRole = roles[roleIndex];
                
                if (confirm(`Bạn có chắc chắn muốn thay đổi vai trò thành "${selectedRole}"?`)) {
                    // Show loading
                    document.getElementById('loading').style.display = 'block';
                    
                    // Create form to submit POST request
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'admin_accountmanagement.jsp';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'updateRole';
                    
                    const userIdInput = document.createElement('input');
                    userIdInput.type = 'hidden';
                    userIdInput.name = 'userId';
                    userIdInput.value = userId;
                    
                    const roleInput = document.createElement('input');
                    roleInput.type = 'hidden';
                    roleInput.name = 'newRole';
                    roleInput.value = selectedRole;
                    
                    form.appendChild(actionInput);
                    form.appendChild(userIdInput);
                    form.appendChild(roleInput);
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            }
        }
        
        function deactivateUser(userId) {
            if (confirm('Bạn có chắc chắn muốn vô hiệu hóa tài khoản này? Hành động này không thể hoàn tác.')) {
                // Show loading
                document.getElementById('loading').style.display = 'block';
                
                // Create form to submit POST request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'admin_accountmanagement.jsp';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'deactivateUser';
                
                const userIdInput = document.createElement('input');
                userIdInput.type = 'hidden';
                userIdInput.name = 'userId';
                userIdInput.value = userId;
                
                form.appendChild(actionInput);
                form.appendChild(userIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function updateEntries() {
            const entriesSelect = document.getElementById('entries');
            const roleSelect = document.getElementById('role');
            const selectedEntries = entriesSelect.value;
            const selectedRole = roleSelect.value;
            
            // Redirect with new entries parameter
            const url = 'admin_accountmanagement.jsp?page=1&entries=' + selectedEntries + '&role=' + encodeURIComponent(selectedRole);
            window.location.href = url;
        }
        
        // Hide loading indicator when page loads
        window.addEventListener('load', function() {
            document.getElementById('loading').style.display = 'none';
        });
    </script>
</body>
</html>
