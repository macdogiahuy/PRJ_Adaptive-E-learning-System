package services;

import dao.CourseDAO;
import model.Courses;
import model.Categories;
import model.Sections;
import services.ServiceResults.OperationResult;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service layer for Course management with business logic
 * @author LP
 */
public class CourseService {
    private static final Logger LOGGER = Logger.getLogger(CourseService.class.getName());
    private final CourseDAO courseDAO;
    
    public CourseService() {
        this.courseDAO = new CourseDAO();
    }
    
    /**
     * Get all courses for an instructor
     */
    public List<Courses> getInstructorCourses(String instructorId) {
        if (instructorId == null || instructorId.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Invalid instructor ID");
            return List.of();
        }
        
        return courseDAO.getCoursesByInstructorId(instructorId);
    }
    
    /**
     * Get all courses for admin (can see all courses including pending)
     */
    public List<Courses> getAllCoursesForAdmin() {
        try {
            // Admin can see all courses in the system (including pending)
            return courseDAO.getAllCoursesForAdmin();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting all courses for admin", e);
            return List.of();
        }
    }
    
    /**
     * Get courses based on user role
     * Admin: All courses
     * Instructor: Only their courses
     */
    public List<Courses> getCoursesByUserRole(String userId, String userRole) {
        if ("Admin".equalsIgnoreCase(userRole)) {
            return getAllCoursesForAdmin();
        } else if ("Instructor".equalsIgnoreCase(userRole)) {
            return getInstructorCourses(userId);
        } else {
            LOGGER.log(Level.WARNING, "Invalid role for course access: " + userRole);
            return List.of();
        }
    }
    
    /**
     * Get course by ID with validation
     */
    public Courses getCourseById(String courseId) {
        if (courseId == null || courseId.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Invalid course ID");
            return null;
        }
        
        return courseDAO.getCourseById(courseId);
    }
    
    /**
     * Create new course with validation
     */
    public OperationResult<Courses> createCourse(Courses course, String instructorId, String userId) {
        // Validate input
        if (course == null) {
            return OperationResult.failure("Course object cannot be null");
        }
        
        if (course.getTitle() == null || course.getTitle().trim().isEmpty()) {
            return OperationResult.failure("Course title is required");
        }
        
        if (course.getPrice() < 0) {
            return OperationResult.failure("Course price cannot be negative");
        }
        
        if (instructorId == null || instructorId.trim().isEmpty()) {
            return OperationResult.failure("Instructor ID is required");
        }
        
        if (userId == null || userId.trim().isEmpty()) {
            return OperationResult.failure("User ID is required");
        }
        
        // Business logic: Set defaults
        if (course.getStatus() == null || course.getStatus().trim().isEmpty()) {
            course.setStatus("Ongoing");
        }
        
        if (course.getLevel() == null || course.getLevel().trim().isEmpty()) {
            course.setLevel("Beginner");
        }
        
        // Create course
        boolean success = courseDAO.createCourse(course, instructorId, userId);
        
        if (success) {
            return OperationResult.success("Course created successfully", course);
        } else {
            return OperationResult.failure("Failed to create course");
        }
    }
    
    /**
     * Update existing course with validation
     */
    public OperationResult<Courses> updateCourse(Courses course, String userId, String instructorId) {
        // Validate input
        if (course == null) {
            return OperationResult.failure("Course object cannot be null");
        }
        
        if (course.getId() == null || course.getId().trim().isEmpty()) {
            return OperationResult.failure("Course ID is required");
        }
        
        if (course.getTitle() == null || course.getTitle().trim().isEmpty()) {
            return OperationResult.failure("Course title is required");
        }
        
        if (course.getPrice() < 0) {
            return OperationResult.failure("Course price cannot be negative");
        }
        
        // Verify course belongs to instructor
        Courses existingCourse = courseDAO.getCourseById(course.getId());
        if (existingCourse == null) {
            return OperationResult.failure("Course not found");
        }
        
        // Update course
        boolean success = courseDAO.updateCourse(course, userId);
        
        if (success) {
            return OperationResult.success("Course updated successfully", course);
        } else {
            return OperationResult.failure("Failed to update course");
        }
    }
    
    /**
     * Delete course with validation
     */
    public OperationResult<Void> deleteCourse(String courseId, String instructorId) {
        if (courseId == null || courseId.trim().isEmpty()) {
            return OperationResult.failure("Course ID is required");
        }
        
        // Verify course exists and belongs to instructor
        Courses existingCourse = courseDAO.getCourseById(courseId);
        if (existingCourse == null) {
            return OperationResult.failure("Course not found");
        }
        
        // Delete course
        boolean success = courseDAO.deleteCourse(courseId);
        
        if (success) {
            return OperationResult.success("Course deleted successfully", null);
        } else {
            return OperationResult.failure("Failed to delete course");
        }
    }
    
    /**
     * Get all categories for dropdown
     */
    public List<Categories> getAllCategories() {
        return courseDAO.getAllCategories();
    }
    
    /**
     * Get sections for a course
     */
    public List<Sections> getCourseSections(String courseId) {
        if (courseId == null || courseId.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Invalid course ID");
            return List.of();
        }
        
        return courseDAO.getSectionsByCourseId(courseId);
    }
    
    /**
     * Create section for a course
     */
    public OperationResult<Void> createSection(String courseId, String title, int index, String userId) {
        if (courseId == null || courseId.trim().isEmpty()) {
            return OperationResult.failure("Course ID is required");
        }
        
        if (title == null || title.trim().isEmpty()) {
            return OperationResult.failure("Section title is required");
        }
        
        boolean success = courseDAO.createSection(courseId, title, index, userId);
        
        if (success) {
            return OperationResult.success("Section created successfully", null);
        } else {
            return OperationResult.failure("Failed to create section");
        }
    }
    
    /**
     * Get course statistics for instructor dashboard
     */
    public CourseDAO.CourseStatistics getCourseStatistics(String instructorId) {
        if (instructorId == null || instructorId.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Invalid instructor ID");
            return new CourseDAO.CourseStatistics();
        }
        
        return courseDAO.getCourseStatistics(instructorId);
    }
    
    /**
     * Calculate average rating for a course
     */
    public double calculateAverageRating(Courses course) {
        if (course == null || course.getRatingCount() == 0) {
            return 0.0;
        }
        
        return (double) course.getTotalRating() / course.getRatingCount();
    }
    
    /**
     * Format price with discount
     */
    public double calculateDiscountedPrice(Courses course) {
        if (course == null) {
            return 0.0;
        }
        
        double price = course.getPrice();
        double discount = course.getDiscount();
        
        if (discount > 0 && discount <= 100) {
            return price * (1 - discount / 100);
        }
        
        return price;
    }
}
