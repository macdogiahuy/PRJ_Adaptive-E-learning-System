package model;

import jakarta.persistence.metamodel.ListAttribute;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import java.util.Date;
import javax.annotation.processing.Generated;
import model.Courses;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-23T16:39:30", comments="EclipseLink-4.0.3.v20240522-rb5bf922d44efed420f3a09bc7fa4b015c369ea2a")
@StaticMetamodel(Instructors.class)
@SuppressWarnings({"rawtypes", "deprecation"})
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