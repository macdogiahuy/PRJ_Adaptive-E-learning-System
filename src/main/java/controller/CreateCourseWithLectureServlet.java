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

/**
 * Servlet to create a new Course + Section + Lecture in one transaction
 * with instructor filtering (deprecated - use CreateCourseWithSectionAndLectureServlet instead)
 */
@WebServlet(name = "CreateCourseWithLectureServlet", urlPatterns = {"/instructor/create-course-with-lecture-old"})
public class CreateCourseWithLectureServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String courseName = request.getParameter("courseName");
            String sectionName = request.getParameter("sectionName");
            String lectureName = request.getParameter("lectureName");

            // Validate inputs
            if (courseName == null || courseName.trim().isEmpty() ||
                sectionName == null || sectionName.trim().isEmpty() ||
                lectureName == null || lectureName.trim().isEmpty()) {
                out.println("{\"success\":false,\"message\":\"All fields are required\"}");
                return;
            }

            // Check if user is logged in
            model.Users currentUser = (model.Users) request.getSession().getAttribute("account");
            if (currentUser == null || currentUser.getId() == null) {
                out.println("{\"success\":false,\"message\":\"Unauthorized\"}");
                return;
            }

            // Check if user has an instructor ID
            String instructorId = currentUser.getInstructorId();
            if (instructorId == null || instructorId.isBlank()) {
                out.println("{\"success\":false,\"message\":\"User is not an instructor\"}");
                return;
            }

            try {
                // Generate UUIDs for course, section, lecture
                String courseId = UUID.randomUUID().toString();
                String sectionId = UUID.randomUUID().toString();
                String lectureId = UUID.randomUUID().toString();

                // Create course + section + lecture with instructor and creator IDs
                DBSectionInserter.createCourseWithSectionAndLecture(
                    courseId, courseName, sectionId, sectionName, lectureId, lectureName,
                    instructorId,           // InstructorId from user's instructor record
                    currentUser.getId()     // CreatorId (user who created)
                );

                out.println("{\"success\":true,\"courseId\":\"" + courseId + "\",\"sectionId\":\"" + sectionId + "\",\"lectureId\":\"" + lectureId + "\"}");

            } catch (SQLException e) {
                e.printStackTrace();
                out.println("{\"success\":false,\"message\":\"" + e.getMessage().replace("\"", "'") + "\"}");
            }
        }
    }
}
