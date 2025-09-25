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
import model.LectureMaterial;
import model.LectureMaterialPK;
import model.Lectures;

/**
 *
 * @author LP
 */
public class LectureMaterialJpaController implements Serializable {

    public LectureMaterialJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(LectureMaterial lectureMaterial) throws PreexistingEntityException, Exception {
        if (lectureMaterial.getLectureMaterialPK() == null) {
            lectureMaterial.setLectureMaterialPK(new LectureMaterialPK());
        }
        lectureMaterial.getLectureMaterialPK().setLectureId(lectureMaterial.getLectures().getId());
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Lectures lectures = lectureMaterial.getLectures();
            if (lectures != null) {
                lectures = em.getReference(lectures.getClass(), lectures.getId());
                lectureMaterial.setLectures(lectures);
            }
            em.persist(lectureMaterial);
            if (lectures != null) {
                lectures.getLectureMaterialList().add(lectureMaterial);
                lectures = em.merge(lectures);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findLectureMaterial(lectureMaterial.getLectureMaterialPK()) != null) {
                throw new PreexistingEntityException("LectureMaterial " + lectureMaterial + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(LectureMaterial lectureMaterial) throws NonexistentEntityException, Exception {
        lectureMaterial.getLectureMaterialPK().setLectureId(lectureMaterial.getLectures().getId());
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            LectureMaterial persistentLectureMaterial = em.find(LectureMaterial.class, lectureMaterial.getLectureMaterialPK());
            Lectures lecturesOld = persistentLectureMaterial.getLectures();
            Lectures lecturesNew = lectureMaterial.getLectures();
            if (lecturesNew != null) {
                lecturesNew = em.getReference(lecturesNew.getClass(), lecturesNew.getId());
                lectureMaterial.setLectures(lecturesNew);
            }
            lectureMaterial = em.merge(lectureMaterial);
            if (lecturesOld != null && !lecturesOld.equals(lecturesNew)) {
                lecturesOld.getLectureMaterialList().remove(lectureMaterial);
                lecturesOld = em.merge(lecturesOld);
            }
            if (lecturesNew != null && !lecturesNew.equals(lecturesOld)) {
                lecturesNew.getLectureMaterialList().add(lectureMaterial);
                lecturesNew = em.merge(lecturesNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                LectureMaterialPK id = lectureMaterial.getLectureMaterialPK();
                if (findLectureMaterial(id) == null) {
                    throw new NonexistentEntityException("The lectureMaterial with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(LectureMaterialPK id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            LectureMaterial lectureMaterial;
            try {
                lectureMaterial = em.getReference(LectureMaterial.class, id);
                lectureMaterial.getLectureMaterialPK();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The lectureMaterial with id " + id + " no longer exists.", enfe);
            }
            Lectures lectures = lectureMaterial.getLectures();
            if (lectures != null) {
                lectures.getLectureMaterialList().remove(lectureMaterial);
                lectures = em.merge(lectures);
            }
            em.remove(lectureMaterial);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<LectureMaterial> findLectureMaterialEntities() {
        return findLectureMaterialEntities(true, -1, -1);
    }

    public List<LectureMaterial> findLectureMaterialEntities(int maxResults, int firstResult) {
        return findLectureMaterialEntities(false, maxResults, firstResult);
    }

    private List<LectureMaterial> findLectureMaterialEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(LectureMaterial.class));
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

    public LectureMaterial findLectureMaterial(LectureMaterialPK id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(LectureMaterial.class, id);
        } finally {
            em.close();
        }
    }

    public int getLectureMaterialCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<LectureMaterial> rt = cq.from(LectureMaterial.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
