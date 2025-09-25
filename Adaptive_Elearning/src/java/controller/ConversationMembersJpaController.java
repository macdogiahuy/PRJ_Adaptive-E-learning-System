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
import model.ConversationMembers;
import model.ConversationMembersPK;
import model.Conversations;
import model.Users;

/**
 *
 * @author LP
 */
public class ConversationMembersJpaController implements Serializable {

    public ConversationMembersJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(ConversationMembers conversationMembers) throws PreexistingEntityException, Exception {
        if (conversationMembers.getConversationMembersPK() == null) {
            conversationMembers.setConversationMembersPK(new ConversationMembersPK());
        }
        conversationMembers.getConversationMembersPK().setCreatorId(conversationMembers.getUsers().getId());
        conversationMembers.getConversationMembersPK().setConversationId(conversationMembers.getConversations().getId());
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Conversations conversations = conversationMembers.getConversations();
            if (conversations != null) {
                conversations = em.getReference(conversations.getClass(), conversations.getId());
                conversationMembers.setConversations(conversations);
            }
            Users users = conversationMembers.getUsers();
            if (users != null) {
                users = em.getReference(users.getClass(), users.getId());
                conversationMembers.setUsers(users);
            }
            em.persist(conversationMembers);
            if (conversations != null) {
                conversations.getConversationMembersList().add(conversationMembers);
                conversations = em.merge(conversations);
            }
            if (users != null) {
                users.getConversationMembersList().add(conversationMembers);
                users = em.merge(users);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findConversationMembers(conversationMembers.getConversationMembersPK()) != null) {
                throw new PreexistingEntityException("ConversationMembers " + conversationMembers + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(ConversationMembers conversationMembers) throws NonexistentEntityException, Exception {
        conversationMembers.getConversationMembersPK().setCreatorId(conversationMembers.getUsers().getId());
        conversationMembers.getConversationMembersPK().setConversationId(conversationMembers.getConversations().getId());
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            ConversationMembers persistentConversationMembers = em.find(ConversationMembers.class, conversationMembers.getConversationMembersPK());
            Conversations conversationsOld = persistentConversationMembers.getConversations();
            Conversations conversationsNew = conversationMembers.getConversations();
            Users usersOld = persistentConversationMembers.getUsers();
            Users usersNew = conversationMembers.getUsers();
            if (conversationsNew != null) {
                conversationsNew = em.getReference(conversationsNew.getClass(), conversationsNew.getId());
                conversationMembers.setConversations(conversationsNew);
            }
            if (usersNew != null) {
                usersNew = em.getReference(usersNew.getClass(), usersNew.getId());
                conversationMembers.setUsers(usersNew);
            }
            conversationMembers = em.merge(conversationMembers);
            if (conversationsOld != null && !conversationsOld.equals(conversationsNew)) {
                conversationsOld.getConversationMembersList().remove(conversationMembers);
                conversationsOld = em.merge(conversationsOld);
            }
            if (conversationsNew != null && !conversationsNew.equals(conversationsOld)) {
                conversationsNew.getConversationMembersList().add(conversationMembers);
                conversationsNew = em.merge(conversationsNew);
            }
            if (usersOld != null && !usersOld.equals(usersNew)) {
                usersOld.getConversationMembersList().remove(conversationMembers);
                usersOld = em.merge(usersOld);
            }
            if (usersNew != null && !usersNew.equals(usersOld)) {
                usersNew.getConversationMembersList().add(conversationMembers);
                usersNew = em.merge(usersNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                ConversationMembersPK id = conversationMembers.getConversationMembersPK();
                if (findConversationMembers(id) == null) {
                    throw new NonexistentEntityException("The conversationMembers with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(ConversationMembersPK id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            ConversationMembers conversationMembers;
            try {
                conversationMembers = em.getReference(ConversationMembers.class, id);
                conversationMembers.getConversationMembersPK();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The conversationMembers with id " + id + " no longer exists.", enfe);
            }
            Conversations conversations = conversationMembers.getConversations();
            if (conversations != null) {
                conversations.getConversationMembersList().remove(conversationMembers);
                conversations = em.merge(conversations);
            }
            Users users = conversationMembers.getUsers();
            if (users != null) {
                users.getConversationMembersList().remove(conversationMembers);
                users = em.merge(users);
            }
            em.remove(conversationMembers);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<ConversationMembers> findConversationMembersEntities() {
        return findConversationMembersEntities(true, -1, -1);
    }

    public List<ConversationMembers> findConversationMembersEntities(int maxResults, int firstResult) {
        return findConversationMembersEntities(false, maxResults, firstResult);
    }

    private List<ConversationMembers> findConversationMembersEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(ConversationMembers.class));
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

    public ConversationMembers findConversationMembers(ConversationMembersPK id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(ConversationMembers.class, id);
        } finally {
            em.close();
        }
    }

    public int getConversationMembersCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<ConversationMembers> rt = cq.from(ConversationMembers.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
