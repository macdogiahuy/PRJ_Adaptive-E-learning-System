package utils;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class StartupListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== APPLICATION STARTUP ===");
        System.out.println("Context initialized successfully");
        System.out.println("Jakarta EE namespace working correctly");
        
        try {
            // Test database connection
            System.out.println("Testing database connection...");
            // Add your DB test here if needed
            System.out.println("Application ready!");
        } catch (Exception e) {
            System.err.println("ERROR during startup: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== APPLICATION SHUTDOWN ===");
    }
}