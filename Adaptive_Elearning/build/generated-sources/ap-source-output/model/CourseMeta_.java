package model;

import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.CourseMetaPK;
import model.Courses;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(CourseMeta.class)
public class CourseMeta_ { 

    public static volatile SingularAttribute<CourseMeta, Courses> courses;
    public static volatile SingularAttribute<CourseMeta, CourseMetaPK> courseMetaPK;
    public static volatile SingularAttribute<CourseMeta, Short> type;
    public static volatile SingularAttribute<CourseMeta, String> value;

}