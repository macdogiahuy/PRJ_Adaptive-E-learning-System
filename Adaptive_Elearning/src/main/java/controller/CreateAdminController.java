package controller;

import services.AdminService;
import services.ServiceResults.AdminCreationResult;
import services.ServiceResults.ValidationResult;
import services.AdminServiceImpl;
import java.sql.SQLException;
import java.util.Date;

/**
 * Controller for Admin Creation - Now using Service Layer Pattern
 * This controller acts as a thin layer between the web layer and business logic
 */
public class CreateAdminController {
    
    private AdminService adminService;
    
    public CreateAdminController() {
        this.adminService = new AdminServiceImpl();
    }
    
    /**
     * Create a new admin user - delegates to service layer
     * @return AdminCreationResult with detailed result information
     */
    public AdminCreationResult createAdmin(String userName, String password, String email, String fullName, 
                                          String phone, String bio, Date dateOfBirth) throws SQLException {
        return adminService.createAdmin(userName, password, email, fullName, phone, bio, dateOfBirth);
    }
    
    /**
     * Create admin with simple boolean result for backward compatibility
     */
    public boolean createAdminSimple(String userName, String password, String email, String fullName, 
                                    String phone, String bio, Date dateOfBirth) throws SQLException {
        AdminCreationResult result = adminService.createAdmin(userName, password, email, fullName, phone, bio, dateOfBirth);
        return result.isSuccess();
    }
    
    /**
     * Check if user exists - delegates to service layer
     */
    public boolean isUserExists(String userName, String email) throws SQLException {
        return adminService.isUserExists(userName, email);
    }
    
    /**
     * Get admin count - delegates to service layer  
     */
    public int getUserCount() throws SQLException {
        return adminService.getAdminCount();
    }
    
    /**
     * Validate admin data - delegates to service layer
     */
    public ValidationResult validateAdminData(String userName, String password, String email, String fullName) {
        return adminService.validateAdminData(userName, password, email, fullName);
    }
    
    /**
     * Test database connection - delegates to service layer
     */
    public boolean testDatabaseConnection() {
        return adminService.testConnection();
    }
    
    /**
     * Get detailed error information from last operation
     */
    public String getLastErrorMessage() {
        // This could be enhanced to store last operation result
        return "Check validation result for detailed error information";
    }
}