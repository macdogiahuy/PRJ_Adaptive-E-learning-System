/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.CoursesMarket;
import java.sql.*;
import java.util.*;

public class CourseMarketDAO {
    private Connection conn;

    public CourseMarketDAO(Connection conn) {
        this.conn = conn;
    }

    // Lấy tất cả courses
    public List<CoursesMarket> getAllCourses() {
        List<CoursesMarket> list = new ArrayList<>();
        String sql = "SELECT c.Id, c.Title, c.ThumbUrl, u.FullName AS Instructor, " +
                     "c.Price, c.Discount, cat.Name AS Category, " +
                     "c.TotalRating, c.RatingCount, c.StudentsCount, c.CreationTime " +
                     "FROM Courses c " +
                     "JOIN Instructors i ON c.InstructorId = i.Id " +
                     "JOIN Users u ON i.CreatorId = u.Id " +
                     "JOIN Categories cat ON c.CategoryId = cat.Id";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                double total = rs.getDouble("TotalRating");
                int count = rs.getInt("RatingCount");
                double rating = (count == 0) ? 0 : total / count;

                list.add(new CoursesMarket(
                        rs.getInt("Id"),
                        rs.getString("Title"),
                        rs.getString("ThumbUrl"),
                        rs.getString("Instructor"),
                        rs.getDouble("Price"),
                        rs.getDouble("Discount"),
                        rs.getString("Category"),
                        rating,
                        rs.getInt("StudentsCount"),
                        rs.getTimestamp("CreatedAt").toLocalDateTime()
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

