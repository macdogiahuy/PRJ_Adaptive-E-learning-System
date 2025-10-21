<<<<<<< HEAD
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

=======
<%@page import="controller.ReportedCourseController"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Get parameters
    String pageParam = request.getParameter("page");
    String searchStatus = request.getParameter("status");
    String entriesParam = request.getParameter("entries");
    
    int currentPage = 1;
    if (pageParam != null && !pageParam.trim().isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    int recordsPerPage = 8; // default for better card layout
    if (entriesParam != null && !entriesParam.trim().isEmpty()) {
        try {
            int entries = Integer.parseInt(entriesParam);
            if (entries == 4 || entries == 8 || entries == 12 || entries == 16) {
                recordsPerPage = entries;
            }
        } catch (NumberFormatException e) {
            recordsPerPage = 8;
        }
    }
    
    if (searchStatus == null) {
        searchStatus = "";
    }
    
    // Initialize variables
    Map<String, Object> reportData = null;
    List<String> reportStatuses = null;
    Map<String, Object> reportStats = null;
    String error = null;
    String success = null;
    
    // Check for status messages
    String updated = request.getParameter("updated");
    String suspended = request.getParameter("suspended");
    String errorMsg = request.getParameter("msg");
    
    if ("success".equals(updated)) {
        success = "Cập nhật trạng thái báo cáo thành công!";
    } else if ("error".equals(updated)) {
        error = "Lỗi khi cập nhật trạng thái: " + (errorMsg != null ? errorMsg : "Unknown error");
    } else if ("success".equals(suspended)) {
        success = "Đình chỉ khóa học thành công!";
    } else if ("error".equals(suspended)) {
        error = "Lỗi khi đình chỉ khóa học: " + (errorMsg != null ? errorMsg : "Unknown error");
    }
    
    // Load data using ReportedCourseController
    try {
        ReportedCourseController controller = new ReportedCourseController();
        
        // Test connection first
        if (controller.testDatabaseConnection()) {
            // Load reported courses with pagination and search
            reportData = controller.getReportedCourses(currentPage, searchStatus, recordsPerPage);
            reportStatuses = controller.getReportStatuses();
            reportStats = controller.getReportStatistics();
        } else {
            error = "Không thể kết nối tới database CourseHubDB";
        }
    } catch (Exception e) {
        e.printStackTrace();
        error = "Lỗi: " + e.getMessage();
    }
    
    // Set default values if data loading failed
    if (reportData == null) {
        reportData = new java.util.HashMap<>();
        reportData.put("reportedCourses", new ArrayList<>());
        reportData.put("currentPage", 1);
        reportData.put("totalPages", 0);
        reportData.put("totalRecords", 0);
        reportData.put("recordsPerPage", recordsPerPage);
    }
    
    if (reportStatuses == null) {
        reportStatuses = new ArrayList<>();
    }
    
    if (reportStats == null) {
        reportStats = new java.util.HashMap<>();
        reportStats.put("totalReports", 0);
        reportStats.put("statusStats", new java.util.HashMap<>());
        reportStats.put("recentReports", 0);
        reportStats.put("reasonStats", new java.util.HashMap<>());
    }
    
    // Extract data for easy access
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> reportedCourses = (List<Map<String, Object>>) reportData.get("reportedCourses");
    
    int totalPages = (Integer) reportData.get("totalPages");
    int totalRecords = (Integer) reportData.get("totalRecords");
    int totalReports = (Integer) reportStats.get("totalReports");
    int recentReports = (Integer) reportStats.get("recentReports");
    
    @SuppressWarnings("unchecked")
    Map<String, Integer> statusStats = (Map<String, Integer>) reportStats.get("statusStats");
    
    @SuppressWarnings("unchecked")
    Map<String, Integer> reasonStats = (Map<String, Integer>) reportStats.get("reasonStats");
    
    // Date and number formatters
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<<<<<<< HEAD
    <title>Quản lý nhóm bị báo cáo - CourseHub Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="${pageContext.request.contextPath}/assests/css/universe-background.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
=======
    <title>Reported Courses - CourseHub E-Learning</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assests/css/universe-background.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
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
<<<<<<< HEAD
        
=======

>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
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
<<<<<<< HEAD
        .stats-container {
=======
        .stats-grid {
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
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
<<<<<<< HEAD
=======
            color: #F8FAFC;
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
        }

        .stat-card::before {
            content: '';
            position: absolute;
<<<<<<< HEAD
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent, rgba(139, 92, 246, 0.1), transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
=======
            top: -100%;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(139, 92, 246, 0.2), transparent);
            transition: left 0.5s;
        }

        .stat-card:hover::before {
            left: 100%;
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(139, 92, 246, 0.3);
            border-color: rgba(139, 92, 246, 0.4);
        }

<<<<<<< HEAD
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
=======
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

        .stat-icon.reports { background: linear-gradient(135deg, #8B5CF6, #06B6D4); }
        .stat-icon.recent { background: linear-gradient(135deg, #EC4899, #8B5CF6); }
        .stat-icon.pending { background: linear-gradient(135deg, #06B6D4, #3B82F6); }
        .stat-icon.resolved { background: linear-gradient(135deg, #10B981, #06B6D4); }

        .stat-info {
            position: relative;
            z-index: 2;
        }

        .stat-info h3 {
            font-size: 2rem;
            font-weight: bold;
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 0 0 20px rgba(139, 92, 246, 0.8);
        }

<<<<<<< HEAD
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
=======
        .stat-info p {
            color: rgba(248, 250, 252, 0.7);
            font-size: 0.9rem;
        }

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
            padding: 1rem 1.25rem;
            border: 2px solid rgba(139, 92, 246, 0.3);
            background: linear-gradient(145deg, 
                rgba(15, 15, 35, 0.9), 
                rgba(26, 26, 46, 0.8)
            );
            backdrop-filter: blur(20px);
            border-radius: 12px;
            font-size: 0.95rem;
            font-weight: 500;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            color: #F8FAFC;
            box-shadow: 
                0 4px 6px -1px rgba(0, 0, 0, 0.1),
                0 2px 4px -1px rgba(0, 0, 0, 0.06),
                inset 0 1px 0 rgba(139, 92, 246, 0.1);
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%238B5CF6' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
            padding-right: 2.5rem;
            cursor: pointer;
        }

        .form-group select:hover {
            border-color: rgba(139, 92, 246, 0.5);
            box-shadow: 
                0 8px 25px -8px rgba(139, 92, 246, 0.3),
                0 2px 4px -1px rgba(0, 0, 0, 0.06),
                inset 0 1px 0 rgba(139, 92, 246, 0.15);
            transform: translateY(-1px);
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%2306B6D4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
        }

        .form-group select:focus {
            outline: none;
            border-color: #8B5CF6;
            box-shadow: 
                0 0 0 3px rgba(139, 92, 246, 0.2),
                0 8px 25px -8px rgba(139, 92, 246, 0.4),
                inset 0 1px 0 rgba(139, 92, 246, 0.2);
            transform: translateY(-1px);
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23F8FAFC' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
        }

        /* Dropdown options styling */
        .form-group select option {
            background: rgba(15, 15, 35, 0.95) !important;
            color: #F8FAFC !important;
            border: none !important;
            padding: 0.75rem !important;
            font-weight: 500 !important;
        }

        .form-group select option:hover,
        .form-group select option:focus {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4) !important;
            color: white !important;
        }

        .form-group select option:checked,
        .form-group select option:selected {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4) !important;
            color: white !important;
        }

        .form-group select option:not(:checked):not(:selected) {
            background: rgba(15, 15, 35, 0.95) !important;
            color: #F8FAFC !important;
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
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
<<<<<<< HEAD
            gap: 0.5rem;
=======
            gap: 0.75rem;
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
            color: #F8FAFC;
        }

        .entries-select select {
<<<<<<< HEAD
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
=======
            padding: 0.75rem 1rem;
            border: 2px solid rgba(139, 92, 246, 0.3);
            background: linear-gradient(145deg, 
                rgba(15, 15, 35, 0.9), 
                rgba(26, 26, 46, 0.8)
            );
            backdrop-filter: blur(20px);
            border-radius: 12px;
            font-size: 0.9rem;
            font-weight: 500;
            color: #F8FAFC;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 
                0 4px 6px -1px rgba(0, 0, 0, 0.1),
                0 2px 4px -1px rgba(0, 0, 0, 0.06),
                inset 0 1px 0 rgba(139, 92, 246, 0.1);
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%238B5CF6' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
            padding-right: 2.5rem;
            cursor: pointer;
        }

        .entries-select select:hover {
            border-color: rgba(139, 92, 246, 0.5);
            box-shadow: 
                0 8px 25px -8px rgba(139, 92, 246, 0.3),
                0 2px 4px -1px rgba(0, 0, 0, 0.06),
                inset 0 1px 0 rgba(139, 92, 246, 0.15);
            transform: translateY(-1px);
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%2306B6D4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
        }

        .entries-select select:focus {
            outline: none;
            border-color: #8B5CF6;
<<<<<<< HEAD
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
=======
            box-shadow: 
                0 0 0 3px rgba(139, 92, 246, 0.2),
                0 8px 25px -8px rgba(139, 92, 246, 0.4),
                inset 0 1px 0 rgba(139, 92, 246, 0.2);
            transform: translateY(-1px);
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23F8FAFC' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
        }

        /* Entries select options styling */
        .entries-select select option {
            background: rgba(15, 15, 35, 0.95) !important;
            color: #F8FAFC !important;
            border: none !important;
            padding: 0.75rem !important;
            font-weight: 500 !important;
        }

        .entries-select select option:hover,
        .entries-select select option:focus {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4) !important;
            color: white !important;
        }

        .entries-select select option:checked,
        .entries-select select option:selected {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4) !important;
            color: white !important;
        }

        .entries-select select option:not(:checked):not(:selected) {
            background: rgba(15, 15, 35, 0.95) !important;
            color: #F8FAFC !important;
        }

        /* Additional styling for better dropdown behavior */
        select {
            color-scheme: dark;
        }

        select::-webkit-dropdown {
            background: rgba(15, 15, 35, 0.95) !important;
        }

        /* Force all select options to maintain dark theme */
        select option,
        .form-group select option,
        .entries-select select option {
            background-color: rgba(15, 15, 35, 0.95) !important;
            color: #F8FAFC !important;
        }

        /* Specific hover states that override defaults */
        select option:hover,
        .form-group select option:hover,
        .entries-select select option:hover {
            background-color: #8B5CF6 !important;
            background: linear-gradient(135deg, #8B5CF6, #06B6D4) !important;
            color: white !important;
        }

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

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .course-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            position: relative;
        }

        .course-card:hover {
            transform: translateY(-10px) rotateX(5deg);
            box-shadow: 0 30px 80px rgba(0, 0, 0, 0.15);
        }

        .course-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .course-card:hover .course-image {
            transform: scale(1.05);
        }

        .course-content {
            padding: 1.5rem;
            background: linear-gradient(145deg, rgba(107, 70, 193, 0.1), rgba(139, 92, 246, 0.05));
            
        }

        .course-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 0.5rem;
            line-height: 1.4;
        }

        .course-meta {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
            font-size: 0.85rem;
            color: #666;
        }

        .course-meta span {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .report-info {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            padding: 1rem;
            margin: -1.5rem -1.5rem 1rem -1.5rem;
            position: relative;
        }

        .report-info::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 0;
            height: 0;
            border-left: 10px solid transparent;
            border-right: 10px solid transparent;
            border-top: 10px solid #ee5a24;
        }

        .report-reason {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .report-meta {
            font-size: 0.85rem;
            opacity: 0.9;
        }

        .course-stats {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 10px;
        }

        .stat {
            text-align: center;
        }

        .stat-value {
            font-weight: 700;
            color: #333;
        }

        .stat-label {
            font-size: 0.8rem;
            color: #666;
            margin-top: 0.25rem;
        }

        .course-actions {
            display: flex;
            gap: 0.5rem;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-none {
            background: #f8d7da;
            color: #721c24;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-reviewed {
            background: #d4edda;
            color: #155724;
        }

        .status-resolved {
            background: #d1ecf1;
            color: #0c5460;
        }

        .no-data {
            text-align: center;
            padding: 4rem;
            color: #666;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
        }

        .no-data i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.3;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 1rem;
            margin-top: 2rem;
        }

        .pagination a,
        .pagination span {
            padding: 1rem 1.5rem;
            text-decoration: none;
            border-radius: 15px;
            transition: all 0.3s ease;
            font-weight: 600;
        }

        .pagination a {
            color: #667eea;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .pagination a:hover {
            background: #667eea;
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.3);
        }

        .pagination .current {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.3);
        }

        .pagination .disabled {
            color: #ccc;
            background: rgba(255, 255, 255, 0.5);
            cursor: not-allowed;
        }

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

        .floating-action {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.3);
            cursor: pointer;
            transition: all 0.3s ease;
            animation: pulse 2s infinite;
        }

        .floating-action:hover {
            transform: scale(1.1);
            box-shadow: 0 20px 45px rgba(102, 126, 234, 0.4);
        }

        @keyframes pulse {
            0% { box-shadow: 0 15px 35px rgba(102, 126, 234, 0.3); }
            50% { box-shadow: 0 15px 35px rgba(102, 126, 234, 0.5); }
            100% { box-shadow: 0 15px 35px rgba(102, 126, 234, 0.3); }
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

            .search-form {
                flex-direction: column;
            }

            .form-group {
                margin-bottom: 1rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .courses-grid {
                grid-template-columns: 1fr;
            }

            .course-actions {
                flex-direction: column;
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
            }
        }
    </style>
    <script src="${pageContext.request.contextPath}/assests/js/universe-theme.js"></script>
</head>
<body class="universe-theme">
    <!-- Universe Background Layer -->
    <div class="universe-background"></div>
    
    <header class="header universe-header">
<<<<<<< HEAD
        <h1 class="universe-title"><i class="fas fa-flag"></i> Reported Groups Management - CourseHub E-Learning</h1>
        <div class="user-info"><span>Xin chào, Admin</span><i class="fas fa-user-circle"></i></div>
=======
        <h1 class="universe-title">
            <i class="fas fa-exclamation-triangle"></i>
            Reported Courses - CourseHub E-Learning
        </h1>
        <div class="user-info">
            <span>Xin chào, Admin</span>
            <i class="fas fa-user-circle"></i>
        </div>
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
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
<<<<<<< HEAD
                    <li><a href="/Adaptive_Elearning/admin_dashboard.jsp">
                        <i class="fas fa-tachometer-alt"></i> 
                        <span>Tổng quan</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_notification.jsp">
                        <i class="fas fa-bell"></i> 
=======
                    <li><a href="/adaptive_elearning/admin_dashboard.jsp">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Tổng quan</span>
                    </a></li>
                    <li><a href="/adaptive_elearning/admin_notification.jsp">
                        <i class="fas fa-bell"></i>
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
                        <span>Thông báo</span>
                    </a></li>
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">User Management</div>
                <ul>
<<<<<<< HEAD
                    <li><a href="/Adaptive_Elearning/admin_createadmin.jsp">
                        <i class="fas fa-user-plus"></i> 
                        <span>Tạo Admin</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_accountmanagement.jsp">
                        <i class="fas fa-users"></i> 
=======
                    <li><a href="/adaptive_elearning/admin_createadmin.jsp">
                        <i class="fas fa-user-plus"></i>
                        <span>Tạo Admin</span>
                    </a></li>
                    <li><a href="/adaptive_elearning/admin_accountmanagement.jsp">
                        <i class="fas fa-users"></i>
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
                        <span>Quản lý Tài Khoản</span>
                    </a></li>
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">Content Management</div>
                <ul>
<<<<<<< HEAD
                    <li><a href="/Adaptive_Elearning/admin_coursemanagement.jsp">
                        <i class="fa-solid fa-bars-progress"></i> 
                        <span>Các Khóa Học</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_reportedcourse.jsp">
                        <i class="fas fa-flag"></i> 
                        <span>Khóa Học Báo Cáo</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_reportedgroup.jsp" class="active">
                        <i class="fas fa-users-slash"></i> 
                        <span>Nhóm Báo Cáo</span>
=======
                    <li><a href="/adaptive_elearning/admin_coursemanagement.jsp">
                        <i class="fa-solid fa-bars-progress"></i>
                        <span>Các Khóa Học</span>
                    </a></li>
                    <li><a href="/adaptive_elearning/admin_reportedcourse.jsp" class="active">
                        <i class="fas fa-flag"></i>
                        <span>Quản lý Khóa Học</span>
                    </a></li>
                    <li><a href="/adaptive_elearning/admin_reportedgroup.jsp">
                        <i class="fas fa-user-graduate"></i>
                        <span>Quản lý Nhóm</span>
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
                    </a></li>
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">System</div>
                <ul>
                    <li><a href="#">
<<<<<<< HEAD
                        <i class="fas fa-chart-bar"></i> 
                        <span>Analytics</span>
                    </a></li>
                    <li><a href="#">
                        <i class="fas fa-cog"></i> 
                        <span>Settings</span>
                    </a></li>
                    <li><a href="#">
                        <i class="fas fa-sign-out-alt"></i> 
                        <span>Đăng xuất</span>
=======
                        <i class="fas fa-chart-bar"></i>
                        <span>Home</span>
                    </a></li>
                    <li><a href="#">
                        <i class="fas fa-cog"></i>
                        <span>LogOut</span>
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
                    </a></li>
                </ul>
            </div>
        </nav>

<<<<<<< HEAD
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

=======
        <main class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fas fa-flag"></i> Quản lý khóa học bị báo cáo</h2>
           
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
                    <div class="stat-icon reports">
                        <i class="fas fa-flag"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= totalReports %></h3>
                        <p>Tổng số báo cáo</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon recent">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= recentReports %></h3>
                        <p>Báo cáo trong 7 ngày</p>
                    </div>
                </div>
                
                <% 
                int pendingReports = statusStats.containsKey("None") ? statusStats.get("None") : 0;
                int resolvedReports = statusStats.containsKey("Resolved") ? statusStats.get("Resolved") : 0;
                %>
                
                <div class="stat-card">
                    <div class="stat-icon pending">
                        <i class="fas fa-hourglass-half"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= pendingReports %></h3>
                        <p>Chờ xử lý</p>
                    </div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon resolved">
                        <i class="fas fa-check-double"></i>
                    </div>
                    <div class="stat-info">
                        <h3><%= resolvedReports %></h3>
                        <p>Đã xử lý</p>
                    </div>
                </div>
            </div>

            <!-- Search Section -->
            <div class="search-section">
                <form class="filters" method="GET" action="/adaptive_elearning/admin_reportedcourse.jsp">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" name="searchTerm" placeholder="Tìm kiếm khóa học..." 
                               value="<%= request.getParameter("searchTerm") != null ? request.getParameter("searchTerm") : "" %>">
                    </div>
                    <div class="entries-select">
                        <label>Hiển thị:</label>
                        <select name="entries" onchange="updateEntries()">
                            <option value="4" <%= recordsPerPage == 4 ? "selected" : "" %>>4 khóa học</option>
                            <option value="8" <%= recordsPerPage == 8 ? "selected" : "" %>>8 khóa học</option>
                            <option value="12" <%= recordsPerPage == 12 ? "selected" : "" %>>12 khóa học</option>
                            <option value="16" <%= recordsPerPage == 16 ? "selected" : "" %>>16 khóa học</option>
                        </select>
                    </div>
                    <div class="entries-select">
                        <label>Trạng thái:</label>
                        <select name="status" id="status">
                            <option value="">Tất cả</option>
                            <% for (String status : reportStatuses) { %>
                                <option value="<%= status %>" <%= searchStatus.equals(status) ? "selected" : "" %>>
                                    <%= "None".equals(status) ? "Chờ xử lý" : status %>
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

            <!-- Reported Courses Grid -->
            <% if (reportedCourses.isEmpty()) { %>
                <div class="no-data">
                    <i class="fas fa-flag"></i>
                    <h3>Không có khóa học bị báo cáo nào</h3>
                    <p>Hệ thống hiện tại không có báo cáo nào về khóa học</p>
                </div>
            <% } else { %>
                <div class="courses-grid">
                    <% for (Map<String, Object> report : reportedCourses) { 
                        String statusClass = "status-none";
                        String statusText = "Chờ xử lý";
                        String reportStatus = (String) report.get("reportStatus");
                        
                        if ("Pending".equals(reportStatus)) {
                            statusClass = "status-pending";
                            statusText = "Đang xử lý";
                        } else if ("Reviewed".equals(reportStatus)) {
                            statusClass = "status-reviewed";
                            statusText = "Đã xem xét";
                        } else if ("Resolved".equals(reportStatus)) {
                            statusClass = "status-resolved";
                            statusText = "Đã xử lý";
                        }
                        
                        String courseThumb = (String) report.get("courseThumb");
                        if (courseThumb == null || courseThumb.trim().isEmpty()) {
                            courseThumb = "https://via.placeholder.com/350x200?text=No+Image";
                        }
                    %>
                    <div class="course-card">
                        <img src="<%= courseThumb %>" alt="Course Image" class="course-image" onerror="this.src='https://via.placeholder.com/350x200?text=No+Image'">
                        
                        <div class="report-info">
                            <div class="report-reason">
                                <i class="fas fa-exclamation-circle"></i>
                                <%= report.get("reportReason") %>
                            </div>
                            <div class="report-meta">
                                Báo cáo bởi: <%= report.get("reporterName") != null ? report.get("reporterName") : "Anonymous" %> | 
                                <%= dateFormat.format(report.get("reportTime")) %>
                            </div>
                        </div>
                        
                        <div class="course-content">
                            <h3 class="course-title"><%= report.get("courseTitle") %></h3>
                            
                            <div class="course-meta">
                                <span><i class="fas fa-user"></i> <%= report.get("instructorName") %></span>
                                <span><i class="fas fa-level-up-alt"></i> <%= report.get("courseLevel") %></span>
                                <span class="status-badge <%= statusClass %>"><%= statusText %></span>
                            </div>
                            
                            <div class="course-stats">
                                <div class="stat">
                                    <div class="stat-value"><%= report.get("learnerCount") %></div>
                                    <div class="stat-label">Học viên</div>
                                </div>
                                <div class="stat">
                                    <div class="stat-value">
                                        <%= String.format("%.1f", (Double) report.get("averageRating")) %>★
                                    </div>
                                    <div class="stat-label">Đánh giá</div>
                                </div>
                                <div class="stat">
                                    <div class="stat-value">
                                        <%= currencyFormat.format((Double) report.get("coursePrice")) %>
                                    </div>
                                    <div class="stat-label">Giá</div>
                                </div>
                            </div>
                            
                            <div class="course-actions">
                                <% String notificationId = (String) report.get("notificationId"); %>
                                <% String courseId = (String) report.get("courseId"); %>
                                
                                <button class="btn btn-warning btn-sm" onclick="updateStatus('<%= notificationId %>', '<%= reportStatus %>')">
                                    <i class="fas fa-edit"></i> Cập nhật trạng thái
                                </button>
                                
                                <% if (!"Suspended".equals(report.get("courseStatus"))) { %>
                                    <button class="btn btn-danger btn-sm" onclick="suspendCourse('<%= courseId %>')">
                                        <i class="fas fa-ban"></i> Đình chỉ khóa học
                                    </button>
                                <% } else { %>
                                    <span class="btn btn-sm" style="background: #6c757d; color: white;">
                                        <i class="fas fa-ban"></i> Đã đình chỉ
                                    </span>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } %>

            <!-- Pagination -->
            <% if (totalPages > 1) { %>
                <div class="pagination">
                    <% if (currentPage > 1) { %>
                        <a href="?page=<%= currentPage - 1 %>&status=<%= searchStatus %>&entries=<%= recordsPerPage %>">
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
                            <a href="?page=<%= i %>&status=<%= searchStatus %>&entries=<%= recordsPerPage %>"><%= i %></a>
                        <% } %>
                    <% } %>

                    <% if (currentPage < totalPages) { %>
                        <a href="?page=<%= currentPage + 1 %>&status=<%= searchStatus %>&entries=<%= recordsPerPage %>">
                            Next <i class="fas fa-chevron-right"></i>
                        </a>
                    <% } else { %>
                        <span class="disabled">
                            Next <i class="fas fa-chevron-right"></i>
                        </span>
                    <% } %>
                </div>
            <% } %>
        </main>
    </div>

    <!-- Floating Action Button -->
    <div class="floating-action" onclick="scrollToTop()" title="Scroll to top">
        <i class="fas fa-arrow-up"></i>
    </div>

    <script>
        function updateStatus(notificationId, currentStatus) {
            const statuses = ['None', 'Pending', 'Reviewed', 'Resolved'];
            const statusNames = ['Chờ xử lý', 'Đang xử lý', 'Đã xem xét', 'Đã xử lý'];
            
            let options = '';
            for (let i = 0; i < statuses.length; i++) {
                options += (i + 1) + '. ' + statusNames[i] + '\n';
            }
            
            const newStatus = prompt('Chọn trạng thái mới:\n' + options + '\nNhập số (1-4):', '2');
            
            if (newStatus && newStatus >= '1' && newStatus <= '4') {
                const statusIndex = parseInt(newStatus) - 1;
                const selectedStatus = statuses[statusIndex];
                
                if (confirm(`Bạn có chắc chắn muốn thay đổi trạng thái thành "${statusNames[statusIndex]}"?`)) {
                    // Create form to submit POST request
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '/adaptive_elearning/admin_reportedcourse.jsp';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'updateStatus';
                    
                    const notificationIdInput = document.createElement('input');
                    notificationIdInput.type = 'hidden';
                    notificationIdInput.name = 'notificationId';
                    notificationIdInput.value = notificationId;
                    
                    const statusInput = document.createElement('input');
                    statusInput.type = 'hidden';
                    statusInput.name = 'newStatus';
                    statusInput.value = selectedStatus;
                    
                    form.appendChild(actionInput);
                    form.appendChild(notificationIdInput);
                    form.appendChild(statusInput);
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            }
        }
        
        function suspendCourse(courseId) {
            if (confirm('Bạn có chắc chắn muốn đình chỉ khóa học này? Khóa học sẽ không còn khả dụng cho học viên.')) {
                // Create form to submit POST request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '/adaptive_elearning/admin_reportedcourse.jsp';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'suspendCourse';
                
                const courseIdInput = document.createElement('input');
                courseIdInput.type = 'hidden';
                courseIdInput.name = 'courseId';
                courseIdInput.value = courseId;
                
                form.appendChild(actionInput);
                form.appendChild(courseIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
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
<<<<<<< HEAD
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
=======
                    // Create ripple effect
                    const ripple = document.createElement('div');
                    ripple.style.position = 'absolute';
                    ripple.style.borderRadius = '50%';
                    ripple.style.background = 'rgba(139, 92, 246, 0.3)';
                    ripple.style.transform = 'scale(0)';
                    ripple.style.animation = 'ripple 0.6s linear';
                    ripple.style.pointerEvents = 'none';
                    
                    const rect = this.getBoundingClientRect();
                    const size = Math.max(rect.width, rect.height);
                    ripple.style.width = ripple.style.height = size + 'px';
                    ripple.style.left = (rect.width / 2 - size / 2) + 'px';
                    ripple.style.top = (rect.height / 2 - size / 2) + 'px';
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
                    
                    this.style.position = 'relative';
                    this.appendChild(ripple);
                    
<<<<<<< HEAD
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
                    
=======
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
                    setTimeout(() => ripple.remove(), 600);
                });

                // Add click animation
                link.addEventListener('click', function(e) {
<<<<<<< HEAD
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
=======
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
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
                    
                    this.appendChild(clickRipple);
                    setTimeout(() => clickRipple.remove(), 300);
                });
            });

            // Add CSS animations
            const style = document.createElement('style');
            style.textContent = `
                @keyframes ripple {
                    to {
<<<<<<< HEAD
                        transform: scale(1);
=======
                        transform: scale(2);
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
                        opacity: 0;
                    }
                }
                
                @keyframes click-ripple {
                    to {
<<<<<<< HEAD
                        transform: scale(1.2);
=======
                        transform: scale(3);
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
                        opacity: 0;
                    }
                }
                
                @keyframes float-particle {
<<<<<<< HEAD
                    0% {
                        transform: translateY(0px) scale(1);
                        opacity: 1;
                    }
                    100% {
                        transform: translateY(-20px) scale(0);
                        opacity: 0;
=======
                    0%, 100% {
                        transform: translateY(0px) rotate(0deg);
                        opacity: 1;
                    }
                    50% {
                        transform: translateY(-20px) rotate(180deg);
                        opacity: 0.8;
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
                    }
                }
                
                .nav-group {
<<<<<<< HEAD
                    animation: slideInLeft 0.6s ease-out;
=======
                    animation: slideInLeft 0.5s ease-out forwards;
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
                }
                
                .nav-group:nth-child(2) { animation-delay: 0.1s; }
                .nav-group:nth-child(3) { animation-delay: 0.2s; }
                .nav-group:nth-child(4) { animation-delay: 0.3s; }
                .nav-group:nth-child(5) { animation-delay: 0.4s; }
                
                @keyframes slideInLeft {
                    from {
<<<<<<< HEAD
                        transform: translateX(-30px);
                        opacity: 0;
                    }
                    to {
                        transform: translateX(0);
                        opacity: 1;
=======
                        opacity: 0;
                        transform: translateX(-30px);
                    }
                    to {
                        opacity: 1;
                        transform: translateX(0);
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
                    }
                }
            `;
            document.head.appendChild(style);

            // Add universe glow effects to interactive elements
<<<<<<< HEAD
            const interactiveElements = document.querySelectorAll('button, .stat-card, .content-card, .search-box');
=======
            const interactiveElements = document.querySelectorAll('button, .stat-card, .search-section, .search-box');
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
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

<<<<<<< HEAD
            // Enhanced table row hover effects
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.background = 'linear-gradient(90deg, rgba(139, 92, 246, 0.2), rgba(107, 70, 193, 0.1))';
                    this.style.boxShadow = '0 0 20px rgba(139, 92, 246, 0.3)';
                });
                row.addEventListener('mouseleave', function() {
                    this.style.background = '';
=======
            // Enhanced course card hover effects
            const courseCards = document.querySelectorAll('.course-card');
            courseCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-10px) scale(1.02)';
                    this.style.boxShadow = '0 0 30px rgba(139, 92, 246, 0.3)';
                });
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
                    this.style.boxShadow = '';
                });
            });
        });
