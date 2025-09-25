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
import model.CommentMedia;
import model.CommentMediaPK;
import model.Comments;

/**
 *
 * @author LP
 */
public class CommentMediaJpaController implements Serializable {

    public CommentMediaJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(CommentMedia commentMedia) throws PreexistingEntityException, Exception {
        if (commentMedia.getCommentMediaPK() == null) {
            commentMedia.setCommentMediaPK(new CommentMediaPK());
        }
        commentMedia.getCommentMediaPK().setCommentId(commentMedia.getComments().getId());
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Comments comments = commentMedia.getComments();
            if (comments != null) {
                comments = em.getReference(comments.getClass(), comments.getId());
                commentMedia.setComments(comments);
            }
            em.persist(commentMedia);
            if (comments != null) {
                comments.getCommentMediaList().add(commentMedia);
                comments = em.merge(comments);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findCommentMedia(commentMedia.getCommentMediaPK()) != null) {
                throw new PreexistingEntityException("CommentMedia " + commentMedia + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(CommentMedia commentMedia) throws NonexistentEntityException, Exception {
        commentMedia.getCommentMediaPK().setCommentId(commentMedia.getComments().getId());
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            CommentMedia persistentCommentMedia = em.find(CommentMedia.class, commentMedia.getCommentMediaPK());
            Comments commentsOld = persistentCommentMedia.getComments();
            Comments commentsNew = commentMedia.getComments();
            if (commentsNew != null) {
                commentsNew = em.getReference(commentsNew.getClass(), commentsNew.getId());
                commentMedia.setComments(commentsNew);
            }
            commentMedia = em.merge(commentMedia);
            if (commentsOld != null && !commentsOld.equals(commentsNew)) {
                commentsOld.getCommentMediaList().remove(commentMedia);
                commentsOld = em.merge(commentsOld);
            }
            if (commentsNew != null && !commentsNew.equals(commentsOld)) {
                commentsNew.getCommentMediaList().add(commentMedia);
                commentsNew = em.merge(commentsNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                CommentMediaPK id = commentMedia.getCommentMediaPK();
                if (findCommentMedia(id) == null) {
                    throw new NonexistentEntityException("The commentMedia with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(CommentMediaPK id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            CommentMedia commentMedia;
            try {
                commentMedia = em.getReference(CommentMedia.class, id);
                commentMedia.getCommentMediaPK();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The commentMedia with id " + id + " no longer exists.", enfe);
            }
            Comments comments = commentMedia.getComments();
            if (comments != null) {
                comments.getCommentMediaList().remove(commentMedia);
                comments = em.merge(comments);
            }
            em.remove(commentMedia);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<CommentMedia> findCommentMediaEntities() {
        return findCommentMediaEntities(true, -1, -1);
    }

    public List<CommentMedia> findCommentMediaEntities(int maxResults, int firstResult) {
        return findCommentMediaEntities(false, maxResults, firstResult);
    }

    private List<CommentMedia> findCommentMediaEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(CommentMedia.class));
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

    public CommentMedia findCommentMedia(CommentMediaPK id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(CommentMedia.class, id);
        } finally {
            em.close();
        }
    }

    public int getCommentMediaCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<CommentMedia> rt = cq.from(CommentMedia.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
