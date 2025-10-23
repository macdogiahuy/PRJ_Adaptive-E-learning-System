/*
 * Example servlet showing how to use JPA controllers and services
 */
package servlet;

import services.UserCourseService;
import model.Users;
import model.Courses;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Example servlet demonstrating JPA usage
 * @author LP
 */
@WebServlet("/api/example")
public class ExampleJpaServlet extends HttpServlet {
    
    private UserCourseService service;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.service = new UserCourseService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        switch (action != null ? action : "stats") {
            case "users":
                handleGetUsers(request, response);
                break;
            case "courses":
                handleGetCourses(request, response);
                break;
            case "stats":
                handleGetStats(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        switch (action != null ? action : "") {
            case "register":
                handleRegister(request, response);
                break;
            case "login":
                handleLogin(request, response);
                break;
            case "createCourse":
                handleCreateCourse(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    private void handleGetUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String role = request.getParameter("role");
        List<Users> users;
        
        if (role != null && !role.isEmpty()) {
            users = service.getUsersByRole(role);
        } else {
            // This would require adding a findAll method to service
            users = service.getUsersByRole("Student"); // Example fallback
        }
        
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/users.jsp").forward(request, response);
    }
    
    private void handleGetCourses(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String instructorId = request.getParameter("instructorId");
        List<Courses> courses;
        
        if (instructorId != null && !instructorId.isEmpty()) {
            courses = service.getCoursesByInstructor(instructorId);
        } else {
            courses = service.getPublishedCourses();
        }
        
        request.setAttribute("courses", courses);
        request.getRequestDispatcher("/WEB-INF/views/courses.jsp").forward(request, response);
    }
    
    private void handleGetStats(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Print stats to console/logs
        service.printStatistics();
        
        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"success\",\"message\":\"Statistics printed to console\"}");
    }
    
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        
        boolean success = service.registerUser(username, email, password, fullName);
        
        if (success) {
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"success\",\"message\":\"User registered successfully\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Registration failed\"}");
        }
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        Users user = service.authenticateUser(username, password);
        
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userRole", user.getRole());
            
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"success\",\"message\":\"Login successful\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Invalid credentials\"}");
        }
    }
    
    private void handleCreateCourse(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String instructorId = (String) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");
        
        if (instructorId == null || !"Instructor".equals(userRole)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Unauthorized\"}");
            return;
        }
        
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String categoryId = request.getParameter("categoryId");
        
        boolean success = service.createCourse(title, description, instructorId, categoryId);
        
        if (success) {
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"success\",\"message\":\"Course created successfully\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Course creation failed\"}");
        }
    }
}