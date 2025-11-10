package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import model.LectureCompletions;
import model.Lectures;
import model.Users;
import utils.JPAUtils;
import java.util.*;

public class CompletionDAO {

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

    public void markAsComplete(String userId, String lectureId) {
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

}
