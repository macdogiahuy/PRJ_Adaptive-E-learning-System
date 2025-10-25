/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "Submissions")
@NamedQueries({
    @NamedQuery(name = "Submissions.findAll", query = "SELECT s FROM Submissions s"),
    @NamedQuery(name = "Submissions.findById", query = "SELECT s FROM Submissions s WHERE s.id = :id"),
    @NamedQuery(name = "Submissions.findByMark", query = "SELECT s FROM Submissions s WHERE s.mark = :mark"),
    @NamedQuery(name = "Submissions.findByTimeSpentInSec", query = "SELECT s FROM Submissions s WHERE s.timeSpentInSec = :timeSpentInSec"),
    @NamedQuery(name = "Submissions.findByCreationTime", query = "SELECT s FROM Submissions s WHERE s.creationTime = :creationTime"),
    @NamedQuery(name = "Submissions.findByLastModificationTime", query = "SELECT s FROM Submissions s WHERE s.lastModificationTime = :lastModificationTime"),
    @NamedQuery(name = "Submissions.findByLastModifierId", query = "SELECT s FROM Submissions s WHERE s.lastModifierId = :lastModifierId")})
public class Submissions implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @Column(name = "Mark")
    private double mark;
    @Basic(optional = false)
    @Column(name = "TimeSpentInSec")
    private int timeSpentInSec;
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
    @ManyToMany(mappedBy = "submissionsList")
    private List<McqChoices> mcqChoicesList;
    @JoinColumn(name = "AssignmentId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Assignments assignmentId;
    @JoinColumn(name = "CreatorId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Users creatorId;

    public Submissions() {
    }

    public Submissions(String id) {
        this.id = id;
    }

    public Submissions(String id, double mark, int timeSpentInSec, Date creationTime, Date lastModificationTime, String lastModifierId) {
        this.id = id;
        this.mark = mark;
        this.timeSpentInSec = timeSpentInSec;
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

    public double getMark() {
        return mark;
    }

    public void setMark(double mark) {
        this.mark = mark;
    }

    public int getTimeSpentInSec() {
        return timeSpentInSec;
    }

    public void setTimeSpentInSec(int timeSpentInSec) {
        this.timeSpentInSec = timeSpentInSec;
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

    public List<McqChoices> getMcqChoicesList() {
        return mcqChoicesList;
    }

    public void setMcqChoicesList(List<McqChoices> mcqChoicesList) {
        this.mcqChoicesList = mcqChoicesList;
    }

    public Assignments getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(Assignments assignmentId) {
        this.assignmentId = assignmentId;
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
        if (!(object instanceof Submissions)) {
            return false;
        }
        Submissions other = (Submissions) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Submissions[ id=" + id + " ]";
    }
    
}
