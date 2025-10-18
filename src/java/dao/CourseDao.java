package dao;

import model.Course;
import java.sql.*;
import java.util.*;

public class CourseDao {
    public Course getCourseById(String courseId) throws SQLException {
        String sql = "SELECT Id, Title, ThumbUrl, Price, Intro, Description, Outcomes, Requirements, InstructorId FROM Courses WHERE Id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Course(
                    rs.getString("Id"),
                    rs.getString("Title"),
                    rs.getString("ThumbUrl"),
                    rs.getString("Price"),
                    rs.getString("Intro"),
                    rs.getString("Description"),
                    rs.getString("Outcomes"),
                    rs.getString("Requirements"),
                    rs.getString("InstructorId")
                );
            }
        }
        return null;
    }

    public List<Course> getCoursesByInstructorExcept(String instructorId, String exceptCourseId) throws SQLException {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT Id, Title, ThumbUrl, Price, Intro, Description, Outcomes, Requirements, InstructorId FROM Courses WHERE InstructorId = ? AND Id <> ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, instructorId);
            ps.setString(2, exceptCourseId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Course(
                    rs.getString("Id"),
                    rs.getString("Title"),
                    rs.getString("ThumbUrl"),
                    rs.getString("Price"),
                    rs.getString("Intro"),
                    rs.getString("Description"),
                    rs.getString("Outcomes"),
                    rs.getString("Requirements"),
                    rs.getString("InstructorId")
                ));
            }
        }
        return list;
    }
}
