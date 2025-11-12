package utils;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JPAUtils {
    private static EntityManagerFactory emf;

    static {
        try {
            System.out.println("[JPA] Initializing EntityManagerFactory (EclipseLink)...");
            emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU");
            System.out.println("[JPA] EntityManagerFactory initialized successfully!");
        } catch (Exception e) {
            System.err.println("[JPA] Failed to initialize EntityManagerFactory!");
            e.printStackTrace();
            throw new RuntimeException("Error initializing JPAUtils", e);
        }
    }

    public static EntityManager getEntityManager() {
        if (emf == null || !emf.isOpen()) {
            throw new IllegalStateException("EntityManagerFactory not initialized.");
        }
        return emf.createEntityManager();
    }

    public static void shutdown() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
