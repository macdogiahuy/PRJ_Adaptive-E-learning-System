package model;

import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import java.util.Date;
import javax.annotation.processing.Generated;
import model.Courses;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-23T16:39:30", comments="EclipseLink-4.0.3.v20240522-rb5bf922d44efed420f3a09bc7fa4b015c369ea2a")
@StaticMetamodel(CourseReviews.class)
@SuppressWarnings({"rawtypes", "deprecation"})
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