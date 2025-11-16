/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import jakarta.persistence.Basic;
import jakarta.persistence.CascadeType;
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
@Table(name = "Conversations")
@NamedQueries({
    @NamedQuery(name = "Conversations.findAll", query = "SELECT c FROM Conversations c"),
    @NamedQuery(name = "Conversations.findById", query = "SELECT c FROM Conversations c WHERE c.id = :id"),
    @NamedQuery(name = "Conversations.findByTitle", query = "SELECT c FROM Conversations c WHERE c.title = :title"),
    @NamedQuery(name = "Conversations.findByIsPrivate", query = "SELECT c FROM Conversations c WHERE c.isPrivate = :isPrivate"),
    @NamedQuery(name = "Conversations.findByAvatarUrl", query = "SELECT c FROM Conversations c WHERE c.avatarUrl = :avatarUrl"),
    @NamedQuery(name = "Conversations.findByCreationTime", query = "SELECT c FROM Conversations c WHERE c.creationTime = :creationTime")})
public class Conversations implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @Column(name = "Title")
    private String title;
    @Basic(optional = false)
    @Column(name = "IsPrivate")
    private boolean isPrivate;
    @Basic(optional = false)
    @Column(name = "AvatarUrl")
    private String avatarUrl;
    @Basic(optional = false)
    @Column(name = "CreationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;
    @JoinColumn(name = "CreatorId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Users creatorId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "conversationId")
    private List<ChatMessages> chatMessagesList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "conversations")
    private List<ConversationMembers> conversationMembersList;

    public Conversations() {
    }

    public Conversations(String id) {
        this.id = id;
    }

    public Conversations(String id, String title, boolean isPrivate, String avatarUrl, Date creationTime) {
        this.id = id;
        this.title = title;
        this.isPrivate = isPrivate;
        this.avatarUrl = avatarUrl;
        this.creationTime = creationTime;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public boolean getIsPrivate() {
        return isPrivate;
    }

    public void setIsPrivate(boolean isPrivate) {
        this.isPrivate = isPrivate;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public Users getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(Users creatorId) {
        this.creatorId = creatorId;
    }

    public List<ChatMessages> getChatMessagesList() {
        return chatMessagesList;
    }

    public void setChatMessagesList(List<ChatMessages> chatMessagesList) {
        this.chatMessagesList = chatMessagesList;
    }

    public List<ConversationMembers> getConversationMembersList() {
        return conversationMembersList;
    }

    public void setConversationMembersList(List<ConversationMembers> conversationMembersList) {
        this.conversationMembersList = conversationMembersList;
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
        if (!(object instanceof Conversations)) {
            return false;
        }
        Conversations other = (Conversations) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Conversations[ id=" + id + " ]";
    }
    
}
