package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import controller.CourseManagementController.Course;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet for handling courses listing and filtering
 */
@WebServlet(name = "CoursesServlet", urlPatterns = { "/courses" })
public class CoursesServlet extends HttpServlet {

  private final CourseManagementController courseController = new CourseManagementController();
  private final int PAGE_SIZE = 6; // Number of courses per page

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    try {
      // Get search parameters
      String searchTerm = request.getParameter("search");
      String sortBy = request.getParameter("sort");
      String category = request.getParameter("category");

      // Get page number (default to 1 if not specified)
      int page = 1;
      try {
        if (request.getParameter("page") != null) {
          page = Integer.parseInt(request.getParameter("page"));
          if (page < 1)
            page = 1;
        }
      } catch (NumberFormatException e) {
        // If page is not a valid number, default to 1
        page = 1;
      }

      // Calculate offset for SQL query
      int offset = (page - 1) * PAGE_SIZE;

      // Get total course count
      int totalCourses = courseController.getTotalCourseCount(searchTerm, category); // Calculate total pages
      int totalPages = (int) Math.ceil((double) totalCourses / PAGE_SIZE);
      if (totalPages < 1)
        totalPages = 1;

      // Get courses for the current page
      List<Course> courses = courseController.getCourses(searchTerm, sortBy, category, PAGE_SIZE, offset); // Get course
                                                                                                           // statistics
      CourseManagementController.CourseStats stats = courseController.getCourseStats();

      // Get category counts for the sidebar
      Map<String, Integer> categoryCounts = courseController.getCategoryCounts();

      // Set attributes for the JSP page
      request.setAttribute("courses", courses);
      request.setAttribute("stats", stats);
      request.setAttribute("currentPage", page);
      request.setAttribute("totalPages", totalPages);
      request.setAttribute("totalCourses", totalCourses);
      request.setAttribute("searchTerm", searchTerm);
      request.setAttribute("sortBy", sortBy);
      request.setAttribute("category", category);
      request.setAttribute("categoryCounts", categoryCounts); // Forward to the courses JSP page
      request.getRequestDispatcher("/WEB-INF/views/courses.jsp").forward(request, response);

    } catch (SQLException e) {
      e.printStackTrace();
      request.setAttribute("errorMessage", "Database error: " + e.getMessage());
      request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
    // For now, POST requests are forwarded to doGet
    doGet(request, response);
  }
}