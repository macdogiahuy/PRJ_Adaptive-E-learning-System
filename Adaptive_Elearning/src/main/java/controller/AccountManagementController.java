package controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import dao.DBConnection;

public class AccountManagementController {

    private static final int RECORDS_PER_PAGE = 10;

    public AccountManagementController() {
    }

    /**
     * Get paginated users with search filter
     */
    public Map<String, Object> getUsers(int page, String searchRole) throws SQLException {
        return getUsers(page, searchRole, RECORDS_PER_PAGE);
    }

    /**
     * Get paginated users with search filter and custom page size
     */
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
            }

            result.put("users", users);
            result.put("currentPage", page);
            result.put("totalPages", totalPages);
            result.put("totalRecords", totalRecords);
            result.put("recordsPerPage", recordsPerPage);
            result.put("searchRole", searchRole);

        } finally {
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            if (connection != null)
                connection.close();
        }

        return result;
    }

    /**
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
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            if (connection != null)
                connection.close();
        }

        return roles;
    }

    /**
     * Get user statistics
     */
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
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            if (connection != null)
                connection.close();
        }

        return stats;
    }

    /**
     * Update user role
     */
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
            if (stmt != null)
                stmt.close();
            if (connection != null)
                connection.close();
        }
    }

    /**
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
            if (stmt != null)
                stmt.close();
            if (connection != null)
                connection.close();
        }
    }

    /**
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
            if (stmt != null)
                stmt.close();
            if (connection != null)
                connection.close();
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
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            if (connection != null)
                connection.close();
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
    }
}