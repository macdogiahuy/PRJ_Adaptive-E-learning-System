package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
// Import các model mới
import model.AssignmentCompletions;
import model.Assignments;
import model.LectureCompletions;
import model.Lectures;
import model.Users;
import utils.JPAUtils;
import java.util.*;

public class CompletionDAO {

    // ===============================================
    // PHẦN LECTURES (BÀI GIẢNG)
    // ===============================================
    public List<String> getCompletedLectureIds(String userId, String courseId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            TypedQuery<String> query = em.createQuery("""
                SELECT lc.lectureId.id 
                FROM LectureCompletions lc 
                JOIN lc.lectureId l 
                JOIN l.sectionId s 
                WHERE lc.userId.id = :userId AND s.courseId.id = :courseId
            """, String.class);
            query.setParameter("userId", userId);
            query.setParameter("courseId", courseId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }

    private boolean isLectureComplete(String userId, String lectureId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            Long count = em.createQuery("""
                SELECT COUNT(lc) 
                FROM LectureCompletions lc 
                WHERE lc.userId.id = :userId AND lc.lectureId.id = :lectureId
                """, Long.class)
                    .setParameter("userId", userId)
                    .setParameter("lectureId", lectureId)
                    .getSingleResult();
            return count > 0;
        } catch (NoResultException e) {
            return false;
        } finally {
            em.close();
        }
    }

    public void markAsComplete(String userId, String lectureId) {
        if (isLectureComplete(userId, lectureId)) {
            System.out.println("[CompletionDAO] Bài giảng " + lectureId + " đã được hoàn thành trước đó.");
            return;
        }
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();
            Users user = em.find(Users.class, userId);
            Lectures lecture = em.find(Lectures.class, lectureId);

            if (user != null && lecture != null) {
                LectureCompletions completion = new LectureCompletions();
                completion.setUserId(user);
                completion.setLectureId(lecture);
                em.persist(completion);
                em.getTransaction().commit();
                System.out.println("[CompletionDAO] Đã lưu hoàn thành cho bài giảng " + lectureId);
            } else {
                System.err.println("[CompletionDAO] Không tìm thấy User hoặc Lecture. Rollback.");
                em.getTransaction().rollback();
            }
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    // ===============================================
    // PHẦN ASSIGNMENTS (BÀI TẬP) - CODE MỚI
    // ===============================================
    public List<String> getCompletedAssignmentIds(String userId, String courseId) {
        List<String> completedIds = new ArrayList<>();
        String sql = """
            SELECT ac.AssignmentId 
            FROM AssignmentCompletions ac 
            JOIN Assignments a ON ac.AssignmentId = a.Id
            JOIN Sections s ON a.SectionId = s.Id
            WHERE ac.UserId = ? AND s.CourseId = ?
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            ps.setString(2, courseId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    completedIds.add(rs.getString(1));
                }
            }
        } catch (Exception e) {
            // Lỗi "Invalid object name" sẽ xảy ra ở đây nếu CSDL bị sai
            e.printStackTrace();
        }
        return completedIds;
    }

    private boolean isAssignmentComplete(String userId, String assignmentId) {
        String sql = "SELECT COUNT(*) FROM AssignmentCompletions WHERE UserId = ? AND AssignmentId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            ps.setString(2, assignmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void markAssignmentAsComplete(String userId, String assignmentId) {
        if (isAssignmentComplete(userId, assignmentId)) {
            System.out.println("[CompletionDAO-JDBC] Bài tập " + assignmentId + " đã được hoàn thành trước đó.");
            return;
        }

        String sql = "INSERT INTO AssignmentCompletions (UserId, AssignmentId) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            ps.setString(2, assignmentId);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                System.out.println("[CompletionDAO-JDBC] Đã lưu hoàn thành cho bài tập " + assignmentId);
            }
        } catch (SQLException e) {
            System.err.println("[CompletionDAO-JDBC] Lỗi khi lưu Assignment: " + e.getMessage());
        }
    }

    public int getTotalCompletableItems(String courseId) {
        int totalLectures = 0;
        int totalAssignments = 0;

        String sqlLectures = """
            SELECT COUNT(l.Id) 
            FROM Lectures l 
            INNER JOIN Sections s ON l.SectionId = s.Id 
            WHERE s.CourseId = ?
        """;

        String sqlAssignments = """
            SELECT COUNT(a.Id) 
            FROM Assignments a 
            INNER JOIN Sections s ON a.SectionId = s.Id 
            WHERE s.CourseId = ?
        """;

        try (Connection conn = DBConnection.getConnection()) {

            // 1. Đếm Lectures
            try (PreparedStatement psL = conn.prepareStatement(sqlLectures)) {
                psL.setString(1, courseId);
                try (ResultSet rsL = psL.executeQuery()) {
                    if (rsL.next()) {
                        totalLectures = rsL.getInt(1);
                    }
                }
            }

            // 2. Đếm Assignments
            try (PreparedStatement psA = conn.prepareStatement(sqlAssignments)) {
                psA.setString(1, courseId);
                try (ResultSet rsA = psA.executeQuery()) {
                    if (rsA.next()) {
                        totalAssignments = rsA.getInt(1);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Trả về tổng
        return totalLectures + totalAssignments;
    }
}
