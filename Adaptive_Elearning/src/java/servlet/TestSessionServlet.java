package servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

@WebServlet("/test-session")
public class TestSessionServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        String userRole = (String) session.getAttribute("userRole");
        
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println("<!DOCTYPE html>");
        response.getWriter().println("<html><head><title>Session Test</title></head><body>");
        response.getWriter().println("<h1>Session Information</h1>");
        
        if (currentUser != null) {
            response.getWriter().println("<p><strong>User ID:</strong> " + currentUser.getId() + "</p>");
            response.getWriter().println("<p><strong>Username:</strong> " + currentUser.getUserName() + "</p>");
            response.getWriter().println("<p><strong>Full Name:</strong> " + currentUser.getFullName() + "</p>");
            response.getWriter().println("<p><strong>Email:</strong> " + currentUser.getEmail() + "</p>");
            response.getWriter().println("<p><strong>Role:</strong> " + userRole + "</p>");
        } else {
            response.getWriter().println("<p>No user logged in</p>");
        }
        
        response.getWriter().println("</body></html>");
    }
}