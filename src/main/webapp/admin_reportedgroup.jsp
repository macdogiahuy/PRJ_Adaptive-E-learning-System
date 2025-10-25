<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="controller.ReportedGroupController"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>

<%
    // Handle POST actions
    String action = request.getParameter("action");
    String reportId = request.getParameter("reportId");
    String redirectUrl = "admin_reportedgroup.jsp";
    
    if ("alertAdmin".equals(action) && reportId != null) {
        try {
            ReportedGroupController controller = new ReportedGroupController();
            boolean success = controller.alertAdmin(reportId);
            
            if (success) {
                redirectUrl += "?alertSuccess=true";
            } else {
                redirectUrl += "?alertError=true";
            }
        } catch (SQLException e) {
            redirectUrl += "?alertError=true&msg=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8");
        }
        response.sendRedirect(redirectUrl);
        return;
    }
    
    if ("dismiss".equals(action) && reportId != null) {
        try {
            ReportedGroupController controller = new ReportedGroupController();
            boolean success = controller.dismissReport(reportId);
            
            if (success) {
                redirectUrl += "?dismissSuccess=true";
            } else {
                redirectUrl += "?dismissError=true";
            }
        } catch (SQLException e) {
            redirectUrl += "?dismissError=true&msg=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8");
        }
        response.sendRedirect(redirectUrl);
        return;
    }
    
    // Get parameters for data loading
    String pageParam = request.getParameter("page");
    String searchReporter = request.getParameter("searchReporter");
    String entriesParam = request.getParameter("entries");
    
    int currentPage = 1;
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    int entriesPerPage = 10;
    if (entriesParam != null && !entriesParam.isEmpty()) {
        try {
            entriesPerPage = Integer.parseInt(entriesParam);
        } catch (NumberFormatException e) {
            entriesPerPage = 10;
        }
    }
    
    if (searchReporter == null) {
        searchReporter = "";
    }
    
    // Load data using controller
    ReportedGroupController controller = new ReportedGroupController();
    Map<String, Object> result = null;
    Map<String, Object> statistics = null;
    String errorMessage = null;
    boolean databaseConnected = false;
    
    try {
        databaseConnected = controller.testDatabaseConnection();
        if (databaseConnected) {
            result = controller.getReportedGroups(currentPage, searchReporter, entriesPerPage);
            statistics = controller.getReportStatistics();
        } else {
            errorMessage = "Không thể kết nối đến cơ sở dữ liệu";
        }
    } catch (SQLException e) {
        errorMessage = "Lỗi khi truy vấn dữ liệu: " + e.getMessage();
        e.printStackTrace();
    } catch (Exception e) {
        errorMessage = "Lỗi hệ thống: " + e.getMessage();
        e.printStackTrace();
    }
    
    // Set attributes for JSP
    request.setAttribute("result", result);
    request.setAttribute("statistics", statistics);
    request.setAttribute("currentPage", currentPage);
    request.setAttribute("searchReporter", searchReporter);
    request.setAttribute("entriesPerPage", entriesPerPage);
    request.setAttribute("errorMessage", errorMessage);
    request.setAttribute("databaseConnected", databaseConnected);
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý nhóm bị báo cáo - CourseHub Admin</title>
</head>
<body>
    <%-- Forward to the actual view --%>
    <jsp:forward page="WEB-INF/views/admin/reportedgroup.jsp" />
</body>
</html>