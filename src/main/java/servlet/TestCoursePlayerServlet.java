package servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Simple test servlet for course player UI
 */
@WebServlet(name = "TestCoursePlayerServlet", urlPatterns = {"/test-course-player"})
public class TestCoursePlayerServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Always forward to JSP in test mode (no data)
        request.getRequestDispatcher("/WEB-INF/views/Pages/user/course-player.jsp").forward(request, response);
    }
}