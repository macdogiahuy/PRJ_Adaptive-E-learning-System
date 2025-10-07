/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "Tag")
@NamedQueries({
    @NamedQuery(name = "Tag.findAll", query = "SELECT t FROM Tag t"),
    @NamedQuery(name = "Tag.findByArticleId", query = "SELECT t FROM Tag t WHERE t.tagPK.articleId = :articleId"),
    @NamedQuery(name = "Tag.findById", query = "SELECT t FROM Tag t WHERE t.tagPK.id = :id"),
    @NamedQuery(name = "Tag.findByTitle", query = "SELECT t FROM Tag t WHERE t.title = :title")})
public class Tag implements Serializable {

    private static final long serialVersionUID = 1L;
    @EmbeddedId
    protected TagPK tagPK;
    @Basic(optional = false)
    @Column(name = "Title")
    private String title;
    @JoinColumn(name = "ArticleId", referencedColumnName = "Id", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private Articles articles;

    public Tag() {
    }

    public Tag(TagPK tagPK) {
        this.tagPK = tagPK;
    }

    public Tag(TagPK tagPK, String title) {
        this.tagPK = tagPK;
        this.title = title;
    }

    public Tag(String articleId, int id) {
        this.tagPK = new TagPK(articleId, id);
    }

    public TagPK getTagPK() {
        return tagPK;
    }

    public void setTagPK(TagPK tagPK) {
        this.tagPK = tagPK;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Articles getArticles() {
        return articles;
    }

    public void setArticles(Articles articles) {
        this.articles = articles;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (tagPK != null ? tagPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Tag)) {
            return false;
        }
        Tag other = (Tag) object;
        if ((this.tagPK == null && other.tagPK != null) || (this.tagPK != null && !this.tagPK.equals(other.tagPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Tag[ tagPK=" + tagPK + " ]";
    }
    
}
