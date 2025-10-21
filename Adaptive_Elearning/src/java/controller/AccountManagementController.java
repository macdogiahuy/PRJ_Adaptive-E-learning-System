package controller;

<<<<<<< HEAD
=======
import dao.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
<<<<<<< HEAD
import java.util.Date;
import model.Users;

/**
 * Account Management Controller - Converted to use JPA
 * @author LP
 */
public class AccountManagementController {
    
    private static final int RECORDS_PER_PAGE = 10;
    private UsersJpaController usersJpaController;
    
    public AccountManagementController() {
        this.usersJpaController = new UsersJpaController();
=======

public class AccountManagementController {
    
    private static final int RECORDS_PER_PAGE = 10;
    
    public AccountManagementController() {
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
    }
    
    /**
     * Get paginated users with search filter
     */
<<<<<<< HEAD
    public Map<String, Object> getUsers(int page, String searchRole) {
=======
    public Map<String, Object> getUsers(int page, String searchRole) throws SQLException {
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
        return getUsers(page, searchRole, RECORDS_PER_PAGE);
    }
    
    /**
     * Get paginated users with search filter and custom page size
     */
<<<<<<< HEAD
    public Map<String, Object> getUsers(int page, String searchRole, int recordsPerPage) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Get all users or filtered by role
            List<Users> allUsers;
            if (searchRole != null && !searchRole.trim().isEmpty() && !searchRole.equals("all")) {
                allUsers = usersJpaController.findByRole(searchRole);
            } else {
                allUsers = usersJpaController.findUsersEntities();
            }
            
            // Calculate pagination
            int totalRecords = allUsers.size();
            int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            int offset = (page - 1) * recordsPerPage;
            int endIndex = Math.min(offset + recordsPerPage, totalRecords);
            
            // Get paginated subset
            List<Users> paginatedUsers = allUsers.subList(offset, endIndex);
            
            // Convert to display format
            List<Map<String, Object>> users = new ArrayList<>();
            for (Users user : paginatedUsers) {
                Map<String, Object> userMap = new HashMap<>();
                userMap.put("id", user.getId());
                userMap.put("fullName", user.getFullName());
                userMap.put("email", user.getEmail());
                userMap.put("role", user.getRole());
                userMap.put("creationTime", user.getCreationTime());
                userMap.put("systemBalance", user.getSystemBalance());
                users.add(userMap);
=======
    public Map<String, Object> getUsers(int page, String searchRole, int recordsPerPage) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            // Build WHERE clause for search
            String whereClause = "";
            if (searchRole != null && !searchRole.trim().isEmpty() && !searchRole.equals("all")) {
                whereClause = " WHERE Role = ?";
            }
            
            // Get total count for pagination
            String countSql = "SELECT COUNT(*) as total FROM Users" + whereClause;
            stmt = connection.prepareStatement(countSql);
            if (!whereClause.isEmpty()) {
                stmt.setString(1, searchRole);
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
            
            // Get paginated users
            String sql = "SELECT Id, FullName, Email, Role, CreationTime, SystemBalance " +
                        "FROM Users" + whereClause + 
                        " ORDER BY CreationTime DESC " +
                        "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
            
            stmt = connection.prepareStatement(sql);
            int paramIndex = 1;
            if (!whereClause.isEmpty()) {
                stmt.setString(paramIndex++, searchRole);
            }
            stmt.setInt(paramIndex++, offset);
            stmt.setInt(paramIndex, recordsPerPage);
            
            rs = stmt.executeQuery();
            
            List<Map<String, Object>> users = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> user = new HashMap<>();
                user.put("id", rs.getString("Id"));
                user.put("fullName", rs.getString("FullName"));
                user.put("email", rs.getString("Email"));
                user.put("role", rs.getString("Role"));
                user.put("creationTime", rs.getTimestamp("CreationTime"));
                user.put("systemBalance", rs.getLong("SystemBalance"));
                users.add(user);
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
            }
            
            result.put("users", users);
            result.put("currentPage", page);
            result.put("totalPages", totalPages);
            result.put("totalRecords", totalRecords);
            result.put("recordsPerPage", recordsPerPage);
            result.put("searchRole", searchRole);
            
<<<<<<< HEAD
        } catch (Exception e) {
            result.put("error", "Error fetching users: " + e.getMessage());
            result.put("users", new ArrayList<>());
            result.put("currentPage", page);
            result.put("totalPages", 0);
            result.put("totalRecords", 0);
=======
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
        }
        
        return result;
    }
    
    /**
<<<<<<< HEAD
     * Get available roles for dropdown
     */
    public List<String> getRoles() {
        List<String> roles = new ArrayList<>();
        try {
            List<Users> allUsers = usersJpaController.findUsersEntities();
            for (Users user : allUsers) {
                String role = user.getRole();
                if (role != null && !roles.contains(role)) {
                    roles.add(role);
                }
            }
        } catch (Exception e) {
            System.err.println("Error getting roles: " + e.getMessage());
        }
=======
     * Get distinct user roles for search dropdown
     */
    public List<String> getUserRoles() throws SQLException {
        List<String> roles = new ArrayList<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = "SELECT DISTINCT Role FROM Users WHERE Role IS NOT NULL ORDER BY Role";
            stmt = connection.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                String role = rs.getString("Role");
                if (role != null && !role.trim().isEmpty()) {
                    roles.add(role.trim());
                }
            }
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
        return roles;
    }
    
    /**
     * Get user statistics
     */
<<<<<<< HEAD
    public Map<String, Object> getUserStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            // Total users count
            int totalUsers = usersJpaController.getUsersCount();
            stats.put("totalUsers", totalUsers);
            
            // Users by role
            Map<String, Integer> roleStats = new HashMap<>();
            List<String> roles = getRoles();
            for (String role : roles) {
                int count = usersJpaController.findByRole(role).size();
                roleStats.put(role, count);
            }
            stats.put("roleStats", roleStats);
            
            // Total system balance
            List<Users> allUsers = usersJpaController.findUsersEntities();
            long totalBalance = 0L;
            for (Users user : allUsers) {
                totalBalance += user.getSystemBalance();
            }
            stats.put("totalSystemBalance", totalBalance);
            
        } catch (Exception e) {
            System.err.println("Error getting user statistics: " + e.getMessage());
            stats.put("totalUsers", 0);
            stats.put("roleStats", new HashMap<>());
            stats.put("totalSystemBalance", 0L);
=======
    public Map<String, Object> getUserStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            // Total users count
            String totalSql = "SELECT COUNT(*) as total FROM Users";
            stmt = connection.prepareStatement(totalSql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalUsers", rs.getInt("total"));
            }
            rs.close();
            stmt.close();
            
            // Users by role
            String roleSql = "SELECT Role, COUNT(*) as count FROM Users WHERE Role IS NOT NULL GROUP BY Role ORDER BY count DESC";
            stmt = connection.prepareStatement(roleSql);
            rs = stmt.executeQuery();
            
            Map<String, Integer> roleStats = new HashMap<>();
            while (rs.next()) {
                roleStats.put(rs.getString("Role"), rs.getInt("count"));
            }
            stats.put("roleStats", roleStats);
            rs.close();
            stmt.close();
            
            // Total system balance
            String balanceSql = "SELECT SUM(SystemBalance) as totalBalance FROM Users";
            stmt = connection.prepareStatement(balanceSql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                stats.put("totalSystemBalance", rs.getLong("totalBalance"));
            }
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
        }
        
        return stats;
    }
    
