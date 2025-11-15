package controller;

import client.CatApiClient;
import com.google.gson.*;
import dao.CatResultsDAO;
import dao.CompletionDAO;
import dao.QuizDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "AdaptiveQuizServlet", urlPatterns = {"/adaptive-quiz"})
public class AdaptiveQuizServlet extends HttpServlet {

    private CatApiClient catApi;
    private QuizDAO quizDAO = new QuizDAO();
    private CatResultsDAO resultsDAO = new CatResultsDAO();
    private CompletionDAO completionDAO = new CompletionDAO();

    @Override
    public void init() throws ServletException {
        super.init();
        catApi = new CatApiClient("http://127.0.0.1:5000");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        process(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        process(req, resp);
    }

    private List<Map<String, String>> parseChoices(JsonArray arr) {
        List<Map<String, String>> list = new ArrayList<>();

        if (arr == null) {
            return list;
        }

        for (JsonElement el : arr) {
            JsonObject c = el.getAsJsonObject();
            Map<String, String> map = new HashMap<>();
            map.put("Id", c.get("Id").getAsString());
            map.put("Content", c.get("Content").getAsString());
            list.add(map);
        }

        return list;
    }

    @SuppressWarnings("unchecked")
    private void process(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String action = Optional.ofNullable(req.getParameter("action")).orElse("start");

        model.Users account = (model.Users) session.getAttribute("account");
        if (account == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String userId = account.getId();

        String courseId = Optional.ofNullable(req.getParameter("courseId"))
                .orElse((String) session.getAttribute("cat_courseId"));

        String assignmentId = Optional.ofNullable(req.getParameter("assignmentId"))
                .orElse((String) session.getAttribute("cat_assignmentId"));

        if (courseId == null || assignmentId == null) {
            resp.getWriter().println("Thiếu courseId / assignmentId.");
            return;
        }

        List<String> answered = (List<String>) session.getAttribute("cat_answered");
        List<Integer> responses = (List<Integer>) session.getAttribute("cat_responses");
        Double currentTheta = (Double) session.getAttribute("cat_theta");

        if (answered == null) {
            answered = new ArrayList<>();
        }
        if (responses == null) {
            responses = new ArrayList<>();
        }
        if (currentTheta == null) {
            currentTheta = 0.0;
        }

        switch (action) {
            // =================== START QUIZ ===================
            case "start": {
                session.setAttribute("cat_courseId", courseId);
                session.setAttribute("cat_assignmentId", assignmentId);
                session.setAttribute("cat_answered", new ArrayList<>());
                session.setAttribute("cat_responses", new ArrayList<>());
                session.setAttribute("cat_theta", 0.0);
                session.setAttribute("cat_userAnswers", new HashMap<String, String>());
                session.setAttribute("cat_startTime", System.currentTimeMillis());

                JsonObject res = catApi.nextQuestion(
                        userId, courseId, assignmentId, 0.0,
                        new ArrayList<>(), new ArrayList<>()
                );
                
                int durationInMinutes = completionDAO.getAssignmentDuration(assignmentId);
                
                int durationInSeconds;
                if (durationInMinutes > 0) {
                    durationInSeconds = durationInMinutes * 60;
                } else {
                    durationInSeconds = 1800; 
                    System.out.println("[WARN] Không tìm thấy duration, set mặc định 30 phút.");
                }

                JsonObject nq = res.getAsJsonObject("next_question");
                JsonArray choicesArr = nq.getAsJsonArray("choices");
                List<Map<String, String>> choices = parseChoices(choicesArr);

                req.setAttribute("questionId", nq.get("question_id").getAsString());
                req.setAttribute("questionContent", nq.get("content").getAsString());
                req.setAttribute("choices", choices);
                req.setAttribute("tempTheta", res.has("temp_theta")
                        ? res.get("temp_theta").getAsDouble() : 0.0);
                req.setAttribute("questionNumber", 1);
                req.setAttribute("durationInSeconds", durationInSeconds);

                req.getRequestDispatcher("take-quiz.jsp").forward(req, resp);
                return;
            }

            // =================== ANSWER QUESTION ===================
            case "answer": {
                String choiceId = req.getParameter("choiceId");
                if (choiceId == null) {
                    resp.getWriter().println("Thiếu choiceId.");
                    return;
                }

                String questionId = req.getParameter("questionId");
                boolean isCorrect = false;

                if (questionId != null && choiceId != null) {
                    String correctChoiceId = quizDAO.getCorrectChoiceForQuestion(questionId);
                    isCorrect = choiceId.equals(correctChoiceId);

                    System.out.println("[CHECK] DB Compare → QID=" + questionId
                            + " | userChoice=" + choiceId
                            + " | correctChoice=" + correctChoiceId
                            + " | result=" + (isCorrect ? "✅" : "❌"));
                } else {
                    System.out.println("[WARN] Missing questionId or choiceId → cannot check correctness");
                }
                Map<String, String> userAnswers = (Map<String, String>) session.getAttribute("cat_userAnswers");
                if (userAnswers == null) {
                    userAnswers = new HashMap<>(); // Đề phòng
                }
                userAnswers.put(questionId, choiceId);
                session.setAttribute("cat_userAnswers", userAnswers);

                answered.add(questionId);
                responses.add(isCorrect ? 1 : 0);

                session.setAttribute("cat_answered", answered);
                session.setAttribute("cat_responses", responses);

                System.out.println("📤 Sending to API: responses = " + responses);
                System.out.println("📤 answered = " + answered);

                JsonObject res = catApi.nextQuestion(
                        userId, courseId, assignmentId,
                        currentTheta,
                        answered,
                        Collections.singletonList(isCorrect ? 1 : 0)
                );

                req.setAttribute("debugAnswered", answered.size());

                if (res.has("message")
                        && res.get("message").getAsString().toLowerCase().contains("completed")) {
                    System.out.println("Quiz completed — redirecting to finish...");
                    resp.sendRedirect(req.getContextPath() + "/adaptive-quiz?action=finish");
                    return;
                }

                if (res.has("temp_theta")) {
                    currentTheta = res.get("temp_theta").getAsDouble();
                }
                session.setAttribute("cat_theta", currentTheta);

                JsonObject nq = res.getAsJsonObject("next_question");
                JsonArray choicesArr = nq.getAsJsonArray("choices");
                List<Map<String, String>> choices = parseChoices(choicesArr);

                req.setAttribute("questionId", nq.get("question_id").getAsString());
                req.setAttribute("questionContent", nq.get("content").getAsString());
                req.setAttribute("choices", choices);
                req.setAttribute("tempTheta", currentTheta);
                req.setAttribute("questionNumber", answered.size() + 1);

                req.getRequestDispatcher("take-quiz.jsp").forward(req, resp);
                return;
            }

            // =================== FINISH QUIZ ===================
            case "finish": {
                List<String> sessionAnswered = (List<String>) session.getAttribute("cat_answered");
                List<Integer> sessionResponses = (List<Integer>) session.getAttribute("cat_responses");

                if (sessionAnswered == null) {
                    sessionAnswered = new ArrayList<>();
                }
                if (sessionResponses == null) {
                    sessionResponses = new ArrayList<>();
                }

                System.out.println("🔹 [CAT] Submitting quiz...");
                System.out.println("   answered questions = " + sessionAnswered.size());
                System.out.println("   responses = " + sessionResponses.size());

                JsonObject res = catApi.submit(
                        userId,
                        courseId,
                        assignmentId,
                        sessionAnswered,
                        sessionResponses,
                        0.2
                );

                int correct = res.has("correct") ? res.get("correct").getAsInt() : 0;
                int total = res.has("total") ? res.get("total").getAsInt() : sessionAnswered.size();

                double mark = (double) correct / (total > 0 ? total : 1) * 10.0;
                System.out.println("📊 Calculated mark = " + mark);

               int durationInSeconds = 60; // Giá trị mặc định nếu không tìm thấy
                Long startTime = (Long) session.getAttribute("cat_startTime");

                if (startTime != null) {
                    long endTime = System.currentTimeMillis();
                    long durationInMillis = endTime - startTime;
                    durationInSeconds = (int) (durationInMillis / 1000); // Đổi sang giây
                } else {
                    System.err.println("[CAT_WARN] Không tìm thấy 'cat_startTime' trong session. Đặt mặc định 60s.");
                }

                Map<String, String> userAnswers = (Map<String, String>) session.getAttribute("cat_userAnswers");
                if (userAnswers == null) {
                    userAnswers = new HashMap<>();
                }

                quizDAO.saveQuizResult(userId, assignmentId, mark, durationInSeconds, userAnswers);
                
                int minutes = durationInSeconds / 60;
                int seconds = durationInSeconds % 60;
                String formattedDuration = String.format("%02d:%02d", minutes, seconds);

                int rank = resultsDAO.getAssignmentRank(assignmentId, userId);
                int totalParticipants = resultsDAO.getAssignmentTotalParticipants(assignmentId);

                jakarta.persistence.EntityManager em = utils.JPAUtils.getEntityManager();
                model.Assignments assignment = em.find(model.Assignments.class, assignmentId);
                double gradeToPass = assignment != null ? assignment.getGradeToPass() : 5.0;
                em.close();

                boolean passed = mark >= gradeToPass;
                System.out.println("🎯 GradeToPass = " + gradeToPass + " → Passed = " + passed);
                if (passed) {
                try {
                    // Lấy assignmentId từ session (vì nó vẫn còn đó)
                    String assignIdToMark = (String) session.getAttribute("cat_assignmentId");
                    
                    if (assignIdToMark != null) {
                        completionDAO.markAssignmentAsComplete(userId, assignIdToMark);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    System.err.println("Lỗi khi tự động đánh dấu hoàn thành assignment: " + e.getMessage());
                }
            }

                req.setAttribute("correct", correct);
                req.setAttribute("total", total);
                req.setAttribute("mark", String.format("%.2f", mark));
                req.setAttribute("gradeToPass", gradeToPass);
                req.setAttribute("passed", passed);
                req.setAttribute("rank", rank);
                req.setAttribute("totalParticipants", totalParticipants);
                req.setAttribute("formattedDuration", formattedDuration);

                List<Map<String, Object>> history = quizDAO.getSubmissionHistory(userId, assignmentId);
                req.setAttribute("history", history);

                session.removeAttribute("cat_answered");
                session.removeAttribute("cat_responses");
                session.removeAttribute("cat_theta");
                session.removeAttribute("cat_userAnswers");

                req.getRequestDispatcher("quiz-review.jsp").forward(req, resp);
                return;
            }
        }
    }
}
