/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import java.util.List;
import model.Courses;

/**
 *
 * @author LP
 */
public class CoursesJpaController {
    
    private EntityManagerFactory emf;
    
    public CoursesJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    
    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    
    public void create(Courses course) throws Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            EntityTransaction tx = em.getTransaction();
            tx.begin();
            em.persist(course);
            tx.commit();
        } catch (Exception ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    public void edit(Courses course) throws Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            EntityTransaction tx = em.getTransaction();
            tx.begin();
            em.merge(course);
            tx.commit();
        } catch (Exception ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    public void destroy(String id) throws Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            EntityTransaction tx = em.getTransaction();
            tx.begin();
            Courses course = em.find(Courses.class, id);
            if (course != null) {
                em.remove(course);
            }
            tx.commit();
        } catch (Exception ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    public Courses findCourses(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Courses.class, id);
        } finally {
            em.close();
        }
    }
    
    public List<Courses> findCoursesEntities() {
        return findCoursesEntities(true, -1, -1);
    }
    
    public List<Courses> findCoursesEntities(int maxResults, int firstResult) {
        return findCoursesEntities(false, maxResults, firstResult);
    }
    
    private List<Courses> findCoursesEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            Query q = em.createQuery("SELECT c FROM Courses c");
            if (!all) {
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }
    
    public int getCoursesCount() {
        EntityManager em = getEntityManager();
        try {
            Query q = em.createQuery("SELECT COUNT(c) FROM Courses c");
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
    public List<Courses> findCoursesByInstructor(String instructorId) {
        EntityManager em = getEntityManager();
        try {
            Query q = em.createQuery("SELECT c FROM Courses c WHERE c.instructorId = :instructorId ORDER BY c.creationTime DESC");
            q.setParameter("instructorId", instructorId);
            return q.getResultList();
        } finally {
            em.close();
        }
    }
}
