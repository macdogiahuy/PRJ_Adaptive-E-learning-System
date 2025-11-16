package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.security.SecureRandom;
import java.util.Base64;

public class Csrf {
    private static final SecureRandom RND = new SecureRandom();

    public static void ensureToken(HttpSession session) {
        if (session.getAttribute("csrfToken") == null) {
            byte[] b = new byte[32];
            RND.nextBytes(b);
            session.setAttribute("csrfToken", Base64.getUrlEncoder().withoutPadding().encodeToString(b));
        }
    }

    public static boolean valid(HttpServletRequest req) {
        Object s = req.getSession().getAttribute("csrfToken");
        String p = req.getParameter("csrf");
        return s != null && s.equals(p);
    }
}
