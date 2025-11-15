package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import controller.CourseManagementController;
import controller.CourseManagementController.Course;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    private final CourseManagementController courseController = new CourseManagementController();
    private static final int COURSES_PER_PAGE = 6;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy từ khóa search từ request
        String search = request.getParameter("search");
        if (search == null) search = "";

        // 2. Lấy trang hiện tại
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        int offset = (currentPage - 1) * COURSES_PER_PAGE;
        int totalCourses = 0;
        int totalPages = 1;

        try {
            // 3. Lấy tổng số khóa học matching search (COUNT(*))
            totalCourses = courseController.getTotalCoursesCount(search);
            totalPages = (int) Math.ceil((double) totalCourses / COURSES_PER_PAGE);
            if (totalPages < 1) totalPages = 1;

            // 4. Lấy danh sách khóa học cho trang hiện tại
            List<Course> courses = courseController.getCourses(search, COURSES_PER_PAGE, offset);

            // 5. Set attributes cho JSP
            request.setAttribute("courses", courses);
            request.setAttribute("search", search); // giữ lại từ khóa trong input
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCourses", totalCourses);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải khóa học: " + e.getMessage());
            request.setAttribute("courses", null);
        }

        // 6. Forward sang JSP
        RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/Pages/home.jsp");
        rd.forward(request, response);
    }
}
