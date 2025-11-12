<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Forward to admin dashboard in views
    request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
%>