    /**
     * Update user role
     */
<<<<<<< HEAD
    public boolean updateUserRole(String userId, String newRole) {
        try {
            Users user = usersJpaController.findUser(userId);
            if (user != null) {
                user.setRole(newRole);
                user.setLastModificationTime(new Date());
                usersJpaController.edit(user);
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("Error updating user role: " + e.getMessage());
            return false;
=======
    public boolean updateUserRole(String userId, String newRole) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = "UPDATE Users SET Role = ?, LastModificationTime = GETDATE() WHERE Id = ?";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, newRole);
            stmt.setString(2, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } finally {
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
        }
    }
    
    /**
<<<<<<< HEAD
     * Deactivate user (soft delete by setting role to 'Inactive')
     */
    public boolean deactivateUser(String userId) {
        try {
            Users user = usersJpaController.findUser(userId);
            if (user != null) {
                user.setRole("Inactive");
                user.setLastModificationTime(new Date());
                usersJpaController.edit(user);
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("Error deactivating user: " + e.getMessage());
            return false;
=======
     * Delete user (soft delete by setting role to 'Inactive')
     */
    public boolean deactivateUser(String userId) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = "UPDATE Users SET Role = 'Inactive', LastModificationTime = GETDATE() WHERE Id = ?";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } finally {
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
        }
    }
    
    /**
<<<<<<< HEAD
     * Ban user (set role to 'Inactive')
     */
    public boolean banUser(String userId) {
        return deactivateUser(userId);
    }
    
    /**
     * Unban user (restore previous role from Inactive)
     * Default role will be 'Learner' if no previous role found
     */
    public boolean unbanUser(String userId) {
        try {
            Users user = usersJpaController.findUser(userId);
            if (user != null && "Inactive".equals(user.getRole())) {
                user.setRole("Learner"); // Set default role to 'Learner' for unbanned users
                user.setLastModificationTime(new Date());
                usersJpaController.edit(user);
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("Error unbanning user: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Delete user (hard delete)
     * Note: This is a permanent operation, use with caution
     */
    public boolean deleteUser(String userId) {
        try {
            usersJpaController.destroy(userId);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting user: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get user details by ID
     */
    public Users getUserById(String userId) {
        try {
            return usersJpaController.findUser(userId);
        } catch (Exception e) {
            System.err.println("Error getting user by ID: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Update user system balance
     */
    public boolean updateUserBalance(String userId, long newBalance) {
        try {
            Users user = usersJpaController.findUser(userId);
            if (user != null) {
                user.setSystemBalance(newBalance);
                user.setLastModificationTime(new Date());
                usersJpaController.edit(user);
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("Error updating user balance: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Search users by multiple criteria
     */
    public List<Users> searchUsers(String searchTerm) {
        try {
            if (searchTerm == null || searchTerm.trim().isEmpty()) {
                return usersJpaController.findUsersEntities();
            }
            
            // This is a simple search implementation
            // In a real application, you might want to create custom queries
            List<Users> allUsers = usersJpaController.findUsersEntities();
            List<Users> filteredUsers = new ArrayList<>();
            
            String searchLower = searchTerm.toLowerCase();
            for (Users user : allUsers) {
                boolean matches = false;
                
                if (user.getUserName() != null && user.getUserName().toLowerCase().contains(searchLower)) {
                    matches = true;
                }
                if (user.getEmail() != null && user.getEmail().toLowerCase().contains(searchLower)) {
                    matches = true;
                }
                if (user.getFullName() != null && user.getFullName().toLowerCase().contains(searchLower)) {
                    matches = true;
                }
                if (user.getRole() != null && user.getRole().toLowerCase().contains(searchLower)) {
                    matches = true;
                }
                
                if (matches) {
                    filteredUsers.add(user);
                }
            }
            
            return filteredUsers;
        } catch (Exception e) {
            System.err.println("Error searching users: " + e.getMessage());
            return new ArrayList<>();
        }
=======
     * Unban user (restore previous role from Inactive)
     * Default role will be 'Learner' if no previous role found
     */
    public boolean unbanUser(String userId) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        
        try {
            connection = DBConnection.getConnection();
            // Set default role to 'Learner' for unbanned users
            String sql = "UPDATE Users SET Role = 'Learner', LastModificationTime = GETDATE() WHERE Id = ? AND Role = 'Inactive'";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } finally {
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    /**
     * Get user information by ID
     */
    public Map<String, Object> getUserById(String userId) throws SQLException {
        Map<String, Object> user = null;
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            String sql = "SELECT Id, FullName, Email, Role, CreationTime, SystemBalance FROM Users WHERE Id = ?";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, userId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = new HashMap<>();
                user.put("id", rs.getString("Id"));
                user.put("fullName", rs.getString("FullName"));
                user.put("email", rs.getString("Email"));
                user.put("role", rs.getString("Role"));
                user.put("creationTime", rs.getTimestamp("CreationTime"));
                user.put("systemBalance", rs.getLong("SystemBalance"));
            }
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return user;
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
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
    }
}