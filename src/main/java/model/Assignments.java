/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
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

/**
 *
 * @author LP
 */
@Entity
@Table(name = "Assignments")
@NamedQueries({
    @NamedQuery(name = "Assignments.findAll", query = "SELECT a FROM Assignments a"),
    @NamedQuery(name = "Assignments.findById", query = "SELECT a FROM Assignments a WHERE a.id = :id"),
    @NamedQuery(name = "Assignments.findByName", query = "SELECT a FROM Assignments a WHERE a.name = :name"),
    @NamedQuery(name = "Assignments.findByDuration", query = "SELECT a FROM Assignments a WHERE a.duration = :duration"),
    @NamedQuery(name = "Assignments.findByQuestionCount", query = "SELECT a FROM Assignments a WHERE a.questionCount = :questionCount"),
    @NamedQuery(name = "Assignments.findByGradeToPass", query = "SELECT a FROM Assignments a WHERE a.gradeToPass = :gradeToPass")})
public class Assignments implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @Column(name = "Name")
    private String name;
    @Basic(optional = false)
    @Column(name = "Duration")
    private int duration;
    @Basic(optional = false)
    @Column(name = "QuestionCount")
    private int questionCount;
    @Basic(optional = false)
    @Column(name = "GradeToPass")
    private double gradeToPass;
    @JoinColumn(name = "SectionId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Sections sectionId;
    @JoinColumn(name = "CreatorId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Users creatorId;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "assignmentId")
    private List<McqQuestions> mcqQuestionsList;
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "assignmentId")
    private List<Submissions> submissionsList;

    public Assignments() {
    }

    public Assignments(String id) {
        this.id = id;
    }

    public Assignments(String id, String name, int duration, int questionCount, double gradeToPass) {
        this.id = id;
        this.name = name;
        this.duration = duration;
        this.questionCount = questionCount;
        this.gradeToPass = gradeToPass;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public int getQuestionCount() {
        return questionCount;
    }

    public void setQuestionCount(int questionCount) {
        this.questionCount = questionCount;
    }

    public double getGradeToPass() {
        return gradeToPass;
    }

    public void setGradeToPass(double gradeToPass) {
        this.gradeToPass = gradeToPass;
    }

    public Sections getSectionId() {
        return sectionId;
    }

    public void setSectionId(Sections sectionId) {
        this.sectionId = sectionId;
    }

    public Users getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(Users creatorId) {
        this.creatorId = creatorId;
    }

    public List<McqQuestions> getMcqQuestionsList() {
        return mcqQuestionsList;
    }

    public void setMcqQuestionsList(List<McqQuestions> mcqQuestionsList) {
        this.mcqQuestionsList = mcqQuestionsList;
    }

    public List<Submissions> getSubmissionsList() {
        return submissionsList;
    }

    public void setSubmissionsList(List<Submissions> submissionsList) {
        this.submissionsList = submissionsList;
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
        if (!(object instanceof Assignments)) {
            return false;
        }
        Assignments other = (Assignments) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.Assignments[ id=" + id + " ]";
    }
    
}
