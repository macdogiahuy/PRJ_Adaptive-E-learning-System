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
//import java.util.List;
//import model.McqChoices;
//import model.McqQuestions;
//
//@WebServlet(name = "TakeQuizServlet", urlPatterns = {"/take-quiz"})
//public class TakeQuizServlet extends HttpServlet {
//
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//
//        List<String> questionIds = (List<String>) session.getAttribute("quizQuestionIds");
//        Integer currentIndex = (Integer) session.getAttribute("currentQuestionIndex");
//
//        if (questionIds == null || currentIndex == null) {
//            response.sendRedirect("course-player?error=Phiên làm bài không hợp lệ");
//            return;
//        }
//
//        if (currentIndex >= questionIds.size()) {
//            response.sendRedirect("submit-quiz");
//            return;
//        }
//
//        String currentQuestionId = questionIds.get(currentIndex);
//
//        try {
//            QuizDAO quizDAO = new QuizDAO();
//            McqQuestions question = quizDAO.getQuestionById(currentQuestionId);
//            List<McqChoices> choices = quizDAO.getChoicesByQuestionId(currentQuestionId);
//
//            request.setAttribute("question", question);
//            request.setAttribute("choices", choices);
//            request.setAttribute("questionNumber", currentIndex + 1);
//            request.setAttribute("totalQuestions", questionIds.size());
//            String courseId = (String) session.getAttribute("returnCourseId");
//            String lectureId = (String) session.getAttribute("returnLectureId");
//
//            request.setAttribute("returnCourseId", courseId);
//            request.setAttribute("returnLectureId", lectureId);
//
//            request.getRequestDispatcher("take-quiz.jsp").forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect("course-player?error=Lỗi khi tải câu hỏi");
//        }
//    }
//}
