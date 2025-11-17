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

@WebServlet("/instructor/create-course-with-lecture")
public class CreateCourseWithSectionAndLectureServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String courseName = req.getParameter("courseName");
        String sectionName = req.getParameter("sectionName");
        String lectureName = req.getParameter("lectureName");

        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            if (courseName == null || courseName.isBlank() || sectionName == null || sectionName.isBlank() 
                    || lectureName == null || lectureName.isBlank()) {
                out.print("{\"success\":false,\"message\":\"Missing parameters\"}");
                return;
            }

            // Check if user is logged in
            model.Users currentUser = (model.Users) req.getSession().getAttribute("account");
            if (currentUser == null || currentUser.getId() == null) {
                out.print("{\"success\":false,\"message\":\"Unauthorized\"}");
                return;
            }

            // Check if user has an instructor ID (is an instructor)
            String instructorId = currentUser.getInstructorId();
            if (instructorId == null || instructorId.isBlank()) {
                out.print("{\"success\":false,\"message\":\"User is not an instructor\"}");
                return;
            }

            try {
                // Generate new UUIDs for course, section, lecture
                String courseId = UUID.randomUUID().toString();
                String sectionId = UUID.randomUUID().toString();
                String lectureId = UUID.randomUUID().toString();

                // Create course + section + lecture with instructor's ID and user ID as CreatorId
                DBSectionInserter.createCourseWithSectionAndLecture(
                    courseId, courseName,
                    sectionId, sectionName,
                    lectureId, lectureName,
                    instructorId,           // InstructorId from user's instructor record
                    currentUser.getId()     // CreatorId (user who created)
                );

                out.print("{\"success\":true,\"courseId\":\"" + courseId + "\",\"lectureId\":\"" + lectureId + "\"}");
            } catch (SQLException e) {
                e.printStackTrace();
                out.print("{\"success\":false,\"message\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
}
        }
    }
}