package servlet;

import controller.UsersJpaController;
import java.io.IOException;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Users;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null || user.getId() == null) {
            // Not logged-in: set flash and redirect to profile (user asked to postpone login)
            request.getSession().setAttribute("errorMessage", "You must be logged in to change your password.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/Pages/user/change_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null || user.getId() == null) {
            request.getSession().setAttribute("errorMessage", "You must be logged in to change your password.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        String current = request.getParameter("currentPassword");
        String next = request.getParameter("newPassword");
        String confirm = request.getParameter("confirmPassword");

        // basic validations
        if (current == null || current.isEmpty()) {
            request.setAttribute("errorMessage", "Current password is required.");
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/change_password.jsp").forward(request, response);
            return;
        }
        if (next == null || next.length() < 6) {
            request.setAttribute("errorMessage", "New password must be at least 6 characters.");
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/change_password.jsp").forward(request, response);
            return;
        }
        if (!next.equals(confirm)) {
            request.setAttribute("errorMessage", "New password and confirmation do not match.");
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/change_password.jsp").forward(request, response);
            return;
        }

        // strength recommendation: uppercase, lowercase, digit
        boolean hasUpper = next.matches(".*[A-Z].*");
        boolean hasLower = next.matches(".*[a-z].*");
        boolean hasDigit = next.matches(".*[0-9].*");
        if (!hasUpper || !hasLower || !hasDigit) {
            request.setAttribute("errorMessage", "Password should contain uppercase, lowercase letters and numbers for better security.");
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/change_password.jsp").forward(request, response);
            return;
        }

        // verify current password matches stored password (assume stored as SHA-256 hex)
        String hashedCurrent = hashPassword(current);
        if (user.getPassword() == null || !user.getPassword().equals(hashedCurrent)) {
            request.setAttribute("errorMessage", "Current password is incorrect.");
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/change_password.jsp").forward(request, response);
            return;
        }

        // set new password (hash) and persist
        user.setPassword(hashPassword(next));
        UsersJpaController usersCtrl = new UsersJpaController();
        try {
            usersCtrl.edit(user);
            // update session and flash
            request.getSession().setAttribute("user", user);
            request.getSession().setAttribute("successMessage", "Password changed successfully.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        } catch (Exception ex) {
            request.setAttribute("errorMessage", "Unable to change password: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/change_password.jsp").forward(request, response);
            return;
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("Password hashing failed", e);
        }
    }
}
