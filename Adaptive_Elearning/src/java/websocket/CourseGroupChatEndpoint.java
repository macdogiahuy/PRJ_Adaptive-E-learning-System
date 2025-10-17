package websocket;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import controller.ChatController;
import model.ChatMessages;
import model.Users;

import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.List;

/**
 * WebSocket Server Endpoint cho Chat Group Member của khóa học
 * Endpoint: /chat/{conversationId}
 */
@ServerEndpoint("/chat/{conversationId}")
public class CourseGroupChatEndpoint {
    
    // Map lưu trữ các session theo conversationId
    private static final ConcurrentHashMap<String, CopyOnWriteArraySet<Session>> conversationSessions = new ConcurrentHashMap<>();
    
    // Map lưu trữ thông tin user theo sessionId
    private static final ConcurrentHashMap<String, String> sessionUsers = new ConcurrentHashMap<>();
    
    private ChatController chatController;
    private Gson gson;
    
    public CourseGroupChatEndpoint() {
        this.chatController = new ChatController();
        this.gson = new Gson();
    }
    
    @OnOpen
    public void onOpen(Session session, @PathParam("conversationId") String conversationId) {
        try {
            // Lấy userId từ session parameters hoặc headers
            String userId = getUserIdFromSession(session);
            
            if (userId == null) {
                session.close(new CloseReason(CloseReason.CloseCodes.CANNOT_ACCEPT, "User not authenticated"));
                return;
            }
            
            // Kiểm tra user có quyền truy cập conversation không
            if (!chatController.validateUserAccess(userId, conversationId)) {
                session.close(new CloseReason(CloseReason.CloseCodes.CANNOT_ACCEPT, "Access denied"));
                return;
            }
            
            // Thêm session vào conversation
            conversationSessions.computeIfAbsent(conversationId, k -> new CopyOnWriteArraySet<>()).add(session);
            sessionUsers.put(session.getId(), userId);
            
            // Gửi thông báo user joined
            broadcastUserJoined(conversationId, userId, session);
            
            // Gửi lịch sử tin nhắn cho user mới kết nối
            sendMessageHistory(session, conversationId);
            
            System.out.println("User " + userId + " joined conversation " + conversationId);
            
        } catch (Exception e) {
            e.printStackTrace();
            try {
                session.close(new CloseReason(CloseReason.CloseCodes.UNEXPECTED_CONDITION, "Server error"));
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    @OnMessage
    public void onMessage(String message, Session session, @PathParam("conversationId") String conversationId) {
        try {
            String userId = sessionUsers.get(session.getId());
            if (userId == null) {
                return;
            }
            
            // Parse message JSON
            JsonObject messageObj = gson.fromJson(message, JsonObject.class);
            String type = messageObj.get("type").getAsString();
            
            switch (type) {
                case "CHAT_MESSAGE":
                    handleChatMessage(messageObj, conversationId, userId);
                    break;
                case "TYPING":
                    handleTyping(messageObj, conversationId, userId, session);
                    break;
                case "STOP_TYPING":
                    handleStopTyping(messageObj, conversationId, userId, session);
                    break;
                default:
                    System.out.println("Unknown message type: " + type);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @OnClose
    public void onClose(Session session, @PathParam("conversationId") String conversationId) {
        try {
            String userId = sessionUsers.remove(session.getId());
            
            CopyOnWriteArraySet<Session> sessions = conversationSessions.get(conversationId);
            if (sessions != null) {
                sessions.remove(session);
                if (sessions.isEmpty()) {
                    conversationSessions.remove(conversationId);
                }
            }
            
            // Thông báo user left
            if (userId != null) {
                broadcastUserLeft(conversationId, userId);
                System.out.println("User " + userId + " left conversation " + conversationId);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @OnError
    public void onError(Session session, Throwable error) {
        error.printStackTrace();
        try {
            session.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    private void handleChatMessage(JsonObject messageObj, String conversationId, String userId) {
        try {
            String content = messageObj.get("content").getAsString();
            
            // Lưu tin nhắn vào database
            ChatMessages savedMessage = chatController.sendMessage(conversationId, userId, content);
            
            if (savedMessage != null) {
                // Broadcast tin nhắn đến tất cả members
                JsonObject broadcastMsg = new JsonObject();
                broadcastMsg.addProperty("type", "NEW_MESSAGE");
                broadcastMsg.addProperty("messageId", savedMessage.getId());
                broadcastMsg.addProperty("content", savedMessage.getContent());
                broadcastMsg.addProperty("senderId", userId);
                broadcastMsg.addProperty("timestamp", savedMessage.getCreationTime().getTime());
                broadcastMsg.addProperty("status", savedMessage.getStatus());
                
                // Thêm thông tin sender nếu có
                // Note: Cần implement getUserInfo để lấy thông tin chi tiết
                
                broadcastToConversation(conversationId, broadcastMsg.toString());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void handleTyping(JsonObject messageObj, String conversationId, String userId, Session senderSession) {
        try {
            JsonObject typingMsg = new JsonObject();
            typingMsg.addProperty("type", "USER_TYPING");
            typingMsg.addProperty("userId", userId);
            
            broadcastToConversationExcept(conversationId, typingMsg.toString(), senderSession);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void handleStopTyping(JsonObject messageObj, String conversationId, String userId, Session senderSession) {
        try {
            JsonObject stopTypingMsg = new JsonObject();
            stopTypingMsg.addProperty("type", "USER_STOP_TYPING");
            stopTypingMsg.addProperty("userId", userId);
            
            broadcastToConversationExcept(conversationId, stopTypingMsg.toString(), senderSession);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void sendMessageHistory(Session session, String conversationId) {
        try {
            List<ChatMessages> messages = chatController.getMessageHistory(conversationId, 50);
            
            if (messages != null && !messages.isEmpty()) {
                JsonObject historyMsg = new JsonObject();
                historyMsg.addProperty("type", "MESSAGE_HISTORY");
                historyMsg.add("messages", gson.toJsonTree(messages));
                
                session.getBasicRemote().sendText(historyMsg.toString());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void broadcastUserJoined(String conversationId, String userId, Session newSession) {
        try {
            JsonObject joinMsg = new JsonObject();
            joinMsg.addProperty("type", "USER_JOINED");
            joinMsg.addProperty("userId", userId);
            
            broadcastToConversationExcept(conversationId, joinMsg.toString(), newSession);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void broadcastUserLeft(String conversationId, String userId) {
        try {
            JsonObject leftMsg = new JsonObject();
            leftMsg.addProperty("type", "USER_LEFT");
            leftMsg.addProperty("userId", userId);
            
            broadcastToConversation(conversationId, leftMsg.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void broadcastToConversation(String conversationId, String message) {
        CopyOnWriteArraySet<Session> sessions = conversationSessions.get(conversationId);
        if (sessions != null) {
            for (Session session : sessions) {
                try {
                    if (session.isOpen()) {
                        session.getBasicRemote().sendText(message);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                    sessions.remove(session);
                }
            }
        }
    }
    
    private void broadcastToConversationExcept(String conversationId, String message, Session exceptSession) {
        CopyOnWriteArraySet<Session> sessions = conversationSessions.get(conversationId);
        if (sessions != null) {
            for (Session session : sessions) {
                if (!session.equals(exceptSession)) {
                    try {
                        if (session.isOpen()) {
                            session.getBasicRemote().sendText(message);
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                        sessions.remove(session);
                    }
                }
            }
        }
    }
    
    private String getUserIdFromSession(Session session) {
        // Lấy userId từ session parameters
        String userId = session.getRequestParameterMap().get("userId") != null ? 
                       session.getRequestParameterMap().get("userId").get(0) : null;
        
        if (userId == null) {
            // Hoặc lấy từ HTTP session thông qua HttpSession
            // Cần implement authentication mechanism
            // userId = (String) session.getUserProperties().get("userId");
        }
        
        return userId;
    }
}