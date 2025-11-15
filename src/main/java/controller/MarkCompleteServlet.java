package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Import
import java.io.IOException;
import java.util.ArrayList; // Import
import java.util.List; // Import

@WebServlet(name = "MarkCompleteServlet", urlPatterns = {"/mark-complete"})
public class MarkCompleteServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String lectureId = request.getParameter("lectureId");
        String courseId = request.getParameter("courseId");
        
        // 1. Lấy session hiện tại
        HttpSession session = request.getSession();

        // 2. Lấy danh sách đã hoàn thành từ session
        List<String> completedLectures = (List<String>) session.getAttribute("completedLectures");

        // 3. Nếu list chưa tồn tại, tạo mới
        if (completedLectures == null) {
            completedLectures = new ArrayList<>();
        }

        // 4. Thêm ID bài học này vào list
        if (!completedLectures.contains(lectureId)) {
            completedLectures.add(lectureId);
        }

        // 5. Lưu list mới TRỞ LẠI vào session
        session.setAttribute("completedLectures", completedLectures);
        
        // 6. Redirect người dùng quay lại (chuyển sang bài tiếp theo)
        // (Tạm thời, chúng ta redirect về chính bài đó)
        // ** NÂNG CAO: ** Bạn có thể thêm logic ở đây để tìm bài học tiếp theo và redirect sang
        response.sendRedirect("course-player?courseId=" + courseId + "&lectureId=" + lectureId);
    }
}