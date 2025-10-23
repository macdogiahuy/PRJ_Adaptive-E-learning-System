<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="controller.CourseManagementController"%>
<%@page import="controller.CourseManagementController.Course"%>
<%@page import="java.util.*"%>
<%@page import="model.Users"%>

<%
    // Dữ liệu courses, phân trang, tìm kiếm
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    String search = (String) request.getAttribute("search");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalCourses = (Integer) request.getAttribute("totalCourses");
    String errorMessage = (String) request.getAttribute("errorMessage");

    if (search == null) {
        search = "";
    }
    if (currentPage == null) {
        currentPage = 1;
    }
    if (totalPages == null) {
        totalPages = 1;
    }
    if (totalCourses == null) {
        totalCourses = 0;
    }

    Users u = null;
    if (session != null) {
        u = (Users) session.getAttribute("account");
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang chủ - CourseHub</title>
        <link rel="stylesheet" href="assests/css/home.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            :root {
                --primary-color: #667eea;
                --primary-dark: #5a67d8;
                --secondary-color: #764ba2;
                --accent-color: #f093fb;
                --success-color: #48bb78;
                --warning-color: #ed8936;
                --error-color: #f56565;
                --text-primary: #1a202c;
                --text-secondary: #4a5568;
                --text-muted: #718096;
                --bg-primary: #ffffff;
                --bg-secondary: #f7fafc;
                --bg-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                --border-color: #e2e8f0;
                --shadow-sm: 0 2px 4px rgba(0,0,0,0.04);
                --shadow-md: 0 4px 12px rgba(0,0,0,0.08);
                --shadow-lg: 0 8px 24px rgba(0,0,0,0.12);
                --shadow-xl: 0 12px 32px rgba(0,0,0,0.16);
                --border-radius-sm: 8px;
                --border-radius-md: 12px;
                --border-radius-lg: 16px;
                --border-radius-xl: 24px;
            }

            body {
                font-family: 'Inter', sans-serif;
                background: var(--bg-secondary);
                color: var(--text-primary);
                line-height: 1.6;
                overflow-x: hidden;
            }

            /* Modern Header */
            .page-header {
                background: var(--bg-primary);
                box-shadow: var(--shadow-md);
                position: sticky;
                top: 0;
                z-index: 1000;
                backdrop-filter: blur(10px);
                border-bottom: 1px solid var(--border-color);
            }

            .top-nav {
                background: var(--bg-gradient);
                padding: 8px 0;
            }

            .top-nav nav a {
                color: white;
                text-decoration: none;
                padding: 8px 16px;
                border-radius: var(--border-radius-sm);
                font-weight: 500;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .top-nav nav a::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: rgba(255,255,255,0.1);
                transition: left 0.3s ease;
            }

            .top-nav nav a:hover::before,
            .top-nav nav a.active::before {
                left: 0;
            }

            .top-nav nav a:hover,
            .top-nav nav a.active {
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(255,255,255,0.2);
            }

            .middle-nav {
                padding: 16px 24px;
                display: flex;
                align-items: center;
                gap: 24px;
                max-width: 1400px;
                margin: 0 auto;
            }

            .logo {
                height: 48px;
                width: auto;
                transition: transform 0.3s ease;
            }

            .logo:hover {
                transform: scale(1.05);
            }

            /* Modern Search Bar */
            .search-bar {
                flex: 1;
                max-width: 600px;
                position: relative;
            }

            .search-container {
                position: relative;
                display: flex;
                background: var(--bg-secondary);
                border: 2px solid var(--border-color);
                border-radius: var(--border-radius-lg);
                overflow: hidden;
                transition: all 0.3s ease;
                box-shadow: var(--shadow-sm);
            }

            .search-container:focus-within {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                transform: translateY(-1px);
            }

            .search-container input {
                flex: 1;
                padding: 14px 20px;
                border: none;
                background: transparent;
                font-size: 16px;
                font-weight: 400;
                color: var(--text-primary);
                outline: none;
            }

            .search-container input::placeholder {
                color: var(--text-muted);
                font-weight: 400;
            }

            .search-btn {
                padding: 14px 20px;
                background: var(--bg-gradient);
                border: none;
                color: white;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .search-btn:hover {
                background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
                transform: translateX(-2px);
            }

            /* Modern User Actions */
            .user-actions {
                display: flex;
                align-items: center;
                gap: 16px;
            }

            /* User Avatar & Dropdown */
            .user-dropdown {
                position: relative;
            }

            .user-trigger {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 16px;
                background: var(--bg-primary);
                border: 2px solid var(--border-color);
                border-radius: var(--border-radius-xl);
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: var(--shadow-sm);
                position: relative;
                overflow: hidden;
            }

            .user-trigger::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: var(--bg-gradient);
                transition: left 0.3s ease;
                z-index: -1;
            }

            .user-trigger:hover::before {
                left: 0;
            }

            .user-trigger:hover {
                border-color: var(--primary-color);
                color: white;
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: var(--bg-gradient);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: 600;
                font-size: 16px;
                transition: transform 0.3s ease;
            }

            .user-trigger:hover .user-avatar {
                transform: scale(1.1);
            }

            .user-info {
                display: flex;
                flex-direction: column;
                align-items: flex-start;
            }

            .user-name {
                font-weight: 600;
                font-size: 14px;
                line-height: 1.2;
            }

            .user-role {
                font-size: 12px;
                opacity: 0.7;
                line-height: 1.2;
            }

            .dropdown-arrow {
                transition: transform 0.3s ease;
                margin-left: 4px;
            }

            .user-dropdown.open .dropdown-arrow {
                transform: rotate(180deg);
            }

            /* Notification Bell */
            .notification-bell {
                position: relative;
                width: 44px;
                height: 44px;
                border-radius: 50%;
                background: var(--bg-primary);
                border: 2px solid var(--border-color);
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: var(--shadow-sm);
            }

            .notification-bell:hover {
                border-color: var(--primary-color);
                transform: translateY(-2px);
                box-shadow: var(--shadow-md);
            }

            .notification-bell::after {
                content: '';
                position: absolute;
                top: 8px;
                right: 8px;
                width: 8px;
                height: 8px;
                background: var(--error-color);
                border-radius: 50%;
                border: 2px solid white;
            }

            /* Dropdown Menu */
            .dropdown-menu {
                position: absolute;
                top: calc(100% + 8px);
                right: 0;
                width: 280px;
                background: var(--bg-primary);
                border-radius: var(--border-radius-lg);
                box-shadow: var(--shadow-xl);
                border: 1px solid var(--border-color);
                opacity: 0;
                visibility: hidden;
                transform: translateY(-10px) scale(0.95);
                transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                z-index: 1000;
                overflow: hidden;
            }

            .user-dropdown.open .dropdown-menu {
                opacity: 1;
                visibility: visible;
                transform: translateY(0) scale(1);
            }

            .dropdown-menu::before {
                content: '';
                position: absolute;
                top: -6px;
                right: 20px;
                width: 12px;
                height: 12px;
                background: var(--bg-primary);
                border: 1px solid var(--border-color);
                border-bottom: none;
                border-right: none;
                transform: rotate(45deg);
            }

            .dropdown-header {
                padding: 20px;
                border-bottom: 1px solid var(--border-color);
                background: var(--bg-secondary);
            }

            .dropdown-user-info {
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .dropdown-avatar {
                width: 48px;
                height: 48px;
                border-radius: 50%;
                background: var(--bg-gradient);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: 600;
                font-size: 18px;
            }

            .dropdown-user-details h4 {
                font-weight: 600;
                margin-bottom: 4px;
                color: var(--text-primary);
            }

            .dropdown-user-details p {
                font-size: 12px;
                color: var(--text-muted);
                margin: 0;
            }

            .dropdown-body {
                padding: 8px 0;
            }

            .dropdown-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 20px;
                color: var(--text-primary);
                text-decoration: none;
                transition: all 0.3s ease;
                border: none;
                background: none;
                width: 100%;
                cursor: pointer;
                font-size: 14px;
            }

            .dropdown-item:hover {
                background: var(--bg-secondary);
                color: var(--primary-color);
                transform: translateX(4px);
            }

            .dropdown-item i {
                width: 16px;
                text-align: center;
                opacity: 0.7;
            }

            .dropdown-divider {
                height: 1px;
                background: var(--border-color);
                margin: 8px 0;
            }

            .dropdown-item.logout {
                color: var(--error-color);
                border-top: 1px solid var(--border-color);
                margin-top: 8px;
            }

            .dropdown-item.logout:hover {
                background: rgba(245, 101, 101, 0.1);
            }

            /* Sign In Button */
            .sign-in-btn {
                padding: 12px 24px;
                background: var(--bg-gradient);
                color: white;
                text-decoration: none;
                border-radius: var(--border-radius-lg);
                font-weight: 600;
                transition: all 0.3s ease;
                box-shadow: var(--shadow-sm);
                position: relative;
                overflow: hidden;
            }

            .sign-in-btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
                transition: left 0.3s ease;
            }

            .sign-in-btn:hover::before {
                left: 0;
            }

            .sign-in-btn:hover {
                transform: translateY(-2px);
                box-shadow: var(--shadow-lg);
                color: white;
                text-decoration: none;
            }

            .sign-in-btn span {
                position: relative;
                z-index: 1;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .middle-nav {
                    padding: 12px 16px;
                    gap: 16px;
                }

                .search-bar {
                    max-width: none;
                }

                .user-info {
                    display: none;
                }

                .dropdown-menu {
                    width: 240px;
                }

                .top-nav nav {
                    gap: 8px;
                }

                .top-nav nav a {
                    padding: 6px 12px;
                    font-size: 14px;
                }
            }

            @media (max-width: 480px) {
                .middle-nav {
                    flex-wrap: wrap;
                    gap: 12px;
                }

                .search-bar {
                    order: 3;
                    width: 100%;
                }

                .user-actions {
                    order: 2;
                }
            }
        </style>
    </head>

    <body>
        <header class="page-header">
            <div class="top-nav d-flex justify-content-center py-2">
                <nav class="d-flex gap-4">
                    <a href="home" class="active">
                        <i class="fas fa-home"></i> Home
                    </a>
                    <a href="#">
                        <i class="fas fa-book"></i> Courses
                    </a>
                    <a href="#">
                        <i class="fas fa-users"></i> Learning Groups
                    </a>
                </nav>
            </div>

            <div class="middle-nav">
                <img src="assets/images/logo.png" alt="CourseHub Logo" class="logo">

                <!-- Modern Search Bar -->
                <form method="get" action="home" class="search-bar">
                    <div class="search-container">
                        <input type="text" name="search" value="<%= search%>" placeholder="Tìm kiếm khóa học, chủ đề...">
                        <button type="submit" class="search-btn">
                            <i class="fas fa-search"></i>
                            <span>Tìm kiếm</span>
                        </button>
                    </div>
                </form>

                <!-- Modern User Actions -->
                <div class="user-actions">
                    <% if (u != null) {%>
                    <!-- Notification Bell -->
                    <div class="notification-bell">
                        <i class="fas fa-bell"></i>
                    </div>

                    <!-- User Dropdown -->
                    <div class="user-dropdown" id="userDropdown">
                        <button type="button" class="user-trigger" id="userDropdownBtn">
                            <div class="user-avatar">
                                <%= u.getUserName().substring(0, 1).toUpperCase()%>
                            </div>
                            <div class="user-info">
                                <span class="user-name"><%= u.getUserName()%></span>
                                <span class="user-role">Học viên</span>
                            </div>
                            <i class="fas fa-chevron-down dropdown-arrow"></i>
                        </button>

                        <div class="dropdown-menu" id="dropdownMenu">
                            <div class="dropdown-header">
                                <div class="dropdown-user-info">
                                    <div class="dropdown-avatar">
                                        <%= u.getUserName().substring(0, 1).toUpperCase()%>
                                    </div>
                                    <div class="dropdown-user-details">
                                        <h4><%= u.getUserName()%></h4>
                                        <p>Thành viên từ 2024</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="dropdown-body">
                                <a href="#" class="dropdown-item">
                                    <i class="fas fa-graduation-cap"></i>
                                    <span>Khóa học của tôi</span>
                                </a>
                                <a href="#" class="dropdown-item">
                                    <i class="fas fa-heart"></i>
                                    <span>Yêu thích</span>
                                </a>
                                <a href="#" class="dropdown-item">
                                    <i class="fas fa-certificate"></i>
                                    <span>Chứng chỉ</span>
                                </a>
                                <a href="#" class="dropdown-item">
                                    <i class="fas fa-chart-line"></i>
                                    <span>Tiến độ học tập</span>
                                </a>
                                
                                <div class="dropdown-divider"></div>
                                
                                <a href="#" class="dropdown-item">
                                    <i class="fas fa-user-cog"></i>
                                    <span>Cài đặt tài khoản</span>
                                </a>
                                <a href="#" class="dropdown-item">
                                    <i class="fas fa-credit-card"></i>
                                    <span>Thanh toán</span>
                                </a>
                                <a href="#" class="dropdown-item">
                                    <i class="fas fa-question-circle"></i>
                                    <span>Trợ giúp</span>
                                </a>
                                
                                <a href="#" class="dropdown-item logout">
                                    <i class="fas fa-sign-out-alt"></i>
                                    <span>Đăng xuất</span>
                                </a>
                            </div>
                        </div>
                    </div>
                    <% } else { %>
                    <a href="login" class="sign-in-btn">
                        <span><i class="fas fa-sign-in-alt"></i> Đăng nhập</span>
                    </a>
                    <% } %>
                </div>
            </div>
        </header>

        <main class="container my-4" style="max-width: 1400px; margin: 0 auto; padding: 32px 24px;">
            <% if (errorMessage != null) {%>
            <div class="alert alert-danger" style="background: linear-gradient(135deg, #fed7d7 0%, #feb2b2 100%); border: none; border-radius: var(--border-radius-lg); padding: 16px 20px; margin-bottom: 24px; box-shadow: var(--shadow-sm);"><%= errorMessage%></div>
            <% } %>

            <div class="feature-header" style="text-align: center; margin-bottom: 48px;">
                <h1 style="background: var(--bg-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; font-size: 3rem; font-weight: 700; margin-bottom: 16px; line-height: 1.2;">
                    Khám phá tri thức
                </h1>
                <p style="color: var(--text-muted); font-size: 1.2rem; font-weight: 400; max-width: 600px; margin: 0 auto;">
                    Hàng nghìn khóa học chất lượng cao từ các chuyên gia hàng đầu, giúp bạn phát triển kỹ năng và sự nghiệp
                </p>
            </div>

            <div class="courses-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 24px; margin-bottom: 48px;">
                <% if (courses != null && !courses.isEmpty()) {
                        for (Course c : courses) {%>
                <div class="course-card" style="background: var(--bg-primary); border-radius: var(--border-radius-lg); overflow: hidden; box-shadow: var(--shadow-md); transition: all 0.3s ease; border: 1px solid var(--border-color); position: relative;">
                    <div class="course-thumbnail" style="position: relative; height: 200px; overflow: hidden;">
                        <img src="<%= c.getThumbUrl() != null && !c.getThumbUrl().isEmpty() ? c.getThumbUrl() : "assets/images/default.jpg"%>" 
                             alt="<%= c.getTitle()%>" 
                             style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s ease;">
                        <div class="course-overlay" style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: linear-gradient(to bottom, transparent 0%, rgba(0,0,0,0.1) 100%); opacity: 0; transition: opacity 0.3s ease;"></div>
                        <div class="course-rating" style="position: absolute; top: 12px; right: 12px; background: rgba(255,255,255,0.9); padding: 6px 12px; border-radius: 20px; backdrop-filter: blur(10px); font-weight: 600; font-size: 14px; color: var(--text-primary);">
                            <%= String.format("%.1f", c.getAverageRating())%> <i class="fas fa-star" style="color: #fbbf24; margin-left: 4px;"></i>
                        </div>
                    </div>
                    
                    <div class="course-content" style="padding: 24px;">
                        <div class="course-title" style="font-size: 1.25rem; font-weight: 600; margin-bottom: 12px; color: var(--text-primary); line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;"><%= c.getTitle()%></div>
                        
                        <div class="course-meta" style="display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 16px;">
                            <span class="meta-tag" style="background: var(--bg-secondary); color: var(--text-secondary); padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 500;">
                                <i class="fas fa-signal" style="margin-right: 4px;"></i>
                                <%= c.getLevel() != null ? c.getLevel() : "Tất cả"%>
                            </span>
                            <span class="meta-tag" style="background: var(--bg-secondary); color: var(--text-secondary); padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 500;">
                                <i class="fas fa-users" style="margin-right: 4px;"></i>
                                <%= c.getLearnerCount()%> học viên
                            </span>
                        </div>
                        
                        <div class="course-footer" style="display: flex; justify-content: space-between; align-items: center; padding-top: 16px; border-top: 1px solid var(--border-color);">
                            <div class="price" style="font-size: 1.5rem; font-weight: 700; color: var(--primary-color);"><%= String.format("%,.0f", c.getPrice())%>₫</div>
                            <div class="status" style="padding: 6px 16px; border-radius: 20px; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">
                                <%
                                    String st = c.getStatus();
                                    String text = "Đang diễn ra";
                                    String statusColor = "background: var(--success-color); color: white;";
                                    if ("Off".equals(st)) {
                                        text = "Đã tắt";
                                        statusColor = "background: var(--text-muted); color: white;";
                                    } else if ("Completed".equals(st)) {
                                        text = "Hoàn thành";
                                        statusColor = "background: var(--primary-color); color: white;";
                                    } else if ("Draft".equals(st)) {
                                        text = "Bản nháp";
                                        statusColor = "background: var(--warning-color); color: white;";
                                    }
                                %>
                                <span style="<%= statusColor%>"><%= text%></span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Hover Effects -->
                    <style>
                        .course-card:hover {
                            transform: translateY(-8px);
                            box-shadow: var(--shadow-xl);
                        }
                        
                        .course-card:hover .course-thumbnail img {
                            transform: scale(1.05);
                        }
                        
                        .course-card:hover .course-overlay {
                            opacity: 1;
                        }
                    </style>
                </div>
                <%  }
                } else { %>
                <div style="text-align: center; color: var(--text-muted); grid-column: 1 / -1; padding: 60px 20px;">
                    <i class="fas fa-search" style="font-size: 4rem; opacity: 0.3; margin-bottom: 24px;"></i>
                    <h3 style="font-weight: 600; margin-bottom: 12px;">Không tìm thấy khóa học nào</h3>
                    <p>Thử tìm kiếm với từ khóa khác hoặc khám phá các chủ đề phổ biến</p>
                </div>
                <% } %>
            </div>

            <!-- Modern Pagination -->
            <% if (totalPages > 1) { %>
            <div class="pagination-container" style="display: flex; justify-content: center; margin-top: 48px;">
                <div class="pagination" style="display: flex; gap: 8px; align-items: center; background: var(--bg-primary); padding: 12px; border-radius: var(--border-radius-lg); box-shadow: var(--shadow-md); border: 1px solid var(--border-color);">
                    <% if (currentPage > 1) {%>
                    <a href="home?search=<%= java.net.URLEncoder.encode(search, "UTF-8")%>&page=<%= currentPage - 1%>" 
                       class="pagination-btn" 
                       style="display: flex; align-items: center; gap: 8px; padding: 10px 16px; border-radius: var(--border-radius-sm); background: var(--bg-secondary); color: var(--text-primary); text-decoration: none; font-weight: 500; transition: all 0.3s ease; border: 1px solid var(--border-color);">
                        <i class="fas fa-chevron-left"></i> Trước
                    </a>
                    <% } %>

                    <% 
                        int startPage = Math.max(1, currentPage - 2);
                        int endPage = Math.min(totalPages, currentPage + 2);
                        
                        if (startPage > 1) {
                    %>
                    <a href="home?search=<%= java.net.URLEncoder.encode(search, "UTF-8")%>&page=1" 
                       class="pagination-number" 
                       style="display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: var(--border-radius-sm); background: var(--bg-secondary); color: var(--text-primary); text-decoration: none; font-weight: 500; transition: all 0.3s ease; border: 1px solid var(--border-color);">1</a>
                    <% if (startPage > 2) { %>
                    <span style="color: var(--text-muted); padding: 0 8px;">...</span>
                    <% } %>
                    <% } %>

                    <% for (int i = startPage; i <= endPage; i++) { %>
                    <% if (i == currentPage) {%>
                    <span class="pagination-number active" 
                          style="display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: var(--border-radius-sm); background: var(--bg-gradient); color: white; font-weight: 600; box-shadow: var(--shadow-sm);"><%= i%></span>
                    <% } else {%>
                    <a href="home?search=<%= java.net.URLEncoder.encode(search, "UTF-8")%>&page=<%= i%>" 
                       class="pagination-number" 
                       style="display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: var(--border-radius-sm); background: var(--bg-secondary); color: var(--text-primary); text-decoration: none; font-weight: 500; transition: all 0.3s ease; border: 1px solid var(--border-color);"><%= i%></a>
                    <% } %>
                    <% } %>

                    <% 
                        if (endPage < totalPages) {
                            if (endPage < totalPages - 1) {
                    %>
                    <span style="color: var(--text-muted); padding: 0 8px;">...</span>
                    <% } %>
                    <a href="home?search=<%= java.net.URLEncoder.encode(search, "UTF-8")%>&page=<%= totalPages%>" 
                       class="pagination-number" 
                       style="display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: var(--border-radius-sm); background: var(--bg-secondary); color: var(--text-primary); text-decoration: none; font-weight: 500; transition: all 0.3s ease; border: 1px solid var(--border-color);"><%= totalPages%></a>
                    <% } %>

                    <% if (currentPage < totalPages) {%>
                    <a href="home?search=<%= java.net.URLEncoder.encode(search, "UTF-8")%>&page=<%= currentPage + 1%>" 
                       class="pagination-btn" 
                       style="display: flex; align-items: center; gap: 8px; padding: 10px 16px; border-radius: var(--border-radius-sm); background: var(--bg-secondary); color: var(--text-primary); text-decoration: none; font-weight: 500; transition: all 0.3s ease; border: 1px solid var(--border-color);">
                        Tiếp <i class="fas fa-chevron-right"></i>
                    </a>
                    <% } %>
                </div>
                
                <div style="margin-left: 24px; display: flex; align-items: center; color: var(--text-muted); font-size: 14px;">
                    Hiển thị trang <%= currentPage%> / <%= totalPages%> 
                    (<%= totalCourses%> khóa học)
                </div>
            </div>
            
            <style>
                .pagination-btn:hover,
                .pagination-number:hover {
                    background: var(--primary-color) !important;
                    color: white !important;
                    transform: translateY(-2px);
                    box-shadow: var(--shadow-md);
                }
            </style>
            <% }%>
        </main>
        
        <!-- Modern Footer -->
        <footer style="background: var(--bg-primary); border-top: 1px solid var(--border-color); margin-top: 80px; padding: 40px 24px; text-align: center;">
            <div style="max-width: 1400px; margin: 0 auto;">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 32px; margin-bottom: 32px;">
                    <div>
                        <h4 style="color: var(--text-primary); margin-bottom: 16px; font-weight: 600;">CourseHub</h4>
                        <p style="color: var(--text-muted); font-size: 14px; line-height: 1.6;">Nền tảng học trực tuyến hàng đầu Việt Nam, mang đến cho bạn những khóa học chất lượng cao từ các chuyên gia.</p>
                    </div>
                    <div>
                        <h4 style="color: var(--text-primary); margin-bottom: 16px; font-weight: 600;">Liên kết nhanh</h4>
                        <div style="display: flex; flex-direction: column; gap: 8px;">
                            <a href="#" style="color: var(--text-muted); text-decoration: none; font-size: 14px; transition: color 0.3s ease;">Về chúng tôi</a>
                            <a href="#" style="color: var(--text-muted); text-decoration: none; font-size: 14px; transition: color 0.3s ease;">Điều khoản sử dụng</a>
                            <a href="#" style="color: var(--text-muted); text-decoration: none; font-size: 14px; transition: color 0.3s ease;">Chính sách bảo mật</a>
                            <a href="#" style="color: var(--text-muted); text-decoration: none; font-size: 14px; transition: color 0.3s ease;">Liên hệ</a>
                        </div>
                    </div>
                    <div>
                        <h4 style="color: var(--text-primary); margin-bottom: 16px; font-weight: 600;">Theo dõi chúng tôi</h4>
                        <div style="display: flex; gap: 16px; justify-content: center;">
                            <a href="#" style="display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; background: var(--bg-secondary); border-radius: 50%; color: var(--text-muted); transition: all 0.3s ease;">
                                <i class="fab fa-facebook-f"></i>
                            </a>
                            <a href="#" style="display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; background: var(--bg-secondary); border-radius: 50%; color: var(--text-muted); transition: all 0.3s ease;">
                                <i class="fab fa-twitter"></i>
                            </a>
                            <a href="#" style="display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; background: var(--bg-secondary); border-radius: 50%; color: var(--text-muted); transition: all 0.3s ease;">
                                <i class="fab fa-instagram"></i>
                            </a>
                            <a href="#" style="display: flex; align-items: center; justify-content: center; width: 40px; height: 40px; background: var(--bg-secondary); border-radius: 50%; color: var(--text-muted); transition: all 0.3s ease;">
                                <i class="fab fa-youtube"></i>
                            </a>
                        </div>
                    </div>
                </div>
                <div style="border-top: 1px solid var(--border-color); padding-top: 24px; color: var(--text-muted); font-size: 14px;">
                    © 2024 CourseHub. Tất cả quyền được bảo lưu.
                </div>
            </div>
        </footer>
        <script>
            // Modern Dropdown with Enhanced UX
            document.addEventListener('DOMContentLoaded', function () {
                const userDropdown = document.getElementById('userDropdown');
                const dropdownBtn = document.getElementById('userDropdownBtn');
                const dropdownMenu = document.getElementById('dropdownMenu');

                if (!userDropdown || !dropdownBtn) return;

                let isOpen = false;
                let closeTimeout;

                function openDropdown() {
                    if (isOpen) return;
                    isOpen = true;
                    clearTimeout(closeTimeout);
                    userDropdown.classList.add('open');
                    dropdownBtn.setAttribute('aria-expanded', 'true');
                    
                    // Add backdrop blur effect
                    document.body.style.overflow = 'hidden';
                    const backdrop = document.createElement('div');
                    backdrop.className = 'dropdown-backdrop';
                    backdrop.style.cssText = `
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        backdrop-filter: blur(2px);
                        z-index: 999;
                        opacity: 0;
                        transition: opacity 0.3s ease;
                    `;
                    document.body.appendChild(backdrop);
                    
                    // Animate backdrop
                    requestAnimationFrame(() => {
                        backdrop.style.opacity = '1';
                    });
                    
                    backdrop.addEventListener('click', closeDropdown);
                }

                function closeDropdown() {
                    if (!isOpen) return;
                    isOpen = false;
                    userDropdown.classList.remove('open');
                    dropdownBtn.setAttribute('aria-expanded', 'false');
                    
                    // Remove backdrop
                    const backdrop = document.querySelector('.dropdown-backdrop');
                    if (backdrop) {
                        backdrop.style.opacity = '0';
                        setTimeout(() => {
                            backdrop.remove();
                            document.body.style.overflow = '';
                        }, 300);
                    }
                }

                // Toggle on click
                dropdownBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    if (isOpen) {
                        closeDropdown();
                    } else {
                        openDropdown();
                    }
                });

                // Close on outside click
                document.addEventListener('click', function (e) {
                    if (isOpen && !userDropdown.contains(e.target)) {
                        closeDropdown();
                    }
                });

                // Close on ESC key
                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape' && isOpen) {
                        closeDropdown();
                    }
                });

                // Prevent dropdown menu clicks from closing
                if (dropdownMenu) {
                    dropdownMenu.addEventListener('click', function (e) {
                        e.stopPropagation();
                    });
                }

                // Hover effects for dropdown items
                const dropdownItems = document.querySelectorAll('.dropdown-item');
                dropdownItems.forEach(item => {
                    item.addEventListener('mouseenter', function() {
                        this.style.transform = 'translateX(4px)';
                    });
                    
                    item.addEventListener('mouseleave', function() {
                        this.style.transform = 'translateX(0)';
                    });
                });

                // Notification bell animation
                const notificationBell = document.querySelector('.notification-bell');
                if (notificationBell) {
                    notificationBell.addEventListener('click', function() {
                        this.style.animation = 'bellRing 0.6s ease-in-out';
                        setTimeout(() => {
                            this.style.animation = '';
                        }, 600);
                    });
                }

                // Add bell ring animation
                const style = document.createElement('style');
                style.textContent = `
                    @keyframes bellRing {
                        0%, 100% { transform: rotate(0deg); }
                        10%, 30%, 50%, 70%, 90% { transform: rotate(-10deg); }
                        20%, 40%, 60%, 80% { transform: rotate(10deg); }
                    }
                    
                    @keyframes fadeInUp {
                        from {
                            opacity: 0;
                            transform: translateY(20px);
                        }
                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }
                    
                    .course-card {
                        animation: fadeInUp 0.6s ease-out;
                    }
                    
                    .course-card:nth-child(even) {
                        animation-delay: 0.1s;
                    }
                    
                    .course-card:nth-child(3n) {
                        animation-delay: 0.2s;
                    }
                `;
                document.head.appendChild(style);

                // Search input focus effects
                const searchInput = document.querySelector('.search-container input');
                if (searchInput) {
                    searchInput.addEventListener('focus', function() {
                        this.parentElement.style.transform = 'scale(1.02)';
                    });
                    
                    searchInput.addEventListener('blur', function() {
                        this.parentElement.style.transform = 'scale(1)';
                    });
                }

                // Add smooth scrolling
                document.documentElement.style.scrollBehavior = 'smooth';

                // Loading animation for course cards
                const courseCards = document.querySelectorAll('.course-card');
                const observerOptions = {
                    threshold: 0.1,
                    rootMargin: '0px 0px -50px 0px'
                };

                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.style.opacity = '1';
                            entry.target.style.transform = 'translateY(0)';
                        }
                    });
                }, observerOptions);

                courseCards.forEach((card, index) => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(30px)';
                    card.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
                    observer.observe(card);
                });

                console.log('🎨 Modern UI initialized successfully!');
            });
        </script>
    </body>
</html>
