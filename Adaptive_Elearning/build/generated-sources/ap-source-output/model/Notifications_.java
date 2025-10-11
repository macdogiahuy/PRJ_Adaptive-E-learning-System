package model;

import java.util.Date;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-12T01:17:23", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Notifications.class)
public class Notifications_ { 

    public static volatile SingularAttribute<Notifications, Users> receiverId;
    public static volatile SingularAttribute<Notifications, Date> creationTime;
    public static volatile SingularAttribute<Notifications, Users> creatorId;
    public static volatile SingularAttribute<Notifications, String> id;
    public static volatile SingularAttribute<Notifications, String> message;
    public static volatile SingularAttribute<Notifications, String> type;
    public static volatile SingularAttribute<Notifications, String> status;

}