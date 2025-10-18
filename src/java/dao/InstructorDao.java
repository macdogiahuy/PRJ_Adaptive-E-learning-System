package dao;

import model.Instructor;
import java.sql.*;

public class InstructorDao {
    public Instructor getById(String instructorId) throws SQLException {
        String sql = "SELECT Id, FullName, Avatar FROM Instructors WHERE Id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, instructorId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Instructor(
                    rs.getString("Id"),
                    rs.getString("FullName"),
                    rs.getString("Avatar")
                );
            }
        }
        return null;
    }
}
