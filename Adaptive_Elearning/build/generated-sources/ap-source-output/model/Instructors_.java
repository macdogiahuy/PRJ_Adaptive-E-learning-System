package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Courses;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Instructors.class)
public class Instructors_ { 

    public static volatile ListAttribute<Instructors, Courses> coursesList;
    public static volatile SingularAttribute<Instructors, Date> creationTime;
    public static volatile SingularAttribute<Instructors, Long> balance;
    public static volatile SingularAttribute<Instructors, Short> courseCount;
    public static volatile SingularAttribute<Instructors, Date> lastModificationTime;
    public static volatile SingularAttribute<Instructors, String> intro;
    public static volatile SingularAttribute<Instructors, Users> creatorId;
    public static volatile SingularAttribute<Instructors, String> id;
    public static volatile SingularAttribute<Instructors, String> experience;

}