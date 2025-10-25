package model;

import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import java.util.Date;
import javax.annotation.processing.Generated;
import model.ConversationMembersPK;
import model.Conversations;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-23T16:39:30", comments="EclipseLink-4.0.3.v20240522-rb5bf922d44efed420f3a09bc7fa4b015c369ea2a")
@StaticMetamodel(ConversationMembers.class)
@SuppressWarnings({"rawtypes", "deprecation"})
public class ConversationMembers_ { 

    public static volatile SingularAttribute<ConversationMembers, ConversationMembersPK> conversationMembersPK;
    public static volatile SingularAttribute<ConversationMembers, Date> creationTime;
    public static volatile SingularAttribute<ConversationMembers, Date> lastVisit;
    public static volatile SingularAttribute<ConversationMembers, Boolean> isAdmin;
    public static volatile SingularAttribute<ConversationMembers, Conversations> conversations;
    public static volatile SingularAttribute<ConversationMembers, Users> users;

}