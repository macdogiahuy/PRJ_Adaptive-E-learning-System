package servlet;

import model.Courses;
import model.Categories;
import model.Sections;
import model.Users;
import services.CourseService;
import services.ServiceResults.OperationResult;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for managing instructor courses
 * Handles CRUD operations for courses
 * @author LP
 */
@WebServlet(urlPatterns = {"/instructor-courses", "/instructor-courses/*"})
public class InstructorCoursesServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(InstructorCoursesServlet.class.getName());
    private CourseService courseService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        courseService = new CourseService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("account") : null;
        
        // Check if user is logged in and has instructor or admin role
        if (user == null || (!("Instructor".equalsIgnoreCase(user.getRole()) || "Admin".equalsIgnoreCase(user.getRole())))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // List all courses for instructor
                handleListCourses(request, response, user);
            } else if (pathInfo.equals("/create")) {
                // Show create course form
                handleShowCreateForm(request, response, user);
            } else if (pathInfo.startsWith("/edit/")) {
                // Show edit course form
                String courseId = pathInfo.substring(6);
                handleShowEditForm(request, response, user, courseId);
            } else if (pathInfo.startsWith("/view/")) {
                // View course details
                String courseId = pathInfo.substring(6);
                handleViewCourse(request, response, user, courseId);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doGet", e);
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("account") : null;
        
        // Check if user is logged in and has instructor or admin role
        if (user == null || (!("Instructor".equalsIgnoreCase(user.getRole()) || "Admin".equalsIgnoreCase(user.getRole())))) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "create":
                    handleCreateCourse(request, response, user);
                    break;
                case "update":
                    handleUpdateCourse(request, response, user);
                    break;
                case "delete":
                    handleDeleteCourse(request, response, user);
                    break;
                case "createSection":
                    handleCreateSection(request, response, user);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doPost", e);
            sendJsonResponse(response, false, "Có lỗi xảy ra: " + e.getMessage());
        }
    }
    
    /**
     * List all courses for instructor
     */
    private void handleListCourses(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws ServletException, IOException {
        
        String userRole = user.getRole();
        List<Courses> courses;
        
        if ("Admin".equalsIgnoreCase(userRole)) {
            // Admin can see all courses
            LOGGER.log(Level.INFO, "Admin user: {0} - getting all courses", user.getUserName());
            courses = courseService.getAllCoursesForAdmin();
        } else {
            // Instructor sees only their courses
            // IMPORTANT: InstructorId in Users table points to Instructors.Id
            // Courses.InstructorId references Instructors.Id (NOT Users.Id)
            String instructorId = user.getInstructorId();
            
            LOGGER.log(Level.INFO, "User ID: {0}", user.getId());
            LOGGER.log(Level.INFO, "Instructor ID from Users.InstructorId: {0}", instructorId);
            
            // Verify we have a valid instructor ID
            if (instructorId == null || instructorId.trim().isEmpty()) {
                LOGGER.log(Level.WARNING, "No InstructorId found for user: {0}", user.getUserName());
                instructorId = user.getId(); // Fallback to User ID
            }
            
            LOGGER.log(Level.INFO, "Fetching courses for instructor: {0}", instructorId);
            courses = courseService.getInstructorCourses(instructorId);
        }
        
        LOGGER.log(Level.INFO, "Found {0} courses for user {1}", new Object[]{courses.size(), user.getUserName()});
        
        // Get categories for filter
        List<Categories> categories = courseService.getAllCategories();
        
        // Set attributes
        request.setAttribute("courses", courses);
        request.setAttribute("categories", categories);
        request.setAttribute("totalCourses", courses.size());
        
        // Forward to JSP
        request.getRequestDispatcher("/instructor_courses.jsp").forward(request, response);
    }
    
    /**
     * Show create course form
     */
    private void handleShowCreateForm(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws ServletException, IOException {
        
        // Get categories for dropdown
        List<Categories> categories = courseService.getAllCategories();
        request.setAttribute("categories", categories);
        request.setAttribute("action", "create");
        
        // Forward to form JSP
        request.getRequestDispatcher("/instructor_course_form.jsp").forward(request, response);
    }
    
    /**
     * Show edit course form
     */
    private void handleShowEditForm(HttpServletRequest request, HttpServletResponse response, Users user, String courseId) 
            throws ServletException, IOException {
        
        // Get course
        Courses course = courseService.getCourseById(courseId);
        
        if (course == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Course not found");
            return;
        }
        
        // Get sections
        List<Sections> sections = courseService.getCourseSections(courseId);
        
        // Get categories
        List<Categories> categories = courseService.getAllCategories();
        
        // Set attributes
        request.setAttribute("course", course);
        request.setAttribute("sections", sections);
        request.setAttribute("categories", categories);
        request.setAttribute("action", "update");
        
        // Forward to form JSP
        request.getRequestDispatcher("/instructor_course_form.jsp").forward(request, response);
    }
    
    /**
     * View course details
     */
    private void handleViewCourse(HttpServletRequest request, HttpServletResponse response, Users user, String courseId) 
            throws ServletException, IOException {
        
        Courses course = courseService.getCourseById(courseId);
        
        if (course == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Course not found");
            return;
        }
        
        List<Sections> sections = courseService.getCourseSections(courseId);
        
        request.setAttribute("course", course);
        request.setAttribute("sections", sections);
        request.setAttribute("averageRating", courseService.calculateAverageRating(course));
        
        request.getRequestDispatcher("/instructor_course_view.jsp").forward(request, response);
    }
    
    /**
     * Handle create course
     */
    private void handleCreateCourse(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws ServletException, IOException {
        
        // Parse course data
        Courses course = new Courses();
        course.setTitle(request.getParameter("title"));
        course.setThumbUrl(request.getParameter("thumbUrl"));
        course.setIntro(request.getParameter("intro"));
        course.setDescription(request.getParameter("description"));
        
        try {
            String priceStr = request.getParameter("price");
            String discountStr = request.getParameter("discount");
            
            LOGGER.log(Level.INFO, "Price parameter: {0}", priceStr);
            LOGGER.log(Level.INFO, "Discount parameter: {0}", discountStr);
            
            // Parse price
            if (priceStr == null || priceStr.trim().isEmpty()) {
                throw new NumberFormatException("Price is required");
            }
            course.setPrice(Double.parseDouble(priceStr.trim()));
            
            // Parse discount
            if (discountStr != null && !discountStr.trim().isEmpty()) {
                course.setDiscount(Double.parseDouble(discountStr.trim()));
            } else {
                course.setDiscount(0);
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Error parsing price/discount", e);
            request.setAttribute("errorMessage", "Giá hoặc giảm giá không hợp lệ. Vui lòng nhập số.");
            request.setAttribute("course", course);
            List<Categories> categories = courseService.getAllCategories();
            request.setAttribute("categories", categories);
            request.setAttribute("action", "create");
            request.getRequestDispatcher("/instructor_course_form.jsp").forward(request, response);
            return;
        }
        
        course.setLevel(request.getParameter("level"));
        course.setOutcomes(request.getParameter("outcomes"));
        course.setRequirements(request.getParameter("requirements"));
        course.setStatus(request.getParameter("status"));
        
        // Set category
        String categoryId = request.getParameter("categoryId");
        if (categoryId != null && !categoryId.trim().isEmpty()) {
            Categories category = new Categories();
            category.setId(categoryId);
            course.setLeafCategoryId(category);
        }
        
        // Get correct InstructorId from Users table
        String instructorId = user.getInstructorId();
        if (instructorId == null || instructorId.trim().isEmpty()) {
            LOGGER.log(Level.SEVERE, "No InstructorId found for user: {0}", user.getUserName());
            request.setAttribute("errorMessage", "Không tìm thấy InstructorId. Vui lòng liên hệ admin.");
            request.setAttribute("course", course);
            List<Categories> categories = courseService.getAllCategories();
            request.setAttribute("categories", categories);
            request.setAttribute("action", "create");
            request.getRequestDispatcher("/instructor_course_form.jsp").forward(request, response);
            return;
        }
        
        LOGGER.log(Level.INFO, "Creating course with InstructorId: {0}", instructorId);
        
        // Create course (InstructorId for Courses.InstructorId, UserId for CreatorId/LastModifierId)
        OperationResult<Courses> result = courseService.createCourse(course, instructorId, user.getId());
        
        if (result.isSuccess()) {
            // Handle sections if provided
            String[] sectionTitles = request.getParameterValues("sectionTitles[]");
            if (sectionTitles != null && sectionTitles.length > 0) {
                for (int i = 0; i < sectionTitles.length; i++) {
                    if (sectionTitles[i] != null && !sectionTitles[i].trim().isEmpty()) {
                        courseService.createSection(result.getData().getId(), sectionTitles[i], i + 1, user.getId());
                    }
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/instructor-courses?success=created");
        } else {
            request.setAttribute("errorMessage", result.getMessage());
            request.setAttribute("course", course);
            List<Categories> categories = courseService.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/instructor_course_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle update course
     */
    private void handleUpdateCourse(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws ServletException, IOException {
        
        String courseId = request.getParameter("courseId");
        
        if (courseId == null || courseId.trim().isEmpty()) {
            sendJsonResponse(response, false, "Course ID is required");
            return;
        }
        
        // Get existing course
        Courses course = courseService.getCourseById(courseId);
        
        if (course == null) {
            sendJsonResponse(response, false, "Course not found");
            return;
        }
        
        // Update course data
        course.setTitle(request.getParameter("title"));
        course.setThumbUrl(request.getParameter("thumbUrl"));
        course.setIntro(request.getParameter("intro"));
        course.setDescription(request.getParameter("description"));
        
        try {
            String priceStr = request.getParameter("price");
            String discountStr = request.getParameter("discount");
            
            // Parse price
            if (priceStr == null || priceStr.trim().isEmpty()) {
                throw new NumberFormatException("Price is required");
            }
            course.setPrice(Double.parseDouble(priceStr.trim()));
            
            // Parse discount
            if (discountStr != null && !discountStr.trim().isEmpty()) {
                course.setDiscount(Double.parseDouble(discountStr.trim()));
            } else {
                course.setDiscount(0);
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Error parsing price/discount", e);
            request.setAttribute("errorMessage", "Giá hoặc giảm giá không hợp lệ. Vui lòng nhập số.");
            request.setAttribute("course", course);
            List<Categories> categories = courseService.getAllCategories();
            request.setAttribute("categories", categories);
            request.setAttribute("action", "update");
            request.getRequestDispatcher("/instructor_course_form.jsp").forward(request, response);
            return;
        }
        
        course.setLevel(request.getParameter("level"));
        course.setOutcomes(request.getParameter("outcomes"));
        course.setRequirements(request.getParameter("requirements"));
        course.setStatus(request.getParameter("status"));
        
        // Update category
        String categoryId = request.getParameter("categoryId");
        if (categoryId != null && !categoryId.trim().isEmpty()) {
            Categories category = new Categories();
            category.setId(categoryId);
            course.setLeafCategoryId(category);
        }
        
        // Update course
        OperationResult<Courses> result = courseService.updateCourse(course, user.getId(), user.getId());
        
        if (result.isSuccess()) {
            response.sendRedirect(request.getContextPath() + "/instructor-courses?success=updated");
        } else {
            request.setAttribute("errorMessage", result.getMessage());
            request.setAttribute("course", course);
            List<Categories> categories = courseService.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/instructor_course_form.jsp").forward(request, response);
        }
    }
    
    /**
     * Handle delete course
     */
    private void handleDeleteCourse(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws ServletException, IOException {
        
        String courseId = request.getParameter("courseId");
        
        if (courseId == null || courseId.trim().isEmpty()) {
            sendJsonResponse(response, false, "Course ID is required");
            return;
        }
        
        OperationResult<Void> result = courseService.deleteCourse(courseId, user.getId());
        
        sendJsonResponse(response, result.isSuccess(), result.getMessage());
    }
    
    /**
     * Handle create section
     */
    private void handleCreateSection(HttpServletRequest request, HttpServletResponse response, Users user) 
            throws ServletException, IOException {
        
        String courseId = request.getParameter("courseId");
        String title = request.getParameter("title");
        String indexStr = request.getParameter("index");
        
        if (courseId == null || title == null) {
            sendJsonResponse(response, false, "Missing required parameters");
            return;
        }
        
        int index = indexStr != null ? Integer.parseInt(indexStr) : 1;
        
        OperationResult<Void> result = courseService.createSection(courseId, title, index, user.getId());
        
        sendJsonResponse(response, result.isSuccess(), result.getMessage());
    }
    
    /**
     * Send JSON response
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String json = String.format("{\"success\": %b, \"message\": \"%s\"}", success, message);
        response.getWriter().write(json);
    }
}
