package dao;

import model.Lectures;
import model.LectureMaterial;
import model.LectureMaterialPK;
import model.Sections; // ✅ Giả định bạn có model này
import java.util.List;
import java.util.ArrayList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import dao.DBConnection; // 

public class LectureDAO {

    /**
     * Lấy danh sách bài giảng bằng SectionId (JDBC)
     */
    public List<Lectures> getLecturesBySectionId(String sectionId) {
        List<Lectures> lectureList = new ArrayList<>();
        // Tên cột "SectionId" được lấy từ @JoinColumn(name = "SectionId"...)
        String sql = "SELECT * FROM Lectures WHERE SectionId = ? ORDER BY Id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, sectionId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Lectures lecture = new Lectures();
                    
                    // Map tất cả các trường từ ResultSet sang đối tượng Lectures
                    lecture.setId(rs.getString("Id"));
                    lecture.setTitle(rs.getString("Title"));
                    lecture.setContent(rs.getString("Content"));
                    
                    // Dùng getTimestamp vì trong model là @Temporal(TemporalType.TIMESTAMP)
                    lecture.setCreationTime(rs.getTimestamp("CreationTime"));
                    lecture.setLastModificationTime(rs.getTimestamp("LastModificationTime"));
                    lecture.setIsPreviewable(rs.getBoolean("IsPreviewable"));

                    // Xử lý khóa ngoại SectionId
                    // Tạo một đối tượng Sections "proxy" chỉ chứa Id
                    Sections section = new Sections();
                    section.setId(rs.getString("SectionId"));
                    lecture.setSectionId(section);

                    lectureList.add(lecture);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In lỗi ra console
        }
        return lectureList;
    }

    /**
     * Lấy một bài giảng bằng Id (JDBC)
     */
    public Lectures getLectureById(String lectureId) {
        Lectures lecture = null;
        String sql = "SELECT * FROM Lectures WHERE Id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, lectureId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    lecture = new Lectures();
                    
                    // Map tất cả các trường
                    lecture.setId(rs.getString("Id"));
                    lecture.setTitle(rs.getString("Title"));
                    lecture.setContent(rs.getString("Content"));
                    lecture.setCreationTime(rs.getTimestamp("CreationTime"));
                    lecture.setLastModificationTime(rs.getTimestamp("LastModificationTime"));
                    lecture.setIsPreviewable(rs.getBoolean("IsPreviewable"));

                    // Xử lý khóa ngoại SectionId
                    Sections section = new Sections();
                    section.setId(rs.getString("SectionId"));
                    lecture.setSectionId(section);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lecture;
    }

    /**
     * Lấy danh sách tài liệu bằng LectureId (JDBC)
     */
    public List<LectureMaterial> getMaterialsByLectureId(String lectureId) {
        List<LectureMaterial> materialList = new ArrayList<>();
        // Tên cột "LectureId" và "Id" được lấy từ @Column trong LectureMaterialPK
        String sql = "SELECT * FROM LectureMaterial WHERE LectureId = ? ORDER BY Id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, lectureId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LectureMaterial material = new LectureMaterial();

                    // 1. Lấy các giá trị từ ResultSet
                    String lecId = rs.getString("LectureId");
                    int matId = rs.getInt("Id");
                    String type = rs.getString("Type");
                    String url = rs.getString("Url");

                    // 2. Tái tạo lại đối tượng PK (Composite Key)
                    LectureMaterialPK pk = new LectureMaterialPK();
                    pk.setLectureId(lecId);
                    pk.setId(matId);

                    // 3. Set giá trị cho đối tượng material
                    material.setLectureMaterialPK(pk);
                    material.setType(type);
                    material.setUrl(url);

                    materialList.add(material);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return materialList;
    }
}