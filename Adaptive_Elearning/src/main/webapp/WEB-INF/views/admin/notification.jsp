<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="controller.NotificationController"%>
<%@page import="model.CourseNotification"%>
<%@page import="services.CourseApprovalService"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%
    // Get course approval notifications from request attributes
    @SuppressWarnings("unchecked")
    List<CourseNotification> pendingNotifications = (List<CourseNotification>) request.getAttribute("pendingNotifications");
    Integer pendingCount = (Integer) request.getAttribute("pendingCount");
    Integer dismissedCount = (Integer) request.getAttribute("dismissedCount");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    DecimalFormat priceFormat = (DecimalFormat) request.getAttribute("priceFormat");
    SimpleDateFormat dateFormat = (SimpleDateFormat) request.getAttribute("dateFormat");
    
    if (pendingNotifications == null) {
        pendingNotifications = new ArrayList<>();
    }
    if (pendingCount == null) {
        pendingCount = 0;
    }
    if (dismissedCount == null) {
        dismissedCount = 0;
    }
    if (priceFormat == null) {
        priceFormat = new DecimalFormat("#,###");
    }
    if (dateFormat == null) {
        dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
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
                from {
                    transform: rotate(0deg);
                }
                to {
                    transform: rotate(360deg);
                }
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

            .stat-card:nth-child(1) {
                animation-delay: 0.1s;
            }
            .stat-card:nth-child(2) {
                animation-delay: 0.2s;
            }
            .stat-card:nth-child(3) {
                animation-delay: 0.3s;
            }
            .stat-card:nth-child(4) {
                animation-delay: 0.4s;
            }

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

            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 10000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.7);
                backdrop-filter: blur(5px);
                align-items: center;
                justify-content: center;
                animation: fadeIn 0.3s ease;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            .modal-content {
                background: linear-gradient(145deg, rgba(30, 30, 60, 0.95), rgba(20, 20, 40, 0.95));
                backdrop-filter: blur(20px);
                border: 1px solid rgba(139, 92, 246, 0.3);
                border-radius: 16px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
                width: 90%;
                max-width: 600px;
                animation: slideDown 0.3s ease;
            }

            @keyframes slideDown {
                from {
                    transform: translateY(-50px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .modal-footer {
                border-top: 1px solid rgba(255, 255, 255, 0.1);
            }
        </style>
        <script src="${pageContext.request.contextPath}/assests/js/universe-theme.js"></script>
    </head>
    <body class="universe-theme">
        <!-- Universe Background Layer -->
        <div class="universe-background"></div>

        <header class="header universe-header">
            <h1 class="universe-title"><i class="fas fa-bell"></i> Quản lý Thông báo - CourseHub Admin</h1>
            
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
                     
                        <li><a href="/Adaptive_Elearning/admin_coursemanagement.jsp">
                                <i class="fa-solid fa-bars-progress"></i><span>Quản Lý Khóa Học</span>
                            </a></li>
                            <li><a href="/Adaptive_Elearning/admin_reportedcourse.jsp">
                                <i class="fas fa-flag"></i><span>Báo cáo Khóa học</span>
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
                <% if (errorMessage != null) {%>
                <div class="error-message">
                    <i class="fas fa-exclamation-triangle"></i>
                    <%= errorMessage%>
                </div>
                <% } %>

                <!-- Success/Error Messages -->
                <% if (successMessage != null) { %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i> <%= successMessage %>
                </div>
                <% } %>
                
                <% if (errorMessage != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
                </div>
                <% } %>

                <!-- Page Header -->
                <div class="page-header">
                    <h2><i class="fas fa-bell"></i> Thông báo phê duyệt khóa học</h2>
                    <p>Quản lý và phê duyệt khóa học mới từ giảng viên</p>
                </div>

                <!-- Statistics Cards -->
                <div class="stats-container">
                    <div class="stat-card pending">
                        <div class="icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div>
                            <h3>Đang chờ phê duyệt</h3>
                            <div class="value"><%= pendingCount %></div>
                        </div>
                    </div>

                    <div class="stat-card total">
                        <div class="icon">
                            <i class="fas fa-graduation-cap"></i>
                        </div>
                        <div>
                            <h3>Khóa học mới hôm nay</h3>
                            <div class="value"><%= pendingCount %></div>
                        </div>
                    </div>

                    <div class="stat-card approved">
                        <div class="icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div>
                            <h3>Chờ xem xét</h3>
                            <div class="value"><%= pendingCount %></div>
                        </div>
                    </div>

                    <div class="stat-card dismissed">
                        <div class="icon">
                            <i class="fas fa-times-circle"></i>
                        </div>
                        <div>
                            <h3>Đã từ chối</h3>
                            <div class="value"><%= dismissedCount%></div>
                        </div>
                    </div>
                </div>

                <!-- Notifications Table -->
                <div class="content-card">
                    <div class="card-header">
                        <h2><i class="fas fa-graduation-cap"></i> Khóa học chờ phê duyệt</h2>
                    </div>
                    <div class="card-body">
                        <div class="pagination-info" style="margin-bottom: 1rem; color: rgba(248, 250, 252, 0.8);">
                            Hiển thị <%= pendingNotifications.size()%> khóa học đang chờ phê duyệt
                        </div>

                        <div class="table-container">
                            <% if (pendingNotifications.isEmpty()) { %>
                            <div class="no-data">
                                <i class="fas fa-check-circle"></i>
                                <h3>Không có khóa học nào đang chờ phê duyệt</h3>
                                <p>Tất cả khóa học đã được xem xét</p>
                            </div>
                            <% } else { %>
                            <table>
                                <thead>
                                    <tr>
                                        <th style="width: 100px;">Hình ảnh</th>
                                        <th>Khóa học</th>
                                        <th style="width: 150px;">Giảng viên</th>
                                        <th style="width: 120px;">Giá</th>
                                        <th style="width: 150px;">Thời gian</th>
                                        <th style="width: 100px;">Trạng thái</th>
                                        <th style="width: 200px; text-align: center;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (CourseNotification notification : pendingNotifications) { %>
                                    <tr>
                                        <td>
                                            <% if (notification.getThumbUrl() != null && !notification.getThumbUrl().isEmpty()) { %>
                                                <img src="<%= notification.getThumbUrl() %>" 
                                                     alt="<%= notification.getCourseTitle() %>" 
                                                     style="width: 80px; height: 50px; object-fit: cover; border-radius: 8px;">
                                            <% } else { %>
                                                <div style="width: 80px; height: 50px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                                                    <i class="fas fa-book" style="font-size: 24px; color: white;"></i>
                                                </div>
                                            <% } %>
                                        </td>
                                        <td>
                                            <strong style="color: #F8FAFC; font-size: 15px;"><%= notification.getCourseTitle() %></strong>
                                            <% if (notification.getLevel() != null) { %>
                                                <div style="margin-top: 5px;">
                                                    <span style="font-size: 12px; color: rgba(248, 250, 252, 0.7);">
                                                        <i class="fas fa-signal"></i> <%= notification.getLevel() %>
                                                    </span>
                                                </div>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                <i class="fas fa-user-tie" style="color: #06B6D4;"></i>
                                                <strong><%= notification.getInstructorName() %></strong>
                                            </div>
                                        </td>
                                        <td>
                                            <span style="color: #10B981; font-weight: 600; font-size: 15px;">
                                                <%= priceFormat.format(notification.getCoursePrice()) %> VNĐ
                                            </span>
                                        </td>
                                        <td>
                                            <div style="font-size: 13px;">
                                                <i class="fas fa-clock" style="color: #8B5CF6;"></i>
                                                <%= dateFormat.format(notification.getCreationTime()) %>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="status-badge status-pending">
                                                <i class="fas fa-hourglass-half"></i> Chờ duyệt
                                            </span>
                                        </td>
                                        <td style="text-align: center;">
                                            <div class="action-buttons" style="display: flex; gap: 8px; justify-content: center;">
                                                <form method="POST" action="<%= request.getContextPath() %>/admin/course-approval" style="display: inline;">
                                                    <input type="hidden" name="action" value="approve">
                                                    <input type="hidden" name="notificationId" value="<%= notification.getId() %>">
                                                    <button type="submit" class="btn btn-success" 
                                                            onclick="return confirm('Bạn có chắc muốn phê duyệt khóa học này?')"
                                                            style="padding: 8px 16px; font-size: 13px;">
                                                        <i class="fas fa-check"></i> Duyệt
                                                    </button>
                                                </form>
                                                
                                                <button type="button" class="btn btn-danger" 
                                                        onclick="openRejectModal('<%= notification.getId() %>', '<%= notification.getCourseTitle().replace("'", "\\'") %>')"
                                                        style="padding: 8px 16px; font-size: 13px;">
                                                    <i class="fas fa-times"></i> Từ chối
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                            <% } %>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- Rejection Reason Modal -->
        <div id="rejectModal" class="modal" style="display: none;">
            <div class="modal-content" style="max-width: 600px;">
                <div class="modal-header" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; border-radius: 12px 12px 0 0;">
                    <h2 style="color: white; margin: 0; font-size: 20px;">
                        <i class="fas fa-times-circle"></i> Từ chối khóa học
                    </h2>
                    <button onclick="closeRejectModal()" style="background: rgba(255, 255, 255, 0.2); border: none; color: white; font-size: 24px; cursor: pointer; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                        &times;
                    </button>
                </div>
                <form method="POST" action="<%= request.getContextPath() %>/admin/course-approval">
                    <div class="modal-body" style="padding: 24px;">
                        <input type="hidden" name="action" value="reject">
                        <input type="hidden" name="notificationId" id="rejectNotificationId">
                        
                        <div style="margin-bottom: 20px;">
                            <label style="display: block; color: #F8FAFC; font-weight: 600; margin-bottom: 8px;">
                                <i class="fas fa-book"></i> Khóa học:
                            </label>
                            <div id="rejectCourseTitle" style="padding: 12px; background: rgba(255, 255, 255, 0.1); border-radius: 8px; color: #F8FAFC; font-size: 15px;"></div>
                        </div>
                        
                        <div>
                            <label for="rejectionReason" style="display: block; color: #F8FAFC; font-weight: 600; margin-bottom: 8px;">
                                <i class="fas fa-comment-dots"></i> Lý do từ chối: <span style="color: #EF4444;">*</span>
                            </label>
                            <textarea name="rejectionReason" id="rejectionReason" required
                                      rows="5"
                                      placeholder="Vui lòng nhập lý do từ chối khóa học..."
                                      style="width: 100%; padding: 12px; background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); border-radius: 8px; color: #F8FAFC; font-size: 14px; resize: vertical; font-family: inherit;"
                                      onkeyup="this.style.borderColor = this.value.trim().length > 0 ? '#10B981' : 'rgba(255, 255, 255, 0.2)'"></textarea>
                            <div style="margin-top: 6px; font-size: 12px; color: rgba(248, 250, 252, 0.6);">
                                <i class="fas fa-info-circle"></i> Lý do từ chối sẽ được gửi đến giảng viên để họ có thể chỉnh sửa
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer" style="padding: 16px 24px; border-top: 1px solid rgba(255, 255, 255, 0.1); display: flex; gap: 12px; justify-content: flex-end;">
                        <button type="button" onclick="closeRejectModal()" class="btn btn-secondary" style="padding: 10px 20px;">
                            <i class="fas fa-times"></i> Hủy
                        </button>
                        <button type="submit" class="btn btn-danger" style="padding: 10px 20px;">
                            <i class="fas fa-ban"></i> Xác nhận từ chối
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Universe Theme Script -->
        <script>
            // Rejection Modal Functions
            function openRejectModal(notificationId, courseTitle) {
                document.getElementById('rejectNotificationId').value = notificationId;
                document.getElementById('rejectCourseTitle').textContent = courseTitle;
                document.getElementById('rejectionReason').value = '';
                document.getElementById('rejectModal').style.display = 'flex';
            }

            function closeRejectModal() {
                document.getElementById('rejectModal').style.display = 'none';
            }

            // Close modal when clicking outside
            window.onclick = function(event) {
                const modal = document.getElementById('rejectModal');
                if (event.target === modal) {
                    closeRejectModal();
                }
            };

            document.addEventListener('DOMContentLoaded', function () {
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
                    link.addEventListener('mouseenter', function () {
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
                    link.addEventListener('click', function (e) {
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
                    element.addEventListener('mouseenter', function () {
                        this.style.boxShadow = '0 0 30px rgba(139, 92, 246, 0.4)';
                    });
                    element.addEventListener('mouseleave', function () {
                        if (!this.matches(':focus')) {
                            this.style.boxShadow = '';
                        }
                    });
                });

                // Add cosmic particle effect for stat cards
                const statCards = document.querySelectorAll('.stat-card');
                statCards.forEach(card => {
                    card.addEventListener('mouseenter', function () {
                        this.style.transform = 'translateY(-10px) scale(1.02)';
                    });
                    card.addEventListener('mouseleave', function () {
                        this.style.transform = 'translateY(0) scale(1)';
                    });
                });

                // Enhanced table row hover effects
                const tableRows = document.querySelectorAll('tbody tr');
                tableRows.forEach(row => {
                    row.addEventListener('mouseenter', function () {
                        this.style.transform = 'scale(1.01)';
                        this.style.boxShadow = '0 0 20px rgba(139, 92, 246, 0.3)';
                    });
                    row.addEventListener('mouseleave', function () {
                        this.style.transform = 'scale(1)';
                        this.style.boxShadow = '';
                    });
                });
            });
        </script>
        
        <!-- Admin Performance Optimizer -->
        <script src="${pageContext.request.contextPath}/assets/js/admin-performance.js"></script>
    </body>
</html>