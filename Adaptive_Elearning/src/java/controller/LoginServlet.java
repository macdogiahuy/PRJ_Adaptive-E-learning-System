package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;
import userDAO.UserDAO;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
     UserDAO userDAO = new UserDAO();
    

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
        //login với database
        User us = userDAO.checkLogin(username, password);

        if (us != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", us.getUserName()); 
            session.setAttribute("role", us.getRole());

            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("alertMessage", "Invalid username or password!");
            request.setAttribute("alertStatus", false);
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/Pages/user/login.jsp").forward(request, response);
    }
}
