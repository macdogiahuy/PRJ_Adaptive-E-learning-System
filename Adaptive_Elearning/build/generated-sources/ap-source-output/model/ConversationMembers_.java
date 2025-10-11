package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.ConversationMembersPK;
import model.Conversations;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(ConversationMembers.class)
public class ConversationMembers_ { 

    public static volatile SingularAttribute<ConversationMembers, ConversationMembersPK> conversationMembersPK;
    public static volatile SingularAttribute<ConversationMembers, Date> creationTime;
    public static volatile SingularAttribute<ConversationMembers, Date> lastVisit;
    public static volatile SingularAttribute<ConversationMembers, Boolean> isAdmin;
    public static volatile SingularAttribute<ConversationMembers, Conversations> conversations;
    public static volatile SingularAttribute<ConversationMembers, Users> users;

}