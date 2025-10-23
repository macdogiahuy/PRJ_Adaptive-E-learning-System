package services;

import dao.CourseChatDAO;
import model.ChatMessage;
import model.CourseConversation;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

/**
 * Implementation of CourseChatService
 * Handles business logic for course chat functionality
 */
public class CourseChatServiceImpl implements CourseChatService {
    
    private final CourseChatDAO courseChatDAO;
    
    public CourseChatServiceImpl() {
        this.courseChatDAO = new CourseChatDAO();
    }
    
    @Override
    public boolean joinCourseChat(UUID userId, UUID courseId) throws SQLException {
        if (userId == null || courseId == null) {
            return false;
        }
        
        return courseChatDAO.addUserToCourseConversation(userId, courseId);
    }
    
    @Override
    public boolean sendMessage(UUID userId, UUID courseId, String content) throws SQLException {
        if (userId == null || courseId == null || content == null || content.trim().isEmpty()) {
            return false;
        }
        
        // Check if user can access course chat
        if (!canUserAccessCourseChat(userId, courseId)) {
            return false;
        }
        
        // Get conversation ID
        UUID conversationId = getCourseConversationId(courseId);
        if (conversationId == null) {
            return false;
        }
        
        // Create and save message
        ChatMessage message = createMessage(content.trim(), conversationId, userId);
        return courseChatDAO.saveMessage(message);
    }
    
    @Override
    public List<ChatMessage> getCourseMessages(UUID courseId, int limit) throws SQLException {
        if (courseId == null || limit <= 0) {
            return List.of();
        }
        
        return courseChatDAO.getCourseMessages(courseId, Math.min(limit, 100)); // Max 100 messages
    }
    
    @Override
    public List<CourseConversation> getUserCourseConversations(UUID userId) throws SQLException {
        if (userId == null) {
            return List.of();
        }
        
        return courseChatDAO.getUserCourseConversations(userId);
    }
    
    @Override
    public boolean canUserAccessCourseChat(UUID userId, UUID courseId) throws SQLException {
        if (userId == null || courseId == null) {
            return false;
        }
        
        return courseChatDAO.isUserMemberOfCourseChat(userId, courseId);
    }
    
    @Override
    public UUID getCourseConversationId(UUID courseId) throws SQLException {
        if (courseId == null) {
            return null;
        }
        
        UUID conversationId = courseChatDAO.getCourseConversationId(courseId);
        
        // If conversation doesn't exist, create it
        if (conversationId == null) {
            CourseConversation conversation = courseChatDAO.getOrCreateCourseConversation(courseId);
            if (conversation != null) {
                conversationId = conversation.getId();
            }
        }
        
        return conversationId;
    }
    
    @Override
    public ChatMessage createMessage(String content, UUID conversationId, UUID creatorId) {
        if (content == null || conversationId == null || creatorId == null) {
            return null;
        }
        
        return new ChatMessage(content, conversationId, creatorId);
    }
    
    /**
     * Validate message content
     */
    public boolean isValidMessageContent(String content) {
        if (content == null) {
            return false;
        }
        
        String trimmed = content.trim();
        return !trimmed.isEmpty() && trimmed.length() <= 255; // Max length from database
    }
    
    /**
     * Auto-join user to course chat when they enroll
     */
    public void autoJoinUserToCourseChats(UUID userId) {
        try {
            // This would be called when user enrolls in a course
            // Implementation would get all enrolled courses and join their chats
            List<CourseConversation> conversations = getUserCourseConversations(userId);
            
            for (CourseConversation conversation : conversations) {
                joinCourseChat(userId, conversation.getCourseId());
            }
            
        } catch (SQLException e) {
            System.err.println("Error auto-joining user to course chats: " + e.getMessage());
        }
    }
}