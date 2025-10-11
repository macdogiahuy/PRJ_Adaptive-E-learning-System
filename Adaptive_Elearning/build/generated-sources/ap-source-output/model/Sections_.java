package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Assignments;
import model.Courses;
import model.Lectures;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Sections.class)
public class Sections_ { 

    public static volatile SingularAttribute<Sections, Short> lectureCount;
    public static volatile SingularAttribute<Sections, Date> creationTime;
    public static volatile ListAttribute<Sections, Lectures> lecturesList;
    public static volatile SingularAttribute<Sections, Date> lastModificationTime;
    public static volatile ListAttribute<Sections, Assignments> assignmentsList;
    public static volatile SingularAttribute<Sections, Short> index;
    public static volatile SingularAttribute<Sections, String> id;
    public static volatile SingularAttribute<Sections, String> title;
    public static volatile SingularAttribute<Sections, Courses> courseId;

}