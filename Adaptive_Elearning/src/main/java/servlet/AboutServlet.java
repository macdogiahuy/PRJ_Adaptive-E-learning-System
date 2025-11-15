package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet for handling About page requests
 */
@WebServlet("/about")
public class AboutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set page title and meta information
        request.setAttribute("pageTitle", "Về chúng tôi - FlyUp");
        request.setAttribute("pageDescription", "Tìm hiểu về FlyUp - nền tảng học trực tuyến hàng đầu Việt Nam");
        
        // Forward to about page
        request.getRequestDispatcher("/WEB-INF/views/Pages/about.jsp").forward(request, response);
    }
}