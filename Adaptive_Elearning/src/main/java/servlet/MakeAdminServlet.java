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
 * Quick fix servlet to make current user admin
 */
@WebServlet("/make-admin")
public class MakeAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Users user = (Users) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Set user role to Admin in session (temporary fix)
        user.setRole("Admin");
        session.setAttribute("account", user);
        session.setAttribute("role", "Admin");
        
        // Return response
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().println(
            "<html><body>" +
            "<h2>✅ User Role Updated</h2>" +
            "<p>User <strong>" + user.getUserName() + "</strong> is now Admin!</p>" +
            "<p><a href='" + request.getContextPath() + "/auth-debug.jsp'>🔍 Check Debug Page</a></p>" +
            "<p><a href='" + request.getContextPath() + "/instructor-dashboard'>👨‍🏫 Try Instructor Dashboard</a></p>" +
            "<p><a href='" + request.getContextPath() + "/home'>🏠 Back to Home</a></p>" +
            "</body></html>"
        );
    }
}