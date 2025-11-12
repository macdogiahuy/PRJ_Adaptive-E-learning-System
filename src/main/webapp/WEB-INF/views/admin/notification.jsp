<%@page import="controller.NotificationController"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Get parameters
    String pageParam = request.getParameter("page");
    String searchType = request.getParameter("type");
    String entriesParam = request.getParameter("entries");
    
    int currentPage = 1;
    if (pageParam != null && !pageParam.trim().isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    int recordsPerPage = 10; // default
    if (entriesParam != null && !entriesParam.trim().isEmpty()) {
        try {
            int entries = Integer.parseInt(entriesParam);
            if (entries == 5 || entries == 7 || entries == 10) {
                recordsPerPage = entries;
            }
        } catch (NumberFormatException e) {
            recordsPerPage = 10;
        }
    }
    
    if (searchType == null) {
        searchType = "";
    }
    
    // Initialize variables
    Map<String, Object> notificationData = null;
    List<String> notificationTypes = null;
    String error = null;
    
    // Load data using NotificationController
    try {
        NotificationController controller = new NotificationController();
        
        // Test connection first
        if (controller.testDatabaseConnection()) {
            // Load notifications with pagination and search
            notificationData = controller.getNotifications(currentPage, searchType, recordsPerPage);
            notificationTypes = controller.getNotificationTypes();
        } else {
            error = "Không thể kết nối tới database CourseHubDB";
        }
    } catch (Exception e) {
        e.printStackTrace();
        error = "Lỗi: " + e.getMessage();
    }
    
    // Set default values if data loading failed
    if (notificationData == null) {
        notificationData = new java.util.HashMap<>();
        notificationData.put("notifications", new ArrayList<>());
        notificationData.put("currentPage", 1);
        notificationData.put("totalPages", 0);
        notificationData.put("totalRecords", 0);
        notificationData.put("recordsPerPage", recordsPerPage);
    }
    
    if (notificationTypes == null) {
        notificationTypes = new ArrayList<>();
    }
    
    // Extract data for easy access
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> notifications = (List<Map<String, Object>>) notificationData.get("notifications");
    
    int totalPages = (Integer) notificationData.get("totalPages");
    int totalRecords = (Integer) notificationData.get("totalRecords");
    
    // Date formatter
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
%>
<%
    // Handle POST requests for status updates
    String action = request.getParameter("action");
    if ("updateStatus".equals(action)) {
        String notificationIdParam = request.getParameter("notificationId");
        String newStatus = request.getParameter("newStatus");
        
        if (notificationIdParam != null && newStatus != null) {
            try {
                controller.NotificationController controller = new controller.NotificationController();
                
                boolean success = controller.updateNotificationStatus(notificationIdParam, newStatus);
                if (success) {
                    // Redirect back with success message
                    response.sendRedirect("notification.jsp?updated=success");
                    return;
                } else {
                    // Redirect back with error message
                    response.sendRedirect("notification.jsp?updated=error");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("notification.jsp?updated=error");
                return;
            }
        }
    }
    

%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Thông báo - CourseHub Admin</title>
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

        .stat-card.approved .icon {
            background: linear-gradient(135deg, #10B981, #06B6D4);
            color: white;
        }

        .stat-card.dismissed .icon {
            background: linear-gradient(135deg, #EF4444, #EC4899);
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

        /* Filters */
        .filters {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
            align-items: end;
            padding: 1.5rem;
            background: linear-gradient(145deg, 
                rgba(107, 70, 193, 0.15), 
                rgba(139, 92, 246, 0.08)
            );
            border-radius: 12px;
            border: 1px solid rgba(139, 92, 246, 0.25);
            backdrop-filter: blur(20px);
            position: relative;
            overflow: hidden;
        }

        .filters::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(180deg, 
                rgba(139, 92, 246, 0.1) 0%, 
                transparent 50%, 
                rgba(6, 182, 212, 0.1) 100%
            );
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
        }

        .filters:hover::before {
            opacity: 1;
        }

        .search-box {
            position: relative;
            flex: 1;
            max-width: 200px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            position: relative;
        }

        .form-group label {
            color: #F8FAFC;
            font-size: 0.95rem;
            font-weight: 600;
            letter-spacing: 0.025em;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-shadow: 0 0 10px rgba(139, 92, 246, 0.3);
        }

        .form-group label::before {
            content: '';
            width: 4px;
            height: 4px;
            background: linear-gradient(45deg, #8B5CF6, #06B6D4);
            border-radius: 50%;
            box-shadow: 0 0 8px rgba(139, 92, 246, 0.8);
        }

        /* Filter button enhancement */
        .filters .btn {
            align-self: end;
            min-width: 140px;
            height: 3.25rem;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            border: none;
            border-radius: 12px;
            color: white;
            font-weight: 600;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 
                0 4px 6px -1px rgba(0, 0, 0, 0.1),
                0 2px 4px -1px rgba(0, 0, 0, 0.06),
                0 0 20px rgba(139, 92, 246, 0.3);
            position: relative;
            overflow: hidden;
            text-shadow: 0 0 10px rgba(139, 92, 246, 0.8);
        }

        .filters .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, 
                transparent, 
                rgba(248, 250, 252, 0.2), 
                transparent
            );
            transition: left 0.5s ease;
        }

        .filters .btn:hover {
            transform: translateY(-2px);
            box-shadow: 
                0 8px 25px -8px rgba(139, 92, 246, 0.4),
                0 2px 4px -1px rgba(0, 0, 0, 0.06),
                0 0 30px rgba(139, 92, 246, 0.5);
            background: linear-gradient(45deg, #8B5CF6, #06B6D4);
        }

        .filters .btn:hover::before {
            left: 100%;
        }

        .filters .btn:active {
            transform: translateY(0);
        }

        /* Enhanced Modern Filter Design */
        .modern-filter-card {
            margin-bottom: 2rem;
            background: linear-gradient(145deg, 
                rgba(107, 70, 193, 0.12), 
                rgba(139, 92, 246, 0.06)
            );
            border: 1px solid rgba(139, 92, 246, 0.3);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 
                0 8px 32px rgba(0, 0, 0, 0.12),
                0 2px 8px rgba(139, 92, 246, 0.2);
        }

        .filter-header {
            background: linear-gradient(135deg, 
                rgba(139, 92, 246, 0.15), 
                rgba(6, 182, 212, 0.1)
            );
            border-bottom: 1px solid rgba(139, 92, 246, 0.2);
            padding: 1.5rem 2rem;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .icon-wrapper {
            width: 48px;
            height: 48px;
            background: linear-gradient(45deg, #8B5CF6, #06B6D4);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: white;
            box-shadow: 0 4px 12px rgba(139, 92, 246, 0.4);
        }

        .header-title h2 {
            margin: 0;
            font-size: 1.4rem;
            font-weight: 600;
            background: linear-gradient(45deg, #06B6D4, #8B5CF6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .filter-status {
            display: flex;
            align-items: center;
        }

        .status-badge {
            background: linear-gradient(135deg, rgba(6, 182, 212, 0.2), rgba(139, 92, 246, 0.2));
            border: 1px solid rgba(6, 182, 212, 0.3);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            color: #F8FAFC;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            backdrop-filter: blur(10px);
        }

        .status-badge i {
            color: #06B6D4;
        }

        .filter-body {
            padding: 2rem;
        }

        .modern-filters {
            background: transparent;
            padding: 0;
            border: none;
            margin: 0;
        }

        .filter-row {
            display: grid;
            grid-template-columns: 1fr 1fr auto auto;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
            align-items: end;
        }

        .primary-filters {
            align-items: end;
        }

        .filter-group {
            position: relative;
        }

        .enhanced-select {
            position: relative;
        }

        .modern-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
            font-weight: 600;
            font-size: 0.9rem;
            color: #F8FAFC;
            text-shadow: 0 0 8px rgba(139, 92, 246, 0.3);
        }

        .modern-label i {
            color: #8B5CF6;
            font-size: 0.85rem;
        }

        .select-wrapper {
            position: relative;
            overflow: hidden;
            border-radius: 12px;
            background: linear-gradient(145deg, 
                rgba(15, 15, 35, 0.9), 
                rgba(26, 26, 46, 0.8)
            );
            border: 2px solid rgba(139, 92, 246, 0.3);
            transition: all 0.3s ease;
            min-height: 3.25rem;
        }

        .select-wrapper:hover {
            border-color: rgba(139, 92, 246, 0.5);
            box-shadow: 0 4px 12px rgba(139, 92, 246, 0.2);
        }

        .select-wrapper:focus-within {
            border-color: #8B5CF6;
            box-shadow: 
                0 0 0 3px rgba(139, 92, 246, 0.2),
                0 4px 12px rgba(139, 92, 246, 0.3);
        }

        .modern-select {
            width: 100%;
            padding: 1rem 3rem 1rem 1rem;
            background: transparent;
            border: none;
            color: #F8FAFC;
            font-size: 0.95rem;
            font-weight: 500;
            cursor: pointer;
            outline: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            height: 3.25rem;
            box-sizing: border-box;
        }

        .modern-select option {
            background: rgba(15, 15, 35, 0.95);
            color: #F8FAFC;
            padding: 0.5rem;
        }

        .select-arrow {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #8B5CF6;
            font-size: 0.8rem;
            pointer-events: none;
            transition: all 0.3s ease;
        }

        .select-wrapper:hover .select-arrow {
            color: #06B6D4;
        }

        .action-group {
            display: contents;
        }

        .button-container {
            display: contents;
        }

        .modern-search-btn {
            background: linear-gradient(45deg, #8B5CF6, #06B6D4);
            border: none;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            color: white;
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            min-width: 160px;
            height: 3.25rem;
            box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modern-search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(139, 92, 246, 0.4);
            background: linear-gradient(45deg, #A855F7, #0891B2);
        }

        .btn-content {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            position: relative;
            z-index: 2;
        }

        .btn-glow {
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, 
                transparent, 
                rgba(255, 255, 255, 0.2), 
                transparent
            );
            transition: left 0.6s ease;
        }

        .modern-search-btn:hover .btn-glow {
            left: 100%;
        }

        .reset-btn {
            background: rgba(139, 92, 246, 0.1);
            border: 1px solid rgba(139, 92, 246, 0.3);
            border-radius: 12px;
            padding: 1rem;
            color: #F8FAFC;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            min-width: 120px;
            height: 3.25rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .reset-btn:hover {
            background: rgba(139, 92, 246, 0.2);
            border-color: rgba(139, 92, 246, 0.5);
            transform: translateY(-1px);
        }

        .filter-summary {
            border-top: 1px solid rgba(139, 92, 246, 0.2);
            padding-top: 1.5rem;
            margin-top: 1.5rem;
        }

        .summary-content {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .active-filters {
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
            width: 100%;
        }

        .summary-label {
            font-size: 0.9rem;
            color: rgba(248, 250, 252, 0.8);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            white-space: nowrap;
        }

        .summary-label i {
            color: #8B5CF6;
        }

        .filter-tags {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .filter-tag {
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.2), rgba(6, 182, 212, 0.1));
            border: 1px solid rgba(139, 92, 246, 0.3);
            padding: 0.4rem 0.8rem;
            border-radius: 16px;
            font-size: 0.8rem;
            color: #F8FAFC;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            backdrop-filter: blur(10px);
        }

        .filter-tag i:first-child {
            color: #8B5CF6;
        }

        .remove-filter {
            background: none;
            border: none;
            color: rgba(248, 250, 252, 0.6);
            cursor: pointer;
            padding: 0;
            margin-left: 0.3rem;
            font-size: 0.7rem;
            transition: color 0.2s ease;
        }

        .remove-filter:hover {
            color: #EC4899;
        }

        .no-filters {
            color: rgba(248, 250, 252, 0.6);
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-style: italic;
        }

        .no-filters i {
            color: rgba(139, 92, 246, 0.6);
        }
        

        .form-group select,
        .form-group input {
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
            position: relative;
        }

        .form-group select:hover,
        .form-group input:hover {
            border-color: rgba(139, 92, 246, 0.5);
            box-shadow: 
                0 8px 25px -8px rgba(139, 92, 246, 0.3),
                0 2px 4px -1px rgba(0, 0, 0, 0.06),
                inset 0 1px 0 rgba(139, 92, 246, 0.15);
            transform: translateY(-1px);
        }

        .form-group select:focus,
        .form-group input:focus {
            outline: none;
            border-color: #8B5CF6;
            box-shadow: 
                0 0 0 3px rgba(139, 92, 246, 0.2),
                0 8px 25px -8px rgba(139, 92, 246, 0.4),
                inset 0 1px 0 rgba(139, 92, 246, 0.2);
            transform: translateY(-1px);
        }

        .form-group select {
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
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%2306B6D4' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
        }

        .form-group select:focus {
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23F8FAFC' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
        }

        /* Custom dropdown options styling */
        .form-group select option {
            background: rgba(15, 15, 35, 0.95);
            color: #F8FAFC;
            padding: 0.75rem;
            border: none;
            font-weight: 500;
        }

        .form-group select option:hover,
        .form-group select option:checked {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
            color: white;
        }

        /* Enhanced form group styling */
        .form-group {
            position: relative;
            margin-bottom: 1.5rem;
        }

        .form-group::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(139, 92, 246, 0.05), rgba(6, 182, 212, 0.05));
            border-radius: 16px;
            opacity: 0;
            transition: opacity 0.3s ease;
            pointer-events: none;
            z-index: -1;
        }

        .form-group:hover::before {
            opacity: 1;
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
            color: white;
            border-radius: 8px;
            font-size: 0.8rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, #8B5CF6, #06B6D4);
            color: white;
        }

        .btn-success {
            background: linear-gradient(135deg, #10B981, #06B6D4);
            color: white;
        }

        .btn-danger {
            background: linear-gradient(135deg, #EF4444, #EC4899);
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
            background: rgba(249, 115, 22, 0.2);
            color: #F59E0B;
            border: 1px solid rgba(249, 115, 22, 0.3);
        }

        .status-approved {
            background: rgba(34, 197, 94, 0.2);
            color: #10B981;
            border: 1px solid rgba(34, 197, 94, 0.3);
        }

        .status-dismissed {
            background: rgba(239, 68, 68, 0.2);
            color: #EF4444;
            border: 1px solid rgba(239, 68, 68, 0.3);
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 2rem;
            padding: 1.5rem;
            border-top: 1px solid rgba(139, 92, 246, 0.2);
            background: linear-gradient(145deg, rgba(139, 92, 246, 0.05), rgba(107, 70, 193, 0.02));
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
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .success-message {
            background: linear-gradient(145deg, rgba(34, 197, 94, 0.2), rgba(34, 197, 94, 0.1));
            backdrop-filter: blur(10px);
            border: 1px solid rgba(34, 197, 94, 0.3);
            color: #86EFAC;
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .no-data {
            text-align: center;
            padding: 3rem;
            color: rgba(248, 250, 252, 0.8);
        }

        .no-data i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: rgba(139, 92, 246, 0.6);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container { 
                flex-direction: column; 
            }
            .sidebar { 
                width: 100%; 
                order: 2; 
                padding: 1rem 0;
            }
            .main-content { 
                order: 1; 
                margin-left: 0;
                padding: 1rem;
            }

            .header {
                padding: 1rem;
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .header h1 {
                font-size: 1.4rem;
            }

            .stats-container {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .stat-card {
                padding: 1rem;
                flex-direction: row;
                align-items: center;
                gap: 1rem;
            }

            .stat-card .icon {
                margin-bottom: 0;
                width: 40px;
                height: 40px;
                font-size: 1.2rem;
            }

            .stat-card .value {
                font-size: 1.5rem;
            }

            .filters {
                grid-template-columns: 1fr;
                gap: 1rem;
                padding: 1rem;
            }

            .form-group {
                margin-bottom: 0;
            }

            .form-group select,
            .form-group input {
                padding: 0.875rem 1rem;
                font-size: 0.9rem;
            }

            .filters .btn {
                min-width: 100%;
                margin-top: 0.5rem;
            }

            .search-box {
                max-width: none;
            }

            .table-container {
                font-size: 0.8rem;
                overflow-x: auto;
            }

            table {
                min-width: 600px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 0.25rem;
            }

            .action-buttons .btn {
                padding: 0.4rem 0.8rem;
                font-size: 0.75rem;
            }

            .pagination {
                flex-direction: column;
                gap: 1rem;
                padding: 1rem;
            }

            .pagination-controls {
                justify-content: center;
                flex-wrap: wrap;
            }

            .modern-filter-card {
                margin-bottom: 1rem;
            }

            .filter-header {
                padding: 1rem;
            }

            .header-content {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.75rem;
            }

            .filter-body {
                padding: 1rem;
            }

            .filter-row {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .modern-search-btn,
            .reset-btn {
                min-width: auto;
                width: 100%;
                margin-top: 1rem;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 0.5rem;
            }

            .header {
                padding: 0.75rem;
            }

            .header h1 {
                font-size: 1.2rem;
            }

            .page-header {
                padding: 1rem;
                border-radius: 12px;
            }

            .page-header h2 {
                font-size: 1.1rem;
            }

            .content-card {
                border-radius: 12px;
                margin-bottom: 1rem;
            }

            .card-header {
                padding: 1rem;
            }

            .card-body {
                padding: 1rem;
            }

            .stats-container {
                gap: 0.75rem;
            }

            .stat-card {
                padding: 0.875rem;
                border-radius: 12px;
            }

            .stat-card .icon {
                width: 36px;
                height: 36px;
                font-size: 1rem;
            }

            .stat-card h3 {
                font-size: 0.8rem;
            }

            .stat-card .value {
                font-size: 1.25rem;
            }

            .table-container {
                border-radius: 8px;
                margin-bottom: 1rem;
            }

            table {
                min-width: 500px;
                font-size: 0.75rem;
            }

            thead th {
                padding: 0.75rem 0.5rem;
                font-size: 0.8rem;
            }

            tbody td {
                padding: 0.75rem 0.5rem;
                font-size: 0.75rem;
            }

            .action-buttons .btn {
                padding: 0.3rem 0.6rem;
                font-size: 0.7rem;
                border-radius: 6px;
            }

            .pagination {
                padding: 0.75rem;
            }

            .pagination-info {
                font-size: 0.8rem;
                text-align: center;
            }

            .pagination-controls a,
            .pagination-controls span {
                padding: 0.4rem 0.6rem;
                font-size: 0.8rem;
                border-radius: 6px;
            }

            .sidebar {
                padding: 0.75rem 0;
            }

            .nav-header {
                padding: 0 1rem 1rem 1rem;
            }

            .nav-header h3 {
                font-size: 1rem;
            }

            .sidebar a {
                padding: 0.75rem 1rem;
                font-size: 0.85rem;
                gap: 0.75rem;
            }

            .sidebar a i {
                font-size: 1rem;
                width: 18px;
            }

            .nav-group-title {
                font-size: 0.7rem;
                padding: 0 1rem 0.4rem 1rem;
            }

            .filter-row {
                grid-template-columns: 1fr;
                gap: 0.75rem;
            }

            .modern-search-btn {
                font-size: 0.85rem;
                padding: 0.875rem 1rem;
                min-width: auto;
                width: 100%;
                margin-top: 0.75rem;
            }

            .reset-btn {
                font-size: 0.85rem;
                padding: 0.875rem;
                min-width: auto;
                width: 100%;
                margin-top: 0.5rem;
            }

            .modern-label {
                font-size: 0.85rem;
                margin-bottom: 0.5rem;
            }

            .modern-select {
                font-size: 0.85rem;
                padding: 0.875rem 2.5rem 0.875rem 0.875rem;
            }
        }

        /* Enhanced Animation Effects */
        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInScale {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        @keyframes shimmer {
            0% {
                background-position: -200px 0;
            }
            100% {
                background-position: calc(200px + 100%) 0;
            }
        }

        .content-card {
            animation: slideInUp 0.6s ease-out;
        }

        .stat-card {
            animation: fadeInScale 0.6s ease-out;
            animation-fill-mode: both;
        }

        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .stat-card:nth-child(4) { animation-delay: 0.4s; }

        /* Loading shimmer effect */
        .loading-shimmer {
            background: linear-gradient(90deg, 
                rgba(139, 92, 246, 0.1) 0%, 
                rgba(139, 92, 246, 0.3) 50%, 
                rgba(139, 92, 246, 0.1) 100%
            );
            background-size: 200px 100%;
            animation: shimmer 1.5s infinite;
        }

        /* Enhanced focus states for accessibility */
        .modern-select:focus,
        .form-group input:focus,
        .btn:focus {
            outline: 2px solid #8B5CF6;
            outline-offset: 2px;
        }

        /* Improved button hover states */
        .btn {
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, 
                transparent, 
                rgba(255, 255, 255, 0.2), 
                transparent
            );
            transition: left 0.5s ease;
        }

        .btn:hover::before {
            left: 100%;
        }

        /* Status badge animations */
        .status-badge {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .status-badge::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, 
                transparent, 
                rgba(255, 255, 255, 0.2), 
                transparent
            );
            transition: left 0.8s ease;
        }

        .status-badge:hover::before {
            left: 100%;
        }

        /* Table row animations */
        tbody tr {
            transition: all 0.3s ease;
            transform: translateX(0);
        }

        tbody tr:hover {
            transform: translateX(5px);
            background: linear-gradient(135deg, 
                rgba(139, 92, 246, 0.15), 
                rgba(6, 182, 212, 0.1)
            );
        }

        /* Enhanced pagination styles */
        .pagination-controls a,
        .pagination-controls span {
            position: relative;
            overflow: hidden;
        }

        .pagination-controls a::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, 
                rgba(139, 92, 246, 0.3), 
                rgba(6, 182, 212, 0.2)
            );
            transition: left 0.4s ease;
        }

        .pagination-controls a:hover::before {
            left: 100%;
        }
    </style>
    <script src="${pageContext.request.contextPath}/assests/js/universe-theme.js"></script>
</head>
<body class="universe-theme">
    <!-- Universe Background Layer -->
    <div class="universe-background"></div>
    
    <header class="header universe-header">
        <h1 class="universe-title"><i class="fas fa-bell"></i> Quản lý Thông báo - CourseHub Admin</h1>
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
                    <li><a href="/Adaptive_Elearning/admin_notification.jsp" class="active">
                        <i class="fas fa-bell"></i><span>Thông báo</span>
                    </a></li>
                </ul>
            </div>

            <div class="nav-group">
                <div class="nav-group-title">User Management</div>
                <ul>
                    <li><a href="/Adaptive_Elearning/admin_createadmin.jsp">
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
            <% if (error != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    <%= error %>
                </div>
            <% } %>

            <!-- Success/Error Messages -->
            <% if (request.getParameter("updated") != null) { %>
                <% if ("success".equals(request.getParameter("updated"))) { %>
                    <div class="success-message">
                        <i class="fas fa-check-circle"></i> Cập nhật trạng thái thông báo thành công!
                    </div>
                <% } else { %>
                    <div class="error-message">
                        <i class="fas fa-exclamation-circle"></i> Không thể cập nhật trạng thái thông báo. Vui lòng thử lại!
                    </div>
                <% } %>
            <% } %>

            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="fas fa-bell"></i> Quản lý Thông báo</h2>
                <p>Quản lý và theo dõi tất cả thông báo trong hệ thống CourseHub</p>
            </div>

            <!-- Statistics Cards -->
            <%
                // Calculate notification statistics from total records
                int totalNotifications = totalRecords;
                int pendingCount = 0;
                int approvedCount = 0;
                int dismissedCount = 0;
                
                // Count from current page notifications for display
                for (Map<String, Object> notification : notifications) {
                    String status = (String) notification.get("status");
                    if (status == null || "Pending".equals(status)) {
                        pendingCount++;
                    } else if ("Approved".equals(status)) {
                        approvedCount++;
                    } else if ("Dismissed".equals(status)) {
                        dismissedCount++;
                    }
                }
            %>
            <div class="stats-container">
                <div class="stat-card total">
                    <div class="icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div>
                        <h3>Tổng số thông báo</h3>
                        <div class="value"><%= totalNotifications %></div>
                    </div>
                </div>
                
                <div class="stat-card pending">
                    <div class="icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div>
                        <h3>Đang chờ xử lý</h3>
                        <div class="value"><%= pendingCount %></div>
                    </div>
                </div>
                
                <div class="stat-card approved">
                    <div class="icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div>
                        <h3>Đã phê duyệt</h3>
                        <div class="value"><%= approvedCount %></div>
                    </div>
                </div>
                
                <div class="stat-card dismissed">
                    <div class="icon">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <div>
                        <h3>Đã từ chối</h3>
                        <div class="value"><%= dismissedCount %></div>
                    </div>
                </div>
            </div>

            <!-- Advanced Search & Filter Section -->
            <div class="content-card modern-filter-card">
                <div class="card-header filter-header">
                    <div class="header-content">
                        <div class="header-title">
                            <div class="icon-wrapper">
                                <i class="fas fa-filter"></i>
                            </div>
                            <h2>Bộ lọc & Tìm kiếm thông minh</h2>
                        </div>
                        <div class="filter-status">
                            <span class="status-badge">
                                <i class="fas fa-circle-check"></i>
                                Đang hiển thị <%= notifications.size() %>/<%= totalRecords %> thông báo
                            </span>
                        </div>
                    </div>
                </div>
                <div class="card-body filter-body">
                    <form class="filters modern-filters" method="GET" action="admin_notification.jsp">
                        <div class="filter-row primary-filters">
                            <div class="filter-group">
                                <div class="form-group enhanced-select">
                                    <label for="entries" class="modern-label">
                                        <i class="fas fa-list-ol"></i>
                                        <span>Số lượng hiển thị</span>
                                    </label>
                                    <div class="select-wrapper">
                                        <select name="entries" id="entries" onchange="updateEntries()" class="modern-select">
                                            <option value="5" <%= recordsPerPage == 5 ? "selected" : "" %>>5 mục</option>
                                            <option value="7" <%= recordsPerPage == 7 ? "selected" : "" %>>7 mục</option>
                                            <option value="10" <%= recordsPerPage == 10 ? "selected" : "" %>>10 mục</option>
                                        </select>
                                        <div class="select-arrow">
                                            <i class="fas fa-chevron-down"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="filter-group">
                                <div class="form-group enhanced-select">
                                    <label for="type" class="modern-label">
                                        <i class="fas fa-tag"></i>
                                        <span>Loại thông báo</span>
                                    </label>
                                    <div class="select-wrapper">
                                        <select name="type" id="type" class="modern-select">
                                            <option value="">Tất cả loại</option>
                                            <% for (String type : notificationTypes) { %>
                                                <option value="<%= type %>" <%= searchType.equals(type) ? "selected" : "" %>>
                                                    <%= type %>
                                                </option>
                                            <% } %>
                                        </select>
                                        <div class="select-arrow">
                                            <i class="fas fa-chevron-down"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <input type="hidden" name="page" value="1">
                            <button type="submit" class="btn btn-primary modern-search-btn">
                                <div class="btn-content">
                                    <i class="fas fa-search"></i>
                                    <span>Áp dụng bộ lọc</span>
                                </div>
                                <div class="btn-glow"></div>
                            </button>
                            
                            <button type="button" class="btn btn-secondary reset-btn" onclick="resetFilters()">
                                <i class="fas fa-undo"></i>
                                <span>Đặt lại</span>
                            </button>
                        </div>

                      
                    </form>
                </div>
            </div>

            <!-- Notifications Table -->
            <div class="content-card">
                <div class="card-header">
                    <h2><i class="fas fa-list"></i> Danh sách Thông báo</h2>
                </div>
                <div class="card-body">
                    <div class="pagination-info" style="margin-bottom: 1rem; color: rgba(248, 250, 252, 0.8);">
                        Hiển thị <%= notifications.size() %> trên tổng <%= totalRecords %> thông báo
                    </div>

                    <div class="table-container">
                        <% if (notifications.isEmpty()) { %>
                            <div class="no-data">
                                <i class="fas fa-inbox"></i>
                                <p>Không có thông báo nào</p>
                            </div>
                        <% } else { %>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Loại thông báo</th>
                                        <th>Người tạo</th>
                                        <th>Thời gian tạo</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> notification : notifications) { 
                                        String status = (String) notification.get("status");
                                        String statusClass = "status-pending";
                                        if ("Approved".equals(status)) {
                                            statusClass = "status-approved";
                                        } else if ("Dismissed".equals(status)) {
                                            statusClass = "status-dismissed";
                                        }
                                    %>
                                    <tr>
                                        <td><%= notification.get("type") %></td>
                                        <td><%= notification.get("creatorId") %></td>
                                        <td>
                                            <% if (notification.get("creationTime") != null) { %>
                                                <%= dateFormat.format(notification.get("creationTime")) %>
                                            <% } else { %>
                                                N/A
                                            <% } %>
                                        </td>
                                        <td>
                                            <span class="status-badge <%= statusClass %>">
                                                <%= status != null ? status : "Pending" %>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <% 
                                                String notificationId = (String) notification.get("id");
                                                if (!"Approved".equals(status)) { %>
                                                    <button class="btn btn-success" onclick="updateStatus('<%= notificationId %>', 'Approved')">
                                                        <i class="fas fa-check"></i> Phê duyệt
                                                    </button>
                                                <% } %>
                                                <% if (!"Dismissed".equals(status)) { %>
                                                    <button class="btn btn-danger" onclick="updateStatus('<%= notificationId %>', 'Dismissed')">
                                                        <i class="fas fa-times"></i> Từ chối
                                                    </button>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>

                    <!-- Pagination -->
                    <% if (totalPages > 1) { %>
                        <div class="pagination">
                            <div class="pagination-info">
                                Trang <%= currentPage %> trên <%= totalPages %>
                            </div>
                            <div class="pagination-controls">
                                <% if (currentPage > 1) { %>
                                    <a href="?page=<%= currentPage - 1 %>&type=<%= searchType %>&entries=<%= recordsPerPage %>">
                                        <i class="fas fa-chevron-left"></i> Trang trước
                                    </a>
                                <% } else { %>
                                    <span class="disabled">
                                        <i class="fas fa-chevron-left"></i> Trang trước
                                    </span>
                                <% } %>

                                <% 
                                int startPage = Math.max(1, currentPage - 2);
                                int endPage = Math.min(totalPages, currentPage + 2);
                                
                                for (int i = startPage; i <= endPage; i++) { %>
                                    <% if (i == currentPage) { %>
                                        <span class="current"><%= i %></span>
                                    <% } else { %>
                                        <a href="?page=<%= i %>&type=<%= searchType %>&entries=<%= recordsPerPage %>"><%= i %></a>
                                    <% } %>
                                <% } %>

                                <% if (currentPage < totalPages) { %>
                                    <a href="?page=<%= currentPage + 1 %>&type=<%= searchType %>&entries=<%= recordsPerPage %>">
                                        Trang sau <i class="fas fa-chevron-right"></i>
                                    </a>
                                <% } else { %>
                                    <span class="disabled">
                                        Trang sau <i class="fas fa-chevron-right"></i>
                                    </span>
                                <% } %>
                            </div>
                        </div>
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
            const interactiveElements = document.querySelectorAll('button, .stat-card, .content-card, .form-group input, .form-group select');
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

            // Enhanced table row hover effects
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.transform = 'scale(1.01)';
                    this.style.boxShadow = '0 0 20px rgba(139, 92, 246, 0.3)';
                });
                row.addEventListener('mouseleave', function() {
                    this.style.transform = 'scale(1)';
                    this.style.boxShadow = '';
                });
            });
        });

        function updateStatus(notificationId, status) {
            if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái này?')) {
                // Create form to submit POST request
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '/Adaptive_Elearning/admin_notification.jsp';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'notificationId';
                idInput.value = notificationId;
                
                const statusInput = document.createElement('input');
                statusInput.type = 'hidden';
                statusInput.name = 'newStatus';
                statusInput.value = status;
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'updateStatus';
                
                form.appendChild(idInput);
                form.appendChild(statusInput);
                form.appendChild(actionInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function updateEntries() {
            const entriesSelect = document.getElementById('entries');
            const typeSelect = document.getElementById('type');
            const selectedEntries = entriesSelect.value;
            const selectedType = typeSelect.value;
            
            // Redirect with new entries parameter
            const url = 'admin_notification.jsp?page=1&entries=' + selectedEntries + '&type=' + encodeURIComponent(selectedType);
            window.location.href = url;
        }

        // Enhanced filter functions
        function resetFilters() {
            window.location.href = 'admin_notification.jsp?page=1';
        }

        function removeFilter(filterType) {
            const currentUrl = new URL(window.location);
            const params = new URLSearchParams(currentUrl.search);
            
            if (filterType === 'entries') {
                params.set('entries', '10'); // Reset to default
            } else if (filterType === 'type') {
                params.delete('type');
            }
            
            params.set('page', '1'); // Reset to first page
            
            const newUrl = 'admin_notification.jsp?' + params.toString();
            window.location.href = newUrl;
        }

        // Enhanced dropdown interactions
        document.addEventListener('DOMContentLoaded', function() {
            // Add click animation to filter elements
            const selectWrappers = document.querySelectorAll('.select-wrapper');
            selectWrappers.forEach(wrapper => {
                const select = wrapper.querySelector('.modern-select');
                const arrow = wrapper.querySelector('.select-arrow');
                
                select.addEventListener('focus', () => {
                    arrow.style.transform = 'translateY(-50%) rotate(180deg)';
                });
                
                select.addEventListener('blur', () => {
                    arrow.style.transform = 'translateY(-50%) rotate(0deg)';
                });
            });

            // Add hover effects to filter tags
            const filterTags = document.querySelectorAll('.filter-tag');
            filterTags.forEach(tag => {
                tag.addEventListener('mouseenter', () => {
                    tag.style.transform = 'translateY(-2px)';
                    tag.style.boxShadow = '0 4px 12px rgba(139, 92, 246, 0.3)';
                });
                
                tag.addEventListener('mouseleave', () => {
                    tag.style.transform = 'translateY(0)';
                    tag.style.boxShadow = 'none';
                });
            });

            // Add loading state to search button
            const searchBtn = document.querySelector('.modern-search-btn');
            if (searchBtn) {
                searchBtn.addEventListener('click', function() {
                    const btnContent = this.querySelector('.btn-content span');
                    const originalText = btnContent.textContent;
                    btnContent.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tìm kiếm...';
                    
                    // Reset after form submission (fallback)
                    setTimeout(() => {
                        btnContent.textContent = originalText;
                    }, 2000);
                });
            }
        });
    </script>
</body>
</html>