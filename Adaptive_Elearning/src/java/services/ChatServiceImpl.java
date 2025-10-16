package services;

import dao.DBConnection;
import model.Conversations;
import model.ChatMessages;
import model.Users;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Implementation của ChatService cho chức năng Chat Group Member
 */
public class ChatServiceImpl implements ChatService {

    private Connection connection;

    public ChatServiceImpl() throws SQLException {
        this.connection = DBConnection.getConnection();
    }

    @Override
    public Conversations createOrGetCourseConversation(String courseId) throws SQLException {
        // Kiểm tra xem khóa học đã có conversation chưa
        Conversations existing = getConversationByCourseId(courseId);
        if (existing != null) {
            return existing;
        }

        // Lấy thông tin khóa học
        String getCourseQuery = "SELECT Title, ThumbUrl, InstructorId FROM Courses WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(getCourseQuery)) {
            ps.setString(1, courseId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                String courseTitle = rs.getString("Title");
                String thumbUrl = rs.getString("ThumbUrl");
                String instructorId = rs.getString("InstructorId");
                
                // Tạo conversation mới
                String conversationId = UUID.randomUUID().toString();
                String insertConversationQuery = "INSERT INTO Conversations (Id, Title, IsPrivate, AvatarUrl, CreationTime, CreatorId) VALUES (?, ?, 0, ?, GETDATE(), ?)";
                
                try (PreparedStatement insertPs = connection.prepareStatement(insertConversationQuery)) {
                    insertPs.setString(1, conversationId);
                    insertPs.setString(2, "Nhóm học: " + courseTitle);
                    insertPs.setString(3, thumbUrl != null ? thumbUrl : "");
                    insertPs.setString(4, instructorId);
                    insertPs.executeUpdate();
                }
                
                // Tạo bảng liên kết Course-Conversation (tạm thời lưu trong description)
                String updateConversationQuery = "UPDATE Conversations SET Title = ? WHERE Id = ?";
                try (PreparedStatement updatePs = connection.prepareStatement(updateConversationQuery)) {
                    updatePs.setString(1, "Nhóm học: " + courseTitle + " [CourseId:" + courseId + "]");
                    updatePs.setString(2, conversationId);
                    updatePs.executeUpdate();
                }
                
                // Tự động thêm instructor vào group
                addMemberToConversation(conversationId, instructorId, true);
                
                return getConversationById(conversationId);
            }
        }
        return null;
    }

    @Override
    public boolean addUserToCourseGroup(String userId, String courseId) throws SQLException {
        // Tạo hoặc lấy conversation của khóa học
        Conversations conversation = createOrGetCourseConversation(courseId);
        if (conversation == null) {
            return false;
        }

        // Kiểm tra user đã trong group chưa
        if (isUserInConversation(userId, conversation.getId())) {
            return true; // Đã có trong group
        }

        // Thêm user vào group
        return addMemberToConversation(conversation.getId(), userId, false);
    }

    private boolean addMemberToConversation(String conversationId, String userId, boolean isAdmin) throws SQLException {
        String insertMemberQuery = "INSERT INTO ConversationMembers (CreatorId, ConversationId, IsAdmin, LastVisit, CreationTime) VALUES (?, ?, ?, GETDATE(), GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(insertMemberQuery)) {
            ps.setString(1, userId);
            ps.setString(2, conversationId);
            ps.setBoolean(3, isAdmin);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<Conversations> getUserCourseGroups(String userId) throws SQLException {
        List<Conversations> conversations = new ArrayList<>();
        String query = """
            SELECT DISTINCT c.Id, c.Title, c.IsPrivate, c.AvatarUrl, c.CreationTime, c.CreatorId
            FROM Conversations c
            INNER JOIN ConversationMembers cm ON c.Id = cm.ConversationId
            WHERE cm.CreatorId = ? AND c.IsPrivate = 0 AND c.Title LIKE 'Nhóm học:%'
            ORDER BY c.CreationTime DESC
            """;
        
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Conversations conv = new Conversations();
                conv.setId(rs.getString("Id"));
                conv.setTitle(rs.getString("Title"));
                conv.setIsPrivate(rs.getBoolean("IsPrivate"));
                conv.setAvatarUrl(rs.getString("AvatarUrl"));
                conv.setCreationTime(rs.getTimestamp("CreationTime"));
                // Note: CreatorId mapping would need Users object
                conversations.add(conv);
            }
        }
        
        return conversations;
    }

    @Override
    public List<Users> getConversationMembers(String conversationId) throws SQLException {
        List<Users> members = new ArrayList<>();
        String query = """
            SELECT u.Id, u.UserName, u.Email, u.FullName, u.AvatarUrl
            FROM Users u
            INNER JOIN ConversationMembers cm ON u.Id = cm.CreatorId
            WHERE cm.ConversationId = ?
            ORDER BY cm.CreationTime ASC
            """;
        
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, conversationId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Users user = new Users();
                user.setId(rs.getString("Id"));
                user.setUserName(rs.getString("UserName"));
                user.setEmail(rs.getString("Email"));
                user.setFullName(rs.getString("FullName"));
                user.setAvatarUrl(rs.getString("AvatarUrl"));
                members.add(user);
            }
        }
        
        return members;
    }

    @Override
    public ChatMessages sendMessage(String conversationId, String senderId, String content) throws SQLException {
        String messageId = UUID.randomUUID().toString();
        String insertQuery = "INSERT INTO ChatMessages (Id, Content, Status, ConversationId, CreationTime, LastModificationTime, CreatorId, LastModifierId) VALUES (?, ?, 'Delivered', ?, GETDATE(), GETDATE(), ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(insertQuery)) {
            ps.setString(1, messageId);
            ps.setString(2, content);
            ps.setString(3, conversationId);
            ps.setString(4, senderId);
            ps.setString(5, "00000000-0000-0000-0000-000000000000"); // Default LastModifierId
            
            int result = ps.executeUpdate();
            if (result > 0) {
                return getMessageById(messageId);
            }
        }
        
        return null;
    }

    private ChatMessages getMessageById(String messageId) throws SQLException {
        String query = """
            SELECT cm.Id, cm.Content, cm.Status, cm.ConversationId, cm.CreationTime, cm.LastModificationTime, cm.CreatorId, cm.LastModifierId,
                   u.UserName, u.FullName, u.AvatarUrl
            FROM ChatMessages cm
            INNER JOIN Users u ON cm.CreatorId = u.Id
            WHERE cm.Id = ?
            """;
        
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, messageId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                ChatMessages message = new ChatMessages();
                message.setId(rs.getString("Id"));
                message.setContent(rs.getString("Content"));
                message.setStatus(rs.getString("Status"));
                message.setCreationTime(rs.getTimestamp("CreationTime"));
                message.setLastModificationTime(rs.getTimestamp("LastModificationTime"));
                message.setLastModifierId(rs.getString("LastModifierId"));
                
                // Create and set Users object
                Users sender = new Users();
                sender.setId(rs.getString("CreatorId"));
                sender.setUserName(rs.getString("UserName"));
                sender.setFullName(rs.getString("FullName"));
                sender.setAvatarUrl(rs.getString("AvatarUrl"));
                message.setCreatorId(sender);
                
                return message;
            }
        }
        
        return null;
    }

    @Override
    public List<ChatMessages> getMessageHistory(String conversationId, int limit) throws SQLException {
        List<ChatMessages> messages = new ArrayList<>();
        String query = """
            SELECT TOP (?) cm.Id, cm.Content, cm.Status, cm.ConversationId, cm.CreationTime, cm.LastModificationTime, cm.CreatorId, cm.LastModifierId,
                   u.UserName, u.FullName, u.AvatarUrl
            FROM ChatMessages cm
            INNER JOIN Users u ON cm.CreatorId = u.Id
            WHERE cm.ConversationId = ?
            ORDER BY cm.CreationTime DESC
            """;
        
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, limit);
            ps.setString(2, conversationId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ChatMessages message = new ChatMessages();
                message.setId(rs.getString("Id"));
                message.setContent(rs.getString("Content"));
                message.setStatus(rs.getString("Status"));
                message.setCreationTime(rs.getTimestamp("CreationTime"));
                message.setLastModificationTime(rs.getTimestamp("LastModificationTime"));
                message.setLastModifierId(rs.getString("LastModifierId"));
                
                Users sender = new Users();
                sender.setId(rs.getString("CreatorId"));
                sender.setUserName(rs.getString("UserName"));
                sender.setFullName(rs.getString("FullName"));
                sender.setAvatarUrl(rs.getString("AvatarUrl"));
                message.setCreatorId(sender);
                
                messages.add(message);
            }
        }
        
        // Reverse để có thứ tự từ cũ đến mới
        java.util.Collections.reverse(messages);
        return messages;
    }

    @Override
    public boolean isUserInConversation(String userId, String conversationId) throws SQLException {
        String query = "SELECT COUNT(*) FROM ConversationMembers WHERE CreatorId = ? AND ConversationId = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, userId);
            ps.setString(2, conversationId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    @Override
    public Conversations getConversationById(String conversationId) throws SQLException {
        String query = "SELECT Id, Title, IsPrivate, AvatarUrl, CreationTime, CreatorId FROM Conversations WHERE Id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, conversationId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Conversations conv = new Conversations();
                conv.setId(rs.getString("Id"));
                conv.setTitle(rs.getString("Title"));
                conv.setIsPrivate(rs.getBoolean("IsPrivate"));
                conv.setAvatarUrl(rs.getString("AvatarUrl"));
                conv.setCreationTime(rs.getTimestamp("CreationTime"));
                return conv;
            }
        }
        return null;
    }

    @Override
    public Conversations getConversationByCourseId(String courseId) throws SQLException {
        String query = "SELECT Id, Title, IsPrivate, AvatarUrl, CreationTime, CreatorId FROM Conversations WHERE Title LIKE ? AND IsPrivate = 0";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, "%[CourseId:" + courseId + "]");
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Conversations conv = new Conversations();
                conv.setId(rs.getString("Id"));
                conv.setTitle(rs.getString("Title"));
                conv.setIsPrivate(rs.getBoolean("IsPrivate"));
                conv.setAvatarUrl(rs.getString("AvatarUrl"));
                conv.setCreationTime(rs.getTimestamp("CreationTime"));
                return conv;
            }
        }
        return null;
    }
}