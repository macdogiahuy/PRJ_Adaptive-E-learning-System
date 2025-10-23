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

        /* Statistics Cards */
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
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
            color: white;
        }

        .stat-card.pending .icon {
            background: linear-gradient(135deg, #EC4899, #8B5CF6);
            color: white;
        }

        .stat-card.alerted .icon {
            background: linear-gradient(135deg, #06B6D4, #3B82F6);
            color: white;
        }

        .stat-card.dismissed .icon {
            background: linear-gradient(135deg, #10B981, #06B6D4);
            color: white;
        }

        .stat-card h3 {
            font-size: 0.9rem;
            color: rgba(248, 250, 252, 0.8);
            margin-bottom: 0.5rem;
            font-weight: 500;
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

        /* Table */
        .table-container {
            overflow-x: auto;
            margin-bottom: 2rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(16px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 12px;
            overflow: hidden;
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
        }

        tbody tr {
            border-bottom: 1px solid rgba(139, 92, 246, 0.1);
            transition: background-color 0.2s ease;
        }

        tbody tr:hover {
            background: rgba(139, 92, 246, 0.1);
        }

        tbody td {
            padding: 1rem;
            font-size: 0.9rem;
            color: #F8FAFC;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn {
            padding: 0.5rem 1rem;
            border: 2px solid rgba(139, 92, 246, 0.2);
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            color:white;
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
            background: linear-gradient(135deg, #EC4899, #8B5CF6);
            color: white;
        }

        .btn-dismiss {
            background: linear-gradient(135deg, #10B981, #06B6D4);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(139, 92, 246, 0.3);
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
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .pagination-controls a {
            background: linear-gradient(145deg, rgba(139, 92, 246, 0.1), rgba(107, 70, 193, 0.05));
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            color: #F8FAFC;
        }

        .pagination-controls a:hover {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
            color: white;
            box-shadow: 0 0 20px rgba(139, 92, 246, 0.4);
        }

        .pagination-controls .current {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
            color: white;
            box-shadow: 0 0 20px rgba(139, 92, 246, 0.6);
        }

        .pagination-controls .disabled {
            background: rgba(139, 92, 246, 0.05);
            color: rgba(248, 250, 252, 0.4);
            cursor: not-allowed;
            border: 1px solid rgba(139, 92, 246, 0.1);
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
    <script src="${pageContext.request.contextPath}/assests/js/universe-theme.js"></script>
</head>
<body class="universe-theme">
    <!-- Universe Background Layer -->
    <div class="universe-background"></div>
    
    <header class="header universe-header">
        <h1 class="universe-title"><i class="fas fa-flag"></i> Reported Groups Management - CourseHub E-Learning</h1>
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
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">Content Management</div>
                <ul>
                    <li><a href="/Adaptive_Elearning/admin_coursemanagement.jsp">
                        <i class="fa-solid fa-bars-progress"></i> 
                        <span>Quản Lý Khóa Học</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_reportedcourse.jsp">
                        <i class="fas fa-flag"></i> 
                        <span>Báo Cáo Khóa Học</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_reportedgroup.jsp" class="active">
                        <i class="fas fa-users-slash"></i> 
                        <span>Nhóm Báo Cáo</span>
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
            const interactiveElements = document.querySelectorAll('button, .stat-card, .content-card, .search-box');
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

            // Enhanced table row hover effects
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.background = 'linear-gradient(90deg, rgba(139, 92, 246, 0.2), rgba(107, 70, 193, 0.1))';
                    this.style.boxShadow = '0 0 20px rgba(139, 92, 246, 0.3)';
                });
                row.addEventListener('mouseleave', function() {
                    this.style.background = '';
                    this.style.boxShadow = '';
                });
            });
        });
    </script>
</body>
</html>