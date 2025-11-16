package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;
import model.*;
import utils.JPAUtils;

/**
 * QuizDAO — quản lý truy vấn liên quan đến câu hỏi, lựa chọn, và bài quiz.
 *
 * Gọn gàng, chỉ giữ lại các hàm cần thiết cho adaptive quiz & quản lý kết quả.
 */
public class QuizDAO {

    /**
     * Lấy danh sách ID câu hỏi trong 1 assignment
     */
    public List<String> getQuestionIdsByAssignmentId(String assignmentId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            String jpql = "SELECT q.id FROM McqQuestions q WHERE q.assignmentId.id = :assignmentId";
            return em.createQuery(jpql, String.class)
                    .setParameter("assignmentId", assignmentId)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }

    /**
     * Lấy toàn bộ câu hỏi (bao gồm assignment và section liên quan)
     */
    public List<McqQuestions> getFullQuestions(String assignmentId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            String jpql = """
                SELECT DISTINCT q
                FROM McqQuestions q
                JOIN FETCH q.assignmentId a
                JOIN FETCH a.sectionId s
                LEFT JOIN FETCH s.lecturesCollection
                WHERE a.id = :assignmentId
            """;
            return em.createQuery(jpql, McqQuestions.class)
                    .setParameter("assignmentId", assignmentId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /**
     * Lưu kết quả làm bài quiz (submission + câu trả lời người dùng)
     */
    // ... bên trong file QuizDAO.java ...
// (Bạn cần import java.sql.Connection và java.sql.PreparedStatement)
// import java.sql.Connection;
// import java.sql.PreparedStatement;
// import java.sql.Timestamp; // Cần import thêm
    public model.Submissions saveQuizResult(
            String userId, String assignmentId,
            double mark, int timeSpent,
            java.util.Map<String, String> userAnswers) {

        // 1. Chuẩn bị dữ liệu
        String submissionId = java.util.UUID.randomUUID().toString();
        java.sql.Timestamp now = new java.sql.Timestamp(new java.util.Date().getTime());

        String sqlSubmission = """
        INSERT INTO Submissions 
        (Id, Mark, TimeSpentInSec, CreatorId, AssignmentId, LastModifierId, CreationTime, LastModificationTime) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;

        String sqlUserAnswer = """
        INSERT INTO McqUserAnswer (SubmissionId, McqChoiceId) 
        VALUES (?, ?)
        """;

        Connection conn = null;
        PreparedStatement psSubmission = null;
        PreparedStatement psUserAnswer = null;

        try {
            // Lấy kết nối từ utility class của bạn
            conn = DBConnection.getConnection();
            if (conn == null) {
                System.err.println("[QuizDAO] LỖI: DBConnection.getConnection() trả về null!");
                return null;
            }

            // BẮT ĐẦU TRANSACTION
            conn.setAutoCommit(false);

            // 2. Thêm vào bảng Submissions
            psSubmission = conn.prepareStatement(sqlSubmission);
            psSubmission.setString(1, submissionId);
            psSubmission.setDouble(2, mark);
            psSubmission.setInt(3, timeSpent);
            psSubmission.setString(4, userId);
            psSubmission.setString(5, assignmentId);
            psSubmission.setString(6, userId); // LastModifierId
            psSubmission.setTimestamp(7, now); // CreationTime
            psSubmission.setTimestamp(8, now); // LastModificationTime

            int submissionRows = psSubmission.executeUpdate();
            if (submissionRows == 0) {
                throw new java.sql.SQLException("Tạo submission thất bại, không có dòng nào bị ảnh hưởng.");
            }

            // 3. Thêm vào bảng McqUserAnswer (dùng batch insert)
            psUserAnswer = conn.prepareStatement(sqlUserAnswer);

            for (java.util.Map.Entry<String, String> entry : userAnswers.entrySet()) {
                String choiceId = entry.getValue();
                if (choiceId != null && !choiceId.isEmpty()) {
                    psUserAnswer.setString(1, submissionId);
                    psUserAnswer.setString(2, choiceId);
                    psUserAnswer.addBatch();
                }
            }

            // Thực thi batch insert
            psUserAnswer.executeBatch();

            // Nếu mọi thứ thành công, COMMIT TRANSACTION
            conn.commit();

            System.out.println("[QuizDAO] JDBC saveQuizResult THÀNH CÔNG! Đã commit.");

            // 4. Trả về một đối tượng Submissions (tương tự bản JPA)
            model.Submissions submission = new model.Submissions();
            submission.setId(submissionId);
            submission.setMark(mark);
            submission.setTimeSpentInSec(timeSpent);
            submission.setLastModifierId(userId);
            submission.setCreationTime(now);
            submission.setLastModificationTime(now);

            // Tạo các đối tượng tham chiếu (proxy)
            Users userRef = new Users();
            userRef.setId(userId);
            submission.setCreatorId(userRef);

            Assignments assignRef = new Assignments();
            assignRef.setId(assignmentId);
            submission.setAssignmentId(assignRef);

            return submission;

        } catch (Exception e) {
            System.err.println("[QuizDAO] JDBC Transaction Thất Bại! Đang rollback...");
            e.printStackTrace(); // In ra lỗi SQL chi tiết

            if (conn != null) {
                try {
                    // ROLLBACK TRANSACTION nếu có lỗi
                    conn.rollback();
                } catch (java.sql.SQLException ex) {
                    System.err.println("[QuizDAO] Rollback thất bại: " + ex.getMessage());
                }
            }
            return null; // Trả về null khi thất bại
        } finally {
            // Dọn dẹp tài nguyên
            try {
                if (psUserAnswer != null) {
                    psUserAnswer.close();
                }
            } catch (Exception e) {
            }
            try {
                if (psSubmission != null) {
                    psSubmission.close();
                }
            } catch (Exception e) {
            }
            try {
                if (conn != null) {
                    conn.setAutoCommit(true); // Trả lại auto-commit cho connection pool
                    conn.close(); // Trả connection về pool
                }
            } catch (Exception e) {
            }
        }
    }

    /**
     * Lấy thông tin cơ bản của assignment (dùng cho hiển thị quiz)
     */
    public Assignments getAssignmentById(String assignmentId) {
        String sql = """
            SELECT a.Id AS AssignmentId, a.Name AS AssignmentName, a.Duration,
                   a.QuestionCount, a.GradeToPass, a.SectionId AS AssignSectionId,
                   s.CourseId AS SectionCourseId
            FROM dbo.Assignments a
            LEFT JOIN dbo.Sections s ON a.SectionId = s.Id
            WHERE a.Id = ?
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, assignmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Assignments a = new Assignments();
                    a.setId(rs.getString("AssignmentId"));
                    a.setName(rs.getString("AssignmentName"));
                    a.setDuration(rs.getInt("Duration"));
                    a.setQuestionCount(rs.getInt("QuestionCount"));
                    a.setGradeToPass(rs.getDouble("GradeToPass"));

                    String sectionId = rs.getString("AssignSectionId");
                    String courseId = rs.getString("SectionCourseId");

                    Sections section = new Sections();
                    section.setId(sectionId);
                    if (courseId != null) {
                        Courses course = new Courses();
                        course.setId(courseId);
                        section.setCourseId(course);
                    }
                    a.setSectionId(section);
                    return a;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Đếm số lượng câu hỏi trong assignment
     */
    public int countQuestionsByAssignment(String assignmentId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(q) FROM McqQuestions q WHERE q.assignmentId.id = :assignmentId",
                    Long.class)
                    .setParameter("assignmentId", assignmentId)
                    .getSingleResult();
            return count.intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    /**
     * Kiểm tra một lựa chọn có phải đáp án đúng không (true/false)
     */
    public boolean isChoiceCorrect(String choiceId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            Boolean result = em.createQuery(
                    "SELECT c.isCorrect FROM McqChoices c WHERE c.id = :cid",
                    Boolean.class)
                    .setParameter("cid", choiceId)
                    .getResultStream()
                    .findFirst()
                    .orElse(false);
            return Boolean.TRUE.equals(result);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    /**
     * Lấy ID câu hỏi tương ứng với một lựa chọn
     */
    public String getQuestionIdOfChoice(String choiceId) {
        String sql = "SELECT McqQuestionId FROM dbo.McqChoices WHERE Id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, choiceId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getString(1) : null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 🔍 Lấy đáp án đúng (choiceId) của một câu hỏi
     */
    public String getCorrectChoiceForQuestion(String questionId) {
        String sql = """
            SELECT Id FROM dbo.McqChoices
            WHERE McqQuestionId = ? AND IsCorrect = 1
        """;
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, questionId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() ? rs.getString("Id") : null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ==================== 🔥 HÀM MỚI: LẤY LỊCH SỬ LÀM BÀI ====================
    public List<Map<String, Object>> getSubmissionHistory(String userId, String assignmentId) {
        List<Map<String, Object>> history = new ArrayList<>();

        String sql = """
            SELECT 
                s.Id AS SubmissionId,
                s.Mark AS CorrectCount,
                s.TimeSpentInSec,
                s.CreationTime AS SubmitTime
            FROM Submissions s
            WHERE s.CreatorId = ? AND s.AssignmentId = ?
            ORDER BY s.CreationTime DESC
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, userId);
            stmt.setString(2, assignmentId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("submissionId", rs.getString("SubmissionId"));
                    item.put("correctCount", rs.getInt("CorrectCount"));
                    item.put("timeSpent", rs.getInt("TimeSpentInSec"));
                    item.put("submitTime", rs.getTimestamp("SubmitTime"));
                    history.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return history;
    }

    public java.util.Map<String, String> getCorrectAnswers(String assignmentId) {
        EntityManager em = JPAUtils.getEntityManager();
        java.util.Map<String, String> answerMap = new java.util.HashMap<>();
        try {
            String jpql = "SELECT c.mcqQuestionId.id, c.id FROM McqChoices c "
                    + "WHERE c.mcqQuestionId.assignmentId.id = :assignmentId AND c.isCorrect = true";
            TypedQuery<Object[]> query = em.createQuery(jpql, Object[].class);
            query.setParameter("assignmentId", assignmentId);

            List<Object[]> results = query.getResultList();
            for (Object[] result : results) {
                answerMap.put((String) result[0], (String) result[1]);
            }
            return answerMap;
        } catch (Exception e) {
            e.printStackTrace();
            return answerMap;
        } finally {
            em.close();
        }
    }
}
