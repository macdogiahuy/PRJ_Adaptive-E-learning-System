package services;

import model.ChatMessage;
import model.CourseConversation;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

/**
 * Service interface for Course Chat functionality
 */
public interface CourseChatService {
    
    /**
     * Join user to course chat when they enroll
     */
    boolean joinCourseChat(UUID userId, UUID courseId) throws SQLException;
    
    /**
     * Send message to course chat
     */
    boolean sendMessage(UUID userId, UUID courseId, String content) throws SQLException;
    
    /**
     * Get recent messages for course chat
     */
    List<ChatMessage> getCourseMessages(UUID courseId, int limit) throws SQLException;
    
    /**
     * Get user's course conversations
     */
    List<CourseConversation> getUserCourseConversations(UUID userId) throws SQLException;
    
    /**
     * Check if user can access course chat
     */
    boolean canUserAccessCourseChat(UUID userId, UUID courseId) throws SQLException;
    
    /**
     * Get conversation ID for course
     */
    UUID getCourseConversationId(UUID courseId) throws SQLException;
    
    /**
     * Create chat message object
     */
    ChatMessage createMessage(String content, UUID conversationId, UUID creatorId);
}