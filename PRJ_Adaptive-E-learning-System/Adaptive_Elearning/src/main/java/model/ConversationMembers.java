/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
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
@Table(name = "ConversationMembers")
@NamedQueries({
    @NamedQuery(name = "ConversationMembers.findAll", query = "SELECT c FROM ConversationMembers c"),
    @NamedQuery(name = "ConversationMembers.findByCreatorId", query = "SELECT c FROM ConversationMembers c WHERE c.conversationMembersPK.creatorId = :creatorId"),
    @NamedQuery(name = "ConversationMembers.findByConversationId", query = "SELECT c FROM ConversationMembers c WHERE c.conversationMembersPK.conversationId = :conversationId"),
    @NamedQuery(name = "ConversationMembers.findByIsAdmin", query = "SELECT c FROM ConversationMembers c WHERE c.isAdmin = :isAdmin"),
    @NamedQuery(name = "ConversationMembers.findByLastVisit", query = "SELECT c FROM ConversationMembers c WHERE c.lastVisit = :lastVisit"),
    @NamedQuery(name = "ConversationMembers.findByCreationTime", query = "SELECT c FROM ConversationMembers c WHERE c.creationTime = :creationTime")})
public class ConversationMembers implements Serializable {

    private static final long serialVersionUID = 1L;
    @EmbeddedId
    protected ConversationMembersPK conversationMembersPK;
    @Basic(optional = false)
    @Column(name = "IsAdmin")
    private boolean isAdmin;
    @Basic(optional = false)
    @Column(name = "LastVisit")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastVisit;
    @Basic(optional = false)
    @Column(name = "CreationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;
    @JoinColumn(name = "ConversationId", referencedColumnName = "Id", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private Conversations conversations;
    @JoinColumn(name = "CreatorId", referencedColumnName = "Id", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private Users users;

    public ConversationMembers() {
    }

    public ConversationMembers(ConversationMembersPK conversationMembersPK) {
        this.conversationMembersPK = conversationMembersPK;
    }

    public ConversationMembers(ConversationMembersPK conversationMembersPK, boolean isAdmin, Date lastVisit, Date creationTime) {
        this.conversationMembersPK = conversationMembersPK;
        this.isAdmin = isAdmin;
        this.lastVisit = lastVisit;
        this.creationTime = creationTime;
    }

    public ConversationMembers(String creatorId, String conversationId) {
        this.conversationMembersPK = new ConversationMembersPK(creatorId, conversationId);
    }

    public ConversationMembersPK getConversationMembersPK() {
        return conversationMembersPK;
    }

    public void setConversationMembersPK(ConversationMembersPK conversationMembersPK) {
        this.conversationMembersPK = conversationMembersPK;
    }

    public boolean getIsAdmin() {
        return isAdmin;
    }

    public void setIsAdmin(boolean isAdmin) {
        this.isAdmin = isAdmin;
    }

    public Date getLastVisit() {
        return lastVisit;
    }

    public void setLastVisit(Date lastVisit) {
        this.lastVisit = lastVisit;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public Conversations getConversations() {
        return conversations;
    }

    public void setConversations(Conversations conversations) {
        this.conversations = conversations;
    }

    public Users getUsers() {
        return users;
    }

    public void setUsers(Users users) {
        this.users = users;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (conversationMembersPK != null ? conversationMembersPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ConversationMembers)) {
            return false;
        }
        ConversationMembers other = (ConversationMembers) object;
        if ((this.conversationMembersPK == null && other.conversationMembersPK != null) || (this.conversationMembersPK != null && !this.conversationMembersPK.equals(other.conversationMembersPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.ConversationMembers[ conversationMembersPK=" + conversationMembersPK + " ]";
    }
    
}
