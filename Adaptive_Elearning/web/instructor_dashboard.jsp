<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển Giảng viên - Adaptive E-Learning</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Modern CSS Variables */
        :root {
            --primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            --success: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --warning: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            --danger: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            --info: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
            
            --bg-primary: #0f0f23;
            --bg-secondary: #1a1a2e;
            --bg-card: rgba(255, 255, 255, 0.08);
            --bg-glass: rgba(255, 255, 255, 0.05);
            
            --text-primary: #ffffff;
            --text-secondary: rgba(255, 255, 255, 0.7);
            --text-muted: rgba(255, 255, 255, 0.5);
            
            --border: rgba(255, 255, 255, 0.1);
            --shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            --shadow-hover: 0 20px 60px rgba(0, 0, 0, 0.4);
            
            --radius: 20px;
            --radius-sm: 12px;
            --spacing: 24px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* Animated Background */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: 
                radial-gradient(circle at 20% 80%, rgba(120, 119, 198, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(255, 119, 198, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 40% 40%, rgba(120, 219, 255, 0.2) 0%, transparent 50%);
            z-index: -1;
            animation: backgroundFloat 20s ease-in-out infinite;
        }

        @keyframes backgroundFloat {
            0%, 100% { transform: scale(1) rotate(0deg); }
            50% { transform: scale(1.1) rotate(5deg); }
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Glass Morphism Sidebar */
        .sidebar {
            width: 280px;
            background: var(--bg-glass);
            backdrop-filter: blur(20px);
            border-right: 1px solid var(--border);
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .sidebar-header {
            padding: var(--spacing);
            border-bottom: 1px solid var(--border);
            text-align: center;
            position: relative;
        }

        .sidebar-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: var(--primary);
            opacity: 0.1;
            border-radius: 0 0 var(--radius) var(--radius);
        }

        .sidebar-header h3 {
            font-size: 20px;
            font-weight: 700;
            background: var(--primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin: 0;
            position: relative;
            z-index: 1;
        }

        .nav-menu {
            list-style: none;
            padding: var(--spacing) 0;
        }

        .nav-item {
            margin: 8px var(--spacing);
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 16px 20px;
            color: var(--text-secondary);
            text-decoration: none;
            border-radius: var(--radius-sm);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .nav-link::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: var(--primary);
            transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: -1;
        }

        .nav-link:hover::before,
        .nav-item.active .nav-link::before {
            left: 0;
        }

        .nav-link:hover,
        .nav-item.active .nav-link {
            color: var(--text-primary);
            transform: translateX(8px);
        }

        .nav-link i {
            margin-right: 12px;
            font-size: 18px;
            width: 20px;
        }

        .notification-badge {
            background: var(--danger);
            color: white;
            border-radius: 50%;
            padding: 4px 8px;
            font-size: 11px;
            font-weight: 600;
            margin-left: auto;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }

        .sidebar-footer {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            padding: var(--spacing);
            border-top: 1px solid var(--border);
            background: var(--bg-glass);
            backdrop-filter: blur(20px);
        }

        .user-info {
            display: flex;
            align-items: center;
            margin-bottom: 16px;
            padding: 12px;
            background: var(--bg-card);
            border-radius: var(--radius-sm);
            border: 1px solid var(--border);
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            position: relative;
        }

        .user-avatar::before {
            content: '';
            position: absolute;
            inset: -2px;
            background: var(--primary);
            border-radius: 50%;
            z-index: -1;
            animation: rotate 3s linear infinite;
        }

        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .user-avatar i {
            font-size: 20px;
            color: white;
        }

        .user-details {
            flex: 1;
        }

        .user-name {
            font-weight: 600;
            font-size: 14px;
            color: var(--text-primary);
        }

        .user-role {
            font-size: 12px;
            color: var(--text-muted);
        }

        .logout-btn {
            display: flex;
            align-items: center;
            width: 100%;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            color: var(--text-secondary);
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background: var(--danger);
            color: var(--text-primary);
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }

        .logout-btn i {
            margin-right: 8px;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: var(--spacing);
            min-height: 100vh;
        }

        /* Modern Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: calc(var(--spacing) * 2);
            padding: var(--spacing);
            background: var(--bg-card);
            backdrop-filter: blur(20px);
            border-radius: var(--radius);
            border: 1px solid var(--border);
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: var(--primary);
        }

        .header-left h1 {
            font-size: 32px;
            font-weight: 800;
            background: var(--primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 8px;
            position: relative;
        }

        .header-left p {
            color: var(--text-secondary);
            font-size: 16px;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .search-box {
            position: relative;
            display: flex;
            align-items: center;
        }

        .search-box input {
            width: 300px;
            padding: 12px 16px 12px 48px;
            background: var(--bg-glass);
            border: 1px solid var(--border);
            border-radius: 25px;
            color: var(--text-primary);
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .search-box input:focus {
            outline: none;
            border-color: rgba(102, 126, 234, 0.5);
            box-shadow: 0 0 20px rgba(102, 126, 234, 0.2);
            width: 350px;
        }

        .search-box input::placeholder {
            color: var(--text-muted);
        }

        .search-box i {
            position: absolute;
            left: 16px;
            color: var(--text-muted);
        }

        .notifications {
            position: relative;
            padding: 12px;
            background: var(--bg-glass);
            border-radius: 50%;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid var(--border);
        }

        .notifications:hover {
            background: var(--bg-card);
            transform: scale(1.1);
            box-shadow: var(--shadow);
        }

        .notifications i {
            font-size: 18px;
            color: var(--text-secondary);
        }

        .notifications .notification-badge {
            position: absolute;
            top: -4px;
            right: -4px;
        }

        /* Modern Stats Cards */
        .instructor-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: var(--spacing);
            margin-bottom: calc(var(--spacing) * 2);
        }

        .stat-card {
            position: relative;
            background: var(--bg-card);
            backdrop-filter: blur(20px);
            padding: calc(var(--spacing) + 8px);
            border-radius: var(--radius);
            border: 1px solid var(--border);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            transition: all 0.3s ease;
        }

        .stat-card.courses::before { background: var(--primary); }
        .stat-card.students::before { background: var(--success); }
        .stat-card.assignments::before { background: var(--warning); }
        .stat-card.messages::before { background: var(--danger); }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-hover);
        }

        .stat-card:hover::before {
            height: 100%;
            opacity: 0.1;
        }

        .stat-content {
            position: relative;
            z-index: 1;
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 16px;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .stat-card.courses .stat-icon { background: var(--primary); }
        .stat-card.students .stat-icon { background: var(--success); }
        .stat-card.assignments .stat-icon { background: var(--warning); }
        .stat-card.messages .stat-icon { background: var(--danger); }

        .stat-number {
            font-size: 3rem;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 8px;
            animation: countUp 1s ease-out;
        }

        @keyframes countUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .stat-label {
            color: var(--text-secondary);
            font-size: 14px;
            font-weight: 500;
        }

        .stat-change {
            font-size: 12px;
            padding: 4px 8px;
            border-radius: 20px;
            margin-top: 8px;
            display: inline-block;
        }

        .stat-change.positive {
            background: rgba(76, 175, 80, 0.2);
            color: #4CAF50;
        }

        .stat-change.negative {
            background: rgba(244, 67, 54, 0.2);
            color: #F44336;
        }

        /* Dashboard Grid */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: var(--spacing);
            margin-bottom: var(--spacing);
        }

        .card {
            background: var(--bg-card);
            backdrop-filter: blur(20px);
            border-radius: var(--radius);
            padding: var(--spacing);
            border: 1px solid var(--border);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: var(--spacing);
            padding-bottom: 16px;
            border-bottom: 1px solid var(--border);
        }

        .card-title {
            font-size: 20px;
            font-weight: 700;
            color: var(--text-primary);
            display: flex;
            align-items: center;
        }

        .card-title i {
            margin-right: 12px;
            padding: 8px;
            background: var(--primary);
            border-radius: 8px;
            color: white;
            font-size: 16px;
        }

        .view-all {
            color: var(--text-secondary);
            text-decoration: none;
            font-size: 14px;
            padding: 8px 16px;
            border-radius: 20px;
            background: var(--bg-glass);
            border: 1px solid var(--border);
            transition: all 0.3s ease;
        }

        .view-all:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
        }

        /* Course Items */
        .course-item {
            display: flex;
            align-items: center;
            padding: 16px;
            border-radius: var(--radius-sm);
            margin-bottom: 12px;
            background: var(--bg-glass);
            border: 1px solid var(--border);
            transition: all 0.3s ease;
            position: relative;
        }

        .course-item:hover {
            background: var(--bg-card);
            transform: translateX(8px);
            box-shadow: var(--shadow);
        }

        .course-item::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: var(--primary);
            border-radius: 0 4px 4px 0;
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }

        .course-item:hover::before {
            transform: scaleY(1);
        }

        .course-icon {
            width: 48px;
            height: 48px;
            border-radius: var(--radius-sm);
            background: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 16px;
            color: white;
            font-size: 20px;
        }

        .course-info {
            flex: 1;
        }

        .course-name {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 4px;
            font-size: 16px;
        }

        .course-meta {
            font-size: 13px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .course-stats {
            text-align: right;
            font-size: 12px;
        }

        .progress-bar {
            width: 100px;
            height: 6px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 3px;
            overflow: hidden;
            margin: 4px 0;
        }

        .progress-fill {
            height: 100%;
            background: var(--success);
            border-radius: 3px;
            transition: width 1s ease;
        }

        /* Upcoming Events */
        .upcoming-item {
            display: flex;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid var(--border);
            transition: all 0.3s ease;
        }

        .upcoming-item:hover {
            background: var(--bg-glass);
            margin: 0 -12px;
            padding: 12px;
            border-radius: var(--radius-sm);
        }

        .upcoming-item:last-child {
            border-bottom: none;
        }

        .upcoming-date {
            background: var(--primary);
            color: white;
            padding: 12px;
            border-radius: var(--radius-sm);
            font-size: 12px;
            font-weight: 700;
            margin-right: 16px;
            min-width: 70px;
            text-align: center;
            position: relative;
        }

        .upcoming-date::before {
            content: '';
            position: absolute;
            inset: -2px;
            background: var(--primary);
            border-radius: var(--radius-sm);
            z-index: -1;
            opacity: 0.3;
            animation: breathe 2s ease-in-out infinite;
        }

        @keyframes breathe {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .upcoming-info {
            flex: 1;
        }

        .upcoming-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 4px;
        }

        .upcoming-course {
            font-size: 12px;
            color: var(--text-muted);
        }

        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-top: var(--spacing);
        }

        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background: var(--bg-card);
            color: var(--text-primary);
            text-decoration: none;
            border-radius: var(--radius);
            border: 1px solid var(--border);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-weight: 600;
            position: relative;
            overflow: hidden;
        }

        .action-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: var(--primary);
            transition: left 0.3s ease;
            z-index: -1;
        }

        .action-btn:hover::before {
            left: 0;
        }

        .action-btn:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-hover);
            color: white;
        }

        .action-btn i {
            margin-right: 12px;
            font-size: 20px;
        }

        /* Recent Activity */
        .recent-activity {
            max-height: 400px;
            overflow-y: auto;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            padding: 16px 0;
            border-bottom: 1px solid var(--border);
            transition: all 0.3s ease;
        }

        .activity-item:hover {
            background: var(--bg-glass);
            margin: 0 -16px;
            padding: 16px;
            border-radius: var(--radius-sm);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 48px;
            height: 48px;
            background: var(--bg-glass);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 16px;
            color: var(--text-secondary);
            border: 1px solid var(--border);
            position: relative;
        }

        .activity-icon::before {
            content: '';
            position: absolute;
            inset: -1px;
            background: var(--primary);
            border-radius: 50%;
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: -1;
        }

        .activity-item:hover .activity-icon::before {
            opacity: 0.2;
        }

        .activity-content {
            flex: 1;
        }

        .activity-text {
            color: var(--text-primary);
            margin-bottom: 4px;
            line-height: 1.5;
        }

        .activity-text strong {
            color: var(--text-primary);
            font-weight: 600;
        }

        .activity-time {
            font-size: 12px;
            color: var(--text-muted);
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.open {
                transform: translateX(0);
            }

            .main-content {
                margin-left: 0;
            }

            .instructor-stats {
                grid-template-columns: repeat(2, 1fr);
            }

            .header {
                flex-direction: column;
                gap: 16px;
            }

            .header-right {
                width: 100%;
                justify-content: space-between;
            }

            .search-box input {
                width: 100%;
            }

            .quick-actions {
                grid-template-columns: 1fr;
            }
        }

        /* Loading Animation */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            border-top-color: var(--text-primary);
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Scrollbar Styling */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: var(--bg-secondary);
        }

        ::-webkit-scrollbar-thumb {
            background: var(--border);
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: var(--text-muted);
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Modern Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h3><i class="fas fa-graduation-cap"></i> Adaptive E-Learning</h3>
            </div>
            
            <ul class="nav-menu">
                <li class="nav-item active">
                    <a href="${pageContext.request.contextPath}/instructor/dashboard" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Bảng điều khiển</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/instructor/courses" class="nav-link">
                        <i class="fas fa-book"></i>
                        <span>Khóa học của tôi</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/instructor/students" class="nav-link">
                        <i class="fas fa-user-graduate"></i>
                        <span>Học viên</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/instructor/assignments" class="nav-link">
                        <i class="fas fa-tasks"></i>
                        <span>Bài tập</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/instructor/grades" class="nav-link">
                        <i class="fas fa-chart-line"></i>
                        <span>Điểm số</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/instructor/messages" class="nav-link">
                        <i class="fas fa-envelope"></i>
                        <span>Tin nhắn</span>
                        <span class="notification-badge">3</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/instructor/analytics" class="nav-link">
                        <i class="fas fa-chart-bar"></i>
                        <span>Thống kê</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/instructor/calendar" class="nav-link">
                        <i class="fas fa-calendar"></i>
                        <span>Lịch trình</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/instructor/settings" class="nav-link">
                        <i class="fas fa-cog"></i>
                        <span>Cài đặt</span>
                    </a>
                </li>
            </ul>
            
            <div class="sidebar-footer">
                <div class="user-info">
                    <div class="user-avatar">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <div class="user-details">
                        <div class="user-name">${sessionScope.user.fullName}</div>
                        <div class="user-role">Giảng viên (@${sessionScope.user.userName})</div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i>
                    Đăng xuất
                </a>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Modern Header -->
            <header class="header">
                <div class="header-left">
                    <h1>Bảng điều khiển Giảng viên</h1>
                    <p>Chào mừng trở lại, ${sessionScope.user.fullName} (@${sessionScope.user.userName})! 🎓</p>
                </div>
                <div class="header-right">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Tìm kiếm khóa học, học viên...">
                    </div>
                    <div class="notifications">
                        <i class="fas fa-bell"></i>
                        <span class="notification-badge">5</span>
                    </div>
                </div>
            </header>

            <!-- Dashboard Content -->
            <div class="dashboard-content">
                <!-- Modern Statistics Cards -->
                <div class="instructor-stats">
                    <div class="stat-card courses">
                        <div class="stat-content">
                            <div class="stat-header">
                                <div>
                                    <div class="stat-number" data-count="12">0</div>
                                    <div class="stat-label">Khóa học đang dạy</div>
                                    <div class="stat-change positive">↗ +2 khóa học mới</div>
                                </div>
                                <div class="stat-icon">
                                    <i class="fas fa-book"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="stat-card students">
                        <div class="stat-content">
                            <div class="stat-header">
                                <div>
                                    <div class="stat-number" data-count="248">0</div>
                                    <div class="stat-label">Tổng số học viên</div>
                                    <div class="stat-change positive">↗ +15 học viên mới</div>
                                </div>
                                <div class="stat-icon">
                                    <i class="fas fa-user-graduate"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="stat-card assignments">
                        <div class="stat-content">
                            <div class="stat-header">
                                <div>
                                    <div class="stat-number" data-count="35">0</div>
                                    <div class="stat-label">Bài tập chờ chấm</div>
                                    <div class="stat-change negative">↘ -5 bài tập</div>
                                </div>
                                <div class="stat-icon">
                                    <i class="fas fa-tasks"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="stat-card messages">
                        <div class="stat-content">
                            <div class="stat-header">
                                <div>
                                    <div class="stat-number" data-count="8">0</div>
                                    <div class="stat-label">Tin nhắn mới</div>
                                    <div class="stat-change positive">↗ +3 tin nhắn</div>
                                </div>
                                <div class="stat-icon">
                                    <i class="fas fa-envelope"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Dashboard Grid -->
                <div class="dashboard-grid">
                    <!-- My Courses -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-book"></i>
                                Khóa học của tôi
                            </h3>
                            <a href="${pageContext.request.contextPath}/instructor/courses" class="view-all">
                                Xem tất cả <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                        <div class="courses-list">
                            <div class="course-item">
                                <div class="course-icon">
                                    <i class="fab fa-java"></i>
                                </div>
                                <div class="course-info">
                                    <div class="course-name">Lập trình Java Cơ bản</div>
                                    <div class="course-meta">
                                        <span><i class="fas fa-users"></i> 45 học viên</span>
                                        <span><i class="fas fa-play-circle"></i> 12 bài học</span>
                                    </div>
                                </div>
                                <div class="course-stats">
                                    <div class="progress-bar">
                                        <div class="progress-fill" style="width: 85%"></div>
                                    </div>
                                    <div style="color: var(--text-secondary); margin-top: 4px;">Tiến độ: 85%</div>
                                    <div style="color: #f39c12; font-size: 11px;">5 bài tập mới</div>
                                </div>
                            </div>
                            <div class="course-item">
                                <div class="course-icon">
                                    <i class="fas fa-database"></i>
                                </div>
                                <div class="course-info">
                                    <div class="course-name">Cơ sở dữ liệu MySQL</div>
                                    <div class="course-meta">
                                        <span><i class="fas fa-users"></i> 32 học viên</span>
                                        <span><i class="fas fa-play-circle"></i> 8 bài học</span>
                                    </div>
                                </div>
                                <div class="course-stats">
                                    <div class="progress-bar">
                                        <div class="progress-fill" style="width: 70%"></div>
                                    </div>
                                    <div style="color: var(--text-secondary); margin-top: 4px;">Tiến độ: 70%</div>
                                    <div style="color: #f39c12; font-size: 11px;">3 bài tập mới</div>
                                </div>
                            </div>
                            <div class="course-item">
                                <div class="course-icon">
                                    <i class="fab fa-html5"></i>
                                </div>
                                <div class="course-info">
                                    <div class="course-name">Web Development</div>
                                    <div class="course-meta">
                                        <span><i class="fas fa-users"></i> 67 học viên</span>
                                        <span><i class="fas fa-play-circle"></i> 15 bài học</span>
                                    </div>
                                </div>
                                <div class="course-stats">
                                    <div class="progress-bar">
                                        <div class="progress-fill" style="width: 92%"></div>
                                    </div>
                                    <div style="color: var(--text-secondary); margin-top: 4px;">Tiến độ: 92%</div>
                                    <div style="color: #f39c12; font-size: 11px;">2 bài tập mới</div>
                                </div>
                            </div>
                            <div class="course-item">
                                <div class="course-icon">
                                    <i class="fab fa-python"></i>
                                </div>
                                <div class="course-info">
                                    <div class="course-name">Python cho người mới bắt đầu</div>
                                    <div class="course-meta">
                                        <span><i class="fas fa-users"></i> 28 học viên</span>
                                        <span><i class="fas fa-play-circle"></i> 10 bài học</span>
                                    </div>
                                </div>
                                <div class="course-stats">
                                    <div class="progress-bar">
                                        <div class="progress-fill" style="width: 60%"></div>
                                    </div>
                                    <div style="color: var(--text-secondary); margin-top: 4px;">Tiến độ: 60%</div>
                                    <div style="color: #f39c12; font-size: 11px;">7 bài tập mới</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Upcoming Events -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">
                                <i class="fas fa-calendar-alt"></i>
                                Lịch trình sắp tới
                            </h3>
                            <a href="${pageContext.request.contextPath}/instructor/calendar" class="view-all">
                                Xem lịch <i class="fas fa-external-link-alt"></i>
                            </a>
                        </div>
                        <div class="upcoming-events">
                            <div class="upcoming-item">
                                <div class="upcoming-date">
                                    <div>23</div>
                                    <div>Oct</div>
                                </div>
                                <div class="upcoming-info">
                                    <div class="upcoming-title">Kiểm tra giữa kỳ</div>
                                    <div class="upcoming-course">Lập trình Java Cơ bản</div>
                                </div>
                            </div>
                            <div class="upcoming-item">
                                <div class="upcoming-date">
                                    <div>25</div>
                                    <div>Oct</div>
                                </div>
                                <div class="upcoming-info">
                                    <div class="upcoming-title">Hạn nộp bài tập</div>
                                    <div class="upcoming-course">Web Development</div>
                                </div>
                            </div>
                            <div class="upcoming-item">
                                <div class="upcoming-date">
                                    <div>28</div>
                                    <div>Oct</div>
                                </div>
                                <div class="upcoming-info">
                                    <div class="upcoming-title">Buổi thảo luận online</div>
                                    <div class="upcoming-course">Cơ sở dữ liệu MySQL</div>
                                </div>
                            </div>
                            <div class="upcoming-item">
                                <div class="upcoming-date">
                                    <div>30</div>
                                    <div>Oct</div>
                                </div>
                                <div class="upcoming-info">
                                    <div class="upcoming-title">Bài kiểm tra thực hành</div>
                                    <div class="upcoming-course">Python cho người mới bắt đầu</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-bolt"></i>
                            Thao tác nhanh
                        </h3>
                    </div>
                    <div class="quick-actions">
                        <a href="${pageContext.request.contextPath}/instructor/courses/create" class="action-btn">
                            <i class="fas fa-plus"></i>
                            Tạo khóa học mới
                        </a>
                        <a href="${pageContext.request.contextPath}/instructor/assignments/create" class="action-btn">
                            <i class="fas fa-clipboard-list"></i>
                            Tạo bài tập
                        </a>
                        <a href="${pageContext.request.contextPath}/instructor/announcements/create" class="action-btn">
                            <i class="fas fa-bullhorn"></i>
                            Gửi thông báo
                        </a>
                        <a href="${pageContext.request.contextPath}/instructor/grades" class="action-btn">
                            <i class="fas fa-star"></i>
                            Chấm điểm
                        </a>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">
                            <i class="fas fa-history"></i>
                            Hoạt động gần đây
                        </h3>
                    </div>
                    <div class="recent-activity">
                        <div class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-text">
                                    <strong>Nguyễn Văn An</strong> đã đăng ký khóa học "Lập trình Java Cơ bản"
                                </div>
                                <div class="activity-time">2 giờ trước</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-file-upload"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-text">
                                    <strong>Trần Thị Bình</strong> đã nộp bài tập "Tạo ứng dụng Web"
                                </div>
                                <div class="activity-time">4 giờ trước</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-comment"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-text">
                                    <strong>Lê Văn Cường</strong> đã bình luận trong khóa học "Web Development"
                                </div>
                                <div class="activity-time">6 giờ trước</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-trophy"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-text">
                                    <strong>Phạm Thị Dung</strong> đã hoàn thành khóa học "Python cho người mới bắt đầu"
                                </div>
                                <div class="activity-time">1 ngày trước</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-star"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-text">
                                    Khóa học "Cơ sở dữ liệu MySQL" nhận được đánh giá 5 sao từ <strong>Hoàng Văn Em</strong>
                                </div>
                                <div class="activity-time">2 ngày trước</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Enhanced JavaScript functionality
        document.addEventListener('DOMContentLoaded', function() {
            // Active navigation state
            const navLinks = document.querySelectorAll('.nav-link');
            const currentPath = window.location.pathname;
            
            navLinks.forEach(link => {
                if (link.getAttribute('href') === currentPath) {
                    link.parentElement.classList.add('active');
                } else {
                    link.parentElement.classList.remove('active');
                }
            });

            // Animated counter for statistics
            function animateCounter(element) {
                const target = parseInt(element.getAttribute('data-count'));
                const increment = target / 100;
                let current = 0;
                
                const timer = setInterval(() => {
                    current += increment;
                    element.textContent = Math.ceil(current);
                    
                    if (current >= target) {
                        element.textContent = target;
                        clearInterval(timer);
                    }
                }, 20);
            }

            // Start counter animations when page loads
            const statNumbers = document.querySelectorAll('.stat-number[data-count]');
            statNumbers.forEach(animateCounter);

            // Auto-refresh statistics every 30 seconds
            setInterval(refreshStats, 30000);
            
            // Enhanced search functionality
            initializeSearch();

            // Progress bar animations
            animateProgressBars();

            // Mobile menu toggle
            initializeMobileMenu();
        });

        function refreshStats() {
            fetch('${pageContext.request.contextPath}/instructor/api/stats')
                .then(response => response.json())
                .then(data => {
                    updateStatCard('.stat-card.courses .stat-number', data.totalCourses);
                    updateStatCard('.stat-card.students .stat-number', data.totalStudents);
                    updateStatCard('.stat-card.assignments .stat-number', data.pendingAssignments);
                    updateStatCard('.stat-card.messages .stat-number', data.newMessages);
                })
                .catch(error => console.error('Error refreshing stats:', error));
        }

        function updateStatCard(selector, newValue) {
            const element = document.querySelector(selector);
            if (element) {
                element.setAttribute('data-count', newValue);
                element.textContent = '0';
                animateCounter(element);
            }
        }

        function animateCounter(element) {
            const target = parseInt(element.getAttribute('data-count'));
            const increment = target / 50;
            let current = 0;
            
            const timer = setInterval(() => {
                current += increment;
                element.textContent = Math.ceil(current);
                
                if (current >= target) {
                    element.textContent = target;
                    clearInterval(timer);
                }
            }, 30);
        }

        function initializeSearch() {
            const searchInput = document.querySelector('.search-box input');
            searchInput.addEventListener('input', debounce(function(e) {
                const searchTerm = e.target.value.toLowerCase();
                if (searchTerm.length > 2) {
                    performSearch(searchTerm);
                }
            }, 300));
        }

        function performSearch(term) {
            // Add search loading state
            const searchIcon = document.querySelector('.search-box i');
            searchIcon.className = 'fas fa-spinner fa-spin';
            
            // Simulate search API call
            setTimeout(() => {
                searchIcon.className = 'fas fa-search';
                console.log('Searching for:', term);
                // Implement actual search logic here
            }, 1000);
        }

        function animateProgressBars() {
            const progressBars = document.querySelectorAll('.progress-fill');
            progressBars.forEach(bar => {
                const width = bar.style.width;
                bar.style.width = '0%';
                setTimeout(() => {
                    bar.style.width = width;
                }, 500);
            });
        }

        function initializeMobileMenu() {
            // Add mobile menu toggle button
            const header = document.querySelector('.header');
            const menuToggle = document.createElement('button');
            menuToggle.className = 'mobile-menu-toggle';
            menuToggle.innerHTML = '<i class="fas fa-bars"></i>';
            menuToggle.style.display = 'none';
            
            header.insertBefore(menuToggle, header.firstChild);
            
            menuToggle.addEventListener('click', function() {
                document.querySelector('.sidebar').classList.toggle('open');
            });
            
            // Show/hide menu button based on screen size
            function checkScreenSize() {
                if (window.innerWidth <= 768) {
                    menuToggle.style.display = 'block';
                } else {
                    menuToggle.style.display = 'none';
                    document.querySelector('.sidebar').classList.remove('open');
                }
            }
            
            window.addEventListener('resize', checkScreenSize);
            checkScreenSize();
        }

        function debounce(func, wait) {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
        }

        // Notification click handler
        document.querySelector('.notifications').addEventListener('click', function() {
            window.location.href = '${pageContext.request.contextPath}/instructor/notifications';
        });

        // Course item click handlers
        document.querySelectorAll('.course-item').forEach(item => {
            item.addEventListener('click', function() {
                const courseName = this.querySelector('.course-name').textContent;
                // Navigate to course detail page
                console.log('Navigating to course:', courseName);
            });
        });

        // Add loading states for action buttons
        document.querySelectorAll('.action-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                if (this.href && !this.href.includes('#')) {
                    const icon = this.querySelector('i');
                    const originalClass = icon.className;
                    icon.className = 'fas fa-spinner fa-spin';
                    
                    setTimeout(() => {
                        icon.className = originalClass;
                    }, 2000);
                }
            });
        });
    </script>
