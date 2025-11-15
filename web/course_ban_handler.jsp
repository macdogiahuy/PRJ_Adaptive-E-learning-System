<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="controller.CourseManagementController" %>
<%
    String action = request.getParameter("action");
    String courseId = request.getParameter("courseId");
    String currentPage = request.getParameter("currentPage");
    String searchQuery = request.getParameter("searchQuery");
    
    // Validate parameters
    if (action == null || courseId == null) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
        return;
    }
    
    CourseManagementController controller = new CourseManagementController();
    boolean success = false;
    String message = "";
    
    try {
        if ("ban".equals(action)) {
            success = controller.banCourse(courseId);
            message = success ? "Khóa học đã được ban thành công!" : "Không thể ban khóa học. Vui lòng thử lại.";
        } else if ("unban".equals(action)) {
            success = controller.unbanCourse(courseId);
            message = success ? "Khóa học đã được unban thành công!" : "Không thể unban khóa học. Vui lòng thử lại.";
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            return;
        }
        
        // Set success/error message in session
        if (success) {
            session.setAttribute("successMessage", message);
        } else {
            session.setAttribute("errorMessage", message);
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
    }
    
    // Redirect back to course management page with current pagination and search
    StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/admin_coursemanagement.jsp");
    
    boolean hasParams = false;
    if (currentPage != null && !currentPage.isEmpty()) {
        redirectUrl.append("?page=").append(currentPage);
        hasParams = true;
    }
    
    if (searchQuery != null && !searchQuery.isEmpty()) {
        redirectUrl.append(hasParams ? "&" : "?").append("search=").append(java.net.URLEncoder.encode(searchQuery, "UTF-8"));
    }
    
    response.sendRedirect(redirectUrl.toString());
%>