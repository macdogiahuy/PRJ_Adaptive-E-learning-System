package model;

import jakarta.persistence.metamodel.ListAttribute;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import java.util.Date;
import javax.annotation.processing.Generated;
import model.Conversations;
import model.Reactions;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-23T16:39:30", comments="EclipseLink-4.0.3.v20240522-rb5bf922d44efed420f3a09bc7fa4b015c369ea2a")
@StaticMetamodel(ChatMessages.class)
@SuppressWarnings({"rawtypes", "deprecation"})
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