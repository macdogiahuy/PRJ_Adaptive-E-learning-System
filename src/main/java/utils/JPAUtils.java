package utils; // Hoặc package của bạn

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JPAUtils {

    private static EntityManagerFactory emf;

    static {
        try {
            emf = Persistence.createEntityManagerFactory("CourseHubPU");
        } catch (Exception e) {
            System.err.println("Không thể khởi tạo EntityManagerFactory!");
            e.printStackTrace();
            throw new RuntimeException("Lỗi khởi tạo JPAUtils", e);
        }
    }

    public static EntityManager getEntityManager() {
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory chưa được khởi tạo.");
        }
        return emf.createEntityManager();
    }

    public static void shutdown() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}