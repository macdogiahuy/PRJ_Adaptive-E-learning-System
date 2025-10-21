package controller;

import services.ChatService;
import services.ChatServiceImpl;
import model.Conversations;
import model.ChatMessages;
import model.Users;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller cho chức năng Chat Group Member
 * Xử lý các yêu cầu liên quan đến chat group của khóa học
 */
public class ChatController {
    
    private ChatService chatService;
    
    public ChatController() {
        try {
            this.chatService = new ChatServiceImpl();
        } catch (SQLException e) {
            e.printStackTrace();
            // Log error hoặc throw runtime exception
        }
    }
    
    /**
     * Xử lý khi user enroll vào khóa học - tự động add vào group chat
     * @param userId ID của user
     * @param courseId ID của khóa học
     * @return true nếu thành công
     */
    public boolean handleCourseEnrollment(String userId, String courseId) {
        try {
            return chatService.addUserToCourseGroup(userId, courseId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Lấy danh sách tất cả group chat mà user tham gia
     * @param userId ID của user
     * @return Danh sách conversations
     */
    public List<Conversations> getUserCourseGroups(String userId) {
        try {
            return chatService.getUserCourseGroups(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Lấy danh sách members trong conversation
     * @param conversationId ID của conversation
     * @return Danh sách users
     */
    public List<Users> getConversationMembers(String conversationId) {
        try {
            return chatService.getConversationMembers(conversationId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Gửi tin nhắn vào group
     * @param conversationId ID của conversation
     * @param senderId ID của người gửi
     * @param content Nội dung tin nhắn
     * @return ChatMessage đã tạo
     */
    public ChatMessages sendMessage(String conversationId, String senderId, String content) {
        try {
            return chatService.sendMessage(conversationId, senderId, content);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Lấy lịch sử tin nhắn
     * @param conversationId ID của conversation
     * @param limit Số lượng tin nhắn tối đa
     * @return Danh sách tin nhắn
     */
    public List<ChatMessages> getMessageHistory(String conversationId, int limit) {
        try {
            return chatService.getMessageHistory(conversationId, limit);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Kiểm tra user có quyền truy cập conversation không
     * @param userId ID của user
     * @param conversationId ID của conversation
     * @return true nếu có quyền
     */
    public boolean validateUserAccess(String userId, String conversationId) {
        try {
            return chatService.isUserInConversation(userId, conversationId);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Lấy thông tin conversation
     * @param conversationId ID của conversation
     * @return Conversation object
     */
    public Conversations getConversationInfo(String conversationId) {
        try {
            return chatService.getConversationById(conversationId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Lấy conversation của khóa học
     * @param courseId ID của khóa học
     * @return Conversation của khóa học
     */
    public Conversations getCourseConversation(String courseId) {
        try {
            return chatService.getConversationByCourseId(courseId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}