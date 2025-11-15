package servlet;

import controller.*;
import controller.CourseManagementController;
import controller.CourseManagementController.Course;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CoursesServlet", urlPatterns = {"/courses"})
public class CoursesServlet extends HttpServlet {
    private CourseManagementController courseController;
    private static final int COURSES_PER_PAGE = 9; // 3 columns per row

    @Override
    public void init() throws ServletException {
        courseController = new CourseManagementController();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("category");
        String search = request.getParameter("search");
        if (search == null) search = "";

        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { currentPage = Integer.parseInt(pageParam); if (currentPage < 1) currentPage = 1; }
            catch (NumberFormatException e) { currentPage = 1; }
        }

        int offset = (currentPage - 1) * COURSES_PER_PAGE;

        try {
            // categories for sidebar
            List<String> categories = courseController.getAllCategoryTitles();
            Map<String, Integer> categoryCounts = courseController.getCategoryCounts();

            List<Course> courses;
            int totalCourses = 0;
            int totalPages = 1;

            if (category != null && !category.trim().isEmpty()) {
                // load by category
                totalCourses = courseController.getTotalCoursesCountByCategory(category);
                totalPages = (int) Math.ceil((double) totalCourses / COURSES_PER_PAGE);
                if (totalPages < 1) totalPages = 1;
                courses = courseController.getCoursesByCategory(category, COURSES_PER_PAGE, offset);
            } else {
                // normal search listing
                totalCourses = courseController.getTotalCoursesCount(search);
                totalPages = (int) Math.ceil((double) totalCourses / COURSES_PER_PAGE);
                if (totalPages < 1) totalPages = 1;
                courses = courseController.getCourses(search, COURSES_PER_PAGE, offset);
            }

            // Build pagination URLs (preserve category/search query parameters)
            String context = request.getContextPath();
            String basePath = context + "/courses";

            List<String> pageUrls = new ArrayList<>();
            for (int p = 1; p <= totalPages; p++) {
                StringBuilder url = new StringBuilder(basePath);
                boolean first = true;
                if (category != null && !category.trim().isEmpty()) {
                    url.append(first ? '?' : '&').append("category=")
                       .append(URLEncoder.encode(category, StandardCharsets.UTF_8));
                    first = false;
                }
                if (search != null && !search.trim().isEmpty()) {
                    url.append(first ? '?' : '&').append("search=")
                       .append(URLEncoder.encode(search, StandardCharsets.UTF_8));
                    first = false;
                }
                // append page param
                url.append(first ? '?' : '&').append("page=").append(p);
                pageUrls.add(url.toString());
            }

            String prevPageUrl = null;
            String nextPageUrl = null;
            if (currentPage > 1) prevPageUrl = pageUrls.get(currentPage - 2);
            if (currentPage < totalPages) nextPageUrl = pageUrls.get(currentPage);

            request.setAttribute("categories", categories);
            request.setAttribute("categoryCounts", categoryCounts);
            request.setAttribute("courses", courses);
            request.setAttribute("search", search);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCourses", totalCourses);
            request.setAttribute("pageUrls", pageUrls);
            request.setAttribute("prevPageUrl", prevPageUrl);
            request.setAttribute("nextPageUrl", nextPageUrl);

        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load courses: " + ex.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/Pages/user/courses.jsp").forward(request, response);
    }
}