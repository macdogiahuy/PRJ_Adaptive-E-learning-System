<%@page import="controller.AccountManagementController"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Handle POST requests for user management actions
    String action = request.getParameter("action");
    if ("updateRole".equals(action)) {
        String userId = request.getParameter("userId");
        String newRole = request.getParameter("newRole");
        
        if (userId != null && newRole != null) {
            try {
                AccountManagementController controller = new AccountManagementController();
                boolean success = controller.updateUserRole(userId, newRole);
                
                if (success) {
                    response.sendRedirect("admin_accountmanagement.jsp?updated=success");
                    return;
                } else {
                    response.sendRedirect("admin_accountmanagement.jsp?updated=error");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_accountmanagement.jsp?updated=error&msg=" + e.getMessage());
                return;
            }
        }
    } else if ("deactivateUser".equals(action)) {
        String userId = request.getParameter("userId");
        
        if (userId != null) {
            try {
                AccountManagementController controller = new AccountManagementController();
                boolean success = controller.deactivateUser(userId);
                
                if (success) {
                    response.sendRedirect("admin_accountmanagement.jsp?deactivated=success");
                    return;
                } else {
                    response.sendRedirect("admin_accountmanagement.jsp?deactivated=error");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_accountmanagement.jsp?deactivated=error&msg=" + e.getMessage());
                return;
            }
        }
    }
    
    // Forward to account management JSP in views
    request.getRequestDispatcher("/WEB-INF/views/admin/accountmanagement.jsp").forward(request, response);
%>