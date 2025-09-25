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
import model.Articles;
import model.ChatMessages;
import model.Comments;
import model.Reactions;
import model.ReactionsPK;

/**
 *
 * @author LP
 */
public class ReactionsJpaController implements Serializable {

    public ReactionsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Reactions reactions) throws PreexistingEntityException, Exception {
        if (reactions.getReactionsPK() == null) {
            reactions.setReactionsPK(new ReactionsPK());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Articles articleId = reactions.getArticleId();
            if (articleId != null) {
                articleId = em.getReference(articleId.getClass(), articleId.getId());
                reactions.setArticleId(articleId);
            }
            ChatMessages chatMessageId = reactions.getChatMessageId();
            if (chatMessageId != null) {
                chatMessageId = em.getReference(chatMessageId.getClass(), chatMessageId.getId());
                reactions.setChatMessageId(chatMessageId);
            }
            Comments commentId = reactions.getCommentId();
            if (commentId != null) {
                commentId = em.getReference(commentId.getClass(), commentId.getId());
                reactions.setCommentId(commentId);
            }
            em.persist(reactions);
            if (articleId != null) {
                articleId.getReactionsList().add(reactions);
                articleId = em.merge(articleId);
            }
            if (chatMessageId != null) {
                chatMessageId.getReactionsList().add(reactions);
                chatMessageId = em.merge(chatMessageId);
            }
            if (commentId != null) {
                commentId.getReactionsList().add(reactions);
                commentId = em.merge(commentId);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findReactions(reactions.getReactionsPK()) != null) {
                throw new PreexistingEntityException("Reactions " + reactions + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Reactions reactions) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Reactions persistentReactions = em.find(Reactions.class, reactions.getReactionsPK());
            Articles articleIdOld = persistentReactions.getArticleId();
            Articles articleIdNew = reactions.getArticleId();
            ChatMessages chatMessageIdOld = persistentReactions.getChatMessageId();
            ChatMessages chatMessageIdNew = reactions.getChatMessageId();
            Comments commentIdOld = persistentReactions.getCommentId();
            Comments commentIdNew = reactions.getCommentId();
            if (articleIdNew != null) {
                articleIdNew = em.getReference(articleIdNew.getClass(), articleIdNew.getId());
                reactions.setArticleId(articleIdNew);
            }
            if (chatMessageIdNew != null) {
                chatMessageIdNew = em.getReference(chatMessageIdNew.getClass(), chatMessageIdNew.getId());
                reactions.setChatMessageId(chatMessageIdNew);
            }
            if (commentIdNew != null) {
                commentIdNew = em.getReference(commentIdNew.getClass(), commentIdNew.getId());
                reactions.setCommentId(commentIdNew);
            }
            reactions = em.merge(reactions);
            if (articleIdOld != null && !articleIdOld.equals(articleIdNew)) {
                articleIdOld.getReactionsList().remove(reactions);
                articleIdOld = em.merge(articleIdOld);
            }
            if (articleIdNew != null && !articleIdNew.equals(articleIdOld)) {
                articleIdNew.getReactionsList().add(reactions);
                articleIdNew = em.merge(articleIdNew);
            }
            if (chatMessageIdOld != null && !chatMessageIdOld.equals(chatMessageIdNew)) {
                chatMessageIdOld.getReactionsList().remove(reactions);
                chatMessageIdOld = em.merge(chatMessageIdOld);
            }
            if (chatMessageIdNew != null && !chatMessageIdNew.equals(chatMessageIdOld)) {
                chatMessageIdNew.getReactionsList().add(reactions);
                chatMessageIdNew = em.merge(chatMessageIdNew);
            }
            if (commentIdOld != null && !commentIdOld.equals(commentIdNew)) {
                commentIdOld.getReactionsList().remove(reactions);
                commentIdOld = em.merge(commentIdOld);
            }
            if (commentIdNew != null && !commentIdNew.equals(commentIdOld)) {
                commentIdNew.getReactionsList().add(reactions);
                commentIdNew = em.merge(commentIdNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                ReactionsPK id = reactions.getReactionsPK();
                if (findReactions(id) == null) {
                    throw new NonexistentEntityException("The reactions with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(ReactionsPK id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Reactions reactions;
            try {
                reactions = em.getReference(Reactions.class, id);
                reactions.getReactionsPK();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The reactions with id " + id + " no longer exists.", enfe);
            }
            Articles articleId = reactions.getArticleId();
            if (articleId != null) {
                articleId.getReactionsList().remove(reactions);
                articleId = em.merge(articleId);
            }
            ChatMessages chatMessageId = reactions.getChatMessageId();
            if (chatMessageId != null) {
                chatMessageId.getReactionsList().remove(reactions);
                chatMessageId = em.merge(chatMessageId);
            }
            Comments commentId = reactions.getCommentId();
            if (commentId != null) {
                commentId.getReactionsList().remove(reactions);
                commentId = em.merge(commentId);
            }
            em.remove(reactions);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Reactions> findReactionsEntities() {
        return findReactionsEntities(true, -1, -1);
    }

    public List<Reactions> findReactionsEntities(int maxResults, int firstResult) {
        return findReactionsEntities(false, maxResults, firstResult);
    }

    private List<Reactions> findReactionsEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Reactions.class));
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

    public Reactions findReactions(ReactionsPK id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Reactions.class, id);
        } finally {
            em.close();
        }
    }

    public int getReactionsCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Reactions> rt = cq.from(Reactions.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
