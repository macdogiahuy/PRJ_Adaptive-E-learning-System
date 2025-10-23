<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // This JSP acts as a controller to forward to the edit user role view
    String userId = request.getParameter("userId");
    
    if (userId == null || userId.trim().isEmpty()) {
        response.sendRedirect("../../admin_accountmanagement.jsp?error=invalid_user_id");
        return;
    }
    
    // Forward the request to the actual edit user role JSP with the userId parameter
    request.getRequestDispatcher("/WEB-INF/views/admin/edit_user_role.jsp").forward(request, response);
%>