package model;

// THÊM 2 IMPORT NÀY
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.Objects; // Sửa lại import cho .equals

@Entity
@Table(
    name = "LectureCompletions",
    uniqueConstraints = @UniqueConstraint(columnNames = {"UserId", "LectureId"})
)
public class LectureCompletions implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) // <-- THÊM DÒNG NÀY
    @Basic(optional = false)
    @Column(name = "Id")
    private Long id; // <-- SỬA TỪ String sang Long (hoặc Integer)

    @JoinColumn(name = "UserId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Users userId;

    @JoinColumn(name = "LectureId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Lectures lectureId;

    @Column(name = "CompletedDate", insertable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date completedDate;

    public LectureCompletions() {
        // Không cần gán ID ở đây nữa, CSDL sẽ tự làm
    }

    // Xóa constructor cũ: public LectureCompletions(String id) {}

    // getters & setters (SỬA LẠI KIỂU DỮ LIỆU)
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Users getUserId() { return userId; }
    public void setUserId(Users userId) { this.userId = userId; }

    public Lectures getLectureId() { return lectureId; }
    public void setLectureId(Lectures lectureId) { this.lectureId = lectureId; }

    public Date getCompletedDate() { return completedDate; }
    public void setCompletedDate(Date completedDate) { this.completedDate = completedDate; }

    // Sửa lại .hashCode() và .equals()
    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof LectureCompletions)) {
            return false;
        }
        LectureCompletions other = (LectureCompletions) object;
        return Objects.equals(this.id, other.id);
    }

    @Override
    public String toString() {
        return "model.LectureCompletions[ id=" + id + " ]";
    }
}