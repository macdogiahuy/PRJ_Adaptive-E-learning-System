package dao;

import java.sql.Timestamp;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Users;
import utils.SHA256Helper;

public class UserDAO {

    private static final String CHECK_EXIST
            = "SELECT COUNT(*) FROM Users WHERE UserName = ? OR Email = ?";

    private static final String REGISTER_USER
            = "INSERT INTO Users "
            + "(Id, UserName, Email, Password, FullName, MetaFullName, Role, AvatarUrl, Bio, "
            + "Token, RefreshToken, IsVerified, IsApproved, AccessFailedCount, DateOfBirth, "
            + "EnrollmentCount, CreationTime, LastModificationTime, SystemBalance) "
            + "VALUES (NEWID(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, GETDATE(), GETDATE(), 0)";

    private static final String LOGIN_SQL
            = "SELECT Id, UserName, Role FROM Users WHERE (UserName=? OR Email=?) AND Password=?";

    public boolean registerUser(Users user) {
        try (Connection con = DBConnection.getConnection()) {

            try (PreparedStatement ps = con.prepareStatement(CHECK_EXIST)) {
                ps.setString(1, user.getUserName());
                ps.setString(2, user.getEmail());
                ResultSet rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    return false; 
                }
            }

            String hashedPassword = SHA256Helper.hash(user.getPassword());

            try (PreparedStatement ps = con.prepareStatement(REGISTER_USER)) {
                ps.setString(1, user.getUserName());
                ps.setString(2, user.getEmail());
                ps.setString(3, hashedPassword);
                ps.setString(4, user.getFullName() != null ? user.getFullName() : user.getUserName());
                ps.setString(5, user.getMetaFullName() != null ? user.getMetaFullName() : user.getUserName());
                ps.setString(6, user.getRole() != null ? user.getRole() : "Student");
                ps.setString(7, user.getAvatarUrl() != null ? user.getAvatarUrl() : "");
                ps.setString(8, user.getBio() != null ? user.getBio() : "");
                ps.setString(9, user.getToken() != null ? user.getToken() : "");
                ps.setString(10, user.getRefreshToken() != null ? user.getRefreshToken() : "");
                ps.setBoolean(11, user.getIsVerified());
                ps.setBoolean(12, user.getIsApproved());
                ps.setInt(13, user.getAccessFailedCount());
                ps.setDate(14, java.sql.Date.valueOf("2000-01-01")); 
                ps.executeUpdate();
            }

            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Users checkLogin(String nameOrEmail, String password) {
        Users us = null;
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(LOGIN_SQL)) {

            String hashedPassword = SHA256Helper.hash(password);
            ps.setString(1, nameOrEmail);
            ps.setString(2, nameOrEmail);
            ps.setString(3, hashedPassword);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    us = new Users();
                    us.setId(rs.getString("Id"));
                    us.setUserName(rs.getString("UserName"));
                    us.setRole(rs.getString("Role"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return us;
    }
    private static final String FIND_BY_EMAIL
            = "SELECT TOP 1 Id, UserName, Email, Role, Token, LastModificationTime FROM Users WHERE Email = ?";

    private static final String FIND_BY_EMAIL_WITH_VALID_OTP = """
        SELECT TOP 1 Id, UserName, Email, Role, Token, LastModificationTime
        FROM Users
        WHERE Email = ?
          AND Token = ?
          AND LastModificationTime IS NOT NULL
          AND DATEDIFF(MINUTE, LastModificationTime, GETDATE()) <= ?
        """;
    private static final String ISSUE_RESET_OTP
            = "UPDATE Users SET Token = ?, LastModificationTime = GETDATE() WHERE Id = ?";

    private static final String UPDATE_PASSWORD_HASH
            = "UPDATE Users SET Password = ?, Token = '', LastModificationTime = GETDATE() WHERE Id = ?";

    private static final String CLEAR_TOKEN
            = "UPDATE Users SET Token = '' WHERE Id = ?";

    public Users findByEmail(String email) {
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(FIND_BY_EMAIL)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBasicUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void issueResetOtp(String userId, String otp6) {
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(ISSUE_RESET_OTP)) {
            ps.setString(1, otp6);
            ps.setString(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Users findByEmailWithValidOtp(String email, String otp6, int ttlMinutes) {
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(FIND_BY_EMAIL_WITH_VALID_OTP)) {
            ps.setString(1, email);
            ps.setString(2, otp6);
            ps.setInt(3, ttlMinutes);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBasicUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updatePasswordHash(String userId, String newPlainPassword) {
        String newHash = SHA256Helper.hash(newPlainPassword);
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(UPDATE_PASSWORD_HASH)) {
            ps.setString(1, newHash);
            ps.setString(2, userId);
            int rows = ps.executeUpdate();
            System.out.println("[UserDAO] rows=" + rows + " for Id=" + userId);
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void clearToken(String userId) {
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(CLEAR_TOKEN)) {
            ps.setString(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Users mapBasicUser(ResultSet rs) throws SQLException {
        Users u = new Users();
        u.setId(rs.getString("Id"));
        u.setUserName(rs.getString("UserName"));
        u.setEmail(rs.getString("Email"));
        u.setRole(rs.getString("Role"));
        u.setToken(rs.getString("Token"));
        Timestamp lm = rs.getTimestamp("LastModificationTime");
        if (lm != null) {
            u.setLastModificationTime(new java.util.Date(lm.getTime()));
        }
        return u;
    }

    public Users findOrCreateGoogleUser(String email, String name, String avatarUrl, String googleId) {
        Users existing = findByEmail(email);
        if (existing != null) {
            return existing;
        }

        Users newUser = new Users();
        newUser.setUserName(email);
        newUser.setEmail(email);
        newUser.setFullName(name);
        newUser.setMetaFullName(name);
        newUser.setAvatarUrl(avatarUrl);
        newUser.setPassword(""); 
        newUser.setRole("Student");
        newUser.setToken("");
        newUser.setRefreshToken("");
        newUser.setIsVerified(true);
        newUser.setIsApproved(true);
        newUser.setAccessFailedCount((short) 0);
        newUser.setLoginProvider("Google");
        newUser.setProviderKey(googleId);

        boolean ok = registerUser(newUser);
        return ok ? findByEmail(email) : null;
    }

}
