package controller;

import dao.CompletionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;

@WebServlet(name = "MarkCompleteServlet", urlPatterns = {"/mark-complete"})
public class MarkCompleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String lectureId = request.getParameter("lectureId");
        String courseId = request.getParameter("courseId");

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("account");

        // 🔹 Bảo vệ: chưa đăng nhập
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 🔹 Ghi tiến độ vào DB
        try {
            CompletionDAO completionDAO = new CompletionDAO();
            
            // Gọi hàm đã sửa, hàm này giờ đã an toàn
            completionDAO.markAsComplete(currentUser.getId(), lectureId);

            // [ĐÃ XÓA] Dòng Thread.sleep(100);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Lỗi khi lưu tiến độ: " + e.getMessage());
            return;
        }

        // 🔁 Quay lại trang học hiện tại (load lại từ DB)
        response.sendRedirect("course-player?courseId=" + courseId + "&lectureId=" + lectureId);
    }
}