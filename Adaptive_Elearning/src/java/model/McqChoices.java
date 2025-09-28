/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.List;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "McqChoices")
@NamedQueries({
    @NamedQuery(name = "McqChoices.findAll", query = "SELECT m FROM McqChoices m"),
    @NamedQuery(name = "McqChoices.findById", query = "SELECT m FROM McqChoices m WHERE m.id = :id"),
    @NamedQuery(name = "McqChoices.findByContent", query = "SELECT m FROM McqChoices m WHERE m.content = :content"),
    @NamedQuery(name = "McqChoices.findByIsCorrect", query = "SELECT m FROM McqChoices m WHERE m.isCorrect = :isCorrect")})
public class McqChoices implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @Column(name = "Content")
    private String content;
    @Basic(optional = false)
    @Column(name = "IsCorrect")
    private boolean isCorrect;
    @JoinTable(name = "McqUserAnswer", joinColumns = {
        @JoinColumn(name = "MCQChoiceId", referencedColumnName = "Id")}, inverseJoinColumns = {
        @JoinColumn(name = "SubmissionId", referencedColumnName = "Id")})
    @ManyToMany
    private List<Submissions> submissionsList;
    @JoinColumn(name = "McqQuestionId", referencedColumnName = "Id")
    @ManyToOne
    private McqQuestions mcqQuestionId;

    public McqChoices() {
    }

    public McqChoices(String id) {
        this.id = id;
    }

    public McqChoices(String id, String content, boolean isCorrect) {
        this.id = id;
        this.content = content;
        this.isCorrect = isCorrect;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean getIsCorrect() {
        return isCorrect;
    }

    public void setIsCorrect(boolean isCorrect) {
        this.isCorrect = isCorrect;
    }

    public List<Submissions> getSubmissionsList() {
        return submissionsList;
    }

    public void setSubmissionsList(List<Submissions> submissionsList) {
        this.submissionsList = submissionsList;
    }

    public McqQuestions getMcqQuestionId() {
        return mcqQuestionId;
    }

    public void setMcqQuestionId(McqQuestions mcqQuestionId) {
        this.mcqQuestionId = mcqQuestionId;
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
        if (!(object instanceof McqChoices)) {
            return false;
        }
        McqChoices other = (McqChoices) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.McqChoices[ id=" + id + " ]";
    }
    
}
