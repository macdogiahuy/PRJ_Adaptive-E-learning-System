package dao;

// Import các thư viện SQL
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
// Import DBConnection của bạn (thay thế "utils.DBConnection" nếu cần)
import dao.DBConnection; 

public class CatResultsDAO {

    /**
     * Trả về thứ hạng (rank) của người dùng dựa trên ĐIỂM SỐ (Mark)
     * trong bảng Submissions (Sử dụng JDBC).
     */
    public int getAssignmentRank(String assignmentId, String userId) {
        
        String sqlGetUserMark = "SELECT MAX(Mark) FROM Submissions " +
                                "WHERE AssignmentId = ? AND CreatorId = ?";
        
        String sqlCountHigher = """
            WITH UserBestScores AS (
                SELECT 
                    CreatorId, 
                    MAX(Mark) AS BestMark 
                FROM Submissions 
                WHERE AssignmentId = ?
                GROUP BY CreatorId
            )
            SELECT COUNT(DISTINCT CreatorId) 
            FROM UserBestScores 
            WHERE BestMark > ?
        """;

        double userBestMark = 0.0;
        boolean userHasScore = false;

        // Dùng try-with-resources để đảm bảo tài nguyên được đóng
        try (Connection conn = DBConnection.getConnection()) {

            // 🔹 Bước 1: Lấy điểm cao nhất của người dùng hiện tại
            try (PreparedStatement ps1 = conn.prepareStatement(sqlGetUserMark)) {
                ps1.setString(1, assignmentId);
                ps1.setString(2, userId);
                try (ResultSet rs1 = ps1.executeQuery()) {
                    if (rs1.next()) {
                        userBestMark = rs1.getDouble(1);
                        if (!rs1.wasNull()) {
                            userHasScore = true;
                        }
                    }
                }
            }

            // Nếu user không có điểm (chưa nộp), trả về 0
            if (!userHasScore) {
                return 0;
            }

            // 🔹 Bước 2: Đếm số người có điểm cao hơn
            int higherCount = 0;
            try (PreparedStatement ps2 = conn.prepareStatement(sqlCountHigher)) {
                ps2.setString(1, assignmentId);
                ps2.setDouble(2, userBestMark);
                try (ResultSet rs2 = ps2.executeQuery()) {
                    if (rs2.next()) {
                        higherCount = rs2.getInt(1);
                    }
                }
            }
            
            int rank = higherCount + 1; // người cao hơn + 1 = thứ hạng hiện tại

            // (Lấy tổng số người tham gia - để in log cho chắc)
            int total = getAssignmentTotalParticipants(assignmentId); // Gọi hàm bên dưới

            System.out.printf("🏆 [JDBC Rank_By_Mark] user=%s | rank=%d / total=%d (BestMark=%.2f)%n",
                    userId, rank, total, userBestMark);

            return rank;

        } catch (Exception e) {
            e.printStackTrace();
            return 0; // Trả về 0 nếu có lỗi
        }
    }

    /**
     * Lấy tổng số người đã làm bài (từ bảng Submissions) (Sử dụng JDBC).
     */
    public int getAssignmentTotalParticipants(String assignmentId) {
        
        String sqlTotal = "SELECT COUNT(DISTINCT CreatorId) FROM Submissions WHERE AssignmentId = ?";

        // Dùng try-with-resources
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlTotal)) {
            
            ps.setString(1, assignmentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1); // Trả về tổng số
                }
            }
            
            return 0; // Không có ai
            
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}