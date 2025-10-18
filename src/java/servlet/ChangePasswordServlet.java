package servlet;

import dao.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/settings/password"})
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/change_password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String id = request.getParameter("id");
        String current = request.getParameter("currentPassword");
        String next = request.getParameter("newPassword");
        String confirm = request.getParameter("confirmPassword");

        if (next == null || next.length() < 8) {
            request.setAttribute("error", "New password must be at least 8 characters.");
            request.getRequestDispatcher("/WEB-INF/views/change_password.jsp").forward(request, response);
            return;
        }
        if (!next.equals(confirm)) {
            request.setAttribute("error", "New password and confirm do not match.");
            request.getRequestDispatcher("/WEB-INF/views/change_password.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            if (id == null || id.isEmpty()) {
                try (PreparedStatement ps = conn.prepareStatement("SELECT TOP 1 Id FROM Users");
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) id = rs.getString(1);
                }
            }
            if (id == null || id.isEmpty()) {
                request.setAttribute("error", "No user found to change password.");
                request.getRequestDispatcher("/WEB-INF/views/change_password.jsp").forward(request, response);
                return;
            }

            // Verify current password
            try (PreparedStatement ps = conn.prepareStatement("SELECT Password FROM Users WHERE Id = ?")) {
                ps.setString(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String stored = rs.getString(1);
                        if (stored == null) stored = "";
                        if (!stored.equals(current)) {
                            request.setAttribute("error", "Current password is incorrect.");
                            request.getRequestDispatcher("/WEB-INF/views/change_password.jsp").forward(request, response);
                            return;
                        }
                    } else {
                        request.setAttribute("error", "User not found.");
                        request.getRequestDispatcher("/WEB-INF/views/change_password.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // Update password (NOTE: plaintext - consider hashing)
            try (PreparedStatement ps = conn.prepareStatement("UPDATE Users SET Password = ? WHERE Id = ?")) {
                ps.setString(1, next);
                ps.setString(2, id);
                ps.executeUpdate();
            }

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }

        // success
        request.getSession().setAttribute("success", "Password changed successfully.");
        response.sendRedirect(request.getContextPath() + "/settings/profile");
    }
}
