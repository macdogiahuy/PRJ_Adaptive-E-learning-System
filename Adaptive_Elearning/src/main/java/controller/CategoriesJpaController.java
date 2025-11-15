/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Query;
import java.util.List;
import model.Categories;

/**
 *
 * @author LP
 */
public class CategoriesJpaController {
    
    private EntityManagerFactory emf;
    
    public CategoriesJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    
    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    
    public Categories findCategories(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Categories.class, id);
        } finally {
            em.close();
        }
    }
    
    public List<Categories> findCategoriesEntities() {
        return findCategoriesEntities(true, -1, -1);
    }
    
    public List<Categories> findCategoriesEntities(int maxResults, int firstResult) {
        return findCategoriesEntities(false, maxResults, firstResult);
    }
    
    private List<Categories> findCategoriesEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            Query q = em.createQuery("SELECT c FROM Categories c ORDER BY c.title");
            if (!all) {
                q.setMaxResults(maxResults);
                q.setFirstResult(firstResult);
            }
            return q.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Categories> findLeafCategories() {
        EntityManager em = getEntityManager();
        try {
            Query q = em.createQuery("SELECT c FROM Categories c WHERE c.isLeaf = true ORDER BY c.title");
            return q.getResultList();
        } finally {
            em.close();
        }
    }
}
