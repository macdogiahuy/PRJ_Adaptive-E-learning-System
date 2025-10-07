/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "CourseReviews")
@NamedQueries({
    @NamedQuery(name = "CourseReviews.findAll", query = "SELECT c FROM CourseReviews c"),
    @NamedQuery(name = "CourseReviews.findById", query = "SELECT c FROM CourseReviews c WHERE c.id = :id"),
    @NamedQuery(name = "CourseReviews.findByContent", query = "SELECT c FROM CourseReviews c WHERE c.content = :content"),
    @NamedQuery(name = "CourseReviews.findByRating", query = "SELECT c FROM CourseReviews c WHERE c.rating = :rating"),
    @NamedQuery(name = "CourseReviews.findByCreationTime", query = "SELECT c FROM CourseReviews c WHERE c.creationTime = :creationTime"),
    @NamedQuery(name = "CourseReviews.findByLastModificationTime", query = "SELECT c FROM CourseReviews c WHERE c.lastModificationTime = :lastModificationTime"),
    @NamedQuery(name = "CourseReviews.findByLastModifierId", query = "SELECT c FROM CourseReviews c WHERE c.lastModifierId = :lastModifierId")})
public class CourseReviews implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @Column(name = "Content")
    private String content;
    @Basic(optional = false)
    @Column(name = "Rating")
    private short rating;
    @Basic(optional = false)
    @Column(name = "CreationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;
    @Basic(optional = false)
    @Column(name = "LastModificationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastModificationTime;
    @Basic(optional = false)
    @Column(name = "LastModifierId")
    private String lastModifierId;
    @JoinColumn(name = "CourseId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Courses courseId;
    @JoinColumn(name = "CreatorId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Users creatorId;

    public CourseReviews() {
    }

    public CourseReviews(String id) {
        this.id = id;
    }

    public CourseReviews(String id, String content, short rating, Date creationTime, Date lastModificationTime, String lastModifierId) {
        this.id = id;
        this.content = content;
        this.rating = rating;
        this.creationTime = creationTime;
        this.lastModificationTime = lastModificationTime;
        this.lastModifierId = lastModifierId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public short getRating() {
        return rating;
    }

    public void setRating(short rating) {
        this.rating = rating;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public Date getLastModificationTime() {
        return lastModificationTime;
    }

    public void setLastModificationTime(Date lastModificationTime) {
        this.lastModificationTime = lastModificationTime;
    }

    public String getLastModifierId() {
        return lastModifierId;
    }

    public void setLastModifierId(String lastModifierId) {
        this.lastModifierId = lastModifierId;
    }

    public Courses getCourseId() {
        return courseId;
    }

    public void setCourseId(Courses courseId) {
        this.courseId = courseId;
    }

    public Users getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(Users creatorId) {
        this.creatorId = creatorId;
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
        if (!(object instanceof CourseReviews)) {
            return false;
        }
        CourseReviews other = (CourseReviews) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.CourseReviews[ id=" + id + " ]";
    }
    
}
