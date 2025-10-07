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


public class ReportedGroupController {
    
    private static final int RECORDS_PER_PAGE = 10;
    
    public ReportedGroupController() {
    }
    
    /**
     * Get paginated reported groups with search filter
     */
    public Map<String, Object> getReportedGroups(int page, String searchReporter) throws SQLException {
        return getReportedGroups(page, searchReporter, RECORDS_PER_PAGE);
    }
    
    /**
     * Get paginated reported groups with search filter and custom page size
     */
    public Map<String, Object> getReportedGroups(int page, String searchReporter, int recordsPerPage) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> reportedGroups = new ArrayList<>();
        
        try {
            connection = DBConnection.getConnection();
            
            // Base query for reported groups
            String baseQuery = "SELECT n.Id, n.Message, n.CreationTime, n.CreatorId, n.Status, " +
                             "u.FullName as ReporterName, u.Email as ReporterEmail, " +
                             "c.Title as GroupName, c.Id as ConversationId " +
                             "FROM Notifications n " +
                             "INNER JOIN Users u ON n.CreatorId = u.Id " +
                             "LEFT JOIN Conversations c ON JSON_VALUE(n.Message, '$.Conversation') = c.Id " +
                             "WHERE n.Type = 'ReportGroup'";
            
            String whereClause = "";
            List<String> params = new ArrayList<>();
            
            // Add search filter
            if (searchReporter != null && !searchReporter.trim().isEmpty()) {
                whereClause += " AND (u.FullName LIKE ? OR u.Email LIKE ?)";
                params.add("%" + searchReporter + "%");
                params.add("%" + searchReporter + "%");
            }
            
            // Count total records
            String countQuery = "SELECT COUNT(*) as total FROM (" + baseQuery + whereClause + ") as countTable";
            stmt = connection.prepareStatement(countQuery);
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setString(i + 1, params.get(i));
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
            
            // Get paginated data
            String paginatedQuery = baseQuery + whereClause + 
                                  " ORDER BY n.CreationTime DESC " +
                                  "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            
            stmt = connection.prepareStatement(paginatedQuery);
            
            int paramIndex = 1;
            for (String param : params) {
                stmt.setString(paramIndex++, param);
            }
            stmt.setInt(paramIndex++, offset);
            stmt.setInt(paramIndex, recordsPerPage);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> reportedGroup = new HashMap<>();
                reportedGroup.put("id", rs.getString("Id"));
                reportedGroup.put("reporterName", rs.getString("ReporterName"));
                reportedGroup.put("reporterEmail", rs.getString("ReporterEmail"));
                reportedGroup.put("groupName", rs.getString("GroupName"));
                reportedGroup.put("conversationId", rs.getString("ConversationId"));
                reportedGroup.put("creationTime", rs.getTimestamp("CreationTime"));
                reportedGroup.put("status", rs.getString("Status"));
                
                // Parse message JSON to extract report reason  
                String messageJson = rs.getString("Message");
                String reportMessage = "N/A";
                if (messageJson != null && !messageJson.trim().isEmpty()) {
                    try {
                        // Simple JSON parsing for {"Message":"value"}
                        if (messageJson.contains("\"Message\":")) {
                            int startIndex = messageJson.indexOf("\"Message\":\"") + 11;
                            int endIndex = messageJson.indexOf("\"", startIndex);
                            if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
                                reportMessage = messageJson.substring(startIndex, endIndex);
                            }
                        }
                    } catch (Exception e) {
                        reportMessage = "Invalid message format";
                    }
                }
                reportedGroup.put("message", reportMessage);
                
                reportedGroups.add(reportedGroup);
            }
            
            result.put("reportedGroups", reportedGroups);
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
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        Map<String, Object> stats = new HashMap<>();
        
        try {
            connection = DBConnection.getConnection();
            
            // Get total reported groups
            String totalQuery = "SELECT COUNT(*) as total FROM Notifications WHERE Type = 'ReportGroup'";
            stmt = connection.prepareStatement(totalQuery);
            rs = stmt.executeQuery();
            
            int totalReports = 0;
            if (rs.next()) {
                totalReports = rs.getInt("total");
            }
            rs.close();
            stmt.close();
            
            // Get status statistics
            String statusQuery = "SELECT Status, COUNT(*) as count FROM Notifications WHERE Type = 'ReportGroup' GROUP BY Status";
            stmt = connection.prepareStatement(statusQuery);
            rs = stmt.executeQuery();
            
            Map<String, Integer> statusStats = new HashMap<>();
            while (rs.next()) {
                String status = rs.getString("Status");
                if (status == null || status.trim().isEmpty()) {
                    status = "Pending";
                }
                statusStats.put(status, rs.getInt("count"));
            }
            
            stats.put("totalReports", totalReports);
            stats.put("statusStats", statusStats);
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return stats;
    }
    
    /**
     * Alert admin about a reported group
     */
    public boolean alertAdmin(String reportId) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = "UPDATE Notifications SET Status = 'AlertedAdmin' WHERE Id = ? AND Type = 'ReportGroup'";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, reportId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } finally {
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    /**
     * Dismiss a reported group
     */
    public boolean dismissReport(String reportId) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = "UPDATE Notifications SET Status = 'Dismissed' WHERE Id = ? AND Type = 'ReportGroup'";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, reportId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } finally {
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    /**
     * Test database connection
     */
    public boolean testDatabaseConnection() {
        try {
            Connection conn = DBConnection.getConnection();
            if (conn != null) {
                conn.close();
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}