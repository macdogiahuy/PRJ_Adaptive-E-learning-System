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
import model.CourseReviews;
import model.Courses;
import model.Users;

/**
 *
 * @author LP
 */
public class CourseReviewsJpaController implements Serializable {

    public CourseReviewsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(CourseReviews courseReviews) throws PreexistingEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Courses courseId = courseReviews.getCourseId();
            if (courseId != null) {
                courseId = em.getReference(courseId.getClass(), courseId.getId());
                courseReviews.setCourseId(courseId);
            }
            Users creatorId = courseReviews.getCreatorId();
            if (creatorId != null) {
                creatorId = em.getReference(creatorId.getClass(), creatorId.getId());
                courseReviews.setCreatorId(creatorId);
            }
            em.persist(courseReviews);
            if (courseId != null) {
                courseId.getCourseReviewsList().add(courseReviews);
                courseId = em.merge(courseId);
            }
            if (creatorId != null) {
                creatorId.getCourseReviewsList().add(courseReviews);
                creatorId = em.merge(creatorId);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findCourseReviews(courseReviews.getId()) != null) {
                throw new PreexistingEntityException("CourseReviews " + courseReviews + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(CourseReviews courseReviews) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            CourseReviews persistentCourseReviews = em.find(CourseReviews.class, courseReviews.getId());
            Courses courseIdOld = persistentCourseReviews.getCourseId();
            Courses courseIdNew = courseReviews.getCourseId();
            Users creatorIdOld = persistentCourseReviews.getCreatorId();
            Users creatorIdNew = courseReviews.getCreatorId();
            if (courseIdNew != null) {
                courseIdNew = em.getReference(courseIdNew.getClass(), courseIdNew.getId());
                courseReviews.setCourseId(courseIdNew);
            }
            if (creatorIdNew != null) {
                creatorIdNew = em.getReference(creatorIdNew.getClass(), creatorIdNew.getId());
                courseReviews.setCreatorId(creatorIdNew);
            }
            courseReviews = em.merge(courseReviews);
            if (courseIdOld != null && !courseIdOld.equals(courseIdNew)) {
                courseIdOld.getCourseReviewsList().remove(courseReviews);
                courseIdOld = em.merge(courseIdOld);
            }
            if (courseIdNew != null && !courseIdNew.equals(courseIdOld)) {
                courseIdNew.getCourseReviewsList().add(courseReviews);
                courseIdNew = em.merge(courseIdNew);
            }
            if (creatorIdOld != null && !creatorIdOld.equals(creatorIdNew)) {
                creatorIdOld.getCourseReviewsList().remove(courseReviews);
                creatorIdOld = em.merge(creatorIdOld);
            }
            if (creatorIdNew != null && !creatorIdNew.equals(creatorIdOld)) {
                creatorIdNew.getCourseReviewsList().add(courseReviews);
                creatorIdNew = em.merge(creatorIdNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = courseReviews.getId();
                if (findCourseReviews(id) == null) {
                    throw new NonexistentEntityException("The courseReviews with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(String id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            CourseReviews courseReviews;
            try {
                courseReviews = em.getReference(CourseReviews.class, id);
                courseReviews.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The courseReviews with id " + id + " no longer exists.", enfe);
            }
            Courses courseId = courseReviews.getCourseId();
            if (courseId != null) {
                courseId.getCourseReviewsList().remove(courseReviews);
                courseId = em.merge(courseId);
            }
            Users creatorId = courseReviews.getCreatorId();
            if (creatorId != null) {
                creatorId.getCourseReviewsList().remove(courseReviews);
                creatorId = em.merge(creatorId);
            }
            em.remove(courseReviews);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<CourseReviews> findCourseReviewsEntities() {
        return findCourseReviewsEntities(true, -1, -1);
    }

    public List<CourseReviews> findCourseReviewsEntities(int maxResults, int firstResult) {
        return findCourseReviewsEntities(false, maxResults, firstResult);
    }

    private List<CourseReviews> findCourseReviewsEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(CourseReviews.class));
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

    public CourseReviews findCourseReviews(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(CourseReviews.class, id);
        } finally {
            em.close();
        }
    }

    public int getCourseReviewsCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<CourseReviews> rt = cq.from(CourseReviews.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
