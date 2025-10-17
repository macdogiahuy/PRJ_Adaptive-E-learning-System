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
public class ReactionsPK implements Serializable {

    @Basic(optional = false)
    @Column(name = "CreatorId")
    private String creatorId;
    @Basic(optional = false)
    @Column(name = "SourceEntityId")
    private String sourceEntityId;

    public ReactionsPK() {
    }

    public ReactionsPK(String creatorId, String sourceEntityId) {
        this.creatorId = creatorId;
        this.sourceEntityId = sourceEntityId;
    }

    public String getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(String creatorId) {
        this.creatorId = creatorId;
    }

    public String getSourceEntityId() {
        return sourceEntityId;
    }

    public void setSourceEntityId(String sourceEntityId) {
        this.sourceEntityId = sourceEntityId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (creatorId != null ? creatorId.hashCode() : 0);
        hash += (sourceEntityId != null ? sourceEntityId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof ReactionsPK)) {
            return false;
        }
        ReactionsPK other = (ReactionsPK) object;
        if ((this.creatorId == null && other.creatorId != null) || (this.creatorId != null && !this.creatorId.equals(other.creatorId))) {
            return false;
        }
        if ((this.sourceEntityId == null && other.sourceEntityId != null) || (this.sourceEntityId != null && !this.sourceEntityId.equals(other.sourceEntityId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.ReactionsPK[ creatorId=" + creatorId + ", sourceEntityId=" + sourceEntityId + " ]";
    }
    
}
