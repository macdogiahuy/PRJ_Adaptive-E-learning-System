package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.persistence.*;
import model.Users;
import model.Courses;
import model.Enrollments;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * Servlet xử lý trang "Khóa học của tôi"
 */
@WebServlet(name = "MyCoursesServlet", urlPatterns = {"/my-courses"})
public class MyCoursesServlet extends HttpServlet {
    
    private static final Logger logger = Logger.getLogger(MyCoursesServlet.class.getName());
    private EntityManagerFactory emf;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            logger.info("Loading courses for user: " + user.getUserName());
            
            // Lấy danh sách các khóa học đã đăng ký của user
            List<CourseEnrollmentInfo> enrolledCourses = getEnrolledCourses(user.getId());
            
            // Lấy thống kê
            CourseStats stats = getCourseStats(user.getId());
            
            // Set attributes cho JSP
            request.setAttribute("enrolledCourses", enrolledCourses);
            request.setAttribute("courseStats", stats);
            request.setAttribute("user", user);
            
            // Kiểm tra có thông báo checkout thành công không
            String checkoutSuccess = request.getParameter("checkout");
            if ("success".equals(checkoutSuccess)) {
                request.setAttribute("showSuccessMessage", true);
                request.setAttribute("successMessage", "Thanh toán thành công! Các khóa học đã được thêm vào tài khoản của bạn.");
            }
            
            logger.info("Found " + enrolledCourses.size() + " enrolled courses for user: " + user.getUserName());
            
