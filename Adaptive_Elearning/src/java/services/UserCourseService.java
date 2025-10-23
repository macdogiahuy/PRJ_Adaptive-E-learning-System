/*
 * Service class example using JPA Controllers
 */
package services;

import controller.UsersJpaController;
import controller.CoursesJpaController;
import controller.exceptions.NonexistentEntityException;
import controller.exceptions.PreexistingEntityException;
import model.Users;
import model.Courses;
import java.util.List;
import java.util.UUID;

/**
 * Service layer for User and Course operations
 * This demonstrates how to use auto-generated JPA controllers
 * @author LP
 */
public class UserCourseService {
    
    private UsersJpaController userController;
    private CoursesJpaController courseController;
    
    public UserCourseService() {
        this.userController = new UsersJpaController();
        this.courseController = new CoursesJpaController();
    }
    
    // User Service Methods
    
    /**
     * Register a new user
     */
    public boolean registerUser(String username, String email, String password, String fullName) {
        try {
            // Check if user already exists
            if (userController.findByUsername(username) != null) {
                throw new RuntimeException("Username already exists");
            }
            
            if (userController.findByEmail(email) != null) {
                throw new RuntimeException("Email already exists");
            }
            
            // Create new user
            Users newUser = new Users();
            newUser.setId(UUID.randomUUID().toString());
            newUser.setUserName(username);
            newUser.setEmail(email);
            newUser.setPassword(password); // Should be hashed in real application
            newUser.setFullName(fullName);
            newUser.setRole("Student");
            newUser.setIsVerified(false);
            newUser.setIsApproved(true);
            newUser.setAccessFailedCount(0);
            
            userController.create(newUser);
            return true;
            
        } catch (PreexistingEntityException | Exception e) {
            System.err.println("Error registering user: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Authenticate user login
     */
    public Users authenticateUser(String username, String password) {
        Users user = userController.findByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }
    
    /**
     * Get all users by role
     */
    public List<Users> getUsersByRole(String role) {
        return userController.findByRole(role);
    }
    
    /**
     * Update user profile
     */
    public boolean updateUserProfile(String userId, String fullName, String bio, String phone) {
        try {
            Users user = userController.findUser(userId);
            if (user != null) {
                user.setFullName(fullName);
                user.setBio(bio);
                user.setPhone(phone);
                userController.edit(user);
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("Error updating user profile: " + e.getMessage());
            return false;
        }
    }
    
    // Course Service Methods
    
    /**
     * Create a new course
     */
    public boolean createCourse(String title, String description, String instructorId, String categoryId) {
        try {
            Courses newCourse = new Courses();
            newCourse.setId(UUID.randomUUID().toString());
            newCourse.setTitle(title);
            newCourse.setDescription(description);
            newCourse.setInstructorId(instructorId);
            newCourse.setCategoryId(categoryId);
            newCourse.setIsPublished(false);
            newCourse.setEnrollmentCount(0);
            
            courseController.create(newCourse);
            return true;
            
        } catch (Exception e) {
            System.err.println("Error creating course: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get all published courses
     */
    public List<Courses> getPublishedCourses() {
        return courseController.findPublishedCourses();
    }
    
    /**
     * Get courses by instructor
     */
    public List<Courses> getCoursesByInstructor(String instructorId) {
        return courseController.findByInstructor(instructorId);
    }
    
    /**
     * Publish a course
     */
    public boolean publishCourse(String courseId) {
        try {
            Courses course = courseController.findCourse(courseId);
            if (course != null) {
                course.setIsPublished(true);
                courseController.edit(course);
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("Error publishing course: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get course statistics
     */
    public void printStatistics() {
        try {
            int totalUsers = userController.getUsersCount();
            int totalCourses = courseController.getCoursesCount();
            int totalStudents = userController.findByRole("Student").size();
            int totalInstructors = userController.findByRole("Instructor").size();
            
            System.out.println("=== Platform Statistics ===");
            System.out.println("Total Users: " + totalUsers);
            System.out.println("Total Courses: " + totalCourses);
            System.out.println("Students: " + totalStudents);
            System.out.println("Instructors: " + totalInstructors);
            
        } catch (Exception e) {
            System.err.println("Error getting statistics: " + e.getMessage());
        }
    }
}