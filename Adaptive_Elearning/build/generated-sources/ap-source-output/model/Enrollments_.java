package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Bills;
import model.Courses;
import model.EnrollmentsPK;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Enrollments.class)
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