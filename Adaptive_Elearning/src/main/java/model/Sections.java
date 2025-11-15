/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.xml.bind.annotation.XmlRootElement;
import jakarta.xml.bind.annotation.XmlTransient;
import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

/**
 *
 * @author ADMIN
 */
@Entity
@Table(name = "Sections")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Sections.findAll", query = "SELECT s FROM Sections s"),
    @NamedQuery(name = "Sections.findById", query = "SELECT s FROM Sections s WHERE s.id = :id"),
    @NamedQuery(name = "Sections.findByIndex", query = "SELECT s FROM Sections s WHERE s.index = :index"),
    @NamedQuery(name = "Sections.findByTitle", query = "SELECT s FROM Sections s WHERE s.title = :title"),
    @NamedQuery(name = "Sections.findByLectureCount", query = "SELECT s FROM Sections s WHERE s.lectureCount = :lectureCount"),
    @NamedQuery(name = "Sections.findByCreationTime", query = "SELECT s FROM Sections s WHERE s.creationTime = :creationTime"),
    @NamedQuery(name = "Sections.findByLastModificationTime", query = "SELECT s FROM Sections s WHERE s.lastModificationTime = :lastModificationTime")})
public class Sections implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 36)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @NotNull
    @Column(name = "[Index]")
    private short index;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 255)
    @Column(name = "Title")
    private String title;
    @Basic(optional = false)
    @NotNull
    @Column(name = "LectureCount")
    private short lectureCount;
    @Basic(optional = false)
    @NotNull
    @Column(name = "CreationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;
    @Basic(optional = false)
    @NotNull
    @Column(name = "LastModificationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastModificationTime;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "sectionId")
    private Collection<Assignments> assignmentsCollection;
    @JoinColumn(name = "CourseId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Courses courseId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "sectionId")
    private Collection<Lectures> lecturesCollection;

    public Sections() {
    }

    public Sections(String id) {
        this.id = id;
    }

    public Sections(String id, short index, String title, short lectureCount, Date creationTime, Date lastModificationTime) {
        this.id = id;
        this.index = index;
        this.title = title;
        this.lectureCount = lectureCount;
        this.creationTime = creationTime;
        this.lastModificationTime = lastModificationTime;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public short getIndex() {
        return index;
    }

    public void setIndex(short index) {
        this.index = index;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public short getLectureCount() {
        return lectureCount;
    }

    public void setLectureCount(short lectureCount) {
        this.lectureCount = lectureCount;
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

    @XmlTransient
    public Collection<Assignments> getAssignmentsCollection() {
        return assignmentsCollection;
    }

    public void setAssignmentsCollection(Collection<Assignments> assignmentsCollection) {
        this.assignmentsCollection = assignmentsCollection;
    }

    public Courses getCourseId() {
        return courseId;
    }

    public void setCourseId(Courses courseId) {
        this.courseId = courseId;
    }

    @XmlTransient
    public Collection<Lectures> getLecturesCollection() {
        return lecturesCollection;
    }

    public void setLecturesCollection(Collection<Lectures> lecturesCollection) {
        this.lecturesCollection = lecturesCollection;
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
        if (!(object instanceof Sections)) {
            return false;
        }
        Sections other = (Sections) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Sections[ id=" + id + " ]";
    }
    
}
