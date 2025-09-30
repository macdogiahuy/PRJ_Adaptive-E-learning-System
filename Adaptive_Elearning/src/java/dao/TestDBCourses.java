package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestDBCourses {
    public static void main(String[] args) {
        try (Connection conn = DBCourses.getConnection()) {
            System.out.println("✅ Kết nối DB thành công!");

            String sql = "SELECT TOP 10 Id, Title, MetaTitle, ThumbURL, Intro FROM Courses";
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery(sql)) {

                while (rs.next()) {
                    String id = rs.getString("Id"); // Id là uniqueidentifier (GUID)
                    String title = rs.getString("Title");
                    String metaTitle = rs.getString("MetaTitle");
                    String thumb = rs.getString("ThumbURL");
                    String intro = rs.getString("Intro");

                    System.out.printf("Id: %s | Title: %s | MetaTitle: %s | Thumb: %s | Intro: %s%n",
                            id, title, metaTitle, thumb, intro);
                }
            }
        } catch (Exception e) {
            System.out.println("❌ Lỗi kết nối hoặc query!");
            e.printStackTrace();
        }
    }
}
