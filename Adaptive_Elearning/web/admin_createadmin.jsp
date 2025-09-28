<%@page import="controller.CreateAdminController"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Handle POST requests for creating admin
    String action = request.getParameter("action");
    if ("createAdmin".equals(action)) {
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String bio = request.getParameter("bio");
        String dobStr = request.getParameter("dateOfBirth");
        
        // Validation
        if (userName != null && password != null && confirmPassword != null && 
            email != null && fullName != null && password.equals(confirmPassword)) {
            
            try {
                CreateAdminController controller = new CreateAdminController();
                
                // Parse date of birth
                java.util.Date dateOfBirth = null;
                if (dobStr != null && !dobStr.trim().isEmpty()) {
                    try {
                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                        dateOfBirth = sdf.parse(dobStr);
                    } catch (Exception e) {
                        // Invalid date format, ignore
                    }
                }
                
                boolean success = controller.createAdmin(userName.trim(), password, email.trim(), 
                                                       fullName.trim(), phone, bio, dateOfBirth);
                
                if (success) {
                    // Redirect back with success message
                    response.sendRedirect("admin_createadmin.jsp?created=success");
                    return;
                } else {
                    // Redirect back with error message (user exists)
                    response.sendRedirect("admin_createadmin.jsp?created=exists");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_createadmin.jsp?created=error&msg=" + e.getMessage());
                return;
            }
        } else {
            // Invalid input
            response.sendRedirect("admin_createadmin.jsp?created=invalid");
            return;
        }
    }
    
    // Forward to create admin JSP in views
    request.getRequestDispatcher("/WEB-INF/views/admin/createadmin.jsp").forward(request, response);
%>