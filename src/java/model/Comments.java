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
@Table(name = "Comments")
@NamedQueries({
    @NamedQuery(name = "Comments.findAll", query = "SELECT c FROM Comments c"),
    @NamedQuery(name = "Comments.findById", query = "SELECT c FROM Comments c WHERE c.id = :id"),
    @NamedQuery(name = "Comments.findByContent", query = "SELECT c FROM Comments c WHERE c.content = :content"),
    @NamedQuery(name = "Comments.findByStatus", query = "SELECT c FROM Comments c WHERE c.status = :status"),
    @NamedQuery(name = "Comments.findBySourceType", query = "SELECT c FROM Comments c WHERE c.sourceType = :sourceType"),
    @NamedQuery(name = "Comments.findByCreationTime", query = "SELECT c FROM Comments c WHERE c.creationTime = :creationTime"),
    @NamedQuery(name = "Comments.findByLastModificationTime", query = "SELECT c FROM Comments c WHERE c.lastModificationTime = :lastModificationTime"),
    @NamedQuery(name = "Comments.findByLastModifierId", query = "SELECT c FROM Comments c WHERE c.lastModifierId = :lastModifierId")})
public class Comments implements Serializable {

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
    @Column(name = "SourceType")
    private String sourceType;
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
    @OneToMany(mappedBy = "commentId")
    private List<Reactions> reactionsList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "comments")
    private List<CommentMedia> commentMediaList;
    @JoinColumn(name = "ArticleId", referencedColumnName = "Id")
    @ManyToOne
    private Articles articleId;
    @OneToMany(mappedBy = "parentId")
    private List<Comments> commentsList;
    @JoinColumn(name = "ParentId", referencedColumnName = "Id")
    @ManyToOne
    private Comments parentId;
    @JoinColumn(name = "LectureId", referencedColumnName = "Id")
    @ManyToOne
    private Lectures lectureId;
    @JoinColumn(name = "CreatorId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Users creatorId;

    public Comments() {
    }

    public Comments(String id) {
        this.id = id;
    }

    public Comments(String id, String content, String status, String sourceType, Date creationTime, Date lastModificationTime, String lastModifierId) {
        this.id = id;
        this.content = content;
        this.status = status;
        this.sourceType = sourceType;
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

    public List<CommentMedia> getCommentMediaList() {
        return commentMediaList;
    }

    public void setCommentMediaList(List<CommentMedia> commentMediaList) {
        this.commentMediaList = commentMediaList;
    }

    public Articles getArticleId() {
        return articleId;
    }

    public void setArticleId(Articles articleId) {
        this.articleId = articleId;
    }

    public List<Comments> getCommentsList() {
        return commentsList;
    }

    public void setCommentsList(List<Comments> commentsList) {
        this.commentsList = commentsList;
    }

    public Comments getParentId() {
        return parentId;
    }

    public void setParentId(Comments parentId) {
        this.parentId = parentId;
    }

    public Lectures getLectureId() {
        return lectureId;
    }

    public void setLectureId(Lectures lectureId) {
        this.lectureId = lectureId;
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
        if (!(object instanceof Comments)) {
            return false;
        }
        Comments other = (Comments) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Comments[ id=" + id + " ]";
    }
    
}
