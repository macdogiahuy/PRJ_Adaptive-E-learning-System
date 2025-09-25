/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import controller.exceptions.NonexistentEntityException;
import controller.exceptions.PreexistingEntityException;
import java.io.Serializable;
import javax.persistence.Query;
import javax.persistence.EntityNotFoundException;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import model.Conversations;
import model.Users;
import model.Reactions;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.ChatMessages;

/**
 *
 * @author LP
 */
public class ChatMessagesJpaController implements Serializable {

    public ChatMessagesJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(ChatMessages chatMessages) throws PreexistingEntityException, Exception {
        if (chatMessages.getReactionsList() == null) {
            chatMessages.setReactionsList(new ArrayList<Reactions>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Conversations conversationId = chatMessages.getConversationId();
            if (conversationId != null) {
                conversationId = em.getReference(conversationId.getClass(), conversationId.getId());
                chatMessages.setConversationId(conversationId);
            }
            Users creatorId = chatMessages.getCreatorId();
            if (creatorId != null) {
                creatorId = em.getReference(creatorId.getClass(), creatorId.getId());
                chatMessages.setCreatorId(creatorId);
            }
            List<Reactions> attachedReactionsList = new ArrayList<Reactions>();
            for (Reactions reactionsListReactionsToAttach : chatMessages.getReactionsList()) {
                reactionsListReactionsToAttach = em.getReference(reactionsListReactionsToAttach.getClass(), reactionsListReactionsToAttach.getReactionsPK());
                attachedReactionsList.add(reactionsListReactionsToAttach);
            }
            chatMessages.setReactionsList(attachedReactionsList);
            em.persist(chatMessages);
            if (conversationId != null) {
                conversationId.getChatMessagesList().add(chatMessages);
                conversationId = em.merge(conversationId);
            }
            if (creatorId != null) {
                creatorId.getChatMessagesList().add(chatMessages);
                creatorId = em.merge(creatorId);
            }
            for (Reactions reactionsListReactions : chatMessages.getReactionsList()) {
                ChatMessages oldChatMessageIdOfReactionsListReactions = reactionsListReactions.getChatMessageId();
                reactionsListReactions.setChatMessageId(chatMessages);
                reactionsListReactions = em.merge(reactionsListReactions);
                if (oldChatMessageIdOfReactionsListReactions != null) {
                    oldChatMessageIdOfReactionsListReactions.getReactionsList().remove(reactionsListReactions);
                    oldChatMessageIdOfReactionsListReactions = em.merge(oldChatMessageIdOfReactionsListReactions);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findChatMessages(chatMessages.getId()) != null) {
                throw new PreexistingEntityException("ChatMessages " + chatMessages + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(ChatMessages chatMessages) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            ChatMessages persistentChatMessages = em.find(ChatMessages.class, chatMessages.getId());
            Conversations conversationIdOld = persistentChatMessages.getConversationId();
            Conversations conversationIdNew = chatMessages.getConversationId();
            Users creatorIdOld = persistentChatMessages.getCreatorId();
            Users creatorIdNew = chatMessages.getCreatorId();
            List<Reactions> reactionsListOld = persistentChatMessages.getReactionsList();
            List<Reactions> reactionsListNew = chatMessages.getReactionsList();
            if (conversationIdNew != null) {
                conversationIdNew = em.getReference(conversationIdNew.getClass(), conversationIdNew.getId());
                chatMessages.setConversationId(conversationIdNew);
            }
            if (creatorIdNew != null) {
                creatorIdNew = em.getReference(creatorIdNew.getClass(), creatorIdNew.getId());
                chatMessages.setCreatorId(creatorIdNew);
            }
            List<Reactions> attachedReactionsListNew = new ArrayList<Reactions>();
            for (Reactions reactionsListNewReactionsToAttach : reactionsListNew) {
                reactionsListNewReactionsToAttach = em.getReference(reactionsListNewReactionsToAttach.getClass(), reactionsListNewReactionsToAttach.getReactionsPK());
                attachedReactionsListNew.add(reactionsListNewReactionsToAttach);
            }
            reactionsListNew = attachedReactionsListNew;
            chatMessages.setReactionsList(reactionsListNew);
            chatMessages = em.merge(chatMessages);
            if (conversationIdOld != null && !conversationIdOld.equals(conversationIdNew)) {
                conversationIdOld.getChatMessagesList().remove(chatMessages);
                conversationIdOld = em.merge(conversationIdOld);
            }
            if (conversationIdNew != null && !conversationIdNew.equals(conversationIdOld)) {
                conversationIdNew.getChatMessagesList().add(chatMessages);
                conversationIdNew = em.merge(conversationIdNew);
            }
            if (creatorIdOld != null && !creatorIdOld.equals(creatorIdNew)) {
                creatorIdOld.getChatMessagesList().remove(chatMessages);
                creatorIdOld = em.merge(creatorIdOld);
            }
            if (creatorIdNew != null && !creatorIdNew.equals(creatorIdOld)) {
                creatorIdNew.getChatMessagesList().add(chatMessages);
                creatorIdNew = em.merge(creatorIdNew);
            }
            for (Reactions reactionsListOldReactions : reactionsListOld) {
                if (!reactionsListNew.contains(reactionsListOldReactions)) {
                    reactionsListOldReactions.setChatMessageId(null);
                    reactionsListOldReactions = em.merge(reactionsListOldReactions);
                }
            }
            for (Reactions reactionsListNewReactions : reactionsListNew) {
                if (!reactionsListOld.contains(reactionsListNewReactions)) {
                    ChatMessages oldChatMessageIdOfReactionsListNewReactions = reactionsListNewReactions.getChatMessageId();
                    reactionsListNewReactions.setChatMessageId(chatMessages);
                    reactionsListNewReactions = em.merge(reactionsListNewReactions);
                    if (oldChatMessageIdOfReactionsListNewReactions != null && !oldChatMessageIdOfReactionsListNewReactions.equals(chatMessages)) {
                        oldChatMessageIdOfReactionsListNewReactions.getReactionsList().remove(reactionsListNewReactions);
                        oldChatMessageIdOfReactionsListNewReactions = em.merge(oldChatMessageIdOfReactionsListNewReactions);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = chatMessages.getId();
                if (findChatMessages(id) == null) {
                    throw new NonexistentEntityException("The chatMessages with id " + id + " no longer exists.");
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
            ChatMessages chatMessages;
            try {
                chatMessages = em.getReference(ChatMessages.class, id);
                chatMessages.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The chatMessages with id " + id + " no longer exists.", enfe);
            }
            Conversations conversationId = chatMessages.getConversationId();
            if (conversationId != null) {
                conversationId.getChatMessagesList().remove(chatMessages);
                conversationId = em.merge(conversationId);
            }
            Users creatorId = chatMessages.getCreatorId();
            if (creatorId != null) {
                creatorId.getChatMessagesList().remove(chatMessages);
                creatorId = em.merge(creatorId);
            }
            List<Reactions> reactionsList = chatMessages.getReactionsList();
            for (Reactions reactionsListReactions : reactionsList) {
                reactionsListReactions.setChatMessageId(null);
                reactionsListReactions = em.merge(reactionsListReactions);
            }
            em.remove(chatMessages);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<ChatMessages> findChatMessagesEntities() {
        return findChatMessagesEntities(true, -1, -1);
    }

    public List<ChatMessages> findChatMessagesEntities(int maxResults, int firstResult) {
        return findChatMessagesEntities(false, maxResults, firstResult);
    }

    private List<ChatMessages> findChatMessagesEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(ChatMessages.class));
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

    public ChatMessages findChatMessages(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(ChatMessages.class, id);
        } finally {
            em.close();
        }
    }

    public int getChatMessagesCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<ChatMessages> rt = cq.from(ChatMessages.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
