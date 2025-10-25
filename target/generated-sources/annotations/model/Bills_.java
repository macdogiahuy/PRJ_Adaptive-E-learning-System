package model;

import jakarta.persistence.metamodel.SingularAttribute;
import jakarta.persistence.metamodel.StaticMetamodel;
import java.util.Date;
import javax.annotation.processing.Generated;
import model.Enrollments;
import model.Users;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2025-10-23T16:39:30", comments="EclipseLink-4.0.3.v20240522-rb5bf922d44efed420f3a09bc7fa4b015c369ea2a")
@StaticMetamodel(Bills.class)
@SuppressWarnings({"rawtypes", "deprecation"})
public class Bills_ { 

    public static volatile SingularAttribute<Bills, String> note;
    public static volatile SingularAttribute<Bills, Long> amount;
    public static volatile SingularAttribute<Bills, Date> creationTime;
    public static volatile SingularAttribute<Bills, Boolean> isSuccessful;
    public static volatile SingularAttribute<Bills, Users> creatorId;
    public static volatile SingularAttribute<Bills, String> action;
    public static volatile SingularAttribute<Bills, String> clientTransactionId;
    public static volatile SingularAttribute<Bills, String> id;
    public static volatile SingularAttribute<Bills, String> transactionId;
    public static volatile SingularAttribute<Bills, String> gateway;
    public static volatile SingularAttribute<Bills, String> token;
    public static volatile SingularAttribute<Bills, Enrollments> enrollments;

}