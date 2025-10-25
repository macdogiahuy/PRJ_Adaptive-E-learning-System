/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "CommentMedia")
@NamedQueries({
    @NamedQuery(name = "CommentMedia.findAll", query = "SELECT c FROM CommentMedia c"),
    @NamedQuery(name = "CommentMedia.findByCommentId", query = "SELECT c FROM CommentMedia c WHERE c.commentMediaPK.commentId = :commentId"),
    @NamedQuery(name = "CommentMedia.findById", query = "SELECT c FROM CommentMedia c WHERE c.commentMediaPK.id = :id"),
    @NamedQuery(name = "CommentMedia.findByType", query = "SELECT c FROM CommentMedia c WHERE c.type = :type"),
    @NamedQuery(name = "CommentMedia.findByUrl", query = "SELECT c FROM CommentMedia c WHERE c.url = :url")})
public class CommentMedia implements Serializable {

    private static final long serialVersionUID = 1L;
    @EmbeddedId
    protected CommentMediaPK commentMediaPK;
    @Basic(optional = false)
    @Column(name = "Type")
    private String type;
    @Basic(optional = false)
    @Column(name = "Url")
    private String url;
    @JoinColumn(name = "CommentId", referencedColumnName = "Id", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private Comments comments;

    public CommentMedia() {
    }

    public CommentMedia(CommentMediaPK commentMediaPK) {
        this.commentMediaPK = commentMediaPK;
    }

    public CommentMedia(CommentMediaPK commentMediaPK, String type, String url) {
        this.commentMediaPK = commentMediaPK;
        this.type = type;
        this.url = url;
    }

    public CommentMedia(String commentId, int id) {
        this.commentMediaPK = new CommentMediaPK(commentId, id);
    }

    public CommentMediaPK getCommentMediaPK() {
        return commentMediaPK;
    }

    public void setCommentMediaPK(CommentMediaPK commentMediaPK) {
        this.commentMediaPK = commentMediaPK;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Comments getComments() {
        return comments;
    }

    public void setComments(Comments comments) {
        this.comments = comments;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (commentMediaPK != null ? commentMediaPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof CommentMedia)) {
            return false;
        }
        CommentMedia other = (CommentMedia) object;
        if ((this.commentMediaPK == null && other.commentMediaPK != null) || (this.commentMediaPK != null && !this.commentMediaPK.equals(other.commentMediaPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.CommentMedia[ commentMediaPK=" + commentMediaPK + " ]";
    }
    
}
