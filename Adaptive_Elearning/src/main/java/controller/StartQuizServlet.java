//package controller;
//
//import dao.QuizDAO; // Import DAO chúng ta vừa tạo
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.io.IOException;
//import java.util.HashMap;
//import java.util.List;
//
//@WebServlet(name = "StartQuizServlet", urlPatterns = {"/start-quiz"})
//public class StartQuizServlet extends HttpServlet {
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String assignmentId = request.getParameter("assignmentId");
//        String courseId = request.getParameter("courseId");
//        String lectureId = request.getParameter("lectureId");
//
//        HttpSession session = request.getSession();
//        session.setAttribute("returnCourseId", courseId);
//        session.setAttribute("returnLectureId", lectureId);
//        
//        String userId = "820EF64F-8E25-4486-86E5-027D4FDDB31D";
//
//        try {
//            QuizDAO quizDAO = new QuizDAO();
//            List<String> questionIds = quizDAO.getQuestionIdsByAssignmentId(assignmentId);
//
//            if (questionIds == null || questionIds.isEmpty()) {
//                request.setAttribute("error", "Quiz không có câu hỏi");
//                request.getRequestDispatcher("course-player.jsp").forward(request, response);
//                return;
//            }
//
//            session.setAttribute("quizQuestionIds", questionIds);
//            session.setAttribute("currentQuestionIndex", 0);
//            session.setAttribute("quizAnswers", new HashMap<String, String>());
//            session.setAttribute("quizAssignmentId", assignmentId);
//            session.setAttribute("quizUserId", userId);
//
//            response.sendRedirect("take-quiz");
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("error", "Quiz không có câu hỏi");
//            request.getRequestDispatcher("course-player.jsp").forward(request, response);
//        }
//    }
//}
