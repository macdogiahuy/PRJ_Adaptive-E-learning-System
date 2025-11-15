package dao;

import model.ChatMessage;
import model.CourseConversation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Data Access Object for Course Chat functionality
 */
public class CourseChatDAO {
    
    /**
     * Create or get existing course conversation
     */
    public CourseConversation getOrCreateCourseConversation(UUID courseId) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            // First try to find existing conversation for this course
            String selectSql = """
                SELECT c.Id, c.Title, c.IsPrivate, c.AvatarUrl, c.CreationTime, c.CreatorId,
                       co.Title as CourseName,
                       (SELECT COUNT(*) FROM ConversationMembers cm WHERE cm.ConversationId = c.Id) as MemberCount
                FROM Conversations c
                INNER JOIN Courses co ON co.Id = ?
                WHERE c.Title = CONCAT('Course Chat - ', co.Title)
                """;
            
            stmt = connection.prepareStatement(selectSql);
            stmt.setString(1, courseId.toString());
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                // Conversation exists, return it
                CourseConversation conversation = new CourseConversation();
                conversation.setId(UUID.fromString(rs.getString("Id")));
                conversation.setTitle(rs.getString("Title"));
                conversation.setPrivate(rs.getBoolean("IsPrivate"));
                conversation.setAvatarUrl(rs.getString("AvatarUrl"));
                conversation.setCreationTime(rs.getTimestamp("CreationTime").toLocalDateTime());
                conversation.setCreatorId(UUID.fromString(rs.getString("CreatorId")));
                conversation.setCourseId(courseId);
                conversation.setCourseName(rs.getString("CourseName"));
                conversation.setMemberCount(rs.getInt("MemberCount"));
                
