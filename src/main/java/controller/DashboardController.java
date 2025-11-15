package controller;

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
        }
        
        return result;
    }
    
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
