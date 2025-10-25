package model;

import jakarta.persistence.metamodel.ListAttribute;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import java.util.Date;
import javax.annotation.processing.Generated;
import model.Comments;
import model.Reactions;
import model.Tag;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-23T16:39:30", comments="EclipseLink-4.0.3.v20240522-rb5bf922d44efed420f3a09bc7fa4b015c369ea2a")
@StaticMetamodel(Articles.class)
@SuppressWarnings({"rawtypes", "deprecation"})
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