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
import model.Notifications;
import model.Users;

/**
 *
 * @author LP
 */
public class NotificationsJpaController implements Serializable {

    public NotificationsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Notifications notifications) throws PreexistingEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Users creatorId = notifications.getCreatorId();
            if (creatorId != null) {
                creatorId = em.getReference(creatorId.getClass(), creatorId.getId());
                notifications.setCreatorId(creatorId);
            }
            Users receiverId = notifications.getReceiverId();
            if (receiverId != null) {
                receiverId = em.getReference(receiverId.getClass(), receiverId.getId());
                notifications.setReceiverId(receiverId);
            }
            em.persist(notifications);
            if (creatorId != null) {
                creatorId.getNotificationsList().add(notifications);
                creatorId = em.merge(creatorId);
            }
            if (receiverId != null) {
                receiverId.getNotificationsList().add(notifications);
                receiverId = em.merge(receiverId);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findNotifications(notifications.getId()) != null) {
                throw new PreexistingEntityException("Notifications " + notifications + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Notifications notifications) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Notifications persistentNotifications = em.find(Notifications.class, notifications.getId());
            Users creatorIdOld = persistentNotifications.getCreatorId();
            Users creatorIdNew = notifications.getCreatorId();
            Users receiverIdOld = persistentNotifications.getReceiverId();
            Users receiverIdNew = notifications.getReceiverId();
            if (creatorIdNew != null) {
                creatorIdNew = em.getReference(creatorIdNew.getClass(), creatorIdNew.getId());
                notifications.setCreatorId(creatorIdNew);
            }
            if (receiverIdNew != null) {
                receiverIdNew = em.getReference(receiverIdNew.getClass(), receiverIdNew.getId());
                notifications.setReceiverId(receiverIdNew);
            }
            notifications = em.merge(notifications);
            if (creatorIdOld != null && !creatorIdOld.equals(creatorIdNew)) {
                creatorIdOld.getNotificationsList().remove(notifications);
                creatorIdOld = em.merge(creatorIdOld);
            }
            if (creatorIdNew != null && !creatorIdNew.equals(creatorIdOld)) {
                creatorIdNew.getNotificationsList().add(notifications);
                creatorIdNew = em.merge(creatorIdNew);
            }
            if (receiverIdOld != null && !receiverIdOld.equals(receiverIdNew)) {
                receiverIdOld.getNotificationsList().remove(notifications);
                receiverIdOld = em.merge(receiverIdOld);
            }
            if (receiverIdNew != null && !receiverIdNew.equals(receiverIdOld)) {
                receiverIdNew.getNotificationsList().add(notifications);
                receiverIdNew = em.merge(receiverIdNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = notifications.getId();
                if (findNotifications(id) == null) {
                    throw new NonexistentEntityException("The notifications with id " + id + " no longer exists.");
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
            Notifications notifications;
            try {
                notifications = em.getReference(Notifications.class, id);
                notifications.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The notifications with id " + id + " no longer exists.", enfe);
            }
            Users creatorId = notifications.getCreatorId();
            if (creatorId != null) {
                creatorId.getNotificationsList().remove(notifications);
                creatorId = em.merge(creatorId);
            }
            Users receiverId = notifications.getReceiverId();
            if (receiverId != null) {
                receiverId.getNotificationsList().remove(notifications);
                receiverId = em.merge(receiverId);
            }
            em.remove(notifications);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Notifications> findNotificationsEntities() {
        return findNotificationsEntities(true, -1, -1);
    }

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

    public Notifications findNotifications(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Notifications.class, id);
        } finally {
            em.close();
        }
    }

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

    public List<Notifications> findByType(String type) {
        EntityManager em = getEntityManager();
        try {
            Query q = em.createNamedQuery("Notifications.findByType");
            q.setParameter("type", type);
            return q.getResultList();
        } finally {
            em.close();
        }
    }
    
}
