/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "CourseMeta")
@NamedQueries({
    @NamedQuery(name = "CourseMeta.findAll", query = "SELECT c FROM CourseMeta c"),
    @NamedQuery(name = "CourseMeta.findByCourseId", query = "SELECT c FROM CourseMeta c WHERE c.courseMetaPK.courseId = :courseId"),
    @NamedQuery(name = "CourseMeta.findById", query = "SELECT c FROM CourseMeta c WHERE c.courseMetaPK.id = :id"),
    @NamedQuery(name = "CourseMeta.findByType", query = "SELECT c FROM CourseMeta c WHERE c.type = :type"),
    @NamedQuery(name = "CourseMeta.findByValue", query = "SELECT c FROM CourseMeta c WHERE c.value = :value")})
public class CourseMeta implements Serializable {

    private static final long serialVersionUID = 1L;
    @EmbeddedId
    protected CourseMetaPK courseMetaPK;
    @Basic(optional = false)
    @Column(name = "Type")
    private short type;
    @Basic(optional = false)
    @Column(name = "Value")
    private String value;
    @JoinColumn(name = "CourseId", referencedColumnName = "Id", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private Courses courses;

    public CourseMeta() {
    }

    public CourseMeta(CourseMetaPK courseMetaPK) {
        this.courseMetaPK = courseMetaPK;
    }

    public CourseMeta(CourseMetaPK courseMetaPK, short type, String value) {
        this.courseMetaPK = courseMetaPK;
        this.type = type;
        this.value = value;
    }

    public CourseMeta(String courseId, int id) {
        this.courseMetaPK = new CourseMetaPK(courseId, id);
    }

    public CourseMetaPK getCourseMetaPK() {
        return courseMetaPK;
    }

    public void setCourseMetaPK(CourseMetaPK courseMetaPK) {
        this.courseMetaPK = courseMetaPK;
    }

    public short getType() {
        return type;
    }

    public void setType(short type) {
        this.type = type;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public Courses getCourses() {
        return courses;
    }

    public void setCourses(Courses courses) {
        this.courses = courses;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (courseMetaPK != null ? courseMetaPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof CourseMeta)) {
            return false;
        }
        CourseMeta other = (CourseMeta) object;
        if ((this.courseMetaPK == null && other.courseMetaPK != null) || (this.courseMetaPK != null && !this.courseMetaPK.equals(other.courseMetaPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.CourseMeta[ courseMetaPK=" + courseMetaPK + " ]";
    }
    
}
