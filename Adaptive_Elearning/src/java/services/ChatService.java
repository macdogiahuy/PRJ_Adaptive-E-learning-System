package services;

import model.Conversations;
import model.ChatMessages;
import model.Users;
import java.util.List;
import java.sql.SQLException;

/**
 * Service interface cho chức năng Chat Group Member
 * Quản lý chat group của các khóa học
 */
public interface ChatService {
    
    /**
     * Tạo conversation group cho khóa học nếu chưa tồn tại
     * @param courseId ID của khóa học
     * @return Conversation đã tạo hoặc đã tồn tại
     * @throws SQLException
     */
    Conversations createOrGetCourseConversation(String courseId) throws SQLException;
    
    /**
     * Tự động thêm user vào group chat khi enroll khóa học
     * @param userId ID của user
     * @param courseId ID của khóa học
     * @return true nếu thành công
     * @throws SQLException
     */
    boolean addUserToCourseGroup(String userId, String courseId) throws SQLException;
    
    /**
     * Lấy danh sách tất cả conversation groups mà user tham gia
     * @param userId ID của user
     * @return Danh sách conversations
     * @throws SQLException
     */
    List<Conversations> getUserCourseGroups(String userId) throws SQLException;
    
    /**
     * Lấy danh sách members trong một conversation
     * @param conversationId ID của conversation
     * @return Danh sách users
     * @throws SQLException
     */
    List<Users> getConversationMembers(String conversationId) throws SQLException;
    
    /**
     * Gửi tin nhắn vào group
     * @param conversationId ID của conversation
     * @param senderId ID của người gửi
     * @param content Nội dung tin nhắn
     * @return ChatMessage đã tạo
     * @throws SQLException
     */
    ChatMessages sendMessage(String conversationId, String senderId, String content) throws SQLException;
    
    /**
     * Lấy lịch sử tin nhắn của conversation
     * @param conversationId ID của conversation
     * @param limit Số lượng tin nhắn tối đa
     * @return Danh sách tin nhắn
     * @throws SQLException
     */
    List<ChatMessages> getMessageHistory(String conversationId, int limit) throws SQLException;
    
    /**
     * Kiểm tra user có phải member của conversation không
     * @param userId ID của user
     * @param conversationId ID của conversation
     * @return true nếu là member
     * @throws SQLException
     */
    boolean isUserInConversation(String userId, String conversationId) throws SQLException;
    
    /**
     * Lấy thông tin conversation theo ID
     * @param conversationId ID của conversation
     * @return Conversation object
     * @throws SQLException
     */
    Conversations getConversationById(String conversationId) throws SQLException;
    
    /**
     * Lấy conversation của khóa học
     * @param courseId ID của khóa học
     * @return Conversation của khóa học hoặc null nếu chưa có
     * @throws SQLException
     */
    Conversations getConversationByCourseId(String courseId) throws SQLException;
}