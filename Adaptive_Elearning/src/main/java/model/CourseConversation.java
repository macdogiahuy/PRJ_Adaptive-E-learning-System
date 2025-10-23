package model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Course Chat Conversation Model
 * Represents a group chat for a specific course
 */
public class CourseConversation {
    private UUID id;
    private String title;
    private boolean isPrivate;
    private String avatarUrl;
    private LocalDateTime creationTime;
    private UUID creatorId;
    private UUID courseId; // Link to course
    
    // Additional info for display
    private String courseName;
    private int memberCount;
    private String lastMessage;
    private LocalDateTime lastMessageTime;
    
    // Default constructor
    public CourseConversation() {
        this.id = UUID.randomUUID();
        this.creationTime = LocalDateTime.now();
        this.isPrivate = false; // Course chats are group chats
    }
    
    // Constructor for course chat
    public CourseConversation(String title, UUID courseId, UUID creatorId) {
        this();
        this.title = title;
        this.courseId = courseId;
        this.creatorId = creatorId;
        this.avatarUrl = "/assets/images/default-course-chat.png";
    }
    
    // Getters and Setters
    public UUID getId() {
        return id;
    }
    
    public void setId(UUID id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public boolean isPrivate() {
        return isPrivate;
    }
    
    public void setPrivate(boolean isPrivate) {
        this.isPrivate = isPrivate;
    }
    
    public String getAvatarUrl() {
        return avatarUrl;
    }
    
    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }
    
    public LocalDateTime getCreationTime() {
        return creationTime;
    }
    
    public void setCreationTime(LocalDateTime creationTime) {
        this.creationTime = creationTime;
    }
    
    public UUID getCreatorId() {
        return creatorId;
    }
    
    public void setCreatorId(UUID creatorId) {
        this.creatorId = creatorId;
    }
    
    public UUID getCourseId() {
        return courseId;
    }
    
    public void setCourseId(UUID courseId) {
        this.courseId = courseId;
    }
    
    public String getCourseName() {
        return courseName;
    }
    
    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }
    
    public int getMemberCount() {
        return memberCount;
    }
    
    public void setMemberCount(int memberCount) {
        this.memberCount = memberCount;
    }
    
    public String getLastMessage() {
        return lastMessage;
    }
    
    public void setLastMessage(String lastMessage) {
        this.lastMessage = lastMessage;
    }
    
    public LocalDateTime getLastMessageTime() {
        return lastMessageTime;
    }
    
    public void setLastMessageTime(LocalDateTime lastMessageTime) {
        this.lastMessageTime = lastMessageTime;
    }
    
    @Override
    public String toString() {
        return "CourseConversation{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", courseId=" + courseId +
                ", memberCount=" + memberCount +
                ", creationTime=" + creationTime +
                '}';
    }
}