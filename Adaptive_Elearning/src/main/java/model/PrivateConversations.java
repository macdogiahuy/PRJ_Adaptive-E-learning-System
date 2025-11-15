/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
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
@Table(name = "PrivateConversations")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "PrivateConversations.findAll", query = "SELECT p FROM PrivateConversations p"),
    @NamedQuery(name = "PrivateConversations.findByConversationId", query = "SELECT p FROM PrivateConversations p WHERE p.conversationId = :conversationId"),
    @NamedQuery(name = "PrivateConversations.findByUser1Id", query = "SELECT p FROM PrivateConversations p WHERE p.user1Id = :user1Id"),
    @NamedQuery(name = "PrivateConversations.findByUser2Id", query = "SELECT p FROM PrivateConversations p WHERE p.user2Id = :user2Id"),
    @NamedQuery(name = "PrivateConversations.findByCreatedAt", query = "SELECT p FROM PrivateConversations p WHERE p.createdAt = :createdAt"),
    @NamedQuery(name = "PrivateConversations.findByLastMessageAt", query = "SELECT p FROM PrivateConversations p WHERE p.lastMessageAt = :lastMessageAt"),
    @NamedQuery(name = "PrivateConversations.findByLastMessageText", query = "SELECT p FROM PrivateConversations p WHERE p.lastMessageText = :lastMessageText")})
public class PrivateConversations implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "conversation_id")
    private Integer conversationId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "user1_id")
    private String user1Id;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "user2_id")
    private String user2Id;
    @Basic(optional = false)
    @NotNull
    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;
    @Column(name = "last_message_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastMessageAt;
    @Size(max = 2147483647)
    @Column(name = "last_message_text")
    private String lastMessageText;

    public PrivateConversations() {
    }

    public PrivateConversations(Integer conversationId) {
        this.conversationId = conversationId;
    }

    public PrivateConversations(Integer conversationId, String user1Id, String user2Id, Date createdAt) {
        this.conversationId = conversationId;
        this.user1Id = user1Id;
        this.user2Id = user2Id;
        this.createdAt = createdAt;
    }

    public Integer getConversationId() {
        return conversationId;
    }

    public void setConversationId(Integer conversationId) {
        this.conversationId = conversationId;
    }

    public String getUser1Id() {
        return user1Id;
    }

    public void setUser1Id(String user1Id) {
        this.user1Id = user1Id;
    }

    public String getUser2Id() {
        return user2Id;
    }

    public void setUser2Id(String user2Id) {
        this.user2Id = user2Id;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getLastMessageAt() {
        return lastMessageAt;
    }

    public void setLastMessageAt(Date lastMessageAt) {
        this.lastMessageAt = lastMessageAt;
    }

    public String getLastMessageText() {
        return lastMessageText;
    }

    public void setLastMessageText(String lastMessageText) {
        this.lastMessageText = lastMessageText;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (conversationId != null ? conversationId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof PrivateConversations)) {
            return false;
        }
        PrivateConversations other = (PrivateConversations) object;
        if ((this.conversationId == null && other.conversationId != null) || (this.conversationId != null && !this.conversationId.equals(other.conversationId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.PrivateConversations[ conversationId=" + conversationId + " ]";
    }
    
}
