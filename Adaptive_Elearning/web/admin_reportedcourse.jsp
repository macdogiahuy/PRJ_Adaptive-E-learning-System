<%@page import="controller.ReportedCourseController"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Set cache control headers to prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    // Handle POST requests for report management actions
    String action = request.getParameter("action");
    if ("updateStatus".equals(action)) {
        String notificationId = request.getParameter("notificationId");
        String newStatus = request.getParameter("newStatus");
        
        if (notificationId != null && newStatus != null) {
            try {
                ReportedCourseController controller = new ReportedCourseController();
                boolean success = controller.updateReportStatus(notificationId, newStatus);
                
                if (success) {
                    response.sendRedirect("admin_reportedcourse.jsp?updated=success&t=" + System.currentTimeMillis());
                    return;
                } else {
                    response.sendRedirect("admin_reportedcourse.jsp?updated=error&t=" + System.currentTimeMillis());
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_reportedcourse.jsp?updated=error&msg=" + e.getMessage());
                return;
            }
        }
    } else if ("suspendCourse".equals(action)) {
        String courseId = request.getParameter("courseId");
        
        if (courseId != null) {
            try {
                ReportedCourseController controller = new ReportedCourseController();
                boolean success = controller.suspendCourse(courseId);
                
                if (success) {
                    response.sendRedirect("admin_reportedcourse.jsp?suspended=success&t=" + System.currentTimeMillis());
                    return;
                } else {
                    response.sendRedirect("admin_reportedcourse.jsp?suspended=error&t=" + System.currentTimeMillis());
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_reportedcourse.jsp?suspended=error&msg=" + e.getMessage());
                return;
            }
        }
    }
    
    // Forward to reported course JSP in views
    request.getRequestDispatcher("/WEB-INF/views/admin/reportedcourse.jsp").forward(request, response);
%>