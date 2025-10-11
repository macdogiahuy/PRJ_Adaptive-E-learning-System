package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Conversations;
import model.Reactions;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(ChatMessages.class)
public class ChatMessages_ { 

    public static volatile SingularAttribute<ChatMessages, Date> creationTime;
    public static volatile ListAttribute<ChatMessages, Reactions> reactionsList;
    public static volatile SingularAttribute<ChatMessages, Date> lastModificationTime;
    public static volatile SingularAttribute<ChatMessages, Conversations> conversationId;
    public static volatile SingularAttribute<ChatMessages, Users> creatorId;
    public static volatile SingularAttribute<ChatMessages, String> lastModifierId;
    public static volatile SingularAttribute<ChatMessages, String> id;
    public static volatile SingularAttribute<ChatMessages, String> content;
    public static volatile SingularAttribute<ChatMessages, String> status;

}