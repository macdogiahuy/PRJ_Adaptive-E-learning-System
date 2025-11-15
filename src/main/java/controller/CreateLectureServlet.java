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
import java.util.UUID;

@WebServlet("/instructor/create-lecture")
public class CreateLectureServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String courseId = req.getParameter("courseId");
        String sectionId = req.getParameter("sectionId");
        String title = req.getParameter("title");

        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            if (courseId == null || courseId.isBlank() || sectionId == null || sectionId.isBlank() || title == null || title.isBlank()) {
                out.print("{\"success\":false,\"message\":\"Missing parameters\"}");
                return;
            }

            // Check if instructor owns this course
            model.Users currentUser = (model.Users) req.getSession().getAttribute("account");
            if (currentUser == null || currentUser.getId() == null) {
                out.print("{\"success\":false,\"message\":\"Unauthorized\"}");
                return;
            }

            try {
                // Validate GUIDs
                UUID.fromString(courseId);
                UUID.fromString(sectionId);
            } catch (IllegalArgumentException ex) {
                out.print("{\"success\":false,\"message\":\"Invalid GUID format\"}");
                return;
            }

            try {
                // Verify course belongs to instructor
                String courseInstructor = DBSectionInserter.getCourseInstructorId(courseId);
                if (courseInstructor == null || !courseInstructor.equals(currentUser.getId())) {
                    out.print("{\"success\":false,\"message\":\"Unauthorized\"}");
                    return;
                }

                String newLectureId = UUID.randomUUID().toString();
                DBSectionInserter.insertLecture(newLectureId, title, "", sectionId);
                out.print("{\"success\":true,\"lectureId\":\"" + newLectureId + "\"}");
            } catch (SQLException e) {
                out.print("{\"success\":false,\"message\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
            }
        }
    }
}
