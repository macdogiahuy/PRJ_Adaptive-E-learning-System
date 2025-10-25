package model;

import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import java.util.Date;
import javax.annotation.processing.Generated;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-23T16:39:30", comments="EclipseLink-4.0.3.v20240522-rb5bf922d44efed420f3a09bc7fa4b015c369ea2a")
@StaticMetamodel(Notifications.class)
@SuppressWarnings({"rawtypes", "deprecation"})
public class Notifications_ { 

    public static volatile SingularAttribute<Notifications, Users> receiverId;
    public static volatile SingularAttribute<Notifications, Date> creationTime;
    public static volatile SingularAttribute<Notifications, Users> creatorId;
    public static volatile SingularAttribute<Notifications, String> id;
    public static volatile SingularAttribute<Notifications, String> message;
    public static volatile SingularAttribute<Notifications, String> type;
    public static volatile SingularAttribute<Notifications, String> status;

}