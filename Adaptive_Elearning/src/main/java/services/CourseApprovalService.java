package services;

import dao.CourseNotificationDAO;
import model.CourseNotification;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service class for Course Approval business logic
 * Handles course approval/rejection workflow
 * @author LP
 */
public class CourseApprovalService {
    
    private static final Logger LOGGER = Logger.getLogger(CourseApprovalService.class.getName());
    private final CourseNotificationDAO notificationDAO;
    
    public CourseApprovalService() {
        this.notificationDAO = new CourseNotificationDAO();
    }
    
    /**
     * Create notification when instructor creates a new course
     */
    public boolean createCourseNotification(String courseId, String instructorId, 
                                           String instructorName, String courseTitle, 
                                           double coursePrice) {
        try {
            CourseNotification notification = new CourseNotification();
            notification.setCourseId(courseId);
            notification.setInstructorId(instructorId);
            notification.setInstructorName(instructorName);
            notification.setCourseTitle(courseTitle);
            notification.setCoursePrice(coursePrice);
            notification.setNotificationType("course_pending");
            notification.setStatus("pending");
            
            boolean result = notificationDAO.createNotification(notification);
            
            if (result) {
                LOGGER.log(Level.INFO, "Created notification for course: {0} by instructor: {1}", 
                          new Object[]{courseTitle, instructorName});
            }
            
            return result;
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating course notification", e);
            return false;
        }
    }
    
    /**
     * Get all pending notifications for admin review
     */
    public List<CourseNotification> getPendingNotifications() {
        try {
            return notificationDAO.getPendingNotifications();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting pending notifications", e);
            return null;
        }
    }
    
    /**
     * Get all notifications (history)
     */
    public List<CourseNotification> getAllNotifications() {
        try {
            return notificationDAO.getAllNotifications();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting all notifications", e);
            return null;
        }
    }
    
    /**
     * Get notification by ID
     */
    public CourseNotification getNotificationById(String notificationId) {
        try {
            return notificationDAO.getNotificationById(notificationId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting notification by ID", e);
            return null;
        }
    }
    
    /**
     * Approve a course - changes status to 'ongoing' and makes it visible to users
     */
    public ServiceResult approveCourse(String notificationId, String adminId) {
        try {
            // Validate notification exists
            CourseNotification notification = notificationDAO.getNotificationById(notificationId);
            
            if (notification == null) {
                return new ServiceResult(false, "Notification not found");
            }
            
            if (!"pending".equals(notification.getStatus())) {
                return new ServiceResult(false, "Course has already been processed");
            }
            
            // Approve course using stored procedure
            boolean result = notificationDAO.approveCourse(notificationId, adminId);
            
            if (result) {
                LOGGER.log(Level.INFO, "Course approved: {0} by admin: {1}", 
                          new Object[]{notification.getCourseTitle(), adminId});
                return new ServiceResult(true, "Course approved successfully");
            } else {
                return new ServiceResult(false, "Failed to approve course");
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error approving course", e);
            return new ServiceResult(false, "Error: " + e.getMessage());
        }
    }
    
    /**
     * Reject a course with reason - changes status to 'off' and sends notification to instructor
     */
    public ServiceResult rejectCourse(String notificationId, String adminId, String rejectionReason) {
        try {
            // Validate inputs
            if (rejectionReason == null || rejectionReason.trim().isEmpty()) {
                return new ServiceResult(false, "Rejection reason is required");
            }
            
            // Validate notification exists
            CourseNotification notification = notificationDAO.getNotificationById(notificationId);
            
            if (notification == null) {
                return new ServiceResult(false, "Notification not found");
            }
            
            if (!"pending".equals(notification.getStatus())) {
                return new ServiceResult(false, "Course has already been processed");
            }
            
            // Reject course using stored procedure
            boolean result = notificationDAO.rejectCourse(notificationId, adminId, rejectionReason);
            
            if (result) {
                LOGGER.log(Level.INFO, "Course rejected: {0} by admin: {1}. Reason: {2}", 
                          new Object[]{notification.getCourseTitle(), adminId, rejectionReason});
                return new ServiceResult(true, "Course rejected successfully");
            } else {
                return new ServiceResult(false, "Failed to reject course");
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error rejecting course", e);
            return new ServiceResult(false, "Error: " + e.getMessage());
        }
    }
    
    /**
     * Get count of pending notifications
     */
    public int getPendingNotificationCount() {
        try {
            return notificationDAO.getPendingNotificationCount();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting pending notification count", e);
            return 0;
        }
    }
    
    /**
     * Inner class for service operation results
     */
    public static class ServiceResult {
        private final boolean success;
        private final String message;
        private Object data;
        
        public ServiceResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
        
        public ServiceResult(boolean success, String message, Object data) {
            this.success = success;
            this.message = message;
            this.data = data;
        }
        
        public boolean isSuccess() {
            return success;
        }
        
        public String getMessage() {
            return message;
        }
        
        public Object getData() {
            return data;
        }
    }
}
