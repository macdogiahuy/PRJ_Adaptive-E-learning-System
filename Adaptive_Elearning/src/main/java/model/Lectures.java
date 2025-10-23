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
@Table(name = "Lectures")
@NamedQueries({
    @NamedQuery(name = "Lectures.findAll", query = "SELECT l FROM Lectures l"),
    @NamedQuery(name = "Lectures.findById", query = "SELECT l FROM Lectures l WHERE l.id = :id"),
    @NamedQuery(name = "Lectures.findByTitle", query = "SELECT l FROM Lectures l WHERE l.title = :title"),
    @NamedQuery(name = "Lectures.findByContent", query = "SELECT l FROM Lectures l WHERE l.content = :content"),
    @NamedQuery(name = "Lectures.findByCreationTime", query = "SELECT l FROM Lectures l WHERE l.creationTime = :creationTime"),
    @NamedQuery(name = "Lectures.findByLastModificationTime", query = "SELECT l FROM Lectures l WHERE l.lastModificationTime = :lastModificationTime"),
    @NamedQuery(name = "Lectures.findByIsPreviewable", query = "SELECT l FROM Lectures l WHERE l.isPreviewable = :isPreviewable")})
public class Lectures implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @Column(name = "Title")
    private String title;
    @Basic(optional = false)
    @Column(name = "Content")
    private String content;
    @Basic(optional = false)
    @Column(name = "CreationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date creationTime;
    @Basic(optional = false)
    @Column(name = "LastModificationTime")
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastModificationTime;
    @Basic(optional = false)
    @Column(name = "IsPreviewable")
    private boolean isPreviewable;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "lectures")
    private List<LectureMaterial> lectureMaterialList;
    @OneToMany(mappedBy = "lectureId")
    private List<Comments> commentsList;
    @JoinColumn(name = "SectionId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Sections sectionId;

    public Lectures() {
    }

    public Lectures(String id) {
        this.id = id;
    }

    public Lectures(String id, String title, String content, Date creationTime, Date lastModificationTime, boolean isPreviewable) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.creationTime = creationTime;
        this.lastModificationTime = lastModificationTime;
        this.isPreviewable = isPreviewable;
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

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
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

    public boolean getIsPreviewable() {
        return isPreviewable;
    }

    public void setIsPreviewable(boolean isPreviewable) {
        this.isPreviewable = isPreviewable;
    }

    public List<LectureMaterial> getLectureMaterialList() {
        return lectureMaterialList;
    }

    public void setLectureMaterialList(List<LectureMaterial> lectureMaterialList) {
        this.lectureMaterialList = lectureMaterialList;
    }

    public List<Comments> getCommentsList() {
        return commentsList;
    }

    public void setCommentsList(List<Comments> commentsList) {
        this.commentsList = commentsList;
    }

    public Sections getSectionId() {
        return sectionId;
    }

    public void setSectionId(Sections sectionId) {
        this.sectionId = sectionId;
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
        if (!(object instanceof Lectures)) {
            return false;
        }
        Lectures other = (Lectures) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Lectures[ id=" + id + " ]";
    }
    
}
