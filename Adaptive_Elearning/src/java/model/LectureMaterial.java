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
@Table(name = "LectureMaterial")
@NamedQueries({
    @NamedQuery(name = "LectureMaterial.findAll", query = "SELECT l FROM LectureMaterial l"),
    @NamedQuery(name = "LectureMaterial.findByLectureId", query = "SELECT l FROM LectureMaterial l WHERE l.lectureMaterialPK.lectureId = :lectureId"),
    @NamedQuery(name = "LectureMaterial.findById", query = "SELECT l FROM LectureMaterial l WHERE l.lectureMaterialPK.id = :id"),
    @NamedQuery(name = "LectureMaterial.findByType", query = "SELECT l FROM LectureMaterial l WHERE l.type = :type"),
    @NamedQuery(name = "LectureMaterial.findByUrl", query = "SELECT l FROM LectureMaterial l WHERE l.url = :url")})
public class LectureMaterial implements Serializable {

    private static final long serialVersionUID = 1L;
    @EmbeddedId
    protected LectureMaterialPK lectureMaterialPK;
    @Basic(optional = false)
    @Column(name = "Type")
    private String type;
    @Basic(optional = false)
    @Column(name = "Url")
    private String url;
    @JoinColumn(name = "LectureId", referencedColumnName = "Id", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private Lectures lectures;

    public LectureMaterial() {
    }

    public LectureMaterial(LectureMaterialPK lectureMaterialPK) {
        this.lectureMaterialPK = lectureMaterialPK;
    }

    public LectureMaterial(LectureMaterialPK lectureMaterialPK, String type, String url) {
        this.lectureMaterialPK = lectureMaterialPK;
        this.type = type;
        this.url = url;
    }

    public LectureMaterial(String lectureId, int id) {
        this.lectureMaterialPK = new LectureMaterialPK(lectureId, id);
    }

    public LectureMaterialPK getLectureMaterialPK() {
        return lectureMaterialPK;
    }

    public void setLectureMaterialPK(LectureMaterialPK lectureMaterialPK) {
        this.lectureMaterialPK = lectureMaterialPK;
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

    public Lectures getLectures() {
        return lectures;
    }

    public void setLectures(Lectures lectures) {
        this.lectures = lectures;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (lectureMaterialPK != null ? lectureMaterialPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof LectureMaterial)) {
            return false;
        }
        LectureMaterial other = (LectureMaterial) object;
        if ((this.lectureMaterialPK == null && other.lectureMaterialPK != null) || (this.lectureMaterialPK != null && !this.lectureMaterialPK.equals(other.lectureMaterialPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.LectureMaterial[ lectureMaterialPK=" + lectureMaterialPK + " ]";
    }
    
}
