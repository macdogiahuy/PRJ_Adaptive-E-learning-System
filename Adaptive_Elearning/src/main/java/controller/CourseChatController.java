package controller;

import dao.DBConnection;
import model.CourseConversation;
import services.CourseChatService;
import services.CourseChatServiceImpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Controller for Course Chat functionality
 * Handles HTTP requests for chat-related operations
 */
public class CourseChatController {
    
    private final CourseChatService courseChatService;
    
    public CourseChatController() {
        this.courseChatService = new CourseChatServiceImpl();
    }
    
    /**
     * Get user's course conversations for chat sidebar
     */
    public Map<String, Object> getUserCourseConversations(String userId) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            UUID userUUID = UUID.fromString(userId);
            List<CourseConversation> conversations = courseChatService.getUserCourseConversations(userUUID);
            
            result.put("success", true);
            result.put("conversations", conversations);
            result.put("count", conversations.size());
            
        } catch (IllegalArgumentException e) {
            result.put("success", false);
            result.put("error", "Invalid user ID format");
        } catch (SQLException e) {
            result.put("success", false);
            result.put("error", "Database error: " + e.getMessage());
            throw e;
        }
        
        return result;
    }
    
    /**
     * Join user to course chat (called when user enrolls in course)
     */
    public Map<String, Object> joinCourseChat(String userId, String courseId) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            UUID userUUID = UUID.fromString(userId);
            UUID courseUUID = UUID.fromString(courseId);
            
            boolean joined = courseChatService.joinCourseChat(userUUID, courseUUID);
            
            if (joined) {
                result.put("success", true);
                result.put("message", "Successfully joined course chat");
                
                // Get conversation details
                UUID conversationId = courseChatService.getCourseConversationId(courseUUID);
                result.put("conversationId", conversationId != null ? conversationId.toString() : null);
            } else {
                result.put("success", false);
                result.put("error", "Failed to join course chat. Check if you're enrolled in the course.");
            }
            
        } catch (IllegalArgumentException e) {
            result.put("success", false);
            result.put("error", "Invalid ID format");
        } catch (SQLException e) {
            result.put("success", false);
            result.put("error", "Database error: " + e.getMessage());
            throw e;
        }
        
        return result;
    }
    
    /**
     * Get course messages for initial load
     */
    public Map<String, Object> getCourseMessages(String courseId, int limit) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            UUID courseUUID = UUID.fromString(courseId);
            var messages = courseChatService.getCourseMessages(courseUUID, limit);
            
            result.put("success", true);
            result.put("messages", messages);
            result.put("count", messages.size());
            
        } catch (IllegalArgumentException e) {
            result.put("success", false);
            result.put("error", "Invalid course ID format");
        } catch (SQLException e) {
            result.put("success", false);
            result.put("error", "Database error: " + e.getMessage());
            throw e;
        }
        
        return result;
    }
    
    /**
     * Check if user can access course chat
     */
    public Map<String, Object> checkChatAccess(String userId, String courseId) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        
        try {
            UUID userUUID = UUID.fromString(userId);
            UUID courseUUID = UUID.fromString(courseId);
            
            boolean canAccess = courseChatService.canUserAccessCourseChat(userUUID, courseUUID);
            
            result.put("success", true);
            result.put("canAccess", canAccess);
            
            if (!canAccess) {
                result.put("message", "User is not enrolled in this course or chat doesn't exist");
            }
            
        } catch (IllegalArgumentException e) {
            result.put("success", false);
            result.put("error", "Invalid ID format");
        } catch (SQLException e) {
            result.put("success", false);
            result.put("error", "Database error: " + e.getMessage());
            throw e;
        }
        
        return result;
    }
    
    /**
     * Get course information for chat
     */
    public Map<String, Object> getCourseInfo(String courseId) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            UUID courseUUID = UUID.fromString(courseId);
            connection = DBConnection.getConnection();
            
            String sql = """
                SELECT c.Id, c.Title, c.ThumbUrl, 
                       i.Id as InstructorId, u.FullName as InstructorName,
                       (SELECT COUNT(*) FROM Enrollments e WHERE e.CourseId = c.Id) as EnrollmentCount
                FROM Courses c
                INNER JOIN Instructors i ON i.Id = c.InstructorId
                INNER JOIN Users u ON u.Id = i.CreatorId
                WHERE c.Id = ?
                """;
            
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, courseUUID.toString());
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                result.put("success", true);
                result.put("courseId", rs.getString("Id"));
                result.put("courseTitle", rs.getString("Title"));
                result.put("courseThumb", rs.getString("ThumbUrl"));
                result.put("instructorName", rs.getString("InstructorName"));
                result.put("enrollmentCount", rs.getInt("EnrollmentCount"));
            } else {
                result.put("success", false);
                result.put("error", "Course not found");
            }
            
        } catch (IllegalArgumentException e) {
            result.put("success", false);
            result.put("error", "Invalid course ID format");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return result;
    }
    
    /**
     * Auto-join user to all course chats they're enrolled in
     */
    public Map<String, Object> autoJoinUserChats(String userId) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int joinedCount = 0;
        
        try {
            UUID userUUID = UUID.fromString(userId);
            connection = DBConnection.getConnection();
            
            // Get all courses user is enrolled in
            String sql = "SELECT CourseId FROM Enrollments WHERE CreatorId = ?";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, userUUID.toString());
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                UUID courseId = UUID.fromString(rs.getString("CourseId"));
                try {
                    if (courseChatService.joinCourseChat(userUUID, courseId)) {
                        joinedCount++;
                    }
                } catch (Exception e) {
                    System.err.println("Error joining course chat " + courseId + ": " + e.getMessage());
                }
            }
            
            result.put("success", true);
            result.put("joinedCount", joinedCount);
            result.put("message", "Joined " + joinedCount + " course chats");
            
        } catch (IllegalArgumentException e) {
            result.put("success", false);
            result.put("error", "Invalid user ID format");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return result;
    }
    
    /**
     * Get chat statistics for admin
     */
    public Map<String, Object> getChatStatistics() throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            // Total conversations
            String conversationSql = "SELECT COUNT(*) as total FROM Conversations WHERE IsPrivate = 0";
            stmt = connection.prepareStatement(conversationSql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                result.put("totalConversations", rs.getInt("total"));
            }
            rs.close();
            stmt.close();
            
            // Total messages
            String messageSql = "SELECT COUNT(*) as total FROM ChatMessages";
            stmt = connection.prepareStatement(messageSql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                result.put("totalMessages", rs.getInt("total"));
            }
            rs.close();
            stmt.close();
            
            // Active conversations (with messages in last 7 days)
            String activeSql = """
                SELECT COUNT(DISTINCT cm.ConversationId) as active
                FROM ChatMessages cm
                WHERE cm.CreationTime >= DATEADD(DAY, -7, GETDATE())
                """;
            stmt = connection.prepareStatement(activeSql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                result.put("activeConversations", rs.getInt("active"));
            }
            
            result.put("success", true);
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
        
        return result;
    }
    
    /**
     * Test database connection
     */
    public boolean testDatabaseConnection() {
        try {
            Connection connection = DBConnection.getConnection();
            if (connection != null) {
                connection.close();
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Database connection test failed: " + e.getMessage());
        }
        return false;
    }
}