            request.getRequestDispatcher("/my-courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error loading my courses", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải danh sách khóa học.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Lấy danh sách khóa học đã đăng ký của user
     */
    private List<CourseEnrollmentInfo> getEnrolledCourses(String userId) {
        EntityManager em = emf.createEntityManager();
        List<CourseEnrollmentInfo> result = new ArrayList<>();
        
        try {
            // Query để lấy thông tin course và enrollment
            String jpql = """
                SELECT c, e FROM Courses c 
                JOIN Enrollments e ON c.id = e.courseId 
                WHERE e.creatorId = :userId 
                ORDER BY e.creationTime DESC
                """;
            
            TypedQuery<Object[]> query = em.createQuery(jpql, Object[].class);
            query.setParameter("userId", userId);
            
            List<Object[]> results = query.getResultList();
            
            for (Object[] row : results) {
                Courses course = (Courses) row[0];
                Enrollments enrollment = (Enrollments) row[1];
                
                CourseEnrollmentInfo info = new CourseEnrollmentInfo();
                info.setCourse(course);
                info.setEnrollment(enrollment);
                info.setProgress(calculateProgress(enrollment));
                
                result.add(info);
            }
            
        } catch (Exception e) {
            logger.log(Level.WARNING, "Error querying enrolled courses, using fallback method", e);
            // Fallback: Query trực tiếp bằng native SQL
            result = getEnrolledCoursesNative(userId);
            
        } finally {
            em.close();
        }
        
        return result;
    }
    
    /**
     * Fallback method sử dụng native SQL
     */
    @SuppressWarnings("unchecked")
    private List<CourseEnrollmentInfo> getEnrolledCoursesNative(String userId) {
        EntityManager em = emf.createEntityManager();
        List<CourseEnrollmentInfo> result = new ArrayList<>();
        
        try {
            // Native SQL query
            String sql = """
                SELECT c.Id, c.Title, c.ThumbUrl, c.Price, c.Level, c.LearnerCount,
                       e.Status, e.CreationTime, e.BillId
                FROM Courses c
                INNER JOIN Enrollments e ON c.Id = e.CourseId
                WHERE e.CreatorId = ?
                ORDER BY e.CreationTime DESC
                """;
            
            Query query = em.createNativeQuery(sql);
            query.setParameter(1, userId);
            
            List<Object[]> results = query.getResultList();
            
            for (Object[] row : results) {
                CourseEnrollmentInfo info = new CourseEnrollmentInfo();
                
                // Tạo course object từ raw data
                Courses course = new Courses();
                course.setId((String) row[0]);
                course.setTitle((String) row[1]);
                course.setThumbUrl((String) row[2]);
                if (row[3] != null) course.setPrice(((Number) row[3]).doubleValue());
                course.setLevel((String) row[4]);
                if (row[5] != null) course.setLearnerCount(((Number) row[5]).intValue());
                
                // Tạo enrollment object từ raw data
                Enrollments enrollment = new Enrollments();
                enrollment.setStatus((String) row[6]);
                enrollment.setCreationTime((java.util.Date) row[7]);
                // Note: BillId is Bills object, not String - will handle separately if needed
                
                info.setCourse(course);
                info.setEnrollment(enrollment);
                info.setProgress(0); // Default progress
                
                result.add(info);
            }
            
            logger.info("Fallback method loaded " + result.size() + " courses");
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in fallback method", e);
        } finally {
            em.close();
        }
        
        return result;
    }
    
    /**
     * Tính progress của course (placeholder logic)
     */
    private int calculateProgress(Enrollments enrollment) {
        // TODO: Implement actual progress calculation based on milestones
        // For now, return random progress between 0-100
        return (int) (Math.random() * 100);
    }
    
    /**
     * Lấy thống kê khóa học của user
     */
    private CourseStats getCourseStats(String userId) {
        EntityManager em = emf.createEntityManager();
        CourseStats stats = new CourseStats();
        
        try {
            // Count total enrollments
            String countSql = "SELECT COUNT(*) FROM Enrollments WHERE CreatorId = ?";
            Query countQuery = em.createNativeQuery(countSql);
            countQuery.setParameter(1, userId);
            
            Number count = (Number) countQuery.getSingleResult();
            stats.setTotalCourses(count.intValue());
            
            // Count completed courses (placeholder logic)
            stats.setCompletedCourses((int) (count.intValue() * 0.3)); // 30% completed
            stats.setInProgressCourses(count.intValue() - stats.getCompletedCourses());
            
            // Calculate total learning hours (placeholder)
            stats.setTotalHours(count.intValue() * 10); // 10 hours per course average
            
        } catch (Exception e) {
            logger.log(Level.WARNING, "Error calculating course stats", e);
            // Default stats
            stats.setTotalCourses(0);
            stats.setCompletedCourses(0);
            stats.setInProgressCourses(0);
            stats.setTotalHours(0);
        } finally {
            em.close();
        }
        
        return stats;
    }
    
    @Override
    public void destroy() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
    
    /**
     * Class chứa thông tin course và enrollment
     */
    public static class CourseEnrollmentInfo {
        private Courses course;
        private Enrollments enrollment;
        private int progress;
        
        // Getters and setters
        public Courses getCourse() { return course; }
        public void setCourse(Courses course) { this.course = course; }
        
        public Enrollments getEnrollment() { return enrollment; }
        public void setEnrollment(Enrollments enrollment) { this.enrollment = enrollment; }
        
        public int getProgress() { return progress; }
        public void setProgress(int progress) { this.progress = progress; }
    }
    
    /**
     * Class chứa thống kê khóa học
     */
    public static class CourseStats {
        private int totalCourses;
        private int completedCourses;
        private int inProgressCourses;
        private int totalHours;
        
        // Getters and setters
        public int getTotalCourses() { return totalCourses; }
        public void setTotalCourses(int totalCourses) { this.totalCourses = totalCourses; }
        
        public int getCompletedCourses() { return completedCourses; }
        public void setCompletedCourses(int completedCourses) { this.completedCourses = completedCourses; }
        
        public int getInProgressCourses() { return inProgressCourses; }
        public void setInProgressCourses(int inProgressCourses) { this.inProgressCourses = inProgressCourses; }
        
        public int getTotalHours() { return totalHours; }
        public void setTotalHours(int totalHours) { this.totalHours = totalHours; }
    }
}