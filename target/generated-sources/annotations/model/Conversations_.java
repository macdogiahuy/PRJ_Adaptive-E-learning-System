package model;

import jakarta.persistence.metamodel.ListAttribute;
import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import java.util.Date;
import javax.annotation.processing.Generated;
import model.ChatMessages;
import model.ConversationMembers;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-23T16:39:30", comments="EclipseLink-4.0.3.v20240522-rb5bf922d44efed420f3a09bc7fa4b015c369ea2a")
@StaticMetamodel(Conversations.class)
@SuppressWarnings({"rawtypes", "deprecation"})
public class Conversations_ { 

    public static volatile SingularAttribute<Conversations, Date> creationTime;
    public static volatile SingularAttribute<Conversations, String> avatarUrl;
    public static volatile SingularAttribute<Conversations, Users> creatorId;
    public static volatile SingularAttribute<Conversations, String> id;
    public static volatile SingularAttribute<Conversations, Boolean> isPrivate;
    public static volatile SingularAttribute<Conversations, String> title;
    public static volatile ListAttribute<Conversations, ConversationMembers> conversationMembersList;
    public static volatile ListAttribute<Conversations, ChatMessages> chatMessagesList;

}