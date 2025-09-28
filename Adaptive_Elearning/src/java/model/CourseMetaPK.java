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
public class CourseMetaPK implements Serializable {

    @Basic(optional = false)
    @Column(name = "CourseId")
    private String courseId;
    @Basic(optional = false)
    @Column(name = "Id")
    private int id;

    public CourseMetaPK() {
    }

    public CourseMetaPK(String courseId, int id) {
        this.courseId = courseId;
        this.id = id;
    }

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (courseId != null ? courseId.hashCode() : 0);
        hash += (int) id;
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof CourseMetaPK)) {
            return false;
        }
        CourseMetaPK other = (CourseMetaPK) object;
        if ((this.courseId == null && other.courseId != null) || (this.courseId != null && !this.courseId.equals(other.courseId))) {
            return false;
        }
        if (this.id != other.id) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.CourseMetaPK[ courseId=" + courseId + ", id=" + id + " ]";
    }
    
}