</body>
</html>
            /* Instructor-specific styles */
            .instructor-stats {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }
            
            .stat-card {
                background: white;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                border-left: 4px solid;
                transition: transform 0.3s ease;
            }
            
            .stat-card:hover {
                transform: translateY(-2px);
            }
            
            .stat-card.courses { border-left-color: #3498db; }
            .stat-card.students { border-left-color: #2ecc71; }
            .stat-card.assignments { border-left-color: #f39c12; }
            .stat-card.messages { border-left-color: #e74c3c; }
            
            .stat-number {
                font-size: 2.5rem;
                font-weight: bold;
                margin-bottom: 10px;
            }
            
            .stat-label {
                color: #666;
                font-size: 14px;
            }
            
            .stat-icon {
                float: right;
                font-size: 2rem;
                opacity: 0.3;
            }
            
            .dashboard-grid {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 30px;
                margin-bottom: 30px;
            }
            
            .card {
                background: white;
                border-radius: 10px;
                padding: 25px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            
            .card-header {
                display: flex;
                justify-content: between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 1px solid #eee;
            }
            
            .card-title {
                font-size: 18px;
                font-weight: 600;
                color: #333;
            }
            
            .course-item {
                display: flex;
                align-items: center;
                padding: 15px;
                border-bottom: 1px solid #f0f0f0;
                transition: background-color 0.3s ease;
            }
            
            .course-item:hover {
                background-color: #f8f9fa;
            }
            
            .course-item:last-child {
                border-bottom: none;
            }
            
            .course-info {
                flex: 1;
            }
            
            .course-name {
                font-weight: 600;
                color: #333;
                margin-bottom: 5px;
            }
            
            .course-meta {
                font-size: 12px;
                color: #666;
            }
            
            .course-stats {
                text-align: right;
                font-size: 12px;
                color: #666;
            }
            
            .upcoming-item {
                display: flex;
                align-items: center;
                padding: 12px 0;
                border-bottom: 1px solid #f0f0f0;
            }
            
            .upcoming-item:last-child {
                border-bottom: none;
            }
            
            .upcoming-date {
                background: #667eea;
                color: white;
                padding: 8px 12px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
                margin-right: 15px;
                min-width: 60px;
                text-align: center;
            }
            
            .upcoming-info {
                flex: 1;
            }
            
            .upcoming-title {
                font-weight: 600;
                color: #333;
                margin-bottom: 3px;
            }
            
            .upcoming-course {
                font-size: 12px;
                color: #666;
            }
            
            .quick-actions {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                margin-top: 20px;
            }
            
            .action-btn {
                display: flex;
                align-items: center;
                padding: 15px 20px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                text-decoration: none;
                border-radius: 8px;
                transition: transform 0.3s ease;
                font-weight: 500;
            }
            
            .action-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }
            
            .action-btn i {
                margin-right: 10px;
                font-size: 18px;
            }
            
            .recent-activity {
                max-height: 400px;
                overflow-y: auto;
            }
            
            .activity-item {
                display: flex;
                align-items: flex-start;
                padding: 15px 0;
                border-bottom: 1px solid #f0f0f0;
            }
            
            .activity-item:last-child {
                border-bottom: none;
            }
            
            .activity-icon {
                width: 40px;
                height: 40px;
                background: #f8f9fa;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 15px;
                color: #667eea;
            }
            
            .activity-content {
                flex: 1;
            }
            
            .activity-text {
                color: #333;
                margin-bottom: 5px;
            }
            
            .activity-time {
                font-size: 12px;
                color: #666;
            }
            
            .notification-badge {
                background: #e74c3c;
                color: white;
                border-radius: 50%;
                padding: 2px 6px;
                font-size: 11px;
                font-weight: bold;
            }
            
            @media (max-width: 768px) {
                .dashboard-grid {
                    grid-template-columns: 1fr;
                }
                
                .instructor-stats {
                    grid-template-columns: repeat(2, 1fr);
                }
                
                .quick-actions {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-container">
            <!-- Sidebar -->
            <nav class="sidebar">
                <div class="sidebar-header">
                    <h3><i class="fas fa-graduation-cap"></i> Adaptive E-Learning</h3>
                </div>
                
                <ul class="nav-menu">
                    <li class="nav-item active">
                        <a href="${pageContext.request.contextPath}/instructor/dashboard" class="nav-link">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Bảng điều khiển</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/instructor/courses" class="nav-link">
                            <i class="fas fa-book"></i>
                            <span>Khóa học của tôi</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/instructor/students" class="nav-link">
                            <i class="fas fa-user-graduate"></i>
                            <span>Học viên</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/instructor/assignments" class="nav-link">
                            <i class="fas fa-tasks"></i>
                            <span>Bài tập</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/instructor/grades" class="nav-link">
                            <i class="fas fa-chart-line"></i>
                            <span>Điểm số</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/instructor/messages" class="nav-link">
                            <i class="fas fa-envelope"></i>
                            <span>Tin nhắn</span>
                            <span class="notification-badge">3</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/instructor/analytics" class="nav-link">
                            <i class="fas fa-chart-bar"></i>
                            <span>Thống kê</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/instructor/calendar" class="nav-link">
                            <i class="fas fa-calendar"></i>
                            <span>Lịch trình</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="${pageContext.request.contextPath}/instructor/settings" class="nav-link">
                            <i class="fas fa-cog"></i>
                            <span>Cài đặt</span>
                        </a>
                    </li>
                </ul>
                
                <div class="sidebar-footer">
                    <div class="user-info">
                        <div class="user-avatar">
                            <i class="fas fa-user-circle"></i>
                        </div>
                        <div class="user-details">
                            <div class="user-name">${sessionScope.user.fullName}</div>
                            <div class="user-role">Giảng viên</div>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                        <i class="fas fa-sign-out-alt"></i>
                        Đăng xuất
                    </a>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="main-content">
                <!-- Header -->
                <header class="header">
                    <div class="header-left">
                        <h1>Bảng điều khiển Giảng viên</h1>
                        <p>Chào mừng trở lại, ${sessionScope.user.fullName}!</p>
                    </div>
                    <div class="header-right">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Tìm kiếm khóa học, học viên...">
                        </div>
                        <div class="notifications">
                            <i class="fas fa-bell"></i>
                            <span class="notification-badge">5</span>
                        </div>
                    </div>
                </header>

                <!-- Dashboard Content -->
                <div class="dashboard-content">
                    <!-- Statistics Cards -->
                    <div class="instructor-stats">
                        <div class="stat-card courses">
                            <div class="stat-icon">
                                <i class="fas fa-book"></i>
                            </div>
                            <div class="stat-number">12</div>
                            <div class="stat-label">Khóa học đang dạy</div>
                        </div>
                        <div class="stat-card students">
                            <div class="stat-icon">
                                <i class="fas fa-user-graduate"></i>
                            </div>
                            <div class="stat-number">248</div>
                            <div class="stat-label">Tổng số học viên</div>
                        </div>
                        <div class="stat-card assignments">
                            <div class="stat-icon">
                                <i class="fas fa-tasks"></i>
                            </div>
                            <div class="stat-number">35</div>
                            <div class="stat-label">Bài tập chờ chấm</div>
                        </div>
                        <div class="stat-card messages">
                            <div class="stat-icon">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div class="stat-number">8</div>
                            <div class="stat-label">Tin nhắn mới</div>
                        </div>
                    </div>

                    <!-- Main Dashboard Grid -->
                    <div class="dashboard-grid">
                        <!-- My Courses -->
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">Khóa học của tôi</h3>
                                <a href="${pageContext.request.contextPath}/instructor/courses" class="view-all">Xem tất cả</a>
                            </div>
                            <div class="courses-list">
                                <div class="course-item">
                                    <div class="course-info">
                                        <div class="course-name">Lập trình Java Cơ bản</div>
                                        <div class="course-meta">45 học viên • 12 bài học</div>
                                    </div>
                                    <div class="course-stats">
                                        <div>Tiến độ: 85%</div>
                                        <div>5 bài tập mới</div>
                                    </div>
                                </div>
                                <div class="course-item">
                                    <div class="course-info">
                                        <div class="course-name">Cơ sở dữ liệu MySQL</div>
                                        <div class="course-meta">32 học viên • 8 bài học</div>
                                    </div>
                                    <div class="course-stats">
                                        <div>Tiến độ: 70%</div>
                                        <div>3 bài tập mới</div>
                                    </div>
                                </div>
                                <div class="course-item">
                                    <div class="course-info">
                                        <div class="course-name">Web Development</div>
                                        <div class="course-meta">67 học viên • 15 bài học</div>
                                    </div>
                                    <div class="course-stats">
                                        <div>Tiến độ: 92%</div>
                                        <div>2 bài tập mới</div>
                                    </div>
                                </div>
                                <div class="course-item">
                                    <div class="course-info">
                                        <div class="course-name">Python cho người mới bắt đầu</div>
                                        <div class="course-meta">28 học viên • 10 bài học</div>
                                    </div>
                                    <div class="course-stats">
                                        <div>Tiến độ: 60%</div>
                                        <div>7 bài tập mới</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Upcoming Events -->
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">Lịch trình sắp tới</h3>
                                <a href="${pageContext.request.contextPath}/instructor/calendar" class="view-all">Xem lịch</a>
                            </div>
                            <div class="upcoming-events">
                                <div class="upcoming-item">
                                    <div class="upcoming-date">
                                        <div>23</div>
                                        <div>Oct</div>
                                    </div>
                                    <div class="upcoming-info">
                                        <div class="upcoming-title">Kiểm tra giữa kỳ</div>
                                        <div class="upcoming-course">Lập trình Java Cơ bản</div>
                                    </div>
                                </div>
                                <div class="upcoming-item">
                                    <div class="upcoming-date">
                                        <div>25</div>
                                        <div>Oct</div>
                                    </div>
                                    <div class="upcoming-info">
                                        <div class="upcoming-title">Hạn nộp bài tập</div>
                                        <div class="upcoming-course">Web Development</div>
                                    </div>
                                </div>
                                <div class="upcoming-item">
                                    <div class="upcoming-date">
                                        <div>28</div>
                                        <div>Oct</div>
                                    </div>
                                    <div class="upcoming-info">
                                        <div class="upcoming-title">Buổi thảo luận online</div>
                                        <div class="upcoming-course">Cơ sở dữ liệu MySQL</div>
                                    </div>
                                </div>
                                <div class="upcoming-item">
                                    <div class="upcoming-date">
                                        <div>30</div>
                                        <div>Oct</div>
                                    </div>
                                    <div class="upcoming-info">
                                        <div class="upcoming-title">Bài kiểm tra thực hành</div>
                                        <div class="upcoming-course">Python cho người mới bắt đầu</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Thao tác nhanh</h3>
                        </div>
                        <div class="quick-actions">
                            <a href="${pageContext.request.contextPath}/instructor/courses/create" class="action-btn">
                                <i class="fas fa-plus"></i>
                                Tạo khóa học mới
                            </a>
                            <a href="${pageContext.request.contextPath}/instructor/assignments/create" class="action-btn">
                                <i class="fas fa-clipboard-list"></i>
                                Tạo bài tập
                            </a>
                            <a href="${pageContext.request.contextPath}/instructor/announcements/create" class="action-btn">
                                <i class="fas fa-bullhorn"></i>
                                Gửi thông báo
                            </a>
                            <a href="${pageContext.request.contextPath}/instructor/grades" class="action-btn">
                                <i class="fas fa-star"></i>
                                Chấm điểm
                            </a>
                        </div>
                    </div>

                    <!-- Recent Activity -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Hoạt động gần đây</h3>
                        </div>
                        <div class="recent-activity">
                            <div class="activity-item">
                                <div class="activity-icon">
                                    <i class="fas fa-user-plus"></i>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-text">
                                        <strong>Nguyễn Văn An</strong> đã đăng ký khóa học "Lập trình Java Cơ bản"
                                    </div>
                                    <div class="activity-time">2 giờ trước</div>
                                </div>
                            </div>
                            <div class="activity-item">
                                <div class="activity-icon">
                                    <i class="fas fa-file-upload"></i>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-text">
                                        <strong>Trần Thị Bình</strong> đã nộp bài tập "Tạo ứng dụng Web"
                                    </div>
                                    <div class="activity-time">4 giờ trước</div>
                                </div>
                            </div>
                            <div class="activity-item">
                                <div class="activity-icon">
                                    <i class="fas fa-comment"></i>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-text">
                                        <strong>Lê Văn Cường</strong> đã bình luận trong khóa học "Web Development"
                                    </div>
                                    <div class="activity-time">6 giờ trước</div>
                                </div>
                            </div>
                            <div class="activity-item">
                                <div class="activity-icon">
                                    <i class="fas fa-trophy"></i>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-text">
                                        <strong>Phạm Thị Dung</strong> đã hoàn thành khóa học "Python cho người mới bắt đầu"
                                    </div>
                                    <div class="activity-time">1 ngày trước</div>
                                </div>
                            </div>
                            <div class="activity-item">
                                <div class="activity-icon">
                                    <i class="fas fa-star"></i>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-text">
                                        Khóa học "Cơ sở dữ liệu MySQL" nhận được đánh giá 5 sao từ <strong>Hoàng Văn Em</strong>
                                    </div>
                                    <div class="activity-time">2 ngày trước</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <script>
            // Add active state to current nav item
            document.addEventListener('DOMContentLoaded', function() {
                const navLinks = document.querySelectorAll('.nav-link');
                const currentPath = window.location.pathname;
                
                navLinks.forEach(link => {
                    if (link.getAttribute('href') === currentPath) {
                        link.parentElement.classList.add('active');
                    } else {
                        link.parentElement.classList.remove('active');
                    }
                });
                
                // Auto-refresh statistics every 30 seconds
                setInterval(refreshStats, 30000);
                
                // Initialize search functionality
                initializeSearch();
            });
            
            function refreshStats() {
                // AJAX call to refresh statistics
                fetch('${pageContext.request.contextPath}/instructor/api/stats')
                    .then(response => response.json())
                    .then(data => {
                        document.querySelector('.stat-card.courses .stat-number').textContent = data.totalCourses;
                        document.querySelector('.stat-card.students .stat-number').textContent = data.totalStudents;
                        document.querySelector('.stat-card.assignments .stat-number').textContent = data.pendingAssignments;
                        document.querySelector('.stat-card.messages .stat-number').textContent = data.newMessages;
                    })
                    .catch(error => console.error('Error refreshing stats:', error));
            }
            
            function initializeSearch() {
                const searchInput = document.querySelector('.search-box input');
                searchInput.addEventListener('input', function(e) {
                    const searchTerm = e.target.value.toLowerCase();
                    // Implement search functionality here
                    console.log('Searching for:', searchTerm);
                });
            }
            
            // Notification click handler
            document.querySelector('.notifications').addEventListener('click', function() {
                // Show notifications dropdown or redirect to notifications page
                window.location.href = '${pageContext.request.contextPath}/instructor/notifications';
            });
        </script>
    </body>
    </html>