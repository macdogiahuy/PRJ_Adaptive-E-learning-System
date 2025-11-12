package dao; // Hoặc package của bạn

import model.Lectures;
import model.LectureMaterial; 
import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import utils.JPAUtils; 

public class LectureDAO {

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
           
        String jpql = "SELECT m FROM LectureMaterial m WHERE m.lectureMaterialPK.lectureId = :lectureId ORDER BY m.id";
            
            TypedQuery<LectureMaterial> query = em.createQuery(jpql, LectureMaterial.class);
            query.setParameter("lectureId", lectureId);
            
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}