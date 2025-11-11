/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author ADMIN
 */
@Entity
@Table(name = "CourseNotifications")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "CourseNotifications.findAll", query = "SELECT c FROM CourseNotifications c"),
    @NamedQuery(name = "CourseNotifications.findById", query = "SELECT c FROM CourseNotifications c WHERE c.id = :id"),
    @NamedQuery(name = "CourseNotifications.findByCourseId", query = "SELECT c FROM CourseNotifications c WHERE c.courseId = :courseId"),
    @NamedQuery(name = "CourseNotifications.findByInstructorId", query = "SELECT c FROM CourseNotifications c WHERE c.instructorId = :instructorId"),
    @NamedQuery(name = "CourseNotifications.findByInstructorName", query = "SELECT c FROM CourseNotifications c WHERE c.instructorName = :instructorName"),
    @NamedQuery(name = "CourseNotifications.findByCourseTitle", query = "SELECT c FROM CourseNotifications c WHERE c.courseTitle = :courseTitle"),
    @NamedQuery(name = "CourseNotifications.findByCoursePrice", query = "SELECT c FROM CourseNotifications c WHERE c.coursePrice = :coursePrice"),
    @NamedQuery(name = "CourseNotifications.findByNotificationType", query = "SELECT c FROM CourseNotifications c WHERE c.notificationType = :notificationType"),
    @NamedQuery(name = "CourseNotifications.findByStatus", query = "SELECT c FROM CourseNotifications c WHERE c.status = :status"),
    @NamedQuery(name = "CourseNotifications.findByRejectionReason", query = "SELECT c FROM CourseNotifications c WHERE c.rejectionReason = :rejectionReason"),
    @NamedQuery(name = "CourseNotifications.findByCreationTime", query = "SELECT c FROM CourseNotifications c WHERE c.creationTime = :creationTime"),
    @NamedQuery(name = "CourseNotifications.findByProcessedTime", query = "SELECT c FROM CourseNotifications c WHERE c.processedTime = :processedTime"),
    @NamedQuery(name = "CourseNotifications.findByProcessedBy", query = "SELECT c FROM CourseNotifications c WHERE c.processedBy = :processedBy")})
public class CourseNotifications implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 36)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 36)
    @Column(name = "CourseId")
    private String courseId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 36)
    @Column(name = "InstructorId")
    private String instructorId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "InstructorName")
    private String instructorName;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "CourseTitle")
    private String courseTitle;
    @Basic(optional = false)
    @NotNull
    @Column(name = "CoursePrice")
    private double coursePrice;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "NotificationType")
    private String notificationType;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "Status")
    private String status;
    @Size(max = 1000)
    @Column(name = "RejectionReason")
    private String rejectionReason;
    @Basic(optional = false)
    @NotNull
    @Column(name = "CreationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;
    @Column(name = "ProcessedTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date processedTime;
    @Size(max = 36)
    @Column(name = "ProcessedBy")
    private String processedBy;

    public CourseNotifications() {
    }

    public CourseNotifications(String id) {
        this.id = id;
    }

    public CourseNotifications(String id, String courseId, String instructorId, String instructorName, String courseTitle, double coursePrice, String notificationType, String status, Date creationTime) {
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

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (id != null ? id.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof CourseNotifications)) {
            return false;
        }
        CourseNotifications other = (CourseNotifications) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.CourseNotifications[ id=" + id + " ]";
    }
    
}
