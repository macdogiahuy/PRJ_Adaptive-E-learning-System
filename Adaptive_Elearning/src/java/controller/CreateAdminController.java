package controller;

import dao.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.UUID;

public class CreateAdminController {
    
    public CreateAdminController() {
    }
    
    /**
     * Create a new admin user
     */
    public boolean createAdmin(String userName, String password, String email, String fullName, 
                              String phone, String bio, Date dateOfBirth) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        
        try {
            connection = DBConnection.getConnection();
            
            // Check if username or email already exists
            if (isUserExists(connection, userName, email)) {
                return false;
            }
            
            // Generate unique ID
            String userId = UUID.randomUUID().toString();
            
            String sql = "INSERT INTO Users (Id, UserName, Password, Email, FullName, MetaFullName, " +
                        "AvatarUrl, Role, Token, RefreshToken, IsVerified, IsApproved, AccessFailedCount, " +
                        "Bio, DateOfBirth, Phone, EnrollmentCount, CreationTime, LastModificationTime, SystemBalance) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, userId);
            stmt.setString(2, userName);
            stmt.setString(3, password); // In production, this should be hashed
            stmt.setString(4, email);
            stmt.setString(5, fullName);
            stmt.setString(6, fullName.toLowerCase()); // MetaFullName for search
            stmt.setString(7, ""); // Default avatar URL
            stmt.setString(8, "Admin"); // Role
            stmt.setString(9, ""); // Token
            stmt.setString(10, ""); // RefreshToken
            stmt.setBoolean(11, true); // IsVerified - Admin is pre-verified
            stmt.setBoolean(12, true); // IsApproved - Admin is pre-approved
            stmt.setShort(13, (short) 0); // AccessFailedCount
            stmt.setString(14, bio != null ? bio : "");
            if (dateOfBirth != null) {
                stmt.setTimestamp(15, new java.sql.Timestamp(dateOfBirth.getTime()));
            } else {
                stmt.setTimestamp(15, null);
            }
            stmt.setString(16, phone != null ? phone : "");
            stmt.setInt(17, 0); // EnrollmentCount
            
            Date now = new Date();
            stmt.setTimestamp(18, new java.sql.Timestamp(now.getTime())); // CreationTime
            stmt.setTimestamp(19, new java.sql.Timestamp(now.getTime())); // LastModificationTime
            stmt.setLong(20, 0); // SystemBalance
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } finally {
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    /**
     * Check if username or email already exists
     */
    private boolean isUserExists(Connection connection, String userName, String email) throws SQLException {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT COUNT(*) as count FROM Users WHERE UserName = ? OR Email = ?";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, userName);
            stmt.setString(2, email);
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            return false;
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
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
    
    /**
     * Get user count for validation
     */
    public int getUserCount() throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as total FROM Users WHERE Role = 'Admin'";
            stmt = connection.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
}