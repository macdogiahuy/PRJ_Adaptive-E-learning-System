package model;

import java.time.LocalDateTime;

public class Courses {
    private String id;             // để String thay vì int
    private String title;
    private String thumbnail;
    private String instructor;
    private double rating;
    private LocalDateTime enrolledAt;
    private String status;

    public Courses(String id, String title, String thumbnail,
                   String instructor, double rating,
                   LocalDateTime enrolledAt, String status) {
        this.id = id;
        this.title = title;
        this.thumbnail = thumbnail;
        this.instructor = instructor;
        this.rating = rating;
        this.enrolledAt = enrolledAt;
        this.status = status;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public String getInstructor() {
        return instructor;
    }

    public void setInstructor(String instructor) {
        this.instructor = instructor;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public LocalDateTime getEnrolledAt() {
        return enrolledAt;
    }

    public void setEnrolledAt(LocalDateTime enrolledAt) {
        this.enrolledAt = enrolledAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Courses{" + "id=" + id + ", title=" + title + ", thumbnail=" + thumbnail + ", instructor=" + instructor + ", rating=" + rating + ", enrolledAt=" + enrolledAt + ", status=" + status + '}';
    }

}
