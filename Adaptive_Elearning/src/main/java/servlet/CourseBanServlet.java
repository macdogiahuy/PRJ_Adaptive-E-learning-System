package servlet;

import controller.CourseManagementController;
import model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for handling course ban/unban actions by admin
 */
@WebServlet("/course-ban")
public class CourseBanServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(CourseBanServlet.class.getName());
    private CourseManagementController controller;
    
    @Override
    public void init() throws ServletException {
        super.init();
        controller = new CourseManagementController();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("account") : null;
        
        // Only allow admin to ban/unban courses
        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        String courseId = request.getParameter("courseId");
        String currentPage = request.getParameter("currentPage");
        String searchQuery = request.getParameter("searchQuery");
        
        if (courseId == null || courseId.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Course ID is missing");
            redirectToManagement(request, response, currentPage, searchQuery, "error", "Course ID is missing");
            return;
        }
        
        try {
            boolean success = false;
            String message = "";
            
            if ("ban".equalsIgnoreCase(action)) {
                success = controller.banCourse(courseId);
                message = success ? "Khóa học đã được ban thành công" : "Không thể ban khóa học";
                LOGGER.log(Level.INFO, "Admin {0} banned course: {1}, success: {2}", 
                          new Object[]{user.getUserName(), courseId, success});
            } else if ("unban".equalsIgnoreCase(action)) {
                success = controller.unbanCourse(courseId);
                message = success ? "Khóa học đã được unban thành công" : "Không thể unban khóa học";
                LOGGER.log(Level.INFO, "Admin {0} unbanned course: {1}, success: {2}", 
                          new Object[]{user.getUserName(), courseId, success});
            } else {
                LOGGER.log(Level.WARNING, "Invalid action: {0}", action);
                redirectToManagement(request, response, currentPage, searchQuery, "error", "Invalid action");
                return;
            }
            
            // Redirect back to course management with status message
            String status = success ? "success" : "error";
            redirectToManagement(request, response, currentPage, searchQuery, status, message);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error handling course ban/unban", e);
            redirectToManagement(request, response, currentPage, searchQuery, "error", "Có lỗi xảy ra: " + e.getMessage());
        }
    }
    
    /**
     * Redirect back to course management page with status message
     */
    private void redirectToManagement(HttpServletRequest request, HttpServletResponse response,
                                     String currentPage, String searchQuery, String status, String message) 
            throws IOException {
        
        StringBuilder url = new StringBuilder(request.getContextPath());
        url.append("/admin_coursemanagement.jsp?");
        
        if (currentPage != null && !currentPage.trim().isEmpty()) {
            url.append("page=").append(currentPage).append("&");
        }
        
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            url.append("search=").append(URLEncoder.encode(searchQuery, "UTF-8")).append("&");
        }
        
        url.append("status=").append(status);
        url.append("&message=").append(URLEncoder.encode(message, "UTF-8"));
        
        response.sendRedirect(url.toString());
    }
}
