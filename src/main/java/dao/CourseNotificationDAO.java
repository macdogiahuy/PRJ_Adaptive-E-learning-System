package dao;

import model.CourseNotification;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DAO class for CourseNotification management
 * Handles database operations for course approval notifications
 * @author LP
 */
public class CourseNotificationDAO {
    
    private static final Logger LOGGER = Logger.getLogger(CourseNotificationDAO.class.getName());
    
    /**
     * Create a new course notification when instructor creates a course
     */
    public boolean createNotification(CourseNotification notification) {
        String sql = "INSERT INTO CourseNotifications " +
                    "(Id, CourseId, InstructorId, InstructorName, CourseTitle, CoursePrice, " +
                    "NotificationType, Status, CreationTime) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            String notificationId = UUID.randomUUID().toString();
            notification.setId(notificationId);
            
            ps.setString(1, notificationId);
            ps.setString(2, notification.getCourseId());
            ps.setString(3, notification.getInstructorId());
            ps.setString(4, notification.getInstructorName());
            ps.setString(5, notification.getCourseTitle());
            ps.setDouble(6, notification.getCoursePrice());
            ps.setString(7, notification.getNotificationType());
            ps.setString(8, notification.getStatus());
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                LOGGER.log(Level.INFO, "Created notification for course: {0}", notification.getCourseTitle());
                return true;
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating course notification", e);
        }
        
        return false;
    }
    
    /**
     * Get all pending course notifications for admin
     */
    public List<CourseNotification> getPendingNotifications() {
        List<CourseNotification> notifications = new ArrayList<>();
        String sql = "EXEC sp_GetPendingCourseNotifications";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                CourseNotification notification = mapResultSetToNotification(rs);
                notifications.add(notification);
            }
            
            LOGGER.log(Level.INFO, "Found {0} pending notifications", notifications.size());
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting pending notifications", e);
        }
        
        return notifications;
    }
    
    /**
     * Get notification by ID
     */
    public CourseNotification getNotificationById(String notificationId) {
        String sql = "SELECT cn.*, c.ThumbUrl, c.Level, c.Description " +
                    "FROM CourseNotifications cn " +
                    "INNER JOIN Courses c ON cn.CourseId = c.Id " +
                    "WHERE cn.Id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, notificationId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToNotification(rs);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting notification by ID: " + notificationId, e);
        }
        
        return null;
    }
    
    /**
     * Get all notifications (for history)
     */
    public List<CourseNotification> getAllNotifications() {
        List<CourseNotification> notifications = new ArrayList<>();
        String sql = "SELECT cn.*, c.ThumbUrl, c.Level, c.Description " +
                    "FROM CourseNotifications cn " +
                    "INNER JOIN Courses c ON cn.CourseId = c.Id " +
                    "ORDER BY cn.CreationTime DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                CourseNotification notification = mapResultSetToNotification(rs);
                notifications.add(notification);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all notifications", e);
        }
        
        return notifications;
    }
    
    /**
     * Approve course - calls stored procedure
     */
    public boolean approveCourse(String notificationId, String processedBy) {
        String sql = "EXEC sp_ApproveCourse ?, ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, notificationId);
            ps.setString(2, processedBy);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int success = rs.getInt("Success");
                String message = rs.getString("Message");
                
                if (success == 1) {
                    LOGGER.log(Level.INFO, "Course approved: {0}", message);
                    return true;
                } else {
                    LOGGER.log(Level.WARNING, "Failed to approve course: {0}", message);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error approving course", e);
        }
        
        return false;
    }
    
    /**
     * Reject course with reason - calls stored procedure
     */
    public boolean rejectCourse(String notificationId, String processedBy, String rejectionReason) {
        String sql = "EXEC sp_RejectCourse ?, ?, ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, notificationId);
            ps.setString(2, processedBy);
            ps.setString(3, rejectionReason);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int success = rs.getInt("Success");
                String message = rs.getString("Message");
                
                if (success == 1) {
                    LOGGER.log(Level.INFO, "Course rejected: {0}", message);
                    return true;
                } else {
                    LOGGER.log(Level.WARNING, "Failed to reject course: {0}", message);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error rejecting course", e);
        }
        
        return false;
    }
    
    /**
     * Get count of pending notifications
     */
    public int getPendingNotificationCount() {
        String sql = "SELECT COUNT(*) as count FROM CourseNotifications WHERE Status = 'pending'";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting pending notification count", e);
        }
        
        return 0;
    }
    
    /**
     * Map ResultSet to CourseNotification object
     */
    private CourseNotification mapResultSetToNotification(ResultSet rs) throws SQLException {
        CourseNotification notification = new CourseNotification();
        
        notification.setId(rs.getString("Id"));
        notification.setCourseId(rs.getString("CourseId"));
        notification.setInstructorId(rs.getString("InstructorId"));
        notification.setInstructorName(rs.getString("InstructorName"));
        notification.setCourseTitle(rs.getString("CourseTitle"));
        notification.setCoursePrice(rs.getDouble("CoursePrice"));
        notification.setNotificationType(rs.getString("NotificationType"));
        notification.setStatus(rs.getString("Status"));
        notification.setCreationTime(rs.getTimestamp("CreationTime"));
        
        // Optional fields
        try {
            notification.setRejectionReason(rs.getString("RejectionReason"));
        } catch (SQLException e) {
            // Column might not exist in all queries
        }
        
        try {
            notification.setProcessedTime(rs.getTimestamp("ProcessedTime"));
        } catch (SQLException e) {
            // Column might not exist
        }
        
        try {
            notification.setProcessedBy(rs.getString("ProcessedBy"));
        } catch (SQLException e) {
            // Column might not exist
        }
        
        try {
            notification.setThumbUrl(rs.getString("ThumbUrl"));
            notification.setLevel(rs.getString("Level"));
            notification.setDescription(rs.getString("Description"));
        } catch (SQLException e) {
            // These columns might not exist in all queries
        }
        
        return notification;
    }
}
