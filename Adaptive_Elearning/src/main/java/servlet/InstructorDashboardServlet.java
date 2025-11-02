package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

import java.io.IOException;

/**
 * Servlet to handle Instructor Dashboard access
 * Allows both Instructor and Admin roles to access instructor features
 */
@WebServlet(urlPatterns = {"/instructor-dashboard", "/instructor_dashboard"})
public class InstructorDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Users user = (Users) session.getAttribute("account");
        
        // Check if user exists and has proper role
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = user.getRole();
        
        // Allow both Admin and Instructor to access
        if (!"Admin".equalsIgnoreCase(userRole) && !"Instructor".equalsIgnoreCase(userRole)) {
            // Redirect to access denied page
            request.getRequestDispatcher("/access-denied.jsp").forward(request, response);
            return;
        }
        
        // Add user info to request for JSP access
        request.setAttribute("currentUser", user);
        request.setAttribute("userRole", userRole);
        
        // Forward to instructor dashboard JSP
        request.getRequestDispatcher("/instructor_dashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}