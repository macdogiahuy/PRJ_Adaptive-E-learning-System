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
import model.Bills;
import model.Enrollments;
import model.Users;

/**
 *
 * @author LP
 */
public class BillsJpaController implements Serializable {

    public BillsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Bills bills) throws PreexistingEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Enrollments enrollments = bills.getEnrollments();
            if (enrollments != null) {
                enrollments = em.getReference(enrollments.getClass(), enrollments.getEnrollmentsPK());
                bills.setEnrollments(enrollments);
            }
            Users creatorId = bills.getCreatorId();
            if (creatorId != null) {
                creatorId = em.getReference(creatorId.getClass(), creatorId.getId());
                bills.setCreatorId(creatorId);
            }
            em.persist(bills);
            if (enrollments != null) {
                Bills oldBillIdOfEnrollments = enrollments.getBillId();
                if (oldBillIdOfEnrollments != null) {
                    oldBillIdOfEnrollments.setEnrollments(null);
                    oldBillIdOfEnrollments = em.merge(oldBillIdOfEnrollments);
                }
                enrollments.setBillId(bills);
                enrollments = em.merge(enrollments);
            }
            if (creatorId != null) {
                creatorId.getBillsList().add(bills);
                creatorId = em.merge(creatorId);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findBills(bills.getId()) != null) {
                throw new PreexistingEntityException("Bills " + bills + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Bills bills) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Bills persistentBills = em.find(Bills.class, bills.getId());
            Enrollments enrollmentsOld = persistentBills.getEnrollments();
            Enrollments enrollmentsNew = bills.getEnrollments();
            Users creatorIdOld = persistentBills.getCreatorId();
            Users creatorIdNew = bills.getCreatorId();
            if (enrollmentsNew != null) {
                enrollmentsNew = em.getReference(enrollmentsNew.getClass(), enrollmentsNew.getEnrollmentsPK());
                bills.setEnrollments(enrollmentsNew);
            }
            if (creatorIdNew != null) {
                creatorIdNew = em.getReference(creatorIdNew.getClass(), creatorIdNew.getId());
                bills.setCreatorId(creatorIdNew);
            }
            bills = em.merge(bills);
            if (enrollmentsOld != null && !enrollmentsOld.equals(enrollmentsNew)) {
                enrollmentsOld.setBillId(null);
                enrollmentsOld = em.merge(enrollmentsOld);
            }
            if (enrollmentsNew != null && !enrollmentsNew.equals(enrollmentsOld)) {
                Bills oldBillIdOfEnrollments = enrollmentsNew.getBillId();
                if (oldBillIdOfEnrollments != null) {
                    oldBillIdOfEnrollments.setEnrollments(null);
                    oldBillIdOfEnrollments = em.merge(oldBillIdOfEnrollments);
                }
                enrollmentsNew.setBillId(bills);
                enrollmentsNew = em.merge(enrollmentsNew);
            }
            if (creatorIdOld != null && !creatorIdOld.equals(creatorIdNew)) {
                creatorIdOld.getBillsList().remove(bills);
                creatorIdOld = em.merge(creatorIdOld);
            }
            if (creatorIdNew != null && !creatorIdNew.equals(creatorIdOld)) {
                creatorIdNew.getBillsList().add(bills);
                creatorIdNew = em.merge(creatorIdNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = bills.getId();
                if (findBills(id) == null) {
                    throw new NonexistentEntityException("The bills with id " + id + " no longer exists.");
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
            Bills bills;
            try {
                bills = em.getReference(Bills.class, id);
                bills.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The bills with id " + id + " no longer exists.", enfe);
            }
            Enrollments enrollments = bills.getEnrollments();
            if (enrollments != null) {
                enrollments.setBillId(null);
                enrollments = em.merge(enrollments);
            }
            Users creatorId = bills.getCreatorId();
            if (creatorId != null) {
                creatorId.getBillsList().remove(bills);
                creatorId = em.merge(creatorId);
            }
            em.remove(bills);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Bills> findBillsEntities() {
        return findBillsEntities(true, -1, -1);
    }

    public List<Bills> findBillsEntities(int maxResults, int firstResult) {
        return findBillsEntities(false, maxResults, firstResult);
    }

    private List<Bills> findBillsEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Bills.class));
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

    public Bills findBills(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Bills.class, id);
        } finally {
            em.close();
        }
    }

    public int getBillsCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Bills> rt = cq.from(Bills.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
