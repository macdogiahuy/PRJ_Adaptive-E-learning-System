package model;

import java.sql.Timestamp;
import java.util.Date;

public class EnrolledCourse {
    private int id;
    private String title;
    private String thumbUrl;
    private int instructorId;
    private String instructorName; // mapping instructorId sang tên
    private double totalRating;
    private Date creationTime;
    private String status;

    public EnrolledCourse(int id, String title, String thumbUrl, int instructorId, String instructorName, double totalRating, Date creationTime, String status) {
        this.id = id;
        this.title = title;
        this.thumbUrl = thumbUrl;
        this.instructorId = instructorId;
        this.instructorName = instructorName;
        this.totalRating = totalRating;
        this.creationTime = creationTime;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getThumbUrl() {
        return thumbUrl;
    }

    public void setThumbUrl(String thumbUrl) {
        this.thumbUrl = thumbUrl;
    }

    public int getInstructorId() {
        return instructorId;
    }

    public void setInstructorId(int instructorId) {
        this.instructorId = instructorId;
    }

    public String getInstructorName() {
        return instructorName;
    }

    public void setInstructorName(String instructorName) {
        this.instructorName = instructorName;
    }

    public double getTotalRating() {
        return totalRating;
    }

    public void setTotalRating(double totalRating) {
        this.totalRating = totalRating;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "EnrolledCourse{" + "id=" + id + ", title=" + title + ", thumbUrl=" + thumbUrl + ", instructorId=" + instructorId + ", instructorName=" + instructorName + ", totalRating=" + totalRating + ", creationTime=" + creationTime + ", status=" + status + '}';
    }

   
}
  