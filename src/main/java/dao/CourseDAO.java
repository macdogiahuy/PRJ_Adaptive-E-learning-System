package dao;

import model.Sections;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.JPAUtils;
import java.util.List;

public class CourseDAO {

    /**
     * Lấy tất cả các Section VÀ các Lecture của chúng thuộc về một Course.
     * Dùng JOIN FETCH để tránh lỗi LazyInitializationException trong JSP.
     */
    public List<Sections> getSectionsAndLecturesByCourseId(String courseId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            //
            // === ĐÃ SỬA LỖI TRONG CÂU QUERY NÀY ===
            //
            // 1. Sửa 's.lecturesList' -> 's.lecturesCollection'
            // 2. Sửa 's.course.id' -> 's.courseId.id'
            // 3. Sửa 'l.index' -> 'l.creationTime' (Vì Lecture không có index, sắp xếp theo thời gian tạo)
            //
            String jpql = "SELECT DISTINCT s FROM Sections s " +
                          "LEFT JOIN FETCH s.lecturesCollection l " + 
                          "WHERE s.courseId.id = :courseId " +
                          "ORDER BY s.index, l.creationTime"; // Sắp xếp theo Section, rồi theo bài học
            
            TypedQuery<Sections> query = em.createQuery(jpql, Sections.class);
            query.setParameter("courseId", courseId);
            return query.getResultList();

        } finally {
            em.close();
        }
    }
}