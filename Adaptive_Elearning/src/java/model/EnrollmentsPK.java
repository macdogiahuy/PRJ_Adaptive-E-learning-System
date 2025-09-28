/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 *
 * @author LP
 */
@Embeddable
public class EnrollmentsPK implements Serializable {

    @Basic(optional = false)
    @Column(name = "CreatorId")
    private String creatorId;
    @Basic(optional = false)
    @Column(name = "CourseId")
    private String courseId;

    public EnrollmentsPK() {
    }

    public EnrollmentsPK(String creatorId, String courseId) {
        this.creatorId = creatorId;
        this.courseId = courseId;
    }

    public String getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(String creatorId) {
        this.creatorId = creatorId;
    }

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (creatorId != null ? creatorId.hashCode() : 0);
        hash += (courseId != null ? courseId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof EnrollmentsPK)) {
            return false;
        }
        EnrollmentsPK other = (EnrollmentsPK) object;
        if ((this.creatorId == null && other.creatorId != null) || (this.creatorId != null && !this.creatorId.equals(other.creatorId))) {
            return false;
        }
        if ((this.courseId == null && other.courseId != null) || (this.courseId != null && !this.courseId.equals(other.courseId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.EnrollmentsPK[ creatorId=" + creatorId + ", courseId=" + courseId + " ]";
    }
    
}
