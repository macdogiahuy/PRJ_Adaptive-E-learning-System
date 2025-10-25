/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import java.io.Serializable;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Users;

/**
 * Minimal JPA controller for Users entity: find and edit (merge) operations.
 */
public class UsersJpaController implements Serializable {

	private EntityManagerFactory emf = null;

	public UsersJpaController() {
		// create factory using persistence.xml unit name
		this.emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU");
	}

	public EntityManager getEntityManager() {
		return emf.createEntityManager();
	}

	public Users findUsers(String id) {
		EntityManager em = getEntityManager();
		try {
			return em.find(Users.class, id);
		} finally {
			em.close();
		}
	}

	public void edit(Users users) throws Exception {
		EntityManager em = null;
		try {
			em = getEntityManager();
			em.getTransaction().begin();
			em.merge(users);
			em.getTransaction().commit();
		} catch (Exception ex) {
			if (em != null && em.getTransaction().isActive()) em.getTransaction().rollback();
			Logger.getLogger(UsersJpaController.class.getName()).log(Level.SEVERE, null, ex);
			throw ex;
		} finally {
			if (em != null) em.close();
		}
	}
}