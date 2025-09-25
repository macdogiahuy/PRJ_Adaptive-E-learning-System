/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import controller.exceptions.IllegalOrphanException;
import controller.exceptions.NonexistentEntityException;
import controller.exceptions.PreexistingEntityException;
import java.io.Serializable;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.Users;
import model.ChatMessages;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.ConversationMembers;
import model.Conversations;

/**
 *
 * @author LP
 */
public class ConversationsJpaController implements Serializable {

    public ConversationsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Conversations conversations) throws PreexistingEntityException, Exception {
        if (conversations.getChatMessagesList() == null) {
            conversations.setChatMessagesList(new ArrayList<ChatMessages>());
        }
        if (conversations.getConversationMembersList() == null) {
            conversations.setConversationMembersList(new ArrayList<ConversationMembers>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Users creatorId = conversations.getCreatorId();
            if (creatorId != null) {
                creatorId = em.getReference(creatorId.getClass(), creatorId.getId());
                conversations.setCreatorId(creatorId);
            }
            List<ChatMessages> attachedChatMessagesList = new ArrayList<ChatMessages>();
            for (ChatMessages chatMessagesListChatMessagesToAttach : conversations.getChatMessagesList()) {
                chatMessagesListChatMessagesToAttach = em.getReference(chatMessagesListChatMessagesToAttach.getClass(), chatMessagesListChatMessagesToAttach.getId());
                attachedChatMessagesList.add(chatMessagesListChatMessagesToAttach);
            }
            conversations.setChatMessagesList(attachedChatMessagesList);
            List<ConversationMembers> attachedConversationMembersList = new ArrayList<ConversationMembers>();
            for (ConversationMembers conversationMembersListConversationMembersToAttach : conversations.getConversationMembersList()) {
                conversationMembersListConversationMembersToAttach = em.getReference(conversationMembersListConversationMembersToAttach.getClass(), conversationMembersListConversationMembersToAttach.getConversationMembersPK());
                attachedConversationMembersList.add(conversationMembersListConversationMembersToAttach);
            }
            conversations.setConversationMembersList(attachedConversationMembersList);
            em.persist(conversations);
            if (creatorId != null) {
                creatorId.getConversationsList().add(conversations);
                creatorId = em.merge(creatorId);
            }
            for (ChatMessages chatMessagesListChatMessages : conversations.getChatMessagesList()) {
                Conversations oldConversationIdOfChatMessagesListChatMessages = chatMessagesListChatMessages.getConversationId();
                chatMessagesListChatMessages.setConversationId(conversations);
                chatMessagesListChatMessages = em.merge(chatMessagesListChatMessages);
                if (oldConversationIdOfChatMessagesListChatMessages != null) {
                    oldConversationIdOfChatMessagesListChatMessages.getChatMessagesList().remove(chatMessagesListChatMessages);
                    oldConversationIdOfChatMessagesListChatMessages = em.merge(oldConversationIdOfChatMessagesListChatMessages);
                }
            }
            for (ConversationMembers conversationMembersListConversationMembers : conversations.getConversationMembersList()) {
                Conversations oldConversationsOfConversationMembersListConversationMembers = conversationMembersListConversationMembers.getConversations();
                conversationMembersListConversationMembers.setConversations(conversations);
                conversationMembersListConversationMembers = em.merge(conversationMembersListConversationMembers);
                if (oldConversationsOfConversationMembersListConversationMembers != null) {
                    oldConversationsOfConversationMembersListConversationMembers.getConversationMembersList().remove(conversationMembersListConversationMembers);
                    oldConversationsOfConversationMembersListConversationMembers = em.merge(oldConversationsOfConversationMembersListConversationMembers);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findConversations(conversations.getId()) != null) {
                throw new PreexistingEntityException("Conversations " + conversations + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Conversations conversations) throws IllegalOrphanException, NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Conversations persistentConversations = em.find(Conversations.class, conversations.getId());
            Users creatorIdOld = persistentConversations.getCreatorId();
            Users creatorIdNew = conversations.getCreatorId();
            List<ChatMessages> chatMessagesListOld = persistentConversations.getChatMessagesList();
            List<ChatMessages> chatMessagesListNew = conversations.getChatMessagesList();
            List<ConversationMembers> conversationMembersListOld = persistentConversations.getConversationMembersList();
            List<ConversationMembers> conversationMembersListNew = conversations.getConversationMembersList();
            List<String> illegalOrphanMessages = null;
            for (ChatMessages chatMessagesListOldChatMessages : chatMessagesListOld) {
                if (!chatMessagesListNew.contains(chatMessagesListOldChatMessages)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain ChatMessages " + chatMessagesListOldChatMessages + " since its conversationId field is not nullable.");
                }
            }
            for (ConversationMembers conversationMembersListOldConversationMembers : conversationMembersListOld) {
                if (!conversationMembersListNew.contains(conversationMembersListOldConversationMembers)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain ConversationMembers " + conversationMembersListOldConversationMembers + " since its conversations field is not nullable.");
                }
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            if (creatorIdNew != null) {
                creatorIdNew = em.getReference(creatorIdNew.getClass(), creatorIdNew.getId());
                conversations.setCreatorId(creatorIdNew);
            }
            List<ChatMessages> attachedChatMessagesListNew = new ArrayList<ChatMessages>();
            for (ChatMessages chatMessagesListNewChatMessagesToAttach : chatMessagesListNew) {
                chatMessagesListNewChatMessagesToAttach = em.getReference(chatMessagesListNewChatMessagesToAttach.getClass(), chatMessagesListNewChatMessagesToAttach.getId());
                attachedChatMessagesListNew.add(chatMessagesListNewChatMessagesToAttach);
            }
            chatMessagesListNew = attachedChatMessagesListNew;
            conversations.setChatMessagesList(chatMessagesListNew);
            List<ConversationMembers> attachedConversationMembersListNew = new ArrayList<ConversationMembers>();
            for (ConversationMembers conversationMembersListNewConversationMembersToAttach : conversationMembersListNew) {
                conversationMembersListNewConversationMembersToAttach = em.getReference(conversationMembersListNewConversationMembersToAttach.getClass(), conversationMembersListNewConversationMembersToAttach.getConversationMembersPK());
                attachedConversationMembersListNew.add(conversationMembersListNewConversationMembersToAttach);
            }
            conversationMembersListNew = attachedConversationMembersListNew;
            conversations.setConversationMembersList(conversationMembersListNew);
            conversations = em.merge(conversations);
            if (creatorIdOld != null && !creatorIdOld.equals(creatorIdNew)) {
                creatorIdOld.getConversationsList().remove(conversations);
                creatorIdOld = em.merge(creatorIdOld);
            }
            if (creatorIdNew != null && !creatorIdNew.equals(creatorIdOld)) {
                creatorIdNew.getConversationsList().add(conversations);
                creatorIdNew = em.merge(creatorIdNew);
            }
            for (ChatMessages chatMessagesListNewChatMessages : chatMessagesListNew) {
                if (!chatMessagesListOld.contains(chatMessagesListNewChatMessages)) {
                    Conversations oldConversationIdOfChatMessagesListNewChatMessages = chatMessagesListNewChatMessages.getConversationId();
                    chatMessagesListNewChatMessages.setConversationId(conversations);
                    chatMessagesListNewChatMessages = em.merge(chatMessagesListNewChatMessages);
                    if (oldConversationIdOfChatMessagesListNewChatMessages != null && !oldConversationIdOfChatMessagesListNewChatMessages.equals(conversations)) {
                        oldConversationIdOfChatMessagesListNewChatMessages.getChatMessagesList().remove(chatMessagesListNewChatMessages);
                        oldConversationIdOfChatMessagesListNewChatMessages = em.merge(oldConversationIdOfChatMessagesListNewChatMessages);
                    }
                }
            }
            for (ConversationMembers conversationMembersListNewConversationMembers : conversationMembersListNew) {
                if (!conversationMembersListOld.contains(conversationMembersListNewConversationMembers)) {
                    Conversations oldConversationsOfConversationMembersListNewConversationMembers = conversationMembersListNewConversationMembers.getConversations();
                    conversationMembersListNewConversationMembers.setConversations(conversations);
                    conversationMembersListNewConversationMembers = em.merge(conversationMembersListNewConversationMembers);
                    if (oldConversationsOfConversationMembersListNewConversationMembers != null && !oldConversationsOfConversationMembersListNewConversationMembers.equals(conversations)) {
                        oldConversationsOfConversationMembersListNewConversationMembers.getConversationMembersList().remove(conversationMembersListNewConversationMembers);
                        oldConversationsOfConversationMembersListNewConversationMembers = em.merge(oldConversationsOfConversationMembersListNewConversationMembers);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = conversations.getId();
                if (findConversations(id) == null) {
                    throw new NonexistentEntityException("The conversations with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(String id) throws IllegalOrphanException, NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Conversations conversations;
            try {
                conversations = em.getReference(Conversations.class, id);
                conversations.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The conversations with id " + id + " no longer exists.", enfe);
            }
            List<String> illegalOrphanMessages = null;
            List<ChatMessages> chatMessagesListOrphanCheck = conversations.getChatMessagesList();
            for (ChatMessages chatMessagesListOrphanCheckChatMessages : chatMessagesListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Conversations (" + conversations + ") cannot be destroyed since the ChatMessages " + chatMessagesListOrphanCheckChatMessages + " in its chatMessagesList field has a non-nullable conversationId field.");
            }
            List<ConversationMembers> conversationMembersListOrphanCheck = conversations.getConversationMembersList();
            for (ConversationMembers conversationMembersListOrphanCheckConversationMembers : conversationMembersListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Conversations (" + conversations + ") cannot be destroyed since the ConversationMembers " + conversationMembersListOrphanCheckConversationMembers + " in its conversationMembersList field has a non-nullable conversations field.");
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            Users creatorId = conversations.getCreatorId();
            if (creatorId != null) {
                creatorId.getConversationsList().remove(conversations);
                creatorId = em.merge(creatorId);
            }
            em.remove(conversations);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Conversations> findConversationsEntities() {
        return findConversationsEntities(true, -1, -1);
    }

    public List<Conversations> findConversationsEntities(int maxResults, int firstResult) {
        return findConversationsEntities(false, maxResults, firstResult);
    }

    private List<Conversations> findConversationsEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Conversations.class));
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

    public Conversations findConversations(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Conversations.class, id);
        } finally {
            em.close();
        }
    }

    public int getConversationsCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Conversations> rt = cq.from(Conversations.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
