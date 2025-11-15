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
@Table(name = "UserAbilities")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "UserAbilities.findAll", query = "SELECT u FROM UserAbilities u"),
    @NamedQuery(name = "UserAbilities.findById", query = "SELECT u FROM UserAbilities u WHERE u.id = :id"),
    @NamedQuery(name = "UserAbilities.findByUserId", query = "SELECT u FROM UserAbilities u WHERE u.userId = :userId"),
    @NamedQuery(name = "UserAbilities.findByCourseId", query = "SELECT u FROM UserAbilities u WHERE u.courseId = :courseId"),
    @NamedQuery(name = "UserAbilities.findByTheta", query = "SELECT u FROM UserAbilities u WHERE u.theta = :theta"),
    @NamedQuery(name = "UserAbilities.findByLastUpdate", query = "SELECT u FROM UserAbilities u WHERE u.lastUpdate = :lastUpdate")})
public class UserAbilities implements Serializable {

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
    @Column(name = "UserId")
    private String userId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 36)
    @Column(name = "CourseId")
    private String courseId;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "Theta")
    private Double theta;
    @Column(name = "LastUpdate")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastUpdate;

    public UserAbilities() {
    }

    public UserAbilities(String id) {
        this.id = id;
    }

    public UserAbilities(String id, String userId, String courseId) {
        this.id = id;
        this.userId = userId;
        this.courseId = courseId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    public Double getTheta() {
        return theta;
    }

    public void setTheta(Double theta) {
        this.theta = theta;
    }

    public Date getLastUpdate() {
        return lastUpdate;
    }

    public void setLastUpdate(Date lastUpdate) {
        this.lastUpdate = lastUpdate;
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
        if (!(object instanceof UserAbilities)) {
            return false;
        }
        UserAbilities other = (UserAbilities) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.UserAbilities[ id=" + id + " ]";
    }
    
}
