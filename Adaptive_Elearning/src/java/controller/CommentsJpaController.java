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
import model.Articles;
import model.Comments;
import model.Lectures;
import model.Users;
import model.Reactions;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.CommentMedia;

/**
 *
 * @author LP
 */
public class CommentsJpaController implements Serializable {

    public CommentsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Comments comments) throws PreexistingEntityException, Exception {
        if (comments.getReactionsList() == null) {
            comments.setReactionsList(new ArrayList<Reactions>());
        }
        if (comments.getCommentMediaList() == null) {
            comments.setCommentMediaList(new ArrayList<CommentMedia>());
        }
        if (comments.getCommentsList() == null) {
            comments.setCommentsList(new ArrayList<Comments>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Articles articleId = comments.getArticleId();
            if (articleId != null) {
                articleId = em.getReference(articleId.getClass(), articleId.getId());
                comments.setArticleId(articleId);
            }
            Comments parentId = comments.getParentId();
            if (parentId != null) {
                parentId = em.getReference(parentId.getClass(), parentId.getId());
                comments.setParentId(parentId);
            }
            Lectures lectureId = comments.getLectureId();
            if (lectureId != null) {
                lectureId = em.getReference(lectureId.getClass(), lectureId.getId());
                comments.setLectureId(lectureId);
            }
            Users creatorId = comments.getCreatorId();
            if (creatorId != null) {
                creatorId = em.getReference(creatorId.getClass(), creatorId.getId());
                comments.setCreatorId(creatorId);
            }
            List<Reactions> attachedReactionsList = new ArrayList<Reactions>();
            for (Reactions reactionsListReactionsToAttach : comments.getReactionsList()) {
                reactionsListReactionsToAttach = em.getReference(reactionsListReactionsToAttach.getClass(), reactionsListReactionsToAttach.getReactionsPK());
                attachedReactionsList.add(reactionsListReactionsToAttach);
            }
            comments.setReactionsList(attachedReactionsList);
            List<CommentMedia> attachedCommentMediaList = new ArrayList<CommentMedia>();
            for (CommentMedia commentMediaListCommentMediaToAttach : comments.getCommentMediaList()) {
                commentMediaListCommentMediaToAttach = em.getReference(commentMediaListCommentMediaToAttach.getClass(), commentMediaListCommentMediaToAttach.getCommentMediaPK());
                attachedCommentMediaList.add(commentMediaListCommentMediaToAttach);
            }
            comments.setCommentMediaList(attachedCommentMediaList);
            List<Comments> attachedCommentsList = new ArrayList<Comments>();
            for (Comments commentsListCommentsToAttach : comments.getCommentsList()) {
                commentsListCommentsToAttach = em.getReference(commentsListCommentsToAttach.getClass(), commentsListCommentsToAttach.getId());
                attachedCommentsList.add(commentsListCommentsToAttach);
            }
            comments.setCommentsList(attachedCommentsList);
            em.persist(comments);
            if (articleId != null) {
                articleId.getCommentsList().add(comments);
                articleId = em.merge(articleId);
            }
            if (parentId != null) {
                parentId.getCommentsList().add(comments);
                parentId = em.merge(parentId);
            }
            if (lectureId != null) {
                lectureId.getCommentsList().add(comments);
                lectureId = em.merge(lectureId);
            }
            if (creatorId != null) {
                creatorId.getCommentsList().add(comments);
                creatorId = em.merge(creatorId);
            }
            for (Reactions reactionsListReactions : comments.getReactionsList()) {
                Comments oldCommentIdOfReactionsListReactions = reactionsListReactions.getCommentId();
                reactionsListReactions.setCommentId(comments);
                reactionsListReactions = em.merge(reactionsListReactions);
                if (oldCommentIdOfReactionsListReactions != null) {
                    oldCommentIdOfReactionsListReactions.getReactionsList().remove(reactionsListReactions);
                    oldCommentIdOfReactionsListReactions = em.merge(oldCommentIdOfReactionsListReactions);
                }
            }
            for (CommentMedia commentMediaListCommentMedia : comments.getCommentMediaList()) {
                Comments oldCommentsOfCommentMediaListCommentMedia = commentMediaListCommentMedia.getComments();
                commentMediaListCommentMedia.setComments(comments);
                commentMediaListCommentMedia = em.merge(commentMediaListCommentMedia);
                if (oldCommentsOfCommentMediaListCommentMedia != null) {
                    oldCommentsOfCommentMediaListCommentMedia.getCommentMediaList().remove(commentMediaListCommentMedia);
                    oldCommentsOfCommentMediaListCommentMedia = em.merge(oldCommentsOfCommentMediaListCommentMedia);
                }
            }
            for (Comments commentsListComments : comments.getCommentsList()) {
                Comments oldParentIdOfCommentsListComments = commentsListComments.getParentId();
                commentsListComments.setParentId(comments);
                commentsListComments = em.merge(commentsListComments);
                if (oldParentIdOfCommentsListComments != null) {
                    oldParentIdOfCommentsListComments.getCommentsList().remove(commentsListComments);
                    oldParentIdOfCommentsListComments = em.merge(oldParentIdOfCommentsListComments);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findComments(comments.getId()) != null) {
                throw new PreexistingEntityException("Comments " + comments + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Comments comments) throws IllegalOrphanException, NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Comments persistentComments = em.find(Comments.class, comments.getId());
            Articles articleIdOld = persistentComments.getArticleId();
            Articles articleIdNew = comments.getArticleId();
            Comments parentIdOld = persistentComments.getParentId();
            Comments parentIdNew = comments.getParentId();
            Lectures lectureIdOld = persistentComments.getLectureId();
            Lectures lectureIdNew = comments.getLectureId();
            Users creatorIdOld = persistentComments.getCreatorId();
            Users creatorIdNew = comments.getCreatorId();
            List<Reactions> reactionsListOld = persistentComments.getReactionsList();
            List<Reactions> reactionsListNew = comments.getReactionsList();
            List<CommentMedia> commentMediaListOld = persistentComments.getCommentMediaList();
            List<CommentMedia> commentMediaListNew = comments.getCommentMediaList();
            List<Comments> commentsListOld = persistentComments.getCommentsList();
            List<Comments> commentsListNew = comments.getCommentsList();
            List<String> illegalOrphanMessages = null;
            for (CommentMedia commentMediaListOldCommentMedia : commentMediaListOld) {
                if (!commentMediaListNew.contains(commentMediaListOldCommentMedia)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain CommentMedia " + commentMediaListOldCommentMedia + " since its comments field is not nullable.");
                }
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            if (articleIdNew != null) {
                articleIdNew = em.getReference(articleIdNew.getClass(), articleIdNew.getId());
                comments.setArticleId(articleIdNew);
            }
            if (parentIdNew != null) {
                parentIdNew = em.getReference(parentIdNew.getClass(), parentIdNew.getId());
                comments.setParentId(parentIdNew);
            }
            if (lectureIdNew != null) {
                lectureIdNew = em.getReference(lectureIdNew.getClass(), lectureIdNew.getId());
                comments.setLectureId(lectureIdNew);
            }
            if (creatorIdNew != null) {
                creatorIdNew = em.getReference(creatorIdNew.getClass(), creatorIdNew.getId());
                comments.setCreatorId(creatorIdNew);
            }
            List<Reactions> attachedReactionsListNew = new ArrayList<Reactions>();
            for (Reactions reactionsListNewReactionsToAttach : reactionsListNew) {
                reactionsListNewReactionsToAttach = em.getReference(reactionsListNewReactionsToAttach.getClass(), reactionsListNewReactionsToAttach.getReactionsPK());
                attachedReactionsListNew.add(reactionsListNewReactionsToAttach);
            }
            reactionsListNew = attachedReactionsListNew;
            comments.setReactionsList(reactionsListNew);
            List<CommentMedia> attachedCommentMediaListNew = new ArrayList<CommentMedia>();
            for (CommentMedia commentMediaListNewCommentMediaToAttach : commentMediaListNew) {
                commentMediaListNewCommentMediaToAttach = em.getReference(commentMediaListNewCommentMediaToAttach.getClass(), commentMediaListNewCommentMediaToAttach.getCommentMediaPK());
                attachedCommentMediaListNew.add(commentMediaListNewCommentMediaToAttach);
            }
            commentMediaListNew = attachedCommentMediaListNew;
            comments.setCommentMediaList(commentMediaListNew);
            List<Comments> attachedCommentsListNew = new ArrayList<Comments>();
            for (Comments commentsListNewCommentsToAttach : commentsListNew) {
                commentsListNewCommentsToAttach = em.getReference(commentsListNewCommentsToAttach.getClass(), commentsListNewCommentsToAttach.getId());
                attachedCommentsListNew.add(commentsListNewCommentsToAttach);
            }
            commentsListNew = attachedCommentsListNew;
            comments.setCommentsList(commentsListNew);
            comments = em.merge(comments);
            if (articleIdOld != null && !articleIdOld.equals(articleIdNew)) {
                articleIdOld.getCommentsList().remove(comments);
                articleIdOld = em.merge(articleIdOld);
            }
            if (articleIdNew != null && !articleIdNew.equals(articleIdOld)) {
                articleIdNew.getCommentsList().add(comments);
                articleIdNew = em.merge(articleIdNew);
            }
            if (parentIdOld != null && !parentIdOld.equals(parentIdNew)) {
                parentIdOld.getCommentsList().remove(comments);
                parentIdOld = em.merge(parentIdOld);
            }
            if (parentIdNew != null && !parentIdNew.equals(parentIdOld)) {
                parentIdNew.getCommentsList().add(comments);
                parentIdNew = em.merge(parentIdNew);
            }
            if (lectureIdOld != null && !lectureIdOld.equals(lectureIdNew)) {
                lectureIdOld.getCommentsList().remove(comments);
                lectureIdOld = em.merge(lectureIdOld);
            }
            if (lectureIdNew != null && !lectureIdNew.equals(lectureIdOld)) {
                lectureIdNew.getCommentsList().add(comments);
                lectureIdNew = em.merge(lectureIdNew);
            }
            if (creatorIdOld != null && !creatorIdOld.equals(creatorIdNew)) {
                creatorIdOld.getCommentsList().remove(comments);
                creatorIdOld = em.merge(creatorIdOld);
            }
            if (creatorIdNew != null && !creatorIdNew.equals(creatorIdOld)) {
                creatorIdNew.getCommentsList().add(comments);
                creatorIdNew = em.merge(creatorIdNew);
            }
            for (Reactions reactionsListOldReactions : reactionsListOld) {
                if (!reactionsListNew.contains(reactionsListOldReactions)) {
                    reactionsListOldReactions.setCommentId(null);
                    reactionsListOldReactions = em.merge(reactionsListOldReactions);
                }
            }
            for (Reactions reactionsListNewReactions : reactionsListNew) {
                if (!reactionsListOld.contains(reactionsListNewReactions)) {
                    Comments oldCommentIdOfReactionsListNewReactions = reactionsListNewReactions.getCommentId();
                    reactionsListNewReactions.setCommentId(comments);
                    reactionsListNewReactions = em.merge(reactionsListNewReactions);
                    if (oldCommentIdOfReactionsListNewReactions != null && !oldCommentIdOfReactionsListNewReactions.equals(comments)) {
                        oldCommentIdOfReactionsListNewReactions.getReactionsList().remove(reactionsListNewReactions);
                        oldCommentIdOfReactionsListNewReactions = em.merge(oldCommentIdOfReactionsListNewReactions);
                    }
                }
            }
            for (CommentMedia commentMediaListNewCommentMedia : commentMediaListNew) {
                if (!commentMediaListOld.contains(commentMediaListNewCommentMedia)) {
                    Comments oldCommentsOfCommentMediaListNewCommentMedia = commentMediaListNewCommentMedia.getComments();
                    commentMediaListNewCommentMedia.setComments(comments);
                    commentMediaListNewCommentMedia = em.merge(commentMediaListNewCommentMedia);
                    if (oldCommentsOfCommentMediaListNewCommentMedia != null && !oldCommentsOfCommentMediaListNewCommentMedia.equals(comments)) {
                        oldCommentsOfCommentMediaListNewCommentMedia.getCommentMediaList().remove(commentMediaListNewCommentMedia);
                        oldCommentsOfCommentMediaListNewCommentMedia = em.merge(oldCommentsOfCommentMediaListNewCommentMedia);
                    }
                }
            }
            for (Comments commentsListOldComments : commentsListOld) {
                if (!commentsListNew.contains(commentsListOldComments)) {
                    commentsListOldComments.setParentId(null);
                    commentsListOldComments = em.merge(commentsListOldComments);
                }
            }
            for (Comments commentsListNewComments : commentsListNew) {
                if (!commentsListOld.contains(commentsListNewComments)) {
                    Comments oldParentIdOfCommentsListNewComments = commentsListNewComments.getParentId();
                    commentsListNewComments.setParentId(comments);
                    commentsListNewComments = em.merge(commentsListNewComments);
                    if (oldParentIdOfCommentsListNewComments != null && !oldParentIdOfCommentsListNewComments.equals(comments)) {
                        oldParentIdOfCommentsListNewComments.getCommentsList().remove(commentsListNewComments);
                        oldParentIdOfCommentsListNewComments = em.merge(oldParentIdOfCommentsListNewComments);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = comments.getId();
                if (findComments(id) == null) {
                    throw new NonexistentEntityException("The comments with id " + id + " no longer exists.");
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
            Comments comments;
            try {
                comments = em.getReference(Comments.class, id);
                comments.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The comments with id " + id + " no longer exists.", enfe);
            }
            List<String> illegalOrphanMessages = null;
            List<CommentMedia> commentMediaListOrphanCheck = comments.getCommentMediaList();
            for (CommentMedia commentMediaListOrphanCheckCommentMedia : commentMediaListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Comments (" + comments + ") cannot be destroyed since the CommentMedia " + commentMediaListOrphanCheckCommentMedia + " in its commentMediaList field has a non-nullable comments field.");
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            Articles articleId = comments.getArticleId();
            if (articleId != null) {
                articleId.getCommentsList().remove(comments);
                articleId = em.merge(articleId);
            }
            Comments parentId = comments.getParentId();
            if (parentId != null) {
                parentId.getCommentsList().remove(comments);
                parentId = em.merge(parentId);
            }
            Lectures lectureId = comments.getLectureId();
            if (lectureId != null) {
                lectureId.getCommentsList().remove(comments);
                lectureId = em.merge(lectureId);
            }
            Users creatorId = comments.getCreatorId();
            if (creatorId != null) {
                creatorId.getCommentsList().remove(comments);
                creatorId = em.merge(creatorId);
            }
            List<Reactions> reactionsList = comments.getReactionsList();
            for (Reactions reactionsListReactions : reactionsList) {
                reactionsListReactions.setCommentId(null);
                reactionsListReactions = em.merge(reactionsListReactions);
            }
            List<Comments> commentsList = comments.getCommentsList();
            for (Comments commentsListComments : commentsList) {
                commentsListComments.setParentId(null);
                commentsListComments = em.merge(commentsListComments);
            }
            em.remove(comments);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Comments> findCommentsEntities() {
        return findCommentsEntities(true, -1, -1);
    }

    public List<Comments> findCommentsEntities(int maxResults, int firstResult) {
        return findCommentsEntities(false, maxResults, firstResult);
    }

    private List<Comments> findCommentsEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Comments.class));
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

    public Comments findComments(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Comments.class, id);
        } finally {
            em.close();
        }
    }

    public int getCommentsCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Comments> rt = cq.from(Comments.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
