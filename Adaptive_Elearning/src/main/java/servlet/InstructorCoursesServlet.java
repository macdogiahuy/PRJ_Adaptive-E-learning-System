package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

/**
 * Servlet hiển thị danh sách khóa học của instructor
 */
@WebServlet(name = "InstructorCoursesServlet", urlPatterns = {"/instructor-courses"})
public class InstructorCoursesServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(InstructorCoursesServlet.class.getName());
    private EntityManagerFactory emf;
    
    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU");
    }
    
    @Override
    public void destroy() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("account");
        
        // Check if user is logged in and is an instructor
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (!"Instructor".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        logger.info("=== INSTRUCTOR COURSES SERVLET ===");
        logger.info("Loading courses for instructor: " + user.getUserName());
        logger.info("Instructor ID: " + user.getId());
        
        try {
            // Get all courses created by this instructor
            List<CourseInfo> courses = getInstructorCourses(user.getId());
            
            // Get statistics
            int totalCourses = courses.size();
            int activeCourses = (int) courses.stream().filter(c -> "Active".equalsIgnoreCase(c.status)).count();
            int draftCourses = (int) courses.stream().filter(c -> "Draft".equalsIgnoreCase(c.status)).count();
            int totalStudents = courses.stream().mapToInt(c -> c.learnerCount).sum();
            
            // Set attributes
            request.setAttribute("courses", courses);
            request.setAttribute("totalCourses", totalCourses);
            request.setAttribute("activeCourses", activeCourses);
            request.setAttribute("draftCourses", draftCourses);
            request.setAttribute("totalStudents", totalStudents);
            
            logger.info("Found " + totalCourses + " courses for instructor");
            logger.info("Active: " + activeCourses + ", Draft: " + draftCourses);
            
            // Forward to JSP
            request.getRequestDispatcher("/manage_courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.severe("Error loading instructor courses: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải danh sách khóa học: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Lấy danh sách khóa học của instructor từ database
     */
    private List<CourseInfo> getInstructorCourses(String instructorId) {
        EntityManager em = emf.createEntityManager();
        List<CourseInfo> result = new ArrayList<>();
        
        try {
            logger.info("=== QUERYING INSTRUCTOR COURSES ===");
            logger.info("Instructor ID: " + instructorId);
            
            // First, let's check total courses in database
            Query countQuery = em.createNativeQuery("SELECT COUNT(*) FROM Courses");
            Object countResult = countQuery.getSingleResult();
            logger.info("Total courses in database: " + countResult);
            
            // Check courses with this creator
            Query creatorCountQuery = em.createNativeQuery("SELECT COUNT(*) FROM Courses WHERE CreatorId = ?");
            creatorCountQuery.setParameter(1, instructorId);
            Object creatorCount = creatorCountQuery.getSingleResult();
            logger.info("Courses with CreatorId = " + instructorId + ": " + creatorCount);
            
            String sql = """
                SELECT 
                    c.Id,
                    c.Title,
                    c.ThumbUrl,
                    c.Price,
                    c.Level,
                    c.LearnerCount,
                    c.Status,
                    c.CreationTime,
                    c.LastModificationTime,
                    CAST(c.TotalRating AS FLOAT) / NULLIF(c.RatingCount, 0) as Rating,
                    c.RatingCount,
                    c.Discount,
                    c.DiscountExpiry,
                    cat.Title as CategoryTitle
                FROM Courses c
                LEFT JOIN Categories cat ON c.LeafCategoryId = cat.Id
                WHERE c.CreatorId = ?
                ORDER BY c.CreationTime DESC
                """;
            
            Query query = em.createNativeQuery(sql);
            query.setParameter(1, instructorId);
            
            List<Object[]> results = query.getResultList();
            logger.info("Query returned " + results.size() + " courses");
            
            for (Object[] row : results) {
                try {
                    CourseInfo info = new CourseInfo();
                    info.id = row[0] != null ? row[0].toString() : null;
                    info.title = row[1] != null ? row[1].toString() : "Untitled Course";
                    info.thumbUrl = row[2] != null ? row[2].toString() : null;
                    info.price = row[3] != null ? ((Number) row[3]).doubleValue() : 0.0;
                    info.level = row[4] != null ? row[4].toString() : "Beginner";
                    info.learnerCount = row[5] != null ? ((Number) row[5]).intValue() : 0;
                    info.status = row[6] != null ? row[6].toString() : "Draft";
                    info.creationTime = row[7] != null ? row[7].toString() : "";
                    info.lastModificationTime = row[8] != null ? row[8].toString() : "";
                    info.rating = row[9] != null ? ((Number) row[9]).doubleValue() : 0.0;
                    info.reviewCount = row[10] != null ? ((Number) row[10]).intValue() : 0;
                    info.discount = row[11] != null ? ((Number) row[11]).doubleValue() : 0.0;
                    info.discountExpiry = row[12] != null ? row[12].toString() : null;
                    info.categoryTitle = row[13] != null ? row[13].toString() : "Uncategorized";
                    
                    result.add(info);
                    logger.info("Added course: " + info.title + " (Status: " + info.status + ")");
                    
                } catch (Exception e) {
                    logger.warning("Error processing course row: " + e.getMessage());
                }
            }
            
            logger.info("Successfully processed " + result.size() + " courses");
            
        } catch (Exception e) {
            logger.severe("Error querying instructor courses: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
        
        return result;
    }
    
    /**
     * DTO class for course information
     */
    public static class CourseInfo {
        public String id;
        public String title;
        public String thumbUrl;
        public double price;
        public String level;
        public int learnerCount;
        public String status;
        public String creationTime;
        public String lastModificationTime;
        public double rating;
        public int reviewCount;
        public double discount;
        public String discountExpiry;
        public String categoryTitle;
        
        // Getters
        public String getId() { return id; }
        public String getTitle() { return title; }
        public String getThumbUrl() { return thumbUrl; }
        public double getPrice() { return price; }
        public String getLevel() { return level; }
        public int getLearnerCount() { return learnerCount; }
        public String getStatus() { return status; }
        public String getCreationTime() { return creationTime; }
        public String getLastModificationTime() { return lastModificationTime; }
        public double getRating() { return rating; }
        public int getReviewCount() { return reviewCount; }
        public double getDiscount() { return discount; }
        public String getDiscountExpiry() { return discountExpiry; }
        public String getCategoryTitle() { return categoryTitle; }
    }
}
