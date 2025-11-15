package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import services.GoogleAuthService;

@WebServlet("/google-login")
public class GoogleLoginServlet extends HttpServlet {
    private final GoogleAuthService authService = new GoogleAuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String authUrl = authService.buildAuthUrl(req.getSession());
        resp.sendRedirect(authUrl);
    }
}
