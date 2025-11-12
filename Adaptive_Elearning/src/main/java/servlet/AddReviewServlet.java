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
 * Servlet xử lý thêm review và rating cho khóa học
 */
@WebServlet(name = "AddReviewServlet", urlPatterns = {"/add-review"})
public class AddReviewServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AddReviewServlet.class.getName());
    private CourseReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        reviewDAO = new CourseReviewDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        LOGGER.log(Level.INFO, "=== ADD REVIEW REQUEST RECEIVED ===");
        
        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Get user from session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            LOGGER.log(Level.WARNING, "No session or user account found, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Users user = (Users) session.getAttribute("account");
        String userId = user.getId();
        
        LOGGER.log(Level.INFO, "User authenticated: UserID={0}, Username={1}", 
                  new Object[]{userId, user.getUserName()});
        
        // Get parameters from form
        String courseId = request.getParameter("courseId");
        String ratingStr = request.getParameter("rating");
        String content = request.getParameter("content");
        
        LOGGER.log(Level.INFO, "Form parameters: CourseID={0}, Rating={1}, Content length={2}", 
                  new Object[]{courseId, ratingStr, content != null ? content.length() : 0});
        
        // Validate input
        if (courseId == null || courseId.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "CourseID is null or empty");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        if (ratingStr == null || content == null || content.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Rating or content is missing");
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ đánh giá và nội dung!");
            response.sendRedirect(request.getContextPath() + "/detail?id=" + courseId);
            return;
        }
        
        try {
            int rating = Integer.parseInt(ratingStr);
            
            LOGGER.log(Level.INFO, "Parsed rating: {0}", rating);
            
            // Validate rating range
            if (rating < 1 || rating > 5) {
                LOGGER.log(Level.WARNING, "Invalid rating range: {0}", rating);
                session.setAttribute("errorMessage", "Đánh giá phải từ 1 đến 5 sao!");
                response.sendRedirect(request.getContextPath() + "/detail?id=" + courseId);
                return;
            }
            
            // Check if user has enrolled in the course
            LOGGER.log(Level.INFO, "Checking enrollment for user {0} in course {1}", 
                      new Object[]{userId, courseId});
            boolean hasEnrolled = reviewDAO.hasUserEnrolled(userId, courseId);
            LOGGER.log(Level.INFO, "Enrollment check result: {0}", hasEnrolled);
            
            if (!hasEnrolled) {
                session.setAttribute("errorMessage", "Bạn cần mua khóa học trước khi đánh giá!");
                response.sendRedirect(request.getContextPath() + "/detail?id=" + courseId);
                return;
            }
            
            // Check if user has already reviewed
            LOGGER.log(Level.INFO, "Checking if user has already reviewed");
            boolean hasReviewed = reviewDAO.hasUserReviewed(userId, courseId);
            LOGGER.log(Level.INFO, "Already reviewed check result: {0}", hasReviewed);
            
            if (hasReviewed) {
                session.setAttribute("errorMessage", "Bạn đã đánh giá khóa học này rồi!");
                response.sendRedirect(request.getContextPath() + "/detail?id=" + courseId);
                return;
            }
            
            // Save review
            LOGGER.log(Level.INFO, "Attempting to save review...");
            boolean success = reviewDAO.saveReview(userId, courseId, rating, content.trim());
            LOGGER.log(Level.INFO, "Save review result: {0}", success);
            
            if (success) {
                session.setAttribute("successMessage", "Cảm ơn bạn đã đánh giá khóa học!");
                LOGGER.log(Level.INFO, "Review added successfully: User={0}, Course={1}, Rating={2}", 
                          new Object[]{userId, courseId, rating});
            } else {
                session.setAttribute("errorMessage", "Có lỗi xảy ra khi lưu đánh giá. Vui lòng thử lại!");
                LOGGER.log(Level.SEVERE, "Failed to save review - saveReview returned false");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Đánh giá không hợp lệ!");
            LOGGER.log(Level.WARNING, "Invalid rating format", e);
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Có lỗi xảy ra. Vui lòng thử lại!");
            LOGGER.log(Level.SEVERE, "Error adding review", e);
            e.printStackTrace();
        }
        
        LOGGER.log(Level.INFO, "=== ADD REVIEW REQUEST COMPLETED ===");
        
        // Redirect back to course detail
        response.sendRedirect(request.getContextPath() + "/detail?id=" + courseId);
    }
}
