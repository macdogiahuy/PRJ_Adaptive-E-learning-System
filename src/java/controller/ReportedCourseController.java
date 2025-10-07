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


public class ReportedCourseController {
    
    private static final int RECORDS_PER_PAGE = 8;
    
    public ReportedCourseController() {
    }
    
    /**
     * Test database connection
     */
    public boolean testDatabaseConnection() {
        try (Connection connection = DBConnection.getConnection()) {
            return connection != null && !connection.isClosed();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get reported courses with pagination
     */
    public Map<String, Object> getReportedCourses(int page, String status, int recordsPerPage) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            // Build WHERE clause for status filter
            String whereClause = " WHERE n.Type = 'ReportCourse'";
            if (status != null && !status.trim().isEmpty() && !status.equals("all")) {
                whereClause += " AND n.Status = ?";
            }
            
            // Get total count for pagination
            String countSql = "SELECT COUNT(*) as total FROM Notifications n" + whereClause;
            stmt = connection.prepareStatement(countSql);
            int paramIndex = 1;
            if (status != null && !status.trim().isEmpty() && !status.equals("all")) {
                stmt.setString(paramIndex++, status);
            }
            
            rs = stmt.executeQuery();
            int totalRecords = 0;
            if (rs.next()) {
                totalRecords = rs.getInt("total");
            }
            rs.close();
            stmt.close();
            
            // Calculate pagination
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            int offset = (page - 1) * recordsPerPage;
            
            // Get reported courses with course details
            String sql = "SELECT TOP " + recordsPerPage + " " +
                        "n.Id as NotificationId, " +
                        "n.Message, " +
                        "n.Status as ReportStatus, " +
                        "n.CreationTime as ReportTime, " +
                        "n.CreatorId as ReporterId, " +
                        "c.Id as CourseId, " +
                        "c.Title, " +
                        "c.ThumbUrl, " +
                        "c.Status as CourseStatus, " +
                        "c.Price, " +
                        "c.Level, " +
                        "c.LearnerCount, " +
                        "c.RatingCount, " +
                        "c.TotalRating, " +
                        "u.FullName as ReporterName, " +
                        "u.Email as ReporterEmail, " +
                        "i.FullName as InstructorName " +
                        "FROM Notifications n " +
                        "LEFT JOIN Users u ON n.CreatorId = u.Id " +
                        "LEFT JOIN Courses c ON JSON_VALUE(n.Message, '$.Course') = CAST(c.Id as NVARCHAR(36)) " +
                        "LEFT JOIN Users i ON c.InstructorId = i.Id " +
                        whereClause +
                        " AND n.Id NOT IN (" +
                        "   SELECT TOP " + offset + " n2.Id " +
                        "   FROM Notifications n2 " +
                        (status != null && !status.trim().isEmpty() && !status.equals("all") ? 
                         " WHERE n2.Type = 'ReportCourse' AND n2.Status = ?" : 
                         " WHERE n2.Type = 'ReportCourse'") +
                        "   ORDER BY n2.CreationTime DESC" +
                        ") " +
                        "ORDER BY n.CreationTime DESC";
            
            stmt = connection.prepareStatement(sql);
            paramIndex = 1;
            if (status != null && !status.trim().isEmpty() && !status.equals("all")) {
                stmt.setString(paramIndex++, status);
                if (offset > 0) {
                    stmt.setString(paramIndex++, status);
                }
            }
            
            rs = stmt.executeQuery();
            
            List<Map<String, Object>> reportedCourses = new ArrayList<>();
            
            while (rs.next()) {
                Map<String, Object> report = new HashMap<>();
                
                // Report details
                report.put("notificationId", rs.getString("NotificationId"));
                report.put("reportStatus", rs.getString("ReportStatus"));
                report.put("reportTime", rs.getTimestamp("ReportTime"));
                report.put("reporterId", rs.getString("ReporterId"));
                report.put("reporterName", rs.getString("ReporterName"));
                report.put("reporterEmail", rs.getString("ReporterEmail"));
                
                // Parse report message - simple string extraction
                String messageJson = rs.getString("Message");
                String reportReason = "Unknown";
                try {
                    // Simple JSON parsing without library
                    if (messageJson != null && messageJson.contains("\"Message\":")) {
                        int startIndex = messageJson.indexOf("\"Message\":\"") + 11;
                        int endIndex = messageJson.indexOf("\"", startIndex);
                        if (startIndex > 10 && endIndex > startIndex) {
                            reportReason = messageJson.substring(startIndex, endIndex);
                        }
                    }
                } catch (Exception e) {
                    reportReason = "Parse error";
                }
                report.put("reportReason", reportReason);
                
                // Course details
                report.put("courseId", rs.getString("CourseId"));
                report.put("courseTitle", rs.getString("Title"));
                report.put("courseThumb", rs.getString("ThumbUrl"));
                report.put("courseStatus", rs.getString("CourseStatus"));
                report.put("coursePrice", rs.getDouble("Price"));
                report.put("courseLevel", rs.getString("Level"));
                report.put("learnerCount", rs.getInt("LearnerCount"));
                report.put("ratingCount", rs.getInt("RatingCount"));
                report.put("totalRating", rs.getLong("TotalRating"));
                report.put("instructorName", rs.getString("InstructorName"));
                
                // Calculate average rating
                double avgRating = 0.0;
                if (rs.getInt("RatingCount") > 0) {
                    avgRating = (double) rs.getLong("TotalRating") / rs.getInt("RatingCount");
                }
                report.put("averageRating", avgRating);
                
                reportedCourses.add(report);
            }
            
            result.put("reportedCourses", reportedCourses);
            result.put("currentPage", page);
            result.put("totalPages", totalPages);
            result.put("totalRecords", totalRecords);
            result.put("recordsPerPage", recordsPerPage);
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return result;
    }
    
    /**
     * Get report statistics
     */
    public Map<String, Object> getReportStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            // Total reported courses
            String totalSql = "SELECT COUNT(*) as total FROM Notifications WHERE Type = 'ReportCourse'";
            stmt = connection.prepareStatement(totalSql);
            rs = stmt.executeQuery();
            int totalReports = 0;
            if (rs.next()) {
                totalReports = rs.getInt("total");
            }
            rs.close();
            stmt.close();
            
            // Reports by status
            String statusSql = "SELECT Status, COUNT(*) as count FROM Notifications WHERE Type = 'ReportCourse' GROUP BY Status";
            stmt = connection.prepareStatement(statusSql);
            rs = stmt.executeQuery();
            
            Map<String, Integer> statusStats = new HashMap<>();
            while (rs.next()) {
                String status = rs.getString("Status");
                if (status == null || status.trim().isEmpty()) {
                    status = "None";
                }
                statusStats.put(status, rs.getInt("count"));
            }
            rs.close();
            stmt.close();
            
            // Recent reports (last 7 days)
            String recentSql = "SELECT COUNT(*) as recent FROM Notifications WHERE Type = 'ReportCourse' AND CreationTime >= DATEADD(day, -7, GETDATE())";
            stmt = connection.prepareStatement(recentSql);
            rs = stmt.executeQuery();
            int recentReports = 0;
            if (rs.next()) {
                recentReports = rs.getInt("recent");
            }
            rs.close();
            stmt.close();
            
            // Top report reasons
            String reasonSql = "SELECT JSON_VALUE(Message, '$.Message') as reason, COUNT(*) as count " +
                              "FROM Notifications WHERE Type = 'ReportCourse' " +
                              "GROUP BY JSON_VALUE(Message, '$.Message') " +
                              "ORDER BY COUNT(*) DESC";
            stmt = connection.prepareStatement(reasonSql);
            rs = stmt.executeQuery();
            
            Map<String, Integer> reasonStats = new HashMap<>();
            while (rs.next()) {
                String reason = rs.getString("reason");
                if (reason == null || reason.trim().isEmpty()) {
                    reason = "Unknown";
                }
                reasonStats.put(reason, rs.getInt("count"));
            }
            
            stats.put("totalReports", totalReports);
            stats.put("statusStats", statusStats);
            stats.put("recentReports", recentReports);
            stats.put("reasonStats", reasonStats);
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return stats;
    }
    
    /**
     * Update report status
     */
    public boolean updateReportStatus(String notificationId, String newStatus) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        
        try {
            connection = DBConnection.getConnection();
            
            String sql = "UPDATE Notifications SET Status = ? WHERE Id = ? AND Type = 'ReportCourse'";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, newStatus);
            stmt.setString(2, notificationId);
            
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
            
        } finally {
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    /**
     * Suspend course
     */
    public boolean suspendCourse(String courseId) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        
        try {
            connection = DBConnection.getConnection();
            
            String sql = "UPDATE Courses SET Status = 'Suspended' WHERE Id = ?";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, courseId);
            
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
            
        } finally {
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    /**
     * Get report statuses for dropdown
     */
    public List<String> getReportStatuses() throws SQLException {
        List<String> statuses = new ArrayList<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            String sql = "SELECT DISTINCT Status FROM Notifications WHERE Type = 'ReportCourse'";
            stmt = connection.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                String status = rs.getString("Status");
                if (status == null || status.trim().isEmpty()) {
                    status = "None";
                }
                if (!statuses.contains(status)) {
                    statuses.add(status);
                }
            }
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return statuses;
    }
}