package controller;

import dao.CourseDAO;
import dao.DBCourses;
import model.Courses;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/Courses")
public class CoursesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = DBCourses.getConnection()) {
            CourseDAO dao = new CourseDAO(conn);
            List<Courses> courses = dao.getAllCourses();
            request.setAttribute("courses", courses);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // nhớ check đúng tên file JSP
        request.getRequestDispatcher("/WEB-INF/views/Pages/courses.jsp").forward(request, response);
    }
}
