<%@page import="model.Users"%>
<%@page import="model.CourseNotification"%>
<%@page import="services.CourseApprovalService"%>
<%@page import="java.util.List"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    Users user = (Users) session.getAttribute("account");
    if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    CourseApprovalService approvalService = new CourseApprovalService();
    List<CourseNotification> pendingNotifications = approvalService.getPendingNotifications();
    int pendingCount = pendingNotifications != null ? pendingNotifications.size() : 0;
    int dismissedCount = 0;
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
    DecimalFormat priceFormat = new DecimalFormat("#,###");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    request.setAttribute("pendingNotifications", pendingNotifications);
    request.setAttribute("pendingCount", pendingCount);
    request.setAttribute("dismissedCount", dismissedCount);
    request.setAttribute("successMessage", successMessage);
    request.setAttribute("errorMessage", errorMessage);
    request.setAttribute("priceFormat", priceFormat);
    request.setAttribute("dateFormat", dateFormat);
    request.getRequestDispatcher("/WEB-INF/views/admin/notification.jsp").forward(request, response);
%>
