package controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import model.Bills;
import java.util.logging.Logger;

/**
 * JPA Controller for Bills entity
 * @author LP
 */
public class BillsJpaController {
    
    private static final Logger LOGGER = Logger.getLogger(BillsJpaController.class.getName());
    private EntityManagerFactory emf;
    
    public BillsJpaController() {
        this.emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU");
    }
    
    public BillsJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }
    
    /**
     * Create a new bill
     * @param bill Bill to create
     * @throws Exception if creation fails
     */
    public void create(Bills bill) throws Exception {
        EntityManager em = null;
        try {
            em = emf.createEntityManager();
            em.getTransaction().begin();
            em.persist(bill);
            em.getTransaction().commit();
            LOGGER.info("Bill created successfully: " + bill.getId());
        } catch (Exception ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            LOGGER.severe("Error creating bill: " + ex.getMessage());
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Find bill by ID
     * @param id Bill ID
     * @return Bills entity or null if not found
     */
    public Bills findBill(String id) {
        EntityManager em = null;
        try {
            em = emf.createEntityManager();
            return em.find(Bills.class, id);
        } catch (Exception ex) {
            LOGGER.severe("Error finding bill: " + ex.getMessage());
            return null;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Update an existing bill
     * @param bill Bill to update
     * @throws Exception if update fails
     */
    public void edit(Bills bill) throws Exception {
        EntityManager em = null;
        try {
            em = emf.createEntityManager();
            em.getTransaction().begin();
            em.merge(bill);
            em.getTransaction().commit();
            LOGGER.info("Bill updated successfully: " + bill.getId());
        } catch (Exception ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            LOGGER.severe("Error updating bill: " + ex.getMessage());
            throw ex;
        } finally {
            if (em != null) {
                em.close();
            }
        }
    }
    
    /**
     * Close the EntityManagerFactory
     */
    public void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
