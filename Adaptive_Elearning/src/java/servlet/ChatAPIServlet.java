package servlet;

import controller.ChatController;
import model.ChatMessages;
import model.Conversations;
import model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * Servlet API cho Chat Group Member của khóa học
 * Cung cấp các endpoint REST cho chức năng chat
 */
@WebServlet("/api/chat/*")
public class ChatAPIServlet extends HttpServlet {
    
    private ChatController chatController;
    
    @Override
    public void init() throws ServletException {
        this.chatController = new ChatController();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null) {
                response.setStatus(400);
                out.print("{\"error\":\"Invalid path\"}");
                return;
            }
            
            String[] pathParts = pathInfo.split("/");
            
            switch (pathParts[1]) {
                case "conversations":
                    handleGetConversations(request, response, pathParts);
                    break;
                case "messages":
                    handleGetMessages(request, response, pathParts);
                    break;
                case "members":
                    handleGetMembers(request, response, pathParts);
                    break;
                default:
                    response.setStatus(404);
                    out.print("{\"error\":\"Endpoint not found\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            out.print("{\"error\":\"Internal server error\"}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null) {
                response.setStatus(400);
                out.print("{\"error\":\"Invalid path\"}");
                return;
            }
            
            String[] pathParts = pathInfo.split("/");
            
            switch (pathParts[1]) {
                case "send":
                    handleSendMessage(request, response);
                    break;
                case "join":
                    handleJoinCourse(request, response);
                    break;
                default:
                    response.setStatus(404);
                    out.print("{\"error\":\"Endpoint not found\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            out.print("{\"error\":\"Internal server error\"}");
        }
    }
    
    /**
     * GET /api/chat/conversations - Lấy danh sách conversations của user
     */
    private void handleGetConversations(HttpServletRequest request, HttpServletResponse response, String[] pathParts) 
            throws IOException {
        
        String userId = request.getParameter("userId");
        if (userId == null) {
            response.setStatus(400);
            response.getWriter().print("{\"error\":\"UserId is required\"}");
            return;
        }
        
        List<Conversations> conversations = chatController.getUserCourseGroups(userId);
        
        if (conversations != null) {
            StringBuilder json = new StringBuilder();
            json.append("{\"conversations\":[");
            
            for (int i = 0; i < conversations.size(); i++) {
                Conversations conv = conversations.get(i);
                json.append("{");
                json.append("\"id\":\"").append(conv.getId()).append("\",");
                json.append("\"title\":\"").append(escapeJson(conv.getTitle())).append("\",");
                json.append("\"avatarUrl\":\"").append(escapeJson(conv.getAvatarUrl())).append("\",");
                json.append("\"isPrivate\":").append(conv.getIsPrivate()).append(",");
                json.append("\"creationTime\":").append(conv.getCreationTime().getTime());
                json.append("}");
                
                if (i < conversations.size() - 1) {
                    json.append(",");
                }
            }
            
            json.append("]}");
            response.getWriter().print(json.toString());
        } else {
            response.setStatus(500);
            response.getWriter().print("{\"error\":\"Failed to fetch conversations\"}");
        }
    }
    
    /**
     * GET /api/chat/messages/{conversationId} - Lấy lịch sử tin nhắn
     */
    private void handleGetMessages(HttpServletRequest request, HttpServletResponse response, String[] pathParts) 
            throws IOException {
        
        if (pathParts.length < 3) {
            response.setStatus(400);
            response.getWriter().print("{\"error\":\"ConversationId is required\"}");
            return;
        }
        
        String conversationId = pathParts[2];
        String limitStr = request.getParameter("limit");
        int limit = limitStr != null ? Integer.parseInt(limitStr) : 50;
        
        List<ChatMessages> messages = chatController.getMessageHistory(conversationId, limit);
        
        if (messages != null) {
            StringBuilder json = new StringBuilder();
            json.append("{\"messages\":[");
            
            for (int i = 0; i < messages.size(); i++) {
                ChatMessages msg = messages.get(i);
                json.append("{");
                json.append("\"id\":\"").append(msg.getId()).append("\",");
                json.append("\"content\":\"").append(escapeJson(msg.getContent())).append("\",");
                json.append("\"senderId\":\"").append(msg.getCreatorId()).append("\",");
                json.append("\"status\":\"").append(msg.getStatus()).append("\",");
                json.append("\"timestamp\":").append(msg.getCreationTime().getTime());
                json.append("}");
                
                if (i < messages.size() - 1) {
                    json.append(",");
                }
            }
            
            json.append("]}");
            response.getWriter().print(json.toString());
        } else {
            response.setStatus(500);
            response.getWriter().print("{\"error\":\"Failed to fetch messages\"}");
        }
    }
    
    /**
     * GET /api/chat/members/{conversationId} - Lấy danh sách members
     */
    private void handleGetMembers(HttpServletRequest request, HttpServletResponse response, String[] pathParts) 
            throws IOException {
        
        if (pathParts.length < 3) {
            response.setStatus(400);
            response.getWriter().print("{\"error\":\"ConversationId is required\"}");
            return;
        }
        
        String conversationId = pathParts[2];
        List<Users> members = chatController.getConversationMembers(conversationId);
        
        if (members != null) {
            StringBuilder json = new StringBuilder();
            json.append("{\"members\":[");
            
            for (int i = 0; i < members.size(); i++) {
                Users user = members.get(i);
                json.append("{");
                json.append("\"id\":\"").append(user.getId()).append("\",");
                json.append("\"userName\":\"").append(escapeJson(user.getUserName())).append("\",");
                json.append("\"fullName\":\"").append(escapeJson(user.getFullName())).append("\",");
                json.append("\"email\":\"").append(escapeJson(user.getEmail())).append("\",");
                json.append("\"avatarUrl\":\"").append(escapeJson(user.getAvatarUrl() != null ? user.getAvatarUrl() : "")).append("\"");
                json.append("}");
                
                if (i < members.size() - 1) {
                    json.append(",");
                }
            }
            
            json.append("]}");
            response.getWriter().print(json.toString());
        } else {
            response.setStatus(500);
            response.getWriter().print("{\"error\":\"Failed to fetch members\"}");
        }
    }
    
    /**
     * POST /api/chat/send - Gửi tin nhắn
     */
    private void handleSendMessage(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String conversationId = request.getParameter("conversationId");
        String senderId = request.getParameter("senderId");
        String content = request.getParameter("content");
        
        if (conversationId == null || senderId == null || content == null) {
            response.setStatus(400);
            response.getWriter().print("{\"error\":\"Missing required parameters\"}");
            return;
        }
        
        // Kiểm tra quyền truy cập
        if (!chatController.validateUserAccess(senderId, conversationId)) {
            response.setStatus(403);
            response.getWriter().print("{\"error\":\"Access denied\"}");
            return;
        }
        
        ChatMessages sentMessage = chatController.sendMessage(conversationId, senderId, content);
        
        if (sentMessage != null) {
            StringBuilder json = new StringBuilder();
            json.append("{\"success\":true,\"message\":{");
            json.append("\"id\":\"").append(sentMessage.getId()).append("\",");
            json.append("\"content\":\"").append(escapeJson(sentMessage.getContent())).append("\",");
            json.append("\"senderId\":\"").append(senderId).append("\",");
            json.append("\"status\":\"").append(sentMessage.getStatus()).append("\",");
            json.append("\"timestamp\":").append(sentMessage.getCreationTime().getTime());
            json.append("}}");
            
            response.getWriter().print(json.toString());
        } else {
            response.setStatus(500);
            response.getWriter().print("{\"error\":\"Failed to send message\"}");
        }
    }
    
    /**
     * POST /api/chat/join - Tự động join vào course group khi enroll
     */
    private void handleJoinCourse(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String userId = request.getParameter("userId");
        String courseId = request.getParameter("courseId");
        
        if (userId == null || courseId == null) {
            response.setStatus(400);
            response.getWriter().print("{\"error\":\"Missing required parameters\"}");
            return;
        }
        
        boolean success = chatController.handleCourseEnrollment(userId, courseId);
        
        if (success) {
            // Lấy thông tin conversation vừa join
            Conversations conversation = chatController.getCourseConversation(courseId);
            
            if (conversation != null) {
                StringBuilder json = new StringBuilder();
                json.append("{\"success\":true,\"conversation\":{");
                json.append("\"id\":\"").append(conversation.getId()).append("\",");
                json.append("\"title\":\"").append(escapeJson(conversation.getTitle())).append("\",");
                json.append("\"avatarUrl\":\"").append(escapeJson(conversation.getAvatarUrl())).append("\"");
                json.append("}}");
                
                response.getWriter().print(json.toString());
            } else {
                response.getWriter().print("{\"success\":true}");
            }
        } else {
            response.setStatus(500);
            response.getWriter().print("{\"error\":\"Failed to join course group\"}");
        }
    }
    
    /**
     * Escape JSON strings để tránh lỗi syntax
     */
    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}