package servlet;

import model.Users;
import services.CourseApprovalService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for admin notifications
 * Returns count of pending courses for real-time notification badge
 */
@WebServlet("/api/admin/pending-courses-count")
public class AdminNotificationServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(AdminNotificationServlet.class.getName());
    private CourseApprovalService approvalService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        approvalService = new CourseApprovalService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("account") : null;
        
        // Only allow admin to access
        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        try {
            // Get count of pending courses
            int pendingCount = approvalService.getPendingNotificationCount();
            
            LOGGER.log(Level.INFO, "Admin {0} requested pending courses count: {1}", 
                      new Object[]{user.getUserName(), pendingCount});
            
            // Return JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            PrintWriter out = response.getWriter();
            out.print("{\"count\": " + pendingCount + ", \"success\": true}");
            out.flush();
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting pending courses count", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            
            PrintWriter out = response.getWriter();
            out.print("{\"count\": 0, \"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            out.flush();
        }
    }
}
