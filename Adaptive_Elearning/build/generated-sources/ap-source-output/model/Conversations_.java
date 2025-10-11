package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.ChatMessages;
import model.ConversationMembers;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Conversations.class)
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