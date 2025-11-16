/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import controller.exceptions.NonexistentEntityException;
import controller.exceptions.PreexistingEntityException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import java.io.Serializable;
import jakarta.persistence.Query;
import jakarta.persistence.EntityNotFoundException;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Root;
import java.util.List;
import model.CATLogs;

/**
 *
 * @author ADMIN
 */
public class CATLogsJpaController implements Serializable {

    public CATLogsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(CATLogs CATLogs) throws PreexistingEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(CATLogs);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findCATLogs(CATLogs.getId()) != null) {
                throw new PreexistingEntityException("CATLogs " + CATLogs + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(CATLogs CATLogs) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            CATLogs = em.merge(CATLogs);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = CATLogs.getId();
                if (findCATLogs(id) == null) {
                    throw new NonexistentEntityException("The cATLogs with id " + id + " no longer exists.");
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
            CATLogs CATLogs;
            try {
                CATLogs = em.getReference(CATLogs.class, id);
                CATLogs.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The CATLogs with id " + id + " no longer exists.", enfe);
            }
            em.remove(CATLogs);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<CATLogs> findCATLogsEntities() {
        return findCATLogsEntities(true, -1, -1);
    }

    public List<CATLogs> findCATLogsEntities(int maxResults, int firstResult) {
        return findCATLogsEntities(false, maxResults, firstResult);
    }

    private List<CATLogs> findCATLogsEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(CATLogs.class));
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

    public CATLogs findCATLogs(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(CATLogs.class, id);
        } finally {
            em.close();
        }
    }

    public int getCATLogsCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<CATLogs> rt = cq.from(CATLogs.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
