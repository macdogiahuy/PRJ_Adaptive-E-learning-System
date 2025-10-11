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
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "McqQuestions")
@NamedQueries({
    @NamedQuery(name = "McqQuestions.findAll", query = "SELECT m FROM McqQuestions m"),
    @NamedQuery(name = "McqQuestions.findById", query = "SELECT m FROM McqQuestions m WHERE m.id = :id"),
    @NamedQuery(name = "McqQuestions.findByContent", query = "SELECT m FROM McqQuestions m WHERE m.content = :content")})
public class McqQuestions implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "Id")
    private String id;
    @Basic(optional = false)
    @Column(name = "Content")
    private String content;
    @OneToMany(mappedBy = "mcqQuestionId")
    private List<McqChoices> mcqChoicesList;
    @JoinColumn(name = "AssignmentId", referencedColumnName = "Id")
    @ManyToOne(optional = false)
    private Assignments assignmentId;

    public McqQuestions() {
    }

    public McqQuestions(String id) {
        this.id = id;
    }

    public McqQuestions(String id, String content) {
        this.id = id;
        this.content = content;
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

    public List<McqChoices> getMcqChoicesList() {
        return mcqChoicesList;
    }

    public void setMcqChoicesList(List<McqChoices> mcqChoicesList) {
        this.mcqChoicesList = mcqChoicesList;
    }

    public Assignments getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(Assignments assignmentId) {
        this.assignmentId = assignmentId;
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
        if (!(object instanceof McqQuestions)) {
            return false;
        }
        McqQuestions other = (McqQuestions) object;
        if ((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.McqQuestions[ id=" + id + " ]";
    }
    
}
