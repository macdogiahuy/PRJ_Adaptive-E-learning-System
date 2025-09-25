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
import model.EFMigrationsHistory;

/**
 *
 * @author LP
 */
public class EFMigrationsHistoryJpaController implements Serializable {

    public EFMigrationsHistoryJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(EFMigrationsHistory EFMigrationsHistory) throws PreexistingEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(EFMigrationsHistory);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findEFMigrationsHistory(EFMigrationsHistory.getMigrationId()) != null) {
                throw new PreexistingEntityException("EFMigrationsHistory " + EFMigrationsHistory + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(EFMigrationsHistory EFMigrationsHistory) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            EFMigrationsHistory = em.merge(EFMigrationsHistory);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = EFMigrationsHistory.getMigrationId();
                if (findEFMigrationsHistory(id) == null) {
                    throw new NonexistentEntityException("The eFMigrationsHistory with id " + id + " no longer exists.");
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
            EFMigrationsHistory EFMigrationsHistory;
            try {
                EFMigrationsHistory = em.getReference(EFMigrationsHistory.class, id);
                EFMigrationsHistory.getMigrationId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The EFMigrationsHistory with id " + id + " no longer exists.", enfe);
            }
            em.remove(EFMigrationsHistory);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<EFMigrationsHistory> findEFMigrationsHistoryEntities() {
        return findEFMigrationsHistoryEntities(true, -1, -1);
    }

    public List<EFMigrationsHistory> findEFMigrationsHistoryEntities(int maxResults, int firstResult) {
        return findEFMigrationsHistoryEntities(false, maxResults, firstResult);
    }

    private List<EFMigrationsHistory> findEFMigrationsHistoryEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(EFMigrationsHistory.class));
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

    public EFMigrationsHistory findEFMigrationsHistory(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(EFMigrationsHistory.class, id);
        } finally {
            em.close();
        }
    }

    public int getEFMigrationsHistoryCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<EFMigrationsHistory> rt = cq.from(EFMigrationsHistory.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
