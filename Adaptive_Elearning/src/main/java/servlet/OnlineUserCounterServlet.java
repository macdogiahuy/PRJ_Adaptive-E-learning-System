package servlet;

import listener.OnlineUserListener;
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
 * Servlet to return current online users count as JSON
 * Called by AJAX every 1 minute to update display
 * Also handles beacon when user closes tab/window
 * @author LP
 */
@WebServlet(urlPatterns = {"/api/online-users"})
public class OnlineUserCounterServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(OnlineUserCounterServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Default: return online users count
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        try {
            int onlineUsers = OnlineUserListener.getLoggedInUsersCount(getServletContext());
            
            // Build JSON response
            String jsonResponse = String.format(
                "{\"success\": true, \"count\": %d, \"timestamp\": %d}",
                onlineUsers,
                System.currentTimeMillis()
            );
            
            PrintWriter out = response.getWriter();
            out.print(jsonResponse);
            out.flush();
            
            LOGGER.log(Level.FINE, "Online users count requested: {0}", onlineUsers);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting online users count", e);
            
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            String errorResponse = String.format(
                "{\"success\": false, \"error\": \"%s\"}",
                e.getMessage().replace("\"", "\\\"")
            );
            
            PrintWriter out = response.getWriter();
            out.print(errorResponse);
            out.flush();
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Online Users Counter API";
    }
}
