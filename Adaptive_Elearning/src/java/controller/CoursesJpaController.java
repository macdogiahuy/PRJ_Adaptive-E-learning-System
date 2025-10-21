/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

<<<<<<< HEAD
import controller.exceptions.NonexistentEntityException;
import controller.exceptions.PreexistingEntityException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityNotFoundException;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import java.util.List;
import model.Courses;

/**
 * JPA Controller for Courses entity
=======
/**
 *
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
 * @author LP
 */
public class CoursesJpaController {
    
<<<<<<< HEAD
    private EntityManagerFactory emf = null;
    
    public CoursesJpaController() {
        this.emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU");
    }
    
    public CoursesJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    
    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    
    /**
     * Create a new course
     */
    public void create(Courses course) throws PreexistingEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(course);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findCourse(course.getId()) != null) {
                throw new PreexistingEntityException("Course " + course + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Update an existing course
     */
    public void edit(Courses course) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            course = em.merge(course);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = course.getId();
                if (findCourse(id) == null) {
                    throw new NonexistentEntityException("The course with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Delete a course
     */
    public void destroy(String id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Courses course;
            try {
                course = em.getReference(Courses.class, id);
                course.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The course with id " + id + " no longer exists.", enfe);
            }
            em.remove(course);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Find all courses
     */
    public List<Courses> findCoursesEntities() {
        return findCoursesEntities(true, -1, -1);
    }
    
    /**
     * Find courses with pagination
     */
    public List<Courses> findCoursesEntities(int maxResults, int firstResult) {
        return findCoursesEntities(false, maxResults, firstResult);
    }
    
    private List<Courses> findCoursesEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Courses.class));
            Query q = em.createQuery(cq);
            if (!all) {
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }
    
    /**
     * Find course by ID
     */
    public Courses findCourse(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Courses.class, id);
        } finally {
            em.close();
        }
    }
    
    /**
     * Get total count of courses
     */
    public int getCoursesCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Courses> rt = cq.from(Courses.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
    /**
     * Find courses by category
     */
    public List<Courses> findByCategory(String categoryId) {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT c FROM Courses c WHERE c.categoryId = :categoryId");
            query.setParameter("categoryId", categoryId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    /**
     * Find courses by instructor
     */
    public List<Courses> findByInstructor(String instructorId) {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT c FROM Courses c WHERE c.instructorId = :instructorId");
            query.setParameter("instructorId", instructorId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    /**
     * Find published courses
     */
    public List<Courses> findPublishedCourses() {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT c FROM Courses c WHERE c.isPublished = true");
            return query.getResultList();
        } finally {
            em.close();
        }
    }
=======
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
}
