package model;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.io.Serializable;

/**
 * Đây là Entity ánh xạ (map) tới bảng McqUserAnswer.
 */
@Entity
@Table(name = "McqUserAnswer")
public class McqUserAnswer implements Serializable {

    private static final long serialVersionUID = 1L;
    
    // Sử dụng Khóa chính phức hợp
    @EmbeddedId
    protected McqUserAnswerPK mcqUserAnswerPK;

    // --- Khóa Ngoại (Foreign Keys) ---
    
    @JoinColumn(name = "MCQChoiceId", referencedColumnName = "Id", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private McqChoices mcqChoices; // Liên kết đến Lựa chọn

    @JoinColumn(name = "SubmissionId", referencedColumnName = "Id", insertable = false, updatable = false)
    @ManyToOne(optional = false)
    private Submissions submissions; // Liên kết đến Bài nộp

    // --- Constructors ---
    
    public McqUserAnswer() {
    }

    public McqUserAnswer(McqUserAnswerPK mcqUserAnswerPK) {
        this.mcqUserAnswerPK = mcqUserAnswerPK;
    }

    public McqUserAnswer(String submissionId, String mcqChoiceId) {
        this.mcqUserAnswerPK = new McqUserAnswerPK(submissionId, mcqChoiceId);
    }

    // --- Getters and Setters ---
    
    public McqUserAnswerPK getMcqUserAnswerPK() {
        return mcqUserAnswerPK;
    }

    public void setMcqUserAnswerPK(McqUserAnswerPK mcqUserAnswerPK) {
        this.mcqUserAnswerPK = mcqUserAnswerPK;
    }

    public McqChoices getMcqChoices() {
        return mcqChoices;
    }

    public void setMcqChoices(McqChoices mcqChoices) {
        this.mcqChoices = mcqChoices;
    }

    public Submissions getSubmissions() {
        return submissions;
    }

    public void setSubmissions(Submissions submissions) {
        this.submissions = submissions;
    }

    // (hashCode, equals, toString)
    @Override
    public int hashCode() {
        int hash = 0;
        hash += (mcqUserAnswerPK != null ? mcqUserAnswerPK.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof McqUserAnswer)) {
            return false;
        }
        McqUserAnswer other = (McqUserAnswer) object;
        if ((this.mcqUserAnswerPK == null && other.mcqUserAnswerPK != null) || (this.mcqUserAnswerPK != null && !this.mcqUserAnswerPK.equals(other.mcqUserAnswerPK))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.McqUserAnswer[ mcqUserAnswerPK=" + mcqUserAnswerPK + " ]";
    }
}