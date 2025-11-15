package servlet;

import controller.CourseManagementController;
import controller.CourseManagementController.Course;
import dao.CourseReviewDAO;
import dao.CourseReviewDAO.ReviewDTO;
import model.Users;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CourseDetailServlet", urlPatterns = {"/course-detail", "/detail"})
public class CourseDetailServlet extends HttpServlet {
    private CourseManagementController courseController;
    private CourseReviewDAO reviewDAO;

    @Override
    public void init() throws ServletException {
        courseController = new CourseManagementController();
        reviewDAO = new CourseReviewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseId = request.getParameter("id");
        if (courseId == null || courseId.isEmpty()) {
            // fallback to demo UI
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/course-review.jsp").forward(request, response);
            return;
        }

        try {
            Course course = courseController.getCourseById(courseId);
            if (course == null) {
                // not found, forward to UI with demo
                request.setAttribute("errorMessage", "Course not found");
                request.getRequestDispatcher("/WEB-INF/views/Pages/user/course-review.jsp").forward(request, response);
                return;
            }

            // normalize thumbnail URL to use /uploads/ for uploaded images
            String ctx = request.getContextPath();
            String thumbUrl = course.getThumbUrl();
            if (thumbUrl == null || thumbUrl.trim().isEmpty()) {
                course.setThumbUrl(ctx + "/assets/img/demo/java.jpg");
            } else if (thumbUrl.startsWith("http") || thumbUrl.startsWith(ctx)) {
                course.setThumbUrl(thumbUrl);
            } else {
                // always use /uploads/ for uploaded images
                course.setThumbUrl(ctx + "/uploads/" + thumbUrl);
            }

            request.setAttribute("course", course);

            // Load reviews for this course
            List<ReviewDTO> reviews = reviewDAO.getReviewsByCourseId(courseId);
            request.setAttribute("reviews", reviews);
            
            // Check if current user can review (logged in and enrolled)
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("account") != null) {
                Users user = (Users) session.getAttribute("account");
                boolean hasEnrolled = reviewDAO.hasUserEnrolled(user.getId(), courseId);
                boolean hasReviewed = reviewDAO.hasUserReviewed(user.getId(), courseId);
                request.setAttribute("canReview", hasEnrolled && !hasReviewed);
                request.setAttribute("hasEnrolled", hasEnrolled);
            }

            // try to load related courses by instructor (use instructorName)
            List<Course> related = new ArrayList<>();
            try {
                related = courseController.getCoursesByInstructor(course.getInstructorName(), courseId);
            } catch (SQLException ex) {
                // ignore and leave related empty
            }
            // normalize thumbnails for related courses as well
            for (Course rc : related) {
                String rThumb = rc.getThumbUrl();
                if (rThumb == null || rThumb.trim().isEmpty()) {
                    rc.setThumbUrl(ctx + "/assets/img/demo/java.jpg");
                } else if (rThumb.startsWith("http") || rThumb.startsWith(ctx)) {
                    rc.setThumbUrl(rThumb);
                } else {
                    rc.setThumbUrl(ctx + "/uploads/" + rThumb);
                }
            }
            request.setAttribute("moreCourses", related);

            request.getRequestDispatcher("/WEB-INF/views/Pages/user/course-review.jsp").forward(request, response);
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load course details");
            request.getRequestDispatcher("/WEB-INF/views/Pages/user/course-review.jsp").forward(request, response);
        }
    }
}