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
            border-radius: 20px;
            margin-bottom: 2rem;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(102, 126, 234, 0.1) 0%, transparent 70%);
            animation: rotate 20s linear infinite;
        }

        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .page-header h2 {
            color: #333;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            position: relative;
            z-index: 2;
        }

        .page-header p {
            position: relative;
            z-index: 2;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            padding: 2rem;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            display: flex;
            align-items: center;
            gap: 1.5rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            transition: left 0.5s;
        }

        .stat-card:hover::before {
            left: 100%;
        }

        .stat-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 30px 80px rgba(0, 0, 0, 0.15);
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
        }

        .stat-icon.reports { background: linear-gradient(135deg, #ff6b6b, #ee5a24); }
        .stat-icon.recent { background: linear-gradient(135deg, #4ecdc4, #44bd87); }
        .stat-icon.pending { background: linear-gradient(135deg, #feca57, #ff9ff3); }
        .stat-icon.resolved { background: linear-gradient(135deg, #48dbfb, #0abde3); }

        .stat-info {
            position: relative;
            z-index: 2;
        }

        .stat-info h3 {
            color: #333;
            font-size: 2rem;
            margin-bottom: 0.25rem;
            font-weight: 700;
        }

        .stat-info p {
            color: #666;
            font-size: 0.9rem;
        }

        .search-section {
            background: rgba(255, 255, 255, 0.95);
            padding: 2rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
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
            color: #333;
        }

        .form-group select {
            width: 100%;
            padding: 1rem;
            border: 2px solid #e1e5e9;
            border-radius: 15px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
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
            background: linear-gradient(135deg, #ffc107, #ffca2c);
            color: white;
            font-weight: 600;
        }

        .status-reviewed {
            background: #d4edda;
            color: #155724;
        }

        .status-resolved {
            background: linear-gradient(135deg, #28a745, #34ce57);
            color: white;
            font-weight: 600;
        }

        .status-under-review {
            background: linear-gradient(135deg, #17a2b8, #20c4dc);
            color: white;
            font-weight: 600;
        }

        .status-dismissed {
            background: linear-gradient(135deg, #dc3545, #e94767);
            color: white;
            font-weight: 600;
        }

        /* Add smooth transitions for status badge updates */
        .status-badge {
            transition: all 0.3s ease;
        }

        .course-card {
            transition: all 0.5s ease;
        }

        /* Update notification styles */
        .update-notification {
            position: fixed;
            top: 20px;
            right: 20px;
            background: linear-gradient(135deg, #28a745, #34ce57);
            color: white;
            padding: 15px 20px;
            border-radius: 12px;
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.3);
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            font-size: 14px;
            z-index: 10001;
            transform: translateX(400px);
            opacity: 0;
            transition: all 0.3s ease;
        }

        .update-notification.show {
            transform: translateX(0);
            opacity: 1;
        }

        .update-notification i {
            font-size: 18px;
        }

        @media (max-width: 768px) {
            .update-notification {
                right: 10px;
                left: 10px;
                transform: translateY(-100px);
            }
            
            .update-notification.show {
                transform: translateY(0);
            }
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

        /* Custom Modal Styles */
        .custom-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(5px);
            z-index: 10000;
            opacity: 0;
            transition: all 0.3s ease;
        }

        .custom-modal.active {
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 1;
        }

        .modal-content {
            background: white;
            border-radius: 20px;
            box-shadow: 0 25px 80px rgba(0, 0, 0, 0.3);
            max-width: 600px;
            width: 90%;
            max-height: 90vh;
            overflow: hidden;
            transform: scale(0.9) translateY(-30px);
            transition: all 0.3s ease;
        }

        .custom-modal.active .modal-content {
            transform: scale(1) translateY(0);
        }

        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h3 {
            margin: 0;
            font-size: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .modal-close {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
            padding: 5px;
            border-radius: 50%;
            transition: all 0.2s ease;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-close:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: rotate(90deg);
        }

        .modal-body {
            padding: 25px;
            max-height: 60vh;
            overflow-y: auto;
        }

        .status-form .form-group {
            margin-bottom: 25px;
        }

        .status-form label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .current-report-info,
        .current-status {
            background: #f8f9fa;
            padding: 12px 15px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }

        .status-badge {
            background: #6c757d;
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-badge.pending { 
            background: linear-gradient(135deg, #ffc107, #ffca2c); 
            color: white; 
            font-weight: 600;
        }
        .status-badge.under-review { 
            background: linear-gradient(135deg, #17a2b8, #20c4dc); 
            color: white; 
            font-weight: 600;
        }
        .status-badge.resolved { 
            background: linear-gradient(135deg, #28a745, #34ce57); 
            color: white; 
            font-weight: 600;
        }
        .status-badge.dismissed { 
            background: linear-gradient(135deg, #dc3545, #e94767); 
            color: white; 
            font-weight: 600;
        }

        .status-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 15px;
            margin-top: 10px;
        }

        .status-option {
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .status-card {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 20px 15px;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .status-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, transparent 0%, rgba(255,255,255,0.1) 100%);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .status-card:hover::before {
            opacity: 1;
        }

        .status-card i {
            font-size: 24px;
            margin-bottom: 8px;
            display: block;
        }

        .status-card span {
            font-weight: 600;
            font-size: 14px;
            display: block;
            margin-bottom: 5px;
        }

        .status-card p {
            font-size: 11px;
            color: #666;
            margin: 0;
            line-height: 1.3;
        }

        .status-card.pending { border-color: #ffc107; }
        .status-card.pending i { color: #ffc107; }
        .status-card.under-review { border-color: #17a2b8; }
        .status-card.under-review i { color: #17a2b8; }
        .status-card.resolved { border-color: #28a745; }
        .status-card.resolved i { color: #28a745; }
        .status-card.dismissed { border-color: #dc3545; }
        .status-card.dismissed i { color: #dc3545; }

        .status-option:hover .status-card {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .status-option.selected .status-card {
            border-width: 3px;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }

        .status-option.selected .status-card.pending {
            background: linear-gradient(135deg, #ffc107, #ffca2c);
            color: white;
        }

        .status-option.selected .status-card.under-review {
            background: linear-gradient(135deg, #17a2b8, #20c4dc);
            color: white;
        }

        .status-option.selected .status-card.resolved {
            background: linear-gradient(135deg, #28a745, #34ce57);
            color: white;
        }

        .status-option.selected .status-card.dismissed {
            background: linear-gradient(135deg, #dc3545, #e94767);
            color: white;
        }

        .status-option.selected .status-card i,
        .status-option.selected .status-card span {
            color: white !important;
        }

        .status-option.selected .status-card p {
            color: rgba(255,255,255,0.9) !important;
        }

        #statusNote {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-family: inherit;
            font-size: 14px;
            resize: vertical;
            transition: border-color 0.2s ease;
        }

        #statusNote:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .modal-footer {
            background: #f8f9fa;
            padding: 20px 25px;
            display: flex;
            gap: 15px;
            justify-content: flex-end;
        }

        .modal-footer .btn {
            padding: 12px 20px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s ease;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .modal-footer .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .modal-footer .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }

        .modal-footer .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .modal-footer .btn-primary:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .modal-footer .btn-primary:disabled {
            background: #6c757d;
            cursor: not-allowed;
        }

        @media (max-width: 768px) {
            .modal-content {
                width: 95%;
                margin: 20px;
            }

            .status-options {
                grid-template-columns: repeat(2, 1fr);
            }

            .modal-footer {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <h1>
            <i class="fas fa-exclamation-triangle"></i>
            Reported Courses - CourseHub E-Learning
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
                <li><a href="/adaptive_elearning/admin_createadmin.jsp"><i class="fas fa-user-plus"></i> Tạo Admin</a></li>
                <li><a href="/adaptive_elearning/admin_accountmanagement.jsp"><i class="fas fa-users"></i> Quản lý Tài Khoản</a></li>
                <li><a href="/adaptive_elearning/admin_reportedcourse.jsp" class="active"><i class="fas fa-flag"></i> Quản lý Khóa Học</a></li>
               <li><a href="/adaptive_elearning/admin_coursemanagement.jsp"><i class="fa-solid fa-bars-progress"></i> Các Khóa Học</a></li>
                <li><a href="/adaptive_elearning/admin_reportedgroup.jsp"><i class="fas fa-user-graduate"></i> Quản lý Nhóm</a></li>
                <li><a href="#"><i class="fas fa-chart-bar"></i> Home</a></li>
                <li><a href="#"><i class="fas fa-cog"></i> LogOut</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fas fa-flag"></i> Quản lý khóa học bị báo cáo</h2>
                <p>Theo dõi và xử lý các báo cáo về khóa học có vấn đề trong hệ thống</p>
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
                <form class="search-form" method="GET" action="/adaptive_elearning/admin_reportedcourse.jsp">
                    <div class="form-group">
                        <label for="entries">Hiển thị:</label>
                        <select name="entries" id="entries" onchange="updateEntries()">
                            <option value="4" <%= recordsPerPage == 4 ? "selected" : "" %>>4 khóa học</option>
                            <option value="8" <%= recordsPerPage == 8 ? "selected" : "" %>>8 khóa học</option>
                            <option value="12" <%= recordsPerPage == 12 ? "selected" : "" %>>12 khóa học</option>
                            <option value="16" <%= recordsPerPage == 16 ? "selected" : "" %>>16 khóa học</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="status">Lọc theo trạng thái:</label>
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
                        String statusClass = "status-pending";
                        String statusText = "Đang chờ";
                        String reportStatus = (String) report.get("reportStatus");
                        
                        // Map status values to match the modal form options
                        if ("Pending".equals(reportStatus)) {
                            statusClass = "status-pending";
                            statusText = "Đang chờ";
                        } else if ("Under Review".equals(reportStatus)) {
                            statusClass = "status-under-review";
                            statusText = "Đang xem xét";
                        } else if ("Resolved".equals(reportStatus)) {
                            statusClass = "status-resolved";
                            statusText = "Đã xử lý";
                        } else if ("Dismissed".equals(reportStatus)) {
                            statusClass = "status-dismissed";
                            statusText = "Đã từ chối";
                        } else {
                            // Default for any other status
                            statusClass = "status-pending";
                            statusText = reportStatus != null ? reportStatus : "Đang chờ";
                        }
                        
                        String courseThumb = (String) report.get("courseThumb");
                        if (courseThumb == null || courseThumb.trim().isEmpty()) {
                            courseThumb = "https://via.placeholder.com/350x200?text=No+Image";
                        }
                    %>
                    <div class="course-card" data-notification-id="<%= report.get("notificationId") %>">
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
        // Global variables for modal
        let currentNotificationId = '';
        let selectedStatus = '';

        function updateStatus(notificationId, currentStatus) {
            // Store current data
            currentNotificationId = notificationId;
            
            // Update modal content
            document.getElementById('currentReportId').textContent = notificationId;
            
            // Set current status badge
            const currentStatusDisplay = document.getElementById('currentStatusDisplay');
            currentStatusDisplay.textContent = getStatusDisplayName(currentStatus);
            currentStatusDisplay.className = 'status-badge ' + getStatusClass(currentStatus);
            
            // Reset selections
            selectedStatus = '';
            document.querySelectorAll('.status-option').forEach(option => {
                option.classList.remove('selected');
            });
            document.getElementById('confirmUpdateBtn').disabled = true;
            document.getElementById('statusNote').value = '';
            
            // Show modal
            const modal = document.getElementById('statusUpdateModal');
            modal.style.display = 'flex';
            setTimeout(() => {
                modal.classList.add('active');
            }, 10);
        }

        function getStatusDisplayName(status) {
            const statusNames = {
                'Pending': 'Đang chờ',
                'Under Review': 'Đang xem xét', 
                'Resolved': 'Đã xử lý',
                'Dismissed': 'Đã từ chối'
            };
            return statusNames[status] || status;
        }

        function getStatusClass(status) {
            const statusClasses = {
                'Pending': 'pending',
                'Under Review': 'under-review',
                'Resolved': 'resolved', 
                'Dismissed': 'dismissed'
            };
            return statusClasses[status] || '';
        }

        function closeStatusModal() {
            const modal = document.getElementById('statusUpdateModal');
            modal.classList.remove('active');
            setTimeout(() => {
                modal.style.display = 'none';
            }, 300);
        }

        function confirmStatusUpdate() {
            if (!selectedStatus) return;
            
            // Show loading state
            const confirmBtn = document.getElementById('confirmUpdateBtn');
            const originalText = confirmBtn.innerHTML;
            confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang cập nhật...';
            confirmBtn.disabled = true;
            
            const statusNote = document.getElementById('statusNote').value;
            
            // Update status badge immediately for better UX
            updateStatusBadgeVisually(currentNotificationId, selectedStatus);
            
            // Create form to submit POST request with cache-busting
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/adaptive_elearning/admin_reportedcourse.jsp?_t=' + Date.now();
            
            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'updateStatus';
            
            const notificationIdInput = document.createElement('input');
            notificationIdInput.type = 'hidden';
            notificationIdInput.name = 'notificationId';
            notificationIdInput.value = currentNotificationId;
            
            const statusInput = document.createElement('input');
            statusInput.type = 'hidden';
            statusInput.name = 'newStatus';
            statusInput.value = selectedStatus;
            
            // Add cache buster
            const timestampInput = document.createElement('input');
            timestampInput.type = 'hidden';
            timestampInput.name = '_t';
            timestampInput.value = Date.now();
            
            // Add note if provided
            if (statusNote.trim()) {
                const noteInput = document.createElement('input');
                noteInput.type = 'hidden';
                noteInput.name = 'statusNote';
                noteInput.value = statusNote;
                form.appendChild(noteInput);
            }
            
            form.appendChild(actionInput);
            form.appendChild(notificationIdInput);
            form.appendChild(statusInput);
            form.appendChild(timestampInput);
            
            document.body.appendChild(form);
            
            // Close modal first
            closeStatusModal();
            
            // Submit form in background
            setTimeout(() => {
                form.submit();
            }, 500);
        }

        function updateStatusBadgeVisually(notificationId, newStatus) {
            // Find the course card with matching notification ID
            const targetCard = document.querySelector(`[data-notification-id="${notificationId}"]`);
            
            if (targetCard) {
                const statusBadge = targetCard.querySelector('.status-badge');
                if (statusBadge) {
                    // Remove old status classes
                    statusBadge.className = 'status-badge';
                    
                    // Get new status info
                    const statusInfo = getStatusInfo(newStatus);
                    
                    // Update classes and text with animation
                    statusBadge.classList.add(statusInfo.class);
                    statusBadge.textContent = statusInfo.text;
                    
                    // Add highlight effect to badge
                    statusBadge.style.transform = 'scale(1.2)';
                    statusBadge.style.transition = 'all 0.3s ease';
                    
                    setTimeout(() => {
                        statusBadge.style.transform = 'scale(1)';
                    }, 300);
                    
                    // Highlight the entire card briefly with pulse effect
                    targetCard.style.boxShadow = '0 0 25px rgba(102, 126, 234, 0.4)';
                    targetCard.style.transform = 'translateY(-2px)';
                    
                    setTimeout(() => {
                        targetCard.style.boxShadow = '0 20px 60px rgba(0, 0, 0, 0.1)';
                        targetCard.style.transform = 'translateY(0)';
                    }, 1200);
                    
                    // Show success notification
                    showUpdateNotification('Cập nhật trạng thái thành công!');
                }
            }
        }

        function showUpdateNotification(message) {
            // Create notification element
            const notification = document.createElement('div');
            notification.className = 'update-notification';
            notification.innerHTML = `
                <i class="fas fa-check-circle"></i>
                <span>${message}</span>
            `;
            
            // Add to document
            document.body.appendChild(notification);
            
            // Show with animation
            setTimeout(() => {
                notification.classList.add('show');
            }, 100);
            
            // Remove after 3 seconds
            setTimeout(() => {
                notification.classList.remove('show');
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }, 3000);
        }

        function getStatusInfo(status) {
            const statusMap = {
                'Pending': {
                    class: 'status-pending',
                    text: 'Đang chờ'
                },
                'Under Review': {
                    class: 'status-under-review', 
                    text: 'Đang xem xét'
                },
                'Resolved': {
                    class: 'status-resolved',
                    text: 'Đã xử lý'
                },
                'Dismissed': {
                    class: 'status-dismissed',
                    text: 'Đã từ chối'
                }
            };
            
            return statusMap[status] || {
                class: 'status-pending',
                text: 'Đang chờ'
            };
        }

        // Handle status option selection
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.status-option').forEach(option => {
                option.addEventListener('click', function() {
                    // Remove previous selection
                    document.querySelectorAll('.status-option').forEach(opt => {
                        opt.classList.remove('selected');
                    });
                    
                    // Add selection to clicked option
                    this.classList.add('selected');
                    selectedStatus = this.dataset.status;
                    
                    // Enable confirm button
                    document.getElementById('confirmUpdateBtn').disabled = false;
                });
            });

            // Close modal when clicking outside
            document.getElementById('statusUpdateModal').addEventListener('click', function(e) {
                if (e.target === this) {
                    closeStatusModal();
                }
            });

            // Close modal with Escape key
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    closeStatusModal();
                }
            });
        });
        
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
    </script>

    <!-- Custom Status Update Modal -->
    <div id="statusUpdateModal" class="custom-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-edit"></i> Thay đổi trạng thái báo cáo</h3>
                <button class="modal-close" onclick="closeStatusModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="status-form">
                    <div class="form-group">
                        <label>Báo cáo hiện tại:</label>
                        <div class="current-report-info">
                            <span id="currentReportId">--</span>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Trạng thái hiện tại:</label>
                        <div class="current-status">
                            <span id="currentStatusDisplay" class="status-badge">--</span>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Chọn trạng thái mới:</label>
                        <div class="status-options">
                            <div class="status-option" data-status="Pending">
                                <div class="status-card pending">
                                    <i class="fas fa-clock"></i>
                                    <span>Đang chờ</span>
                                    <p>Báo cáo đang được xem xét</p>
                                </div>
                            </div>
                            <div class="status-option" data-status="Under Review">
                                <div class="status-card under-review">
                                    <i class="fas fa-search"></i>
                                    <span>Đang xem xét</span>
                                    <p>Đang điều tra báo cáo</p>
                                </div>
                            </div>
                            <div class="status-option" data-status="Resolved">
                                <div class="status-card resolved">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Đã xử lý</span>
                                    <p>Báo cáo đã được giải quyết</p>
                                </div>
                            </div>
                            <div class="status-option" data-status="Dismissed">
                                <div class="status-card dismissed">
                                    <i class="fas fa-times-circle"></i>
                                    <span>Đã từ chối</span>
                                    <p>Báo cáo không hợp lệ</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Ghi chú (tùy chọn):</label>
                        <textarea id="statusNote" placeholder="Nhập ghi chú về việc thay đổi trạng thái..." rows="3"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeStatusModal()">
                    <i class="fas fa-times"></i> Hủy
                </button>
                <button class="btn btn-primary" onclick="confirmStatusUpdate()" id="confirmUpdateBtn" disabled>
                    <i class="fas fa-save"></i> Cập nhật trạng thái
                </button>
            </div>
        </div>
    </div>

    <script>
        // Highlight updated course cards when page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Check if there's a success parameter in URL
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('updated') === 'success') {
                // Add a subtle highlight animation to all course cards
                const courseCards = document.querySelectorAll('.course-card');
                courseCards.forEach((card, index) => {
                    setTimeout(() => {
                        card.style.transform = 'scale(1.02)';
                        card.style.boxShadow = '0 10px 30px rgba(102, 126, 234, 0.2)';
                        card.style.transition = 'all 0.3s ease';
                        
                        setTimeout(() => {
                            card.style.transform = 'scale(1)';
                            card.style.boxShadow = '0 20px 60px rgba(0, 0, 0, 0.1)';
                        }, 500);
                    }, index * 100);
                });
                
                // Clean URL after animation
                setTimeout(() => {
                    const cleanUrl = window.location.pathname + '?' + 
                        Array.from(urlParams.entries())
                            .filter(([key, value]) => key !== 'updated' && key !== 't')
                            .map(([key, value]) => `${key}=${value}`)
                            .join('&');
                    window.history.replaceState({}, '', cleanUrl);
                }, 2000);
            }
        });
    </script>

</body>
</html>