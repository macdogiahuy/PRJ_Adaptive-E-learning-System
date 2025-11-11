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
@Table(name = "CartCheckout")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "CartCheckout.findAll", query = "SELECT c FROM CartCheckout c"),
    @NamedQuery(name = "CartCheckout.findById", query = "SELECT c FROM CartCheckout c WHERE c.id = :id"),
    @NamedQuery(name = "CartCheckout.findByUserId", query = "SELECT c FROM CartCheckout c WHERE c.userId = :userId"),
    @NamedQuery(name = "CartCheckout.findByCourseIds", query = "SELECT c FROM CartCheckout c WHERE c.courseIds = :courseIds"),
    @NamedQuery(name = "CartCheckout.findByTotalAmount", query = "SELECT c FROM CartCheckout c WHERE c.totalAmount = :totalAmount"),
    @NamedQuery(name = "CartCheckout.findByPaymentMethod", query = "SELECT c FROM CartCheckout c WHERE c.paymentMethod = :paymentMethod"),
    @NamedQuery(name = "CartCheckout.findByStatus", query = "SELECT c FROM CartCheckout c WHERE c.status = :status"),
    @NamedQuery(name = "CartCheckout.findByCreationTime", query = "SELECT c FROM CartCheckout c WHERE c.creationTime = :creationTime"),
    @NamedQuery(name = "CartCheckout.findByProcessedTime", query = "SELECT c FROM CartCheckout c WHERE c.processedTime = :processedTime"),
    @NamedQuery(name = "CartCheckout.findByNotes", query = "SELECT c FROM CartCheckout c WHERE c.notes = :notes"),
    @NamedQuery(name = "CartCheckout.findBySessionId", query = "SELECT c FROM CartCheckout c WHERE c.sessionId = :sessionId")})
public class CartCheckout implements Serializable {

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
    @Size(min = 1, max = 2147483647)
    @Column(name = "CourseIds")
    private String courseIds;
    @Basic(optional = false)
    @NotNull
    @Column(name = "TotalAmount")
    private long totalAmount;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "PaymentMethod")
    private String paymentMethod;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "Status")
    private String status;
    @Basic(optional = false)
    @NotNull
    @Column(name = "CreationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;
    @Column(name = "ProcessedTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date processedTime;
    @Size(max = 500)
    @Column(name = "Notes")
    private String notes;
    @Size(max = 100)
    @Column(name = "SessionId")
    private String sessionId;

    public CartCheckout() {
    }

    public CartCheckout(String id) {
        this.id = id;
    }

    public CartCheckout(String id, String userId, String courseIds, long totalAmount, String paymentMethod, String status, Date creationTime) {
        this.id = id;
        this.userId = userId;
        this.courseIds = courseIds;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.creationTime = creationTime;
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

    public String getCourseIds() {
        return courseIds;
    }

    public void setCourseIds(String courseIds) {
        this.courseIds = courseIds;
    }

    public long getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(long totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public Date getProcessedTime() {
        return processedTime;
    }

    public void setProcessedTime(Date processedTime) {
        this.processedTime = processedTime;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
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
        if (!(object instanceof CartCheckout)) {
            return false;
        }
        CartCheckout other = (CartCheckout) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.CartCheckout[ id=" + id + " ]";
    }
    
}
