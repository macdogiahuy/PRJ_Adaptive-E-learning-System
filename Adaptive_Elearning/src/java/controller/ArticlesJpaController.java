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
import model.Reactions;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import model.Articles;
import model.Comments;
import model.Tag;

/**
 *
 * @author LP
 */
public class ArticlesJpaController implements Serializable {

    public ArticlesJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Articles articles) throws PreexistingEntityException, Exception {
        if (articles.getReactionsList() == null) {
            articles.setReactionsList(new ArrayList<Reactions>());
        }
        if (articles.getCommentsList() == null) {
            articles.setCommentsList(new ArrayList<Comments>());
        }
        if (articles.getTagList() == null) {
            articles.setTagList(new ArrayList<Tag>());
        }
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Users creatorId = articles.getCreatorId();
            if (creatorId != null) {
                creatorId = em.getReference(creatorId.getClass(), creatorId.getId());
                articles.setCreatorId(creatorId);
            }
            List<Reactions> attachedReactionsList = new ArrayList<Reactions>();
            for (Reactions reactionsListReactionsToAttach : articles.getReactionsList()) {
                reactionsListReactionsToAttach = em.getReference(reactionsListReactionsToAttach.getClass(), reactionsListReactionsToAttach.getReactionsPK());
                attachedReactionsList.add(reactionsListReactionsToAttach);
            }
            articles.setReactionsList(attachedReactionsList);
            List<Comments> attachedCommentsList = new ArrayList<Comments>();
            for (Comments commentsListCommentsToAttach : articles.getCommentsList()) {
                commentsListCommentsToAttach = em.getReference(commentsListCommentsToAttach.getClass(), commentsListCommentsToAttach.getId());
                attachedCommentsList.add(commentsListCommentsToAttach);
            }
            articles.setCommentsList(attachedCommentsList);
            List<Tag> attachedTagList = new ArrayList<Tag>();
            for (Tag tagListTagToAttach : articles.getTagList()) {
                tagListTagToAttach = em.getReference(tagListTagToAttach.getClass(), tagListTagToAttach.getTagPK());
                attachedTagList.add(tagListTagToAttach);
            }
            articles.setTagList(attachedTagList);
            em.persist(articles);
            if (creatorId != null) {
                creatorId.getArticlesList().add(articles);
                creatorId = em.merge(creatorId);
            }
            for (Reactions reactionsListReactions : articles.getReactionsList()) {
                Articles oldArticleIdOfReactionsListReactions = reactionsListReactions.getArticleId();
                reactionsListReactions.setArticleId(articles);
                reactionsListReactions = em.merge(reactionsListReactions);
                if (oldArticleIdOfReactionsListReactions != null) {
                    oldArticleIdOfReactionsListReactions.getReactionsList().remove(reactionsListReactions);
                    oldArticleIdOfReactionsListReactions = em.merge(oldArticleIdOfReactionsListReactions);
                }
            }
            for (Comments commentsListComments : articles.getCommentsList()) {
                Articles oldArticleIdOfCommentsListComments = commentsListComments.getArticleId();
                commentsListComments.setArticleId(articles);
                commentsListComments = em.merge(commentsListComments);
                if (oldArticleIdOfCommentsListComments != null) {
                    oldArticleIdOfCommentsListComments.getCommentsList().remove(commentsListComments);
                    oldArticleIdOfCommentsListComments = em.merge(oldArticleIdOfCommentsListComments);
                }
            }
            for (Tag tagListTag : articles.getTagList()) {
                Articles oldArticlesOfTagListTag = tagListTag.getArticles();
                tagListTag.setArticles(articles);
                tagListTag = em.merge(tagListTag);
                if (oldArticlesOfTagListTag != null) {
                    oldArticlesOfTagListTag.getTagList().remove(tagListTag);
                    oldArticlesOfTagListTag = em.merge(oldArticlesOfTagListTag);
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findArticles(articles.getId()) != null) {
                throw new PreexistingEntityException("Articles " + articles + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Articles articles) throws IllegalOrphanException, NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Articles persistentArticles = em.find(Articles.class, articles.getId());
            Users creatorIdOld = persistentArticles.getCreatorId();
            Users creatorIdNew = articles.getCreatorId();
            List<Reactions> reactionsListOld = persistentArticles.getReactionsList();
            List<Reactions> reactionsListNew = articles.getReactionsList();
            List<Comments> commentsListOld = persistentArticles.getCommentsList();
            List<Comments> commentsListNew = articles.getCommentsList();
            List<Tag> tagListOld = persistentArticles.getTagList();
            List<Tag> tagListNew = articles.getTagList();
            List<String> illegalOrphanMessages = null;
            for (Tag tagListOldTag : tagListOld) {
                if (!tagListNew.contains(tagListOldTag)) {
                    if (illegalOrphanMessages == null) {
                        illegalOrphanMessages = new ArrayList<String>();
                    }
                    illegalOrphanMessages.add("You must retain Tag " + tagListOldTag + " since its articles field is not nullable.");
                }
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            if (creatorIdNew != null) {
                creatorIdNew = em.getReference(creatorIdNew.getClass(), creatorIdNew.getId());
                articles.setCreatorId(creatorIdNew);
            }
            List<Reactions> attachedReactionsListNew = new ArrayList<Reactions>();
            for (Reactions reactionsListNewReactionsToAttach : reactionsListNew) {
                reactionsListNewReactionsToAttach = em.getReference(reactionsListNewReactionsToAttach.getClass(), reactionsListNewReactionsToAttach.getReactionsPK());
                attachedReactionsListNew.add(reactionsListNewReactionsToAttach);
            }
            reactionsListNew = attachedReactionsListNew;
            articles.setReactionsList(reactionsListNew);
            List<Comments> attachedCommentsListNew = new ArrayList<Comments>();
            for (Comments commentsListNewCommentsToAttach : commentsListNew) {
                commentsListNewCommentsToAttach = em.getReference(commentsListNewCommentsToAttach.getClass(), commentsListNewCommentsToAttach.getId());
                attachedCommentsListNew.add(commentsListNewCommentsToAttach);
            }
            commentsListNew = attachedCommentsListNew;
            articles.setCommentsList(commentsListNew);
            List<Tag> attachedTagListNew = new ArrayList<Tag>();
            for (Tag tagListNewTagToAttach : tagListNew) {
                tagListNewTagToAttach = em.getReference(tagListNewTagToAttach.getClass(), tagListNewTagToAttach.getTagPK());
                attachedTagListNew.add(tagListNewTagToAttach);
            }
            tagListNew = attachedTagListNew;
            articles.setTagList(tagListNew);
            articles = em.merge(articles);
            if (creatorIdOld != null && !creatorIdOld.equals(creatorIdNew)) {
                creatorIdOld.getArticlesList().remove(articles);
                creatorIdOld = em.merge(creatorIdOld);
            }
            if (creatorIdNew != null && !creatorIdNew.equals(creatorIdOld)) {
                creatorIdNew.getArticlesList().add(articles);
                creatorIdNew = em.merge(creatorIdNew);
            }
            for (Reactions reactionsListOldReactions : reactionsListOld) {
                if (!reactionsListNew.contains(reactionsListOldReactions)) {
                    reactionsListOldReactions.setArticleId(null);
                    reactionsListOldReactions = em.merge(reactionsListOldReactions);
                }
            }
            for (Reactions reactionsListNewReactions : reactionsListNew) {
                if (!reactionsListOld.contains(reactionsListNewReactions)) {
                    Articles oldArticleIdOfReactionsListNewReactions = reactionsListNewReactions.getArticleId();
                    reactionsListNewReactions.setArticleId(articles);
                    reactionsListNewReactions = em.merge(reactionsListNewReactions);
                    if (oldArticleIdOfReactionsListNewReactions != null && !oldArticleIdOfReactionsListNewReactions.equals(articles)) {
                        oldArticleIdOfReactionsListNewReactions.getReactionsList().remove(reactionsListNewReactions);
                        oldArticleIdOfReactionsListNewReactions = em.merge(oldArticleIdOfReactionsListNewReactions);
                    }
                }
            }
            for (Comments commentsListOldComments : commentsListOld) {
                if (!commentsListNew.contains(commentsListOldComments)) {
                    commentsListOldComments.setArticleId(null);
                    commentsListOldComments = em.merge(commentsListOldComments);
                }
            }
            for (Comments commentsListNewComments : commentsListNew) {
                if (!commentsListOld.contains(commentsListNewComments)) {
                    Articles oldArticleIdOfCommentsListNewComments = commentsListNewComments.getArticleId();
                    commentsListNewComments.setArticleId(articles);
                    commentsListNewComments = em.merge(commentsListNewComments);
                    if (oldArticleIdOfCommentsListNewComments != null && !oldArticleIdOfCommentsListNewComments.equals(articles)) {
                        oldArticleIdOfCommentsListNewComments.getCommentsList().remove(commentsListNewComments);
                        oldArticleIdOfCommentsListNewComments = em.merge(oldArticleIdOfCommentsListNewComments);
                    }
                }
            }
            for (Tag tagListNewTag : tagListNew) {
                if (!tagListOld.contains(tagListNewTag)) {
                    Articles oldArticlesOfTagListNewTag = tagListNewTag.getArticles();
                    tagListNewTag.setArticles(articles);
                    tagListNewTag = em.merge(tagListNewTag);
                    if (oldArticlesOfTagListNewTag != null && !oldArticlesOfTagListNewTag.equals(articles)) {
                        oldArticlesOfTagListNewTag.getTagList().remove(tagListNewTag);
                        oldArticlesOfTagListNewTag = em.merge(oldArticlesOfTagListNewTag);
                    }
                }
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = articles.getId();
                if (findArticles(id) == null) {
                    throw new NonexistentEntityException("The articles with id " + id + " no longer exists.");
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
            Articles articles;
            try {
                articles = em.getReference(Articles.class, id);
                articles.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The articles with id " + id + " no longer exists.", enfe);
            }
            List<String> illegalOrphanMessages = null;
            List<Tag> tagListOrphanCheck = articles.getTagList();
            for (Tag tagListOrphanCheckTag : tagListOrphanCheck) {
                if (illegalOrphanMessages == null) {
                    illegalOrphanMessages = new ArrayList<String>();
                }
                illegalOrphanMessages.add("This Articles (" + articles + ") cannot be destroyed since the Tag " + tagListOrphanCheckTag + " in its tagList field has a non-nullable articles field.");
            }
            if (illegalOrphanMessages != null) {
                throw new IllegalOrphanException(illegalOrphanMessages);
            }
            Users creatorId = articles.getCreatorId();
            if (creatorId != null) {
                creatorId.getArticlesList().remove(articles);
                creatorId = em.merge(creatorId);
            }
            List<Reactions> reactionsList = articles.getReactionsList();
            for (Reactions reactionsListReactions : reactionsList) {
                reactionsListReactions.setArticleId(null);
                reactionsListReactions = em.merge(reactionsListReactions);
            }
            List<Comments> commentsList = articles.getCommentsList();
            for (Comments commentsListComments : commentsList) {
                commentsListComments.setArticleId(null);
                commentsListComments = em.merge(commentsListComments);
            }
            em.remove(articles);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Articles> findArticlesEntities() {
        return findArticlesEntities(true, -1, -1);
    }

    public List<Articles> findArticlesEntities(int maxResults, int firstResult) {
        return findArticlesEntities(false, maxResults, firstResult);
    }

    private List<Articles> findArticlesEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Articles.class));
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

    public Articles findArticles(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Articles.class, id);
        } finally {
            em.close();
        }
    }

    public int getArticlesCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Articles> rt = cq.from(Articles.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
