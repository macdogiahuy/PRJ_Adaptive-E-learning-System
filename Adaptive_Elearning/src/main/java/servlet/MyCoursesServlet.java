package servlet;

import dao.CompletionDAO;
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
    private CompletionDAO completionDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.emf = Persistence.createEntityManagerFactory("Adaptive_ElearningPU");
        this.completionDAO = new CompletionDAO();
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
            logger.info("=== MY COURSES SERVLET START ===");
            logger.info("Loading courses for user: " + user.getUserName());
            logger.info("User ID from session: " + user.getId());
            logger.info("User ID type: " + (user.getId() != null ? user.getId().getClass().getName() : "null"));

            // Lấy danh sách các khóa học đã đăng ký của user
            List<CourseEnrollmentInfo> enrolledCourses = getEnrolledCourses(user.getId());

            logger.info("Calculating real progress for " + enrolledCourses.size() + " courses...");
            for (CourseEnrollmentInfo info : enrolledCourses) {
                String courseId = info.getCourse().getId();

                // 1. Lấy tổng số mục (Lectures + Assignments)
                int totalItems = completionDAO.getTotalCompletableItems(courseId);

                // 2. Lấy số mục đã hoàn thành (từ các hàm đã có trong DAO)
                int completedLectures = completionDAO.getCompletedLectureIds(user.getId(), courseId).size();
                int completedAssignments = completionDAO.getCompletedAssignmentIds(user.getId(), courseId).size();
                int completedItems = completedLectures + completedAssignments;

                // 3. Tính toán % (tránh lỗi chia cho 0)
                int progress = 0;
                if (totalItems > 0) {
                    progress = (int) Math.round(((double) completedItems / totalItems) * 100);
                }

                // 4. Cập nhật tiến độ vào đối tượng 'info'
                info.setProgress(progress);
                logger.info("  Course: " + info.getCourse().getTitle() + " - Progress: " + progress + "% (" + completedItems + "/" + totalItems + ")");
            }

            // Lấy thống kê
           CourseStats stats = getCourseStats(user.getId(), enrolledCourses);
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
            logger.info("=== GET ENROLLED COURSES START ===");
            logger.info("Querying enrolled courses for user: " + userId);

            // Sử dụng native SQL để đảm bảo query hoạt động đúng
            result = getEnrolledCoursesNative(userId);

            logger.info("=== GET ENROLLED COURSES END ===");
            logger.info("Found " + result.size() + " enrolled courses");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "ERROR in getEnrolledCourses: " + e.getMessage(), e);
            e.printStackTrace();

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
            logger.info("=== NATIVE QUERY FOR ENROLLMENTS ===");
            logger.info("User ID: " + userId);

            // Native SQL query với positional parameter
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

            logger.info("Query returned " + results.size() + " rows");

            for (Object[] row : results) {
                try {
                    CourseEnrollmentInfo info = new CourseEnrollmentInfo();

                    // Tạo course object từ raw data
                    Courses course = new Courses();
                    course.setId(row[0] != null ? row[0].toString() : null);
                    course.setTitle(row[1] != null ? row[1].toString() : "Untitled Course");
                    course.setThumbUrl(row[2] != null ? row[2].toString() : null);

                    if (row[3] != null) {
                        course.setPrice(((Number) row[3]).doubleValue());
                    }

                    course.setLevel(row[4] != null ? row[4].toString() : "Beginner");

                    if (row[5] != null) {
                        course.setLearnerCount(((Number) row[5]).intValue());
                    }

                    // Tạo enrollment object từ raw data
                    Enrollments enrollment = new Enrollments();
                    enrollment.setStatus(row[6] != null ? row[6].toString() : "ACTIVE");

                    if (row[7] != null) {
                        if (row[7] instanceof java.sql.Timestamp) {
                            enrollment.setCreationTime(new java.util.Date(((java.sql.Timestamp) row[7]).getTime()));
                        } else if (row[7] instanceof java.util.Date) {
                            enrollment.setCreationTime((java.util.Date) row[7]);
                        }
                    }

                    info.setCourse(course);
                    info.setEnrollment(enrollment);

                    result.add(info);

                    logger.info("Added course: " + course.getTitle() + " - Status: " + enrollment.getStatus());

                } catch (Exception rowError) {
                    logger.log(Level.WARNING, "Error processing row", rowError);
                }
            }

            logger.info("Successfully processed " + result.size() + " enrollments");

        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in native query", e);
            e.printStackTrace();
        } finally {
            em.close();
        }

        return result;
    }

    /**
     * Lấy thống kê khóa học của user
     */
    private CourseStats getCourseStats(String userId, List<CourseEnrollmentInfo> enrolledCourses) {
        CourseStats stats = new CourseStats();
        try {
            int total = enrolledCourses.size();
            int completed = 0;

            // Đếm số khóa học đã hoàn thành (100%)
            for (CourseEnrollmentInfo info : enrolledCourses) {
                if (info.getProgress() == 100) {
                    completed++;
                }
            }

            stats.setTotalCourses(total);
            stats.setCompletedCourses(completed);
            stats.setInProgressCourses(total - completed);

            stats.setTotalHours(total * 10);

        } catch (Exception e) {
            logger.log(Level.WARNING, "Error calculating course stats", e);
            // Default stats
            stats.setTotalCourses(0);
            stats.setCompletedCourses(0);
            stats.setInProgressCourses(0);
            stats.setTotalHours(0);
        } finally {
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
        public Courses getCourse() {
            return course;
        }

        public void setCourse(Courses course) {
            this.course = course;
        }

        public Enrollments getEnrollment() {
            return enrollment;
        }

        public void setEnrollment(Enrollments enrollment) {
            this.enrollment = enrollment;
        }

        public int getProgress() {
            return progress;
        }

        public void setProgress(int progress) {
            this.progress = progress;
        }
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
        public int getTotalCourses() {
            return totalCourses;
        }

        public void setTotalCourses(int totalCourses) {
            this.totalCourses = totalCourses;
        }

        public int getCompletedCourses() {
            return completedCourses;
        }

        public void setCompletedCourses(int completedCourses) {
            this.completedCourses = completedCourses;
        }

        public int getInProgressCourses() {
            return inProgressCourses;
        }

        public void setInProgressCourses(int inProgressCourses) {
            this.inProgressCourses = inProgressCourses;
        }

        public int getTotalHours() {
            return totalHours;
        }

        public void setTotalHours(int totalHours) {
            this.totalHours = totalHours;
        }
    }
}
