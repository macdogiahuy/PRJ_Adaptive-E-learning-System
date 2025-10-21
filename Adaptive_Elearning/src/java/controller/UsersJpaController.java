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
import model.Users;

/**
 * JPA Controller for Users entity
=======
/**
 *
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
 * @author LP
 */
public class UsersJpaController {
    
<<<<<<< HEAD
    private EntityManagerFactory emf = null;
    
    public UsersJpaController() {
        this.emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU");
    }
    
    public UsersJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    
    public EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    
    /**
     * Create a new user
     */
    public void create(Users user) throws PreexistingEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (findUser(user.getId()) != null) {
                throw new PreexistingEntityException("User " + user + " already exists.", ex);
            }
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Update an existing user
     */
    public void edit(Users user) throws NonexistentEntityException, Exception {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            user = em.merge(user);
            em.getTransaction().commit();
        } catch (Exception ex) {
            String msg = ex.getLocalizedMessage();
            if (msg == null || msg.length() == 0) {
                String id = user.getId();
                if (findUser(id) == null) {
                    throw new NonexistentEntityException("The user with id " + id + " no longer exists.");
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
     * Delete a user
     */
    public void destroy(String id) throws NonexistentEntityException {
        EntityManager em = null;
        try {
            em = getEntityManager();
            em.getTransaction().begin();
            Users user;
            try {
                user = em.getReference(Users.class, id);
                user.getId();
            } catch (EntityNotFoundException enfe) {
                throw new NonexistentEntityException("The user with id " + id + " no longer exists.", enfe);
            }
            em.remove(user);
            em.getTransaction().commit();
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Find all users
     */
    public List<Users> findUsersEntities() {
        return findUsersEntities(true, -1, -1);
    }
    
    /**
     * Find users with pagination
     */
    public List<Users> findUsersEntities(int maxResults, int firstResult) {
        return findUsersEntities(false, maxResults, firstResult);
    }
    
    private List<Users> findUsersEntities(boolean all, int maxResults, int firstResult) {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            cq.select(cq.from(Users.class));
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
     * Find user by ID
     */
    public Users findUser(String id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Users.class, id);
        } finally {
            em.close();
        }
    }
    
    /**
     * Get total count of users
     */
    public int getUsersCount() {
        EntityManager em = getEntityManager();
        try {
            CriteriaQuery cq = em.getCriteriaBuilder().createQuery();
            Root<Users> rt = cq.from(Users.class);
            cq.select(em.getCriteriaBuilder().count(rt));
            Query q = em.createQuery(cq);
            return ((Long) q.getSingleResult()).intValue();
        } finally {
            em.close();
        }
    }
    
    /**
     * Find user by username
     */
    public Users findByUsername(String username) {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createNamedQuery("Users.findByUserName");
            query.setParameter("userName", username);
            List<Users> results = query.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } finally {
            em.close();
        }
    }
    
    /**
     * Find user by email
     */
    public Users findByEmail(String email) {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createNamedQuery("Users.findByEmail");
            query.setParameter("email", email);
            List<Users> results = query.getResultList();
            return results.isEmpty() ? null : results.get(0);
        } finally {
            em.close();
        }
    }
    
    /**
     * Find users by role
     */
    public List<Users> findByRole(String role) {
        EntityManager em = getEntityManager();
        try {
            Query query = em.createNamedQuery("Users.findByRole");
            query.setParameter("role", role);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
=======
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5
}
