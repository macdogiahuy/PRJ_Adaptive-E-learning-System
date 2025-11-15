package userDAO;

import dao.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.UUID;
import model.User;
import model.User.Role;

public class UserDAO {

    private static final String LOGIN_SQL
            = "SELECT Id, UserName, Role FROM Users WHERE (UserName=? OR Email=?) AND [Password]=?";

    public User checkLogin(String nameOrEmail, String password) {
        User us = null;
        String sql = "SELECT Id, UserName, Role FROM Users WHERE (UserName=? OR Email=?) AND [Password]=?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement pstm = con.prepareStatement(sql)) {

            pstm.setString(1, nameOrEmail);
            pstm.setString(2, nameOrEmail);
            pstm.setString(3, password);

            try (ResultSet rs = pstm.executeQuery()) {
                if (rs.next()) {
                    us = new User();
                    String idStr = rs.getString("Id");          
                    us.setId(UUID.fromString(idStr));        
                    us.setUserName(rs.getString("UserName"));
                    us.setRole(Role.valueOf(rs.getString("Role").toUpperCase()));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return us;
    }
}