<<<<<<< HEAD
=======

        function updateStatus(notificationId, currentStatus) {
            const statuses = ['None', 'Pending', 'Reviewed', 'Resolved'];
            const statusNames = ['Chờ xử lý', 'Đang xử lý', 'Đã xem xét', 'Đã xử lý'];
            
            let options = '';
            for (let i = 0; i < statuses.length; i++) {
                options += (i + 1) + '. ' + statusNames[i] + '\n';
            }
            
            const newStatus = prompt('Chọn trạng thái mới:\n' + options + '\nNhập số (1-4):', '2');
            
            if (newStatus && newStatus >= '1' && newStatus <= '4') {
                const statusIndex = parseInt(newStatus) - 1;
                const selectedStatus = statuses[statusIndex];
                
                if (confirm(`Bạn có chắc chắn muốn thay đổi trạng thái thành "${statusNames[statusIndex]}"?`)) {
                    // Create form to submit POST request
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '/adaptive_elearning/admin_reportedcourse.jsp';
                    
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'updateStatus';
                    
                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'notificationId';
                    idInput.value = notificationId;
                    
                    const statusInput = document.createElement('input');
                    statusInput.type = 'hidden';
                    statusInput.name = 'newStatus';
                    statusInput.value = selectedStatus;
                    
                    form.appendChild(actionInput);
                    form.appendChild(idInput);
                    form.appendChild(statusInput);
                    
                    document.body.appendChild(form);
                    form.submit();
                }
            }
        }
        
        function suspendCourse(courseId) {
            if (confirm('Bạn có chắc chắn muốn đình chỉ khóa học này? Khóa học sẽ không còn khả dụng cho học viên.')) {
                // Create form to submit POST request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '/adaptive_elearning/admin_reportedcourse.jsp';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'suspendCourse';
                
                const courseIdInput = document.createElement('input');
                courseIdInput.type = 'hidden';
                courseIdInput.name = 'courseId';
                courseIdInput.value = courseId;
                
                form.appendChild(actionInput);
                form.appendChild(courseIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function updateEntries() {
            const entriesSelect = document.getElementById('entries');
            const statusSelect = document.getElementById('status');
            const selectedEntries = entriesSelect.value;
            const selectedStatus = statusSelect.value;
            
            // Redirect with new entries parameter
            const url = '/adaptive_elearning/admin_reportedcourse.jsp?page=1&entries=' + selectedEntries + '&status=' + encodeURIComponent(selectedStatus);
            window.location.href = url;
        }
        
        function scrollToTop() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }
        
        // Auto-hide alerts
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
    </script>
</body>
</html>