package servlet;

import dao.CourseReviewDAO;
import model.Users;

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
 * Servlet xử lý edit và delete review
 */
@WebServlet(name = "ManageReviewServlet", urlPatterns = {"/manage-review"})
public class ManageReviewServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ManageReviewServlet.class.getName());
    private CourseReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        reviewDAO = new CourseReviewDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Get user from session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Users user = (Users) session.getAttribute("account");
        String userId = user.getId();
        
        // Get parameters
        String action = request.getParameter("action");
        String reviewId = request.getParameter("reviewId");
        String courseId = request.getParameter("courseId");
        
        if (reviewId == null || courseId == null || action == null) {
            session.setAttribute("errorMessage", "Thiếu thông tin!");
            response.sendRedirect(request.getContextPath() + "/detail?id=" + courseId);
            return;
        }
        
        try {
            if ("edit".equals(action)) {
                handleEdit(request, session, userId, reviewId, courseId);
            } else if ("delete".equals(action)) {
                handleDelete(session, userId, reviewId);
            } else {
                session.setAttribute("errorMessage", "Hành động không hợp lệ!");
            }
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Có lỗi xảy ra. Vui lòng thử lại!");
            LOGGER.log(Level.SEVERE, "Error managing review", e);
        }
        
        response.sendRedirect(request.getContextPath() + "/detail?id=" + courseId);
    }

    private void handleEdit(HttpServletRequest request, HttpSession session, 
                           String userId, String reviewId, String courseId) {
        String ratingStr = request.getParameter("rating");
        String content = request.getParameter("content");
        
        if (ratingStr == null || content == null || content.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin!");
            return;
        }
        
        try {
            int rating = Integer.parseInt(ratingStr);
            
            if (rating < 1 || rating > 5) {
                session.setAttribute("errorMessage", "Đánh giá phải từ 1 đến 5 sao!");
                return;
            }
            
            boolean success = reviewDAO.updateReview(reviewId, userId, rating, content.trim());
            
            if (success) {
                session.setAttribute("successMessage", "Cập nhật đánh giá thành công!");
                LOGGER.log(Level.INFO, "Review updated: ID={0}, User={1}", 
                          new Object[]{reviewId, userId});
            } else {
                session.setAttribute("errorMessage", "Không thể cập nhật đánh giá. Bạn có thể không có quyền!");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Đánh giá không hợp lệ!");
            LOGGER.log(Level.WARNING, "Invalid rating format", e);
        }
    }

    private void handleDelete(HttpSession session, String userId, String reviewId) {
        boolean success = reviewDAO.deleteReview(reviewId, userId);
        
        if (success) {
            session.setAttribute("successMessage", "Xóa đánh giá thành công!");
            LOGGER.log(Level.INFO, "Review deleted: ID={0}, User={1}", 
                      new Object[]{reviewId, userId});
        } else {
            session.setAttribute("errorMessage", "Không thể xóa đánh giá. Bạn có thể không có quyền!");
        }
    }
}
