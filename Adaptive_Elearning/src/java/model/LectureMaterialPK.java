/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 *
 * @author LP
 */
@Embeddable
public class LectureMaterialPK implements Serializable {

    @Basic(optional = false)
    @Column(name = "LectureId")
    private String lectureId;
    @Basic(optional = false)
    @Column(name = "Id")
    private int id;

    public LectureMaterialPK() {
    }

    public LectureMaterialPK(String lectureId, int id) {
        this.lectureId = lectureId;
        this.id = id;
    }

    public String getLectureId() {
        return lectureId;
    }

    public void setLectureId(String lectureId) {
        this.lectureId = lectureId;
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
        hash += (lectureId != null ? lectureId.hashCode() : 0);
        hash += (int) id;
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof LectureMaterialPK)) {
            return false;
        }
        LectureMaterialPK other = (LectureMaterialPK) object;
        if ((this.lectureId == null && other.lectureId != null) || (this.lectureId != null && !this.lectureId.equals(other.lectureId))) {
            return false;
        }
        if (this.id != other.id) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.LectureMaterialPK[ lectureId=" + lectureId + ", id=" + id + " ]";
    }
    
}
