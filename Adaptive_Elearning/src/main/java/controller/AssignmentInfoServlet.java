package controller;

import dao.LectureDAO;
import dao.QuizDAO;
import model.Assignments;
import model.Lectures;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AssignmentInfoServlet", urlPatterns = {"/assignment-info"})
public class AssignmentInfoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String assignmentId = request.getParameter("assignmentId");

        if (assignmentId == null || assignmentId.isBlank()) {
            response.sendRedirect("course-player?error=Thiếu mã bài tập");
            return;
        }

        try {
            // ✅ Lấy thông tin người dùng đăng nhập
            HttpSession session = request.getSession();
            Users account = (Users) session.getAttribute("account");

            if (account == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String userId = account.getId(); // ✅ Lấy userId thật

            QuizDAO quizDAO = new QuizDAO();
            LectureDAO lectureDAO = new LectureDAO();

            Assignments assignment = quizDAO.getAssignmentById(assignmentId);
            if (assignment == null) {
                response.sendRedirect("course-player?error=Không tìm thấy bài tập");
                return;
            }

            int questionCount = quizDAO.countQuestionsByAssignment(assignmentId);

            String courseId = null;
            String lectureId = null;

            if (assignment.getSectionId() != null) {
                if (assignment.getSectionId().getCourseId() != null) {
                    courseId = assignment.getSectionId().getCourseId().getId();
                }

                String sectionId = assignment.getSectionId().getId();
                List<Lectures> lectures = lectureDAO.getLecturesBySectionId(sectionId);

                if (lectures != null && !lectures.isEmpty()) {
                    lectureId = lectures.get(0).getId();
                } else {
                    System.out.println("Không tìm thấy lecture nào trong section " + sectionId);
                }
            }

            System.out.println("🎯 [AssignmentInfoServlet] courseId=" + courseId + ", lectureId=" + lectureId);

            request.setAttribute("assignment", assignment);
            request.setAttribute("questionCount", questionCount);
            request.setAttribute("courseId", courseId);
            request.setAttribute("lectureId", lectureId);

            List<Map<String, Object>> history = quizDAO.getSubmissionHistory(userId, assignmentId);
            request.setAttribute("history", history);

            request.getRequestDispatcher("assignment-info.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("course-player?error=Lỗi tải thông tin bài tập");
        }
    }
}
