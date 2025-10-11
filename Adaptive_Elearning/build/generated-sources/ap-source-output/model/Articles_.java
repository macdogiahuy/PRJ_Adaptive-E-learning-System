package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Comments;
import model.Reactions;
import model.Tag;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Articles.class)
public class Articles_ { 

    public static volatile ListAttribute<Articles, Comments> commentsList;
    public static volatile SingularAttribute<Articles, Date> creationTime;
    public static volatile SingularAttribute<Articles, Date> lastModificationTime;
    public static volatile SingularAttribute<Articles, Users> creatorId;
    public static volatile SingularAttribute<Articles, String> title;
    public static volatile SingularAttribute<Articles, String> content;
    public static volatile SingularAttribute<Articles, Integer> commentCount;
    public static volatile ListAttribute<Articles, Tag> tagList;
    public static volatile SingularAttribute<Articles, Boolean> isCommentDisabled;
    public static volatile ListAttribute<Articles, Reactions> reactionsList;
    public static volatile SingularAttribute<Articles, String> lastModifierId;
    public static volatile SingularAttribute<Articles, String> id;
    public static volatile SingularAttribute<Articles, Integer> viewCount;
    public static volatile SingularAttribute<Articles, String> status;

}