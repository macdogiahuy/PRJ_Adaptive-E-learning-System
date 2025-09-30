package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Courses;

public class CourseDAO {
    private Connection conn;

  
    private static final String GET_ALL_COURSES = "SELECT c.Id, c.Title, c.ThumbUrl, " + "u.FullName AS InstructorName, " + "c.TotalRating, c.RatingCount, " + "c.CreationTime, c.Status " + "FROM Courses c " + "JOIN Instructors i ON c.InstructorId = i.Id " +  "JOIN Users u ON i.CreatorId = u.Id";

    private static final String GET_COURSE_BY_ID =
        "SELECT c.Id, c.Title, c.ThumbUrl, " +
        "u.FullName AS InstructorName, " +
        "c.TotalRating, c.RatingCount, " +
        "c.CreationTime, c.Status " +
        "FROM Courses c " +
        "JOIN Instructors i ON c.InstructorId = i.Id " +
        "JOIN Users u ON i.CreatorId = u.Id " +
        "WHERE c.Id = ?";

    public CourseDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Courses> getAllCourses() {
        List<Courses> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(GET_ALL_COURSES)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String id = rs.getString("Id");
                String title = rs.getString("Title");
                String thumb = rs.getString("ThumbUrl");

                double total = rs.getDouble("TotalRating");
                int count = rs.getInt("RatingCount");
                double rating = (count == 0) ? 0 : total / count;

                String instructor = rs.getString("InstructorName");

                list.add(new Courses(
                    id,
                    title,
                    thumb,
                    instructor,
                    rating,
                    rs.getTimestamp("CreationTime").toLocalDateTime(),
                    rs.getString("Status")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

  
    public Courses getCourseById(String courseId) {
        try (PreparedStatement ps = conn.prepareStatement(GET_COURSE_BY_ID)) {
            ps.setString(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                double total = rs.getDouble("TotalRating");
                int count = rs.getInt("RatingCount");
                double rating = (count == 0) ? 0 : total / count;

                return new Courses(
                    rs.getString("Id"),
                    rs.getString("Title"),
                    rs.getString("ThumbUrl"),
                    rs.getString("InstructorName"),
                    rating,
                    rs.getTimestamp("CreationTime").toLocalDateTime(),
                    rs.getString("Status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
