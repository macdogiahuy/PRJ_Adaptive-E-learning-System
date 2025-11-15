package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import dao.CompletionDAO;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.Query;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Courses;
import model.Enrollments;
import model.Users;

/**
 * Servlet xử lý trang "Khóa học của tôi"
 */
@WebServlet(name = "MyCoursesServlet", urlPatterns = { "/my-courses" })
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
                logger.info("  Course: " + info.getCourse().getTitle() + " - Progress: " + progress + "% ("
                        + completedItems + "/" + totalItems + ")");
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
                request.setAttribute("successMessage",
                        "Thanh toán thành công! Các khóa học đã được thêm vào tài khoản của bạn.");
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
            // Log user id type/length safely
            logger.info("User ID Type: " + (userId != null ? userId.getClass().getName() : "null"));
            logger.info("User ID Length: " + (userId != null ? Integer.toString(userId.length()) : "0"));

            // Native SQL query với positional parameter (CAST used for type matching)
            String sql = """
                    SELECT c.Id, c.Title, c.ThumbUrl, c.Price, c.Level, c.LearnerCount,
                           e.Status, e.CreationTime, e.BillId
                    FROM Courses c
                    INNER JOIN Enrollments e ON c.Id = e.CourseId
                    WHERE CAST(e.CreatorId AS VARCHAR(36)) = ?
                    ORDER BY e.CreationTime DESC
                    """;

            Query query = em.createNativeQuery(sql);
            query.setParameter(1, userId);

            List<Object[]> results = query.getResultList();

            logger.info("Query returned " + results.size() + " rows");

            // Debug: Log actual enrollments in database (helps diagnose discrepancies)
            try {
                String debugSql = "SELECT COUNT(*) FROM Enrollments WHERE CAST(CreatorId AS VARCHAR(36)) = ?";
                Query debugQuery = em.createNativeQuery(debugSql);
                debugQuery.setParameter(1, userId);
                Object debugCount = debugQuery.getSingleResult();
                logger.info("Total enrollments in DB for this user: " + debugCount);
            } catch (Exception dbgEx) {
                logger.log(Level.FINE, "Debug enrollment count failed: " + dbgEx.getMessage(), dbgEx);
            }
            for (Object[] row : results) {
                try {
                    logger.info("=== Processing row ===");
                    logger.info("Row data: ID=" + row[0] + ", Title=" + row[1]);

                    // Validate required fields
                    if (row[0] == null || row[1] == null) {
                        logger.severe("❌ SKIPPING: Missing required fields (ID or Title is NULL)");
                        continue;
                    }

                    CourseEnrollmentInfo info = new CourseEnrollmentInfo();

                    // Tạo course object từ raw data với NULL safety
                    Courses course = new Courses();
                    course.setId(row[0] != null ? row[0].toString() : null);
                    course.setTitle(row[1] != null ? row[1].toString() : "Untitled Course");

                    // ThumbUrl - NULL safe with default fallback
                    course.setThumbUrl(row[2] != null ? row[2].toString()
                            : "/Adaptive_Elearning/assets/images/default-course.jpg");

                    // Price - NULL safe with default 0
                    if (row[3] != null) {
                        try {
                            course.setPrice(((Number) row[3]).doubleValue());
                        } catch (Exception e) {
                            logger.warning("Price conversion failed, using 0: " + e.getMessage());
                            course.setPrice(0.0);
                        }
                    } else {
                        course.setPrice(0.0);
                    }

                    // Level - NULL safe with default
                    course.setLevel(row[4] != null ? row[4].toString() : "Beginner");

                    // LearnerCount - NULL safe with default 0
                    if (row[5] != null) {
                        try {
                            course.setLearnerCount(((Number) row[5]).intValue());
                        } catch (Exception e) {
                            logger.warning("LearnerCount conversion failed, using 0: " + e.getMessage());
                            course.setLearnerCount(0);
                        }
                    } else {
                        course.setLearnerCount(0);
                    }

                    // Tạo enrollment object từ raw data với NULL safety
                    Enrollments enrollment = new Enrollments();
                    enrollment.setStatus(row[6] != null ? row[6].toString() : "ACTIVE");

                    // CreationTime - NULL safe
                    if (row[7] != null) {
                        try {
                            if (row[7] instanceof java.sql.Timestamp) {
                                enrollment.setCreationTime(new java.util.Date(((java.sql.Timestamp) row[7]).getTime()));
                            } else if (row[7] instanceof java.util.Date) {
                                enrollment.setCreationTime((java.util.Date) row[7]);
                            }
                        } catch (Exception e) {
                            logger.warning("CreationTime conversion failed: " + e.getMessage());
                            enrollment.setCreationTime(new java.util.Date()); // Use current date as fallback
                        }
                    } else {
                        enrollment.setCreationTime(new java.util.Date());
                    }

                    info.setCourse(course);
                    info.setEnrollment(enrollment);

                    result.add(info);

                    logger.info("✓ Successfully added course: " + course.getTitle() + " - Status: "
                            + enrollment.getStatus());

                } catch (Exception rowError) {
                    logger.log(Level.SEVERE, "❌ ERROR processing row - THIS COURSE WILL BE SKIPPED!", rowError);
                    if (row != null && row.length > 1) {
                        logger.severe("Row details: Title=" + row[1]);
                    }
                    logger.severe("Full row data: " + java.util.Arrays.toString(row));
                    rowError.printStackTrace();
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
            logger.info("=== GETTING COURSE STATS ===");
            logger.info("User ID: " + (userId != null ? userId : "null"));

            int total = enrolledCourses != null ? enrolledCourses.size() : 0;
            int completed = 0;

            if (enrolledCourses != null) {
                // Đếm số khóa học đã hoàn thành (100%)
                for (CourseEnrollmentInfo info : enrolledCourses) {
                    if (info.getProgress() == 100) {
                        completed++;
                    }
                }
            }

            stats.setTotalCourses(total);
            stats.setCompletedCourses(completed);
            stats.setInProgressCourses(total - completed);
            stats.setTotalHours(total * 10);
        } catch (Exception e) {
            logger.log(Level.WARNING, "Error calculating course stats", e);
            e.printStackTrace();
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
