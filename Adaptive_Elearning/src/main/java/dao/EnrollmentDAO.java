package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;
import model.Enrollments;
import model.Lectures;
import utils.JPAUtils;

public class EnrollmentDAO {

    public void updateLastViewedLecture(String userId, String courseId, String lectureId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            em.getTransaction().begin();

            Lectures lecture = em.find(Lectures.class, lectureId);

            TypedQuery<Enrollments> query = em.createQuery(
                    "SELECT e FROM Enrollments e "
                    + "WHERE e.enrollmentsPK.creatorId = :userId "
                    + "AND e.enrollmentsPK.courseId = :courseId",
                    Enrollments.class
            );
            query.setParameter("userId", userId);
            query.setParameter("courseId", courseId);

            Enrollments enrollment = query.getResultStream().findFirst().orElse(null);

            if (enrollment != null && lecture != null) {
                enrollment.setLastViewedLectureId(lecture);
                em.merge(enrollment);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public boolean isUserEnrolled(String userId, String courseId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            String jpql = "SELECT COUNT(e) FROM Enrollments e "
                    + "WHERE e.enrollmentsPK.creatorId = :userId "
                    + "AND e.enrollmentsPK.courseId = :courseId";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("userId", userId)
                    .setParameter("courseId", courseId)
                    .getSingleResult();
            return count > 0;
        } finally {
            em.close();
        }
    }

    // Lấy Enrollments chi tiết (dùng khi cần)
    public Enrollments getEnrollment(String userId, String courseId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            String jpql = "SELECT e FROM Enrollments e WHERE e.enrollmentsPK.creatorId = :userId AND e.enrollmentsPK.courseId = :courseId";
            TypedQuery<Enrollments> query = em.createQuery(jpql, Enrollments.class);
            query.setParameter("userId", userId);
            query.setParameter("courseId", courseId);
            return query.getResultStream().findFirst().orElse(null);
        } finally {
            em.close();
        }
    }
}
