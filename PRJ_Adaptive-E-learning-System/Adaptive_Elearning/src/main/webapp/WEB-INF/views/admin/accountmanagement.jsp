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
    String unbanned = request.getParameter("unbanned");
    String errorMsg = request.getParameter("msg");
    
    if ("success".equals(updated)) {
        success = "Cập nhật vai trò người dùng thành công!";
    } else if ("error".equals(updated)) {
        error = "Lỗi khi cập nhật vai trò: " + (errorMsg != null ? errorMsg : "Unknown error");
    } else if ("success".equals(deactivated)) {
        success = "Vô hiệu hóa người dùng thành công!";
    } else if ("error".equals(deactivated)) {
        error = "Lỗi khi vô hiệu hóa người dùng: " + (errorMsg != null ? errorMsg : "Unknown error");
    } else if ("success".equals(unbanned)) {
        success = "Khôi phục tài khoản thành công! Người dùng đã được chuyển về vai trò Learner.";
    } else if ("error".equals(unbanned)) {
        error = "Lỗi khi khôi phục tài khoản: " + (errorMsg != null ? errorMsg : "Unknown error");
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
    <link href="${pageContext.request.contextPath}/assests/css/universe-background.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0F0F23 0%, #1A1A2E 50%, #16213E 100%);
            color: #F8FAFC;
            min-height: 100vh;
            position: relative;
            overflow-x: auto;
        }

        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 20%, rgba(120, 113, 108, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(139, 92, 246, 0.2) 0%, transparent 50%),
                radial-gradient(circle at 40% 80%, rgba(236, 72, 153, 0.3) 0%, transparent 50%);
            pointer-events: none;
            z-index: -1;
        }

        .header {
           background:linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05)) ;
            backdrop-filter: blur(20px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 8px 25px rgba(139, 92, 246, 0.2);
        }
        .header h1 {
            font-family: 'Orbitron', monospace;
            color: #F8FAFC;
            font-size: 1.8rem;
            font-weight: 700;
            text-shadow: 0 0 20px rgba(139, 92, 246, 0.8);
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .user-info {
            color: #F8FAFC;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-shadow: 0 0 20px rgba(139, 92, 246, 0.8);
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-text-fill-color:transparent;
            background-clip: text
        }

        .container {
            display: flex;
            min-height: calc(100vh - 80px);
        }

        /* Sidebar */
        .sidebar { 
            width: 280px; 
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.15), rgba(139, 92, 246, 0.08)); 
            backdrop-filter: blur(20px); 
            border: 1px solid rgba(139, 92, 246, 0.25);
            padding: 2rem 0; 
            border-right: 1px solid rgba(139, 92, 246, 0.3); 
            position: relative;
            overflow: hidden;
        }

        .sidebar::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(180deg, rgba(139, 92, 246, 0.1) 0%, transparent 50%, rgba(6, 182, 212, 0.1) 100%);
            pointer-events: none;
        }

        .sidebar ul { 
            list-style: none; 
            padding: 0; 
            margin: 0;
            position: relative;
            z-index: 1;
        }

        .sidebar li { 
            margin-bottom: 0.25rem; 
            padding: 0 1rem;
        }

        .sidebar a { 
            display: flex; 
            align-items: center; 
            gap: 1rem; 
            padding: 1rem 1.25rem; 
            color: rgba(248, 250, 252, 0.85); 
            text-decoration: none; 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); 
            border-radius: 12px;
            font-weight: 500;
            font-size: 0.95rem;
            position: relative;
            overflow: hidden;
        }

        .sidebar a::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.2), rgba(6, 182, 212, 0.1));
            opacity: 0;
            transition: opacity 0.3s ease;
            border-radius: 12px;
        }

        .sidebar a i {
            font-size: 1.1rem;
            width: 20px;
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .sidebar a span {
            position: relative;
            z-index: 1;
        }

        .sidebar a:hover { 
            color: #F8FAFC; 
            transform: translateX(8px);
            box-shadow: 0 8px 25px rgba(139, 92, 246, 0.25);
        }

        .sidebar a:hover::before {
            opacity: 1;
        }

        .sidebar a:hover i {
            color: #06B6D4;
            transform: scale(1.1);
            transition: all 0.3s ease;
        }

        .sidebar a.active { 
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.3), rgba(6, 182, 212, 0.2)); 
            color: #F8FAFC; 
            border-left: 4px solid #8B5CF6;
            box-shadow: 0 8px 25px rgba(139, 92, 246, 0.3);
            transform: translateX(4px);
        }

        .sidebar a.active i {
            color: #06B6D4;
            text-shadow: 0 0 10px rgba(6, 182, 212, 0.8);
        }

        .sidebar a.active::before {
            opacity: 1;
        }

        /* Navigation Header */
        .nav-header {
            padding: 0 2rem 1.5rem 2rem;
            border-bottom: 1px solid rgba(139, 92, 246, 0.2);
            margin-bottom: 1.5rem;
        }

        .nav-header h3 {
            color: #F8FAFC;
            font-size: 1.1rem;
            font-weight: 600;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-align: center;
            margin: 0;
        }

        /* Navigation Groups */
        .nav-group {
            margin-bottom: 2rem;
        }

        .nav-group-title {
            color: rgba(248, 250, 252, 0.6);
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 0 2rem 0.5rem 2rem;
            margin-bottom: 0.5rem;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 0px;
            padding: 1rem 2rem;
        }

        .page-header { 
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05)); 
            backdrop-filter: blur(20px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            padding: 2rem; 
            border-radius: 16px; 
            margin-bottom: 2rem; 
            box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.1); 
        }
        .page-header h2 { 
            color: #F8FAFC; 
            margin-bottom: 0.5rem; 
            display: flex; 
            align-items: center; 
            gap: 0.5rem; 
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 700;
        }

        /* Statistics Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.2), rgba(139, 92, 246, 0.1));
            backdrop-filter: blur(16px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 8px 25px rgba(139, 92, 246, 0.2);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            color: #F8FAFC;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: -100%;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(139, 92, 246, 0.2), transparent);
            transition: left 0.5s;
        }

        .stat-card:hover::before {
            left: 100%;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(139, 92, 246, 0.3);
            border-color: rgba(139, 92, 246, 0.4);
        }

        .stat-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            position: relative;
            z-index: 2;
            margin-bottom: 1rem;
        }

        .stat-icon.users { background: linear-gradient(135deg, #8B5CF6, #06B6D4); }
        .stat-icon.balance { background: linear-gradient(135deg, #10B981, #06B6D4); }
        .stat-icon.admin { background: linear-gradient(135deg, #EC4899, #8B5CF6); }
        .stat-icon.student { background: linear-gradient(135deg, #06B6D4, #3B82F6); }
        .stat-icon.instructor { background: linear-gradient(135deg, #F59E0B, #EC4899); }

        .stat-info {
            position: relative;
            z-index: 2;
        }

        .stat-info h3 {
            font-size: 1.5rem;
            font-weight: bold;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 0 0 20px rgba(139, 92, 246, 0.8);
        }

        .stat-info p {
            color: rgba(248, 250, 252, 0.7);
            font-size: 0.9rem;
        }
        
        /* Search Section */
        .search-section {
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(20px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            padding: 2rem;
            border-radius: 16px;
            margin-bottom: 2rem;
            box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.1);
            transition: all 0.3s ease;
        }

        .search-section:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(139, 92, 246, 0.3);
            border-color: rgba(139, 92, 246, 0.4);
        }

        .search-form {
            display: flex;
            gap: 1.5rem;
            align-items: end;
        }

        .form-group {
            flex: 1;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #F8FAFC;
        }

        .form-group select {
            width: 100%;
            padding: 1rem;
            border: 2px solid rgba(139, 92, 246, 0.2);
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(16px);
            border-radius: 12px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            color: #F8FAFC;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23F8FAFC' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 8px center;
            background-size: 16px;
            padding-right: 32px;
        }

        .form-group select::placeholder {
            color: rgba(248, 250, 252, 0.6);
        }

        .form-group select:focus {
            outline: none;
            border-color: #8B5CF6;
            box-shadow: 0 0 20px rgba(139, 92, 246, 0.3);
        }

        /* Dropdown options styling */
        .form-group select option {
            background: rgba(30, 27, 75, 0.95) !important;
            color: #F8FAFC !important;
            border: none !important;
            padding: 8px 12px !important;
        }

        .form-group select option:hover,
        .form-group select option:focus,
        .form-group select option:checked {
            background: rgba(139, 92, 246, 0.8) !important;
            color: #F8FAFC !important;
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
            border: 2px solid rgba(139, 92, 246, 0.2);
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(16px);
            border-radius: 12px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            color: #F8FAFC;
        }

        .search-box input::placeholder {
            color: rgba(248, 250, 252, 0.6);
        }

        .search-box input:focus {
            outline: none;
            border-color: #8B5CF6;
            box-shadow: 0 0 20px rgba(139, 92, 246, 0.3);
        }

        .search-box i {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(248, 250, 252, 0.6);
        }

        .entries-select {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #F8FAFC;
        }

        .entries-select select {
            padding: 0.5rem;
            border: 2px solid rgba(139, 92, 246, 0.2);
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(16px);
            border-radius: 8px;
            font-size: 0.9rem;
            color: #F8FAFC;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23F8FAFC' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 8px center;
            background-size: 16px;
            padding-right: 32px;
        }

        .entries-select select:focus {
            outline: none;
            border-color: #8B5CF6;
            box-shadow: 0 0 20px rgba(139, 92, 246, 0.4);
        }

        /* Buttons */
        .btn {
            padding: 1rem 2rem;
            border: none;
            border-radius: 15px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            font-weight: 600;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.3);
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.85rem;
        }

        .btn-warning {
            background: linear-gradient(135deg, #feca57, #ff9ff3);
            color: white;
        }

        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(254, 202, 87, 0.3);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(255, 107, 107, 0.3);
        }

        .btn-success {
            background: linear-gradient(135deg, #56ab2f, #a8e6cf);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(86, 171, 47, 0.3);
        }
        /* Users Grid */
        .users-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .user-card {
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(20px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.1);
            transition: all 0.3s ease;
            position: relative;
        }

        .user-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent, rgba(139, 92, 246, 0.1), transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
        }

        .user-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(139, 92, 246, 0.3);
            border-color: rgba(139, 92, 246, 0.4);
        }

        .user-card:hover::before {
            opacity: 1;
        }

        .user-info {
            padding: 1.5rem;
            position: relative;
            z-index: 1;
        }

        .user-name {
            font-size: 1.1rem;
            font-weight: bold;
            color: #F8FAFC;
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }

        .user-email {
            font-size: 0.9rem;
            color: rgba(248, 250, 252, 0.7);
            margin-bottom: 1rem;
        }

        .user-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            font-size: 0.85rem;
            color: rgba(248, 250, 252, 0.7);
        }

        .user-role {
            background: rgba(139, 92, 246, 0.2);
            color: #F8FAFC;
            padding: 0.25rem 0.5rem;
            border-radius: 15px;
            font-size: 0.75rem;
        }

        .user-balance {
            font-size: 1rem;
            font-weight: bold;
            color: #06B6D4;
        }

        .user-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        /* Table Styles */
        .table-header {
            padding: 1.5rem;
            border-bottom: 1px solid rgba(139, 92, 246, 0.3);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-header h3 {
            color: #F8FAFC;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin: 0;
        }

        .table-stats {
            color: rgba(248, 250, 252, 0.7);
            font-size: 0.9rem;
        }

        .table-container {
            overflow: hidden;
            max-height: 70vh;
            width: 100%;
        }

        .table-wrapper {
            overflow-y: auto;
            overflow-x: hidden;
            max-height: 70vh;
            width: 100%;
        }

        /* Custom Scrollbar Styles - Only for vertical scroll */
        .table-wrapper::-webkit-scrollbar {
            width: 8px;
            height: 0px; /* Hide horizontal scrollbar */
        }

        .table-wrapper::-webkit-scrollbar-track {
            background: rgba(30, 27, 75, 0.5);
            border-radius: 10px;
        }

        .table-wrapper::-webkit-scrollbar-thumb {
            background: linear-gradient(45deg, rgba(139, 92, 246, 0.6), rgba(6, 182, 212, 0.6));
            border-radius: 10px;
            border: 2px solid rgba(30, 27, 75, 0.5);
        }

        .table-wrapper::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(45deg, rgba(139, 92, 246, 0.8), rgba(6, 182, 212, 0.8));
        }

        .table-wrapper::-webkit-scrollbar-corner {
            background: rgba(30, 27, 75, 0.5);
        }

        /* For Firefox - Only vertical scroll */
        .table-wrapper {
            scrollbar-width: thin;
            scrollbar-color: rgba(139, 92, 246, 0.6) rgba(30, 27, 75, 0.5);
        }

        /* Hide any horizontal scrollbar completely */
        ::-webkit-scrollbar-horizontal {
            display: none;
        }

        /* Global override to prevent any horizontal scroll */
        * {
            overflow-x: hidden !important;
        }

        /* But allow vertical overflow for specific elements that need it */
        .table-wrapper, .sidebar, body, html {
            overflow-y: auto !important;
            overflow-x: hidden !important;
        }

        /* Ensure body and html have no horizontal scroll */
        html, body {
            overflow-x: hidden;
            max-width: 100%;
        }

        /* Ensure main container doesn't overflow */
        .container {
            max-width: 100vw;
            overflow-x: hidden;
        }

        .main-content {
            max-width: calc(100vw - 280px);
            overflow-x: hidden;
        }

        /* Additional scrollbar prevention */
        * {
            box-sizing: border-box;
        }

        .page-header, .stats-grid, .content-card {
            max-width: 100%;
            overflow-x: hidden;
        }

        .search-form {
            max-width: 100%;
            overflow-x: hidden;
        }

        /* ===== TABLE STYLE FROM REPORTEDGROUP.JSP ===== */
        
        /* Content Card */
        .content-card {
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(20px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 16px;
            box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.1);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        .card-header {
            padding: 1.5rem 2rem;
            border-bottom: 1px solid rgba(139, 92, 246, 0.2);
            background: linear-gradient(145deg, rgba(139, 92, 246, 0.1), rgba(107, 70, 193, 0.05));
        }

        .card-header h2 {
            color: #F8FAFC;
            font-size: 1.3rem;
            font-weight: 600;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-body {
            padding: 2rem;
            background: transparent;
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
            border: 2px solid rgba(139, 92, 246, 0.2);
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(16px);
            border-radius: 12px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            color: #F8FAFC;
        }

        .search-box input::placeholder {
            color: rgba(248, 250, 252, 0.6);
        }

        .search-box input:focus {
            outline: none;
            border-color: #8B5CF6;
            box-shadow: 0 0 20px rgba(139, 92, 246, 0.3);
        }

        .search-box i {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(248, 250, 252, 0.6);
        }

        .entries-select {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #F8FAFC;
        }

        .entries-select select {
            padding: 0.5rem;
            border: 2px solid rgba(139, 92, 246, 0.2);
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(16px);
            border-radius: 8px;
            font-size: 0.9rem;
            color: #F8FAFC;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23F8FAFC' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 8px center;
            background-size: 16px;
            padding-right: 32px;
        }

        .entries-select select:focus {
            outline: none;
            border-color: #8B5CF6;
            box-shadow: 0 0 20px rgba(139, 92, 246, 0.4);
        }

        /* Table */
        .table-container {
            overflow-x: auto;
            margin-bottom: 2rem;
            border-radius: 12px;
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(16px);
            border: 1px solid rgba(139, 92, 246, 0.2);
        }

        thead {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
        }

        thead th {
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: white;
            font-size: 0.9rem;
            text-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
        }

        tbody tr {
            border-bottom: 1px solid rgba(139, 92, 246, 0.1);
            transition: all 0.3s ease;
        }

        tbody tr:hover {
            background: rgba(139, 92, 246, 0.1);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(139, 92, 246, 0.2);
        }

        tbody td {
            padding: 1rem;
            font-size: 0.9rem;
            color: #F8FAFC;
            vertical-align: middle;
        }

        /* Status badges from reportedgroup.jsp */
        .status-badge {
            padding: 0.4rem 0.8rem;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-admin {
            background: linear-gradient(135deg, rgba(236, 72, 153, 0.2), rgba(139, 92, 246, 0.1));
            color: #EC4899;
            border: 1px solid rgba(236, 72, 153, 0.3);
        }

        .status-instructor {
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.2), rgba(251, 191, 36, 0.1));
            color: #F59E0B;
            border: 1px solid rgba(245, 158, 11, 0.3);
        }

        .status-learner {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.2), rgba(6, 182, 212, 0.1));
            color: #10B981;
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .status-pending {
            background: rgba(249, 115, 22, 0.1);
            color: #ea580c;
            border: 1px solid rgba(249, 115, 22, 0.3);
        }

        .status-alerted {
            background: rgba(59, 130, 246, 0.1);
            color: #2563eb;
            border: 1px solid rgba(59, 130, 246, 0.3);
        }

        .status-dismissed {
            background: rgba(156, 163, 175, 0.2);
            color: #9CA3AF;
            border: 1px solid rgba(156, 163, 175, 0.3);
        }

        /* Action Buttons from reportedgroup.jsp */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn {
            padding: 0.5rem 1rem;
            border: 2px solid rgba(139, 92, 246, 0.2);
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            color: white;
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

        .btn-edit {
            background: linear-gradient(135deg, #F59E0B, #EC4899);
            color: white;
            border-color: rgba(245, 158, 11, 0.5);
        }

        .btn-alert {
            background: linear-gradient(135deg, #EC4899, #8B5CF6);
            color: white;
            border-color: rgba(236, 72, 153, 0.5);
        }

        .btn-dismiss {
            background: linear-gradient(135deg, #10B981, #06B6D4);
            color: white;
            border-color: rgba(16, 185, 129, 0.5);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(139, 92, 246, 0.3);
        }

        /* Loading and Error States */
        .loading {
            text-align: center;
            padding: 4rem 2rem;
            color: rgba(248, 250, 252, 0.8);
        }

        .loading i {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            color: rgba(139, 92, 246, 0.6);
            animation: pulse 2s infinite;
        }

        .loading h3 {
            color: #F8FAFC;
            margin-bottom: 1rem;
            font-size: 1.5rem;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .loading p {
            color: rgba(248, 250, 252, 0.7);
            margin: 0;
        }

        /* Pagination from reportedgroup.jsp */
        .pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 2rem;
            padding: 1rem 0;
            border-top: 1px solid rgba(139, 92, 246, 0.2);
        }

        .pagination-info {
            color: rgba(248, 250, 252, 0.8);
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
            transition: all 0.2s ease;
        }

        .pagination-controls a {
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            color: #F8FAFC;
            border: 1px solid rgba(139, 92, 246, 0.2);
        }

        .pagination-controls a:hover {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
        }

        .pagination-controls .current {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
            color: white;
            font-weight: 600;
        }

        .pagination-controls .disabled {
            background: rgba(107, 114, 128, 0.1);
            color: rgba(156, 163, 175, 0.5);
            cursor: not-allowed;
        }
        
        .users-container {
            background: linear-gradient(145deg, rgba(15, 15, 35, 0.8), rgba(30, 27, 75, 0.6));
            backdrop-filter: blur(25px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 20px;
            padding: 0;
            overflow: hidden;
            box-shadow: 
                0 25px 50px -12px rgba(139, 92, 246, 0.25),
                0 0 0 1px rgba(139, 92, 246, 0.1);
        }

        .users-header {
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.6), rgba(6, 182, 212, 0.4));
            padding: 2rem;
            border-bottom: 2px solid rgba(139, 92, 246, 0.3);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .users-header h3 {
            color: #F8FAFC;
            font-size: 1.5rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin: 0;
        }

        .users-count {
            background: linear-gradient(135deg, rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0.1));
            backdrop-filter: blur(10px);
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
            color: #F8FAFC;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .users-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            padding: 2rem;
            max-height: 70vh;
            overflow-y: auto;
        }

        /* Custom Scrollbar */
        .users-grid::-webkit-scrollbar {
            width: 8px;
        }

        .users-grid::-webkit-scrollbar-track {
            background: rgba(30, 27, 75, 0.5);
            border-radius: 10px;
        }

        .users-grid::-webkit-scrollbar-thumb {
            background: linear-gradient(45deg, rgba(139, 92, 246, 0.6), rgba(6, 182, 212, 0.6));
            border-radius: 10px;
            border: 2px solid rgba(30, 27, 75, 0.5);
        }

        .users-grid::-webkit-scrollbar-thumb:hover {
            background: linear-gradient(45deg, rgba(139, 92, 246, 0.8), rgba(6, 182, 212, 0.8));
        }

        .user-card {
            background: linear-gradient(145deg, rgba(30, 27, 75, 0.8), rgba(139, 92, 246, 0.1));
            backdrop-filter: blur(15px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 16px;
            padding: 1.5rem;
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            animation: cardSlideIn 0.6s ease forwards;
            opacity: 0;
            transform: translateY(30px);
        }

        .user-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.1), rgba(6, 182, 212, 0.05));
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
        }

        .user-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 
                0 20px 40px rgba(139, 92, 246, 0.3),
                0 0 0 1px rgba(139, 92, 246, 0.4);
            border-color: rgba(139, 92, 246, 0.5);
        }

        .user-card:hover::before {
            opacity: 1;
        }

        .user-card:nth-child(1) { animation-delay: 0.1s; }
        .user-card:nth-child(2) { animation-delay: 0.2s; }
        .user-card:nth-child(3) { animation-delay: 0.3s; }
        .user-card:nth-child(4) { animation-delay: 0.4s; }
        .user-card:nth-child(5) { animation-delay: 0.5s; }
        .user-card:nth-child(6) { animation-delay: 0.6s; }

        @keyframes cardSlideIn {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .user-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 1rem;
            position: relative;
            z-index: 2;
        }

        .user-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
            box-shadow: 0 8px 25px rgba(139, 92, 246, 0.4);
            position: relative;
            overflow: hidden;
        }

        .user-avatar::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transform: rotate(45deg);
            animation: avatarShine 3s linear infinite;
        }

        @keyframes avatarShine {
            0% { transform: translateX(-100%) translateY(-100%) rotate(45deg); }
            100% { transform: translateX(100%) translateY(100%) rotate(45deg); }
        }

        .user-status {
            position: absolute;
            top: -5px;
            right: -5px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            border: 2px solid rgba(30, 27, 75, 0.8);
        }

        .status-active { background: #10B981; }
        .status-inactive { background: #EF4444; }

        .user-info {
            flex: 1;
            margin-left: 1rem;
            position: relative;
            z-index: 2;
        }

        .user-name {
            font-size: 1.1rem;
            font-weight: 700;
            color: #F8FAFC;
            margin-bottom: 0.3rem;
            background: linear-gradient(45deg, #F8FAFC, #E2E8F0);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .user-email {
            font-size: 0.85rem;
            color: rgba(6, 182, 212, 0.9);
            font-family: 'Monaco', 'Menlo', 'Courier New', monospace;
            word-break: break-all;
            margin-bottom: 0.5rem;
        }

        .user-role-modern {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.4rem;
            padding: 0.6rem 1rem;
            border-radius: 25px;
            font-size: 0.8rem;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: 1px;
            border: 2px solid transparent;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
            transition: all 0.3s ease;
            text-align: center;
            min-width: 90px;
            white-space: nowrap;
            position: relative;
            z-index: 1;
        }

        .user-role-modern::before {
            content: '';
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: currentColor;
            box-shadow: 0 0 15px currentColor;
            flex-shrink: 0;
            filter: brightness(1.2);
        }

        .role-admin-modern { 
            background: linear-gradient(135deg, rgba(236, 72, 153, 0.95), rgba(139, 92, 246, 0.9));
            color: #FFFFFF;
            border-color: rgba(236, 72, 153, 1);
            text-shadow: 0 2px 6px rgba(0, 0, 0, 0.8);
            font-weight: 900;
        }
        
        .role-learner-modern { 
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.95), rgba(6, 182, 212, 0.9));
            color: #FFFFFF;
            border-color: rgba(16, 185, 129, 1);
            text-shadow: 0 2px 6px rgba(0, 0, 0, 0.8);
            font-weight: 900;
        }
        
        .role-instructor-modern { 
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.95), rgba(251, 191, 36, 0.9));
            color: #FFFFFF;
            border-color: rgba(245, 158, 11, 1);
            text-shadow: 0 2px 6px rgba(0, 0, 0, 0.8);
            font-weight: 900;
        }

        .role-inactive-modern { 
            background: linear-gradient(135deg, rgba(156, 163, 175, 0.95), rgba(107, 114, 128, 0.9));
            color: #FFFFFF;
            border-color: rgba(156, 163, 175, 1);
            text-shadow: 0 2px 6px rgba(0, 0, 0, 0.8);
            font-weight: 900;
        }

        .user-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin: 1.5rem 0;
            position: relative;
            z-index: 2;
        }

        .detail-item {
            background: linear-gradient(145deg, rgba(139, 92, 246, 0.1), rgba(6, 182, 212, 0.05));
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 10px;
            padding: 1rem;
            text-align: center;
            transition: all 0.3s ease;
        }

        .detail-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(139, 92, 246, 0.2);
            border-color: rgba(139, 92, 246, 0.4);
        }

        .detail-label {
            font-size: 0.7rem;
            color: rgba(248, 250, 252, 0.7);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.3rem;
            font-weight: 600;
        }

        .detail-value {
            font-size: 0.9rem;
            color: #F8FAFC;
            font-weight: 600;
        }

        .detail-value.balance {
            color: rgba(6, 182, 212, 0.9);
            font-family: 'Monaco', monospace;
            font-size: 1rem;
        }

        .detail-value.date {
            font-size: 0.8rem;
            color: rgba(248, 250, 252, 0.8);
        }

        .user-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1.5rem;
            position: relative;
            z-index: 2;
        }

        .action-btn-modern {
            flex: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.8rem 1rem;
            border: none;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            position: relative;
            overflow: hidden;
            text-align: center;
        }

        .action-btn-modern::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s ease;
        }

        .action-btn-modern:hover::before {
            left: 100%;
        }

        .action-btn-modern:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.25);
        }

        .btn-edit-modern {
            background: linear-gradient(135deg, rgba(245, 158, 11, 0.8), rgba(251, 191, 36, 0.6));
            color: white;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
        }

        .btn-ban-modern {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.8), rgba(220, 38, 38, 0.6));
            color: white;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
        }

        .btn-unban-modern {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.8), rgba(5, 150, 105, 0.6));
            color: white;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
        }

        /* Empty State */
        .empty-state-modern {
            text-align: center;
            padding: 4rem 2rem;
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            border: 2px dashed rgba(139, 92, 246, 0.3);
            border-radius: 20px;
            margin: 2rem;
        }

        .empty-state-modern i {
            font-size: 4rem;
            color: rgba(139, 92, 246, 0.6);
            margin-bottom: 1.5rem;
            animation: pulse 2s infinite;
        }

        .empty-state-modern h3 {
            color: #F8FAFC;
            margin-bottom: 1rem;
            font-size: 1.5rem;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        @keyframes pulse {
            0%, 100% { opacity: 0.6; }
            50% { opacity: 1; }
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem;
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(20px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 16px;
            box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.1);
        }

        .empty-state i {
            font-size: 3rem;
            color: rgba(139, 92, 246, 0.5);
            margin-bottom: 1rem;
        }

        .empty-state h3 {
            color: #F8FAFC;
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: rgba(248, 250, 252, 0.7);
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 1rem;
            margin-top: 2rem;
        }

        .pagination button {
            background: linear-gradient(145deg, rgba(139, 92, 246, 0.1), rgba(107, 70, 193, 0.05));
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            color: #F8FAFC;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .pagination button:hover:not(:disabled) {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
            color: white;
            box-shadow: 0 0 20px rgba(139, 92, 246, 0.4);
            transform: translateY(-2px);
        }

        .pagination button:disabled {
            background: rgba(139, 92, 246, 0.05);
            color: rgba(248, 250, 252, 0.4);
            cursor: not-allowed;
            border: 1px solid rgba(139, 92, 246, 0.1);
        }

        .pagination .current-page {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
            color: white;
            box-shadow: 0 0 20px rgba(139, 92, 246, 0.6);
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 600;
        }

        /* Alert Messages */
        .alert {
            padding: 1.5rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
        }

        .alert-success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
            border: 1px solid #f5c6cb;
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

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .users-grid {
                grid-template-columns: 1fr;
            }

            .search-form {
                flex-direction: column;
                gap: 1rem;
            }

            .user-actions {
                flex-direction: column;
            }
        }

        .balance {
            font-weight: 600;
            color: #06B6D4;
            text-shadow: 0 0 10px rgba(6, 182, 212, 0.5);
        }

        /* Empty State for Table */
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: rgba(248, 250, 252, 0.7);
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
            color: rgba(139, 92, 246, 0.5);
        }
        .alert-success { 
            background: rgba(34, 197, 94, 0.2); 
            color: #F8FAFC; 
            border-color: rgba(34, 197, 94, 0.5);
        }
        .alert-error { 
            background: rgba(239, 68, 68, 0.2); 
            color: #F8FAFC; 
            border-color: rgba(239, 68, 68, 0.5);
        }
        
        /* Loading and Animation Effects */
        @keyframes tableRowSlideIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes tableShimmer {
            0% {
                background-position: -200px 0;
            }
            100% {
                background-position: calc(200px + 100%) 0;
            }
        }

        tbody tr {
            animation: tableRowSlideIn 0.5s ease forwards;
        }

        tbody tr:nth-child(1) { animation-delay: 0.1s; }
        tbody tr:nth-child(2) { animation-delay: 0.15s; }
        tbody tr:nth-child(3) { animation-delay: 0.2s; }
        tbody tr:nth-child(4) { animation-delay: 0.25s; }
        tbody tr:nth-child(5) { animation-delay: 0.3s; }
        tbody tr:nth-child(6) { animation-delay: 0.35s; }
        tbody tr:nth-child(7) { animation-delay: 0.4s; }
        tbody tr:nth-child(8) { animation-delay: 0.45s; }
        tbody tr:nth-child(9) { animation-delay: 0.5s; }
        tbody tr:nth-child(10) { animation-delay: 0.55s; }

        /* Table wrapper improvements */
        .table-wrapper {
            border-radius: 16px;
            overflow: hidden;
            background: linear-gradient(145deg, rgba(30, 27, 75, 0.4), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(20px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            box-shadow: 
                0 20px 25px -5px rgba(139, 92, 246, 0.1),
                0 10px 10px -5px rgba(139, 92, 246, 0.04);
        }

        /* Enhanced loading state */
        .loading { 
            display: none; 
            position: fixed; 
            top: 50%; 
            left: 50%; 
            transform: translate(-50%, -50%); 
            background: linear-gradient(145deg, rgba(30, 27, 75, 0.95), rgba(139, 92, 246, 0.1));
            backdrop-filter: blur(20px);
            color: white; 
            padding: 2rem 3rem; 
            border-radius: 16px; 
            z-index: 9999; 
            border: 1px solid rgba(139, 92, 246, 0.3);
            box-shadow: 0 25px 50px -12px rgba(139, 92, 246, 0.25);
        }
        
        .loading i { 
            animation: spin 1s linear infinite; 
            margin-right: 0.5rem; 
            color: #06B6D4;
        }
        
        @keyframes spin { 
            0% { transform: rotate(0deg); } 
            100% { transform: rotate(360deg); } 
        }

        /* Enhanced empty state */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(20px);
            border: 2px dashed rgba(139, 92, 246, 0.3);
            border-radius: 20px;
            box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.1);
            transition: all 0.3s ease;
        }

        .empty-state:hover {
            border-color: rgba(139, 92, 246, 0.5);
            transform: translateY(-2px);
            box-shadow: 0 20px 25px -5px rgba(139, 92, 246, 0.15);
        }

        .empty-state i {
            font-size: 4rem;
            color: rgba(139, 92, 246, 0.6);
            margin-bottom: 1.5rem;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 0.6; }
            50% { opacity: 1; }
        }

        .empty-state h3 {
            color: #F8FAFC;
            margin-bottom: 1rem;
            font-size: 1.5rem;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .empty-state p {
            color: rgba(248, 250, 252, 0.7);
            font-size: 1rem;
            line-height: 1.6;
        }
        
        /* Responsive Design - 100% Enhanced from notification.jsp */
        @media (max-width: 768px) {
            .container { 
                flex-direction: column; 
                max-width: 100vw;
                overflow-x: hidden;
            }
            .sidebar { 
                width: 100%; 
                order: 2; 
                padding: 1rem 0;
            }
            .main-content { 
                order: 1; 
                margin-left: 0;
                padding: 1rem;
                max-width: 100vw;
                overflow-x: hidden;
            }

            .stats-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .search-form {
                flex-direction: column;
                gap: 1rem;
            }

            .form-group {
                width: 100%;
            }

            .search-box {
                max-width: none;
                width: 100%;
            }

            .table-container {
                font-size: 0.8rem;
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
                border-radius: 8px;
            }

            table {
                min-width: 600px;
                font-size: 0.75rem;
            }

            thead th {
                padding: 0.75rem 0.5rem;
                font-size: 0.7rem;
                white-space: nowrap;
            }

            tbody td {
                padding: 0.75rem 0.5rem;
                font-size: 0.75rem;
            }

            .role-badge {
                padding: 0.3rem 0.6rem;
                font-size: 0.65rem;
                min-width: 70px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 0.3rem;
            }

            .btn {
                padding: 0.4rem 0.8rem;
                font-size: 0.7rem;
                min-width: 60px;
            }

            .balance {
                font-size: 0.75rem;
            }

            .creation-date {
                font-size: 0.7rem;
            }

            .page-header {
                padding: 1.5rem;
                text-align: center;
            }

            .page-header h2 {
                font-size: 1.3rem;
            }

            .stat-card {
                padding: 1rem;
            }

            .stat-icon {
                width: 50px;
                height: 50px;
                font-size: 1.2rem;
            }

            .stat-info h3 {
                font-size: 1.2rem;
            }

            .user-info {
                font-size: 0.8rem;
            }

            .header h1 {
                font-size: 1.3rem;
            }

            .nav-group-title {
                font-size: 0.7rem;
            }

            .sidebar a {
                padding: 0.8rem 1rem;
                font-size: 0.85rem;
            }

            .alert {
                padding: 1rem;
                font-size: 0.9rem;
            }

            .no-data {
                padding: 2rem 1rem;
            }

            .no-data i {
                font-size: 2.5rem;
            }

            .no-data h3 {
                font-size: 1.2rem;
            }

            /* Hide horizontal scrollbar completely on mobile */
            .table-container::-webkit-scrollbar {
                height: 0px;
            }

            /* Custom mobile table scroll */
            .table-container {
                scrollbar-width: none;
                -ms-overflow-style: none;
            }
        }

        /* Tablet responsive */
        @media (min-width: 769px) and (max-width: 1024px) {
            .container {
                max-width: 100vw;
            }

            .main-content {
                max-width: calc(100vw - 280px);
                padding: 1.5rem;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .search-form {
                flex-wrap: wrap;
                gap: 1rem;
            }

            table {
                font-size: 0.85rem;
            }

            thead th {
                padding: 1rem 0.8rem;
                font-size: 0.8rem;
            }

            tbody td {
                padding: 1rem 0.8rem;
                font-size: 0.85rem;
            }

            .role-badge {
                font-size: 0.7rem;
                padding: 0.35rem 0.7rem;
            }

            .btn {
                font-size: 0.75rem;
                padding: 0.45rem 0.9rem;
            }
        }

        /* Large desktop responsive */
        @media (min-width: 1440px) {
            .main-content {
                max-width: calc(100vw - 300px);
                padding: 2rem 3rem;
            }

            .stats-grid {
                grid-template-columns: repeat(5, 1fr);
            }

            table {
                font-size: 1rem;
            }

            thead th {
                padding: 1.5rem 1.2rem;
                font-size: 0.9rem;
            }

            tbody td {
                padding: 1.5rem 1.2rem;
                font-size: 1rem;
            }

            .role-badge {
                font-size: 0.8rem;
                padding: 0.5rem 1rem;
            }

            .btn {
                font-size: 0.85rem;
                padding: 0.6rem 0.2rem;
            }
        }

        /* Ultra-wide responsive */
        @media (min-width: 1920px) {
            .container {
                max-width: 1800px;
                margin: 0 auto;
            }

            .main-content {
                max-width: calc(1800px - 300px);
            }

            .stats-grid {
                grid-template-columns: repeat(5, 1fr);
                gap: 2rem;
            }

            .page-header {
                padding: 3rem;
            }

            .search-section {
                padding: 3rem;
            }
        }

        /* Ultra wide screen optimization */
        @media (min-width: 1600px) {
            th, td {
                padding: 1.5rem 1.2rem;
                font-size: 1rem;
            }
            
            th {
                font-size: 1rem;
            }
            
            .role-badge {
                padding: 0.5rem 1rem;
                font-size: 0.8rem;
            }
            
            .btn {
                padding: 0.6rem 0.2rem;
                font-size: 0.5rem;
            }
        }

        /* ===== CARD LAYOUT RESPONSIVE BREAKPOINTS ===== */
        
        /* Large Desktop */
        @media (min-width: 1920px) {
            .users-grid {
                grid-template-columns: repeat(4, 1fr);
                gap: 2rem;
                padding: 2.5rem;
            }
            
            .user-card {
                padding: 2rem;
            }
            
            .users-header {
                padding: 2.5rem;
            }
        }

        /* Standard Desktop */
        @media (max-width: 1440px) {
            .users-grid {
                grid-template-columns: repeat(3, 1fr);
                gap: 1.5rem;
            }
        }

        /* Small Desktop/Large Tablet */
        @media (max-width: 1024px) {
            .users-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 1.25rem;
                padding: 1.5rem;
            }
            
            .users-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
                padding: 1.5rem;
            }
            
            .users-header h3 {
                font-size: 1.3rem;
            }
            
            .user-card {
                padding: 1.25rem;
            }
            
            .user-details {
                grid-template-columns: 1fr;
                gap: 0.75rem;
            }
        }

        /* Tablet */
        @media (max-width: 768px) {
            .users-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
                padding: 1rem;
                max-height: 60vh;
            }
            
            .users-header {
                padding: 1rem;
                text-align: center;
                align-items: center;
            }
            
            .users-header h3 {
                font-size: 1.2rem;
            }
            
            .user-card {
                padding: 1rem;
            }
            
            .user-header {
                flex-direction: column;
                align-items: center;
                text-align: center;
                gap: 1rem;
            }
            
            .user-info {
                margin-left: 0;
                text-align: center;
            }
            
            .user-avatar {
                width: 80px;
                height: 80px;
                font-size: 2rem;
            }
            
            .user-name {
                font-size: 1.2rem;
            }
            
            .user-email {
                font-size: 0.9rem;
            }
            
            .user-actions {
                flex-direction: column;
                gap: 0.75rem;
            }
            
            .action-btn-modern {
                padding: 1rem;
                font-size: 0.9rem;
            }
        }

        /* Mobile */
        @media (max-width: 480px) {
            .users-container {
                margin: 0.5rem;
                border-radius: 15px;
            }
            
            .users-grid {
                padding: 0.75rem;
                gap: 0.75rem;
                max-height: 55vh;
            }
            
            .users-header {
                padding: 0.75rem;
            }
            
            .users-header h3 {
                font-size: 1rem;
                letter-spacing: 0.5px;
            }
            
            .users-count {
                font-size: 0.8rem;
                padding: 0.4rem 0.8rem;
            }
            
            .user-card {
                padding: 0.75rem;
                border-radius: 12px;
            }
            
            .user-avatar {
                width: 60px;
                height: 60px;
                font-size: 1.5rem;
            }
            
            .user-name {
                font-size: 1rem;
            }
            
            .user-email {
                font-size: 0.8rem;
                word-break: break-all;
            }
            
            .user-role-modern {
                font-size: 0.65rem;
                padding: 0.3rem 0.6rem;
            }
            
            .detail-item {
                padding: 0.75rem;
            }
            
            .detail-label {
                font-size: 0.65rem;
            }
            
            .detail-value {
                font-size: 0.8rem;
            }
            
            .action-btn-modern {
                padding: 0.75rem;
                font-size: 0.8rem;
            }
            
            .empty-state-modern {
                padding: 2rem 1rem;
                margin: 1rem;
            }
            
            .empty-state-modern i {
                font-size: 3rem;
            }
            
            .empty-state-modern h3 {
                font-size: 1.2rem;
            }
        }

        /* Extra Small Mobile */
        @media (max-width: 360px) {
            .users-header h3 {
                font-size: 0.9rem;
            }
            
            .users-count {
                font-size: 0.7rem;
            }
            
            .user-avatar {
                width: 50px;
                height: 50px;
                font-size: 1.2rem;
            }
            
            .user-name {
                font-size: 0.9rem;
            }
            
            .user-email {
                font-size: 0.75rem;
            }
            
            .user-role-modern {
                font-size: 0.6rem;
                padding: 0.25rem 0.5rem;
            }
            
            .detail-value {
                font-size: 0.75rem;
            }
            
            .action-btn-modern {
                padding: 0.6rem;
                font-size: 0.75rem;
            }
        }
    </style>
    <script src="${pageContext.request.contextPath}/assests/js/universe-theme.js"></script>
