package model;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.validation.constraints.NotNull;
import java.io.Serializable;

/**
 * Đây là Lớp Khóa Chính Phức Hợp (Composite Primary Key)
 * cho bảng McqUserAnswer.
 */
@Embeddable
public class McqUserAnswerPK implements Serializable {

    @Basic(optional = false)
    @NotNull
    @Column(name = "SubmissionId")
    private String submissionId;

    @Basic(optional = false)
    @NotNull
    @Column(name = "MCQChoiceId")
    private String mcqChoiceId;

    // Constructors
    public McqUserAnswerPK() {
    }

    public McqUserAnswerPK(String submissionId, String mcqChoiceId) {
        this.submissionId = submissionId;
        this.mcqChoiceId = mcqChoiceId;
    }

    // Getters and Setters
    public String getSubmissionId() {
        return submissionId;
    }

    public void setSubmissionId(String submissionId) {
        this.submissionId = submissionId;
    }

    public String getMCQChoiceId() {
        return mcqChoiceId;
    }

    public void setMCQChoiceId(String mcqChoiceId) {
        this.mcqChoiceId = mcqChoiceId;
    }

    // (hashCode and equals methods - quan trọng cho Khóa chính)
    @Override
    public int hashCode() {
        int hash = 0;
        hash += (submissionId != null ? submissionId.hashCode() : 0);
        hash += (mcqChoiceId != null ? mcqChoiceId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof McqUserAnswerPK)) {
            return false;
        }
        McqUserAnswerPK other = (McqUserAnswerPK) object;
        if ((this.submissionId == null && other.submissionId != null) || (this.submissionId != null && !this.submissionId.equals(other.submissionId))) {
            return false;
        }
        if ((this.mcqChoiceId == null && other.mcqChoiceId != null) || (this.mcqChoiceId != null && !this.mcqChoiceId.equals(other.mcqChoiceId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.McqUserAnswerPK[ submissionId=" + submissionId + ", mcqChoiceId=" + mcqChoiceId + " ]";
    }
}