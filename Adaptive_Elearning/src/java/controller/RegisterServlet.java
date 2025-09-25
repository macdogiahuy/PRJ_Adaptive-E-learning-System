package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị trang Register.jsp khi gọi GET
        request.getRequestDispatcher("/WEB-INF/views/Pages/user/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String rePassword = request.getParameter("repassword");

        // Vá lì đây
        if(username == null || username.isEmpty() ||
           email == null || email.isEmpty() ||
           password == null || password.isEmpty()) {
            request.setAttribute("alertStatus", false);
            request.setAttribute("alertMessage", "All fields are required!");
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/register.jsp").forward(request, response);
            return;
        }

        if(!password.equals(rePassword)) {
            request.setAttribute("alertStatus", false);
            request.setAttribute("alertMessage", "Password and RePassword don't match!");
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/register.jsp").forward(request, response);
            return;
        }

        
        boolean isSaved = true; 

        if(isSaved) {
            request.setAttribute("alertStatus", true);
            request.setAttribute("alertMessage", "Please login again");
        } else {
            request.setAttribute("alertStatus", false);
            request.setAttribute("alertMessage", "Cannot register!");
        }

        
        request.getRequestDispatcher("/WEB-INF/views/Pages/user/login.jsp").forward(request, response);
    }
}
