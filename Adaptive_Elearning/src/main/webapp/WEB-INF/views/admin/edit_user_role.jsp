<%@page import="controller.AccountManagementController"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String userId = request.getParameter("userId");
    String action = request.getParameter("action");
    Map<String, Object> user = null;
    String error = null;
    String success = null;
    
    // Handle form submission
    if ("POST".equals(request.getMethod()) && "updateRole".equals(action)) {
        String newRole = request.getParameter("newRole");
        
        if (userId != null && newRole != null && !newRole.trim().isEmpty()) {
            try {
                AccountManagementController controller = new AccountManagementController();
                boolean result = controller.updateUserRole(userId, newRole);
                
                if (result) {
                    response.sendRedirect("/Adaptive_Elearning/admin_accountmanagement.jsp?updated=success");
                    return;
                } else {
                    error = "Không thể cập nhật vai trò người dùng.";
                }
            } catch (Exception e) {
                error = "Lỗi: " + e.getMessage();
            }
        } else {
            error = "Thông tin không hợp lệ.";
        }
    }
    
    // Load user information
    if (userId != null) {
        try {
            AccountManagementController controller = new AccountManagementController();
            user = controller.getUserById(userId);
            
            if (user == null) {
                error = "Không tìm thấy người dùng.";
            }
        } catch (Exception e) {
            error = "Lỗi khi tải thông tin người dùng: " + e.getMessage();
        }
    } else {
        error = "ID người dùng không hợp lệ.";
    }
    
    // Available roles
    List<String> availableRoles = new ArrayList<>();
    availableRoles.add("Admin");
    availableRoles.add("Learner");
    availableRoles.add("Instructor");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User Role - CourseHub E-Learning</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assests/css/universe-background.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-performance.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body { 
            font-family: 'Exo 2', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            min-height: 100vh; 
            display: flex; 
            align-items: center; 
            justify-content: center;
            background-color: #281f52; 
        }
        
        .edit-container {
            background: rgba(30, 27, 75, 0.85);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(139, 92, 246, 0.3);
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(107, 70, 193, 0.3);
            width: 100%;
            max-width: 500px;
            margin: 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .edit-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, 
                transparent, 
                var(--cosmic-cyan), 
                var(--nebula-pink), 
                var(--galaxy-violet), 
                transparent
            );
            animation: energyFlow 3s linear infinite;
        }
        
        .header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .header h1 {
            color: #F8FAFC;
            font-size: 1.8rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
        }
        
        .header p {
            color: #666;
            font-size: 0.9rem;
        }
        
        .user-info {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            border-left: 4px solid #667eea;
        }
        
        .user-info h3 {
            color: #333;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .user-detail {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .user-detail:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        
        .user-detail .label {
            font-weight: 600;
            color: #495057;
        }
        
        .user-detail .value {
            color: #6c757d;
        }
        
        .role-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        
        .role-admin { background: #f8d7da; color: #721c24; }
        .role-learner { background: #d4edda; color: #155724; }
        .role-instructor { background: #d1ecf1; color: #0c5460; }
        .role-inactive { background: #f8f9fa; color: #6c757d; }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.75rem;
            font-weight: 600;
            color: #333;
            font-size: 1rem;
        }
        
        .form-group select {
            width: 100%;
            padding: 1rem;
            border: 2px solid #e1e5e9;
            border-radius: 12px;
            font-size: 1rem;
            background: white;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-group select option {
            padding: 0.5rem;
        }
        
        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .btn {
            flex: 1;
            padding: 1rem 1.5rem;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        .alert {
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .loading {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            align-items: center;
            justify-content: center;
        }
        
        .loading-content {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            text-align: center;
            color: #333;
        }
        
        .loading-content i {
            font-size: 2rem;
            color: #667eea;
            margin-bottom: 1rem;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        @media (max-width: 768px) {
            .edit-container {
                margin: 1rem;
                padding: 1.5rem;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .user-detail {
                flex-direction: column;
                gap: 0.25rem;
            }
        }
    </style>
    <script src="${pageContext.request.contextPath}/assests/js/universe-theme.js"></script>
</head>
<body class="universe-theme">
    <!-- Universe Background Layer -->
    <div class="universe-background"></div>
    
    <div class="edit-container universe-card">
        <div class="header">
            <h1 class="universe-title"><i class="fas fa-user-edit"></i> Chỉnh sửa vai trò người dùng</h1>
            <p class="universe-text">Cập nhật vai trò cho tài khoản người dùng trong hệ thống</p>
        </div>
        
        <% if (error != null) { %>
            <div class="alert alert-error universe-card" style="background: rgba(249, 115, 22, 0.2); border-color: rgba(249, 115, 22, 0.5); color: #F8FAFC;">
                <i class="fas fa-exclamation-triangle"></i>
                <%= error %>
            </div>
        <% } %>
        
        <% if (success != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= success %>
            </div>
        <% } %>
        
        <% if (user != null) { %>
            <div class="user-info">
                <h3><i class="fas fa-user"></i> Thông tin người dùng</h3>
                <div class="user-detail">
                    <span class="label">Họ tên:</span>
                    <span class="value"><%= user.get("fullName") != null ? user.get("fullName") : "N/A" %></span>
                </div>
                <div class="user-detail">
                    <span class="label">Email:</span>
                    <span class="value"><%= user.get("email") != null ? user.get("email") : "N/A" %></span>
                </div>
                <div class="user-detail">
                    <span class="label">Vai trò hiện tại:</span>
                    <span class="value">
                        <% 
                        String currentRole = (String) user.get("role");
                        String roleClass = "role-learner";
                        if ("Admin".equals(currentRole)) {
                            roleClass = "role-admin";
                        } else if ("Instructor".equals(currentRole)) {
                            roleClass = "role-instructor";
                        } else if ("Inactive".equals(currentRole)) {
                            roleClass = "role-inactive";
                        }
                        %>
                        <span class="role-badge <%= roleClass %>">
                            <%= currentRole != null ? currentRole : "Unknown" %>
                        </span>
                    </span>
                </div>
                <div class="user-detail">
                    <span class="label">ID:</span>
                    <span class="value"><%= user.get("id") %></span>
                </div>
            </div>
            
            <form method="POST" action="" onsubmit="showLoading()">
                <input type="hidden" name="action" value="updateRole">
                <input type="hidden" name="userId" value="<%= user.get("id") %>">
                
                <div class="form-group">
                    <label for="newRole">
                        <i class="fas fa-user-tag"></i>
                        Chọn vai trò mới:
                    </label>
                    <select name="newRole" id="newRole" required>
                        <option value="">-- Chọn vai trò --</option>
                        <% for (String role : availableRoles) { %>
                            <option value="<%= role %>" <%= role.equals(currentRole) ? "selected" : "" %>>
                                <%= role %>
                            </option>
                        <% } %>
                    </select>
                </div>
                
                <div class="button-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i>
                        Cập nhật vai trò
                    </button>
                    <a href="/Adaptive_Elearning/admin_accountmanagement.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại
                    </a>
                </div>
            </form>
        <% } else { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i>
                Không thể tải thông tin người dùng.
            </div>
            <div class="button-group">
                <a href="/Adaptive_Elearning/admin_accountmanagement.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại
                </a>
            </div>
        <% } %>
    </div>
    
    <div id="loading" class="loading">
        <div class="loading-content">
            <i class="fas fa-spinner"></i>
            <p>Đang cập nhật vai trò...</p>
        </div>
    </div>
    
    <script>
        function showLoading() {
            document.getElementById('loading').style.display = 'flex';
        }
        
        // Hide loading on page load
        window.addEventListener('load', function() {
            document.getElementById('loading').style.display = 'none';
        });
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const newRole = document.getElementById('newRole').value;
            const currentRole = '<%= user != null ? user.get("role") : "" %>';
            
            if (!newRole) {
                e.preventDefault();
                alert('Vui lòng chọn vai trò mới.');
                return;
            }
            
            if (newRole === currentRole) {
                e.preventDefault();
                alert('Vai trò mới phải khác với vai trò hiện tại.');
                return;
            }
            
            if (!confirm('Bạn có chắc chắn muốn thay đổi vai trò của người dùng này?')) {
                e.preventDefault();
                return;
            }
        });
    </script>
    
    <!-- Admin Performance Optimizer -->
    <script src="${pageContext.request.contextPath}/assets/js/admin-performance.js"></script>
</body>
</html>