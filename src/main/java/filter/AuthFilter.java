package filter;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final List<String> PUBLIC_URLS = List.of(
            "/home", "/courses", "/detail", "/about", "/contact", "/forgot-password", "/verify-otp", "/reset-password",
            "/login", "/register",
            "/google-login", "/oauth2callback",
            "/css/", "/js/", "/assets/", "/img/", "/assests/");

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

        // Robustly obtain current user from known session attributes
        Users currentUser = null;
        if (session != null) {
            Object acc = session.getAttribute("account");
            if (acc instanceof Users) {
                currentUser = (Users) acc;
            } else {
                Object cu = session.getAttribute("currentUser");
                if (cu instanceof Users) {
                    currentUser = (Users) cu;
                }
            }
        }
        if (currentUser == null) {
            // No authenticated user found
            response.sendRedirect(context + "/login");
            return;
        }

        String role = currentUser.getRole();
        if (role == null) {
            role = "";
        }

        // Normalize path relative to context so checks are precise
        String path = uri;
        if (context != null && !context.isEmpty() && uri.startsWith(context)) {
            path = uri.substring(context.length());
        }
        if (path.isEmpty()) {
            path = "/";
        }

        System.out.println("[AuthFilter] URI: " + uri + ", Role: " + role);
        System.out.println("[AuthFilter] User ID: " + currentUser.getId() + ", Username: " + currentUser.getUserName());

        // MY-COURSES (scoped): allow Learner and Instructor and Admin.
        // Place this check before admin/instructor to ensure precise handling for
        // /my-courses
        if (path.equalsIgnoreCase("/my-courses") || path.equalsIgnoreCase("/my-courses.jsp")
                || path.startsWith("/my-courses")) {
            if (!"Admin".equalsIgnoreCase(role) && !"Instructor".equalsIgnoreCase(role)
                    && !"Learner".equalsIgnoreCase(role)) {
                System.out.println("[AuthFilter] BLOCKING my-courses access for role: " + role);
                response.sendRedirect(context + "/access-denied.jsp");
                return;
            }
        }

        // ADMIN pages: exact matches or well-scoped prefixes only.
        if (path.equalsIgnoreCase("/admin_dashboard.jsp") || path.startsWith("/admin_") || path.startsWith("/admin/")) {
            if (!"Admin".equalsIgnoreCase(role)) {
                System.out.println("[AuthFilter] BLOCKING admin access for role: " + role);
                response.sendRedirect(context + "/access-denied.jsp");
                return;
            }
        }

        // INSTRUCTOR pages: instructor_dashboard.jsp, instructor_* files, or
        // /instructor/ paths
        if (path.equalsIgnoreCase("/instructor_dashboard.jsp") || path.startsWith("/instructor_")
                || path.startsWith("/instructor/")) {
            if (!"Admin".equalsIgnoreCase(role) && !"Instructor".equalsIgnoreCase(role)) {
                System.out.println("[AuthFilter] BLOCKING instructor access for role: " + role);
                response.sendRedirect(context + "/access-denied.jsp");
                return;
            }
        }

        // MY-COURSES: allow Learner (and Admin/Instructor if they have access)
        if (path.equalsIgnoreCase("/my-courses") || path.equalsIgnoreCase("/my-courses.jsp")
                || path.endsWith("/my-courses") || path.endsWith("/my-courses.jsp")) {
            if (!"Admin".equalsIgnoreCase(role) && !"Instructor".equalsIgnoreCase(role)
                    && !"Learner".equalsIgnoreCase(role)) {
                System.out.println("[AuthFilter] BLOCKING my-courses access for role: " + role);
                response.sendRedirect(context + "/access-denied.jsp");
                return;
            }
        }

        // LEARNER-specific pages (scoped)
        if (path.equalsIgnoreCase("/learner-home.jsp") || path.startsWith("/learner/")) {
            if (!"Admin".equalsIgnoreCase(role) && !"Instructor".equalsIgnoreCase(role)
                    && !"Learner".equalsIgnoreCase(role)) {
                System.out.println("[AuthFilter] BLOCKING learner access for role: " + role);
                response.sendRedirect(context + "/access-denied.jsp");
                return;
            }
        }

        System.out.println("[AuthFilter] ALLOWING access for role: " + role);
        chain.doFilter(req, res);
    }
}
