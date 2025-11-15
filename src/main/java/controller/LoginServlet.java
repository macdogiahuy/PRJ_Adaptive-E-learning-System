package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Users;
import dao.UserDAO;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("remember");

        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("alertMessage", "Please enter username and password.");
            request.setAttribute("alertStatus", false);
            request.setAttribute("showForm", "login");
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/auth.jsp").forward(request, response);
            return;
        }

        Users user = userDAO.checkLogin(username, password);

        if (user != null) {
            System.out.println("[LoginServlet] Logged in as: " + user.getUserName());
            HttpSession session = request.getSession();
            session.setAttribute("account", user);
            session.setAttribute("role", user.getRole());

            if ("yes".equalsIgnoreCase(rememberMe)) {
                Cookie usernameCookie = new Cookie("username", username);
                usernameCookie.setMaxAge(30 * 24 * 60 * 60);
                usernameCookie.setPath("/");
                response.addCookie(usernameCookie);
            }

            String role = user.getRole();

            switch (role) {
                case "Admin":
                    response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
                    break;

                case "Instructor":
                    response.sendRedirect(request.getContextPath() + "/home");
                    break;

                case "Learner":
                    response.sendRedirect(request.getContextPath() + "/home");
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/home");
                    break;
            }

        } else {
            request.setAttribute("alertMessage", "Invalid username or password!");
            request.setAttribute("alertStatus", false);
            request.setAttribute("showForm", "login");
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/auth.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    request.setAttribute("username", cookie.getValue());
                }
            }
        }

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            Users user = (Users) session.getAttribute("currentUser");
            String role = user.getRole();
            switch (role) {
                case "Admin":
                    response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
                    return;
                case "Instructor":
                    response.sendRedirect(request.getContextPath() + "/instructor/upload-form.jsp");
                    return;
                case "Learner":
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
            }
        }

        request.setAttribute("showForm", "login");
        request.getRequestDispatcher("/WEB-INF/views/Pages/user/auth.jsp").forward(request, response);
    }
}
