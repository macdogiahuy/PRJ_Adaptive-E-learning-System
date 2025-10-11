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
    <title>Create Admin - CourseHub E-Learning</title>
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

        .stats-card {
            background: rgba(255, 255, 255, 0.95);
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .stats-icon {
            width: 60px;
            height: 60px;
            background: #667eea;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        .stats-info h3 {
            color: #333;
            margin-bottom: 0.25rem;
        }

        .stats-info p {
            color: #666;
            font-size: 0.9rem;
        }

        .form-card {
            background: rgba(255, 255, 255, 0.95);
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

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
            color: #333;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
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
            color: #666;
            cursor: pointer;
            font-size: 1.1rem;
            transition: color 0.3s ease;
            z-index: 10;
        }

        .password-toggle:hover {
            color: #667eea;
        }

        .password-toggle:focus {
            outline: none;
            color: #667eea;
        }

        .form-group input[required] + .required-marker {
            color: #dc3545;
            margin-left: 0.25rem;
        }

        .btn {
            padding: 0.75rem 2rem;
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

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e1e5e9;
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

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <h1>
            <i class="fas fa-user-plus"></i>
            Create Admin - CourseHub E-Learning
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
                <li><a href="/adaptive_elearning/admin_notification.jsp"><i class="fas fa-bell"></i> Thông báo</a></li>
                <li><a href="/adaptive_elearning/admin_createadmin.jsp"  class="active"><i class="fas fa-user-plus"></i> Tạo Admin</a></li>
                <li><a href="/adaptive_elearning/admin_accountmanagement.jsp"><i class="fas fa-users"></i> Quản lý Tài Khoản</a></li>
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
                <h2><i class="fas fa-user-plus"></i> Tạo tài khoản Admin mới</h2>
                <p>Tạo tài khoản quản trị viên mới cho hệ thống CourseHub E-Learning</p>
            </div>

            <!-- Current Stats -->
            <div class="stats-card">
                <div class="stats-icon">
                    <i class="fas fa-users-cog"></i>
                </div>
                <div class="stats-info">
                    <h3>Tổng số Admin hiện tại: <%= adminCount %></h3>
                    <p>Số lượng quản trị viên đang hoạt động trong hệ thống</p>
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
            <div class="form-card">
                <form method="POST" action="/adaptive_elearning/admin_createadmin.jsp" onsubmit="return validateForm()">
                    <input type="hidden" name="action" value="createAdmin">
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="userName">Tên đăng nhập <span class="required-marker">*</span></label>
                            <input type="text" id="userName" name="userName" required minlength="3" maxlength="50">
                            <small>Tối thiểu 3 ký tự, không có khoảng trắng hoặc ký tự đặc biệt</small>
                        </div>

                        <div class="form-group">
                            <label for="email">Email <span class="required-marker">*</span></label>
                            <input type="email" id="email" name="email" required>
                            <small>Địa chỉ email hợp lệ sẽ được sử dụng để đăng nhập</small>
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="password">Mật khẩu <span class="required-marker">*</span></label>
                            <div class="password-container">
                                <input type="password" id="password" name="password" required minlength="6">
                                <button type="button" class="password-toggle" onclick="togglePassword('password', this)">
                                    <i class="fas fa-eye" aria-hidden="true"></i>
                                </button>
                            </div>
                            <small>Tối thiểu 6 ký tự, nên bao gồm chữ hoa, chữ thường và số</small>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Xác nhận mật khẩu <span class="required-marker">*</span></label>
                            <div class="password-container">
                                <input type="password" id="confirmPassword" name="confirmPassword" required minlength="6">
                                <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword', this)">
                                    <i class="fas fa-eye" aria-hidden="true"></i>
                                </button>
                            </div>
                            <small>Nhập lại mật khẩu để xác nhận</small>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="fullName">Họ và tên <span class="required-marker">*</span></label>
                        <input type="text" id="fullName" name="fullName" required maxlength="100">
                        <small>Họ và tên đầy đủ của quản trị viên</small>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="phone">Số điện thoại</label>
                            <input type="tel" id="phone" name="phone" pattern="[0-9]{10,11}" maxlength="15">
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
        </main>
    </div>

    <script>
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
                this.style.borderColor = '#dc3545';
                this.title = 'Mật khẩu không khớp';
            } else {
                this.style.borderColor = '#e1e5e9';
                this.title = '';
            }
        });
        
        // Username validation
        document.getElementById('userName').addEventListener('input', function() {
            const userName = this.value;
            const userNameRegex = /^[a-zA-Z0-9_]+$/;
            
            if (userName && !userNameRegex.test(userName)) {
                this.style.borderColor = '#dc3545';
                this.title = 'Chỉ được chứa chữ cái, số và dấu gạch dưới';
            } else {
                this.style.borderColor = '#e1e5e9';
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