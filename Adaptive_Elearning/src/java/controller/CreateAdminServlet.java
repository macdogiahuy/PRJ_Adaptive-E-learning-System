package controller;

import model.Users;
import controller.UsersJpaController;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CreateAdminServlet", urlPatterns = {"/createadmin"})
public class CreateAdminServlet extends HttpServlet {

    private UsersJpaController usersController;

    @Override
    public void init() throws ServletException {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("WebApplication3PU");
        usersController = new UsersJpaController(emf);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Forward to create admin page
        request.getRequestDispatcher("/WEB-INF/views/admin/createadmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");

        // Validation
        StringBuilder errors = new StringBuilder();

        // Check required fields
        if (username == null || username.trim().isEmpty()) {
            errors.append("Username is required.<br>");
        } else if (username.length() < 3) {
            errors.append("Username must be at least 3 characters long.<br>");
        }

        if (email == null || email.trim().isEmpty()) {
            errors.append("Email is required.<br>");
        } else if (!isValidEmail(email)) {
            errors.append("Please enter a valid email address.<br>");
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            errors.append("Full name is required.<br>");
        }

        if (password == null || password.trim().isEmpty()) {
            errors.append("Password is required.<br>");
        } else if (password.length() < 8) {
            errors.append("Password must be at least 8 characters long.<br>");
        }

        if (confirmPassword == null || !confirmPassword.equals(password)) {
            errors.append("Passwords do not match.<br>");
        }

        if (role == null || role.trim().isEmpty()) {
            errors.append("Please select a role.<br>");
        }

        // Check if username already exists
        try {
            List<Users> existingUsers = usersController.findUsersEntities();
            for (Users user : existingUsers) {
                if (user.getUserName().equalsIgnoreCase(username.trim())) {
                    errors.append("Username already exists. Please choose a different username.<br>");
                    break;
                }
                if (user.getEmail().equalsIgnoreCase(email.trim())) {
                    errors.append("Email already exists. Please use a different email address.<br>");
                    break;
                }
            }
        } catch (Exception e) {
            errors.append("Error checking existing users.<br>");
        }

        // If there are validation errors, redirect back with errors
        if (errors.length() > 0) {
            request.setAttribute("errors", errors.toString());
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("role", role);
            request.getRequestDispatcher("/WEB-INF/views/admin/createadmin.jsp").forward(request, response);
            return;
        }

        try {
            // Create new admin user
            Users newAdmin = new Users();

            // Generate unique ID
            String uniqueId = UUID.randomUUID().toString().replace("-", "").substring(0, 16);
            newAdmin.setId(uniqueId);

            // Set user details
            newAdmin.setUserName(username.trim());
            newAdmin.setEmail(email.trim().toLowerCase());
            newAdmin.setFullName(fullName.trim());
            newAdmin.setMetaFullName(fullName.trim().toLowerCase());
            newAdmin.setPhone(phone != null ? phone.trim() : null);

            // Hash password (you might want to use a more secure method)
            String hashedPassword = hashPassword(password);
            newAdmin.setPassword(hashedPassword);

            // Set role
            newAdmin.setRole(role.trim());

            // Set default values for admin
            newAdmin.setAvatarUrl("/assets/images/default-avatar.png");
            newAdmin.setToken(""); // Will be generated on login
            newAdmin.setRefreshToken("");
            newAdmin.setIsVerified(true);
            newAdmin.setIsApproved(true);
            newAdmin.setAccessFailedCount((short) 0);
            newAdmin.setLoginProvider(null);
            newAdmin.setProviderKey(null);
            newAdmin.setBio("Admin user created via admin panel");
            newAdmin.setEnrollmentCount(0);
            newAdmin.setInstructorId(null);
            newAdmin.setSystemBalance(0L);

            // Set timestamps
            Date now = new Date();
            newAdmin.setCreationTime(now);
            newAdmin.setLastModificationTime(now);

            // Create the user
            usersController.create(newAdmin);

            // Set success message
            request.setAttribute("success", "Admin account created successfully!");
            request.setAttribute("newAdmin", newAdmin);

            // Forward to success page or back to form
            request.getRequestDispatcher("/WEB-INF/views/admin/createadmin.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errors", "Error creating admin account: " + e.getMessage());
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("role", role);
            request.getRequestDispatcher("/WEB-INF/views/admin/createadmin.jsp").forward(request, response);
        }
    }

    private boolean isValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
        return email.matches(emailRegex);
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            // Fallback to simple hash if SHA-256 is not available
            return String.valueOf(password.hashCode());
        }
    }

    private void sendWelcomeEmail(Users admin) {
        // TODO: Implement email sending functionality
        // This could use JavaMail API or a service like SendGrid
        System.out.println("Welcome email would be sent to: " + admin.getEmail());
        System.out.println("Username: " + admin.getUserName());
        System.out.println("Temporary Password: [HIDDEN FOR SECURITY]");
    }
}
