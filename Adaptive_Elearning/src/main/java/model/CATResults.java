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
@Table(name = "CAT_Results")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "CATResults.findAll", query = "SELECT c FROM CATResults c"),
    @NamedQuery(name = "CATResults.findById", query = "SELECT c FROM CATResults c WHERE c.id = :id"),
    @NamedQuery(name = "CATResults.findByUserId", query = "SELECT c FROM CATResults c WHERE c.userId = :userId"),
    @NamedQuery(name = "CATResults.findByCourseId", query = "SELECT c FROM CATResults c WHERE c.courseId = :courseId"),
    @NamedQuery(name = "CATResults.findByAssignmentId", query = "SELECT c FROM CATResults c WHERE c.assignmentId = :assignmentId"),
    @NamedQuery(name = "CATResults.findByFinalTheta", query = "SELECT c FROM CATResults c WHERE c.finalTheta = :finalTheta"),
    @NamedQuery(name = "CATResults.findByCorrectCount", query = "SELECT c FROM CATResults c WHERE c.correctCount = :correctCount"),
    @NamedQuery(name = "CATResults.findByTotalQuestions", query = "SELECT c FROM CATResults c WHERE c.totalQuestions = :totalQuestions"),
    @NamedQuery(name = "CATResults.findByThetaBefore", query = "SELECT c FROM CATResults c WHERE c.thetaBefore = :thetaBefore"),
    @NamedQuery(name = "CATResults.findByThetaAfter", query = "SELECT c FROM CATResults c WHERE c.thetaAfter = :thetaAfter"),
    @NamedQuery(name = "CATResults.findByCompletionTime", query = "SELECT c FROM CATResults c WHERE c.completionTime = :completionTime")})
public class CATResults implements Serializable {

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
    @Size(max = 36)
    @Column(name = "AssignmentId")
    private String assignmentId;
    @Basic(optional = false)
    @NotNull
    @Column(name = "FinalTheta")
    private double finalTheta;
    @Basic(optional = false)
    @NotNull
    @Column(name = "CorrectCount")
    private int correctCount;
    @Basic(optional = false)
    @NotNull
    @Column(name = "TotalQuestions")
    private int totalQuestions;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "ThetaBefore")
    private Double thetaBefore;
    @Column(name = "ThetaAfter")
    private Double thetaAfter;
    @Column(name = "CompletionTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date completionTime;

    public CATResults() {
    }

    public CATResults(String id) {
        this.id = id;
    }

    public CATResults(String id, String userId, String courseId, double finalTheta, int correctCount, int totalQuestions) {
        this.id = id;
        this.userId = userId;
        this.courseId = courseId;
        this.finalTheta = finalTheta;
        this.correctCount = correctCount;
        this.totalQuestions = totalQuestions;
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

    public String getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(String assignmentId) {
        this.assignmentId = assignmentId;
    }

    public double getFinalTheta() {
        return finalTheta;
    }

    public void setFinalTheta(double finalTheta) {
        this.finalTheta = finalTheta;
    }

    public int getCorrectCount() {
        return correctCount;
    }

    public void setCorrectCount(int correctCount) {
        this.correctCount = correctCount;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public Double getThetaBefore() {
        return thetaBefore;
    }

    public void setThetaBefore(Double thetaBefore) {
        this.thetaBefore = thetaBefore;
    }

    public Double getThetaAfter() {
        return thetaAfter;
    }

    public void setThetaAfter(Double thetaAfter) {
        this.thetaAfter = thetaAfter;
    }

    public Date getCompletionTime() {
        return completionTime;
    }

    public void setCompletionTime(Date completionTime) {
        this.completionTime = completionTime;
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
        if (!(object instanceof CATResults)) {
            return false;
        }
        CATResults other = (CATResults) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.CATResults[ id=" + id + " ]";
    }
    
}
