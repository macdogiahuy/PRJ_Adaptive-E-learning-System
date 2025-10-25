<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="controller.CourseManagementController" %>
<%@ page import="controller.CourseManagementController.Course" %>
<%@ page import="controller.CourseManagementController.CourseStats" %>
<%@ page import="java.util.List" %>
<%
    CourseManagementController controller = new CourseManagementController();
    CourseStats stats = controller.getCourseStats();
    
    String searchQuery = request.getParameter("search");
    if (searchQuery == null) searchQuery = "";
    
    int currentPage = 1;
    try {
        if (request.getParameter("page") != null) {
            currentPage = Integer.parseInt(request.getParameter("page"));
        }
    } catch (NumberFormatException e) {
        currentPage = 1;
    }
    
    int itemsPerPage = 12;
    List<Course> courses = controller.getCourses(searchQuery, itemsPerPage, (currentPage - 1) * itemsPerPage);
    int totalCourses = controller.getTotalCoursesCount(searchQuery);
    int totalPages = (int) Math.ceil((double) totalCourses / itemsPerPage);
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Course Management - CourseHub E-Learning</title>
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
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
        }

        .stat-info {
            position: relative;
            z-index: 2;
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

        /* Content Section */
        .content-section {
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(20px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.1);
            transition: all 0.3s ease;
        }

        .content-section:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(139, 92, 246, 0.3);
            border-color: rgba(139, 92, 246, 0.4);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .section-header h2 {
            color: #F8FAFC;
            font-size: 1.3rem;
            font-weight: 600;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        /* Search Container */
        .search-container {
            margin-bottom: 2rem;
        }

        .search-bar {
            display: flex;
            align-items: center;
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(16px);
            border: 2px solid rgba(139, 92, 246, 0.2);
            border-radius: 12px;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
            max-width: 500px;
        }

        .search-bar:focus-within {
            border-color: #8B5CF6;
            box-shadow: 0 0 20px rgba(139, 92, 246, 0.3);
        }

        .search-bar input {
            flex: 1;
            background: transparent;
            border: none;
            color: #F8FAFC;
            font-size: 1rem;
            outline: none;
            font-weight: 500;
        }

        .search-bar input::placeholder {
            color: rgba(248, 250, 252, 0.6);
        }

        .search-bar button {
            background: linear-gradient(135deg, #06B6D4, #8B5CF6);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-left: 0.75rem;
        }

        .search-bar button:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 20px rgba(139, 92, 246, 0.3);
        }

        /* Courses Grid */
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
            display: flex;
            flex-direction: column;
            min-height: 450px;
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
            flex-shrink: 0;
        }

        .course-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .course-thumbnail-placeholder {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #f7fafc, #edf2f7);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #a0aec0;
            font-size: 2rem;
            flex-shrink: 0;
        }

        .course-info {
            padding: 1.5rem;
            position: relative;
            z-index: 1;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .course-title {
            font-size: 1.1rem;
            font-weight: bold;
            color: #F8FAFC;
            margin-bottom: 0.5rem;
            line-height: 1.3;
            min-height: 2.6rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
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

        .course-price {
            font-size: 1.2rem;
            font-weight: bold;
            color: #06B6D4;
        }

        .course-status {
            margin-top: auto;
            margin-bottom: 0;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-ongoing { 
            background: rgba(72, 187, 120, 0.1); 
            color: #2f855a; 
            border: 1px solid rgba(72, 187, 120, 0.2);
        }
        .status-draft { 
            background: rgba(237, 137, 54, 0.1); 
            color: #c05621; 
            border: 1px solid rgba(237, 137, 54, 0.2);
        }
        .status-completed { 
            background: rgba(66, 153, 225, 0.1); 
            color: #2c5282; 
            border: 1px solid rgba(66, 153, 225, 0.2);
        }
        .status-off { 
            background: rgba(239, 68, 68, 0.1); 
            color: #c53030; 
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        /* Course Actions */
        .course-actions {
            margin-top: 0.5rem;
            display: flex;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-ban, .btn-unban {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.6rem;
            min-width: 120px;
            justify-content: center;
        }

        .btn-ban {
            background: linear-gradient(135deg, #EF4444, #DC2626);
            color: white;
        }

        .btn-ban:hover {
            background: linear-gradient(135deg, #DC2626, #B91C1C);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(239, 68, 68, 0.3);
        }

        .btn-unban {
            background: linear-gradient(135deg, #10B981, #059669);
            color: white;
        }

        .btn-unban:hover {
            background: linear-gradient(135deg, #059669, #047857);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(16, 185, 129, 0.3);
        }

        /* Alert Messages */
        .alert {
            padding: 1rem 1.5rem;
            margin: 1rem 0;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
            animation: slideIn 0.3s ease;
        }

        .alert-success {
            background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(5, 150, 105, 0.05));
            border: 1px solid rgba(16, 185, 129, 0.2);
            color: #059669;
        }

        .alert-error {
            background: linear-gradient(135deg, rgba(239, 68, 68, 0.1), rgba(220, 38, 38, 0.05));
            border: 1px solid rgba(239, 68, 68, 0.2);
            color: #DC2626;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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

            .courses-grid {
                grid-template-columns: 1fr;
            }
        }

        .page-title {
            margin-bottom: 2rem;
        }

        .page-title h1 {
            color: #F8FAFC;
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 0 20px rgba(139, 92, 246, 0.8);
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .page-title p {
            color: rgba(248, 250, 252, 0.8);
            font-size: 1.1rem;
        }

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
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #06B6D4, #8B5CF6);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(139, 92, 246, 0.3);
            border-color: rgba(139, 92, 246, 0.4);
        }

        .stat-card.users::before { --accent-color: #667eea; }
        .stat-card.courses::before { --accent-color: #f093fb; }
        .stat-card.enrollments::before { --accent-color: #4facfe; }
        .stat-card.notifications::before { --accent-color: #43e97b; }

        .stat-info h3 {
            color: rgba(248, 250, 252, 0.8);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .stat-info .number {
            font-size: 2rem;
            font-weight: bold;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 0 0 20px rgba(139, 92, 246, 0.8);
        }

        .stat-info .change {
            color: #28a745;
            font-size: 0.8rem;
        }

        .stat-icon {
            font-size: 2rem;
            opacity: 0.3;
        }

        .content-section {
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(20px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 24px;
            padding: 2.5rem;
            box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.1);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .section-header h2 {
            color: #F8FAFC;
            font-size: 1.75rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .search-container {
            margin-bottom: 2rem;
        }

        .search-bar {
            display: flex;
            align-items: center;
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(16px);
            border: 2px solid rgba(139, 92, 246, 0.2);
            border-radius: 16px;
            padding: 0.75rem 1.25rem;
            transition: all 0.3s ease;
            max-width: 500px;
        }

        .search-bar:focus-within {
            border-color: #8B5CF6;
            box-shadow: 0 0 20px rgba(139, 92, 246, 0.3);
        }

        .search-bar input {
            flex: 1;
            background: transparent;
            border: none;
            color: #F8FAFC;
            font-size: 1rem;
            outline: none;
            font-weight: 500;
        }

        .search-bar input::placeholder {
            color: rgba(248, 250, 252, 0.6);
        }

        .search-bar button {
            background: linear-gradient(135deg, #06B6D4, #8B5CF6);
            border: none;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-left: 0.75rem;
        }

        .search-bar button:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 20px rgba(139, 92, 246, 0.3);
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }

        .course-card {
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            backdrop-filter: blur(16px);
            border: 1px solid rgba(139, 92, 246, 0.2);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(139, 92, 246, 0.1);
            transition: all 0.3s ease;
            position: relative;
        }

        .course-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(139, 92, 246, 0.3);
            border-color: rgba(139, 92, 246, 0.4);
        }

        .course-thumbnail {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: linear-gradient(135deg, #f7fafc, #edf2f7);
        }

        .course-thumbnail-placeholder {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #f7fafc, #edf2f7);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #a0aec0;
            font-size: 2rem;
        }

        .course-info {
            padding: 1.75rem;
        }

        .course-title {
            font-size: 1.125rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
            color: #F8FAFC;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 1rem 0;
        }

        .course-level {
            background: linear-gradient(135deg, #06B6D4, #8B5CF6);
            color: white;
            padding: 0.375rem 0.875rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .course-price {
            font-size: 1.25rem;
            font-weight: 800;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .course-status {
            margin-top: 1rem;
        }

        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-ongoing { 
            background: rgba(72, 187, 120, 0.1); 
            color: #2f855a; 
            border: 1px solid rgba(72, 187, 120, 0.2);
        }
        .status-draft { 
            background: rgba(237, 137, 54, 0.1); 
            color: #c05621; 
            border: 1px solid rgba(237, 137, 54, 0.2);
        }
        .status-completed { 
            background: rgba(66, 153, 225, 0.1); 
            color: #2c5282; 
            border: 1px solid rgba(66, 153, 225, 0.2);
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 1rem;
        }

        .pagination button {
            background: white;
            border: 2px solid #e2e8f0;
            color: #4a5568;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .pagination button:hover:not(:disabled) {
            border-color: #667eea;
            color: #667eea;
            transform: translateY(-1px);
        }

        .pagination button:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }

        .pagination .current-page {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 600;
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #a0aec0;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: #4a5568;
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                order: 2;
            }
            
            .sidebar ul {
                display: flex;
                overflow-x: auto;
                padding: 1rem;
                gap: 0.5rem;
            }
            
            .sidebar li {
                margin: 0;
                flex-shrink: 0;
            }

            .main-content {
                order: 1;
                padding: 1rem;
            }

            .stats-container {
                grid-template-columns: repeat(2, 1fr);
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
    
    <header class="header universe-header">
        <h1 class="universe-title">
            <i class="fas fa-graduation-cap"></i>
            Course Management - CourseHub E-Learning
        </h1>
       
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
                    <li><a href="/Adaptive_Elearning/admin_coursemanagement.jsp" class="active">
                        <i class="fa-solid fa-bars-progress"></i>
                        <span>Quản Lý Khóa Học</span>
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
                <h2><i class="fas fa-graduation-cap"></i> Quản lý khóa học</h2>
            </div>

            <!-- Success/Error Messages -->
            <%
                String successMessage = (String) session.getAttribute("successMessage");
                String errorMessage = (String) session.getAttribute("errorMessage");
                if (successMessage != null) {
                    session.removeAttribute("successMessage");
            %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= successMessage %>
            </div>
            <%
                }
                if (errorMessage != null) {
                    session.removeAttribute("errorMessage");
            %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i>
                <%= errorMessage %>
            </div>
            <%
                }
            %>

            <!-- Statistics Section -->
            <div class="stats-container">
                <div class="stat-card users">
                    <div class="stat-info">
                        <h3>Tổng số khóa học</h3>
                        <div class="number"><%= stats.getTotalCourses() %></div>
                        <div class="change">Tổng cộng trong hệ thống</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-book"></i>
                    </div>
                </div>
                <div class="stat-card courses">
                    <div class="stat-info">
                        <h3>Khóa học đang diễn ra</h3>
                        <div class="number"><%= stats.getOngoingCourses() %></div>
                        <div class="change">Đang hoạt động</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-play-circle"></i>
                    </div>
                </div>
                <div class="stat-card enrollments">
                    <div class="stat-info">
                        <h3>Khóa học hoàn thành</h3>
                        <div class="number"><%= stats.getCompletedCourses() %></div>
                        <div class="change">Đã hoàn thành</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
                <div class="stat-card notifications">
                    <div class="stat-info">
                        <h3>Bản nháp</h3>
                        <div class="number"><%= stats.getDraftCourses() %></div>
                        <div class="change">Chờ xuất bản</div>
                    </div>
                    <div class="stat-icon">
                        <i class="fas fa-edit"></i>
                    </div>
                </div>
            </div>

            <!-- Courses Section -->
            <div class="content-section">
                <div class="section-header">
                    <h2><i class="fas fa-list-alt"></i> Danh sách khóa học</h2>
                </div>

                <!-- Search Bar -->
                <div class="search-container">
                    <form class="search-bar" method="get">
                        <input type="text" name="search" placeholder="Tìm kiếm khóa học theo tên..." value="<%= searchQuery %>">
                        <button type="submit"><i class="fas fa-search"></i> Tìm kiếm</button>
                    </form>
                </div>

                <!-- Courses Grid -->
                <div class="courses-grid">
                    <% if (courses != null && !courses.isEmpty()) { 
                        for (Course course : courses) { %>
                        <div class="course-card">
                            <% if (course.getThumbUrl() != null && !course.getThumbUrl().isEmpty()) { %>
                                <img src="<%= course.getThumbUrl() %>" alt="Course Thumbnail" class="course-thumbnail">
                            <% } else { %>
                                <div class="course-thumbnail-placeholder">
                                    <i class="fas fa-book-open"></i>
                                </div>
                            <% } %>
                            
                            <div class="course-info">
                                <h3 class="course-title"><%= course.getTitle() %></h3>
                                
                                <div class="course-meta">
                                    <span class="course-level"><%= course.getLevel() %></span>
                                    <span class="course-price"><%= course.getFormattedPrice() %></span>
                                </div>
                                
                                <div class="course-status">
                                    <% String status = course.getStatus();
                                       String statusClass = "status-ongoing"; // default
                                       if ("Draft".equalsIgnoreCase(status)) statusClass = "status-draft";
                                       else if ("Completed".equalsIgnoreCase(status)) statusClass = "status-completed";
                                       else if ("Off".equalsIgnoreCase(status)) statusClass = "status-off";
                                    %>
                                    <span class="status-badge <%= statusClass %>"><%= status %></span>
                                </div>
                                
                                <!-- Course Actions -->
                                <div class="course-actions">
                                    <% if ("Ongoing".equalsIgnoreCase(status)) { %>
                                        <a href="course_ban_handler.jsp?action=ban&courseId=<%= course.getId() %>&currentPage=<%= currentPage %>&searchQuery=<%= java.net.URLEncoder.encode(searchQuery, "UTF-8") %>" 
                                           class="btn-ban"
                                           onclick="return confirm('Bạn có chắc chắn muốn ban khóa học này?');">
                                            <i class="fas fa-ban"></i> Ban
                                        </a>
                                    <% } else if ("Off".equalsIgnoreCase(status)) { %>
                                        <a href="course_ban_handler.jsp?action=unban&courseId=<%= course.getId() %>&currentPage=<%= currentPage %>&searchQuery=<%= java.net.URLEncoder.encode(searchQuery, "UTF-8") %>" 
                                           class="btn-unban"
                                           onclick="return confirm('Bạn có chắc chắn muốn unban khóa học này?');">
                                            <i class="fas fa-check"></i> Unban
                                        </a>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    <% } 
                    } else { %>
                        <div class="empty-state">
                            <i class="fas fa-search"></i>
                            <h3>Không tìm thấy khóa học nào</h3>
                            <p>Thử thay đổi từ khóa tìm kiếm hoặc xóa bộ lọc để xem tất cả khóa học</p>
                        </div>
                    <% } %>
                </div>

                <!-- Pagination -->
                <% if (totalPages > 1) { %>
                <div class="pagination">
                    <button onclick="goToPage(<%= currentPage - 1 %>)" <%= currentPage <= 1 ? "disabled" : "" %>>
                        <i class="fas fa-chevron-left"></i> Trước
                    </button>
                    
                    <span class="current-page">Trang <%= currentPage %> / <%= totalPages %></span>
                    
                    <button onclick="goToPage(<%= currentPage + 1 %>)" <%= currentPage >= totalPages ? "disabled" : "" %>>
                        Sau <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
                <% } %>
            </div>
        </main>
    </div>

    <script>
        function goToPage(page) {
            if (page >= 1 && page <= <%= totalPages %>) {
                const url = new URL(window.location);
                url.searchParams.set('page', page);
                window.location.href = url.toString();
            }
        }

        // Add smooth scrolling
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            });
        });

        // Add loading animation to search
        document.querySelector('.search-bar form').addEventListener('submit', function(e) {
            const button = this.querySelector('button');
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tìm...';
        });
    </script>

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

            // Add universe glow effects to interactive elements
            const interactiveElements = document.querySelectorAll('button, .course-card, .stat-card, .search-bar');
            interactiveElements.forEach(element => {
                element.addEventListener('mouseenter', function() {
                    this.style.boxShadow = '0 0 30px rgba(139, 92, 246, 0.4)';
                });
                element.addEventListener('mouseleave', function() {
                    this.style.boxShadow = '';
                });
            });
        });
    </script>
</body>
</html>