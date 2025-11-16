/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "Reactions")
@NamedQueries({
    @NamedQuery(name = "Reactions.findAll", query = "SELECT r FROM Reactions r"),
    @NamedQuery(name = "Reactions.findByCreatorId", query = "SELECT r FROM Reactions r WHERE r.reactionsPK.creatorId = :creatorId"),
    @NamedQuery(name = "Reactions.findBySourceEntityId", query = "SELECT r FROM Reactions r WHERE r.reactionsPK.sourceEntityId = :sourceEntityId"),
    @NamedQuery(name = "Reactions.findByContent", query = "SELECT r FROM Reactions r WHERE r.content = :content"),
    @NamedQuery(name = "Reactions.findBySourceType", query = "SELECT r FROM Reactions r WHERE r.sourceType = :sourceType"),
    @NamedQuery(name = "Reactions.findByCreationTime", query = "SELECT r FROM Reactions r WHERE r.creationTime = :creationTime")})
public class Reactions implements Serializable {

    private static final long serialVersionUID = 1L;
    @EmbeddedId
    protected ReactionsPK reactionsPK;
    @Basic(optional = false)
    @Column(name = "Content")
    private String content;
    @Basic(optional = false)
    @Column(name = "SourceType")
    private String sourceType;
    @Basic(optional = false)
    @Column(name = "CreationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;
    @JoinColumn(name = "ArticleId", referencedColumnName = "Id")
    @ManyToOne
    private Articles articleId;
    @JoinColumn(name = "ChatMessageId", referencedColumnName = "Id")
    @ManyToOne
    private ChatMessages chatMessageId;
    @JoinColumn(name = "CommentId", referencedColumnName = "Id")
    @ManyToOne
    private Comments commentId;

    public Reactions() {
    }

    public Reactions(ReactionsPK reactionsPK) {
        this.reactionsPK = reactionsPK;
    }

    public Reactions(ReactionsPK reactionsPK, String content, String sourceType, Date creationTime) {
        this.reactionsPK = reactionsPK;
        this.content = content;
        this.sourceType = sourceType;
        this.creationTime = creationTime;
    }

    public Reactions(String creatorId, String sourceEntityId) {
        this.reactionsPK = new ReactionsPK(creatorId, sourceEntityId);
    }

    public ReactionsPK getReactionsPK() {
        return reactionsPK;
    }

    public void setReactionsPK(ReactionsPK reactionsPK) {
        this.reactionsPK = reactionsPK;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getSourceType() {
        return sourceType;
    }

    public void setSourceType(String sourceType) {
        this.sourceType = sourceType;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public Articles getArticleId() {
        return articleId;
    }

    public void setArticleId(Articles articleId) {
        this.articleId = articleId;
    }

    public ChatMessages getChatMessageId() {
        return chatMessageId;
    }

    public void setChatMessageId(ChatMessages chatMessageId) {
        this.chatMessageId = chatMessageId;
    }

    public Comments getCommentId() {
        return commentId;
    }

    public void setCommentId(Comments commentId) {
        this.commentId = commentId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (reactionsPK != null ? reactionsPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Reactions)) {
            return false;
        }
        Reactions other = (Reactions) object;
        if ((this.reactionsPK == null && other.reactionsPK != null) || (this.reactionsPK != null && !this.reactionsPK.equals(other.reactionsPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Reactions[ reactionsPK=" + reactionsPK + " ]";
    }
    
}
