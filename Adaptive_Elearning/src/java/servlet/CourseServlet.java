package servlet;

import controller.CourseManagementController;
import controller.CourseManagementController.Course;
import controller.CourseManagementController.CourseStats;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CourseServlet", urlPatterns = {"/courses"})
public class CourseServlet extends HttpServlet {
    
    private CourseManagementController courseController;
    
    @Override
    public void init() throws ServletException {
        courseController = new CourseManagementController();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy tham số từ request
            String searchTerm = request.getParameter("search");
            String sortBy = request.getParameter("sort");
            int page = 1;
            int pageSize = 6;
            
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                // Giữ page = 1 nếu không có tham số hoặc tham số không hợp lệ
            }
            
            // Tính offset cho phân trang
            int offset = (page - 1) * pageSize;
            
            // Lấy danh sách khóa học
            List<Course> courses = courseController.getCourses(searchTerm, pageSize, offset);
            
            // Lấy tổng số khóa học để tính số trang
            int totalCourses = courseController.getTotalCourseCount(searchTerm);
            int totalPages = (int) Math.ceil((double) totalCourses / pageSize);
            
            // Lấy thống kê khóa học
            CourseStats stats = courseController.getCourseStats();
            
            // Đặt các thuộc tính vào request
            request.setAttribute("courses", courses);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("stats", stats);
            
            // Forward đến trang JSP
            request.getRequestDispatcher("/WEB-INF/views/courses.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}