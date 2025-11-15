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
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reported Courses - CourseHub E-Learning</title>
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
            gap: 0.75rem;
            color: #F8FAFC;
        }

        .entries-select select {
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
        }

        .entries-select select:focus {
            outline: none;
            border-color: #8B5CF6;
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
            <i class="fas fa-exclamation-triangle"></i>
            Reported Courses - CourseHub E-Learning
        </h1>
        <div class="user-info">
            <span>Xin chào, Admin</span>
            <i class="fas fa-user-circle"></i>
        </div>
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
                        <span>Các Khóa Học</span>
                    </a></li>
                    <li><a href="/Adaptive_Elearning/admin_reportedcourse.jsp" class="active">
                        <i class="fas fa-flag"></i>
                        <span>Quản lý Khóa Học</span>
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
                    <li><a href="#">
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
                <form class="filters" method="GET" action="/Adaptive_Elearning/admin_reportedcourse.jsp">
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
                    form.action = '/Adaptive_Elearning/admin_reportedcourse.jsp';
                    
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
                form.action = '/Adaptive_Elearning/admin_reportedcourse.jsp';
                
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
                        transform: scale(2);
                        opacity: 0;
                    }
                }
                
                @keyframes click-ripple {
                    to {
                        transform: scale(3);
                        opacity: 0;
                    }
                }
                
                @keyframes float-particle {
                    0%, 100% {
                        transform: translateY(0px) rotate(0deg);
                        opacity: 1;
                    }
                    50% {
                        transform: translateY(-20px) rotate(180deg);
                        opacity: 0.8;
                    }
                }
                
                .nav-group {
                    animation: slideInLeft 0.5s ease-out forwards;
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
            const interactiveElements = document.querySelectorAll('button, .stat-card, .search-section, .search-box');
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
                    form.action = '/Adaptive_Elearning/admin_reportedcourse.jsp';
                    
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
                form.action = '/Adaptive_Elearning/admin_reportedcourse.jsp';
                
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
            const url = '/Adaptive_Elearning/admin_reportedcourse.jsp?page=1&entries=' + selectedEntries + '&status=' + encodeURIComponent(selectedStatus);
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
    </script>
</body>
</html>