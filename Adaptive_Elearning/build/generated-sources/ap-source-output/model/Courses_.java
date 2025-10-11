package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Categories;
import model.CourseMeta;
import model.CourseReviews;
import model.Enrollments;
import model.Instructors;
import model.Sections;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Courses.class)
public class Courses_ { 

    public static volatile SingularAttribute<Courses, Date> creationTime;
    public static volatile SingularAttribute<Courses, Date> lastModificationTime;
    public static volatile SingularAttribute<Courses, Users> creatorId;
    public static volatile SingularAttribute<Courses, String> description;
    public static volatile SingularAttribute<Courses, Double> discount;
    public static volatile SingularAttribute<Courses, Date> discountExpiry;
    public static volatile SingularAttribute<Courses, String> title;
    public static volatile ListAttribute<Courses, CourseReviews> courseReviewsList;
    public static volatile SingularAttribute<Courses, String> outcomes;
    public static volatile SingularAttribute<Courses, Double> price;
    public static volatile SingularAttribute<Courses, String> intro;
    public static volatile SingularAttribute<Courses, String> lastModifierId;
    public static volatile SingularAttribute<Courses, String> id;
    public static volatile SingularAttribute<Courses, String> thumbUrl;
    public static volatile ListAttribute<Courses, Sections> sectionsList;
    public static volatile SingularAttribute<Courses, String> requirements;
    public static volatile SingularAttribute<Courses, Integer> learnerCount;
    public static volatile SingularAttribute<Courses, String> level;
    public static volatile SingularAttribute<Courses, Long> totalRating;
    public static volatile ListAttribute<Courses, CourseMeta> courseMetaList;
    public static volatile ListAttribute<Courses, Enrollments> enrollmentsList;
    public static volatile SingularAttribute<Courses, Integer> ratingCount;
    public static volatile SingularAttribute<Courses, Short> lectureCount;
    public static volatile SingularAttribute<Courses, String> metaTitle;
    public static volatile SingularAttribute<Courses, Categories> leafCategoryId;
    public static volatile SingularAttribute<Courses, String> status;
    public static volatile SingularAttribute<Courses, Instructors> instructorId;

}