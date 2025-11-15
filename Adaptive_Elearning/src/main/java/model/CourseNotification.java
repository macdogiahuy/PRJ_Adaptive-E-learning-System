package model;

import java.io.Serializable;
import java.util.Date;

/**
 * Model class for Course Notification
 * Represents notifications for course approval/rejection
 * @author LP
 */
public class CourseNotification implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    private String id;
    private String courseId;
    private String instructorId;
    private String instructorName;
    private String courseTitle;
    private double coursePrice;
    private String notificationType;  // course_pending, course_approved, course_rejected
    private String status;  // pending, approved, rejected
    private String rejectionReason;
    private Date creationTime;
    private Date processedTime;
    private String processedBy;
    
    // Additional course info for display
    private String thumbUrl;
    private String level;
    private String description;

    public CourseNotification() {
    }

    public CourseNotification(String id) {
        this.id = id;
    }

    public CourseNotification(String id, String courseId, String instructorId, String instructorName, 
                            String courseTitle, double coursePrice, String notificationType, 
                            String status, Date creationTime) {
        this.id = id;
        this.courseId = courseId;
        this.instructorId = instructorId;
        this.instructorName = instructorName;
        this.courseTitle = courseTitle;
        this.coursePrice = coursePrice;
        this.notificationType = notificationType;
        this.status = status;
        this.creationTime = creationTime;
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    public String getInstructorId() {
        return instructorId;
    }

    public void setInstructorId(String instructorId) {
        this.instructorId = instructorId;
    }

    public String getInstructorName() {
        return instructorName;
    }

    public void setInstructorName(String instructorName) {
        this.instructorName = instructorName;
    }

    public String getCourseTitle() {
        return courseTitle;
    }

    public void setCourseTitle(String courseTitle) {
        this.courseTitle = courseTitle;
    }

    public double getCoursePrice() {
        return coursePrice;
    }

    public void setCoursePrice(double coursePrice) {
        this.coursePrice = coursePrice;
    }

    public String getNotificationType() {
        return notificationType;
    }

    public void setNotificationType(String notificationType) {
        this.notificationType = notificationType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public Date getProcessedTime() {
        return processedTime;
    }

    public void setProcessedTime(Date processedTime) {
        this.processedTime = processedTime;
    }

    public String getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(String processedBy) {
        this.processedBy = processedBy;
    }

    public String getThumbUrl() {
        return thumbUrl;
    }

    public void setThumbUrl(String thumbUrl) {
        this.thumbUrl = thumbUrl;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof CourseNotification)) {
            return false;
        }
        CourseNotification other = (CourseNotification) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "CourseNotification{" +
                "id=" + id +
                ", courseTitle='" + courseTitle + '\'' +
                ", instructorName='" + instructorName + '\'' +
                ", status='" + status + '\'' +
                ", creationTime=" + creationTime +
                '}';
    }
}
