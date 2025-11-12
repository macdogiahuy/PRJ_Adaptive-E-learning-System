/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

/**
 *
 * @author LP
 */
@Embeddable
public class CommentMediaPK implements Serializable {

    @Basic(optional = false)
    @Column(name = "CommentId")
    private String commentId;
    @Basic(optional = false)
    @Column(name = "Id")
    private int id;

    public CommentMediaPK() {
    }

    public CommentMediaPK(String commentId, int id) {
        this.commentId = commentId;
        this.id = id;
    }

    public String getCommentId() {
        return commentId;
    }

    public void setCommentId(String commentId) {
        this.commentId = commentId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (commentId != null ? commentId.hashCode() : 0);
        hash += (int) id;
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof CommentMediaPK)) {
            return false;
        }
        CommentMediaPK other = (CommentMediaPK) object;
        if ((this.commentId == null && other.commentId != null) || (this.commentId != null && !this.commentId.equals(other.commentId))) {
            return false;
        }
        if (this.id != other.id) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.CommentMediaPK[ commentId=" + commentId + ", id=" + id + " ]";
    }
    
}
