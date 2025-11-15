//package controller;
//
//import dao.QuizDAO;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.io.IOException;
//import java.net.URLEncoder;
//import java.nio.charset.StandardCharsets;
//import java.util.*;
//import model.McqChoices;
//import model.McqQuestions;
//import model.Submissions;
//
//@WebServlet(name = "SubmitQuizServlet", urlPatterns = {"/submit-quiz"})
//public class SubmitQuizServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//        QuizDAO quizDAO = new QuizDAO();
//
//        try {
//            String userId = (String) session.getAttribute("quizUserId");
//            String assignmentId = (String) session.getAttribute("quizAssignmentId");
//            Map<String, String> userAnswers = (Map<String, String>) session.getAttribute("quizAnswers");
//
//            if (userId == null || assignmentId == null || userAnswers == null) {
//                String msg = URLEncoder.encode("Phiên làm bài đã hết hạn", StandardCharsets.UTF_8);
//                response.sendRedirect("course-player?error=" + msg);
//                return;
//            }
//
//            // ✅ Tính điểm nội bộ (giữ nguyên, không ảnh hưởng hiển thị)
//            Map<String, String> correctAnswers = quizDAO.getCorrectAnswers(assignmentId);
//            int total = correctAnswers.size();
//            int score = 0;
//
//            for (Map.Entry<String, String> entry : userAnswers.entrySet()) {
//                String qid = entry.getKey();
//                String userChoice = entry.getValue();
//                String correctChoice = correctAnswers.get(qid);
//                if (userChoice != null && userChoice.equals(correctChoice)) {
//                    score++;
//                }
//            }
//            double mark = (double) score / total * 10.0;
//
//            Submissions submission = quizDAO.saveQuizResult(userId, assignmentId, mark, 60, userAnswers);
//
//            // ✅ Lấy danh sách câu hỏi và các lựa chọn
//            List<McqQuestions> questions = quizDAO.getFullQuestions(assignmentId);
//            Map<String, List<McqChoices>> choicesMap = new HashMap<>();
//
//            for (McqQuestions q : questions) {
//                choicesMap.put(q.getId(), quizDAO.getChoicesByQuestionId(q.getId()));
//            }
//
//            // ✅ Xóa session quiz (giữ nguyên)
//            session.removeAttribute("quizQuestionIds");
//            session.removeAttribute("currentQuestionIndex");
//            session.removeAttribute("quizAnswers");
//            session.removeAttribute("quizAssignmentId");
//            session.removeAttribute("quizUserId");
//
//            // ✅ Gửi dữ liệu sang JSP (KHÔNG gửi correctAnswers nữa)
//            request.setAttribute("submission", submission);
//            request.setAttribute("questions", questions);
//            request.setAttribute("choicesMap", choicesMap);
//            request.setAttribute("userAnswers", userAnswers);
//
//            String courseId = (String) session.getAttribute("returnCourseId");
//            String lectureId = (String) session.getAttribute("returnLectureId");
//
//            request.setAttribute("returnCourseId", courseId);
//            request.setAttribute("returnLectureId", lectureId);
//
//            // ✅ Forward sang trang review
//            request.getRequestDispatcher("quiz-review.jsp").forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            String msg = URLEncoder.encode("Lỗi khi nộp bài", StandardCharsets.UTF_8);
//            response.sendRedirect("course-player?error=" + msg);
//        }
//    }
//}
