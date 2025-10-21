/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
<<<<<<< HEAD
import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
=======
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;
>>>>>>> 89676be6c4dacb242a202b874ae4ad102c10f6b5

/**
 *
 * @author LP
 */
@Embeddable
public class TagPK implements Serializable {

    @Basic(optional = false)
    @Column(name = "ArticleId")
    private String articleId;
    @Basic(optional = false)
    @Column(name = "Id")
    private int id;

    public TagPK() {
    }

    public TagPK(String articleId, int id) {
        this.articleId = articleId;
        this.id = id;
    }

    public String getArticleId() {
        return articleId;
    }

    public void setArticleId(String articleId) {
        this.articleId = articleId;
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
        hash += (articleId != null ? articleId.hashCode() : 0);
        hash += (int) id;
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TagPK)) {
            return false;
        }
        TagPK other = (TagPK) object;
        if ((this.articleId == null && other.articleId != null) || (this.articleId != null && !this.articleId.equals(other.articleId))) {
            return false;
        }
        if (this.id != other.id) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.TagPK[ articleId=" + articleId + ", id=" + id + " ]";
    }
    
}
