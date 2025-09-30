package controller;

import dao.CourseMarketDAO;
import dao.DBCourses;
import model.CoursesMarket;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/market")
public class CourseMarketServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (Connection conn = DBCourses.getConnection()) {
            CourseMarketDAO dao = new CourseMarketDAO(conn);
            List<CoursesMarket> courses = dao.getAllCourses();
            request.setAttribute("courses", courses);
        } catch (Exception e) {
            e.printStackTrace();
        }
       request.getRequestDispatcher("/WEB-INF/views/Pages/market.jsp").forward(request, response);
    }
}
