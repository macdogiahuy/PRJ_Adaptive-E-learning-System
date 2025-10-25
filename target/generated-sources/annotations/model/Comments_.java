package model;

import jakarta.persistence.metamodel.ListAttribute;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import java.util.Date;
import javax.annotation.processing.Generated;
import model.Articles;
import model.CommentMedia;
import model.Comments;
import model.Lectures;
import model.Reactions;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-23T16:39:30", comments="EclipseLink-4.0.3.v20240522-rb5bf922d44efed420f3a09bc7fa4b015c369ea2a")
@StaticMetamodel(Comments.class)
@SuppressWarnings({"rawtypes", "deprecation"})
public class Comments_ { 

    public static volatile ListAttribute<Comments, Comments> commentsList;
    public static volatile SingularAttribute<Comments, Date> creationTime;
    public static volatile SingularAttribute<Comments, Date> lastModificationTime;
    public static volatile SingularAttribute<Comments, Articles> articleId;
    public static volatile SingularAttribute<Comments, Users> creatorId;
    public static volatile ListAttribute<Comments, CommentMedia> commentMediaList;
    public static volatile SingularAttribute<Comments, String> content;
    public static volatile SingularAttribute<Comments, Comments> parentId;
    public static volatile SingularAttribute<Comments, Lectures> lectureId;
    public static volatile ListAttribute<Comments, Reactions> reactionsList;
    public static volatile SingularAttribute<Comments, String> sourceType;
    public static volatile SingularAttribute<Comments, String> lastModifierId;
    public static volatile SingularAttribute<Comments, String> id;
    public static volatile SingularAttribute<Comments, String> status;

}