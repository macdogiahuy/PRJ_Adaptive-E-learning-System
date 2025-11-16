package services;

import java.util.Date;
import java.sql.SQLException;
import services.ServiceResults.AdminCreationResult;
import services.ServiceResults.ValidationResult;

/**
 * Service interface for Admin Management operations
 */
public interface AdminService {
    
    /**
     * Create a new admin user
     * @param userName Username for the admin
     * @param password Plain text password (will be hashed)
     * @param email Email address
     * @param fullName Full name of the admin
     * @param phone Phone number (optional)
     * @param bio Biography (optional)
     * @param dateOfBirth Date of birth (optional)
     * @return AdminCreationResult containing success status and details
     * @throws SQLException if database error occurs
     */
    AdminCreationResult createAdmin(String userName, String password, String email, 
                                   String fullName, String phone, String bio, Date dateOfBirth) 
                                   throws SQLException;
    
    /**
     * Check if username or email already exists
     * @param userName Username to check
     * @param email Email to check
     * @return true if user exists, false otherwise
     * @throws SQLException if database error occurs
     */
    boolean isUserExists(String userName, String email) throws SQLException;
    
    /**
     * Get admin count
     * @return Number of admin users
     * @throws SQLException if database error occurs
     */
    int getAdminCount() throws SQLException;
    
    /**
     * Validate admin input data
     * @param userName Username
     * @param password Password
     * @param email Email
     * @param fullName Full name
     * @return ValidationResult with validation status and messages
     */
    ValidationResult validateAdminData(String userName, String password, String email, String fullName);
    
    /**
     * Test database connectivity
     * @return true if connection successful
     */
    boolean testConnection();
}