package model;

import jakarta.persistence.metamodel.ListAttribute;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import java.util.Date;
import javax.annotation.processing.Generated;
import model.Articles;
import model.Assignments;
import model.Bills;
import model.ChatMessages;
import model.Comments;
import model.ConversationMembers;
import model.Conversations;
import model.CourseReviews;
import model.Courses;
import model.Enrollments;
import model.Instructors;
import model.Notifications;
import model.Submissions;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-23T16:39:30", comments="EclipseLink-4.0.3.v20240522-rb5bf922d44efed420f3a09bc7fa4b015c369ea2a")
@StaticMetamodel(Users.class)
@SuppressWarnings({"rawtypes", "deprecation"})
public class Users_ { 

    public static volatile ListAttribute<Users, Comments> commentsList;
    public static volatile SingularAttribute<Users, String> role;
    public static volatile SingularAttribute<Users, Date> creationTime;
    public static volatile SingularAttribute<Users, Boolean> isVerified;
    public static volatile SingularAttribute<Users, Date> lastModificationTime;
    public static volatile SingularAttribute<Users, String> bio;
    public static volatile SingularAttribute<Users, Instructors> instructors;
    public static volatile SingularAttribute<Users, String> password;
    public static volatile ListAttribute<Users, CourseReviews> courseReviewsList;
    public static volatile SingularAttribute<Users, Integer> enrollmentCount;
    public static volatile SingularAttribute<Users, Long> systemBalance;
    public static volatile SingularAttribute<Users, String> id;
    public static volatile SingularAttribute<Users, Short> accessFailedCount;
    public static volatile SingularAttribute<Users, Boolean> isApproved;
    public static volatile ListAttribute<Users, ChatMessages> chatMessagesList;
    public static volatile SingularAttribute<Users, String> email;
    public static volatile SingularAttribute<Users, String> metaFullName;
    public static volatile ListAttribute<Users, Conversations> conversationsList;
    public static volatile ListAttribute<Users, Notifications> notificationsList1;
    public static volatile SingularAttribute<Users, String> preferences;
    public static volatile ListAttribute<Users, Courses> coursesList;
    public static volatile SingularAttribute<Users, String> avatarUrl;
    public static volatile ListAttribute<Users, Assignments> assignmentsList;
    public static volatile SingularAttribute<Users, String> fullName;
    public static volatile SingularAttribute<Users, Date> dateOfBirth;
    public static volatile ListAttribute<Users, Enrollments> enrollmentsList;
    public static volatile SingularAttribute<Users, String> userName;
    public static volatile SingularAttribute<Users, String> loginProvider;
    public static volatile ListAttribute<Users, ConversationMembers> conversationMembersList;
    public static volatile SingularAttribute<Users, String> token;
    public static volatile ListAttribute<Users, Notifications> notificationsList;
    public static volatile SingularAttribute<Users, String> phone;
    public static volatile ListAttribute<Users, Bills> billsList;
    public static volatile ListAttribute<Users, Submissions> submissionsList;
    public static volatile ListAttribute<Users, Articles> articlesList;
    public static volatile SingularAttribute<Users, String> providerKey;
    public static volatile SingularAttribute<Users, String> refreshToken;
    public static volatile SingularAttribute<Users, String> instructorId;

}