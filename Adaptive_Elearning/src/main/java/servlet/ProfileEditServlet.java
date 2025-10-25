package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.Users;
import controller.UsersJpaController;

@WebServlet(name = "ProfileEditServlet", urlPatterns = {"/profile/edit"})
@MultipartConfig
public class ProfileEditServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // get user from session with safe casting
        Object userObj = request.getSession().getAttribute("user");
        Users user = null;
        
        if (userObj instanceof Users) {
            user = (Users) userObj;
        }
        
        if (user == null) {
            // allow anonymous edit: create demo user for editing in session
            user = new Users();
            user.setUserName("Fgn85761");
            user.setFullName("Fgn85761");
            user.setMetaFullName("fgn85761");
            user.setEmail("fgn85761@omeie.com");
            user.setBio("Fgn85761's Bio 123456");
            request.getSession().setAttribute("user", user);
        }
        request.setAttribute("userProfile", user);
        request.getRequestDispatcher("/WEB-INF/views/Pages/user/profile_edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // get user from session with safe casting
        Object userObj = request.getSession().getAttribute("user");
        Users sessionUser = null;
        
        if (userObj instanceof Users) {
            sessionUser = (Users) userObj;
        }
        
        boolean anonymous = (sessionUser == null);
        Users user;
        if (sessionUser != null) {
            user = sessionUser;
        } else {
            user = new Users();
            // keep demo user in session for anonymous editing
            request.getSession().setAttribute("user", user);
        }

    String fullName = request.getParameter("fullName");
        String metaFullName = request.getParameter("metaFullName");
        String phone = request.getParameter("phone");
        String bio = request.getParameter("bio");
        String email = request.getParameter("email");
        String dob = request.getParameter("dateOfBirth");

    String error = null;

        if (fullName != null) user.setFullName(fullName);
        if (metaFullName != null) user.setMetaFullName(metaFullName);
        if (phone != null) user.setPhone(phone);
        if (bio != null) user.setBio(bio);
        if (email != null) user.setEmail(email);

        if (dob != null && !dob.isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date d = sdf.parse(dob);
                user.setDateOfBirth(d);
            } catch (ParseException ex) {
                // ignore
            }
        }

        // handle avatar upload with validation
        Part part = request.getPart("avatar");
        if (part != null && part.getSize() > 0) {
            // validate size (max 2MB) and content type
            long maxSize = 2 * 1024 * 1024; // 2MB
            String contentType = part.getContentType();
            if (part.getSize() > maxSize) {
                error = "Avatar file is too large (max 2MB).";
            } else if (contentType == null || !(contentType.startsWith("image/"))) {
                error = "Avatar must be an image file.";
            } else {
                String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String ext = "";
                int i = filename.lastIndexOf('.');
                if (i > 0) ext = filename.substring(i);
                String newName = "avatar_" + System.currentTimeMillis() + ext;

                String uploadsDir = request.getServletContext().getRealPath("/assets/uploads");
                File uploads = new File(uploadsDir);
                if (!uploads.exists()) uploads.mkdirs();

                File out = new File(uploads, newName);
                try (InputStream in = part.getInputStream(); FileOutputStream fos = new FileOutputStream(out)) {
                    byte[] buffer = new byte[4096];
                    int read;
                    while ((read = in.read(buffer)) != -1) {
                        fos.write(buffer, 0, read);
                    }
                }
                // set avatar URL relative to context
                String avatarUrl = request.getContextPath() + "/assets/uploads/" + newName;
                user.setAvatarUrl(avatarUrl);
            }
        }

        // If validation error, show edit page with error
        if (error != null) {
            request.setAttribute("errorMessage", error);
            request.setAttribute("userProfile", user);
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/profile_edit.jsp").forward(request, response);
            return;
        }

    // persist changes only when logged-in user with id exists and is owner
    if (!anonymous && sessionUser != null && sessionUser.getId() != null && sessionUser.getId().equals(user.getId())) {
            UsersJpaController usersCtrl = new UsersJpaController();
            try {
                usersCtrl.edit(user);
                request.getSession().setAttribute("successMessage", "Profile updated successfully.");
            } catch (Exception ex) {
                request.getSession().setAttribute("errorMessage", "Unable to save profile: " + ex.getMessage());
                response.sendRedirect(request.getContextPath() + "/profile/edit");
                return;
            }
        } else {
            // anonymous edit or not owner: only update session but do not persist to DB
            request.getSession().setAttribute("successMessage", "Profile updated in session.");
        }

        // Update session user
        request.getSession().setAttribute("user", user);

        // redirect back to profile
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
