package model;

import java.io.Serializable;
import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "LectureMaterial")
public class LectureMaterial implements Serializable {

    private static final long serialVersionUID = 1L;

    @EmbeddedId
    protected LectureMaterialPK lectureMaterialPK;   // Composite key: lectureId + id

    @Basic(optional = false)
    @Column(name = "Type")
    private String type;        // file type in DB

    @Basic(optional = false)
    @Column(name = "Url", length = 1024)
    private String url;         // drive link in DB

    @JoinColumn(
            name = "LectureId",
            referencedColumnName = "Id",
            insertable = false,
            updatable = false
    )
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

    // ============================================================
    //            GETTERS & SETTERS (STANDARD)
    // ============================================================

    public LectureMaterialPK getLectureMaterialPK() {
        return lectureMaterialPK;
    }

    public void setLectureMaterialPK(LectureMaterialPK lectureMaterialPK) {
        this.lectureMaterialPK = lectureMaterialPK;
    }

    public String getType() {               // original DB field
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUrl() {                // original DB field
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

    // ============================================================
    //      ALIAS GETTERS REQUIRED BY SERVLET (FIX ERROR)
    // ============================================================

    // ✔ Alias for getFileType() required by your servlet
    public String getFileType() {
        return type;
    }

    public void setFileType(String fileType) {
        this.type = fileType;
    }

    // ✔ Alias for getDriveLink()
    public String getDriveLink() {
        return url;
    }

    public void setDriveLink(String driveLink) {
        this.url = driveLink;
    }
// ✔ Alias for getFileName() – database does NOT store this column,
    //   but servlet requires it for DTO, so we return a default.
    public String getFileName() {
        // If you later add a real fileName column in DB, update here
        if (url == null) return null;

        // Extract filename from Google Drive URL if possible
        int index = url.lastIndexOf('/');
        return (index > -1 ? url.substring(index + 1) : url);
    }

    public void setFileName(String fileName) {
        // Nothing to store in DB → no fileName column
        // You may extend this later if you add fileName to DB
    }

    // ============================================================

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (lectureMaterialPK != null ? lectureMaterialPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof LectureMaterial)) {
            return false;
        }
        LectureMaterial other = (LectureMaterial) object;
        return !((this.lectureMaterialPK == null && other.lectureMaterialPK != null) ||
                 (this.lectureMaterialPK != null && !this.lectureMaterialPK.equals(other.lectureMaterialPK)));
    }

    @Override
    public String toString() {
        return "model.LectureMaterial[ lectureMaterialPK=" + lectureMaterialPK + " ]";
    }

}