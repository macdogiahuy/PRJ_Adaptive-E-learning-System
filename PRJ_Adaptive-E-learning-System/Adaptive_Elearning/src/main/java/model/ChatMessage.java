package model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Chat Message Model
 * Represents a message in course group chat
 */
public class ChatMessage {
    private UUID id;
    private String content;
    private String status;
    private UUID conversationId;
    private LocalDateTime creationTime;
    private LocalDateTime lastModificationTime;
    private UUID creatorId;
    private UUID lastModifierId;
    
    // User information for display
    private String senderName;
    private String senderAvatarUrl;
    
    // Default constructor
    public ChatMessage() {
        this.id = UUID.randomUUID();
        this.creationTime = LocalDateTime.now();
        this.lastModificationTime = LocalDateTime.now();
        this.status = "Active";
    }
    
    // Constructor with essential fields
    public ChatMessage(String content, UUID conversationId, UUID creatorId) {
        this();
        this.content = content;
        this.conversationId = conversationId;
        this.creatorId = creatorId;
        this.lastModifierId = creatorId;
    }
    
    // Getters and Setters
    public UUID getId() {
        return id;
    }
    
    public void setId(UUID id) {
        this.id = id;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public UUID getConversationId() {
        return conversationId;
    }
    
    public void setConversationId(UUID conversationId) {
        this.conversationId = conversationId;
    }
    
    public LocalDateTime getCreationTime() {
        return creationTime;
    }
    
    public void setCreationTime(LocalDateTime creationTime) {
        this.creationTime = creationTime;
    }
    
    public LocalDateTime getLastModificationTime() {
        return lastModificationTime;
    }
    
    public void setLastModificationTime(LocalDateTime lastModificationTime) {
        this.lastModificationTime = lastModificationTime;
    }
    
    public UUID getCreatorId() {
        return creatorId;
    }
    
    public void setCreatorId(UUID creatorId) {
        this.creatorId = creatorId;
    }
    
    public UUID getLastModifierId() {
        return lastModifierId;
    }
    
    public void setLastModifierId(UUID lastModifierId) {
        this.lastModifierId = lastModifierId;
    }
    
    public String getSenderName() {
        return senderName;
    }
    
    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }
    
    public String getSenderAvatarUrl() {
        return senderAvatarUrl;
    }
    
    public void setSenderAvatarUrl(String senderAvatarUrl) {
        this.senderAvatarUrl = senderAvatarUrl;
    }
    
    @Override
    public String toString() {
        return "ChatMessage{" +
                "id=" + id +
                ", content='" + content + '\'' +
                ", conversationId=" + conversationId +
                ", creatorId=" + creatorId +
                ", senderName='" + senderName + '\'' +
                ", creationTime=" + creationTime +
                '}';
    }
}