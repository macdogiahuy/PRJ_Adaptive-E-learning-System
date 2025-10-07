/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "Instructors")
@NamedQueries({
    @NamedQuery(name = "Instructors.findAll", query = "SELECT i FROM Instructors i"),
    @NamedQuery(name = "Instructors.findById", query = "SELECT i FROM Instructors i WHERE i.id = :id"),
    @NamedQuery(name = "Instructors.findByIntro", query = "SELECT i FROM Instructors i WHERE i.intro = :intro"),
    @NamedQuery(name = "Instructors.findByExperience", query = "SELECT i FROM Instructors i WHERE i.experience = :experience"),
    @NamedQuery(name = "Instructors.findByCreationTime", query = "SELECT i FROM Instructors i WHERE i.creationTime = :creationTime"),
    @NamedQuery(name = "Instructors.findByLastModificationTime", query = "SELECT i FROM Instructors i WHERE i.lastModificationTime = :lastModificationTime"),
    @NamedQuery(name = "Instructors.findByBalance", query = "SELECT i FROM Instructors i WHERE i.balance = :balance"),
    @NamedQuery(name = "Instructors.findByCourseCount", query = "SELECT i FROM Instructors i WHERE i.courseCount = :courseCount")})
public class Instructors implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @Column(name = "Intro")
    private String intro;
    @Basic(optional = false)
    @Column(name = "Experience")
    private String experience;
    @Basic(optional = false)
    @Column(name = "CreationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;
    @Basic(optional = false)
    @Column(name = "LastModificationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastModificationTime;
    @Basic(optional = false)
    @Column(name = "Balance")
    private long balance;
    @Basic(optional = false)
    @Column(name = "CourseCount")
    private short courseCount;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "instructorId")
    private List<Courses> coursesList;
    @JoinColumn(name = "CreatorId", referencedColumnName = "Id")
    @OneToOne(optional = false)
    private Users creatorId;

    public Instructors() {
    }

    public Instructors(String id) {
        this.id = id;
    }

    public Instructors(String id, String intro, String experience, Date creationTime, Date lastModificationTime, long balance, short courseCount) {
        this.id = id;
        this.intro = intro;
        this.experience = experience;
        this.creationTime = creationTime;
        this.lastModificationTime = lastModificationTime;
        this.balance = balance;
        this.courseCount = courseCount;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIntro() {
        return intro;
    }

    public void setIntro(String intro) {
        this.intro = intro;
    }

    public String getExperience() {
        return experience;
    }

    public void setExperience(String experience) {
        this.experience = experience;
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

    public long getBalance() {
        return balance;
    }

    public void setBalance(long balance) {
        this.balance = balance;
    }

    public short getCourseCount() {
        return courseCount;
    }

    public void setCourseCount(short courseCount) {
        this.courseCount = courseCount;
    }

    public List<Courses> getCoursesList() {
        return coursesList;
    }

    public void setCoursesList(List<Courses> coursesList) {
        this.coursesList = coursesList;
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
        if (!(object instanceof Instructors)) {
            return false;
        }
        Instructors other = (Instructors) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Instructors[ id=" + id + " ]";
    }
    
}
