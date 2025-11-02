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
        "/home","/courses","/detail","/about","/contact" ,"/forgot-password","/verify-otp","/reset-password","/login", "/register",
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
        System.out.println("[AuthFilter] User ID: " + currentUser.getId() + ", Username: " + currentUser.getUserName());


        // Admin pages - only Admin can access
        if ((uri.contains("admin-dashboard.jsp") || uri.contains("/admin")) 
                && !"Admin".equalsIgnoreCase(role)) {
            System.out.println("[AuthFilter] BLOCKING admin access for role: " + role);
            response.sendRedirect(context + "/access-denied.jsp");
            return;
        }

        // Instructor pages - Admin and Instructor can access (Admin inherits Instructor permissions)
        if ((uri.contains("instructor-dashboard.jsp") || uri.contains("/instructor")) 
                && !"Admin".equalsIgnoreCase(role) && !"Instructor".equalsIgnoreCase(role)) {
            System.out.println("[AuthFilter] BLOCKING instructor access for role: " + role);
            response.sendRedirect(context + "/access-denied.jsp");
            return;
        }

        // Learner pages - all authenticated users can access
        if ((uri.contains("learner-home.jsp") || uri.contains("/learner")) 
                && !"Admin".equalsIgnoreCase(role) && !"Instructor".equalsIgnoreCase(role) && !"Learner".equalsIgnoreCase(role)) {
            System.out.println("[AuthFilter] BLOCKING learner access for role: " + role);
            response.sendRedirect(context + "/access-denied.jsp");
            return;
        }
        
        System.out.println("[AuthFilter] ALLOWING access for role: " + role);
        chain.doFilter(req, res);
    }
}
