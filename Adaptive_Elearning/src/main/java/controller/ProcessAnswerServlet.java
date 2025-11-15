package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ProcessAnswerServlet", urlPatterns = {"/process-answer"})
public class ProcessAnswerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();

        String questionId = request.getParameter("questionId");
        String choiceId = request.getParameter("choiceId"); 

        List<String> questionIds = (List<String>) session.getAttribute("quizQuestionIds");
        Integer currentIndex = (Integer) session.getAttribute("currentQuestionIndex");
        Map<String, String> answers = (Map<String, String>) session.getAttribute("quizAnswers");

        if (questionIds == null || currentIndex == null || answers == null || questionId == null) {
            response.sendRedirect("course-player?error=Phiên làm bài không hợp lệ");
            return;
        }
        answers.put(questionId, choiceId);
        currentIndex++;    
        session.setAttribute("currentQuestionIndex", currentIndex);

        if (currentIndex < questionIds.size()) {
            response.sendRedirect("take-quiz");
        } else {
            response.sendRedirect("submit-quiz");
        }
    }
}