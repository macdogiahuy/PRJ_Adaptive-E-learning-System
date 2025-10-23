/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "Bills")
@NamedQueries({
    @NamedQuery(name = "Bills.findAll", query = "SELECT b FROM Bills b"),
    @NamedQuery(name = "Bills.findById", query = "SELECT b FROM Bills b WHERE b.id = :id"),
    @NamedQuery(name = "Bills.findByAction", query = "SELECT b FROM Bills b WHERE b.action = :action"),
    @NamedQuery(name = "Bills.findByNote", query = "SELECT b FROM Bills b WHERE b.note = :note"),
    @NamedQuery(name = "Bills.findByAmount", query = "SELECT b FROM Bills b WHERE b.amount = :amount"),
    @NamedQuery(name = "Bills.findByGateway", query = "SELECT b FROM Bills b WHERE b.gateway = :gateway"),
    @NamedQuery(name = "Bills.findByTransactionId", query = "SELECT b FROM Bills b WHERE b.transactionId = :transactionId"),
    @NamedQuery(name = "Bills.findByClientTransactionId", query = "SELECT b FROM Bills b WHERE b.clientTransactionId = :clientTransactionId"),
    @NamedQuery(name = "Bills.findByToken", query = "SELECT b FROM Bills b WHERE b.token = :token"),
    @NamedQuery(name = "Bills.findByIsSuccessful", query = "SELECT b FROM Bills b WHERE b.isSuccessful = :isSuccessful"),
    @NamedQuery(name = "Bills.findByCreationTime", query = "SELECT b FROM Bills b WHERE b.creationTime = :creationTime")})
public class Bills implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @Column(name = "Action")
    private String action;
    @Basic(optional = false)
    @Column(name = "Note")
    private String note;
    @Basic(optional = false)
    @Column(name = "Amount")
    private long amount;
    @Basic(optional = false)
    @Column(name = "Gateway")
    private String gateway;
    @Basic(optional = false)
    @Column(name = "TransactionId")
    private String transactionId;
    @Basic(optional = false)
    @Column(name = "ClientTransactionId")
    private String clientTransactionId;
    @Basic(optional = false)
    @Column(name = "Token")
    private String token;
    @Basic(optional = false)
    @Column(name = "IsSuccessful")
    private boolean isSuccessful;
    @Basic(optional = false)
    @Column(name = "CreationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;
    @OneToOne(mappedBy = "billId")
    private Enrollments enrollments;
    @JoinColumn(name = "CreatorId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Users creatorId;

    public Bills() {
    }

    public Bills(String id) {
        this.id = id;
    }

    public Bills(String id, String action, String note, long amount, String gateway, String transactionId, String clientTransactionId, String token, boolean isSuccessful, Date creationTime) {
        this.id = id;
        this.action = action;
        this.note = note;
        this.amount = amount;
        this.gateway = gateway;
        this.transactionId = transactionId;
        this.clientTransactionId = clientTransactionId;
        this.token = token;
        this.isSuccessful = isSuccessful;
        this.creationTime = creationTime;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public long getAmount() {
        return amount;
    }

    public void setAmount(long amount) {
        this.amount = amount;
    }

    public String getGateway() {
        return gateway;
    }

    public void setGateway(String gateway) {
        this.gateway = gateway;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getClientTransactionId() {
        return clientTransactionId;
    }

    public void setClientTransactionId(String clientTransactionId) {
        this.clientTransactionId = clientTransactionId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public boolean getIsSuccessful() {
        return isSuccessful;
    }

    public void setIsSuccessful(boolean isSuccessful) {
        this.isSuccessful = isSuccessful;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public Enrollments getEnrollments() {
        return enrollments;
    }

    public void setEnrollments(Enrollments enrollments) {
        this.enrollments = enrollments;
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
        if (!(object instanceof Bills)) {
            return false;
        }
        Bills other = (Bills) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Bills[ id=" + id + " ]";
    }
    
}
