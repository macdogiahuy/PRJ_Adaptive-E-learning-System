package model;

import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import java.util.Date;
import javax.annotation.processing.Generated;
import model.Bills;
import model.Courses;
import model.EnrollmentsPK;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-23T16:39:30", comments="EclipseLink-4.0.3.v20240522-rb5bf922d44efed420f3a09bc7fa4b015c369ea2a")
@StaticMetamodel(Enrollments.class)
@SuppressWarnings({"rawtypes", "deprecation"})
public class Enrollments_ { 

    public static volatile SingularAttribute<Enrollments, String> assignmentMilestones;
    public static volatile SingularAttribute<Enrollments, Courses> courses;
    public static volatile SingularAttribute<Enrollments, EnrollmentsPK> enrollmentsPK;
    public static volatile SingularAttribute<Enrollments, Date> creationTime;
    public static volatile SingularAttribute<Enrollments, String> sectionMilestones;
    public static volatile SingularAttribute<Enrollments, Bills> billId;
    public static volatile SingularAttribute<Enrollments, String> lectureMilestones;
    public static volatile SingularAttribute<Enrollments, Users> users;
    public static volatile SingularAttribute<Enrollments, String> status;

}