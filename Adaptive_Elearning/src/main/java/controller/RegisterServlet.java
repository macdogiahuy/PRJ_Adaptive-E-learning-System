package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.Users;
import dao.UserDAO;
import utils.EmailHelper;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;
    private EmailHelper emailHelper = new EmailHelper();

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("showForm", "register");
        request.getRequestDispatcher("/WEB-INF/views/Pages/user/auth.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username").trim();
        String email = request.getParameter("email").trim();
        String password = request.getParameter("password").trim();
        String rePassword = request.getParameter("repassword").trim();

        if (username.isEmpty() || email.isEmpty() || password.isEmpty()) {
            request.setAttribute("alertStatus", false);
            request.setAttribute("alertMessage", "All fields are required!");
            request.setAttribute("showForm", "register");
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/auth.jsp").forward(request, response);
            return;
        }

        if (!password.equals(rePassword)) {
            request.setAttribute("alertStatus", false);
            request.setAttribute("alertMessage", "Password and RePassword don't match!");
            request.setAttribute("showForm", "register");
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/auth.jsp").forward(request, response);
            return;
        }

        Users newUser = new Users();
        newUser.setUserName(username);
        newUser.setEmail(email);
        newUser.setPassword(password);

        boolean success = userDAO.registerUser(newUser);

        if (success) {
            try {
                String subject = "🎉 Welcome to CourseHub!";
                String body = "Hi " + username + ",\n\nThank you for registering at CourseHub.\n\nBest regards,\nCourseHub Team";
                emailHelper.sendMail(email, subject, body);
                request.setAttribute("alertStatus", true);
                request.setAttribute("alertMessage", "Register successful! Please login.");
                request.setAttribute("showForm", "login");
                request.getRequestDispatcher("/WEB-INF/views/Pages/user/auth.jsp").forward(request, response);
            } catch (Exception ex) {
                request.setAttribute("alertMessage", "We couldn't send the email. Please try again later.");
                request.setAttribute("alertStatus", false);
                request.setAttribute("showForm", "register");
                request.getRequestDispatcher("/WEB-INF/views/Pages/user/auth.jsp").forward(request, response);
            }

        } else {
            request.setAttribute("alertStatus", false);
            request.setAttribute("alertMessage", "Username or Email already exists!");
            request.setAttribute("showForm", "register");
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/auth.jsp").forward(request, response);
        }
    }
}
