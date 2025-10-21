package controller;

<<<<<<< HEAD
import java.util.HashMap;
import java.util.Map;
import model.Users;
import model.Courses;

/**
 * Dashboard Controller - Converted to use JPA
 * @author LP
 */
public class DashboardController {
    
    private UsersJpaController usersJpaController;
    private CoursesJpaController coursesJpaController;
    
    public DashboardController() {
        this.usersJpaController = new UsersJpaController();
        this.coursesJpaController = new CoursesJpaController();
    }
    
    /**
     * Get overview data for dashboard
     */
    public Map<String, Object> getOverviewData() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Total users count
            int totalUsers = usersJpaController.getUsersCount();
            result.put("totalUsers", totalUsers);
            
            // Total courses count
            int totalCourses = coursesJpaController.getCoursesCount();
            result.put("totalCourses", totalCourses);
            
            // Active users (not Inactive role)
            int activeUsers = 0;
            for (Users user : usersJpaController.findUsersEntities()) {
                if (user.getRole() != null && !"Inactive".equals(user.getRole())) {
                    activeUsers++;
                }
            }
            result.put("activeUsers", activeUsers);
            
            // Published courses
            int publishedCourses = coursesJpaController.findPublishedCourses().size();
            result.put("publishedCourses", publishedCourses);
            
            // Students count
            int studentsCount = usersJpaController.findByRole("Student").size();
            result.put("studentsCount", studentsCount);
            
            // Instructors count
            int instructorsCount = usersJpaController.findByRole("Instructor").size();
            result.put("instructorsCount", instructorsCount);
            
            // Admins count
            int adminsCount = usersJpaController.findByRole("Admin").size();
            result.put("adminsCount", adminsCount);
            
