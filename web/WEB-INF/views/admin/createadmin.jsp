<%@page import="controller.CreateAdminController"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Get status messages
    String created = request.getParameter("created");
    String errorMsg = request.getParameter("msg");
    String error = null;
    String success = null;
    
    if ("success".equals(created)) {
        success = "Admin đã được tạo thành công!";
    } else if ("exists".equals(created)) {
        error = "Tên đăng nhập hoặc email đã tồn tại!";
    } else if ("error".equals(created)) {
        error = "Lỗi khi tạo admin: " + (errorMsg != null ? errorMsg : "Unknown error");
    } else if ("invalid".equals(created)) {
        error = "Thông tin không hợp lệ hoặc mật khẩu không khớp!";
    }
    
    // Get admin count for display
    int adminCount = 0;
    try {
        CreateAdminController controller = new CreateAdminController();
        if (controller.testDatabaseConnection()) {
            adminCount = controller.getUserCount();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo Admin - CourseHub Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
                radial-gradient(circle at 20% 50%, rgba(139, 92, 246, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(6, 182, 212, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 40% 80%, rgba(236, 72, 153, 0.3) 0%, transparent 50%);
            pointer-events: none;
            z-index: -1;
        }

        .header {
           background:linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05)) ;
            backdrop-filter: blur(15px);
            padding: 1.5rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(139, 92, 246, 0.4);
            position: relative;
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

        .page-header p {
            color: rgba(248, 250, 252, 0.8);
            margin-top: 0.5rem;
        }

        /* Statistics Card */
        .stats-container {
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
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .stat-card::before {
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

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(139, 92, 246, 0.3);
            border-color: rgba(139, 92, 246, 0.4);
        }

        .stat-card:hover::before {
            opacity: 1;
        }

        .stat-card .icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
            color: white;
            position: relative;
            z-index: 1;
        }

        .stat-card .stats-info {
            position: relative;
            z-index: 1;
        }

        .stat-card h3 {
            font-size: 1.1rem;
            color: #F8FAFC;
            margin-bottom: 0.5rem;
            font-weight: 600;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-card p {
            color: rgba(248, 250, 252, 0.8);
            font-size: 0.9rem;
        }

        .stat-card .value {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 0 0 20px rgba(139, 92, 246, 0.8);
        }

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
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-body {
            padding: 2rem;
            background: transparent;
        }

        /* Form Styling */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #F8FAFC;
            text-shadow: 0 0 10px rgba(139, 92, 246, 0.6);
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid rgba(139, 92, 246, 0.2);
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(16px);
            border-radius: 12px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            color: #F8FAFC;
        }

        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: rgba(248, 250, 252, 0.6);
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #8B5CF6;
            box-shadow: 0 0 20px rgba(139, 92, 246, 0.3);
        }

        .form-group small {
            color: rgba(248, 250, 252, 0.7);
            font-size: 0.8rem;
            margin-top: 0.25rem;
            display: block;
        }

        /* Password field with toggle icon */
        .password-container {
            position: relative;
            display: flex;
            align-items: center;
        }

        .password-container input {
            padding-right: 3rem !important;
        }

        .password-toggle {
            position: absolute;
            right: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: rgba(248, 250, 252, 0.6);
            cursor: pointer;
            font-size: 1.1rem;
            transition: color 0.3s ease;
            z-index: 10;
        }

        .password-toggle:hover {
            color: #8B5CF6;
        }

        .password-toggle:focus {
            outline: none;
            color: #8B5CF6;
        }

        .required-marker {
            color: #EC4899;
            margin-left: 0.25rem;
        }

        /* Buttons */
        .btn {
            padding: 0.75rem 1.5rem;
            border: 2px solid rgba(139, 92, 246, 0.2);
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            color: #F8FAFC;
            border-radius: 12px;
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
            color: white;
            border: none;
        }

        .btn-secondary {
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.2), rgba(139, 92, 246, 0.1));
            border-color: rgba(139, 92, 246, 0.3);
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(139, 92, 246, 0.3);
        }

        .btn-primary:hover {
            box-shadow: 0 10px 20px rgba(139, 92, 246, 0.4);
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid rgba(139, 92, 246, 0.2);
        }

        /* Alert Messages */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            backdrop-filter: blur(16px);
            border: 1px solid;
            font-weight: 500;
        }

        .alert-success {
            background: linear-gradient(145deg, rgba(34, 197, 94, 0.2), rgba(34, 197, 94, 0.1));
            color: #86EFAC;
            border-color: rgba(34, 197, 94, 0.3);
        }

        .alert-error {
            background: linear-gradient(145deg, rgba(239, 68, 68, 0.2), rgba(239, 68, 68, 0.1));
            color: #FCA5A5;
            border-color: rgba(239, 68, 68, 0.3);
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

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .stats-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <script src="${pageContext.request.contextPath}/assests/js/universe-theme.js"></script>
</head>
<body class="universe-theme">
    <!-- Universe Background Layer -->
    <div class="universe-background"></div>
    
    <header class="header universe-header">
        <h1 class="universe-title"><i class="fas fa-user-plus"></i> Tạo Admin - CourseHub Admin</h1>
        <div class="user-info"><span>Xin chào, Admin</span><i class="fas fa-user-circle"></i></div>
    </header>

    <div class="container">
        <!-- Sidebar -->
        <nav class="sidebar universe-sidebar">
            <div class="nav-header">
                <h3><i class="fas fa-rocket"></i> Admin Panel</h3>
            </div>
            
            <div class="nav-group">
                <div class="nav-group-title">Dashboard & Overview</div>
                <ul>
                    <li><a href="/Adaptive_Elearning/admin_dashboard.jsp">
                        <i class="fas fa-tachometer-alt"></i><span>Tổng quan</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_notification.jsp">
                        <i class="fas fa-bell"></i><span>Thông báo</span>
                    </a></li>
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">User Management</div>
                <ul>
                    <li><a href="/Adaptive_Elearning/admin_createadmin.jsp" class="active">
                        <i class="fas fa-user-plus"></i><span>Tạo Admin</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_accountmanagement.jsp">
                        <i class="fas fa-users"></i><span>Quản lý Tài Khoản</span>
                    </a></li>
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">Content Management</div>
                <ul>
                    <li><a href="/Adaptive_Elearning/admin_reportedcourse.jsp">
                        <i class="fas fa-flag"></i><span>Báo cáo Khóa học</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_coursemanagement.jsp">
                        <i class="fa-solid fa-bars-progress"></i><span>Quản lý Khóa học</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_reportedgroup.jsp">
                        <i class="fas fa-users-cog"></i><span>Báo cáo Nhóm</span>
                    </a></li>
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">System</div>
                <ul>
                    <li><a href="#">
                        <i class="fas fa-chart-bar"></i><span>Báo cáo</span>
                    </a></li>
                    <li><a href="#">
                        <i class="fas fa-cog"></i><span>Cài đặt</span>
                    </a></li>
                    <li><a href="#">
                        <i class="fas fa-sign-out-alt"></i><span>Đăng xuất</span>
                    </a></li>
                </ul>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fas fa-user-plus"></i> Tạo tài khoản Admin mới</h2>
                <p>Tạo tài khoản quản trị viên mới cho hệ thống CourseHub E-Learning</p>
            </div>

            <!-- Current Stats -->
            <div class="stats-container">
                <div class="stat-card">
                    <div class="icon">
                        <i class="fas fa-users-cog"></i>
                    </div>
                    <div class="stats-info">
                        <h3>Tổng số Admin hiện tại</h3>
                        <div class="value"><%= adminCount %></div>
                        <p>Số lượng quản trị viên đang hoạt động</p>
                    </div>
                </div>
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

            <!-- Create Admin Form -->
            <div class="content-card">
                <div class="card-header">
                    <h2><i class="fas fa-user-plus"></i> Thông tin Admin mới</h2>
                </div>
                <div class="card-body">
                    <form method="POST" action="/Adaptive_Elearning/admin_createadmin.jsp" onsubmit="return validateForm()">
                        <input type="hidden" name="action" value="createAdmin">
                        
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="userName">Tên đăng nhập <span class="required-marker">*</span></label>
                                <input type="text" id="userName" name="userName" required minlength="3" maxlength="50" placeholder="Nhập tên đăng nhập">
                                <small>Tối thiểu 3 ký tự, không có khoảng trắng hoặc ký tự đặc biệt</small>
                            </div>

                            <div class="form-group">
                                <label for="email">Email <span class="required-marker">*</span></label>
                                <input type="email" id="email" name="email" required placeholder="admin@coursehub.com">
                                <small>Địa chỉ email hợp lệ sẽ được sử dụng để đăng nhập</small>
                            </div>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="password">Mật khẩu <span class="required-marker">*</span></label>
                                <div class="password-container">
                                    <input type="password" id="password" name="password" required minlength="6" placeholder="Nhập mật khẩu">
                                    <button type="button" class="password-toggle" onclick="togglePassword('password', this)">
                                        <i class="fas fa-eye" aria-hidden="true"></i>
                                    </button>
                                </div>
                                <small>Tối thiểu 6 ký tự, nên bao gồm chữ hoa, chữ thường và số</small>
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword">Xác nhận mật khẩu <span class="required-marker">*</span></label>
                                <div class="password-container">
                                    <input type="password" id="confirmPassword" name="confirmPassword" required minlength="6" placeholder="Nhập lại mật khẩu">
                                    <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword', this)">
                                        <i class="fas fa-eye" aria-hidden="true"></i>
                                    </button>
                                </div>
                                <small>Nhập lại mật khẩu để xác nhận</small>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="fullName">Họ và tên <span class="required-marker">*</span></label>
                            <input type="text" id="fullName" name="fullName" required maxlength="100" placeholder="Nhập họ và tên đầy đủ">
                            <small>Họ và tên đầy đủ của quản trị viên</small>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="phone">Số điện thoại</label>
                                <input type="tel" id="phone" name="phone" pattern="[0-9]{10,11}" maxlength="15" placeholder="0123456789">
                                <small>Số điện thoại liên hệ (không bắt buộc)</small>
                            </div>

                            <div class="form-group">
                                <label for="dateOfBirth">Ngày sinh</label>
                                <input type="date" id="dateOfBirth" name="dateOfBirth" max="<%= new SimpleDateFormat("yyyy-MM-dd").format(new Date()) %>">
                                <small>Ngày sinh của quản trị viên (không bắt buộc)</small>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="bio">Giới thiệu</label>
                            <textarea id="bio" name="bio" rows="4" maxlength="500" placeholder="Mô tả ngắn về quản trị viên này..."></textarea>
                            <small>Thông tin bổ sung về quản trị viên (tối đa 500 ký tự)</small>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary" onclick="resetForm()">
                                <i class="fas fa-redo"></i> Đặt lại
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-user-plus"></i> Tạo Admin
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <!-- Universe Theme Script -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Add universe theme class to body
            document.body.classList.add('universe-theme');

            // Create twinkling stars effect
            function createStars() {
                const starsContainer = document.createElement('div');
                starsContainer.className = 'stars-container';
                starsContainer.innerHTML = `
                    <div class="stars"></div>
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
                        left: 50%;
                        top: 50%;
                        width: 0;
                        height: 0;
                        border-radius: 50%;
                        background: radial-gradient(circle, rgba(139, 92, 246, 0.6) 0%, transparent 70%);
                        transform: translate(-50%, -50%);
                        animation: ripple 0.6s ease-out;
                        pointer-events: none;
                        z-index: 0;
                    `;
                    
                    this.style.position = 'relative';
                    this.appendChild(ripple);
                    
                    setTimeout(() => ripple.remove(), 600);
                });

                // Add click animation
                link.addEventListener('click', function(e) {
                    const clickRipple = document.createElement('div');
                    clickRipple.style.cssText = `
                        position: absolute;
                        left: 50%;
                        top: 50%;
                        width: 0;
                        height: 0;
                        border-radius: 50%;
                        background: radial-gradient(circle, rgba(6, 182, 212, 0.8) 0%, transparent 70%);
                        transform: translate(-50%, -50%);
                        animation: click-ripple 0.3s ease-out;
                        pointer-events: none;
                        z-index: 0;
                    `;
                    
                    this.appendChild(clickRipple);
                    setTimeout(() => clickRipple.remove(), 300);
                });
            });

            // Add CSS animations
            const style = document.createElement('style');
            style.textContent = `
                @keyframes ripple {
                    to {
                        width: 200px;
                        height: 200px;
                        opacity: 0;
                    }
                }
                
                @keyframes click-ripple {
                    to {
                        width: 100px;
                        height: 100px;
                        opacity: 0;
                    }
                }
                
                @keyframes float-particle {
                    0% {
                        transform: translateY(0) rotate(0deg);
                        opacity: 1;
                    }
                    100% {
                        transform: translateY(-100px) rotate(360deg);
                        opacity: 0;
                    }
                }
                
                .nav-group {
                    animation: slideInLeft 0.6s ease-out;
                }
                
                .nav-group:nth-child(2) { animation-delay: 0.1s; }
                .nav-group:nth-child(3) { animation-delay: 0.2s; }
                .nav-group:nth-child(4) { animation-delay: 0.3s; }
                .nav-group:nth-child(5) { animation-delay: 0.4s; }
                
                @keyframes slideInLeft {
                    from {
                        opacity: 0;
                        transform: translateX(-30px);
                    }
                    to {
                        opacity: 1;
                        transform: translateX(0);
                    }
                }
            `;
            document.head.appendChild(style);

            // Add universe glow effects to interactive elements
            const interactiveElements = document.querySelectorAll('button, .stat-card, .content-card, .form-group input, .form-group textarea');
            interactiveElements.forEach(element => {
                element.addEventListener('mouseenter', function() {
                    this.style.boxShadow = '0 0 30px rgba(139, 92, 246, 0.4)';
                });
                element.addEventListener('mouseleave', function() {
                    if (!this.matches(':focus')) {
                        this.style.boxShadow = '';
                    }
                });
            });

            // Add cosmic particle effect for stat cards
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-10px) scale(1.02)';
                });
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });

            // Form validation enhancements with cosmic effects
            const formInputs = document.querySelectorAll('input, textarea');
            formInputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.style.boxShadow = '0 0 20px rgba(139, 92, 246, 0.5)';
                    this.style.borderColor = '#8B5CF6';
                });
                
                input.addEventListener('blur', function() {
                    if (!this.value) {
                        this.style.boxShadow = '';
                        this.style.borderColor = 'rgba(139, 92, 246, 0.2)';
                    }
                });
            });
        });

        // Toggle password visibility
        function togglePassword(fieldId, button) {
            const passwordField = document.getElementById(fieldId);
            const icon = button.querySelector('i');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
                button.setAttribute('aria-label', 'Hide password');
            } else {
                passwordField.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
                button.setAttribute('aria-label', 'Show password');
            }
        }
        
        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const userName = document.getElementById('userName').value;
            
            // Check password match
            if (password !== confirmPassword) {
                alert('Mật khẩu và xác nhận mật khẩu không khớp!');
                return false;
            }
            
            // Check username format
            const userNameRegex = /^[a-zA-Z0-9_]+$/;
            if (!userNameRegex.test(userName)) {
                alert('Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới!');
                return false;
            }
            
            // Check password strength
            if (password.length < 6) {
                alert('Mật khẩu phải có ít nhất 6 ký tự!');
                return false;
            }
            
            return confirm('Bạn có chắc chắn muốn tạo tài khoản Admin này?');
        }
        
        function resetForm() {
            if (confirm('Bạn có chắc chắn muốn đặt lại form?')) {
                document.querySelector('form').reset();
            }
        }
        
        // Real-time password confirmation check
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (confirmPassword && password !== confirmPassword) {
                this.style.borderColor = '#EC4899';
                this.title = 'Mật khẩu không khớp';
            } else {
                this.style.borderColor = 'rgba(139, 92, 246, 0.3)';
                this.title = '';
            }
        });
        
        // Username validation
        document.getElementById('userName').addEventListener('input', function() {
            const userName = this.value;
            const userNameRegex = /^[a-zA-Z0-9_]+$/;
            
            if (userName && !userNameRegex.test(userName)) {
                this.style.borderColor = '#EC4899';
                this.title = 'Chỉ được chứa chữ cái, số và dấu gạch dưới';
            } else {
                this.style.borderColor = 'rgba(139, 92, 246, 0.3)';
                this.title = '';
            }
        });

        // Initialize password toggle accessibility
        document.addEventListener('DOMContentLoaded', function() {
            const passwordToggles = document.querySelectorAll('.password-toggle');
            passwordToggles.forEach(function(toggle) {
                toggle.setAttribute('aria-label', 'Show password');
                toggle.setAttribute('title', 'Click to show/hide password');
            });
        });

        // Add keyboard support for password toggle
        document.addEventListener('keydown', function(e) {
            if (e.target.classList.contains('password-toggle') && (e.key === 'Enter' || e.key === ' ')) {
                e.preventDefault();
                e.target.click();
            }
        });
    </script>
</body>
</html>