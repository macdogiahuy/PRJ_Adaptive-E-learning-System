package servlet;

import model.Users;
import services.CourseApprovalService;
import services.CourseApprovalService.ServiceResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for handling course approval/rejection by admin
 * @author LP
 */
@WebServlet(urlPatterns = {"/admin/course-approval"})
public class AdminCourseApprovalServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(AdminCourseApprovalServlet.class.getName());
    private CourseApprovalService approvalService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        approvalService = new CourseApprovalService();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("account") : null;
        
        // Check if user is logged in and is admin
        if (user == null || !"Admin".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized access");
            return;
        }
        
        String action = request.getParameter("action");
        String notificationId = request.getParameter("notificationId");
        
        if (notificationId == null || notificationId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing notification ID");
            return;
        }
        
        try {
            ServiceResult result = null;
            
            switch (action != null ? action : "") {
                case "approve":
                    result = handleApproveCourse(notificationId, user.getId());
                    break;
                    
                case "reject":
                    String rejectionReason = request.getParameter("rejectionReason");
                    if (rejectionReason == null || rejectionReason.trim().isEmpty()) {
                        session.setAttribute("errorMessage", "Vui lòng nhập lý do từ chối khóa học");
                        response.sendRedirect(request.getContextPath() + "/admin_notification.jsp");
                        return;
                    }
                    result = handleRejectCourse(notificationId, user.getId(), rejectionReason);
                    break;
                    
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    return;
            }
            
            // Set result message
            if (result != null) {
                if (result.isSuccess()) {
                    session.setAttribute("successMessage", result.getMessage());
                    LOGGER.log(Level.INFO, "Course {0} by admin: {1}", 
                              new Object[]{action, user.getId()});
                } else {
                    session.setAttribute("errorMessage", result.getMessage());
                    LOGGER.log(Level.WARNING, "Failed to {0} course: {1}", 
                              new Object[]{action, result.getMessage()});
                }
            }
            
            // Redirect back to notification page
            response.sendRedirect(request.getContextPath() + "/admin_notification.jsp");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing course approval", e);
            session.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin_notification.jsp");
        }
    }
    
    /**
     * Handle approve course action
     */
    private ServiceResult handleApproveCourse(String notificationId, String adminId) {
        LOGGER.log(Level.INFO, "Approving course notification: {0} by admin: {1}", 
                  new Object[]{notificationId, adminId});
        
        return approvalService.approveCourse(notificationId, adminId);
    }
    
    /**
     * Handle reject course action
     */
    private ServiceResult handleRejectCourse(String notificationId, String adminId, String rejectionReason) {
        LOGGER.log(Level.INFO, "Rejecting course notification: {0} by admin: {1}. Reason: {2}", 
                  new Object[]{notificationId, adminId, rejectionReason});
        
        return approvalService.rejectCourse(notificationId, adminId, rejectionReason);
    }
    
    @Override
    public String getServletInfo() {
        return "Admin Course Approval Servlet";
    }
}