            result.put("success", true);
            
        } catch (Exception e) {
            System.err.println("Error getting overview data: " + e.getMessage());
            result.put("success", false);
            result.put("error", "Error fetching dashboard data: " + e.getMessage());
            result.put("totalUsers", 0);
            result.put("totalCourses", 0);
            result.put("activeUsers", 0);
            result.put("publishedCourses", 0);
            result.put("studentsCount", 0);
            result.put("instructorsCount", 0);
            result.put("adminsCount", 0);
        }
        
        return result;
    }
    
    /**
     * Get detailed statistics for admin dashboard
     */
    public Map<String, Object> getDetailedStatistics() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Basic counts
            Map<String, Object> basicStats = getOverviewData();
            result.putAll(basicStats);
            
            // Role distribution
            Map<String, Integer> roleDistribution = new HashMap<>();
            for (Users user : usersJpaController.findUsersEntities()) {
                String role = user.getRole();
                if (role != null) {
                    roleDistribution.put(role, roleDistribution.getOrDefault(role, 0) + 1);
                }
            }
            result.put("roleDistribution", roleDistribution);
            
            // Course statistics by category
            Map<String, Integer> coursesByCategory = new HashMap<>();
            for (Courses course : coursesJpaController.findCoursesEntities()) {
                String categoryId = course.getCategoryId();
                if (categoryId != null) {
                    coursesByCategory.put(categoryId, coursesByCategory.getOrDefault(categoryId, 0) + 1);
                }
            }
            result.put("coursesByCategory", coursesByCategory);
            
            // Total system balance
            long totalBalance = 0;
            for (Users user : usersJpaController.findUsersEntities()) {
                totalBalance += user.getSystemBalance();
            }
            result.put("totalSystemBalance", totalBalance);
            
            result.put("success", true);
            
        } catch (Exception e) {
            System.err.println("Error getting detailed statistics: " + e.getMessage());
            result.put("success", false);
            result.put("error", "Error fetching detailed statistics: " + e.getMessage());
        }
        
        return result;
    }
    
    /**
     * Get recent activity summary
     */
    public Map<String, Object> getRecentActivity() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Recent users (this is a simplified version - in real app you'd sort by creation date)
            result.put("recentUsersCount", Math.min(5, usersJpaController.getUsersCount()));
            
            // Recent courses
            result.put("recentCoursesCount", Math.min(5, coursesJpaController.getCoursesCount()));
            
            result.put("success", true);
            
        } catch (Exception e) {
            System.err.println("Error getting recent activity: " + e.getMessage());
            result.put("success", false);
            result.put("error", "Error fetching recent activity: " + e.getMessage());
            result.put("recentUsersCount", 0);
            result.put("recentCoursesCount", 0);
        }
        
        return result;
    }
    
    /**
     * Get system health status
     */
    public Map<String, Object> getSystemHealth() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Database connectivity test
            boolean dbConnected = true;
            try {
                usersJpaController.getUsersCount();
            } catch (Exception e) {
                dbConnected = false;
            }
            
            result.put("databaseConnected", dbConnected);
            result.put("systemStatus", dbConnected ? "Healthy" : "Issues Detected");
            result.put("success", true);
            
        } catch (Exception e) {
            System.err.println("Error checking system health: " + e.getMessage());
            result.put("success", false);
            result.put("error", "Error checking system health: " + e.getMessage());
            result.put("databaseConnected", false);
            result.put("systemStatus", "Error");
=======
import dao.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardController {
    
    public DashboardController() {
    }
    
    public Map<String, Object> getOverviewData() throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            String userCountSql = "SELECT COUNT(*) as total FROM Users";
            stmt = connection.prepareStatement(userCountSql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                result.put("totalUsers", rs.getInt("total"));
            } else {
                result.put("totalUsers", 0);
            }
            rs.close();
            stmt.close();
            
            String courseCountSql = "SELECT COUNT(*) as total FROM Courses";
            stmt = connection.prepareStatement(courseCountSql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                result.put("totalCourses", rs.getInt("total"));
            } else {
                result.put("totalCourses", 0);
            }
            rs.close();
            stmt.close();
            
            String enrollmentCountSql = "SELECT COUNT(*) as total FROM Enrollments";
            stmt = connection.prepareStatement(enrollmentCountSql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                result.put("totalEnrollments", rs.getInt("total"));
            } else {
                result.put("totalEnrollments", 0);
            }
            rs.close();
            stmt.close();
            
            String notificationCountSql = "SELECT COUNT(*) as total FROM Notifications";
            stmt = connection.prepareStatement(notificationCountSql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                result.put("totalNotifications", rs.getInt("total"));
            } else {
                result.put("totalNotifications", 0);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting overview data: " + e.getMessage());
            result.put("totalUsers", 0);
            result.put("totalCourses", 0);
            result.put("totalEnrollments", 0);
            result.put("totalNotifications", 0);
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (connection != null && !connection.isClosed()) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
        }
        
        return result;
    }
<<<<<<< HEAD
}
=======
    
    public Map<String, Object> getMonthlyEnrollments() throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            String sql = "SELECT " +
                        "MONTH(CreationTime) as month, " +
                        "YEAR(CreationTime) as year, " +
                        "COUNT(*) as count " +
                        "FROM Enrollments " +
                        "WHERE CreationTime >= DATEADD(month, -12, GETDATE()) " +
                        "GROUP BY YEAR(CreationTime), MONTH(CreationTime) " +
                        "ORDER BY year, month";
                        
            stmt = connection.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            List<Map<String, Object>> monthlyData = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> monthData = new HashMap<>();
                monthData.put("month", rs.getInt("month"));
                monthData.put("year", rs.getInt("year"));
                monthData.put("count", rs.getInt("count"));
                monthlyData.add(monthData);
            }
            result.put("monthlyEnrollments", monthlyData);
            
        } catch (SQLException e) {
            System.err.println("Error getting monthly enrollments: " + e.getMessage());
            result.put("monthlyEnrollments", new ArrayList<>());
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (connection != null && !connection.isClosed()) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
        
        return result;
    }
    
    public Map<String, Object> getTopCourses() throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            String sql = "SELECT TOP 5 " +
                        "c.Title, " +
                        "c.Description, " +
                        "COUNT(e.CourseId) as enrollmentCount " +
                        "FROM Courses c " +
                        "LEFT JOIN Enrollments e ON c.Id = e.CourseId " +
                        "GROUP BY c.Id, c.Title, c.Description " +
                        "ORDER BY enrollmentCount DESC";
                        
            stmt = connection.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            List<Map<String, Object>> topCourses = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> course = new HashMap<>();
                course.put("title", rs.getString("Title"));
                course.put("description", rs.getString("Description"));
                course.put("enrollmentCount", rs.getInt("enrollmentCount"));
                topCourses.add(course);
            }
            result.put("topCourses", topCourses);
            
        } catch (SQLException e) {
            System.err.println("Error getting top courses: " + e.getMessage());
            result.put("topCourses", new ArrayList<>());
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (connection != null && !connection.isClosed()) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
        
        return result;
    }
    
    public Map<String, Object> getRecentActivities() throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            // Get recent enrollments
            String sql = "SELECT TOP 10 " +
                        "u.FullName, " +
                        "c.Title as courseTitle, " +
                        "e.CreationTime, " +
                        "'enrollment' as activityType " +
                        "FROM Enrollments e " +
                        "JOIN Users u ON e.CreatorId = u.Id " +
                        "JOIN Courses c ON e.CourseId = c.Id " +
                        "ORDER BY e.CreationTime DESC";
                        
            stmt = connection.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            List<Map<String, Object>> activities = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> activity = new HashMap<>();
                activity.put("userName", rs.getString("FullName"));
                activity.put("courseTitle", rs.getString("courseTitle"));
                activity.put("date", rs.getTimestamp("CreationTime"));
                activity.put("type", rs.getString("activityType"));
                activities.add(activity);
            }
            result.put("recentActivities", activities);
            
        } catch (SQLException e) {
            System.err.println("Error getting recent activities: " + e.getMessage());
            result.put("recentActivities", new ArrayList<>());
            throw e;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (connection != null && !connection.isClosed()) {
                    connection.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing database resources: " + e.getMessage());
            }
        }
        
        return result;
    }
    
    public boolean testDatabaseConnection() {
        return DBConnection.testConnection();
    }
    
    /**
     * Get all dashboard data in one method call
     */
    public Map<String, Object> getAllDashboardData() throws SQLException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Get overview data
            Map<String, Object> overview = getOverviewData();
            result.put("overview", overview);
            
            // Get monthly enrollments
            Map<String, Object> monthly = getMonthlyEnrollments();
            result.put("monthly", monthly);
            
            // Get top courses  
            Map<String, Object> topCourses = getTopCourses();
            result.put("topCourses", topCourses);
            
            // Get recent activities
            Map<String, Object> activities = getRecentActivities();
            result.put("activities", activities);
            
            result.put("success", true);
            
        } catch (SQLException e) {
            result.put("success", false);
            result.put("error", e.getMessage());
            throw e;
        }
        
        return result;
    }
}
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
