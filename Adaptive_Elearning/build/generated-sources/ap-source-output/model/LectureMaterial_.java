package model;

import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.LectureMaterialPK;
import model.Lectures;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(LectureMaterial.class)
public class LectureMaterial_ { 

    public static volatile SingularAttribute<LectureMaterial, LectureMaterialPK> lectureMaterialPK;
    public static volatile SingularAttribute<LectureMaterial, Lectures> lectures;
    public static volatile SingularAttribute<LectureMaterial, String> type;
    public static volatile SingularAttribute<LectureMaterial, String> url;

}