<%@page import="controller.CourseManagementController"%>
<%@page import="controller.CourseManagementController.Course"%>
<%@page import="controller.CourseManagementController.CourseStats"%>
<%@page import="java.util.List"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Lấy dữ liệu từ request attributes (đã được xử lý bởi controller)
    CourseStats stats = (CourseStats) request.getAttribute("courseStats");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalCourses = (Integer) request.getAttribute("totalCourses");
    String searchQuery = (String) request.getAttribute("searchQuery");
    
    // Get entries per page parameter
    String entriesParam = request.getParameter("entries");
    int entriesPerPage = 12;
    try {
        if (entriesParam != null) {
            entriesPerPage = Integer.parseInt(entriesParam);
        }
    } catch (NumberFormatException e) {
        entriesPerPage = 12;
    }
    
    // Fallback nếu không có dữ liệu từ attributes
    if (stats == null || courses == null) {
        CourseManagementController controller = new CourseManagementController();
        searchQuery = request.getParameter("search");
        if (searchQuery == null) searchQuery = "";
        
        int pageNum = 1;
        try {
            if (request.getParameter("page") != null) {
                pageNum = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            pageNum = 1;
        }
        
        courses = controller.getCourses(searchQuery, entriesPerPage, (pageNum - 1) * entriesPerPage);
        stats = controller.getCourseStats();
        int total = controller.getTotalCoursesCount(searchQuery);
        totalPages = (int) Math.ceil((double) total / entriesPerPage);
        currentPage = pageNum;
        totalCourses = total;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Management - CourseHub E-Learning</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assests/css/universe-background.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-performance.css">
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

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
            color: white;
        }

        .stat-info h3 {
            font-size: 0.9rem;
            color: rgba(248, 250, 252, 0.8);
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .stat-info .number {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 0 0 20px rgba(139, 92, 246, 0.8);
        }

        .stat-info .change {
            font-size: 0.8rem;
            margin-top: 0.25rem;
            color: rgba(248, 250, 252, 0.7);
        }

        .controls {
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(20px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
            transition: all 0.3s ease;
        }

        .controls:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(139, 92, 246, 0.3);
            border-color: rgba(139, 92, 246, 0.4);
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
            flex: 1;
            max-width: 400px;
            position: relative;
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
            font-size: 0.9rem;
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

        /* Dropdown options styling */
        .entries-select select option {
            background: rgba(30, 27, 75, 0.95) !important;
            color: #F8FAFC !important;
            border: none !important;
            padding: 8px 12px !important;
        }

        .entries-select select option:hover,
        .entries-select select option:focus,
        .entries-select select option:checked {
            background: rgba(139, 92, 246, 0.8) !important;
            color: #F8FAFC !important;
        }

        /* For Firefox */
        .entries-select select:-moz-focusring {
            color: transparent !important;
            text-shadow: 0 0 0 #F8FAFC !important;
        }

        /* Webkit scrollbar for dropdown */
        .entries-select select::-webkit-scrollbar {
            width: 8px;
        }

        .entries-select select::-webkit-scrollbar-track {
            background: rgba(30, 27, 75, 0.5);
            border-radius: 4px;
        }

        .entries-select select::-webkit-scrollbar-thumb {
            background: rgba(139, 92, 246, 0.6);
            border-radius: 4px;
        }

        .entries-select select::-webkit-scrollbar-thumb:hover {
            background: rgba(139, 92, 246, 0.8);
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .course-card {
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(20px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.1);
            transition: all 0.3s ease;
            position: relative;
        }

        .course-card::before {
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

        .course-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(139, 92, 246, 0.3);
            border-color: rgba(139, 92, 246, 0.4);
        }

        .course-card:hover::before {
            opacity: 1;
        }

        .course-thumbnail {
            width: 100%;
            height: 200px;
            background-color: #f8f9fa;
            background-size: cover;
            background-position: center;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 16px;
        }

        .course-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .course-status {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: bold;
            text-transform: uppercase;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .course-content {
            padding: 1.5rem;
            position: relative;
            z-index: 1;
        }

        .course-title {
            font-size: 1.1rem;
            font-weight: bold;
            color: #F8FAFC;
            margin-bottom: 0.5rem;
            line-height: 1.3;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            font-size: 0.85rem;
            color: rgba(248, 250, 252, 0.7);
        }

        .course-level {
            background: rgba(139, 92, 246, 0.2);
            color: #F8FAFC;
            padding: 0.25rem 0.5rem;
            border-radius: 15px;
            font-size: 0.75rem;
        }

        .course-rating {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            color: #ffc107;
        }

        .course-pricing {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .price-section {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .current-price {
            font-size: 1.2rem;
            font-weight: bold;
            color: #06B6D4;
        }

        .original-price {
            font-size: 0.9rem;
            color: rgba(248, 250, 252, 0.5);
            text-decoration: line-through;
        }

        .learners-count {
            font-size: 0.8rem;
            color: rgba(248, 250, 252, 0.7);
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .no-courses {
            text-align: center;
            padding: 3rem;
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(20px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 16px;
            box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.1);
        }

        .no-courses i {
            font-size: 3rem;
            color: rgba(139, 92, 246, 0.5);
            margin-bottom: 1rem;
        }

        .no-courses h3 {
            color: #F8FAFC;
            margin-bottom: 0.5rem;
        }

        .no-courses p {
            color: rgba(248, 250, 252, 0.7);
        }

        /* Loading and Error States */
        .loading {
            text-align: center;
            padding: 3rem;
            color: rgba(248, 250, 252, 0.8);
        }

        .loading i {
            font-size: 2rem;
            margin-bottom: 1rem;
            animation: spin 1s linear infinite;
            color: #8B5CF6;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .error-message {
            background: linear-gradient(145deg, rgba(239, 68, 68, 0.2), rgba(239, 68, 68, 0.1));
            backdrop-filter: blur(10px);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: #FCA5A5;
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1rem;
        }

        .success-message {
            background: linear-gradient(145deg, rgba(34, 197, 94, 0.2), rgba(34, 197, 94, 0.1));
            backdrop-filter: blur(10px);
            border: 1px solid rgba(34, 197, 94, 0.3);
            color: #86EFAC;
            padding: 1rem;
            border-radius: 12px;
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

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .controls {
                flex-direction: column;
                align-items: stretch;
            }

            .search-box {
                max-width: none;
            }

            .courses-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <script src="${pageContext.request.contextPath}/assests/js/universe-theme.js"></script>
</head>
<body class="universe-theme">
    <!-- Universe Background Layer -->
    <div class="universe-background"></div>
    
    <div class="header universe-header">
        <h1 class="universe-title">
            <i class="fa-solid fa-graduation-cap"></i>
            Course Management
        </h1>
     
    </div>

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
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Tổng quan</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_notification.jsp">
                        <i class="fas fa-bell"></i>
                        <span>Thông báo</span>
                    </a></li>
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">User Management</div>
                <ul>
                    <li><a href="/Adaptive_Elearning/admin_createadmin.jsp">
                        <i class="fas fa-user-plus"></i>
                        <span>Tạo Admin</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_accountmanagement.jsp">
                        <i class="fas fa-users"></i>
                        <span>Quản lý Tài Khoản</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_edit_user_role.jsp">
                        <i class="fas fa-user-edit"></i>
                        <span>Phân quyền User</span>
                    </a></li>
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">Content Management</div>
                <ul>
                    <li><a href="/Adaptive_Elearning/admin_coursemanagement.jsp" class="active">
                        <i class="fa-solid fa-bars-progress"></i>
                        <span>Các Khóa Học</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_reportedcourse.jsp">
                        <i class="fas fa-flag"></i>
                        <span>Báo Cáo Khóa Học</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_reportedgroup.jsp">
                        <i class="fas fa-user-graduate"></i>
                        <span>Quản lý Nhóm</span>
                    </a></li>
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">System</div>
                <ul>
                    <li><a href="/Adaptive_Elearning/home">
                        <i class="fas fa-chart-bar"></i>
                        <span>Home</span>
                    </a></li>
                    <li><a href="#">
                        <i class="fas fa-cog"></i>
                        <span>LogOut</span>
                    </a></li>
                </ul>
            </div>
        </nav>

        <main class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fa-solid fa-graduation-cap"></i> Quản lý khóa học</h2>
            </div>

            <!-- Statistics Card -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                    <div class="stat-info">
                        <h3>Tổng số khóa học</h3>
                        <div class="number"><%= stats.getTotalCourses() %></div>
                        <div class="change" style="color: #28a745;">
                            <i class="fas fa-arrow-up"></i> Đang hoạt động
                        </div>
                    </div>
                </div>
            </div>

            <!-- Controls -->
            <div class="controls">
                <form method="GET" style="display: flex; gap: 1rem; align-items: center; flex-wrap: wrap; width: 100%;">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" name="search" placeholder="Tìm kiếm khóa học..." value="<%= searchQuery %>" />
                    </div>
                    
                    <div class="entries-select">
                        <span>Hiển thị</span>
                        <select name="entries" onchange="this.form.submit()">
                            <option value="5" <%= entriesPerPage == 5 ? "selected" : "" %>>5</option>
                            <option value="10" <%= entriesPerPage == 10 ? "selected" : "" %>>10</option>
                            <option value="25" <%= entriesPerPage == 25 ? "selected" : "" %>>25</option>
                            <option value="50" <%= entriesPerPage == 50 ? "selected" : "" %>>50</option>
                        </select>
                        <span>mục</span>
                    </div>
                    
                    <input type="hidden" name="page" value="<%= currentPage %>" />
                </form>
            </div>

            <!-- Courses Grid -->
            <% if (courses != null && !courses.isEmpty()) { %>
                <div class="courses-grid">
                    <% for (Course course : courses) { %>
                        <div class="course-card">
                            <div class="course-thumbnail">
                                <% if (course.getThumbUrl() != null && !course.getThumbUrl().isEmpty()) { %>
                                    <img src="<%= course.getThumbUrl() %>" alt="Course Thumbnail" />
                                <% } else { %>
                                    Thumbnail (750x422)
                                <% } %>
                                <div class="course-status <%= "Active".equals(course.getStatus()) ? "status-active" : "status-inactive" %>">
                                    <%= course.getStatus() %>
                                </div>
                            </div>
                            
                            <div class="course-content">
                                <div class="course-title"><%= course.getTitle() %></div>
                                
                                <div class="course-meta">
                                    <span class="course-level"><%= course.getLevel() %></span>
                                    <div class="course-rating">
                                        <i class="fas fa-star"></i>
                                        <span><%= String.format("%.1f", course.getTotalRating()) %></span>
                                    </div>
                                </div>
                                
                                <div class="course-pricing">
                                    <div class="price-section">
                                        <% if (course.getDiscount() > 0) { %>
                                            <span class="current-price"><%= course.getFormattedDiscountedPrice() %></span>
                                            <span class="original-price"><%= course.getFormattedPrice() %></span>
                                        <% } else { %>
                                            <span class="current-price"><%= course.getFormattedPrice() %></span>
                                        <% } %>
                                    </div>
                                    
                                    <div class="learners-count">
                                        <i class="fas fa-users"></i>
                                        <span><%= course.getLearnerCount() %> học viên</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="no-courses">
                    <i class="fas fa-graduation-cap"></i>
                    <h3>Không tìm thấy khóa học nào</h3>
                    <p>Thử thay đổi từ khóa tìm kiếm hoặc làm mới trang.</p>
                </div>
            <% } %>
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
                    // Add ripple effect
                    const ripple = document.createElement('span');
                    ripple.className = 'nav-ripple';
                    ripple.style.cssText = `
                        position: absolute;
                        border-radius: 50%;
                        background: radial-gradient(circle, rgba(139, 92, 246, 0.6) 0%, transparent 70%);
                        transform: scale(0);
                        animation: ripple 0.6s linear;
                        pointer-events: none;
                        width: 100px;
                        height: 100px;
                        left: 50%;
                        top: 50%;
                        transform-origin: center;
                        margin-left: -50px;
                        margin-top: -50px;
                        z-index: 0;
                    `;
                    
                    this.style.position = 'relative';
                    this.appendChild(ripple);
                    
                    // Create floating particles
                    for (let i = 0; i < 3; i++) {
                        setTimeout(() => {
                            const particle = document.createElement('div');
                            particle.style.cssText = `
                                position: absolute;
                                width: 4px;
                                height: 4px;
                                background: #06B6D4;
                                border-radius: 50%;
                                pointer-events: none;
                                left: ${Math.random() * 100}%;
                                top: ${Math.random() * 100}%;
                                animation: float-particle 1s ease-out forwards;
                                z-index: 0;
                            `;
                            this.appendChild(particle);
                            
                            setTimeout(() => particle.remove(), 1000);
                        }, i * 100);
                    }
                    
                    setTimeout(() => ripple.remove(), 600);
                });

                // Add click animation
                link.addEventListener('click', function(e) {
                    const clickRipple = document.createElement('span');
                    clickRipple.style.cssText = `
                        position: absolute;
                        border-radius: 50%;
                        background: radial-gradient(circle, rgba(6, 182, 212, 0.8) 0%, transparent 70%);
                        transform: scale(0);
                        animation: click-ripple 0.3s ease-out;
                        pointer-events: none;
                        width: 80px;
                        height: 80px;
                        left: 50%;
                        top: 50%;
                        margin-left: -40px;
                        margin-top: -40px;
                        z-index: 0;
                    `;
                    
                    this.appendChild(clickRipple);
                    setTimeout(() => clickRipple.remove(), 300);
                });
            });
                    ripple.style.transform = 'scale(0)';
                    ripple.style.animation = 'ripple 0.6s linear';
                    ripple.style.pointerEvents = 'none';
                    
                    const rect = this.getBoundingClientRect();
                    const size = Math.max(rect.width, rect.height);
                    ripple.style.width = ripple.style.height = size + 'px';
                    ripple.style.left = (rect.width / 2 - size / 2) + 'px';
                    ripple.style.top = (rect.height / 2 - size / 2) + 'px';
                    
                    this.style.position = 'relative';
                    this.appendChild(ripple);
                    
                    setTimeout(() => ripple.remove(), 600);
                });

                // Add click animation
                link.addEventListener('click', function(e) {
                    const clickRipple = document.createElement('div');
                    clickRipple.style.position = 'absolute';
                    clickRipple.style.borderRadius = '50%';
                    clickRipple.style.background = 'rgba(6, 182, 212, 0.4)';
                    clickRipple.style.transform = 'scale(0)';
                    clickRipple.style.animation = 'click-ripple 0.3s ease-out';
                    clickRipple.style.pointerEvents = 'none';
                    
                    const rect = this.getBoundingClientRect();
                    const size = 20;
                    clickRipple.style.width = clickRipple.style.height = size + 'px';
                    clickRipple.style.left = (e.clientX - rect.left - size/2) + 'px';
                    clickRipple.style.top = (e.clientY - rect.top - size/2) + 'px';
                    
                    this.appendChild(clickRipple);
                    setTimeout(() => clickRipple.remove(), 300);
                });
            });

            // Add CSS animations
            const style = document.createElement('style');
            style.textContent = `
                @keyframes ripple {
                    to {
                        transform: scale(1);
                        opacity: 0;
                    }
                }
                
                @keyframes click-ripple {
                    to {
                        transform: scale(1.2);
                        opacity: 0;
                    }
                }
                
                @keyframes float-particle {
                    0% {
                        transform: translateY(0px) scale(1);
                        opacity: 1;
                    }
                    100% {
                        transform: translateY(-20px) scale(0);
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
                        transform: translateX(-30px);
                        opacity: 0;
                    }
                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }
            `;
            document.head.appendChild(style);

            // Add universe glow effects to interactive elements
            const interactiveElements = document.querySelectorAll('button, .stat-card, .controls, .search-box');
            interactiveElements.forEach(element => {
                element.addEventListener('mouseenter', function() {
                    this.style.boxShadow = '0 0 30px rgba(139, 92, 246, 0.4)';
                });
                element.addEventListener('mouseleave', function() {
                    this.style.boxShadow = '';
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

            // Enhanced course card hover effects
            const courseCards = document.querySelectorAll('.course-card');
            courseCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-10px) scale(1.02)';
                    this.style.boxShadow = '0 0 30px rgba(139, 92, 246, 0.3)';
                });
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                    this.style.boxShadow = '';
                });
            });
        });

        // Auto submit search form when typing
        let searchTimeout;
        const searchInput = document.querySelector('input[name="search"]');
        if (searchInput) {
            searchInput.addEventListener('input', function() {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    this.form.submit();
                }, 500);
            });
        }
    </script>
    
    <!-- Admin Performance Optimizer -->
    <script src="${pageContext.request.contextPath}/assets/js/admin-performance.js"></script>
</body>
</html>