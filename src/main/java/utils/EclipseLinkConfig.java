package utils;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.eclipse.persistence.config.PersistenceUnitProperties;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 * Runtime configuration for EclipseLink JPA to bypass SSL certificate
 * validation on local SQL Server.
 * This is ONLY for development. For production, use proper certificate
 * validation.
 */
public class EclipseLinkConfig {
    private static final Logger LOGGER = Logger.getLogger(EclipseLinkConfig.class.getName());
    private static EntityManagerFactory emf = null;

    /**
     * Get or create a configured EntityManagerFactory with SSL bypass for local
     * dev.
     * Override the persistence.xml settings at runtime to use
     * trustServerCertificate=true.
     */
    public static synchronized EntityManagerFactory getEntityManagerFactory() {
        if (emf == null) {
            try {
                // Load default persistence unit from persistence.xml
                Map<String, Object> properties = new HashMap<>();

                // Override JDBC URL to use explicit TCP port to avoid named-instance resolution
                String devDbUrl = "jdbc:sqlserver://localhost:1433;databaseName=CourseHubDB;encrypt=true;trustServerCertificate=true;";
                properties.put(PersistenceUnitProperties.JDBC_URL, devDbUrl);
                properties.put(PersistenceUnitProperties.JDBC_USER, "sa");
                properties.put(PersistenceUnitProperties.JDBC_PASSWORD, "123456");
                properties.put(PersistenceUnitProperties.JDBC_DRIVER, "com.microsoft.sqlserver.jdbc.SQLServerDriver");

                // Tell EclipseLink to use these properties
                properties.put("eclipselink.logging.level", "INFO");
                properties.put("eclipselink.logging.level.sql", "FINE");

                // Create EMF with overrides
                emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU", properties);
                LOGGER.log(Level.INFO,
                        "✅ EntityManagerFactory created for SQL Server at localhost:1433 with trustServerCertificate=true");

            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "❌ Error creating EntityManagerFactory: " + e.getMessage(), e);
                throw new RuntimeException("Failed to initialize EntityManagerFactory", e);
            }
        }
        return emf;
    }

    /**
     * Create a new EntityManager from the configured factory.
     */
    public static EntityManager createEntityManager() {
        return getEntityManagerFactory().createEntityManager();
    }

    /**
     * Close the EntityManagerFactory (call this on app shutdown).
     */
    public static void closeFactory() {
        if (emf != null && emf.isOpen()) {
            emf.close();
            emf = null;
            LOGGER.log(Level.INFO, "EntityManagerFactory closed");
        }
    }
}
