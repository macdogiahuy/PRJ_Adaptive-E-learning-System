package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Users;
import services.GoogleAuthService;
import dao.UserDAO;

@WebServlet("/oauth2callback")
public class GoogleCallbackServlet extends HttpServlet {
    private final GoogleAuthService authService = new GoogleAuthService();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Users googleUser = authService.handleCallback(req);
        if (googleUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=google");
            return;
        }

        Users user = userDAO.findOrCreateGoogleUser(
            googleUser.getEmail(),
            googleUser.getFullName(),
            googleUser.getAvatarUrl(),
            googleUser.getProviderKey()
        );

        HttpSession session = req.getSession();
        session.setAttribute("account", user);
        session.setAttribute("user", user.getUserName());
        session.setAttribute("role", user.getRole());

        resp.sendRedirect(req.getContextPath() + "/home");
    }
}
