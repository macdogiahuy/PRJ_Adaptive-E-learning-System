package servlet;

import controller.CourseManagementController;
import controller.CourseManagementController.Course;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DetailServlet", urlPatterns = {"/course/detail"})
public class DetailServlet extends HttpServlet {
    private CourseManagementController courseController;

    @Override
    public void init() throws ServletException {
        courseController = new CourseManagementController();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseId = request.getParameter("id");

        if (courseId == null || courseId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Course ID is required.");
            return;
        }

        try {
            Course course = courseController.getCourseById(courseId);

            if (course == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Course not found.");
                return;
            }

            request.setAttribute("course", course);

            request.getRequestDispatcher("/WEB-INF/views/Pages/user/course-review.jsp")
                   .forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error while fetching course details.", e);
        }
    }
}