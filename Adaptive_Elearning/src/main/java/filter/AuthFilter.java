package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Users;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final List<String> PUBLIC_URLS = List.of(
        "/home","/courses","/detail" ,"/login", "/register",
        "/google-login", "/oauth2callback",
        "/css/", "/js/", "/assets/", "/img/", "/assests/"
    );

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String uri = request.getRequestURI();
        String context = request.getContextPath();

        boolean isPublic = PUBLIC_URLS.stream().anyMatch(uri::contains)
                || uri.equals(context + "/")
                || uri.equals(context);
        if (isPublic) {
            chain.doFilter(req, res);
            return;
        }

        Users currentUser = (session != null) ? (Users) session.getAttribute("account") : null;
        if (currentUser == null) {
            response.sendRedirect(context + "/login");
            return;
        }

        String role = currentUser.getRole();
        
        System.out.println("[AuthFilter] URI: " + uri + ", Role: " + role);


        if ((uri.contains("admin-dashboard.jsp") || uri.contains("/admin")) 
                && !"Admin".equalsIgnoreCase(role)) {
            response.sendRedirect(context + "/access-denied.jsp");
            return;
        }

        if ((uri.contains("instructor-dashboard.jsp") || uri.contains("/instructor")) 
                && !"Instructor".equalsIgnoreCase(role)) {
            response.sendRedirect(context + "/access-denied.jsp");
            return;
        }

        if ((uri.contains("learner-home.jsp") || uri.contains("/learner")) 
                && !"Learner".equalsIgnoreCase(role)) {
            response.sendRedirect(context + "/access-denied.jsp");
            return;
        }
        chain.doFilter(req, res);
    }
}