                return conversation;
            }
            
            rs.close();
            stmt.close();
            
            // Conversation doesn't exist, create it
            String courseTitleSql = "SELECT Title FROM Courses WHERE Id = ?";
            stmt = connection.prepareStatement(courseTitleSql);
            stmt.setString(1, courseId.toString());
            rs = stmt.executeQuery();
            
            String courseTitle = "Unknown Course";
            if (rs.next()) {
                courseTitle = rs.getString("Title");
            }
            
            rs.close();
            stmt.close();
            
            // Create new conversation
            UUID conversationId = UUID.randomUUID();
            String conversationTitle = "Course Chat - " + courseTitle;
            
            String insertSql = """
                INSERT INTO Conversations (Id, Title, IsPrivate, AvatarUrl, CreationTime, CreatorId)
                VALUES (?, ?, 0, ?, GETDATE(), ?)
                """;
            
            stmt = connection.prepareStatement(insertSql);
            stmt.setString(1, conversationId.toString());
            stmt.setString(2, conversationTitle);
            stmt.setString(3, "/assets/images/default-course-chat.png");
            stmt.setString(4, "00000000-0000-0000-0000-000000000000"); // System user
            
            int result = stmt.executeUpdate();
            
            if (result > 0) {
                CourseConversation conversation = new CourseConversation();
                conversation.setId(conversationId);
                conversation.setTitle(conversationTitle);
                conversation.setCourseId(courseId);
                conversation.setCourseName(courseTitle);
                return conversation;
            }
            
            return null;
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    /**
     * Add user to course conversation if enrolled in course
     */
    public boolean addUserToCourseConversation(UUID userId, UUID courseId) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            // Check if user is enrolled in the course
            String checkEnrollmentSql = "SELECT COUNT(*) FROM Enrollments WHERE CreatorId = ? AND CourseId = ?";
            stmt = connection.prepareStatement(checkEnrollmentSql);
            stmt.setString(1, userId.toString());
            stmt.setString(2, courseId.toString());
            rs = stmt.executeQuery();
            
            if (!rs.next() || rs.getInt(1) == 0) {
                return false; // User not enrolled in course
            }
            
            rs.close();
            stmt.close();
            
            // Get or create conversation
            CourseConversation conversation = getOrCreateCourseConversation(courseId);
            if (conversation == null) {
                return false;
            }
            
            // Check if user is already in the conversation
            String checkMemberSql = "SELECT COUNT(*) FROM ConversationMembers WHERE CreatorId = ? AND ConversationId = ?";
            stmt = connection.prepareStatement(checkMemberSql);
            stmt.setString(1, userId.toString());
            stmt.setString(2, conversation.getId().toString());
            rs = stmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                return true; // Already a member
            }
            
            rs.close();
            stmt.close();
            
            // Add user to conversation
            String addMemberSql = """
                INSERT INTO ConversationMembers (CreatorId, ConversationId, IsAdmin, LastVisit, CreationTime)
                VALUES (?, ?, 0, GETDATE(), GETDATE())
                """;
            
            stmt = connection.prepareStatement(addMemberSql);
            stmt.setString(1, userId.toString());
            stmt.setString(2, conversation.getId().toString());
            
            return stmt.executeUpdate() > 0;
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    /**
     * Get recent messages for a course conversation
     */
    public List<ChatMessage> getCourseMessages(UUID courseId, int limit) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<ChatMessage> messages = new ArrayList<>();
        
        try {
            connection = DBConnection.getConnection();
            
            String sql = """
                SELECT TOP (?) cm.Id, cm.Content, cm.Status, cm.ConversationId, 
                       cm.CreationTime, cm.LastModificationTime, cm.CreatorId, cm.LastModifierId,
                       u.FullName as SenderName, u.AvatarUrl as SenderAvatarUrl
                FROM ChatMessages cm
                INNER JOIN Conversations c ON c.Id = cm.ConversationId
                INNER JOIN Users u ON u.Id = cm.CreatorId
                INNER JOIN Courses co ON co.Id = ?
                WHERE c.Title = CONCAT('Course Chat - ', co.Title)
                ORDER BY cm.CreationTime DESC
                """;
            
            stmt = connection.prepareStatement(sql);
            stmt.setInt(1, limit);
            stmt.setString(2, courseId.toString());
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                ChatMessage message = new ChatMessage();
                message.setId(UUID.fromString(rs.getString("Id")));
                message.setContent(rs.getString("Content"));
                message.setStatus(rs.getString("Status"));
                message.setConversationId(UUID.fromString(rs.getString("ConversationId")));
                message.setCreationTime(rs.getTimestamp("CreationTime").toLocalDateTime());
                message.setLastModificationTime(rs.getTimestamp("LastModificationTime").toLocalDateTime());
                message.setCreatorId(UUID.fromString(rs.getString("CreatorId")));
                message.setLastModifierId(UUID.fromString(rs.getString("LastModifierId")));
                message.setSenderName(rs.getString("SenderName"));
                message.setSenderAvatarUrl(rs.getString("SenderAvatarUrl"));
                
                messages.add(message);
            }
            
            // Reverse to get chronological order
            List<ChatMessage> chronologicalMessages = new ArrayList<>();
            for (int i = messages.size() - 1; i >= 0; i--) {
                chronologicalMessages.add(messages.get(i));
            }
            
            return chronologicalMessages;
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    /**
     * Save a new chat message
     */
    public boolean saveMessage(ChatMessage message) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        
        try {
            connection = DBConnection.getConnection();
            
            String sql = """
                INSERT INTO ChatMessages (Id, Content, Status, ConversationId, CreationTime, 
                                        LastModificationTime, CreatorId, LastModifierId)
                VALUES (?, ?, ?, ?, GETDATE(), GETDATE(), ?, ?)
                """;
            
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, message.getId().toString());
            stmt.setString(2, message.getContent());
            stmt.setString(3, message.getStatus());
            stmt.setString(4, message.getConversationId().toString());
            stmt.setString(5, message.getCreatorId().toString());
            stmt.setString(6, message.getLastModifierId().toString());
            
            return stmt.executeUpdate() > 0;
            
        } finally {
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    /**
     * Get conversation ID for a course
     */
    public UUID getCourseConversationId(UUID courseId) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            String sql = """
                SELECT c.Id
                FROM Conversations c
                INNER JOIN Courses co ON co.Id = ?
                WHERE c.Title = CONCAT('Course Chat - ', co.Title)
                """;
            
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, courseId.toString());
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return UUID.fromString(rs.getString("Id"));
            }
            
            return null;
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    /**
     * Check if user is member of course conversation
     */
    public boolean isUserMemberOfCourseChat(UUID userId, UUID courseId) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            
            String sql = """
                SELECT COUNT(*)
                FROM ConversationMembers cm
                INNER JOIN Conversations c ON c.Id = cm.ConversationId
                INNER JOIN Courses co ON co.Id = ?
                WHERE cm.CreatorId = ? AND c.Title = CONCAT('Course Chat - ', co.Title)
                """;
            
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, courseId.toString());
            stmt.setString(2, userId.toString());
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
            return false;
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
    
    /**
     * Get user's enrolled course conversations
     */
    public List<CourseConversation> getUserCourseConversations(UUID userId) throws SQLException {
        Connection connection = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<CourseConversation> conversations = new ArrayList<>();
        
        try {
            connection = DBConnection.getConnection();
            
            String sql = """
                SELECT DISTINCT c.Id, c.Title, c.IsPrivate, c.AvatarUrl, c.CreationTime, c.CreatorId,
                       co.Id as CourseId, co.Title as CourseName,
                       (SELECT COUNT(*) FROM ConversationMembers cm WHERE cm.ConversationId = c.Id) as MemberCount,
                       (SELECT TOP 1 msg.Content FROM ChatMessages msg WHERE msg.ConversationId = c.Id ORDER BY msg.CreationTime DESC) as LastMessage,
                       (SELECT TOP 1 msg.CreationTime FROM ChatMessages msg WHERE msg.ConversationId = c.Id ORDER BY msg.CreationTime DESC) as LastMessageTime
                FROM Conversations c
                INNER JOIN Courses co ON c.Title = CONCAT('Course Chat - ', co.Title)
                INNER JOIN Enrollments e ON e.CourseId = co.Id
                WHERE e.CreatorId = ?
                ORDER BY LastMessageTime DESC, c.CreationTime DESC
                """;
            
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, userId.toString());
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                CourseConversation conversation = new CourseConversation();
                conversation.setId(UUID.fromString(rs.getString("Id")));
                conversation.setTitle(rs.getString("Title"));
                conversation.setPrivate(rs.getBoolean("IsPrivate"));
                conversation.setAvatarUrl(rs.getString("AvatarUrl"));
                conversation.setCreationTime(rs.getTimestamp("CreationTime").toLocalDateTime());
                conversation.setCreatorId(UUID.fromString(rs.getString("CreatorId")));
                conversation.setCourseId(UUID.fromString(rs.getString("CourseId")));
                conversation.setCourseName(rs.getString("CourseName"));
                conversation.setMemberCount(rs.getInt("MemberCount"));
                conversation.setLastMessage(rs.getString("LastMessage"));
                
                Timestamp lastMessageTime = rs.getTimestamp("LastMessageTime");
                if (lastMessageTime != null) {
                    conversation.setLastMessageTime(lastMessageTime.toLocalDateTime());
                }
                
                conversations.add(conversation);
            }
            
            return conversations;
            
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        }
    }
}