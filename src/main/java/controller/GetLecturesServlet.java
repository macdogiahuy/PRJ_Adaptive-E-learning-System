package controller;

import com.coursehub.tools.DBSectionInserter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/instructor/get-lectures")
public class GetLecturesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String courseId = req.getParameter("courseId");
        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            if (courseId == null || courseId.isBlank()) {
                out.print("[]");
                return;
            }
            
            try {
                List<DBSectionInserter.LectureItem> lectures = DBSectionInserter.getLecturesForCourse(courseId);
                StringBuilder sb = new StringBuilder();
                sb.append("[");
                boolean first = true;
                for (DBSectionInserter.LectureItem li : lectures) {
                    if (!first) sb.append(",");
                    first = false;
                    sb.append("{\"id\":\"").append(li.id).append("\",\"title\":\"")
                            .append(li.title == null ? "" : li.title.replace("\"", "\\\"")).append("\"}");
                }
                sb.append("]");
                out.print(sb.toString());
            } catch (SQLException e) {
                resp.setStatus(500);
                out.print("[]");
            }
        }
    }
}
