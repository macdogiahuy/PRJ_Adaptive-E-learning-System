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
import model.Notifications;

/**
 * JPA Controller for Notifications entity
=======
/**
 *
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
 * @author LP
 */
public class NotificationsJpaController {
    
<<<<<<< HEAD
    private EntityManagerFactory emf = null;
    
    public NotificationsJpaController() {
        this.emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU");
    }
    
    public NotificationsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    
    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    
    /**
     * Create a new notification
     */
    public void create(Notifications notification) throws PreexistingEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(notification);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findNotification(notification.getId()) != null) {
                throw new PreexistingEntityException("Notification " + notification + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Update an existing notification
     */
    public void edit(Notifications notification) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            notification = em.merge(notification);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = notification.getId();
                if (findNotification(id) == null) {
                    throw new NonexistentEntityException("The notification with id " + id + " no longer exists.");
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
     * Delete a notification
     */
    public void destroy(String id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Notifications notification;
            try {
                notification = em.getReference(Notifications.class, id);
                notification.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The notification with id " + id + " no longer exists.", enfe);
            }
            em.remove(notification);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Find all notifications
     */
    public List<Notifications> findNotificationsEntities() {
        return findNotificationsEntities(true, -1, -1);
    }
    
    /**
     * Find notifications with pagination
     */
    public List<Notifications> findNotificationsEntities(int maxResults, int firstResult) {
        return findNotificationsEntities(false, maxResults, firstResult);
    }
    
    private List<Notifications> findNotificationsEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Notifications.class));
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
     * Find notification by ID
     */
    public Notifications findNotification(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Notifications.class, id);
        } finally {
            em.close();
        }
    }
    
    /**
     * Get total count of notifications
     */
    public int getNotificationsCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Notifications> rt = cq.from(Notifications.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
    /**
     * Find notifications by type
     */
    public List<Notifications> findByType(String type) {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT n FROM Notifications n WHERE n.type = :type");
            query.setParameter("type", type);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    /**
     * Find notifications by status
     */
    public List<Notifications> findByStatus(String status) {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT n FROM Notifications n WHERE n.status = :status");
            query.setParameter("status", status);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    /**
     * Find notifications by type and status
     */
    public List<Notifications> findByTypeAndStatus(String type, String status) {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT n FROM Notifications n WHERE n.type = :type AND n.status = :status");
            query.setParameter("type", type);
            query.setParameter("status", status);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    /**
     * Get distinct notification types
     */
    public List<String> getDistinctTypes() {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT DISTINCT n.type FROM Notifications n WHERE n.type IS NOT NULL ORDER BY n.type");
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    /**
     * Update notification status
     */
    public boolean updateStatus(String notificationId, String status) {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Notifications notification = em.find(Notifications.class, notificationId);
            if (notification != null) {
                notification.setStatus(status);
                em.merge(notification);
                em.getTransaction().commit();
                return true;
            }
            em.getTransaction().rollback();
            return false;
        } catch (Exception ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return false;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Get notifications with pagination and filters
     */
    public List<Notifications> findWithFilters(String type, String status, int firstResult, int maxResults) {
        EntityManager em = getEntityManager();
        try {
            StringBuilder queryStr = new StringBuilder("SELECT n FROM Notifications n WHERE 1=1");
            
            if (type != null && !type.trim().isEmpty()) {
                queryStr.append(" AND n.type = :type");
            }
            if (status != null && !status.trim().isEmpty()) {
                queryStr.append(" AND n.status = :status");
            }
            
            queryStr.append(" ORDER BY n.createdDate DESC");
            
            Query query = em.createQuery(queryStr.toString());
            
            if (type != null && !type.trim().isEmpty()) {
                query.setParameter("type", type);
            }
            if (status != null && !status.trim().isEmpty()) {
                query.setParameter("status", status);
            }
            
            query.setFirstResult(firstResult);
            query.setMaxResults(maxResults);
            
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    /**
     * Count notifications with filters
     */
    public long countWithFilters(String type, String status) {
        EntityManager em = getEntityManager();
        try {
            StringBuilder queryStr = new StringBuilder("SELECT COUNT(n) FROM Notifications n WHERE 1=1");
            
            if (type != null && !type.trim().isEmpty()) {
                queryStr.append(" AND n.type = :type");
            }
            if (status != null && !status.trim().isEmpty()) {
                queryStr.append(" AND n.status = :status");
            }
            
            Query query = em.createQuery(queryStr.toString());
            
            if (type != null && !type.trim().isEmpty()) {
                query.setParameter("type", type);
            }
            if (status != null && !status.trim().isEmpty()) {
                query.setParameter("status", status);
            }
            
            return (Long) query.getSingleResult();
        } finally {
            em.close();
        }
    }
=======
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
}
