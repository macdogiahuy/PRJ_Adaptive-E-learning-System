package controller;

import dao.QuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

// 1. Đặt một URL pattern mới
@WebServlet(name = "QuizReviewServlet", urlPatterns = {"/quiz-review"})
public class QuizReviewServlet extends HttpServlet {

    // 2. Khởi tạo DAO
    private QuizDAO quizDAO = new QuizDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // 3. Lấy thông tin user (để bảo mật)
        HttpSession session = req.getSession();
        model.Users account = (model.Users) session.getAttribute("account");

        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String userId = account.getId();
        
        // 4. Lấy submissionId từ link (URL)
        String submissionId = req.getParameter("submissionId");
        
        if (submissionId == null || submissionId.isEmpty()) {
            resp.getWriter().println("Thiếu Submission ID.");
            return;
        }

        model.Submissions submission = 
            quizDAO.getSubmissionForReview(submissionId, userId);

        if (submission == null) {
            resp.getWriter().println("Không tìm thấy bài nộp hoặc bạn không có quyền xem.");
            return;
        }
        
        // 6. Gửi dữ liệu qua trang JSP
        req.setAttribute("submission", submission);
        req.getRequestDispatcher("view-review-detail.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Có thể không cần doPost, nhưng để an toàn thì cứ forward sang doGet
        doGet(req, resp);
    }
}