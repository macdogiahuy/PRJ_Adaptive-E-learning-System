package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import model.Users;
import controller.UsersJpaController;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {
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
            // No login required: create a demo user to display the profile (matches screenshots)
            user = new Users();
            user.setUserName("Fgn85761");
            user.setFullName("Fgn85761");
            user.setMetaFullName("fgn85761");
            user.setEmail(null);
            user.setBio(null);
            user.setPhone(null);
            user.setEnrollmentCount(0);
            user.setRole(null);
            user.setAvatarUrl(null);

            // parse sample dates (DOB and Join Date)
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            try {
                Date dob = sdf.parse("21/01/2000");
                Date join = sdf.parse("19/10/2023");
                user.setDateOfBirth(dob);
                user.setCreationTime(join);
            } catch (ParseException ex) {
                // ignore parse errors and leave dates null
            }
        }
        // If session user exists and has Id, reload from DB to show latest persisted data
        if (user != null && user.getId() != null) {
            try {
                UsersJpaController usersCtrl = new UsersJpaController();
                Users persisted = usersCtrl.findUsers(user.getId());
                if (persisted != null) user = persisted;
            } catch (Exception ex) {
                // ignore and use session user
            }
        }

        // Handle flash messages from session
        Object flashErr = request.getSession().getAttribute("errorMessage");
        if (flashErr != null) {
            request.setAttribute("errorMessage", flashErr.toString());
            request.getSession().removeAttribute("errorMessage");
        }
        Object flashSuccess = request.getSession().getAttribute("successMessage");
        if (flashSuccess != null) {
            request.setAttribute("successMessage", flashSuccess.toString());
            request.getSession().removeAttribute("successMessage");
        }

        request.setAttribute("userProfile", user);
        request.getRequestDispatcher("/WEB-INF/views/Pages/user/profile.jsp").forward(request, response);
    }
}