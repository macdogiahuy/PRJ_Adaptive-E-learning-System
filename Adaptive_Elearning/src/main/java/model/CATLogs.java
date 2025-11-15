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
@Table(name = "CAT_Logs")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "CATLogs.findAll", query = "SELECT c FROM CATLogs c"),
    @NamedQuery(name = "CATLogs.findById", query = "SELECT c FROM CATLogs c WHERE c.id = :id"),
    @NamedQuery(name = "CATLogs.findByUserId", query = "SELECT c FROM CATLogs c WHERE c.userId = :userId"),
    @NamedQuery(name = "CATLogs.findByQuestionId", query = "SELECT c FROM CATLogs c WHERE c.questionId = :questionId"),
    @NamedQuery(name = "CATLogs.findByResponse", query = "SELECT c FROM CATLogs c WHERE c.response = :response"),
    @NamedQuery(name = "CATLogs.findByThetaBefore", query = "SELECT c FROM CATLogs c WHERE c.thetaBefore = :thetaBefore"),
    @NamedQuery(name = "CATLogs.findByThetaAfter", query = "SELECT c FROM CATLogs c WHERE c.thetaAfter = :thetaAfter"),
    @NamedQuery(name = "CATLogs.findByTimestamp", query = "SELECT c FROM CATLogs c WHERE c.timestamp = :timestamp")})
public class CATLogs implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 36)
    @Column(name = "Id")
    private String id;
    @Size(max = 36)
    @Column(name = "UserId")
    private String userId;
    @Size(max = 36)
    @Column(name = "QuestionId")
    private String questionId;
    @Column(name = "Response")
    private Boolean response;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "ThetaBefore")
    private Double thetaBefore;
    @Column(name = "ThetaAfter")
    private Double thetaAfter;
    @Column(name = "Timestamp")
    @Temporal(TemporalType.TIMESTAMP)
    private Date timestamp;

    public CATLogs() {
    }

    public CATLogs(String id) {
        this.id = id;
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

    public String getQuestionId() {
        return questionId;
    }

    public void setQuestionId(String questionId) {
        this.questionId = questionId;
    }

    public Boolean getResponse() {
        return response;
    }

    public void setResponse(Boolean response) {
        this.response = response;
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

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
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
        if (!(object instanceof CATLogs)) {
            return false;
        }
        CATLogs other = (CATLogs) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.CATLogs[ id=" + id + " ]";
    }
    
}
