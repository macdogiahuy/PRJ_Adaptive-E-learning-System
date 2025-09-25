/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import controller.exceptions.NonexistentEntityException;
import controller.exceptions.PreexistingEntityException;
import java.io.Serializable;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.CourseMeta;
import model.CourseMetaPK;
import model.Courses;

/**
 *
 * @author LP
 */
public class CourseMetaJpaController implements Serializable {

    public CourseMetaJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(CourseMeta courseMeta) throws PreexistingEntityException, Exception {
        if (courseMeta.getCourseMetaPK() == null) {
            courseMeta.setCourseMetaPK(new CourseMetaPK());
        }
        courseMeta.getCourseMetaPK().setCourseId(courseMeta.getCourses().getId());
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Courses courses = courseMeta.getCourses();
            if (courses != null) {
                courses = em.getReference(courses.getClass(), courses.getId());
                courseMeta.setCourses(courses);
            }
            em.persist(courseMeta);
            if (courses != null) {
                courses.getCourseMetaList().add(courseMeta);
                courses = em.merge(courses);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findCourseMeta(courseMeta.getCourseMetaPK()) != null) {
                throw new PreexistingEntityException("CourseMeta " + courseMeta + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(CourseMeta courseMeta) throws NonexistentEntityException, Exception {
        courseMeta.getCourseMetaPK().setCourseId(courseMeta.getCourses().getId());
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            CourseMeta persistentCourseMeta = em.find(CourseMeta.class, courseMeta.getCourseMetaPK());
            Courses coursesOld = persistentCourseMeta.getCourses();
            Courses coursesNew = courseMeta.getCourses();
            if (coursesNew != null) {
                coursesNew = em.getReference(coursesNew.getClass(), coursesNew.getId());
                courseMeta.setCourses(coursesNew);
            }
            courseMeta = em.merge(courseMeta);
            if (coursesOld != null && !coursesOld.equals(coursesNew)) {
                coursesOld.getCourseMetaList().remove(courseMeta);
                coursesOld = em.merge(coursesOld);
            }
            if (coursesNew != null && !coursesNew.equals(coursesOld)) {
                coursesNew.getCourseMetaList().add(courseMeta);
                coursesNew = em.merge(coursesNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                CourseMetaPK id = courseMeta.getCourseMetaPK();
                if (findCourseMeta(id) == null) {
                    throw new NonexistentEntityException("The courseMeta with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(CourseMetaPK id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            CourseMeta courseMeta;
            try {
                courseMeta = em.getReference(CourseMeta.class, id);
                courseMeta.getCourseMetaPK();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The courseMeta with id " + id + " no longer exists.", enfe);
            }
            Courses courses = courseMeta.getCourses();
            if (courses != null) {
                courses.getCourseMetaList().remove(courseMeta);
                courses = em.merge(courses);
            }
            em.remove(courseMeta);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<CourseMeta> findCourseMetaEntities() {
        return findCourseMetaEntities(true, -1, -1);
    }

    public List<CourseMeta> findCourseMetaEntities(int maxResults, int firstResult) {
        return findCourseMetaEntities(false, maxResults, firstResult);
    }

    private List<CourseMeta> findCourseMetaEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(CourseMeta.class));
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

    public CourseMeta findCourseMeta(CourseMetaPK id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(CourseMeta.class, id);
        } finally {
            em.close();
        }
    }

    public int getCourseMetaCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<CourseMeta> rt = cq.from(CourseMeta.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
