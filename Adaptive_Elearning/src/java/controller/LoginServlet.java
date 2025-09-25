package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    
    private static final String ADMIN_USER = "admin";
    private static final String ADMIN_PASS = "1";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null) {
            request.setAttribute("alertMessage", "Please enter username and password.");
            request.setAttribute("alertStatus", false);
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/login.jsp").forward(request, response);
            return;
        }

        if (username.equals(ADMIN_USER) && password.equals(ADMIN_PASS)) {
            // Đăng nhập thành công 
            HttpSession session = request.getSession();
            session.setAttribute("user", username);

           response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            // Sai tài khoản/mật khẩu
            request.setAttribute("alertMessage", "Invalid username or password!");
            request.setAttribute("alertStatus", false);
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu user đã login → chuyển dashboard luôn
        request.getRequestDispatcher("/WEB-INF/views/Pages/user/login.jsp").forward(request, response);
    }
}
