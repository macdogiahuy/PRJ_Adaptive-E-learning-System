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
import model.Categories;

/**
 * JPA Controller for Categories entity
=======
/**
 *
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
 * @author LP
 */
public class CategoriesJpaController {
    
<<<<<<< HEAD
    private EntityManagerFactory emf = null;
    
    public CategoriesJpaController() {
        this.emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU");
    }
    
    public CategoriesJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    
    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    
    /**
     * Create a new category
     */
    public void create(Categories category) throws PreexistingEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(category);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findCategory(category.getId()) != null) {
                throw new PreexistingEntityException("Category " + category + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Update an existing category
     */
    public void edit(Categories category) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            category = em.merge(category);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = category.getId();
                if (findCategory(id) == null) {
                    throw new NonexistentEntityException("The category with id " + id + " no longer exists.");
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
     * Delete a category
     */
    public void destroy(String id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Categories category;
            try {
                category = em.getReference(Categories.class, id);
                category.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The category with id " + id + " no longer exists.", enfe);
            }
            em.remove(category);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Find all categories
     */
    public List<Categories> findCategoriesEntities() {
        return findCategoriesEntities(true, -1, -1);
    }
    
    /**
     * Find categories with pagination
     */
    public List<Categories> findCategoriesEntities(int maxResults, int firstResult) {
        return findCategoriesEntities(false, maxResults, firstResult);
    }
    
    private List<Categories> findCategoriesEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Categories.class));
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
     * Find category by ID
     */
    public Categories findCategory(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Categories.class, id);
        } finally {
            em.close();
        }
    }
    
    /**
     * Get total count of categories
     */
    public int getCategoriesCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Categories> rt = cq.from(Categories.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
    /**
     * Find categories by name
     */
    public List<Categories> findByName(String name) {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT c FROM Categories c WHERE c.name LIKE :name");
            query.setParameter("name", "%" + name + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    /**
     * Find active categories
     */
    public List<Categories> findActiveCategories() {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createQuery("SELECT c FROM Categories c WHERE c.isActive = true ORDER BY c.name");
            return query.getResultList();
        } finally {
            em.close();
        }
    }
=======
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
}
