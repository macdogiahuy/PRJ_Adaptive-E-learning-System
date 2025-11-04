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
@WebServlet(urlPatterns = {"/api/online-users", "/api/online-users/leave"})
public class OnlineUserCounterServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(OnlineUserCounterServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getRequestURI();
        
        // Handle /leave endpoint - user closing tab/window
        if (pathInfo != null && pathInfo.endsWith("/leave")) {
            handleUserLeave(request, response);
            return;
        }
        
        // Default: return online users count
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        try {
            int onlineUsers = OnlineUserListener.getOnlineUsersCount(getServletContext());
            
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
    
    /**
     * Handle POST for beacon API when user leaves/closes tab
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        handleUserLeave(request, response);
    }
    
    /**
     * Handle user leaving page (closing tab/window)
     * Decrements online counter directly without invalidating session
     * Note: This allows users with multiple tabs open to keep their session alive
     */
    private void handleUserLeave(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Check if user has active session and hasn't been counted yet for this tab
            HttpSession session = request.getSession(false);
            if (session != null) {
                // Check if this session was counted
                Boolean wasCounted = (Boolean) session.getAttribute(OnlineUserListener.USER_COUNTED_KEY);
                
                if (wasCounted != null && wasCounted) {
                    // Decrement counter directly via ServletContext
                    Integer count = (Integer) getServletContext().getAttribute(OnlineUserListener.ONLINE_USERS_KEY);
                    if (count != null && count > 0) {
                        count--;
                        getServletContext().setAttribute(OnlineUserListener.ONLINE_USERS_KEY, count);
                        session.setAttribute(OnlineUserListener.USER_COUNTED_KEY, false);
                        LOGGER.log(Level.INFO, "User left - decremented counter to: {0}", count);
                    }
                }
            }
            
            response.setStatus(HttpServletResponse.SC_OK);
            PrintWriter out = response.getWriter();
            out.print("{\"success\": true}");
            out.flush();
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error handling user leave", e);
            response.setStatus(HttpServletResponse.SC_OK); // Still return OK for beacon
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Online Users Counter API";
    }
}
