package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Servlet xử lý đăng xuất người dùng
 */
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(LogoutServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processLogout(request, response);
    }
    
    /**
     * Xử lý logic đăng xuất
     */
    private void processLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Log thông tin trước khi đăng xuất
            Object userObj = session.getAttribute("account");
            String userName = "Unknown";
            if (userObj != null) {
                try {
                    // Assuming Users class has getUserName() method
                    userName = ((model.Users) userObj).getUserName();
                } catch (Exception e) {
                    logger.log(Level.WARNING, "Error getting username during logout", e);
                }
            }
            
            logger.info("User logout: " + userName + " (Session: " + session.getId() + ")");
            
            // Xóa tất cả attributes khỏi session
            session.removeAttribute("account");
            session.removeAttribute("user");
            session.removeAttribute("cartItems");
            session.removeAttribute("cart");
            session.removeAttribute("totalAmount");
            session.removeAttribute("checkoutSuccess");
            session.removeAttribute("checkoutBillId");
            session.removeAttribute("checkoutAmount");
            session.removeAttribute("checkoutMethod");
            session.removeAttribute("checkoutMessage");
            
            // Invalidate session hoàn toàn
            session.invalidate();
            
            logger.info("Session invalidated successfully for user: " + userName);
        } else {
            logger.info("Logout attempted but no active session found");
        }
        
        // Thêm header để prevent caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // Redirect về trang home với parameter logout
        String contextPath = request.getContextPath();
        response.sendRedirect(contextPath + "/home?logout=success");
    }
}