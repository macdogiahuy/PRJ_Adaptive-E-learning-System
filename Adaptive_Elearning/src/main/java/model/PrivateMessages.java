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
@Table(name = "PrivateMessages")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "PrivateMessages.findAll", query = "SELECT p FROM PrivateMessages p"),
    @NamedQuery(name = "PrivateMessages.findByMessageId", query = "SELECT p FROM PrivateMessages p WHERE p.messageId = :messageId"),
    @NamedQuery(name = "PrivateMessages.findByConversationId", query = "SELECT p FROM PrivateMessages p WHERE p.conversationId = :conversationId"),
    @NamedQuery(name = "PrivateMessages.findBySenderId", query = "SELECT p FROM PrivateMessages p WHERE p.senderId = :senderId"),
    @NamedQuery(name = "PrivateMessages.findByMessageText", query = "SELECT p FROM PrivateMessages p WHERE p.messageText = :messageText"),
    @NamedQuery(name = "PrivateMessages.findBySentAt", query = "SELECT p FROM PrivateMessages p WHERE p.sentAt = :sentAt"),
    @NamedQuery(name = "PrivateMessages.findByIsRead", query = "SELECT p FROM PrivateMessages p WHERE p.isRead = :isRead")})
public class PrivateMessages implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "message_id")
    private Integer messageId;
    @Basic(optional = false)
    @NotNull
    @Column(name = "conversation_id")
    private int conversationId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "sender_id")
    private String senderId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 2147483647)
    @Column(name = "message_text")
    private String messageText;
    @Basic(optional = false)
    @NotNull
    @Column(name = "sent_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date sentAt;
    @Basic(optional = false)
    @NotNull
    @Column(name = "is_read")
    private boolean isRead;

    public PrivateMessages() {
    }

    public PrivateMessages(Integer messageId) {
        this.messageId = messageId;
    }

    public PrivateMessages(Integer messageId, int conversationId, String senderId, String messageText, Date sentAt, boolean isRead) {
        this.messageId = messageId;
        this.conversationId = conversationId;
        this.senderId = senderId;
        this.messageText = messageText;
        this.sentAt = sentAt;
        this.isRead = isRead;
    }

    public Integer getMessageId() {
        return messageId;
    }

    public void setMessageId(Integer messageId) {
        this.messageId = messageId;
    }

    public int getConversationId() {
        return conversationId;
    }

    public void setConversationId(int conversationId) {
        this.conversationId = conversationId;
    }

    public String getSenderId() {
        return senderId;
    }

    public void setSenderId(String senderId) {
        this.senderId = senderId;
    }

    public String getMessageText() {
        return messageText;
    }

    public void setMessageText(String messageText) {
        this.messageText = messageText;
    }

    public Date getSentAt() {
        return sentAt;
    }

    public void setSentAt(Date sentAt) {
        this.sentAt = sentAt;
    }

    public boolean getIsRead() {
        return isRead;
    }

    public void setIsRead(boolean isRead) {
        this.isRead = isRead;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (messageId != null ? messageId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof PrivateMessages)) {
            return false;
        }
        PrivateMessages other = (PrivateMessages) object;
        if ((this.messageId == null && other.messageId != null) || (this.messageId != null && !this.messageId.equals(other.messageId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.PrivateMessages[ messageId=" + messageId + " ]";
    }
    
}
