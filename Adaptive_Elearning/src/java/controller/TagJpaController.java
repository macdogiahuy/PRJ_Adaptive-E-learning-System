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
import model.Tag;
import model.TagPK;

/**
 *
 * @author LP
 */
public class TagJpaController implements Serializable {

    public TagJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    private EntityManagerFactory emf = null;

    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    public void create(Tag tag) throws PreexistingEntityException, Exception {
        if (tag.getTagPK() == null) {
            tag.setTagPK(new TagPK());
        }
        tag.getTagPK().setArticleId(tag.getArticles().getId());
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Articles articles = tag.getArticles();
            if (articles != null) {
                articles = em.getReference(articles.getClass(), articles.getId());
                tag.setArticles(articles);
            }
            em.persist(tag);
            if (articles != null) {
                articles.getTagList().add(tag);
                articles = em.merge(articles);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findTag(tag.getTagPK()) != null) {
                throw new PreexistingEntityException("Tag " + tag + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void edit(Tag tag) throws NonexistentEntityException, Exception {
        tag.getTagPK().setArticleId(tag.getArticles().getId());
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Tag persistentTag = em.find(Tag.class, tag.getTagPK());
            Articles articlesOld = persistentTag.getArticles();
            Articles articlesNew = tag.getArticles();
            if (articlesNew != null) {
                articlesNew = em.getReference(articlesNew.getClass(), articlesNew.getId());
                tag.setArticles(articlesNew);
            }
            tag = em.merge(tag);
            if (articlesOld != null && !articlesOld.equals(articlesNew)) {
                articlesOld.getTagList().remove(tag);
                articlesOld = em.merge(articlesOld);
            }
            if (articlesNew != null && !articlesNew.equals(articlesOld)) {
                articlesNew.getTagList().add(tag);
                articlesNew = em.merge(articlesNew);
            }
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                TagPK id = tag.getTagPK();
                if (findTag(id) == null) {
                    throw new NonexistentEntityException("The tag with id " + id + " no longer exists.");
                }
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public void destroy(TagPK id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Tag tag;
            try {
                tag = em.getReference(Tag.class, id);
                tag.getTagPK();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The tag with id " + id + " no longer exists.", enfe);
            }
            Articles articles = tag.getArticles();
            if (articles != null) {
                articles.getTagList().remove(tag);
                articles = em.merge(articles);
            }
            em.remove(tag);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }

    public List<Tag> findTagEntities() {
        return findTagEntities(true, -1, -1);
    }

    public List<Tag> findTagEntities(int maxResults, int firstResult) {
        return findTagEntities(false, maxResults, firstResult);
    }

    private List<Tag> findTagEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Tag.class));
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

    public Tag findTag(TagPK id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Tag.class, id);
        } finally {
            em.close();
        }
    }

    public int getTagCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Tag> rt = cq.from(Tag.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
}
