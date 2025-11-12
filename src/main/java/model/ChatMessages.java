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
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "ChatMessages")
@NamedQueries({
    @NamedQuery(name = "ChatMessages.findAll", query = "SELECT c FROM ChatMessages c"),
    @NamedQuery(name = "ChatMessages.findById", query = "SELECT c FROM ChatMessages c WHERE c.id = :id"),
    @NamedQuery(name = "ChatMessages.findByContent", query = "SELECT c FROM ChatMessages c WHERE c.content = :content"),
    @NamedQuery(name = "ChatMessages.findByStatus", query = "SELECT c FROM ChatMessages c WHERE c.status = :status"),
    @NamedQuery(name = "ChatMessages.findByCreationTime", query = "SELECT c FROM ChatMessages c WHERE c.creationTime = :creationTime"),
    @NamedQuery(name = "ChatMessages.findByLastModificationTime", query = "SELECT c FROM ChatMessages c WHERE c.lastModificationTime = :lastModificationTime"),
    @NamedQuery(name = "ChatMessages.findByLastModifierId", query = "SELECT c FROM ChatMessages c WHERE c.lastModifierId = :lastModifierId")})
public class ChatMessages implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @Column(name = "Content")
    private String content;
    @Basic(optional = false)
    @Column(name = "Status")
    private String status;
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
    @OneToMany(mappedBy = "chatMessageId")
    private List<Reactions> reactionsList;
    @JoinColumn(name = "ConversationId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Conversations conversationId;
    @JoinColumn(name = "CreatorId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Users creatorId;

    public ChatMessages() {
    }

    public ChatMessages(String id) {
        this.id = id;
    }

    public ChatMessages(String id, String content, String status, Date creationTime, Date lastModificationTime, String lastModifierId) {
        this.id = id;
        this.content = content;
        this.status = status;
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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
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

    public List<Reactions> getReactionsList() {
        return reactionsList;
    }

    public void setReactionsList(List<Reactions> reactionsList) {
        this.reactionsList = reactionsList;
    }

    public Conversations getConversationId() {
        return conversationId;
    }

    public void setConversationId(Conversations conversationId) {
        this.conversationId = conversationId;
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
        if (!(object instanceof ChatMessages)) {
            return false;
        }
        ChatMessages other = (ChatMessages) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.ChatMessages[ id=" + id + " ]";
    }
    
}
