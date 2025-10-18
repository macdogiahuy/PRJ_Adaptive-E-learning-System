package servlet;

import dao.DBConnection;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Users;

@WebServlet(name = "ProfileSettingsServlet", urlPatterns = {"/profile", "/settings/profile"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 10 * 1024 * 1024)
public class ProfileSettingsServlet extends HttpServlet {

    private static final String AVATAR_DIR = "web/uploads/avatars";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        Users user = null;

        try (Connection conn = DBConnection.getConnection()) {
            String sql;
            if (id != null && !id.isEmpty()) {
                sql = "SELECT Id, FullName, MetaFullName, Email, UserName, Bio, AvatarUrl, DateOfBirth, Phone, EnrollmentCount, Role, CreationTime FROM Users WHERE Id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            user = mapResultToUser(rs);
                        }
                    }
                }
            } else {
                // Select any one user as demo if no id provided
                sql = "SELECT TOP 1 Id, FullName, MetaFullName, Email, UserName, Bio, AvatarUrl, DateOfBirth, Phone, EnrollmentCount, Role, CreationTime FROM Users";
                try (PreparedStatement ps = conn.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        user = mapResultToUser(rs);
                    }
                }
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }

        if (user == null) {
            // If DB empty or failed, provide a fallback demo user
            user = new Users();
            user.setId("demo");
            user.setFullName("Demo User");
            user.setEmail("demo@example.com");
            user.setUserName("demoUser");
            user.setBio("");
            user.setAvatarUrl(request.getContextPath() + "/assets/img/default-avatar.png");
            user.setEnrollmentCount(0);
            user.setRole("Learner");
        }

        request.setAttribute("user", user);
    // keep session user in sync so header displays up-to-date avatar/name
    request.getSession().setAttribute("user", user);
        String servletPath = request.getServletPath();
        if ("/settings/profile".equals(servletPath)) {
            request.getRequestDispatcher("/WEB-INF/views/profile_settings.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String id = request.getParameter("id");
        // If id not provided, attempt to update first user (not ideal but safe for demo)
        try (Connection conn = DBConnection.getConnection()) {
            if (id == null || id.isEmpty()) {
                // find first id
                try (PreparedStatement ps = conn.prepareStatement("SELECT TOP 1 Id FROM Users");
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) id = rs.getString(1);
                }
            }

            if (id == null || id.isEmpty()) {
                // nothing to update
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }

            String fullName = request.getParameter("fullName");
            String bio = request.getParameter("bio");
            String metaFullName = request.getParameter("metaFullName");
            String phone = request.getParameter("phone");
            String dateOfBirth = request.getParameter("dateOfBirth");

            String avatarUrl = null;
            Part avatarPart = request.getPart("avatar");
            String selectedAvatar = request.getParameter("selectedAvatar");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String submitted = avatarPart.getSubmittedFileName();
                String ext = "";
                int dot = submitted.lastIndexOf('.');
                if (dot > 0) ext = submitted.substring(dot);
                String fileName = "avatar_" + System.currentTimeMillis() + ext;

                // Resolve absolute path to uploads (web/uploads/avatars inside project)
                String appPath = request.getServletContext().getRealPath("");
                File uploads = new File(appPath, "uploads/avatars");
                if (!uploads.exists()) uploads.mkdirs();
                File file = new File(uploads, fileName);
                try (InputStream in = avatarPart.getInputStream(); FileOutputStream out = new FileOutputStream(file)) {
                    byte[] buf = new byte[8192];
                    int r;
                    while ((r = in.read(buf)) != -1) out.write(buf, 0, r);
                }
                avatarUrl = request.getContextPath() + "/uploads/avatars/" + fileName;
            } else if (selectedAvatar != null && !selectedAvatar.isEmpty()) {
                // whitelist allowed system avatars (prevent arbitrary URLs)
                if (selectedAvatar.endsWith("/assets/img/avatars/avatar1.svg") ||
                        selectedAvatar.endsWith("/assets/img/avatars/avatar2.svg") ||
                        selectedAvatar.endsWith("/assets/img/avatars/avatar3.svg")) {
                    avatarUrl = selectedAvatar;
                }
            }

            StringBuilder sql = new StringBuilder("UPDATE Users SET FullName = ?, Bio = ?");
            if (metaFullName != null) sql.append(", MetaFullName = ?");
            if (phone != null) sql.append(", Phone = ?");
            if (dateOfBirth != null && !dateOfBirth.isEmpty()) sql.append(", DateOfBirth = ?");
            if (avatarUrl != null) sql.append(", AvatarUrl = ?");
            sql.append(" WHERE Id = ?");

            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                int idx = 1;
                ps.setString(idx++, fullName);
                ps.setString(idx++, bio);
                if (metaFullName != null) ps.setString(idx++, metaFullName);
                if (phone != null) ps.setString(idx++, phone);
                if (dateOfBirth != null && !dateOfBirth.isEmpty()) {
                    try {
                        java.sql.Date dob = java.sql.Date.valueOf(LocalDate.parse(dateOfBirth));
                        ps.setTimestamp(idx++, new Timestamp(dob.getTime()));
                    } catch (DateTimeParseException dtpe) {
                        ps.setTimestamp(idx++, null);
                    }
                }
                if (avatarUrl != null) ps.setString(idx++, avatarUrl);
                ps.setString(idx++, id);
                ps.executeUpdate();
            }

            // refresh the user object and store in session so header shows updated avatar/info
            try (PreparedStatement ps2 = conn.prepareStatement("SELECT Id, FullName, MetaFullName, Email, UserName, Bio, AvatarUrl, DateOfBirth, Phone, EnrollmentCount, Role, CreationTime FROM Users WHERE Id = ?")) {
                ps2.setString(1, id);
                try (ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) {
                        Users updated = mapResultToUser(rs2);
                        request.getSession().setAttribute("user", updated);
                    }
                }
            }

        } catch (SQLException ex) {
            throw new ServletException(ex);
        }

    // Set a session success message and redirect back to the profile page using the resolved id
    request.getSession().setAttribute("success", "Profile updated successfully.");
    response.sendRedirect(request.getContextPath() + "/profile?id=" + (id != null ? id : ""));
    }

    private Users mapResultToUser(ResultSet rs) throws SQLException {
        Users user = new Users();
        user.setId(rs.getString("Id"));
        user.setFullName(rs.getString("FullName"));
        // MetaFullName and Phone are optional in DB
        try { user.setMetaFullName(rs.getString("MetaFullName")); } catch (SQLException e) { /* ignore */ }
        try { user.setPhone(rs.getString("Phone")); } catch (SQLException e) { /* ignore */ }
        user.setEmail(rs.getString("Email"));
        user.setUserName(rs.getString("UserName"));
        user.setBio(rs.getString("Bio"));
        user.setAvatarUrl(rs.getString("AvatarUrl"));
        java.sql.Timestamp dob = rs.getTimestamp("DateOfBirth");
        if (dob != null) user.setDateOfBirth(new java.util.Date(dob.getTime()));
        user.setEnrollmentCount(rs.getInt("EnrollmentCount"));
        user.setRole(rs.getString("Role"));
        java.sql.Timestamp ct = rs.getTimestamp("CreationTime");
        if (ct != null) user.setCreationTime(new java.util.Date(ct.getTime()));
        return user;
    }
}
