package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Articles;
import model.ChatMessages;
import model.Comments;
import model.ReactionsPK;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Reactions.class)
public class Reactions_ { 

    public static volatile SingularAttribute<Reactions, Date> creationTime;
    public static volatile SingularAttribute<Reactions, String> sourceType;
    public static volatile SingularAttribute<Reactions, ReactionsPK> reactionsPK;
    public static volatile SingularAttribute<Reactions, Articles> articleId;
    public static volatile SingularAttribute<Reactions, ChatMessages> chatMessageId;
    public static volatile SingularAttribute<Reactions, Comments> commentId;
    public static volatile SingularAttribute<Reactions, String> content;

}