/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.time.LocalDateTime;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

/**
 * LectureMaterial entity updated to match new schema requirements.
 */
@Entity
@Table(name = "LectureMaterial")
public class LectureMaterial implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "instructorId")
    private Long instructorId;

    @Column(name = "courseId")
    private Long courseId;

    @Column(name = "fileName")
    private String fileName;

    @Column(name = "fileType")
    private String fileType;

    @Column(name = "driveLink", length = 1024)
    private String driveLink;

    @Column(name = "createdAt")
    private LocalDateTime createdAt;

    @ManyToOne(optional = true)
    @JoinColumn(name = "LectureId", referencedColumnName = "Id", insertable = false, updatable = false)
    private Lectures lectures;

    public LectureMaterial() {
    }

    @PrePersist
    protected void onCreate() {
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
        }
    }

    // getters and setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getInstructorId() {
        return instructorId;
    }

    public void setInstructorId(Long instructorId) {
        this.instructorId = instructorId;
    }

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    /**
     * Legacy accessor retained so existing JSPs referencing material.type still resolve.
     */
    public String getType() {
        return fileType;
    }

    /**
     * Legacy mutator retained for backward compatibility.
     */
    public void setType(String type) {
        this.fileType = type;
    }

    public String getDriveLink() {
        return driveLink;
    }

    public void setDriveLink(String driveLink) {
        this.driveLink = driveLink;
    }

    /**
     * Alias for driveLink so older EL expressions using material.url stay functional.
     */
    public String getUrl() {
        return driveLink;
    }

    public void setUrl(String url) {
        this.driveLink = url;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Lectures getLectures() {
        return lectures;
    }

    public void setLectures(Lectures lectures) {
        this.lectures = lectures;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 31 * hash + (id == null ? 0 : id.hashCode());
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final LectureMaterial other = (LectureMaterial) obj;
        return (this.id != null || other.id == null) && (this.id == null || this.id.equals(other.id));
    }

    @Override
    public String toString() {
        return "model.LectureMaterial[id=" + id + ", fileName=" + fileName + "]";
    }

}
