package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Courses;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(CourseReviews.class)
public class CourseReviews_ { 

    public static volatile SingularAttribute<CourseReviews, Date> creationTime;
    public static volatile SingularAttribute<CourseReviews, Date> lastModificationTime;
    public static volatile SingularAttribute<CourseReviews, Short> rating;
    public static volatile SingularAttribute<CourseReviews, Users> creatorId;
    public static volatile SingularAttribute<CourseReviews, String> lastModifierId;
    public static volatile SingularAttribute<CourseReviews, String> id;
    public static volatile SingularAttribute<CourseReviews, Courses> courseId;
    public static volatile SingularAttribute<CourseReviews, String> content;

}