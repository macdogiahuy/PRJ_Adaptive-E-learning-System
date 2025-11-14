package controller;

import com.coursehub.tools.DBSectionInserter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(urlPatterns = {"/instructor/assignments-by-course"})
public class AssignmentsByCourseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String courseId = req.getParameter("courseId");
        try (PrintWriter out = resp.getWriter()) {
            if (courseId == null || courseId.isBlank()) {
                out.print("[]");
                return;
            }

            List<DBSectionInserter.AssignmentItem> assigns = DBSectionInserter.getAssignmentsForCourse(courseId);
            StringBuilder sb = new StringBuilder();
            sb.append('[');
            boolean first = true;
            for (DBSectionInserter.AssignmentItem ai : assigns) {
                if (!first) sb.append(',');
                first = false;
                sb.append('{');
                sb.append("\"id\":\"").append(escapeJson(ai.id)).append("\"");
                sb.append(",\"name\":\"").append(escapeJson(ai.name)).append("\"");
                sb.append('}');
            }
            sb.append(']');
            out.print(sb.toString());
        } catch (Exception e) {
            resp.setStatus(500);
            resp.getWriter().print("[]");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}
