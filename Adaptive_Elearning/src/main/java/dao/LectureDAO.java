package dao;

import model.Lectures;
import model.LectureMaterial;
import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.JPAUtils;

public class LectureDAO {

    public List<Lectures> getLecturesBySectionId(String sectionId) {
    EntityManager em = JPAUtils.getEntityManager();
    try {
        String jpql = "SELECT l FROM Lectures l WHERE l.sectionId.id = :sectionId ORDER BY l.id";
        TypedQuery<Lectures> query = em.createQuery(jpql, Lectures.class);
        query.setParameter("sectionId", sectionId);
        return query.getResultList();
    } finally {
        em.close();
    }
}


    public Lectures getLectureById(String lectureId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            Lectures lecture = em.find(Lectures.class, lectureId);
            return lecture;
        } finally {
            em.close();
        }
    }

    public List<LectureMaterial> getMaterialsByLectureId(String lectureId) {
        EntityManager em = JPAUtils.getEntityManager();
        try {
            String jpql = "SELECT m FROM LectureMaterial m "
                    + "WHERE m.lectureMaterialPK.lectureId = :lectureId "
                    + "ORDER BY m.lectureMaterialPK.id";  // ✅ Đúng 100%
            TypedQuery<LectureMaterial> query = em.createQuery(jpql, LectureMaterial.class);
            query.setParameter("lectureId", lectureId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}
