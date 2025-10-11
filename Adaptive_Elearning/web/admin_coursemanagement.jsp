<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Forward to admin course management in views
    request.getRequestDispatcher("/WEB-INF/views/admin/adcoursemanagement.jsp").forward(request, response);
%>
