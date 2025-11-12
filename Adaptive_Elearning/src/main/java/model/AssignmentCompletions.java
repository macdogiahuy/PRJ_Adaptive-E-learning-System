package model;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.Date;
import java.util.Objects;

@Entity
@Table(
    name = "AssignmentCompletions",
    uniqueConstraints = @UniqueConstraint(columnNames = {"UserId", "AssignmentId"})
)
public class AssignmentCompletions implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Long id; // Dùng Long cho cột IDENTITY

    @JoinColumn(name = "UserId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Users userId;

    @JoinColumn(name = "AssignmentId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Assignments assignmentId;

    @Column(name = "CompletedDate", insertable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date completedDate;

    public AssignmentCompletions() {
        // Constructor rỗng
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Users getUserId() {
        return userId;
    }

    public void setUserId(Users userId) {
        this.userId = userId;
    }

    public Assignments getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(Assignments assignmentId) {
        this.assignmentId = assignmentId;
    }

    public Date getCompletedDate() {
        return completedDate;
    }

    public void setCompletedDate(Date completedDate) {
        this.completedDate = completedDate;
    }

    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof AssignmentCompletions)) {
            return false;
        }
        AssignmentCompletions other = (AssignmentCompletions) object;
        return Objects.equals(this.id, other.id);
    }

    @Override
    public String toString() {
        return "model.AssignmentCompletions[ id=" + id + " ]";
    }
}