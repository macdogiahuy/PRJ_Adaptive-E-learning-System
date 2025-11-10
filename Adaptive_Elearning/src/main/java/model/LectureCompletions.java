package model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(
    name = "LectureCompletions",
    uniqueConstraints = @UniqueConstraint(columnNames = {"UserId", "LectureId"})
)
public class LectureCompletions implements Serializable {

    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id; // UUID string

    @JoinColumn(name = "UserId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Users userId;

    @JoinColumn(name = "LectureId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Lectures lectureId;

    @Column(name = "CompletedDate", insertable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date completedDate;

    public LectureCompletions() {}

    public LectureCompletions(String id) {
        this.id = id;
    }

    // getters & setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public Users getUserId() { return userId; }
    public void setUserId(Users userId) { this.userId = userId; }

    public Lectures getLectureId() { return lectureId; }
    public void setLectureId(Lectures lectureId) { this.lectureId = lectureId; }

    public Date getCompletedDate() { return completedDate; }
    public void setCompletedDate(Date completedDate) { this.completedDate = completedDate; }

    @Override
    public int hashCode() { return (id != null ? id.hashCode() : 0); }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof LectureCompletions)) return false;
        LectureCompletions other = (LectureCompletions) object;
        return (this.id != null || other.id == null)
            && (this.id == null || this.id.equals(other.id));
    }

    @Override
    public String toString() {
        return "model.LectureCompletions[ id=" + id + " ]";
    }
}