</head>
<body class="universe-theme">
    <!-- Universe Background Layer -->
    <div class="universe-background"></div>
    
    <header class="header universe-header">
        <h1 class="universe-title">
            <i class="fas fa-users-cog"></i>
            Account Management - CourseHub E-Learning
        </h1>
      
    </header>

    <div class="container">
        <!-- Sidebar -->
        <nav class="sidebar universe-sidebar">
            <div class="nav-header">
                <h3>Admin Dashboard</h3>
            </div>
            
            <div class="nav-group">
                <div class="nav-group-title">Overview</div>
                <ul>
                    <li><a href="/Adaptive_Elearning/admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i><span>Tổng quan</span></a></li>
                    <li><a href="/Adaptive_Elearning/admin_notification.jsp"><i class="fas fa-bell"></i><span>Thông báo</span></a></li>
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">User Management</div>
                <ul>
                    <li><a href="/Adaptive_Elearning/admin_createadmin.jsp"><i class="fas fa-user-plus"></i><span>Tạo Admin</span></a></li>
                    <li><a href="/Adaptive_Elearning/admin_accountmanagement.jsp" class="active"><i class="fas fa-users"></i><span>Quản lý Tài Khoản</span></a></li>
                
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">Content Management</div>
                <ul>
                    <li><a href="/Adaptive_Elearning/admin_coursemanagement.jsp"><i class="fas fa-book"></i><span>Quản lý Khóa học</span></a></li>
                    <li><a href="/Adaptive_Elearning/admin_reportedcourse.jsp"><i class="fas fa-flag"></i><span>Khóa học bị báo cáo</span></a></li>
                    <li><a href="/Adaptive_Elearning/admin_reportedgroup.jsp"><i class="fas fa-users"></i><span>Nhóm bị báo cáo</span></a></li>
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">System</div>
                <ul>
                    <li><a href="#"><i class="fas fa-cog"></i><span>Cài đặt</span></a></li>
                    <li><a href="#"><i class="fas fa-chart-bar"></i><span>Báo cáo</span></a></li>
                    <li><a href="#"><i class="fas fa-sign-out-alt"></i><span>Đăng xuất</span></a></li>
                </ul>
            </div>
        </nav>

        <main class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fas fa-users-cog"></i> Quản lý tài khoản người dùng</h2>
                <p>Quản lý và theo dõi tài khoản người dùng trong hệ thống</p>
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
                        <i class="fas fa-wallet"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= currencyFormat.format(totalSystemBalance) %></h3>
                        <p>Tổng số dư hệ thống</p>
                    </div>
                </div>
                
                <% if (roleStats.containsKey("Admin")) { %>
                <div class="stat-card">
                    <div class="stat-icon admin">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= roleStats.get("Admin") %></h3>
                        <p>Quản trị viên</p>
                    </div>
                </div>
                <% } %>
                
                <% if (roleStats.containsKey("Learner")) { %>
                <div class="stat-card">
                    <div class="stat-icon student">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= roleStats.get("Learner") %></h3>
                        <p>Học viên</p>
                    </div>
                </div>
                <% } %>
                
                <% if (roleStats.containsKey("Instructor")) { %>
                <div class="stat-card">
                    <div class="stat-icon instructor">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= roleStats.get("Instructor") %></h3>
                        <p>Giảng viên</p>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- Search Section -->
            <div class="search-section">
                <form class="search-form" method="GET" action="admin_accountmanagement.jsp">
                 
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

            <!-- User Management Content Card -->
            <div class="content-card">
                <div class="card-header">
                    <h2><i class="fas fa-users"></i> Quản lý người dùng</h2>
                </div>
                <div class="card-body">
                    <!-- Filters -->
                    <div class="filters">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Tìm kiếm theo tên hoặc email..." id="searchInput">
                        </div>
                       
                    </div>

                    <!-- Users Table -->
                    <div class="table-container">
                        <% if (users.isEmpty()) { %>
                            <div class="loading">
                                <i class="fas fa-users-slash"></i>
                                <h3>Không có người dùng nào</h3>
                                <p>Hiện tại chưa có người dùng nào trong hệ thống phù hợp với tiêu chí tìm kiếm.</p>
                            </div>
                        <% } else { %>
                            <div class="table-wrapper">
                                <table>
                                <thead>
                                    <tr>
                                        <th>STT</th>
                                        <th>Người dùng</th>
                                        <th>Email</th>
                                        <th>Vai trò</th>
                                        <th>Ngày tạo</th>
                                        <th>Số dư</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        int stt = (currentPage - 1) * recordsPerPage + 1;
                                        for (Map<String, Object> user : users) { 
                                            String role = (String) user.get("role");
                                            String userName = (String) user.get("fullName");
                                            String userEmail = (String) user.get("email");
                                            String userId = (String) user.get("id");
                                            Long balance = (Long) user.get("systemBalance");
                                            Object creationTime = user.get("creationTime");
                                    %>
                                    <tr>
                                        <td><%= stt++ %></td>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 0.75rem;">
                                                
                                                <div>
                                                    <div style="font-weight: 600; color: #F8FAFC; font-size: 0.95rem;">
                                                        <%= userName != null ? userName : "N/A" %>
                                                    </div>
                                                   
                                                </div>
                                            </div>
                                        </td>
                                        <td style="color: rgba(6, 182, 212, 0.9); font-family: 'Monaco', monospace; font-size: 0.85rem;">
                                            <%= userEmail != null ? userEmail : "N/A" %>
                                        </td>
                                        <td>
                                            <% 
                                                String statusClass = "status-pending";
                                                String statusText = role != null ? role : "Unknown";
                                                String statusIcon = "fas fa-user";
                                                
                                                if ("Admin".equals(role)) {
                                                    statusClass = "status-admin";
                                                    statusIcon = "fas fa-crown";
                                                } else if ("Instructor".equals(role)) {
                                                    statusClass = "status-instructor";
                                                    statusIcon = "fas fa-chalkboard-teacher";
                                                } else if ("Learner".equals(role) || "Student".equals(role)) {
                                                    statusClass = "status-learner";
                                                    statusIcon = "fas fa-graduation-cap";
                                                } else if ("Inactive".equals(role)) {
                                                    statusClass = "status-dismissed";
                                                    statusIcon = "fas fa-user-slash";
                                                }
                                            %>
                                            <span class="status-badge <%= statusClass %>">
                                                <i class="<%= statusIcon %>"></i>
                                                <%= statusText %>
                                            </span>
                                        </td>
                                        <td style="font-size: 0.85rem; color: rgba(248, 250, 252, 0.8);">
                                            <% if (creationTime != null) { %>
                                                <%= dateFormat.format(creationTime) %>
                                            <% } else { %>
                                                N/A
                                            <% } %>
                                        </td>
                                        <td style="font-weight: 600; color: rgba(6, 182, 212, 0.9); font-family: 'Monaco', monospace;">
                                            <%= balance != null ? currencyFormat.format(balance) : "0 ₫" %>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <% if (!"Inactive".equals(role)) { %>
                                                    <a href="/Adaptive_Elearning/admin_edit_user_role.jsp?userId=<%= userId %>" 
                                                       class="btn btn-edit" title="Chỉnh sửa vai trò">
                                                        <i class="fas fa-edit"></i>
                                                        Sửa
                                                    </a>
                                                    <button class="btn btn-alert" 
                                                            onclick="deactivateUser('<%= userId %>')" 
                                                            title="Vô hiệu hóa người dùng">
                                                        <i class="fas fa-user-slash"></i>
                                                        Ban
                                                    </button>
                                                <% } else { %>
                                                    <button class="btn btn-dismiss" 
                                                            onclick="unbanUser('<%= userId %>')"
                                                            title="Khôi phục tài khoản">
                                                        <i class="fas fa-user-check"></i>
                                                        Unban
                                                    </button>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <% if (totalPages > 1) { %>
                <div class="pagination">
                    <div class="pagination-info">
                        Hiển thị <%= users.size() %> trên tổng <%= totalRecords %> bản ghi
                        <% if (!searchRole.isEmpty()) { %>
                            (Lọc theo: <strong><%= searchRole %></strong>)
                        <% } %>
                    </div>
                    <div class="pagination-controls">
                        <% if (currentPage > 1) { %>
                            <a href="?page=1&role=<%= searchRole %>&entries=<%= recordsPerPage %>">Đầu</a>
                            <a href="?page=<%= currentPage - 1 %>&role=<%= searchRole %>&entries=<%= recordsPerPage %>">Trước</a>
                        <% } else { %>
                            <span class="disabled">Đầu</span>
                            <span class="disabled">Trước</span>
                        <% } %>
                        
                        <span class="current">Trang <%= currentPage %> / <%= totalPages %></span>
                        
                        <% if (currentPage < totalPages) { %>
                            <a href="?page=<%= currentPage + 1 %>&role=<%= searchRole %>&entries=<%= recordsPerPage %>">Sau</a>
                            <a href="?page=<%= totalPages %>&role=<%= searchRole %>&entries=<%= recordsPerPage %>">Cuối</a>
                        <% } else { %>
                            <span class="disabled">Sau</span>
                            <span class="disabled">Cuối</span>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </main>
    </div>

    <script>
        // Enhanced JavaScript from notification.jsp
        document.addEventListener('DOMContentLoaded', function() {
            // Add universe theme class to body
            document.body.classList.add('universe-theme');

            // Create twinkling stars effect
            function createStars() {
                const starsContainer = document.createElement('div');
                starsContainer.className = 'stars-container';
                starsContainer.innerHTML = `
                    <div class="stars1"></div>
                    <div class="stars2"></div>
                    <div class="stars3"></div>
                `;
                document.body.prepend(starsContainer);
            }

            // Initialize universe theme
            createStars();

            // Add smooth scroll behavior
            document.documentElement.style.scrollBehavior = 'smooth';

            // Enhanced navigation effects
            const navLinks = document.querySelectorAll('.sidebar a');
            navLinks.forEach(link => {
                link.addEventListener('mouseenter', function() {
                    // Create ripple effect
                    const ripple = document.createElement('div');
                    ripple.style.cssText = `
                        position: absolute;
                        border-radius: 50%;
                        background: rgba(139, 92, 246, 0.6);
                        width: 10px;
                        height: 10px;
                        animation: ripple 0.6s linear;
                        pointer-events: none;
                        z-index: 1000;
                    `;
                    
                    const rect = this.getBoundingClientRect();
                    ripple.style.left = Math.random() * rect.width + 'px';
                    ripple.style.top = Math.random() * rect.height + 'px';
                    
                    this.appendChild(ripple);
                    setTimeout(() => ripple.remove(), 600);
                });
            });

            // Add CSS animations
            const style = document.createElement('style');
            style.textContent = `
                @keyframes ripple {
                    0% { transform: scale(0); opacity: 1; }
                    100% { transform: scale(4); opacity: 0; }
                }
                
                .stars1, .stars2, .stars3 {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    pointer-events: none;
                    z-index: -1;
                }

                .stars1 {
                    background: transparent url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="1" fill="%23ffffff" opacity="0.8"/><circle cx="80" cy="40" r="0.5" fill="%23ffffff" opacity="0.6"/><circle cx="40" cy="80" r="1" fill="%23ffffff" opacity="0.9"/></svg>') repeat;
                    animation: sparkle 50s linear infinite;
                }

                .stars2 {
                    background: transparent url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="60" cy="10" r="0.8" fill="%2306B6D4" opacity="0.7"/><circle cx="10" cy="60" r="0.6" fill="%238B5CF6" opacity="0.8"/></svg>') repeat;
                    animation: sparkle 100s linear infinite reverse;
                }

                .stars3 {
                    background: transparent url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="30" cy="50" r="0.4" fill="%23EC4899" opacity="0.6"/><circle cx="70" cy="70" r="0.7" fill="%2306B6D4" opacity="0.5"/></svg>') repeat;
                    animation: sparkle 75s linear infinite;
                }

                @keyframes sparkle {
                    from { transform: translateX(0); }
                    to { transform: translateX(-100px); }
                }
            `;
            document.head.appendChild(style);

            // Add universe glow effects to interactive elements
            const interactiveElements = document.querySelectorAll('button, .stat-card, .table-container, .search-section, .role-badge, .btn');
            interactiveElements.forEach(element => {
                element.addEventListener('mouseenter', function() {
                    this.style.filter = 'drop-shadow(0 0 10px rgba(139, 92, 246, 0.5))';
                });
                
                element.addEventListener('mouseleave', function() {
                    this.style.filter = 'none';
                });
            });

            // Enhanced table row hover effects
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-2px) scale(1.01)';
                    this.style.transition = 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)';
                });
                
                row.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });

            // Auto-hide alerts with enhanced animation
            setTimeout(() => {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    alert.style.transition = 'all 0.5s ease';
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-20px)';
                    setTimeout(() => alert.remove(), 500);
                });
            }, 5000);
        });

        // ===== MODERN CARD INTERACTIONS =====
        
        // Enhanced card animation on scroll
        function initCardAnimations() {
            const cards = document.querySelectorAll('.user-card');
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.animationPlayState = 'running';
                    }
                });
            }, {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            });

            cards.forEach(card => {
                observer.observe(card);
                card.style.animationPlayState = 'paused';
            });
        }

        // Enhanced hover effects
        function initCardHoverEffects() {
            const cards = document.querySelectorAll('.user-card');
            
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    // Add cosmic glow effect
                    this.style.boxShadow = `
                        0 20px 40px rgba(139, 92, 246, 0.4),
                        0 0 0 1px rgba(139, 92, 246, 0.6),
                        0 0 20px rgba(6, 182, 212, 0.3)
                    `;
                    
                    // Animate avatar
                    const avatar = this.querySelector('.user-avatar');
                    if (avatar) {
                        avatar.style.transform = 'scale(1.1) rotate(5deg)';
                        avatar.style.boxShadow = '0 12px 30px rgba(139, 92, 246, 0.6)';
                    }
                    
                    // Animate details
                    const details = this.querySelectorAll('.detail-item');
                    details.forEach((detail, index) => {
                        setTimeout(() => {
                            detail.style.transform = 'translateY(-3px) scale(1.02)';
                        }, index * 50);
                    });
                });
                
                card.addEventListener('mouseleave', function() {
                    // Reset effects
                    this.style.boxShadow = '';
                    
                    const avatar = this.querySelector('.user-avatar');
                    if (avatar) {
                        avatar.style.transform = '';
                        avatar.style.boxShadow = '';
                    }
                    
                    const details = this.querySelectorAll('.detail-item');
                    details.forEach(detail => {
                        detail.style.transform = '';
                    });
                });
            });
        }

        // Cosmic particle effect on card click
        function createParticleEffect(element) {
            const rect = element.getBoundingClientRect();
            const particles = 12;
            
            for (let i = 0; i < particles; i++) {
                const particle = document.createElement('div');
                particle.style.cssText = `
                    position: fixed;
                    width: 4px;
                    height: 4px;
                    background: linear-gradient(45deg, #8B5CF6, #06B6D4);
                    border-radius: 50%;
                    pointer-events: none;
                    z-index: 9999;
                    left: ${rect.left + rect.width / 2}px;
                    top: ${rect.top + rect.height / 2}px;
                `;
                
                document.body.appendChild(particle);
                
                const angle = (i / particles) * Math.PI * 2;
                const velocity = 100 + Math.random() * 50;
                const dx = Math.cos(angle) * velocity;
                const dy = Math.sin(angle) * velocity;
                
                particle.animate([
                    { 
                        transform: 'translate(0, 0) scale(1)',
                        opacity: 1
                    },
                    { 
                        transform: `translate(${dx}px, ${dy}px) scale(0)`,
                        opacity: 0
                    }
                ], {
                    duration: 800,
                    easing: 'cubic-bezier(0.4, 0, 0.6, 1)'
                }).onfinish = () => particle.remove();
            }
        }

        // Enhanced action button interactions
        function initActionButtons() {
            document.querySelectorAll('.action-btn-modern').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    // Create ripple effect
                    const ripple = document.createElement('span');
                    const rect = this.getBoundingClientRect();
                    const size = Math.max(rect.width, rect.height);
                    const x = e.clientX - rect.left - size / 2;
                    const y = e.clientY - rect.top - size / 2;
                    
                    ripple.style.cssText = `
                        position: absolute;
                        width: ${size}px;
                        height: ${size}px;
                        left: ${x}px;
                        top: ${y}px;
                        background: rgba(255, 255, 255, 0.4);
                        border-radius: 50%;
                        transform: scale(0);
                        pointer-events: none;
                    `;
                    
                    this.appendChild(ripple);
                    
                    ripple.animate([
                        { transform: 'scale(0)', opacity: 1 },
                        { transform: 'scale(4)', opacity: 0 }
                    ], {
                        duration: 600,
                        easing: 'ease-out'
                    }).onfinish = () => ripple.remove();
                    
                    // Particle effect
                    createParticleEffect(this);
                });
            });
        }

        // Initialize all card interactions when page loads
        document.addEventListener('DOMContentLoaded', function() {
            initCardAnimations();
            initCardHoverEffects();
            initActionButtons();
            
            // Add stagger animation to cards
            const cards = document.querySelectorAll('.user-card');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
            });
        });

        function goToPage(page) {
            if (page >= 1 && page <= <%= totalPages %>) {
                showLoading('Đang chuyển trang...');
                window.location.href = '?page=' + page + '&role=<%= searchRole %>&entries=<%= recordsPerPage %>';
            }
        }

        function editRole(userId, currentRole) {
            showLoading('Đang chuyển đến trang chỉnh sửa...');
            window.location.href = '/Adaptive_Elearning/admin_edit_user_role.jsp?userId=' + userId;
        }

        function deactivateUser(userId) {
            if (confirm('Bạn có chắc chắn muốn vô hiệu hóa người dùng này? Hành động này sẽ chuyển trạng thái của họ thành "Inactive".')) {
                showLoading('Đang vô hiệu hóa người dùng...');
                
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = 'admin_accountmanagement.jsp';

                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'deactivateUser';

                var userIdInput = document.createElement('input');
                userIdInput.type = 'hidden';
                userIdInput.name = 'userId';
                userIdInput.value = userId;

                form.appendChild(actionInput);
                form.appendChild(userIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function unbanUser(userId) {
            if (confirm('Bạn có chắc chắn muốn khôi phục người dùng này? Họ sẽ được chuyển về vai trò Learner.')) {
                showLoading('Đang khôi phục tài khoản...');
                
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = 'admin_accountmanagement.jsp';

                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'unbanUser';

                var userIdInput = document.createElement('input');
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
            // Tìm dropdown entries (có thể có nhiều dropdown khác nhau)
            const entriesSelect = document.getElementById('entriesSelect') || document.getElementById('entries');
            if (entriesSelect) {
                const selectedValue = entriesSelect.value;
                showLoading('Đang cập nhật số bản ghi hiển thị...');
                
                // Tạo URL mới với entries và reset page về 1
                const currentUrl = new URL(window.location);
                currentUrl.searchParams.set('entries', selectedValue);
                currentUrl.searchParams.set('page', '1'); // Reset về trang đầu
                
                // Giữ nguyên role filter nếu có
                const roleSelect = document.getElementById('role');
                if (roleSelect && roleSelect.value) {
                    currentUrl.searchParams.set('role', roleSelect.value);
                }
                
                window.location.href = currentUrl.toString();
            }
        }

        // Đồng bộ giá trị giữa 2 dropdown entries
        document.addEventListener('DOMContentLoaded', function() {
            const entriesSelect1 = document.getElementById('entries');
            const entriesSelect2 = document.getElementById('entriesSelect');
            
            if (entriesSelect1 && entriesSelect2) {
                // Đồng bộ giá trị ban đầu
                const currentEntries = '<%= recordsPerPage %>';
                entriesSelect1.value = currentEntries;
                entriesSelect2.value = currentEntries;
                
                // Đồng bộ khi thay đổi
                entriesSelect1.addEventListener('change', function() {
                    entriesSelect2.value = this.value;
                });
                
                entriesSelect2.addEventListener('change', function() {
                    entriesSelect1.value = this.value;
                });
            }
            
            // Initialize search functionality
            const searchInput = document.getElementById('searchInput');
            if (searchInput) {
                let searchTimeout;
                searchInput.addEventListener('input', function() {
                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(() => {
                        filterTable(this.value);
                    }, 300);
                });
            }
        });

        function filterTable(searchTerm) {
            const tableRows = document.querySelectorAll('tbody tr');
            const searchLower = searchTerm.toLowerCase();
            
            tableRows.forEach(row => {
                const userName = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                const userEmail = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                
                if (userName.includes(searchLower) || userEmail.includes(searchLower)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function showLoading(message = 'Đang tải...') {
            // Remove existing loading
            const existingLoading = document.getElementById('loading-overlay');
            if (existingLoading) {
                existingLoading.remove();
            }
            
            // Create loading overlay
            const loadingOverlay = document.createElement('div');
            loadingOverlay.id = 'loading-overlay';
            loadingOverlay.innerHTML = `
                <div style="
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(15, 15, 35, 0.95);
                    backdrop-filter: blur(15px);
                    z-index: 9999;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: white;
                    font-size: 1.2rem;
                ">
                    <div style="
                        background: linear-gradient(145deg, rgba(30, 27, 75, 0.95), rgba(139, 92, 246, 0.1));
                        backdrop-filter: blur(20px);
                        padding: 2.5rem 3.5rem;
                        border-radius: 20px;
                        border: 1px solid rgba(139, 92, 246, 0.3);
                        box-shadow: 0 25px 50px -12px rgba(139, 92, 246, 0.4);
                        text-align: center;
                        animation: loadingPulse 2s ease-in-out infinite;
                    ">
                        <i class="fas fa-spinner fa-spin" style="color: #06B6D4; font-size: 2.5rem; margin-bottom: 1.5rem; display: block;"></i>
                        <div style="
                            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
                            -webkit-background-clip: text;
                            -webkit-text-fill-color: transparent;
                            background-clip: text;
                            font-weight: 600;
                        ">${message}</div>
                    </div>
                </div>
            `;
            
            // Add loading animation
            const loadingStyle = document.createElement('style');
            loadingStyle.textContent = `
                @keyframes loadingPulse {
                    0%, 100% { transform: scale(1); opacity: 0.9; }
                    50% { transform: scale(1.05); opacity: 1; }
                }
            `;
            document.head.appendChild(loadingStyle);
            
            document.body.appendChild(loadingOverlay);
        }
    </script>
    <script src="${pageContext.request.contextPath}/assests/js/universe-theme.js"></script>
</body>
</html>
