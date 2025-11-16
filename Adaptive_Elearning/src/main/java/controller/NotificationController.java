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

public class NotificationController {
    
    private static final int RECORDS_PER_PAGE = 10;
    
    public NotificationController() {
    }
    
    /**
     * Get paginated notifications with search filter
     */
    public Map<String, Object> getNotifications(int page, String searchType) throws SQLException {
        return getNotifications(page, searchType, RECORDS_PER_PAGE);
    }
    
    /**
     * Get paginated notifications with search filter and custom page size
     */
    public Map<String, Object> getNotifications(int page, String searchType, int recordsPerPage) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            // Build WHERE clause for search
            String whereClause = "";
            if (searchType != null && !searchType.trim().isEmpty() && !searchType.equals("all")) {
                whereClause = " WHERE Type LIKE ?";
            }
            
            // Get total count for pagination
            String countSql = "SELECT COUNT(*) as total FROM Notifications" + whereClause;
            stmt = connection.prepareStatement(countSql);
            if (!whereClause.isEmpty()) {
                stmt.setString(1, "%" + searchType + "%");
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
            
            // Get paginated notifications - use CAST for uniqueidentifier
            String sql = "SELECT CAST(Id as NVARCHAR(50)) as Id, Type, CAST(CreatorId as NVARCHAR(50)) as CreatorId, CreationTime, Status " +
                        "FROM Notifications" + whereClause + 
                        " ORDER BY CreationTime DESC " +
                        "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            
            stmt = connection.prepareStatement(sql);
            int paramIndex = 1;
            if (!whereClause.isEmpty()) {
                stmt.setString(paramIndex++, "%" + searchType + "%");
            }
            stmt.setInt(paramIndex++, offset);
            stmt.setInt(paramIndex, recordsPerPage);
            
            rs = stmt.executeQuery();
            
            List<Map<String, Object>> notifications = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> notification = new HashMap<>();
                notification.put("id", rs.getString("Id")); // Changed from getInt to getString
                notification.put("type", rs.getString("Type"));
                notification.put("creatorId", rs.getString("CreatorId"));
                notification.put("creationTime", rs.getTimestamp("CreationTime"));
                notification.put("status", rs.getString("Status"));
                notifications.add(notification);
            }
            
            result.put("notifications", notifications);
            result.put("currentPage", page);
            result.put("totalPages", totalPages);
            result.put("totalRecords", totalRecords);
            result.put("recordsPerPage", recordsPerPage);
            result.put("searchType", searchType);
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return result;
    }
    
    /**
     * Get distinct notification types for search dropdown
     */
    public List<String> getNotificationTypes() throws SQLException {
        List<String> types = new ArrayList<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = "SELECT DISTINCT Type FROM Notifications WHERE Type IS NOT NULL ORDER BY Type";
            stmt = connection.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                types.add(rs.getString("Type"));
            }
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return types;
    }
    
    /**
     * Update notification status
     */
    public boolean updateNotificationStatus(String notificationId, String status) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = "UPDATE Notifications SET Status = ? WHERE CAST(Id as NVARCHAR(50)) = ?";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setString(2, notificationId); // Changed from setInt to setString
            
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
            Connection connection = DBConnection.getConnection();
            if (connection != null) {
                connection.close();
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}