package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

import java.io.IOException;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet to handle Instructor Dashboard access
 * Allows both Instructor and Admin roles to access instructor features
 */
@WebServlet(urlPatterns = {"/instructor-dashboard", "/instructor_dashboard"})
public class InstructorDashboardServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(InstructorDashboardServlet.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Users user = (Users) session.getAttribute("account");
        
        // Check if user exists and has proper role
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = user.getRole();
        
        // Allow both Admin and Instructor to access
        if (!"Admin".equalsIgnoreCase(userRole) && !"Instructor".equalsIgnoreCase(userRole)) {
            // Redirect to access denied page
            request.getRequestDispatcher("/access-denied.jsp").forward(request, response);
            return;
        }
        
        // Get instructor statistics
        try {
            String instructorId = user.getId();
            InstructorStats stats = getInstructorStats(instructorId);
            
            request.setAttribute("totalStudents", stats.getTotalStudents());
            request.setAttribute("activeCourses", stats.getActiveCourses());
            request.setAttribute("completionRate", stats.getCompletionRate());
            request.setAttribute("monthlyRevenue", stats.getMonthlyRevenue());
            
            LOGGER.log(Level.INFO, "Loaded stats for instructor {0}: Students={1}, Courses={2}", 
                      new Object[]{instructorId, stats.getTotalStudents(), stats.getActiveCourses()});
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading instructor stats", e);
            // Set default values on error
            request.setAttribute("totalStudents", 0);
            request.setAttribute("activeCourses", 0);
            request.setAttribute("completionRate", 0);
            request.setAttribute("monthlyRevenue", 0);
        }
        
        // Add user info to request for JSP access
        request.setAttribute("currentUser", user);
        request.setAttribute("userRole", userRole);
        
        // Forward to instructor dashboard JSP
        request.getRequestDispatcher("/instructor_dashboard.jsp").forward(request, response);
    }
    
    /**
     * Get instructor statistics from database
     */
    private InstructorStats getInstructorStats(String instructorId) throws SQLException {
        InstructorStats stats = new InstructorStats();
        
        try (Connection con = dao.DBConnection.getConnection()) {
            // Get total students enrolled in instructor's courses
            String studentsQuery = "SELECT COUNT(DISTINCT e.CreatorId) as TotalStudents " +
                                  "FROM Enrollments e " +
                                  "INNER JOIN Courses c ON e.CourseId = c.Id " +
                                  "WHERE c.InstructorId = ?";
            
            try (PreparedStatement ps = con.prepareStatement(studentsQuery)) {
                ps.setString(1, instructorId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    stats.setTotalStudents(rs.getInt("TotalStudents"));
                }
            }
            
            // Get active courses count
            String coursesQuery = "SELECT COUNT(*) as ActiveCourses " +
                                 "FROM Courses " +
                                 "WHERE InstructorId = ? AND LOWER(Status) = 'ongoing' AND LOWER(ApprovalStatus) = 'approved'";
            
            try (PreparedStatement ps = con.prepareStatement(coursesQuery)) {
                ps.setString(1, instructorId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    stats.setActiveCourses(rs.getInt("ActiveCourses"));
                }
            }
            
            // Completion rate - fake for now (can be calculated if needed)
            stats.setCompletionRate(87);
            
            // Monthly revenue - fake for now
            stats.setMonthlyRevenue(45600);
        }
        
        return stats;
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Inner class to hold instructor statistics
     */
    private static class InstructorStats {
        private int totalStudents;
        private int activeCourses;
        private int completionRate;
        private int monthlyRevenue;
        
        public int getTotalStudents() { return totalStudents; }
        public void setTotalStudents(int totalStudents) { this.totalStudents = totalStudents; }
        
        public int getActiveCourses() { return activeCourses; }
        public void setActiveCourses(int activeCourses) { this.activeCourses = activeCourses; }
        
        public int getCompletionRate() { return completionRate; }
        public void setCompletionRate(int completionRate) { this.completionRate = completionRate; }
        
        public int getMonthlyRevenue() { return monthlyRevenue; }
        public void setMonthlyRevenue(int monthlyRevenue) { this.monthlyRevenue = monthlyRevenue; }
    }
}