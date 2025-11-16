/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;

/**
 *
 * @author LP
 */
@Entity
@Table(name = "__EFMigrationsHistory")
@NamedQueries({
    @NamedQuery(name = "EFMigrationsHistory.findAll", query = "SELECT e FROM EFMigrationsHistory e"),
    @NamedQuery(name = "EFMigrationsHistory.findByMigrationId", query = "SELECT e FROM EFMigrationsHistory e WHERE e.migrationId = :migrationId"),
    @NamedQuery(name = "EFMigrationsHistory.findByProductVersion", query = "SELECT e FROM EFMigrationsHistory e WHERE e.productVersion = :productVersion")})
public class EFMigrationsHistory implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "MigrationId")
    private String migrationId;
    @Basic(optional = false)
    @Column(name = "ProductVersion")
    private String productVersion;

    public EFMigrationsHistory() {
    }

    public EFMigrationsHistory(String migrationId) {
        this.migrationId = migrationId;
    }

    public EFMigrationsHistory(String migrationId, String productVersion) {
        this.migrationId = migrationId;
        this.productVersion = productVersion;
    }

    public String getMigrationId() {
        return migrationId;
    }

    public void setMigrationId(String migrationId) {
        this.migrationId = migrationId;
    }

    public String getProductVersion() {
        return productVersion;
    }

    public void setProductVersion(String productVersion) {
        this.productVersion = productVersion;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (migrationId != null ? migrationId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof EFMigrationsHistory)) {
            return false;
        }
        EFMigrationsHistory other = (EFMigrationsHistory) object;
        if ((this.migrationId == null && other.migrationId != null) || (this.migrationId != null && !this.migrationId.equals(other.migrationId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "model.EFMigrationsHistory[ migrationId=" + migrationId + " ]";
    }
    
}
