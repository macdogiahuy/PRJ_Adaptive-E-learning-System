<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    
    // Forward to notification JSP in views
    request.getRequestDispatcher("/WEB-INF/views/admin/notification.jsp").forward(request, response);
%>