/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "LectureMaterial")
public class LectureMaterial implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "LectureId")
    private String lectureId;

    // Database doesn't have FileName column, but we keep for compatibility
    private String fileName; 

    @Column(name = "Type")
    private String fileType;

    @Column(name = "Url", length = 1024)
    private String driveLink;

    @ManyToOne(optional = true)
    @JoinColumn(name = "LectureId", referencedColumnName = "Id", insertable = false, updatable = false)
    private Lectures lectures;

    public LectureMaterial() {
    }

    // getters and setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getLectureId() {
        return lectureId;
    }

    public void setLectureId(String lectureId) {
        this.lectureId = lectureId;
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
     * Legacy accessor retained so older JSPs that still call material.type keep working.
     */
    public String getType() {
        return fileType;
    }

    /**
     * Legacy mutator retained for backward compatibility with existing data mappers.
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
     * Alias for driveLink to satisfy older code paths expecting a getUrl accessor.
     */
    public String getUrl() {
        return driveLink;
    }

    public void setUrl(String url) {
        this.driveLink = url;
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
