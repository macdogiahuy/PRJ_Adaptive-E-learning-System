/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "Articles")
@NamedQueries({
    @NamedQuery(name = "Articles.findAll", query = "SELECT a FROM Articles a"),
    @NamedQuery(name = "Articles.findById", query = "SELECT a FROM Articles a WHERE a.id = :id"),
    @NamedQuery(name = "Articles.findByContent", query = "SELECT a FROM Articles a WHERE a.content = :content"),
    @NamedQuery(name = "Articles.findByTitle", query = "SELECT a FROM Articles a WHERE a.title = :title"),
    @NamedQuery(name = "Articles.findByStatus", query = "SELECT a FROM Articles a WHERE a.status = :status"),
    @NamedQuery(name = "Articles.findByIsCommentDisabled", query = "SELECT a FROM Articles a WHERE a.isCommentDisabled = :isCommentDisabled"),
    @NamedQuery(name = "Articles.findByCommentCount", query = "SELECT a FROM Articles a WHERE a.commentCount = :commentCount"),
    @NamedQuery(name = "Articles.findByViewCount", query = "SELECT a FROM Articles a WHERE a.viewCount = :viewCount"),
    @NamedQuery(name = "Articles.findByCreationTime", query = "SELECT a FROM Articles a WHERE a.creationTime = :creationTime"),
    @NamedQuery(name = "Articles.findByLastModificationTime", query = "SELECT a FROM Articles a WHERE a.lastModificationTime = :lastModificationTime"),
    @NamedQuery(name = "Articles.findByLastModifierId", query = "SELECT a FROM Articles a WHERE a.lastModifierId = :lastModifierId")})
public class Articles implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @Column(name = "Content")
    private String content;
    @Basic(optional = false)
    @Column(name = "Title")
    private String title;
    @Basic(optional = false)
    @Column(name = "Status")
    private String status;
    @Basic(optional = false)
    @Column(name = "IsCommentDisabled")
    private boolean isCommentDisabled;
    @Basic(optional = false)
    @Column(name = "CommentCount")
    private int commentCount;
    @Basic(optional = false)
    @Column(name = "ViewCount")
    private int viewCount;
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
    @JoinColumn(name = "CreatorId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Users creatorId;
    @OneToMany(mappedBy = "articleId")
    private List<Reactions> reactionsList;
    @OneToMany(mappedBy = "articleId")
    private List<Comments> commentsList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "articles")
    private List<Tag> tagList;

    public Articles() {
    }

    public Articles(String id) {
        this.id = id;
    }

    public Articles(String id, String content, String title, String status, boolean isCommentDisabled, int commentCount, int viewCount, Date creationTime, Date lastModificationTime, String lastModifierId) {
        this.id = id;
        this.content = content;
        this.title = title;
        this.status = status;
        this.isCommentDisabled = isCommentDisabled;
        this.commentCount = commentCount;
        this.viewCount = viewCount;
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean getIsCommentDisabled() {
        return isCommentDisabled;
    }

    public void setIsCommentDisabled(boolean isCommentDisabled) {
        this.isCommentDisabled = isCommentDisabled;
    }

    public int getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
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

    public Users getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(Users creatorId) {
        this.creatorId = creatorId;
    }

    public List<Reactions> getReactionsList() {
        return reactionsList;
    }

    public void setReactionsList(List<Reactions> reactionsList) {
        this.reactionsList = reactionsList;
    }

    public List<Comments> getCommentsList() {
        return commentsList;
    }

    public void setCommentsList(List<Comments> commentsList) {
        this.commentsList = commentsList;
    }

    public List<Tag> getTagList() {
        return tagList;
    }

    public void setTagList(List<Tag> tagList) {
        this.tagList = tagList;
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
        if (!(object instanceof Articles)) {
            return false;
        }
        Articles other = (Articles) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Articles[ id=" + id + " ]";
    }
    
}
