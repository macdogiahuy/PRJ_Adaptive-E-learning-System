package services;

import dao.DBConnection;
import services.ServiceResults.AdminCreationResult;
import services.ServiceResults.ValidationResult;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.UUID;
import java.util.regex.Pattern;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;

/**
 * Implementation of AdminService interface
 * Handles all admin-related business logic
 */
public class AdminServiceImpl implements AdminService {
    
    private static final String EMAIL_PATTERN = 
        "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    
    private static final Pattern emailPattern = Pattern.compile(EMAIL_PATTERN);
    
    @Override
    public AdminCreationResult createAdmin(String userName, String password, String email, 
                                          String fullName, String phone, String bio, Date dateOfBirth) 
                                          throws SQLException {
        
        // Validate input data
        ValidationResult validation = validateAdminData(userName, password, email, fullName);
        if (!validation.isValid()) {
            return AdminCreationResult.validationError(validation.getErrorsAsString());
        }
        
        Connection connection = null;
        PreparedStatement stmt = null;
        
        try {
            connection = DBConnection.getConnection();
            
            // Check if user already exists
            if (isUserExists(userName, email)) {
                return AdminCreationResult.userExists();
            }
            
            // Generate unique ID
            String adminId = UUID.randomUUID().toString();
            
            String sql = "INSERT INTO Users (Id, UserName, Password, Email, FullName, MetaFullName, " +
                        "AvatarUrl, Role, Token, RefreshToken, IsVerified, IsApproved, AccessFailedCount, " +
                        "Bio, DateOfBirth, Phone, EnrollmentCount, CreationTime, LastModificationTime, SystemBalance) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, adminId);
            stmt.setString(2, userName.trim());
            stmt.setString(3, hashPassword(password));
            stmt.setString(4, email.trim().toLowerCase());
            stmt.setString(5, fullName.trim());
            stmt.setString(6, fullName.trim().toLowerCase()); // MetaFullName for search
            stmt.setString(7, ""); // Default avatar URL
            stmt.setString(8, "Admin"); // Role
            stmt.setString(9, ""); // Token
            stmt.setString(10, ""); // RefreshToken
            stmt.setBoolean(11, true); // IsVerified - Admin is pre-verified
            stmt.setBoolean(12, true); // IsApproved - Admin is pre-approved
            stmt.setShort(13, (short) 0); // AccessFailedCount
            stmt.setString(14, bio != null ? bio.trim() : "");
            
            if (dateOfBirth != null) {
                stmt.setTimestamp(15, new java.sql.Timestamp(dateOfBirth.getTime()));
            } else {
                stmt.setTimestamp(15, null);
            }
            
            stmt.setString(16, phone != null ? phone.trim() : "");
            stmt.setInt(17, 0); // EnrollmentCount
            
            Date now = new Date();
            stmt.setTimestamp(18, new java.sql.Timestamp(now.getTime())); // CreationTime
            stmt.setTimestamp(19, new java.sql.Timestamp(now.getTime())); // LastModificationTime
            stmt.setLong(20, 0); // SystemBalance
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                return AdminCreationResult.success("Admin created successfully", adminId);
            } else {
                return AdminCreationResult.failure("Failed to create admin", "DATABASE_ERROR");
            }
            
        } catch (SQLException e) {
            throw e;
        } finally {
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    @Override
    public boolean isUserExists(String userName, String email) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as count FROM Users WHERE LOWER(UserName) = LOWER(?) OR LOWER(Email) = LOWER(?)";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, userName.trim());
            stmt.setString(2, email.trim());
            
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            return false;
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    @Override
    public int getAdminCount() throws SQLException {
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
    
    @Override
    public ValidationResult validateAdminData(String userName, String password, String email, String fullName) {
        ValidationResult result = new ValidationResult();
        
        // Validate username
        if (userName == null || userName.trim().isEmpty()) {
            result.addError("Username is required");
        } else if (userName.trim().length() < 3) {
            result.addError("Username must be at least 3 characters long");
        } else if (userName.trim().length() > 50) {
            result.addError("Username must not exceed 50 characters");
        } else if (!userName.matches("^[a-zA-Z0-9_]+$")) {
            result.addError("Username can only contain letters, numbers, and underscores");
        }
        
        // Validate password
        if (password == null || password.isEmpty()) {
            result.addError("Password is required");
        } else if (password.length() < 6) {
            result.addError("Password must be at least 6 characters long");
        } else if (password.length() > 100) {
            result.addError("Password must not exceed 100 characters");
        }
        
        // Password strength recommendations
        if (password != null && password.length() >= 6) {
            boolean hasUpper = password.matches(".*[A-Z].*");
            boolean hasLower = password.matches(".*[a-z].*");
            boolean hasDigit = password.matches(".*[0-9].*");
            
            if (!hasUpper || !hasLower || !hasDigit) {
                result.addWarning("Password should contain uppercase, lowercase letters and numbers for better security");
            }
        }
        
        // Validate email
        if (email == null || email.trim().isEmpty()) {
            result.addError("Email is required");
        } else if (!emailPattern.matcher(email.trim()).matches()) {
            result.addError("Invalid email format");
        } else if (email.trim().length() > 255) {
            result.addError("Email must not exceed 255 characters");
        }
        
        // Validate full name
        if (fullName == null || fullName.trim().isEmpty()) {
            result.addError("Full name is required");
        } else if (fullName.trim().length() < 2) {
            result.addError("Full name must be at least 2 characters long");
        } else if (fullName.trim().length() > 100) {
            result.addError("Full name must not exceed 100 characters");
        }
        
        return result;
    }
    
    @Override
    public boolean testConnection() {
        try {
            Connection connection = DBConnection.getConnection();
            if (connection != null) {
                connection.close();
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Database connection test failed: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Hash password using SHA-256
     */
    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            
            return hexString.toString();
        } catch (Exception e) {
            System.err.println("Password hashing failed: " + e.getMessage());
            // In production, this should throw an exception rather than return plain text
            throw new RuntimeException("Password hashing failed", e);
        }
    }
}