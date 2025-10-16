package dao;

import model.Review;
import java.sql.*;
import java.util.*;

public class ReviewDao {
    public List<Review> getReviewsByCourseId(String courseId) throws SQLException {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT u.FullName as UserName, r.Comment, r.Rating FROM Reviews r JOIN Users u ON r.UserId = u.Id WHERE r.CourseId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, courseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Review(
                    rs.getString("UserName"),
                    rs.getString("Comment"),
                    rs.getDouble("Rating")
                ));
            }
        }
        return list;
    }
}
