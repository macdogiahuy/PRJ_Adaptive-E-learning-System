/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "Enrollments")
@NamedQueries({
    @NamedQuery(name = "Enrollments.findAll", query = "SELECT e FROM Enrollments e"),
    @NamedQuery(name = "Enrollments.findByCreatorId", query = "SELECT e FROM Enrollments e WHERE e.enrollmentsPK.creatorId = :creatorId"),
    @NamedQuery(name = "Enrollments.findByCourseId", query = "SELECT e FROM Enrollments e WHERE e.enrollmentsPK.courseId = :courseId"),
    @NamedQuery(name = "Enrollments.findByStatus", query = "SELECT e FROM Enrollments e WHERE e.status = :status"),
    @NamedQuery(name = "Enrollments.findByCreationTime", query = "SELECT e FROM Enrollments e WHERE e.creationTime = :creationTime"),
    @NamedQuery(name = "Enrollments.findByAssignmentMilestones", query = "SELECT e FROM Enrollments e WHERE e.assignmentMilestones = :assignmentMilestones"),
    @NamedQuery(name = "Enrollments.findByLectureMilestones", query = "SELECT e FROM Enrollments e WHERE e.lectureMilestones = :lectureMilestones"),
    @NamedQuery(name = "Enrollments.findBySectionMilestones", query = "SELECT e FROM Enrollments e WHERE e.sectionMilestones = :sectionMilestones")})
public class Enrollments implements Serializable {

    private static final long serialVersionUID = 1L;
    @EmbeddedId
    protected EnrollmentsPK enrollmentsPK;
    @Basic(optional = false)
    @Column(name = "Status")
    private String status;
    @Basic(optional = false)
    @Column(name = "CreationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;
    @Basic(optional = false)
    @Column(name = "AssignmentMilestones")
    private String assignmentMilestones;
    @Basic(optional = false)
    @Column(name = "LectureMilestones")
    private String lectureMilestones;
    @Basic(optional = false)
    @Column(name = "SectionMilestones")
    private String sectionMilestones;
    @JoinColumn(name = "BillId", referencedColumnName = "Id")
    @OneToOne
    private Bills billId;
    @JoinColumn(name = "CourseId", referencedColumnName = "Id", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private Courses courses;
    @JoinColumn(name = "CreatorId", referencedColumnName = "Id", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private Users users;

    public Enrollments() {
    }

    public Enrollments(EnrollmentsPK enrollmentsPK) {
        this.enrollmentsPK = enrollmentsPK;
    }

    public Enrollments(EnrollmentsPK enrollmentsPK, String status, Date creationTime, String assignmentMilestones, String lectureMilestones, String sectionMilestones) {
        this.enrollmentsPK = enrollmentsPK;
        this.status = status;
        this.creationTime = creationTime;
        this.assignmentMilestones = assignmentMilestones;
        this.lectureMilestones = lectureMilestones;
        this.sectionMilestones = sectionMilestones;
    }

    public Enrollments(String creatorId, String courseId) {
        this.enrollmentsPK = new EnrollmentsPK(creatorId, courseId);
    }

    public EnrollmentsPK getEnrollmentsPK() {
        return enrollmentsPK;
    }

    public void setEnrollmentsPK(EnrollmentsPK enrollmentsPK) {
        this.enrollmentsPK = enrollmentsPK;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public String getAssignmentMilestones() {
        return assignmentMilestones;
    }

    public void setAssignmentMilestones(String assignmentMilestones) {
        this.assignmentMilestones = assignmentMilestones;
    }

    public String getLectureMilestones() {
        return lectureMilestones;
    }

    public void setLectureMilestones(String lectureMilestones) {
        this.lectureMilestones = lectureMilestones;
    }

    public String getSectionMilestones() {
        return sectionMilestones;
    }

    public void setSectionMilestones(String sectionMilestones) {
        this.sectionMilestones = sectionMilestones;
    }

    public Bills getBillId() {
        return billId;
    }

    public void setBillId(Bills billId) {
        this.billId = billId;
    }

    public Courses getCourses() {
        return courses;
    }

    public void setCourses(Courses courses) {
        this.courses = courses;
    }

    public Users getUsers() {
        return users;
    }

    public void setUsers(Users users) {
        this.users = users;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (enrollmentsPK != null ? enrollmentsPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Enrollments)) {
            return false;
        }
        Enrollments other = (Enrollments) object;
        if ((this.enrollmentsPK == null && other.enrollmentsPK != null) || (this.enrollmentsPK != null && !this.enrollmentsPK.equals(other.enrollmentsPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Enrollments[ enrollmentsPK=" + enrollmentsPK + " ]";
    }
    
}
