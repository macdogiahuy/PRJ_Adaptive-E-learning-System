package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Articles;
import model.CommentMedia;
import model.Comments;
import model.Lectures;
import model.Reactions;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Comments.class)
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