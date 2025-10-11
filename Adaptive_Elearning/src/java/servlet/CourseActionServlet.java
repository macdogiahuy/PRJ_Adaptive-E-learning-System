package servlet;

import controller.CourseManagementController;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 
 */
@WebServlet(name = "CourseActionServlet", urlPatterns = {"/courseAction"})
public class CourseActionServlet extends HttpServlet {
    
    private CourseManagementController controller = new CourseManagementController();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String courseId = request.getParameter("courseId");
        String redirectPage = request.getParameter("redirectPage");
        
        HttpSession session = request.getSession();
        
        try {
            if ("start".equals(action)) {
                boolean success = controller.startCourse(courseId);
                if (success) {
                    session.setAttribute("actionMessage", "Khóa học đã được bật thành công!");
                    session.setAttribute("actionSuccess", true);
                } else {
                    session.setAttribute("actionMessage", "Không thể bật khóa học. Vui lòng thử lại!");
                    session.setAttribute("actionSuccess", false);
                }
            } else if ("stop".equals(action)) {
                boolean success = controller.stopCourse(courseId);
                if (success) {
                    session.setAttribute("actionMessage", "Khóa học đã được tắt thành công!");
                    session.setAttribute("actionSuccess", true);
                } else {
                    session.setAttribute("actionMessage", "Không thể tắt khóa học. Vui lòng thử lại!");
                    session.setAttribute("actionSuccess", false);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("actionMessage", "Lỗi hệ thống: " + e.getMessage());
            session.setAttribute("actionSuccess", false);
        }
        
        // Redirect back to the course management page
        if (redirectPage != null && !redirectPage.isEmpty()) {
            response.sendRedirect(redirectPage);
        } else {
            response.sendRedirect("admin_coursemanagement.jsp");
        }
    }
}
